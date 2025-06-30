/*RESALE*/

/*Insert resale offers (tickets become available for resale)*/

INSERT INTO resale_offer (ticket_id, status_id)
VALUES (643, (SELECT status_id FROM resale_status WHERE status_name = 'available'));

INSERT INTO resale_offer (ticket_id, status_id)
VALUES (644, (SELECT status_id FROM resale_status WHERE status_name = 'available'));

INSERT INTO resale_offer (ticket_id, status_id)
VALUES (647, (SELECT status_id FROM resale_status WHERE status_name = 'available'));

INSERT INTO resale_offer (ticket_id, status_id)
VALUES (673, (SELECT status_id FROM resale_status WHERE status_name = 'available'));

INSERT INTO resale_offer (ticket_id, status_id)
VALUES (674, (SELECT status_id FROM resale_status WHERE status_name = 'available'));


/*Insert resale requests (buyers request tickets) */


INSERT INTO ticket_resale_request (person_id, event_id, ticket_category_id, specific_ticket_id)
VALUES (90, 39, 3, 643);  /* specific */

INSERT INTO ticket_resale_request (person_id, event_id, ticket_category_id, specific_ticket_id)
VALUES (91, 39, 2, 644);  /* specific */

INSERT INTO ticket_resale_request (person_id, event_id, ticket_category_id, specific_ticket_id)
VALUES (92, 39, 1, NULL); /* general request (event, category) */

INSERT INTO ticket_resale_request (person_id, event_id, ticket_category_id, specific_ticket_id)
VALUES (93, 45, 2, NULL); /* general request (event, category) */

INSERT INTO ticket_resale_request (person_id, event_id, ticket_category_id, specific_ticket_id)
VALUES (94, 39, 1, 647);  /* specific */

INSERT INTO ticket_resale_request (person_id, event_id, ticket_category_id, specific_ticket_id)
VALUES (95, 39, 2, NULL); /* general request (event, category) */

INSERT INTO ticket_resale_request (person_id, event_id, ticket_category_id, specific_ticket_id)
VALUES (96, 45, 2, 673);  /* specific */

INSERT INTO ticket_resale_request (person_id, event_id, ticket_category_id, specific_ticket_id)
VALUES (97, 45, 1, NULL); /* general request (event, category) */

INSERT INTO ticket_resale_request (person_id, event_id, ticket_category_id, specific_ticket_id)
VALUES (98, 39, 3, NULL); /* general request (event, category) */

INSERT INTO ticket_resale_request (person_id, event_id, ticket_category_id, specific_ticket_id)
VALUES (99, 45, 1, 674);  /* specific */


/*these data are the same as those in load file*/


/*implementatioν*/

WITH first_ticket AS (
    SELECT ticket_id, resale_offer_id
    FROM resale_offer
    WHERE status_id = (SELECT status_id FROM resale_status WHERE status_name = 'available')
    ORDER BY offer_date
    LIMIT 1
),

first_request AS (
    SELECT request_id, person_id
    FROM ticket_resale_request, first_ticket
    WHERE fulfilled = FALSE
    AND (
        /*case 1 buyer explicitly requested this spesific ticket*/
        specific_ticket_id = first_ticket.ticket_id

        /*case 2 buyer requested matching event and ticket category*/
        OR (
            specific_ticket_id IS NULL
            AND event_id = (SELECT event_id FROM ticket WHERE ticket_id = first_ticket.ticket_id)
            AND ticket_category_id = (SELECT ticket_category_id FROM ticket WHERE ticket_id = first_ticket.ticket_id)
        )
    )
    ORDER BY request_date
    LIMIT 1
)

/*transaction*/
BEGIN;

/*mark resale offer as sold*/
UPDATE resale_offer
SET status_id = (SELECT status_id FROM resale_status WHERE status_name = 'sold')
WHERE resale_offer_id = (SELECT resale_offer_id FROM first_ticket);

/*mark request as fulfilled*/
UPDATE ticket_resale_request
SET fulfilled = TRUE
WHERE request_id = (SELECT request_id FROM first_request);

/*insert transaction record*/
INSERT INTO resale_transaction (resale_offer_id, request_id, buyer_id)
VALUES (
    (SELECT resale_offer_id FROM first_ticket),
    (SELECT request_id FROM first_request),
    (SELECT person_id FROM first_request)
);

/*update ticket ownership to the new buyer*/
UPDATE ticket
SET person_id = (SELECT person_id FROM first_request)
WHERE ticket_id = (SELECT ticket_id FROM first_ticket);

COMMIT;
