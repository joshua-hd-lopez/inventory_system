       01  INVOICE-RECORD.
      *
           05  INV-KEY.
               10  INV-INVOICE-NUMBER          PIC 9(06).
           05  INV-INVOICE-DATE                PIC X(08).
           05  INV-CUSTOMER-NUMBER             PIC X(06).
           05  INV-PO-NUMBER                   PIC X(10).
           05  INV-LINE-ITEM                   OCCURS 10 TIMES.
               10  INV-PRODUCT-CODE            PIC X(10).
               10  INV-QUANTITY                PIC S9(07).
               10  INV-UNIT-PRICE              PIC S9(07)V99.
               10  INV-AMOUNT                  PIC S9(07)V99.
           05  INV-INVOICE-TOTAL               PIC S9(07)V99.
      *