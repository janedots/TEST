/* V8:ConvertMode=Maintenance                                               */
/* V8:WebEnabled=No                                                         */
/* V8:RunMode=Character,Windows                                             */
/****************************************************************************/
/* xxictrpc.p    : Inventory Transaction CIM Procdedure For HHT & Desktop   */
/* MFG/PRO Ver   : eB2 Sp5  - Character                                     */
/* Description   :                                                          */
/* Called From   :                                                          */
/* Called Program:                                                          */
/* Include Files :                                                          */
/* Included in   :                                                          */
/* Database      : qaddb                                                    */
/* Tables read   :                                                          */
/* Tables updated:                                                          */
/****************************************************************************/
/* CREATED BY    : Girish              DATE: 06/03/07 ECO#:                 */
/* LAST MODIFIED :                     DATE:          ECO#:                 */
/* update BY     : davidw              DATE: 01/10/08                       */
/* update BY     : davidw              DATE: 01/15/08                       */
/* update BY     : jackl               DATE: 07/16/08                       */
/* update BY     : davidw              DATE: 07/22/08                       */
/* update BY     : davidw              DATE: 05/09/08  site = 8             */
/* update BY     : davidw              DATE: 08/09/08  across site          */
/* update BY     : davidw              DATE: 09/09/08  lost reason code     */
/* update BY     : jackl               DATE: 10/09/08                       */
/* update BY     : jackl               DATE: 17/10/08  update domain        */
/* update BY     : jackl               DATE: 20/11/08  update printer rpt   */
/* update BY     : davidw              DATE: 03/22/09  ECO#: 20090320101440 */
/* update BY     : davidw              DATE: 05/08/09  ECO#: 20090504151959 */
/* update BY     : Lina Su             DATE: 06/03/09  ECO#: 20090522130248 */
/* update BY     : Lina Su             DATE: 06/11/09  ECO#: 20090605102535 */
/* update BY     : Lina Su             DATE: 08/19/09  ECO#: 20090819160740 */
/* update BY     : Jack Li             DATE: 09/25/09  ECO#: 20090527133626 */
/* update BY     : Lee  Li             DATE: 11/02/09  ECO#: 20091027123957 */
/* update BY     : Jack Li             DATE: 11/24/09  ECO#: 20091208165908 */
/* update BY     : Lee  Li             DATE: 12/10/09  ECO#: 20091125132413 */
/* update BY     : Jack Li             DATE: 01/02/10  ECO#: 20100102172216 */
/* update BY     : Jack Li             DATE: 01/02/10  ECO#: 20100105155316 */
/* update BY     : Jack Li             DATE: 12/23/09  ECO#: 20091207165510 */
/* update BY     : tao                 DATE: 05/07/10  ECO#: 20100506130549 */
/* update BY     : Lee Li              DATE: 05/24/10  ECO#: 20100414164007 */
/* update BY     : Lee Li              Date: 05/31/10  ECO#: 20100528112030 */
/* Modified By   : Malarkodi(TSL)      Date: 08/30/10  ECO#: MK01           */
/* Modified By   : Malarkodi(TSL)      Date: 09/30/10  ECO#: MK02           */
/* Modified By   : Malarkodi(TSL)      Date: 10/14/10  ECO#: MK03           */
/* Desc          : Allocated Qty calculation is corrected                   */
/* Modified By   : Malarkodi(TSL)      Date: 10/14/10  ECO#: MK04           */
/* Desc          : Included messages as Lot Selected or Not                 */
/* Modified By   : Malarkodi(TSL)      Date: 10/21/10  ECO#: MK05           */
/* Desc          : Fixed Lot  number increment issue for Palletize-lot      */
/* Modified By   : Malarkodi(TSL)  Date : 11/11/10     ECO#: MK06           */
/* Desc          : Fixed Shipper Create Line no. issue                      */
/* Modified by Nilay ECO: Nilay  issue of muliline shipper fixing           */
/* Modified by Maha ECO: maha14112010 to assign std. sheets lenght width    */
/* Modified by Malar ECO: MK22112010 to return if lot is not selected       */
/*                      : Store SO Line no in ld__chr04 of ld_det           */
/*                      : Make GR mandatory if cm_po_reqd flag is set for   */
/*                       that customer                                      */
/*Modified by Malar ECO: MK24112010 to capture Docket number                */
/*Modified by Malar ECO: MK25112020 to get SO Nbr and Line no together      */
/*Modified by Malar ECO: MK01122010 to store SO Line in ld_det for all case */
/****************************************************************************/
/*Modified By: Nilay     Date: 07 Dec 2010                 ECO# ND071110    */
/*Description: Modified to temporarily remove the width validation.         */
/*             Modified to fetch the last tr_hist record for lot validation */
/****************************************************************************/
/*Modified By: Nilay     Date: 09 Dec 2010                 ECO# ND091210    */
/*Description: Resolved the Width Mismatch Issue and lot Allocaiton Issue   */
/****************************************************************************/
/*Modified By: Malar (TSL) Date : 15/12/2010             ECO#: MK15122010   */
/*Description : To Avoid Overshipment issue during Shipment                 */
/****************************************************************************/
/* Modified By   : Jack Li             Date: 01/18/11  ECO#: 20110118163438 */
/* Modified by : Maha(TSL) DAte:22/02/11 ECO#: maha220211 to comment the "T"*/
/* Modified by : sathish(TSL) Date:04/03/11 ECO#:sat040311                  */
/* Desc:to capture sod line from ld__chr04 in Transby-lot procedure         */
/* Modified By   : Jack Li             Date: 03/09/11  ECO#: 20110307095617 */
/* Modified By   : Jack Li             Date: 04/27/11  ECO#: 20110420093443 */
/* Modified By   : Jack Li             Date: 05/12/11  ECO#: 20110512102922 */
/* Modified BY   : Sathish R(TSL)      Date: 05/19/11  Eco#: 20110414093105 */
/*                                                and  Eco#: 20110412165415 */
/* Modified By : Sudha.R     Date: 10Jun'11  ECO#RS001(20110608000036)      */
/* Desc        : Modification done to cal actual trim during shipment       */
/* Modified BY : Sathish R(TSL) Date: 06/14/11 Eco#sat140611(20110621095328)*/
/* Desc        : Modified to fetch lot details based on 9 digit lot number  */
/* update BY   : davidw        DATE: 07/07/2011  ECO#: 20110615121006       */
/* Modified By : Jack Li             Date: 07/13/11  ECO#: 20110608020155   */
/* Modified by : Sathish(TSL)DATE:01/07/11 ECO#:20110704131840              */
/* Desc           : Thai localization changes                               */
/* Modified By : Jack Li             Date: 08/29/11  ECO#: 20110829121243   */
/* Modified By : Jack Li             Date: 11/15/11  ECO#: 20110825144312   */
/* Modified By : Jihui               Date: Dec-02-11 ECO#: 20111202175402   */
/* Modified By : Jason Xu            DATE:10/28/11   ECO#: 20110909113649   */
/* Modified By : Jack Li             DATE: Jan/02/12 ECO#: 20120102153825   */
/* Modified By : Jack Li             DATE: Mar/01/12 ECO#: 20120220104853   */
/* Modified By : Jack Li             DATE: Mar/21/12 ECO#: 20120227144052   */
/* Modified By : david wei           DATE: 04/12/12  ECO#: 20120409142107   */
/* Modified By : Jack Li             DATE: May/11/12 ECO#: 20120427164911   */
/* Modified By : Jack Li             DATE: May/17/12 ECO#: 20120517161745   */
/* Modified By : Jack Li             DATE: May/21/12 ECO#: 20120512230642   */
/* Modified By : Jack Li             DATE: Jun/20/12 ECO#: 20120511113853   */
/* DESCRIPTION : The print DD screen once HHT has confirmed the scan,       */
/*               despite it is pastial shipment                             */
/* Modified By : Jack Li             DATE: Jul/13/12 ECO#: 20120706155109   */
/* Modified By : Jerry Gu            DATE: Aug/06/12 ECO#: 20120726114444   */
/* Modified By : Lina Su             DATE: Aug/15/12 ECO#: 20120815123419   */
/* Modified By : Jack Li             DATE: Oct/22/12 ECO#: 20120613111428   */
/* Modified By : Jack Li             DATE: Oct/22/12 ECO#: 20120710171823   */
/* Modified By : Jason Xu            DATE: Oct/24/12 ECO#: 20120815160723   */
/* DESCRIPTION : Round the qty on SORETURNS-LOT                             */
/* Modified By : Jack Li             DATE: Dec/14/12 ECO#: 20121206143700   */
/* Modified By : Jack Li             DATE: Jan/09/13 ECO#: 20121222144910   */
/* Modified By : david wei          DATE: 01/17/2013 ECO#: 20121227151806   */
/*               add check product line entity and itax site                */
/* Modified By : Jack Li             DATE: Jan/21/13 ECO#: 20130110172731   */
/* Modified By : Jack Li             DATE: Jan/22/13 ECO#: 20130103164942   */
/* Modified By : Jack Li             DATE: Jan/24/13 ECO#: 20130124143111   */
/* Modified By : Lina Su             DATE: Jan/28/13 ECO#: 20120504160107   */
/*            : add lock for patial shippment required by india localization*/
/* Modified By : Jack Li             DATE: Feb/18/13 ECO#: 20130213114418   */
/* Modified By : Jack Li             DATE: Feb/21/13 ECO#: 20130130195514   */
/* Modified By : Lina Su             Date: 03/11/13  ECO#: 20121228113029   */
/*             : Remove RCT-GIT validation for BY-ITEM                      */
/* Modified By : Jack Li             DATE: Mar/12/13 ECO#: 20130224184324   */
/* DESCRIPTION : If disable the tag,allow lot link to another tag           */
/* Modified By : David Wei           DATE: Mar/15/13 ECO#: 20130313151437   */
/* LAST MODIFIED : Jack Li         DATE : 03/15/13  ECO#: 20130313104409   */
/*           Desc: Added new format on the pallet label for Korea          */
/* LAST MODIFIED : Jack Li         DATE : 05/03/13  ECO#: 20130424131717   */
/*           Desc: SO/DO can not delink when lad_det does not exist        */
/* LAST MODIFIED : Jack Li         DATE : 05/23/13  ECO#: 20130320090553   */
/* LAST MODIFIED : Jerry Gu        DATE : Jul-07-13 ECO#: 20130604105119   */
/* modify by   : Lina Su         DATE: 06/24/2013   ECO#: 20130620084204    */
/*               lot number rule changed for AUS                            */
/*               so PALLETIZE-LOTBATCH needs to be changed accordingly      */ 
/*LAST MODIFIED: Jason Xu          DATE: 08/01/2013   ECO#: 20130719115244  */
/*DESC         : save the scrap code into tr_rsn_code                       */
/*LAST MODIFIED: Jack Li           DATE: 08/02/2013   ECO#: 20130528142050  */
/*DESC         : Fix index mess issue                                       */
/*LAST MODIFIED: Jihui             DATE: 08/20/2013   ECO#: 20130802110654  */
/*         DESC: Add a GCM to allow backorder quantity to remain after      */
/*               partial shipment of Distribution Orders.                   */
/*LAST MODIFIED: Jihui             DATE: 09/13/2013   ECO#: 20130902142221  */
/*         DESC: Bug Fix - to keep the consistency with 99.7.5.9            */
/*LAST MODIFIED: Jihui             DATE: 09/16/2013   ECO#: 20130912094300  */
/*         DESC: Bug Fix - Reason Code                                      */
/*LAST MODIFIED: Jack Li           DATE: 10/12/13     ECO#: 20130627135149  */
/*LAST MODIFIED: Lina Su           DATE: 11/25/13     ECO#: 20130916135941  */
/*         DESC:  combine Delivery print 3 to 1  xxdchppc.p only            */
/*         DESC: Bug Fix - check SO line                                    */
/*LAST MODIFIED: Lina Su           DATE: 12/11/13     ECO#: 20131204142955  */
/*         DESC:  When LOT link SO, no need keyin line for China            */
/*LAST MODIFIED: Lina Su           DATE: 12/11/13     ECO#: 20131025113534  */
/*         DESC:  expiry date not assigned for SO return                    */
/*LAST MODIFIED: Jihui             DATE: Jan/09/14    ECO#: 20140108135120  */
/*         DESC: Reason Code bug fix                                        */
/*LAST MODIFIED: Lina Su           DATE: Jan/10/14    ECO#: 20140109091834  */
/*         DESC: Allow SO allocation for HD SO                              */
/*LAST MODIFIED: Lina Su           DATE: Jan/17/14    ECO#: 20140117090338  */
/*         DESC: DO allocation not allowed for canceled DO                  */
/*LAST MODIFIED: Jihui             DATE: Jan/20/14    ECO#: 20140113090940  */
/*         DESC: restore the previous pre-population functionality.         */
/*LAST MODIFIED: Lina Su           DATE: Feb/17/14    ECO#: 20140214084642  */
/*         DESC: If there is no slit pattern, no need to validate Width     */
/*             : 2. For WHDC using EXACTWW, SO line attached without "-",   */
/*             :    So get first 8 character which is SO only               */
/*LAST MODIFIED: Lina Su           DATE: Feb/17/14    ECO#: 20140210152952  */
/*         DESC: 1. Palletise is not allowed for NNN                        */
/*LAST MODIFIED: Lina Su           DATE: Feb/19/14    ECO#: 20131112135125  */
/*         DESC: search for all master rolls. 9 digit and 13 digit          */
/****************************************************************************/

&SCOPED-DEFINE xxictpc_p_01 "All"
&SCOPED-DEFINE xxictpc_p_02 "Cust"
&SCOPED-DEFINE xxictpc_p_03 "DO"
&SCOPED-DEFINE xxictpc_p_04 "Fr Loc"
&SCOPED-DEFINE xxictpc_p_05 "Item"
&SCOPED-DEFINE xxictpc_p_06 "Len"
&SCOPED-DEFINE xxictpc_p_07 "Length"
&SCOPED-DEFINE xxictpc_p_08 "Loc"
&SCOPED-DEFINE xxictpc_p_09 "Lot"
&SCOPED-DEFINE xxictpc_p_10 "Pallet"
&SCOPED-DEFINE xxictpc_p_11 "Qty"
&SCOPED-DEFINE xxictpc_p_12 "Qty OnHand"
&SCOPED-DEFINE xxictpc_p_13 "Rec Loc"
&SCOPED-DEFINE xxictpc_p_14 "Ref"
&SCOPED-DEFINE xxictpc_p_15 "Res"
&SCOPED-DEFINE xxictpc_p_16 "Sit"
&SCOPED-DEFINE xxictpc_p_17 "Site"
&SCOPED-DEFINE xxictpc_p_18 "SiteLoc"
&SCOPED-DEFINE xxictpc_p_19 "SO/DO"
&SCOPED-DEFINE xxictpc_p_20 "Tag"
&SCOPED-DEFINE xxictpc_p_21 "To Loc"
&SCOPED-DEFINE xxictpc_p_22 "Width"
&SCOPED-DEFINE xxictpc_p_23 "SL"
&SCOPED-DEFINE xxictpc_p_24 "PLT"
&SCOPED-DEFINE xxictpc_p_25 "EDT"
&SCOPED-DEFINE xxictpc_p_26 "GR"
&SCOPED-DEFINE xxictpc_p_27 "FROM Lot"          /*jackl**10/09/08*/
&SCOPED-DEFINE xxictpc_p_28 "TO Lot"            /*jackl**10/09/08*/
&SCOPED-DEFINE xxictpc_p_29 "Splice"    /* MK01 */
&SCOPED-DEFINE xxictpc_p_30 "Exp"               /* jerryg ECO#:20120726114444 */

DEFINE  VARIABLE m_socnt AS INT               NO-UNDO. /*linas142955*/
DEFINE  VARIABLE m_chr01_a      LIKE sod__chr01. /*linas42955*/
FUNCTION DUMPLICATE-SOLINE RETURNS INT PRIVATE   (INPUT m_str1 AS CHARACTE, INPUT m_str2 AS CHARACTE ) FORWARD. /*linas42955*/


DEFINE SHARED VARIABLE m_screen LIKE mfc_logical                 NO-UNDO.
DEFINE SHARED VARIABLE m_option AS CHAR                          NO-UNDO.

DEFINE NEW SHARED VARIABLE m_serial AS CHARACTER                 NO-UNDO.
DEFINE NEW SHARED VARIABLE m_sernbr AS CHARACTER                 NO-UNDO.
DEFINE NEW SHARED VARIABLE m_refon  LIKE mfc_logical INITIAL YES NO-UNDO.
DEFINE NEW SHARED VARIABLE m_printer LIKE mfc_logical            NO-UNDO.
DEFINE NEW SHARED VARIABLE xx_cnt_qty like tag_cnt_qty           NO-UNDO.  /*20090522130248 */
DEFINE NEW SHARED VARIABLE m_prttype AS INT NO-UNDO. /*20130313104409*/

DEFINE VARIABLE m_effdate   LIKE tr_effdate INITIAL TODAY        NO-UNDO.
DEFINE VARIABLE m_nbr       LIKE lad_nbr                         NO-UNDO.
DEFINE VARIABLE m_lot       LIKE ld_lot  FORMAT "X(9)"           NO-UNDO.
DEFINE VARIABLE m_syslot    LIKE ld_lot                          NO-UNDO.
DEFINE VARIABLE m_loc       LIKE ld_loc                          NO-UNDO.
DEFINE VARIABLE m_cust      LIKE tr_addr                         NO-UNDO.
DEFINE VARIABLE m_loc1      LIKE ld_loc                          NO-UNDO.
DEFINE VARIABLE m_ref       LIKE ld_ref                          NO-UNDO.
DEFINE VARIABLE m_ref1      LIKE ld_ref                          NO-UNDO.
/*Jack Li ****ECO#:20110420093443****/
DEFINE VARIABLE m_curr      LIKE tr_curr                         NO-UNDO.
DEFINE NEW SHARED VARIABLE m_recid     AS   RECID.
DEFINE VARIABLE m_recid1    AS   RECID.
DEFINE VARIABLE m_error     LIKE mfc_logical.
DEFINE VARIABLE m_trtype    LIKE tr_type.
DEFINE VARIABLE m_yn        LIKE mfc_logical                     NO-UNDO.
DEFINE VARIABLE del-yn      LIKE mfc_logical                     NO-UNDO.
DEFINE VARIABLE m_part      LIKE ld_part                         NO-UNDO.
DEFINE VARIABLE m_site      LIKE ld_site                         NO-UNDO.
DEFINE VARIABLE m_rsite     LIKE ld_site                         NO-UNDO.
DEFINE VARIABLE m_qty       LIKE ld_qty_oh                       NO-UNDO.
DEFINE VARIABLE m_value     LIKE tr_gl_amt                       NO-UNDO.
DEFINE VARIABLE m_apamt     LIKE tr_gl_amt                       NO-UNDO.
DEFINE VARIABLE m_count     AS   INT                             NO-UNDO.
DEFINE VARIABLE m_line      LIKE lad_line                        NO-UNDO.
DEFINE VARIABLE m_dataset   LIKE lad_dataset                     NO-UNDO.
DEFINE VARIABLE m_paltpref  LIKE code_cmmt                       NO-UNDO.
DEFINE VARIABLE m_ofcutpref LIKE code_cmmt                       NO-UNDO.
DEFINE VARIABLE m_claimpref LIKE code_cmmt                       NO-UNDO.
DEFINE VARIABLE m_expdt     LIKE ld_expire                       NO-UNDO.
DEFINE VARIABLE m_mesdesc   LIKE msg_desc   EXTENT 48            NO-UNDO. /* MK01 - Changed Extent  */
DEFINE VARIABLE m_tag       LIKE tag_nbr                         NO-UNDO.
DEFINE VARIABLE m_frsite    LIKE ld_site                         NO-UNDO.
DEFINE VARIABLE m_shipid    LIKE tr_ship_id                      NO-UNDO.
DEFINE VARIABLE m_sonbr     LIKE so_nbr                          NO-UNDO.
DEFINE VARIABLE m_ctry      LIKE txc_ctry_code                   NO-UNDO.
DEFINE VARIABLE m_overshipct AS  DEC                             NO-UNDO.
DEFINE VARIABLE m_shipqty   like ld_qty_oh                       NO-UNDO.
DEFINE VARIABLE m_ordqty    like ld_qty_oh                       NO-UNDO.
DEFINE VARI     m_soum     LIKE sod_um                           NO-UNDO.    /*20090605102535*/
DEFINE VARI     m_um_conv  LIKE sod_um_conv                      NO-UNDO.    /*20090605102535*/

DEFINE VARIABLE m_driver    AS   CHAR     FORMAT "X(10)" COLUMN-LABEL "Driver" NO-UNDO.  /*linas20090210125358*/
DEFINE VARIABLE m_shipfrom  LIKE ABS_SHIPFROM                    NO-UNDO.                /*linas20090210125358*/

   /*jackl --ADD BEGIN* 10/09/08***/
DEFINE VARIABLE m_lot1      LIKE ld_lot  FORMAT "X(9)"           NO-UNDO.
DEFINE VARIABLE m_lot2      LIKE ld_lot  FORMAT "X(9)"           NO-UNDO.
DEFINE VARIABLE m_lot3      LIKE ld_lot                          NO-UNDO. /*linas84204*/
DEFINE VARIABLE m_part1     LIKE ld_part         NO-UNDO.
DEFINE VARIABLE m_int       AS INTEGER           NO-UNDO.
DEFINE VARIABLE m_int1      AS INTEGER           NO-UNDO.
DEFINE VARIABLE m_int2      AS INTEGER           NO-UNDO.
DEFINE VARIABLE ii          AS INTEGER           NO-UNDO.
DEFINE VARIABLE m_err       AS LOGICAL           NO-UNDO.
   /*jackl --ADDED BEGIN* 10/09/08***/
define variable m_totsqumeter   as decimal  . /*tao20100506130549*/
DEFINE VARIABLE n_count         AS INTEGER. /*jackl 20090527133626*/
DEFINE VARIABLE m_pallet        AS LOGICAL. /*jackl ECO#: 20100105155316*/
/**CIM FILE VARIABLES BEGINS**/
DEFINE VARIABLE m_cimfile       AS      CHARACTER                NO-UNDO.
DEFINE VARIABLE m_errfile       AS      CHARACTER                NO-UNDO.
DEFINE VARIABLE m_outfile       AS      CHARACTER                NO-UNDO.
DEFINE VARIABLE m_cimerr        LIKE    mfc_logical              NO-UNDO.
DEFINE VARIABLE m_direc         AS      CHARACTER                NO-UNDO.
DEFINE VARIABLE m_message       LIKE    mfc_char FORMAT "x(76)"  NO-UNDO.
DEFINE VARIABLE errorst         AS LOGICAL                       NO-UNDO.
DEFINE VARIABLE errornum        AS INTEGER                       NO-UNDO.
/*davidw*/ DEFINE VAR m_acrossflag  AS logical                   NO-UNDO.
/*davidw*/ define var m_rsncode like tr_rsn_code no-undo.
/*davidw:1440*/ define var m_return_oldprice like mfc_logical    NO-UNDO.
/*davidw:1440*/ define var m_oldprice like   sod_price           NO-UNDO.
/*davidw:1959*/ define var m_bell like mfc_logical               NO-UNDO.
/*davidw:1806*/ define var m_first_entity like pl__chr01         NO-UNDO.
/*davidw:1806*/ define var m_first_itaxsite like so_site         NO-UNDO.
/*davidw:1806*/ FUNCTION get_sscentity RETURNS CHARACTER PRIVATE
        (INPUT ssc_part AS CHARACTER)  FORWARD.
/*davidw:1806*/ FUNCTION get_itaxsite RETURNS CHARACTER PRIVATE
        (INPUT ssc_site AS CHARACTER, INPUT ssc_part AS CHARACTER) FORWARD.

/*linas60107*/  FUNCTION SHIPPMENT-LOCK RETURNS LOGICAL(INPUT parm1 AS CHAR ) FORWARD.

/**CIM FILE VARIABLES ENDS**/
/*davidw tracking ld__chr01 for link SO */
def var old_ld__chr01 like ld__chr01 no-undo.
def var m_flag LIKE mfc_logical INITIAL No no-undo.

DEFINE VARIABLE m_splice AS INTEGER FORMAT 9 INITIAL 0  NO-UNDO. /* MK01 */
DEFINE VARIABLE m_ver    AS CHAR FORMAT "X" INITIAL '0' NO-UNDO. /* MK01 */
DEFINE VARIABLE m_soline     LIKE sod_line  INITIAL 0   NO-UNDO. /* MK01 */

DEFINE VARIABLE m_trflg AS LOGICAL INIT NO NO-UNDO. /* MK24112010 */
DEFINE VARIABLE m_docno AS CHAR INIT "" NO-UNDO.    /* MK24112010 */

DEFINE VARIABLE m_soln AS CHAR INIT "" NO-UNDO. /* MK25112020 */
/* DEFINE VARIABLE m_sopre AS CHAR INIT "" NO-UNDO./* MK25112020 */ Jack 20120102153825*/
DEFINE VARIABLE m_docprn AS CHAR INIT "" NO-UNDO. /* MK24112010 */
DEFINE VARIABLE m_length1 AS INTEGER FORMAT "99999" NO-UNDO.  /* 20110414093105 */
DEFINE VARIABLE m_domain LIKE wo_domain NO-UNDO.  /* 20110704131840 */
DEFINE VARIABLE m_doc   AS CHARACTER NO-UNDO.     /* 20110704131840 */
DEFINE VARIABLE m_vend_lot LIKE tr_vend_lot NO-UNDO. /*20120220104853*/
DEFINE VARIABLE m_track AS LOGICAL NO-UNDO. /*20120227144052*/
DEFINE VARIABLE m_ii    AS INTEGER   NO-UNDO. /*20120706155109*/
DEFINE VARIABLE m_mail  AS CHARACTER NO-UNDO. /*20120706155109*/
DEFINE VARIABLE m_tmp   AS CHARACTER NO-UNDO. /*20120706155109*/
DEFINE VARIABLE m_fileper AS CHARACTER NO-UNDO. /*20120706155109*/
DEFINE VARIABLE m_opt   AS LOGIC     NO-UNDO. /*20130110172731*/

DEFINE VARIABLE m_epsma AS LOGICAL NO-UNDO.   /* jerryg ECO:105119 */
DEFINE VARIABLE m_maxtrnbr LIKE tr_trnbr.   /*Jack Li*20130528142050*/

DEFINE TEMP-TABLE tt1_det  NO-UNDO
       FIELD tt1_lot      LIKE ld_lot  FORMAT "X(9)"
       FIELD tt1_ref      LIKE ld_ref
       FIELD tt1_ref1     LIKE ld_ref
       FIELD tt1_part     LIKE ld_part
       FIELD tt1_soum     LIKE sod_um               /*20090605102535*/
       FIELD tt1_um_conv  LIKE sod_um_conv          /*20090605102535*/
       FIELD tt1_um       LIKE pt_um
       FIELD tt1_desc     LIKE pt_desc1
       FIELD tt1_site     LIKE ld_site
       FIELD tt1_loc      LIKE ld_loc
       FIELD tt1_loc1     LIKE ld_loc
       FIELD tt1_syslot   LIKE ld_lot
       FIELD tt1_qtyiss   LIKE ld_qty_oh
       FIELD tt1_rsncd    LIKE rsn_code
       FIELD tt1_qtyoh    LIKE ld_qty_oh
       FIELD tt1_nbr      LIKE so_nbr
       FIELD tt1_channel  LIKE so_channel
       FIELD tt1_dataset  LIKE lad_dataset
       FIELD tt1_shipsite LIKE ds_shipsite
       FIELD tt1_recsite  LIKE dss_rec_site
       FIELD tt1_line     LIKE lad_line
       FIELD tt1_qtyopn   LIKE sod_qty_ord
       FIELD tt1_qtyall   LIKE sod_qty_all
       FIELD tt1_cust     LIKE so_cust
       FIELD tt1_shipid   LIKE tr_ship_id
       FIELD tt1_tag      LIKE tag_nbr
       FIELD tt1_tag1     LIKE tag_nbr
       FIELD tt1_value    LIKE tr_gl_amt
       FIELD tt1_sub      LIKE gltr_sub
       FIELD tt1_acct     LIKE gltr_acc   /*Jack Li**20130627135149*/
       FIELD tt1_expdt    LIKE ld_expire
       FIELD tt1_user1    LIKE tag_user1  /*Jack Li**ECO:20120220104853*/
       FIELD tt1_user2    LIKE tag_user2
       FIELD tt1_curr     LIKE tr_curr    /*Jack ECO#:20110420093443*/
       FIELD tt1_flag     AS   LOGICAL
/*davidw:1440*/  FIELD tt1_price    LIKE sod_price
       INDEX tt1_a IS PRIMARY UNIQUE
       tt1_lot tt1_ref1 tt1_ref tt1_part tt1_site
       tt1_loc ASCENDING
       INDEX tt1_tag
       tt1_tag ASCENDING.

DEFINE TEMP-TABLE tt1a_det  NO-UNDO
        FIELD tt1a_lot      LIKE ld_lot  FORMAT "X(9)"
        FIELD tt1a_ref      LIKE ld_ref
        FIELD tt1a_ref1     LIKE ld_ref
        FIELD tt1a_part     LIKE ld_part
        FIELD tt1a_um       LIKE pt_um
        FIELD tt1a_desc     LIKE pt_desc1
        FIELD tt1a_site     LIKE ld_site
        FIELD tt1a_loc      LIKE ld_loc
        FIELD tt1a_loc1     LIKE ld_loc
        FIELD tt1a_syslot   LIKE ld_lot
        FIELD tt1a_qtyiss   LIKE ld_qty_oh
        FIELD tt1a_rsncd    LIKE rsn_code
        FIELD tt1a_qtyoh    LIKE ld_qty_oh
        FIELD tt1a_nbr      LIKE so_nbr
        FIELD tt1a_channel  LIKE so_channel
        FIELD tt1a_dataset  LIKE lad_dataset
        FIELD tt1a_shipsite LIKE ds_shipsite
        FIELD tt1a_recsite  LIKE dss_rec_site
        FIELD tt1a_line     LIKE lad_line
        FIELD tt1a_qtyopn   LIKE sod_qty_ord
        FIELD tt1a_cust     LIKE so_cust
        FIELD tt1a_shipid   LIKE tr_ship_id
        FIELD tt1a_tag      LIKE tag_nbr
        FIELD tt1a_tag1     LIKE tag_nbr
        INDEX tt1a_a IS PRIMARY UNIQUE
        tt1a_lot tt1a_ref1 tt1a_ref tt1a_part tt1a_site
        tt1a_loc ASCENDING
        INDEX tt1a_tag
        tt1a_tag ASCENDING.

DEFINE TEMP-TABLE tt2a_det  NO-UNDO
       FIELD tt2a_ref     LIKE ld_ref
       FIELD tt2a_part    LIKE ld_part
       FIELD tt2a_um      LIKE pt_um
       FIELD tt2a_desc    LIKE pt_desc1
       FIELD tt2a_site    LIKE ld_site
       FIELD tt2a_loc     LIKE ld_loc
       FIELD tt2a_qtyoh   LIKE ld_qty_oh
       FIELD tt2a_nbr     LIKE so_nbr
       FIELD tt2a_dataset LIKE lad_dataset
       FIELD tt2a_line    LIKE lad_line
       FIELD tt2a_qtyopn  LIKE sod_qty_ord
       FIELD tt2a_qtyall  LIKE sod_qty_all
       FIELD tt2a_cust    LIKE so_cust
       FIELD tt2a_recsite LIKE dss_rec_site
       INDEX tt2a_ref IS PRIMARY UNIQUE
       tt2a_ref ASCENDING.

DEFINE TEMP-TABLE tt3_det  NO-UNDO
       FIELD tt3_ref     LIKE ld_ref
       FIELD tt3_site    LIKE ld_site
       FIELD tt3_loc     LIKE ld_loc
       FIELD tt3_depall  LIKE mfc_logical FORMAT "Y/N"
       INDEX tt3_ref     IS PRIMARY UNIQUE
       tt3_ref ASCENDING.

DEFINE TEMP-TABLE tt4_det  NO-UNDO
       FIELD tt4_nbr     LIKE so_nbr
       FIELD tt4_part    LIKE ld_part
       FIELD tt4_qtyord  LIKE sod_qty_ord
       FIELD tt4_qtyall  LIKE sod_qty_all
       FIELD tt4_cust    LIKE so_cust
       FIELD tt4_dataset LIKE lad_dataset
       FIELD tt4_line    LIKE lad_line  INIT 0 /* MK03 */
       INDEX tt4_a IS PRIMARY UNIQUE
       tt4_line                         /* MK03 */
       tt4_nbr tt4_part ASCENDING.

DEFINE TEMP-TABLE tt5_det NO-UNDO
       FIELD tt5_nbr      LIKE so_nbr
       FIELD tt5_cust     LIKE so_cust
       FIELD tt5_dataset  LIKE lad_dataset
       FIELD tt5_shipsite LIKE ds_shipsite
       FIELD tt5_site     LIKE ds_site
       FIELD tt5_recsite  LIKE dss_rec_site
       FIELD tt5_loc      LIKE dsr_loc
       INDEX tt5_nbr     IS PRIMARY UNIQUE
       tt5_nbr ASCENDING.

/**INQUIRIES TEMPORARY TEMP-TABLE BEGINS******/
DEFINE VARIABLE m_width     AS   INT FORMAT ">>>9"        NO-UNDO.
DEFINE VARIABLE m_length    AS   INT FORMAT ">>>>9"       NO-UNDO.

DEFINE TEMP-TABLE ttq1_det  NO-UNDO
       FIELD ttq1_loc     LIKE ld_loc
       FIELD ttq1_date    LIKE ld_date
       FIELD ttq1_lot     LIKE ld_lot
       FIELD ttq1_ref     LIKE ld_ref
       FIELD ttq1_qtyoh   LIKE ld_qty_oh
       INDEX ttq1_a IS PRIMARY UNIQUE
       ttq1_date ttq1_lot ttq1_loc ttq1_ref ASCENDING.

DEFINE TEMP-TABLE ttq2_det  NO-UNDO
       FIELD ttq2_len     AS   CHAR    FORMAT "X(5)"
       FIELD ttq2_date    LIKE ld_date
       FIELD ttq2_loc     LIKE ld_loc
       FIELD ttq2_lot     LIKE ld_lot  FORMAT "X(9)"
       FIELD ttq2_ref     LIKE ld_ref
       FIELD ttq2_qtyoh   LIKE ld_qty_oh
       INDEX ttq2_a IS PRIMARY UNIQUE
       ttq2_len ttq2_date ttq2_loc ttq2_lot ttq2_ref
       ASCENDING
       INDEX ttq2_b IS UNIQUE
       ttq2_date ttq2_lot ttq2_len ttq2_loc ttq2_ref
       ASCENDING.

DEFINE TEMP-TABLE ttq3_det  NO-UNDO
       FIELD ttq3_part    LIKE ld_part
       FIELD ttq3_site    LIKE ld_site
       FIELD ttq3_date    LIKE ld_date
       FIELD ttq3_loc     LIKE ld_loc
       FIELD ttq3_lot     LIKE ld_lot
       FIELD ttq3_qtyoh   LIKE ld_qty_oh
       INDEX ttq3_a IS PRIMARY UNIQUE
       ttq3_part ttq3_site ttq3_date ttq3_loc ttq3_lot
       ASCENDING.

DEFINE TEMP-TABLE ttq4_det  NO-UNDO
       FIELD ttq4_part    LIKE ld_part
       FIELD ttq4_site    LIKE ld_site
       FIELD ttq4_date    LIKE ld_date
       FIELD ttq4_lot     LIKE ld_lot
       FIELD ttq4_ref     LIKE ld_ref
       FIELD ttq4_qtyoh   LIKE ld_qty_oh
       INDEX ttq4_a IS PRIMARY UNIQUE
       ttq4_part ttq4_site ttq4_date ttq4_lot ttq4_ref
       ASCENDING.

/*jackl -ADD BEGIN *20/11/08*/
DEFINE NEW SHARED TEMP-TABLE ttso_det NO-UNDO
       FIELD ttso_nbr     LIKE so_nbr
       FIELD ttso_date    LIKE tr_date
       FIELD ttso_site    LIKE tr_site
       FIELD ttso_part    LIKE tr_part
       FIELD ttso_ref     LIKE ld_ref
       FIELD ttso_lot     LIKE ld_lot
       FIELD ttso_type    AS CHARACTER FORMAT "X(1)"
       FIELD ttso_qty     LIKE tr_qty_loc
       FIELD ttso_docno   AS CHARACTER  /*Jack Li 20120706155109*/
       FIELD ttso_line    LIKE tr_site .  /* 20110909113649 Jason  Added */
DEFINE BUFFER lddet FOR ld_det.
/*jackl -ADDED END *20/11/08*/


/* MK24112010 >> added */
DEFINE NEW SHARED TEMP-TABLE tt_doc NO-UNDO
    FIELD tt_docno AS CHAR
    FIELD tt_cust  LIKE so_cust
    FIELD tt_nbr   LIKE so_nbr    /*Jack Li**ECO:20110608020155*/
    FIELD tt_flag  AS   logical   /*Jack Li 20120706155109*/
    FIELD tt_site  LIKE so_site.
/* << MK24112010 - end */


/*linas 20090210125358 begin */
DEFINE TEMP-TABLE ttdr_det NO-UNDO
      FIELD ttdr_ref      LIKE ld_ref
      FIELD ttdr_driver   LIKE absc_carrier
      FIELD ttdr_shipid   LIKE abs_id
      FIELD ttdr_shipfrom LIKE abs_shipfrom
      INDEX ttdr_ref     IS PRIMARY UNIQUE
      ttdr_ref ASCENDING.

/*linas 20090210125358 end   */

/*Jack Li ***BEGIN ADD****ECO:20110307095617*/
DEFINE VARIABLE m_qtytol   LIKE ld_qty_oh.
DEFINE TEMP-TABLE ttrs_det NO-UNDO
       FIELD ttrs_wid      AS   DEC FORMAT ">>,>>9.99"
       FIELD ttrs_qty      LIKE ld_qty_oh
       FIELD ttrs_qtytol   LIKE ld_qty_oh.
/*Jack Li ***END ADDED****ECO:20110307095617*/

DEFINE TEMP-TABLE ttord_det NO-UNDO
       FIELD ttord_nbr      LIKE so_nbr
       FIELD ttord_line     LIKE sod_line
       FIELD ttord_shpqty   LIKE ld_qty_oh
       FIELD ttord_ordqty   LIKE ld_qty_oh.
 /* Lee Li add 20091125132413 */

 DEFINE TEMP-TABLE tttempso NO-UNDO
      FIELD tttempso_nbr   as char format "x(40)".

/* Lee Li add 20091125132413 */

/* MK01 >> */
DEFINE TEMP-TABLE tts21_det  NO-UNDO
        FIELD tts21_line      LIKE sod_line
        FIELD tts21_srnbr     LIKE sod_line
        FIELD tts21_rolls     AS   INT FORMAT ">>>>>>>9"
        FIELD tts21_width     AS   DEC FORMAT ">>,>>9.99"
        FIELD tts21_length    AS   DEC FORMAT ">>,>>9.99" .

DEFINE TEMP-TABLE tt_ver NO-UNDO
    FIELD tt_sono      AS CHAR
    FIELD tt_vpart     AS CHAR
    FIELD tt_version   AS CHAR.


 DEFINE VARIABLE m__chr01 AS CHAR NO-UNDO.
 DEFINE VARIABLE m_data   AS CHAR EXTENT 8.
 DEFINE VARIABLE m_sernbr1 AS INT INITIAL 0 NO-UNDO.
 DEFINE VARIABLE m_slline  AS INT INITIAL 0 NO-UNDO.
 DEFINE VARIABLE m_slitdet AS CHAR NO-UNDO.

 DEFINE BUFFER tt1_buf FOR tt1_det.

/* << MK01 */
{xxwowott.i "new"}

/**INQUIRIES TEMPORARY TEMP-TABLE ENDS******/


{mfdeclre.i}
{gpglefdf.i}
{glsec.i}
{gplabel.i}

IF SUBSTRING(dtitle,1,1) >= "0" AND SUBSTRING(dtitle,1,1) <= "9" THEN
   dtitle = "{1}" + dtitle.
ELSE
   dtitle = SUBSTRING(dtitle,1,INDEX(dtitle," ")) + "{1}" +
            SUBSTRING(dtitle,INDEX(dtitle," ") + LENGTH("{1}","raw") + 1,78).

IF c-application-mode <> 'WEB-ChUI' THEN
DO:
   IF m_screen THEN
      DISPLAY dtitle FORMAT "x(26)"
              WITH NO-LABELS ROW 1 COLUMN 2
              FRAME dtitle-hht NO-BOX NO-ATTR-SPACE.
   ELSE
      DISPLAY dtitle FORMAT "x(78)"
              WITH NO-LABELS WIDTH 80 ROW 1 COLUMN 2
              FRAME dtitle NO-BOX NO-ATTR-SPACE.
END. /**IF c-application-mode <> 'WEB-ChUI' THEN**/

/*davidw  tracking ld__chr01   */
on assign of ld_det.ld__chr01 old value old_ld__chr01 do:
  if m_flag and ld__chr01 <> old_ld__chr01 then do:
       CREATE usrw_wkfl.
       ASSIGN usrw_domain = global_domain
              usrw_key1   = "xxictrpc"
              usrw_key2   = ld_lot + "." + old_ld__chr01 + "." +
ld__chr01 + "." + string(today) + "." + STRING(TIME,"HH:MM:SS")
              usrw_charfld[1] = ld_site
              usrw_charfld[2] = ld_part
              usrw_charfld[3] = ld_loc
              usrw_charfld[4] = ld_lot
              usrw_charfld[5] = ld_ref
              usrw_charfld[6] = old_ld__chr01
              usrw_charfld[7] = ld__chr01
              usrw_charfld[8] = global_userid
              usrw_charfld[9] = string(time,"HH:MM:SS")
              usrw_charfld[10] = execname
              usrw_datefld[1] = today .
  end.
end.

/* MK24112010 >> */
ON ASSIGN OF tr_hist.tr_type
DO:

    IF m_trflg AND (tr_type = "ISS-SO" ) THEN
    DO:
        FIND FIRST tt_doc WHERE tt_cust = tr_addr
               AND tt_nbr = tr_nbr /*Jack Li**ECO:20110608020155*/
                 AND tt_site = tr_site      NO-ERROR.
        IF AVAIL tt_doc THEN
        DO:
            ASSIGN tr__chr11 = tt_docno
                   tt_flag   = Yes. /*Jack Li 20120706155109*/
        END.
    END.
    IF m_trflg AND (tr_type = "ISS-DO" ) THEN
    DO:
        FIND FIRST tt_doc WHERE tt_cust = ""
               AND tt_nbr = tr_nbr /*Jack Li*ECO:20110608020155*/
               AND tt_site = tr_site  NO-ERROR.
        IF AVAIL tt_doc THEN
        DO:
            ASSIGN tr__chr11 = tt_docno
                   tt_flag   = Yes. /*Jack Li 20120706155109*/
        END.
    END.
    FIND FIRST tt1_det WHERE tt1_syslot = tr_serial NO-LOCK NO-ERROR.
    IF AVAIL tt1_det THEN
    DO:
        ASSIGN tr__chr13 = tt1_line.
    END.
END.
/* << MK24112010 */

ASSIGN  m_cimfile =  m_direc + "xxictr" + STRING(m_option)
                    + SUBSTRING(STRING(TODAY),1,2)
                    + SUBSTRING(STRING(TODAY),4,2)
                    + SUBSTRING(STRING(TODAY),7,2)
                    + STRING(TIME) + ".cim"
         m_errfile = m_direc + "xxictr" + STRING(m_option)
                    + SUBSTRING(STRING(TODAY),1,2)
                    + SUBSTRING(STRING(TODAY),4,2)
                    + SUBSTRING(STRING(TODAY),7,2)
                    + STRING(TIME) + ".err"
         m_outfile = m_direc + "xxictr" + STRING(m_option)
                    + SUBSTRING(STRING(TODAY),1,2)
                    + SUBSTRING(STRING(TODAY),4,2)
                    + SUBSTRING(STRING(TODAY),7,2)
                    + STRING(TIME) + ".out".


FOR FIRST icc_ctrl
    FIELDS(icc_iss_days)
    WHERE icc_domain = GLOBAL_domain NO-LOCK :
END. /**FOR FIRST icc_ctrl**/
IF NOT AVAIL icc_ctrl THEN
   NEXT.

FOR FIRST txc_ctrl
    FIELDS(txc_ctry_code)
    WHERE txc_domain = GLOBAL_domain NO-LOCK :
    m_ctry = txc_ctry_code.
END. /**FOR FIRST icc_ctrl**/

FOR FIRST code_mstr FIELDS(code_cmmt)
     WHERE code_domain  = GLOBAL_domain
       AND code_fldname = "xx_path"
       AND code_value   = "CIM" NO-LOCK:
END. /**FOR FIRST code_mstr**/
IF AVAIL CODE_mstr THEN
   m_direc = CODE_cmmt.

/*davidw:1440  begins*/
 m_return_oldprice = no.
 FOR FIRST code_mstr WHERE code_domain  = GLOBAL_domain
    AND code_fldname = "xx_return_oldprice" NO-LOCK:
 END. /**FOR FIRST code_mstr**/
 IF AVAIL CODE_mstr THEN
    m_return_oldprice = Yes.
/*davidw:1440  end*/

/*davidw:1959  begins*/
 m_bell = no.
 FOR FIRST code_mstr WHERE code_domain  = GLOBAL_domain
    AND code_fldname = "xx_bell" NO-LOCK:
 END. /**FOR FIRST code_mstr**/
 IF AVAIL CODE_mstr THEN
    m_bell = Yes.
/*davidw:1959  end*/

/*dvaidw tracking delink order */
FOR FIRST CODE_mstr FIELDS(code_cmmt)
    WHERE CODE_domain  = GLOBAL_domain
      AND CODE_fldname = "xx_delink_order"
      AND CODE_value   = "flag" NO-LOCK:
END. /**FOR FIRST CODE_mstr**/
IF AVAIL CODE_mstr THEN
  m_flag =  (substring(code_cmmt,1,1) = "Y") NO-ERROR.

FOR FIRST code_mstr
    FIELDS(code_cmmt)
    WHERE CODE_domain  = GLOBAL_domain
      AND CODE_fldname = "XX_WO_RECEIPTS"
      AND CODE_value   = "NRMSeq_OFFCUT" NO-LOCK:
END. /**FOR FIRST code_mstr**/
IF AVAIL CODE_mstr THEN
DO:
  FOR FIRST nr_mstr
      FIELDS(nr_seg_value)
      WHERE nr_domain = GLOBAL_domain
        AND nr_seqid  = CODE_cmmt  NO-LOCK:
  END. /**FOR FIRST nr_mstr**/
  IF AVAIL nr_mstr THEN
     m_ofcutpref = TRIM(ENTRY(1 , nr_seg_value)).
END. /**IF AVAIL CODE_mstr THEN**/

FOR FIRST code_mstr
    FIELDS(code_cmmt)
    WHERE CODE_domain  = GLOBAL_domain
      AND CODE_fldname = "XX_PALLET_REF"
      AND CODE_value   = "NRMSeq" NO-LOCK:
END. /**FOR FIRST code_mstr**/
IF AVAIL CODE_mstr THEN
DO:
FOR FIRST nr_mstr
    FIELDS(nr_seg_value)
    WHERE nr_domain = GLOBAL_domain
      AND nr_seqid  = CODE_cmmt  NO-LOCK:
END. /**FOR FIRST nr_mstr**/
IF AVAIL nr_mstr THEN
   m_paltpref = TRIM(ENTRY(1 , nr_seg_value)).
END. /**IF AVAIL CODE_mstr THEN**/

FOR FIRST CODE_mstr
    FIELDS(code_cmmt)
     WHERE CODE_domain  = GLOBAL_domain
       AND CODE_fldname = "XX_CLAIM"
       AND CODE_value   = "PREFIX" NO-LOCK:
END. /**FOR FIRST CODE_mstr**/
IF AVAIL CODE_mstr THEN
   m_claimpref =  CODE_cmmt.

FOR FIRST CODE_mstr
    FIELDS(code_cmmt)
     WHERE CODE_domain  = GLOBAL_domain
       AND CODE_fldname = "xx_so_overshipment"
       AND CODE_value   = "LIMIT_PCT" NO-LOCK:
END. /**FOR FIRST CODE_mstr**/
IF AVAIL CODE_mstr THEN
   m_overshipct =  DECIMAL(CODE_cmmt) NO-ERROR.

IF m_overshipct = ? THEN
   m_overshipct = 0.
/************Sathish added begins*****20110704131840************************/
FIND FIRST code_mstr NO-LOCK
             WHERE code_domain = global_domain
               AND code_fldname = "xx_thailoc_domain"
               AND CODE_VALUE   = "thai_domain" NO-ERROR .
IF AVAILABLE code_mstr THEN m_domain = trim(code_cmmt).
/************Sathish added ends*****20110704131840************************/

/****Jack Li*****ADD BEGIN****ECO:20120227144052****/
m_track = No.
FIND FIRST code_mstr NO-LOCK
     WHERE code_domain = global_domain
       AND code_fldname = "xx_dock_tracking"
       AND CODE_VALUE   = ""
       AND code_cmmt = "Yes" NO-ERROR .
IF AVAILABLE code_mstr THEN m_track = Yes.
/****Jack Li*****ADDED END****ECO:20120227144052****/

/* jerryg add start ECO:105119 */
FOR FIRST code_mstr WHERE code_domain  = GLOBAL_domain
     AND code_fldname = "xx_epsma_pallet" NO-LOCK:
END. /**FOR FIRST code_mstr**/
m_epsma = IF avail code_mstr THEN yes ELSE no .
/* jerryg add end   ECO:105119 */


{pxmsg.i &MSGNUM    =9200   /**Error: Invalid Item**/
         &ERRORLEVEL=4
         &MSGBUFFER =m_mesdesc[1]}

{pxmsg.i &MSGNUM    =9201   /**Error: Invalid Location**/
         &ERRORLEVEL=4
         &MSGBUFFER =m_mesdesc[2]}

{pxmsg.i &MSGNUM    =9202   /**Error: Invalid Lot**/
         &ERRORLEVEL=4
         &MSGBUFFER =m_mesdesc[3]}

{pxmsg.i &MSGNUM    =9203   /**Error: Invalid Order Number**/
         &ERRORLEVEL=4
         &MSGBUFFER =m_mesdesc[4]}

{pxmsg.i &MSGNUM    =9204   /**Error: Invalid Pallet**/
         &ERRORLEVEL=4
         &MSGBUFFER =m_mesdesc[5]}

{pxmsg.i &MSGNUM    =9205   /**Error: Invalid Qty**/
         &ERRORLEVEL=4
         &MSGBUFFER =m_mesdesc[6]}

{pxmsg.i &MSGNUM    =9206   /**Error: Invalid Reason Code**/
         &ERRORLEVEL=4
         &MSGBUFFER =m_mesdesc[7]}

{pxmsg.i &MSGNUM    =9207   /**Error: Invalid Selection**/
         &ERRORLEVEL=4
         &MSGBUFFER =m_mesdesc[8]}

{pxmsg.i &MSGNUM    =9208   /**Error: Invalid Site**/
         &ERRORLEVEL=4
         &MSGBUFFER =m_mesdesc[9]}

{pxmsg.i &MSGNUM    =9209   /**Error: Invalid Tag Number**/
         &ERRORLEVEL=4
         &MSGBUFFER =m_mesdesc[10]}

{pxmsg.i &MSGNUM    =9210   /**Error: Lot Exits For Oh Item**/
         &ERRORLEVEL=4
         &MSGBUFFER =m_mesdesc[11]}

{pxmsg.i &MSGNUM    =9211   /**Error: Lot Not Linked To Ord**/
         &ERRORLEVEL=4
         &MSGBUFFER =m_mesdesc[12]}

{pxmsg.i &MSGNUM    =9212   /**Error: Lot Has Expired**/
         &ERRORLEVEL=4
         &MSGBUFFER =m_mesdesc[13]}

{pxmsg.i &MSGNUM    =9213   /**Error: No Selection**/
         &ERRORLEVEL=4
         &MSGBUFFER =m_mesdesc[14]}

{pxmsg.i &MSGNUM    =9214   /**Error: Onhand Zero**/
         &ERRORLEVEL=4
         &MSGBUFFER =m_mesdesc[15]}

{pxmsg.i &MSGNUM    =9215   /**Error: Qty > OnHand**/
         &ERRORLEVEL=4
         &MSGBUFFER =m_mesdesc[16]}

{pxmsg.i &MSGNUM    =9216   /**Error: Site Security**/
         &ERRORLEVEL=4
         &MSGBUFFER =m_mesdesc[17]}

{pxmsg.i &MSGNUM    =9217   /**Error: GL Period Is Closed**/
         &ERRORLEVEL=4
         &MSGBUFFER =m_mesdesc[18]}

{pxmsg.i &MSGNUM    =9218   /**Error: Invalid Sales Order**/
         &ERRORLEVEL=4
         &MSGBUFFER =m_mesdesc[19]}

{pxmsg.i &MSGNUM    =9219   /**Error: Invalid SO/DO**/
         &ERRORLEVEL=4
         &MSGBUFFER =m_mesdesc[20]}

{pxmsg.i &MSGNUM    =9220   /**Lot is linked to a Pallet**/
         &ERRORLEVEL=1
         &MSGBUFFER =m_mesdesc[21]}

{pxmsg.i &MSGNUM    =9201   /**Invalid Location**/
         &ERRORLEVEL=1
         &MSGBUFFER =m_mesdesc[22]}

{pxmsg.i &MSGNUM    =9221   /**Confirm Pallet Creation**/
         &ERRORLEVEL=1
         &MSGBUFFER =m_mesdesc[23]}

{pxmsg.i &MSGNUM    =9222   /**Shipper:**/
         &ERRORLEVEL=1
         &MSGBUFFER =m_mesdesc[24]}

{pxmsg.i &MSGNUM    =9223   /**Error: Invalid Entry**/
         &ERRORLEVEL=4
         &MSGBUFFER =m_mesdesc[25]}

{pxmsg.i &MSGNUM    =9224   /**Error: Invalid DO**/
         &ERRORLEVEL=4
         &MSGBUFFER =m_mesdesc[26]}

{pxmsg.i &MSGNUM    =9225   /**Error: Invalid Customer**/
         &ERRORLEVEL=4
         &MSGBUFFER =m_mesdesc[27]}

{pxmsg.i &MSGNUM    =9226   /**Error: EMT SO Not Allowed**/
         &ERRORLEVEL=4
         &MSGBUFFER =m_mesdesc[28]}

{pxmsg.i &MSGNUM    =9227   /**Error: Adj Amount > Allowed**/
         &ERRORLEVEL=4
         &MSGBUFFER =m_mesdesc[29]}

{pxmsg.i &MSGNUM    =9234   /**Error: Lot Linked To Ord**/
         &ERRORLEVEL=4
         &MSGBUFFER =m_mesdesc[30]}

{pxmsg.i &MSGNUM    =9229   /**Error: Qty <> Onhand**/
         &ERRORLEVEL=4
         &MSGBUFFER =m_mesdesc[31]}

{pxmsg.i &MSGNUM    =9230   /**Error: LOT Site <> Shpr Site**/
         &ERRORLEVEL=4
         &MSGBUFFER =m_mesdesc[32]}

{pxmsg.i &MSGNUM    =9231   /**Error: LOT Already Linked**/
         &ERRORLEVEL=4
         &MSGBUFFER =m_mesdesc[33]}

{pxmsg.i &MSGNUM    =9232   /**Error: LOT Not Linked**/
         &ERRORLEVEL=4
         &MSGBUFFER =m_mesdesc[34]}

{pxmsg.i &MSGNUM    =9233   /**Error: LOT Linked To Shipper**/
         &ERRORLEVEL=4
         &MSGBUFFER =m_mesdesc[35]}

{pxmsg.i &MSGNUM    =9235   /**Error: Shipper ID Locked**/
         &ERRORLEVEL=4
         &MSGBUFFER =m_mesdesc[36]}

{pxmsg.i &MSGNUM    =9236   /**Error: Use Shipper Option**/
         &ERRORLEVEL=4
         &MSGBUFFER =m_mesdesc[37]}

{pxmsg.i &MSGNUM    =9237   /**Error: Lot Ord <> Pallet**/
         &ERRORLEVEL=4
         &MSGBUFFER =m_mesdesc[38]}

{pxmsg.i &MSGNUM    =9239   /**Error: Check Order Customer**/
         &ERRORLEVEL=4
         &MSGBUFFER =m_mesdesc[39]}

{pxmsg.i &MSGNUM    =9246   /**Error: Alloc >  Tolerance**/
         &ERRORLEVEL=4
         &MSGBUFFER =m_mesdesc[40]}

{pxmsg.i &MSGNUM    =9251   /**Error: SO Reason Code Blank**/
         &ERRORLEVEL=4
         &MSGBUFFER =m_mesdesc[41]}
{pxmsg.i &MSGNUM    =26066   /**ERROR: Quarantined Material**/
         &ERRORLEVEL=4
         &MSGBUFFER =m_mesdesc[42]}


{pxmsg.i &MSGNUM    =26077   /** Lot Selected **/
         &ERRORLEVEL=1
         &MSGBUFFER =m_mesdesc[43]}

{pxmsg.i &MSGNUM    =26078   /** ERROR:Lot not Selected **/
         &ERRORLEVEL=4
         &MSGBUFFER =m_mesdesc[44]}

{pxmsg.i &MSGNUM    =26079   /** GR is mandatory for this customer **/
         &ERRORLEVEL=4
         &MSGBUFFER =m_mesdesc[45]}

{pxmsg.i &MSGNUM    =26080   /** Lot Version differd with already linked orders **/
         &ERRORLEVEL=4
         &MSGBUFFER =m_mesdesc[46]}

{pxmsg.i &MSGNUM    =26081   /** Invalid Lot - Width mismatch **/
         &ERRORLEVEL=4
         &MSGBUFFER =m_mesdesc[47]}

{pxmsg.i &MSGNUM    =26082   /** Length is different **/
         &ERRORLEVEL=2
         &MSGBUFFER =m_mesdesc[48]}

/***Jihui Added Begin 20130802110654***/
FIND FIRST code_mstr WHERE code_domain = GLOBAL_DOMAIN
                       AND code_fldname = "xx_DO_backorder_remain"
                       NO-LOCK NO-ERROR.
IF NOT AVAIL code_mstr THEN DO:
/***Jihui Added End   20130802110654***/
ON ASSIGN  OF ds_det.ds_qty_chg DO:

  IF NOT CAN-FIND(FIRST lad_det NO-LOCK
                  WHERE lad_domain  = ds_det.ds_domain
                    AND lad_dataset = "ds_det"
                    AND lad_nbr     = ds_det.ds_req_nbr
                    AND lad_line    = ds_det.ds_site
                    AND lad_qty_all <> 0 ) THEN

  DO:
      FOR FIRST dsr_mstr
          FIELDS(dsr_loc)
          WHERE dsr_mstr.dsr_domain   = GLOBAL_domain
            AND dsr_mstr.dsr_req_nbr  = ds_det.ds_req_nbr
            AND dsr_mstr.dsr_site     = ds_det.ds_site NO-LOCK:
      END. /**FOR FIRST dsr_mstr**/
      IF AVAIL dsr_mstr THEN
      DO:
       IF (dsr_loc <> "" AND
          NOT CAN-FIND(FIRST cm_mstr NO-LOCK
                       WHERE cm_mstr.cm_domain = GLOBAL_domain
                         AND cm_mstr.cm_addr   = dsr_loc
                         AND cm_mstr.cm_partial )) OR dsr_loc = ""
          OR NOT CAN-FIND(FIRST cm_mstr NO-LOCK
                          WHERE cm_mstr.cm_domain = GLOBAL_domain
                            AND cm_mstr.cm_addr   = dsr_loc ) THEN
       DO:
           ds_det.ds_qty_conf = ds_det.ds_qty_ship + ds_det.ds_qty_chg.

           FOR FIRST dsd_det
               FIELDS(dsd_qty_conf)
               WHERE dsd_det.dsd_domain   = GLOBAL_domain
                 AND dsd_det.dsd_req_nbr  = ds_det.ds_req_nbr
                 AND dsd_det.dsd_site     = ds_det.ds_site
                 AND dsd_det.dsd_shipsite = ds_det.ds_shipsite EXCLUSIVE-LOCK :
           END. /**FOR FIRST dsd_det**/
           IF AVAIL dsd_det THEN
              dsd_det.dsd_qty_conf = ds_det.ds_qty_conf.

           FOR FIRST mrp_det
               FIELDS(mrp_qty)
               WHERE mrp_det.mrp_domain    = GLOBAL_domain
                 AND mrp_det.mrp_dataset   = "dsd_det"
                 AND mrp_det.mrp_part      = ds_det.ds_part
                 AND mrp_det.mrp_nbr       = ds_det.ds_req_nbr
                 AND mrp_det.mrp_line      = ds_det.ds_site
                 AND mrp_det.mrp_line2     = ds_det.ds_shipsite
                 EXCLUSIVE-LOCK :
           END. /**FOR FIRST mrp_det**/
           IF AVAIL mrp_det THEN
              mrp_det.mrp_qty = ds_det.ds_qty_conf.

       END. /**IF (dsr_loc <> "" AND **/

      END. /**IF AVAIL dsr_mstr THEN**/

  END. /**IF NOT CAN-FIND(FIRST lad_det NO-LOCK**/

END. /**ON ASSIGN OF ds_det.ds_qty_chg DO:**/
END. /*IF NOT AVAIL code_mstr THEN 20130802110654*/

IF NOT m_option BEGINS "SODOSHIP" THEN
DO:
    ON DELETE OF ld_det DO:

       FIND FIRST lad_det
            WHERE lad_domain  = global_domain
              AND lad_site    = ld_det.ld_site
              AND lad_loc     = ld_det.ld_loc
              AND lad_part    = ld_det.ld_part
              AND lad_lot     = ld_det.ld_lot
              AND lad_ref     = ld_det.ld_ref EXCLUSIVE-LOCK NO-ERROR.
       IF AVAIL lad_det THEN
          ASSIGN lad_qty_all  = 0
                      lad_qty_pick = 0
                      lad_qty_chg  = 0.
    END.  /**ON DELETE OF po_mstr:**/
END. /**IF m_option BEGINS "CYC" OR m_option BEGINS "PHY" THEN**/

RUN VALUE(m_option).

PROCEDURE USERID-DISPLAY:
    FORM
        GLOBAL_userid COLON 10 LABEL "Userid"
        SKIP
        GLOBAL_domain COLON 10 LABEL "Domain"
        WITH FRAME a1h SIDE-LABEL.

    DISP GLOBAL_userid
         GLOBAL_domain
         WITH FRAME a1h.
    PAUSE.

END. /**PROCEDURE USERID-DISPLAY:**/

PROCEDURE INQUIRY-BYITEM:
    FORM
        m_part  COLON 5 LABEL {&xxictpc_p_05}
        VALIDATE(CAN-FIND(FIRST pt_mstr NO-LOCK
                          WHERE pt_domain = GLOBAL_domain
                            AND pt_part   = INPUT FRAME a1h m_part ) ,
                 m_mesdesc[1])
        pt_um      NO-LABEL
        m_site  COLON 8 LABEL {&xxictpc_p_18}
        VALIDATE(CAN-FIND(FIRST si_mstr NO-LOCK
                          WHERE si_domain = GLOBAL_domain
                            AND si_site   = INPUT FRAME a1h m_site ) ,
                 m_mesdesc[9])
        ttq1_loc   NO-LABEL
        SKIP
        pt_desc1   NO-LABEL
        ttq1_lot   COLON 5 LABEL {&xxictpc_p_09}
        ttq1_ref   COLON 5 LABEL {&xxictpc_p_14}
        ttq1_qtyoh COLON 5 LABEL {&xxictpc_p_11}
        WITH FRAME a1h SIDE-LABEL.

    mainloop:
    REPEAT:
       CLEAR FRAME a1h ALL NO-PAUSE.
       UPDATE m_part m_site WITH FRAME a1h.

       EMPTY TEMP-TABLE ttq1_det.

       FOR EACH ld_det
           FIELDS(ld_status ld_loc ld_lot ld_ref ld_date ld_qty_oh ld_qty_all
                  ld__chr01 )
           WHERE ld_domain = GLOBAL_domain
             AND ld_part   = m_part
             AND ld_site   = m_site
/*           AND LENGTH(ld_lot) <= 9 NO-LOCK:    linas35125*/
             AND LENGTH(ld_lot) <= 13  NO-LOCK: /*linas35125*/
          IF ld_qty_oh - ld_qty_all <= 0 OR TRUNCATE(ld_qty_oh , 3) = 0
          THEN NEXT.

          IF CAN-FIND(FIRST IS_mstr NO-LOCK
                      WHERE IS_domain  = GLOBAL_domain
                        AND IS_status  = ld_status
                        AND is_avail   = NO )  THEN NEXT.

          FIND FIRST ttq1_det
               WHERE ttq1_loc  = ld_loc
                 AND ttq1_lot  = ld_lot
                 AND ttq1_ref  = ld_ref NO-ERROR.
          IF NOT AVAIL ttq1_det THEN
          DO:
             CREATE ttq1_det.
             ASSIGN ttq1_loc  = ld_loc
                    ttq1_lot  = ld_lot
                    ttq1_date = ld_date
                    ttq1_ref  = ld_ref.
          END. /**IF NOT AVAIL ttq1_det THEN**/
          ttq1_qtyoh = ttq1_qtyoh + (ld_qty_oh - ld_qty_all).
          {xxqtylim.i ttq1_qtyoh}

       END. /**EACH ld_det **/

       FOR FIRST pt_mstr
           FIELDS(pt_um pt_desc1)
           WHERE pt_domain = GLOBAL_domain
            AND pt_part   = m_part NO-LOCK:
       END. /**FOR FIRST pt_mstr**/
       IF AVAIL pt_mstr THEN
          DISP pt_um pt_desc1
               WITH FRAME a1h.

       PROMPT-FOR ttq1_lot
           WITH FRAME a1h EDITING:
           {mfnp01.i ttq1_det ttq1_lot ttq1_lot ttq1_lot ttq1_lot ttq1_a}
            IF recno <> ? THEN
               DISP ttq1_loc ttq1_lot ttq1_ref ttq1_qtyoh
                    WITH FRAME a1h.
       END. /**PROMPT-FOR tt12_lot**/
       m_lot = INPUT FRAME a1h ttq1_lot.

    END. /**END OF REPEAT**/
END. /**PROCEDURE INQUIRY-BYITEM:**/

PROCEDURE INQUIRY-BYITEMWIDTH:
    FORM
        m_part  COLON 5 LABEL {&xxictpc_p_05}
        VALIDATE(CAN-FIND(FIRST pt_mstr NO-LOCK
                          WHERE pt_domain = GLOBAL_domain
                            AND pt_part   = INPUT FRAME a1h m_part ) ,
                 m_mesdesc[1])
        pt_um      NO-LABEL
        m_site  COLON 5 LABEL {&xxictpc_p_17}
        VALIDATE(CAN-FIND(FIRST si_mstr NO-LOCK
                          WHERE si_domain = GLOBAL_domain
                            AND si_site   = INPUT FRAME a1h m_site ) ,
                 m_mesdesc[9])
        m_width   LABEL {&xxictpc_p_22}
        SKIP
        pt_desc1   NO-LABEL
        SPACE(4)
        ttq2_date  COLON 4 LABEL {&xxictpc_p_25}
        ttq2_lot   LABEL {&xxictpc_p_09}
        ttq2_loc   COLON 4 LABEL {&xxictpc_p_08}
        ttq2_ref   LABEL {&xxictpc_p_14}
        ttq2_len   COLON 4 LABEL {&xxictpc_p_06}
        ttq2_qtyoh LABEL {&xxictpc_p_11}
        WITH FRAME a1h SIDE-LABEL.

    mainloop:
    REPEAT:
       CLEAR FRAME a1h ALL NO-PAUSE.
       UPDATE m_part m_site m_width WITH FRAME a1h.

       EMPTY TEMP-TABLE ttq2_det.

       IF m_width <> 0 THEN
       DO:
           FOR EACH ld_det
               FIELDS(ld_loc ld_status ld_lot ld_ref ld_date ld_qty_oh
                      ld_qty_all ld_expire ld__chr01)
               WHERE ld_domain = GLOBAL_domain
                 AND ld_part   = m_part
                 AND ld_site   = m_site
                 AND SUBSTRING(ld_lot , 10 , 4 ) = STRING(m_width , "9999")
                 AND LENGTH(ld_lot) > 9 NO-LOCK:
               IF ld_qty_oh - ld_qty_all <= 0 OR TRUNCATE(ld_qty_oh , 3) = 0
               THEN NEXT.

               IF CAN-FIND(FIRST IS_mstr NO-LOCK
                           WHERE IS_domain  = GLOBAL_domain
                             AND IS_status  = ld_status
                             AND is_avail   = NO )  THEN NEXT.

              FIND FIRST ttq2_det
                   WHERE ttq2_len  = SUBSTRING(ld_lot , 14 , 5 )
                     AND ttq2_lot  = SUBSTRING(ld_lot , 1 , 9 )
                     AND ttq2_loc  = ld_loc
                     AND ttq2_ref  = ld_ref NO-ERROR.
              IF NOT AVAIL ttq2_det THEN
              DO:
                 CREATE ttq2_det.
                 ASSIGN ttq2_len  = SUBSTRING(ld_lot , 14 , 5 )
                        ttq2_lot  = SUBSTRING(ld_lot , 1 , 9 )
                        ttq2_loc  = ld_loc
                        ttq2_ref  = ld_ref
                        ttq2_date = ld_expire.
              END. /**IF NOT AVAIL ttq2_det THEN**/
              ttq2_qtyoh = ttq2_qtyoh + (ld_qty_oh - ld_qty_all).
              {xxqtylim.i ttq2_qtyoh}
           END. /**EACH ld_det **/

       END. /**IF m_width <> 0 THEN**/
       ELSE DO:
           FOR EACH ld_det
               FIELDS(ld_loc ld_status ld_lot ld_ref ld_date ld_qty_oh
                      ld_qty_all ld_expire ld__chr01)
               WHERE ld_domain = GLOBAL_domain
                 AND ld_part   = m_part
                 AND ld_site   = m_site
/*linas35125*    AND LENGTH(ld_lot)  = 9  NO-LOCK: */
/*linas35125*/   AND LENGTH(ld_lot) <= 13 NO-LOCK: 
               IF ld_qty_oh - ld_qty_all <= 0 OR TRUNCATE(ld_qty_oh , 3) = 0
               THEN NEXT.

               IF CAN-FIND(FIRST IS_mstr NO-LOCK
                           WHERE IS_domain  = GLOBAL_domain
                             AND IS_status  = ld_status
                             AND is_avail   = NO )  THEN NEXT.

              m_length = 0.
              FOR FIRST pt_mstr
                  FIELDS(pt__dec01)
                  WHERE pt_domain  = GLOBAL_domain
                    AND pt_part    = m_part NO-LOCK :
                 m_length = (ld_qty_oh - ld_qty_all) / ( pt__dec01 * 0.001).
              END. /**FOR FIRST pt_mstr**/

              FIND FIRST ttq2_det
                   WHERE ttq2_len  = STRING(m_length)
                     AND ttq2_lot  = SUBSTRING(ld_lot , 1 )
                     AND ttq2_loc  = ld_loc
                     AND ttq2_ref  = ld_ref NO-ERROR.
              IF NOT AVAIL ttq2_det THEN
              DO:
                 CREATE ttq2_det.
                 ASSIGN ttq2_len  = STRING(m_length)
                        ttq2_lot  = SUBSTRING(ld_lot , 1  )
                        ttq2_loc  = ld_loc
                        ttq2_ref  = ld_ref
                        ttq2_date = ld_expire.
              END. /**IF NOT AVAIL ttq2_det THEN**/
              ttq2_qtyoh = ttq2_qtyoh + (ld_qty_oh - ld_qty_all).
              {xxqtylim.i ttq2_qtyoh}
           END. /**EACH ld_det **/
       END. /**ELSE DO**/

       FOR FIRST pt_mstr
           FIELDS(pt_um pt_desc1)
           WHERE pt_domain = GLOBAL_domain
            AND pt_part   = m_part NO-LOCK:
       END. /**FOR FIRST pt_mstr**/
       IF AVAIL pt_mstr THEN
          DISP pt_um pt_desc1
               WITH FRAME a1h.

       FIND FIRST ttq2_det USE-INDEX ttq2_b NO-LOCK NO-ERROR.
       IF AVAIL ttq2_det THEN
          DISP ttq2_date ttq2_len ttq2_lot ttq2_loc ttq2_ref ttq2_qtyoh
               WITH FRAME a1h.

       PROMPT-FOR ttq2_date
           WITH FRAME a1h EDITING:
           {mfnp01.i ttq2_det ttq2_date ttq2_date ttq2_date ttq2_date ttq2_b}
            IF recno <> ? THEN
               DISP ttq2_date ttq2_len ttq2_lot ttq2_loc ttq2_ref ttq2_qtyoh
                    WITH FRAME a1h.
       END. /**PROMPT-FOR tt12_lot**/
       m_effdate = INPUT FRAME a1h ttq2_date.

    END. /**END OF REPEAT**/
END. /**PROCEDURE INQUIRY-BYITEM:**/

PROCEDURE INQUIRY-BYLOT:
    FORM
        /* m_lot   COLON 5 LABEL {&xxictpc_p_09} */                       /* 20120726114444 del */
        m_lot   COLON 4 LABEL {&xxictpc_p_09}                             /* 20120726114444 add */
        VALIDATE(INPUT FRAME a1h m_lot <> "" AND
                 LENGTH(INPUT FRAME a1h m_lot) = 9, m_mesdesc[3])
        ld_expire COLON 19 LABEL {&xxictpc_p_30}                          /* 20120726114444 add */
        ld_part COLON 5 LABEL {&xxictpc_p_05}
        pt_um      NO-LABEL
        SKIP
        pt_desc1   NO-LABEL
        ld_site   COLON 8 LABEL {&xxictpc_p_18}
        ld_loc    NO-LABEL
        m_width   COLON 6 LABEL {&xxictpc_p_22}
        SPACE(1)
        m_length  LABEL {&xxictpc_p_07}
        ld_ref    COLON 5 LABEL {&xxictpc_p_14}
        ld_qty_oh COLON 5 LABEL {&xxictpc_p_11}
        WITH FRAME a1h SIDE-LABEL.

    mainloop:
    REPEAT:
       UPDATE m_lot WITH FRAME a1h.

       ASSIGN m_part   = ""
              m_length = 0
              m_width  = 0.
       FOR FIRST tr_hist
           FIELDS(tr_part)
            WHERE tr_domain = GLOBAL_domain
              AND tr_serial = m_lot
              AND tr_qty_loc <> 0 USE-INDEX tr_serial NO-LOCK :
           m_part = tr_part.
       END. /**FOR LAST tr_hist**/
       IF NOT AVAIL tr_hist THEN
       DO:
          FOR FIRST tr_hist
              FIELDS(tr_part)
              WHERE tr_domain = GLOBAL_domain
                AND tr_serial BEGINS m_lot
                AND tr_qty_loc <> 0  USE-INDEX tr_serial NO-LOCK:
              m_part = tr_part.
          END. /**FOR LAST tr_hist**/
       END. /**IF NOT AVAIL tr_hist THEN**/
       FOR FIRST ld_det
           FIELDS(ld_part ld_site ld_loc ld_lot ld_ref ld_qty_oh ld__chr01 ld_expire /* 20120726114444 add */)
            WHERE ld_domain = GLOBAL_domain
              AND ld_part   = m_part
              AND ld_lot    = m_lot
              AND TRUNCATE(ld_qty_oh , 3) <> 0 NO-LOCK:
       END. /**FOR FIRST ld_det**/
       IF NOT AVAIL ld_det THEN
       DO:
          FOR FIRST ld_det
              FIELDS(ld_part ld_site ld_loc ld_lot ld_ref ld_qty_oh ld__chr01 ld_expire /* 20120726114444 add */)
              WHERE ld_domain = GLOBAL_domain
                AND ld_part                 = m_part
                AND ld_lot             BEGINS m_lot
                AND TRUNCATE(ld_qty_oh , 3) <> 0 NO-LOCK :
          END. /**FOR FIRST ld_det**/
       END. /**IF NOT AVAIL ld_det THEN**/

       IF AVAIL ld_det THEN
       DO:
           ASSIGN m_width  = INT(IF LENGTH(ld_lot) > 9 THEN
                                 SUBSTRING(ld_lot , 10 , 4)
                                 ELSE "0")
                  m_length = INT(IF LENGTH(ld_lot) > 9 THEN
                                 SUBSTRING(ld_lot , 14 , 5)
                                 ELSE "0") NO-ERROR.

          FOR FIRST pt_mstr
              FIELDS(pt_um pt_desc1)
              WHERE pt_domain = GLOBAL_domain
                AND pt_part = ld_part NO-LOCK:
          END. /**FOR FIRST pt_mstr**/
          IF AVAIL pt_mstr THEN
             DISP ld_part pt_um pt_desc1 ld_site ld_loc m_width m_length
                  ld_ref ld_qty_oh ld_expire /* 20120726114444 add */ WITH FRAME a1h.
       END. /**IF AVAIL ld_det THEN**/
       ELSE DISP "" @ ld_part "" @ pt_um "" @ pt_desc1 "" @ ld_site
                 "" @ ld_loc 0 @ m_width 0 @ m_length
                 "" @ ld_ref 0 @ ld_qty_oh "" @ ld_expire /* 20120726114444 add */ WITH FRAME a1h.

    END. /**END OF REPEAT**/
END. /**PROCEDURE INQUIRY-BYITEM:**/

PROCEDURE INQUIRY-BYPALLET:
    FORM
        m_ref      COLON 5 LABEL {&xxictpc_p_14}
        ttq3_part  COLON 5 LABEL {&xxictpc_p_05}
        pt_um      NO-LABEL
        SKIP
        pt_desc1   NO-LABEL
        ttq3_site  COLON 8 LABEL {&xxictpc_p_18}
        ttq3_loc   NO-LABEL
        ttq3_lot   COLON 5 LABEL {&xxictpc_p_09}
        ttq3_qtyoh COLON 5 LABEL {&xxictpc_p_11}
        WITH FRAME a1h SIDE-LABEL.

    mainloop:
    REPEAT:
       CLEAR FRAME a1h ALL NO-PAUSE.
       UPDATE m_ref WITH FRAME a1h.

       EMPTY TEMP-TABLE ttq3_det.

       FOR EACH ld_det
           FIELDS(ld_part ld_status ld_site ld_loc ld_lot ld_date ld_qty_oh
                  ld__chr01)
           WHERE ld_domain = GLOBAL_domain
             AND ld_ref    = m_ref NO-LOCK:
          IF TRUNCATE(ld_qty_oh , 3) = 0 THEN NEXT.

          IF CAN-FIND(FIRST IS_mstr NO-LOCK
                      WHERE IS_domain  = GLOBAL_domain
                        AND IS_status  = ld_status
                        AND is_avail   = NO )  THEN NEXT.


          FIND FIRST ttq3_det
               WHERE ttq3_part = ld_part
                 AND ttq3_site = ld_site
                 AND ttq3_loc  = ld_loc
                 AND ttq3_lot  = ld_lot NO-ERROR.
          IF NOT AVAIL ttq3_det THEN
          DO:
             CREATE ttq3_det.
             ASSIGN ttq3_part = ld_part
                    ttq3_site = ld_site
                    ttq3_loc  = ld_loc
                    ttq3_lot  = ld_lot
                    ttq3_date = ld_date.
          END. /**IF NOT AVAIL ttq3_det THEN**/
          ttq3_qtyoh = ttq3_qtyoh + ld_qty_oh.

          {xxqtylim.i ttq3_qtyoh}


       END. /**EACH ld_det **/


       PROMPT-FOR ttq3_part
           WITH FRAME a1h EDITING:
           {mfnp01.i ttq3_det ttq3_part ttq3_part ttq3_part ttq3_part ttq3_a}
            IF recno <> ? THEN
            DO:
               FOR FIRST pt_mstr
                   FIELDS(pt_um pt_desc1)
                    WHERE pt_domain = GLOBAL_domain
                      AND pt_part   = ttq3_part NO-LOCK:
               END. /**FOR FIRST pt_mstr**/
               IF AVAIL pt_mstr THEN
                   DISP ttq3_site ttq3_part pt_um pt_desc1 ttq3_loc ttq3_lot
                        ttq3_qtyoh WITH FRAME a1h.

            END. /**IF recno <> ? THEN **/
       END. /**PROMPT-FOR tt12_lot**/
       m_part = INPUT FRAME a1h ttq3_part.
    END. /**END OF REPEAT**/
END. /**PROCEDURE INQUIRY-BYPALLET:**/

PROCEDURE INQUIRY-BYLOC:
    FORM
        m_site     COLON 8 LABEL {&xxictpc_p_18}
        m_loc      NO-LABEL
        ttq4_part  COLON 5 LABEL {&xxictpc_p_05}
        pt_um      NO-LABEL
        SKIP
        pt_desc1   NO-LABEL
        ttq4_lot   COLON 5 LABEL {&xxictpc_p_09}
        ttq4_ref   COLON 5 LABEL {&xxictpc_p_14}
        ttq4_qtyoh COLON 5 LABEL {&xxictpc_p_11}
        WITH FRAME a1h SIDE-LABEL.

    mainloop:
    REPEAT:
       CLEAR FRAME a1h ALL NO-PAUSE.
       UPDATE m_site m_loc WITH FRAME a1h.

       EMPTY TEMP-TABLE ttq4_det.

       FOR EACH ld_det
           FIELDS(ld_part ld_status ld_site ld_loc ld_lot ld_ref ld_date
                  ld_qty_oh ld__chr01)
           WHERE ld_domain = GLOBAL_domain
             AND ld_site   = m_site
             AND ld_loc    = m_loc NO-LOCK:

          IF TRUNCATE(ld_qty_oh , 3) = 0 THEN NEXT.

          IF CAN-FIND(FIRST IS_mstr NO-LOCK
                      WHERE IS_domain  = GLOBAL_domain
                        AND IS_status  = ld_status
                        AND is_avail   = NO )  THEN NEXT.


          FIND FIRST ttq4_det
               WHERE ttq4_part = ld_part
                 AND ttq4_site = ld_site
                 AND ttq4_lot  = ld_lot
                 AND ttq4_ref  = ld_ref NO-ERROR.
          IF NOT AVAIL ttq4_det THEN
          DO:
             CREATE ttq4_det.
             ASSIGN ttq4_part = ld_part
                    ttq4_site = ld_site
                    ttq4_lot  = ld_lot
                    ttq4_ref  = ld_ref
                    ttq4_date = ld_date.
          END. /**IF NOT AVAIL ttq4_det THEN**/
          ttq4_qtyoh = ttq4_qtyoh + ld_qty_oh.

          {xxqtylim.i ttq4_qtyoh}

       END. /**EACH ld_det **/


       PROMPT-FOR ttq4_part
           WITH FRAME a1h EDITING:
           {mfnp01.i ttq4_det ttq4_part ttq4_part ttq4_part ttq4_part ttq4_a}
            IF recno <> ? THEN
            DO:
               FOR FIRST pt_mstr
                   FIELDS(pt_um pt_desc1)
                    WHERE pt_domain = GLOBAL_domain
                      AND pt_part   = ttq4_part NO-LOCK:
               END. /**FOR FIRST pt_mstr**/
               IF AVAIL pt_mstr THEN
                   DISP ttq4_site @ m_site
                        ttq4_part pt_um pt_desc1 ttq4_lot ttq4_ref
                        ttq4_qtyoh WITH FRAME a1h.

            END. /**IF recno <> ? THEN **/
       END. /**PROMPT-FOR tt12_lot**/
       m_part = INPUT FRAME a1h ttq4_part.
    END. /**END OF REPEAT**/
END. /**PROCEDURE INQUIRY-BYPALLET:**/

PROCEDURE TRANS-BYLOT:
  n_count = 0. /*jackl 20090527133626*/
  FORM
      tt1_lot
      VALIDATE(INPUT FRAME a1 tt1_lot <> ""
               AND LENGTH(INPUT FRAME a1 tt1_lot) = 9, m_mesdesc[3])
      tt1_part
      tt1_um
      tt1_qtyiss
      tt1_site
      tt1_loc1
      VALIDATE(CAN-FIND(FIRST loc_mstr NO-LOCK
                        WHERE loc_domain = GLOBAL_domain
                          AND loc_site = m_site
                          AND loc_loc  = INPUT FRAME a1 tt1_loc1 ) ,
               m_mesdesc[2])
      WITH FRAME a1 DOWN.

  FORM
    tt1_lot    LABEL {&xxictpc_p_09}
    VALIDATE(INPUT FRAME a1h tt1_lot <> ""
             AND LENGTH(INPUT FRAME a1h tt1_lot) = 9, m_mesdesc[3])
    tt1_loc1   LABEL {&xxictpc_p_21}
    VALIDATE(CAN-FIND(FIRST loc_mstr NO-LOCK
                      WHERE loc_domain = GLOBAL_domain
                        AND loc_site = m_site
                        AND loc_loc  = INPUT FRAME a1h tt1_loc1 ) ,
             m_mesdesc[2])
    WITH FRAME a1h DOWN.

  mainloop:
  REPEAT:
    EMPTY TEMP-TABLE tt1_det.

    CLEAR FRAME a1 ALL NO-PAUSE.
    CLEAR FRAME a1h ALL NO-PAUSE.

    detloop:
    REPEAT:

      IF m_screen THEN
      DO:
          PROMPT-FOR tt1_lot
              WITH FRAME a1h EDITING:
              {mfnp.i tt1_det tt1_lot tt1_lot tt1_lot tt1_lot
                      tt1_a}
               IF recno <> ? THEN
                  DISP tt1_lot tt1_loc1
                       WITH FRAME a1h.
          END. /**ROMPT-FOR tt12_lot**/
      END. /**HHT SCREEN**/
      ELSE DO:
          PROMPT-FOR tt1_lot
              WITH FRAME a1 EDITING:
              {mfnp.i tt1_det tt1_lot tt1_lot tt1_lot tt1_lot
                      tt1_a}
               IF recno <> ? THEN
                  DISP tt1_lot tt1_part tt1_um tt1_qtyiss tt1_site tt1_loc1
                       WITH FRAME a1.
          END. /**PROMPT-FOR tt12_lot**/

      END. /**MFG/PRO SCREEN**/

      ASSIGN m_part   = ""
             m_site   = ""
             m_loc    = ""
             m_syslot = ""
             m_lot    = (IF m_screen THEN INPUT FRAME a1h tt1_lot
                         ELSE INPUT FRAME a1 tt1_lot )
             m_ref    = ""
             m_nbr    = ""
             m_recid  = ?
             gpglef   = 0
             m_trtype = "ISS-TR"
             m_error  = NO.

      RUN GET-ITEM-FROM-LOTREF IN THIS-PROCEDURE.

      IF m_error THEN
         UNDO detloop , RETRY detloop.

      IF m_ref <> "" AND m_ref BEGINS m_paltpref THEN DO:
         MESSAGE m_mesdesc[21].
/*davidw:1959*/  RUN sendbell  IN THIS-PROCEDURE.
         UNDO detloop , RETRY detloop.
      END. /**PALLET REFERENCE**/

      FIND FIRST tt1_det
           WHERE tt1_lot  = m_lot NO-ERROR.
      IF NOT AVAIL tt1_det THEN
      DO:
         CREATE tt1_det.
         ASSIGN tt1_lot    = m_lot
                tt1_syslot = m_syslot
                tt1_part   = m_part
                tt1_site   = m_site
                tt1_loc    = m_loc
		tt1_loc1   = m_loc1  /*Jihui 20140113090940*/
                tt1_ref    = m_ref.
         n_count = n_count + 1. /*jackl 20090527133626*/

         FOR FIRST ld_det
             FIELDS(ld__chr01 ld__chr04 ld_qty_oh)    /*sat040311 */
              WHERE RECID(ld_det) = m_recid NO-LOCK:
         END. /**FOR FIRST ld_det**/
         IF AVAIL ld_det THEN
         DO:
             ASSIGN tt1_nbr    = ld__chr01
                    tt1_line   = ld__chr04          /*sat040311 */
                    tt1_qtyiss = ld_qty_oh.
             ASSIGN m_soline = int(ld__chr04).          /* sat040311 */
             {xxqtylim.i tt1_qtyiss}
         END. /**IF AVAIL ld_det THEN**/

         IF tt1_nbr <> "" THEN
         DO:
            RUN GET-ORDER-DETAILS IN THIS-PROCEDURE
               (INPUT tt1_nbr      , INPUT tt1_part , OUTPUT tt1_line ,
                OUTPUT tt1_dataset , OUTPUT tt1_qtyopn, OUTPUT tt1_cust ,
                OUTPUT tt1_recsite , OUTPUT tt1_qtyall,
                      OUTPUT tt1_soum    , OUTPUT tt1_um_conv).  /*20090605102535*/

         END. /**IF tt1_nbr <> "" THEN**/

         FOR FIRST pt_mstr
             FIELDS(pt_um pt_desc1)
             WHERE pt_domain = GLOBAL_domain
               AND pt_part   = m_part NO-LOCK:
         END. /**FOR FIRST pt_mstr**/
         IF AVAIL pt_mstr THEN
            ASSIGN tt1_um     = pt_um
                   tt1_desc   = pt_desc1.
      END. /**IF NOT AVAIL tt1_det THEN**/

      IF m_screen THEN
          DISP tt1_lot tt1_loc1
               WITH FRAME a1h.
      ELSE DISP tt1_lot tt1_part tt1_um tt1_qtyiss tt1_site tt1_loc1
                WITH FRAME a1.

      IF m_screen THEN DO:
          UPDATE tt1_loc1
                 GO-ON (CTRL-D F5) WITH FRAME a1h DOWN.
          Message "Sum to Scan:" n_count. /*jackl 20090527133626*/
      END.
      ELSE
          UPDATE tt1_loc1
                 GO-ON (CTRL-D F5) WITH FRAME a1 DOWN.

      ASSIGN m_loc1   = (IF m_screen THEN INPUT FRAME a1h tt1_loc1
                         ELSE INPUT FRAME a1 tt1_loc1)
             m_trtype = "RCT-TR"
             m_error  = NO.

      RUN LOC-STAT-VALIDATION IN THIS-PROCEDURE.

      IF m_error THEN
      DO:
         tt1_loc1 = "".
         UNDO detloop , RETRY detloop.
      END. /**IF m_error THEN**/

      /* DELETE */
      IF LASTKEY = KEYCODE("F5") OR LASTKEY = KEYCODE("CTRL-D")
      THEN do:
         del-yn = no.
        /* Please confirm delete */
        {pxmsg.i &MSGNUM=11 &ERRORLEVEL=1 &CONFIRM=del-yn}
        IF del-yn THEN
        DO:
           DELETE tt1_det.
           IF m_screen THEN DO:
              CLEAR FRAME a1h.
              n_count = n_count - 1. /*jackl 20090527133626*/
              Message "Sum to scan:" n_count. /*jackl 20090527133626*/
           END.
           ELSE
              CLEAR FRAME a1.
           UNDO detloop, RETRY detloop.
        END. /**IF del-yn THEN**/
      END. /**IF LASTKEY = KEYCODE("F5") OR LASTKEY = KEYCODE("CTRL-D")*/
      IF m_screen THEN
         DOWN 1 WITH FRAME a1h.
      ELSE DOWN 1 WITH FRAME a1.
    END. /**END OF REPEAT**/

    IF NOT CAN-FIND(FIRST tt1_det) THEN  /*20130621104943*/
          LEAVE mainloop.                /*20130621104943*/
    ELSE IF NOT CAN-FIND(FIRST tt1_det WHERE tt1_qtyiss <> 0
                                    AND tt1_loc1  <> "") THEN
    DO:
       MESSAGE m_mesdesc[14].
/*davidw:1959*/  RUN sendbell  IN THIS-PROCEDURE.
       PAUSE.
       LEAVE mainloop.
    END. /**IF NOT CAN-FIND(FIRST tt1_det WHERE tt1_qtyiss <> 0 ) THEN**/

    RUN STOCK-TRANSFER-CIM IN THIS-PROCEDURE.
    n_count = 0. /*jackl 20090527133626*/
  END. /**END OF REPEAT**/

END. /**TRANS-BYLOT**/

PROCEDURE TRANS-BYPALLET:
  n_count = 0. /*jackl 20090527133626*/
  FORM
      tt2a_ref    COLUMN-LABEL {&xxictpc_p_10}
      VALIDATE(CAN-FIND(FIRST ld_det
                        WHERE ld_domain = GLOBAL_domain
                          AND ld_ref    = INPUT FRAME a1 tt2a_ref NO-LOCK ) ,
               m_mesdesc[5])
      tt2a_part
      tt2a_um
      tt2a_qtyoh
      tt2a_site
      tt2a_loc
      VALIDATE(CAN-FIND(FIRST loc_mstr NO-LOCK
                        WHERE loc_domain = GLOBAL_domain
                          AND loc_site = m_site
                          AND loc_loc  = INPUT FRAME a1 tt2a_loc ) ,
               m_mesdesc[2])
      WITH FRAME a1 DOWN.

  FORM
    tt2a_ref     COLUMN-LABEL {&xxictpc_p_10}
    VALIDATE(CAN-FIND(FIRST ld_det
                        WHERE ld_domain = GLOBAL_domain
                          AND ld_ref    = INPUT FRAME a1h tt2a_ref NO-LOCK ) ,
               m_mesdesc[5])
    tt2a_loc     LABEL {&xxictpc_p_21}
    VALIDATE(CAN-FIND(FIRST loc_mstr NO-LOCK
                      WHERE loc_domain = GLOBAL_domain
                        AND loc_site = m_site
                        AND loc_loc  = INPUT FRAME a1h tt2a_loc ) ,
             m_mesdesc[2])
    WITH FRAME a1h DOWN.

  mainloop:
  REPEAT:
    EMPTY TEMP-TABLE tt2a_det.
    EMPTY TEMP-TABLE tt1_det.

    CLEAR FRAME a1 ALL NO-PAUSE.
    CLEAR FRAME a1h ALL NO-PAUSE.

    detloop:
    REPEAT:

      IF m_screen THEN
      DO:
          PROMPT-FOR tt2a_ref
              WITH FRAME a1h EDITING:
              {mfnp.i tt2a_det tt2a_ref tt2a_ref tt2a_ref tt2a_ref
                      tt2a_ref}
               IF recno <> ? THEN
                  DISP tt2a_ref tt2a_loc
                       WITH FRAME a1h.
          END. /**ROMPT-FOR tt12_lot**/
      END. /**HHT SCREEN**/
      ELSE DO:
          PROMPT-FOR tt2a_ref
              WITH FRAME a1 EDITING:
              {mfnp.i tt2a_det tt2a_ref tt2a_ref tt2a_ref tt2a_ref
                      tt2a_ref}
               IF recno <> ? THEN
                  DISP tt2a_ref tt2a_part tt2a_um tt2a_qtyoh tt2a_site tt2a_loc
                       WITH FRAME a1.
          END. /**PROMPT-FOR tt12_lot**/

      END. /**MFG/PRO SCREEN**/

      ASSIGN m_part   = ""
             m_site   = ""
             m_loc    = ""
             m_lot    = ""
             m_syslot = ""
             m_ref    = (IF m_screen THEN INPUT FRAME a1h tt2a_ref
                         ELSE INPUT FRAME a1 tt2a_ref )
             m_nbr    = ""
             m_recid  = ?
             gpglef   = 0
             m_trtype = "ISS-TR"
             m_error  = NO.

      RUN GET-ITEM-FROM-LOTREF IN THIS-PROCEDURE.

      IF m_error THEN
         UNDO detloop , RETRY detloop.

      FIND FIRST tt2a_det
           WHERE tt2a_ref  = m_ref NO-ERROR.
      IF NOT AVAIL tt2a_det THEN
      DO:
         CREATE tt2a_det.
         ASSIGN tt2a_ref   = m_ref
                tt2a_part  = m_part
                tt2a_site  = m_site
		tt2a_loc   = m_loc1. /*Jihui 20140113090940*/
         n_count = n_count + 1. /*jackl 20090527133626*/
         FOR FIRST pt_mstr
             FIELDS(pt_um pt_desc1)
              WHERE pt_domain = GLOBAL_domain
                AND pt_part = m_part NO-LOCK:
         END. /**FOR FIRST pt_mstr**/
         IF AVAIL pt_mstr THEN
            ASSIGN tt2a_um     = pt_um
                   tt2a_desc   = pt_desc1.

         FOR EACH ld_det
             FIELDS(ld_part ld_site ld_loc ld_lot ld_ref ld__chr01 ld_qty_oh)
             WHERE ld_domain = GLOBAL_domain
               AND ld_ref    = m_ref
               AND ld_site   = m_site
               AND ld_loc    = m_loc
               AND TRUNCATE(ld_qty_oh , 3) <> 0 NO-LOCK :

           ASSIGN m_recid = RECID(ld_det)
                  m_part  = ld_part
                  m_error = NO.
           RUN LOC-DET-VALIDATIONS IN THIS-PROCEDURE
               (INPUT m_recid , OUTPUT m_error).

           IF m_error THEN
              LEAVE.

           FIND FIRST tt1_det
                WHERE tt1_lot   = ld_lot
                  AND tt1_ref   = ld_ref
                  AND tt1_site  = ld_site
                  AND tt1_loc   = ld_loc
                  AND tt1_part  = ld_part NO-ERROR.
           IF NOT AVAIL tt1_det THEN
           DO:
              CREATE tt1_det.
              ASSIGN tt1_lot    = ld_lot
                     tt1_syslot = ld_lot
                     tt1_ref    = ld_ref
                     tt1_ref1   = ld_ref
                     tt1_site   = ld_site
                     tt1_loc    = ld_loc
                     tt1_nbr    = ld__chr01
                     tt1_line   = ld__chr04  /*jackl**ECO:20110307095617*/
                     tt1_part   = ld_part
                     tt1_qtyiss = ld_qty_oh.

              {xxqtylim.i tt1_qtyiss}

              IF tt1_nbr <> "" THEN
              DO:
              /****Jack Li***BEGIN DELETE**ECO:20110307095617*
                RUN GET-ORDER-DETAILS IN THIS-PROCEDURE
                   (INPUT tt1_nbr      , INPUT tt1_part , OUTPUT tt1_line ,
                    OUTPUT tt1_dataset , OUTPUT tt1_qtyopn, OUTPUT tt1_cust ,
                    OUTPUT tt1_recsite , OUTPUT tt1_qtyall,
                      OUTPUT tt1_soum    , OUTPUT tt1_um_conv).  /*20090605102535*/           ****Jack Li***END DELETED**ECO:20110307095617*/

               /****Jack Li***BEGIN ADD**ECO:20110307095617*/
                 RUN GET-ORDER-DETAILS2 IN THIS-PROCEDURE
                    (INPUT tt1_nbr      , INPUT tt1_part , INPUT-OUTPUT tt1_line ,
                     OUTPUT tt1_dataset , OUTPUT tt1_qtyopn, OUTPUT tt1_cust ,
                     OUTPUT tt1_recsite , OUTPUT tt1_qtyall,
                     OUTPUT tt1_soum    , OUTPUT tt1_um_conv,
		     OUTPUT m_chr01_a ). /*linas42955*/
               /****Jack Li***BEGIN ADD**ECO:20110307095617*/

              END. /**IF tt1_nbr <> "" THEN**/
           END. /**IF NOT AVAIL tt1_det THEN**/
         END. /**EACH ld_det**/
         IF m_error THEN
         DO:
            FOR EACH tt1_det
                WHERE tt1_ref = m_ref :
                DELETE tt1_det.
            END. /**EACH tt1_det**/
            UNDO detloop , RETRY detloop.
         END. /**IF m_error THEN**/

      END. /**IF NOT AVAIL tt2a_det THEN**/

      IF m_screen THEN
          DISP tt2a_ref tt2a_loc
                 WITH FRAME a1h.
      ELSE DISP tt2a_ref tt2a_part tt2a_um tt2a_qtyoh tt2a_site tt2a_loc
                WITH FRAME a1.

      IF m_screen THEN DO:
         UPDATE tt2a_loc
                GO-ON (CTRL-D F5) WITH FRAME a1h DOWN.
         Message "Sum to scan:" n_count. /*jackl 20090527133626*/
      END.
      ELSE
         UPDATE tt2a_loc
                GO-ON (CTRL-D F5) WITH FRAME a1 DOWN.

      ASSIGN m_loc1   = tt2a_loc
             m_trtype = "RCT-TR"
             m_error  = NO.

      RUN LOC-STAT-VALIDATION IN THIS-PROCEDURE.

      IF m_error THEN
      DO:
         tt2a_loc = "".
         FOR EACH tt1_det
             WHERE tt1_ref = m_ref :
             tt1_loc1 = "".
         END. /**EACH tt1_det**/
         UNDO detloop , RETRY detloop.
      END. /**IF m_error THEN**/

        /* DELETE */
      IF LASTKEY = KEYCODE("F5") OR LASTKEY = KEYCODE("CTRL-D")
      THEN do:
           del-yn = no.
           /* Please confirm delete */
           {pxmsg.i &MSGNUM=11 &ERRORLEVEL=1 &CONFIRM=del-yn}
           IF del-yn THEN
           DO:
              FOR EACH tt1_det
                  WHERE tt1_ref = tt2a_ref:
                  DELETE tt1_det.
              END. /**EACH tt1_det**/

              DELETE tt2a_det.
              IF m_screen THEN DO:
                 CLEAR FRAME a1h.
                 n_count = n_count - 1. /*jackl 20090527133626*/
                 Message "Sum to scan:" n_count. /*jackl 20090527133626*/

              END.
              ELSE
                 CLEAR FRAME a1.
              UNDO detloop, RETRY detloop.
           END. /**IF del-yn THEN**/
      END. /**IF LASTKEY = KEYCODE("F5") OR LASTKEY = KEYCODE("CTRL-D")*/
      FOR EACH tt1_det
          WHERE tt1_ref = m_ref :
          tt1_loc1 = m_loc1.
      END. /**EACH tt1_det**/

      IF m_screen THEN
         DOWN 1 WITH FRAME a1h.
      ELSE DOWN 1 WITH FRAME a1.
    END. /**END OF REPEAT**/

    IF NOT CAN-FIND(FIRST tt1_det WHERE tt1_qtyiss <> 0
                                     AND tt1_loc1  <> ""  ) THEN
    DO:
       MESSAGE m_mesdesc[14].
/*davidw:1959*/  RUN sendbell  IN THIS-PROCEDURE.
       PAUSE.
       LEAVE mainloop.
    END. /**IF NOT CAN-FIND(FIRST tt1_det WHERE tt1_qtyiss <> 0 ) THEN**/

    RUN STOCK-TRANSFER-CIM IN THIS-PROCEDURE.
    n_count = 0. /*jackl 20090527133626*/
  END. /**END OF REPEAT**/

END. /**TRANS-BYPALLET**/

PROCEDURE TRANS-BYITEM:
    n_count = 0. /*jackl 20090527133626*/
    FORM
        tt1_part
        VALIDATE(CAN-FIND(FIRST pt_mstr
                          WHERE pt_domain = GLOBAL_domain
                            AND pt_part = INPUT FRAME a1 tt1_part
                            AND pt_lot_ser = "" NO-LOCK ) ,
                 m_mesdesc[1])
        tt1_um
        tt1_site
        VALIDATE(CAN-FIND(FIRST si_mstr NO-LOCK
                          WHERE si_domain = GLOBAL_domain
                            AND si_site   = INPUT FRAME a1 tt1_site ) ,
                 m_mesdesc[9])
        tt1_loc
        VALIDATE(CAN-FIND(FIRST loc_mstr NO-LOCK
                          WHERE loc_domain = GLOBAL_domain
                            AND loc_site = INPUT FRAME a1 tt1_site
                            AND loc_loc  = INPUT FRAME a1 tt1_loc ) ,
                 m_mesdesc[2])
        tt1_loc1
        VALIDATE(CAN-FIND(FIRST loc_mstr NO-LOCK
                          WHERE loc_domain = GLOBAL_domain
                            AND loc_site = INPUT FRAME a1 tt1_site
                            AND loc_loc  = INPUT FRAME a1 tt1_loc1 ) ,
                 m_mesdesc[2])
        tt1_qtyiss
        VALIDATE(INPUT FRAME a1 tt1_qtyiss <= tt1_qtyoh ,
                 m_mesdesc[16] )
        WITH FRAME a1 DOWN.

    FORM
        tt1_part    COLON 8 LABEL {&xxictpc_p_05}
        VALIDATE(CAN-FIND(FIRST pt_mstr
                          WHERE pt_domain = GLOBAL_domain
                            AND pt_part = INPUT FRAME a1h tt1_part
                            AND pt_lot_ser = "" NO-LOCK ) ,
                 m_mesdesc[1])
        tt1_um      COLON 8
        tt1_site    COLON 8
        VALIDATE(CAN-FIND(FIRST si_mstr NO-LOCK
                          WHERE si_domain = GLOBAL_domain
                            AND si_site = INPUT FRAME a1h tt1_site ) ,
                 m_mesdesc[9])
        tt1_loc     COLON 8 LABEL {&xxictpc_p_04}
        VALIDATE(CAN-FIND(FIRST loc_mstr NO-LOCK
                          WHERE loc_domain = GLOBAL_domain
                            AND loc_site = INPUT FRAME a1h tt1_site
                            AND loc_loc  = INPUT FRAME a1h tt1_loc ) ,
                 m_mesdesc[2])
        tt1_qtyiss  COLON 8 LABEL {&xxictpc_p_11}
        VALIDATE(INPUT FRAME a1h tt1_qtyiss <= tt1_qtyoh ,
                 m_mesdesc[16] )
        tt1_loc1    COLON 8 LABEL {&xxictpc_p_21}
        VALIDATE(CAN-FIND(FIRST loc_mstr NO-LOCK
                          WHERE loc_domain = GLOBAL_domain
                            AND loc_site = INPUT FRAME a1h tt1_site
                            AND loc_loc  = INPUT FRAME a1h tt1_loc1 )
                 AND INPUT FRAME a1h tt1_loc1 <> INPUT FRAME a1h tt1_loc ,
                 m_mesdesc[2])
      WITH FRAME a1h SIDE-LABEL.

    mainloop:
    REPEAT:
      EMPTY TEMP-TABLE tt1_det.

      CLEAR FRAME a1 ALL NO-PAUSE.
      CLEAR FRAME a1h ALL NO-PAUSE.

      detloop:
      REPEAT:

        IF m_screen THEN
        DO:
            PROMPT-FOR tt1_part tt1_site tt1_loc
                WITH FRAME a1h EDITING:
                {mfnp.i tt1_det tt1_part tt1_part tt1_part tt1_part
                        tt1_a}
                 IF recno <> ? THEN
                     DISP tt1_part tt1_um tt1_site tt1_loc tt1_qtyiss
                          tt1_loc1
                         WITH FRAME a1h.
            END. /**ROMPT-FOR tt12_lot**/
        END. /**HHT SCREEN**/
        ELSE DO:
            PROMPT-FOR tt1_part tt1_site tt1_loc
                WITH FRAME a1 EDITING:
                {mfnp.i tt1_det tt1_part tt1_part tt1_part tt1_part
                        tt1_a}
                 IF recno <> ? THEN
                    DISP tt1_part tt1_um tt1_site tt1_loc tt1_qtyiss
                         tt1_loc1
                         WITH FRAME a1.
            END. /**PROMPT-FOR tt12_lot**/

        END. /**MFG/PRO SCREEN**/


        ASSIGN m_part   = (IF m_screen THEN INPUT FRAME a1h tt1_part
                           ELSE INPUT FRAME a1 tt1_part )
               m_site   = (IF m_screen THEN INPUT FRAME a1h tt1_site
                           ELSE INPUT FRAME a1 tt1_site )
               m_loc    = (IF m_screen THEN INPUT FRAME a1h tt1_loc
                           ELSE INPUT FRAME a1 tt1_loc )
               m_lot    = ""
               m_syslot = ""
               m_ref    = ""
               m_nbr    = ""
               m_recid  = ?
               gpglef   = 0
               m_trtype = "ISS-TR"
               m_error  = NO.

        RUN GET-ITEM-FROM-LOTREF IN THIS-PROCEDURE.

        IF m_error THEN
           UNDO detloop , RETRY detloop.

        FIND FIRST tt1_det
             WHERE tt1_part  = m_part
               AND tt1_site  = m_site
               AND tt1_loc   = m_loc  NO-ERROR.
        IF NOT AVAIL tt1_det THEN
        DO:
           CREATE tt1_det.
           ASSIGN tt1_part  = m_part
                  tt1_site  = m_site
                  tt1_loc   = m_loc.
           n_count = n_count + 1. /*jackl 20090527133626*/
           FOR FIRST ld_det
               FIELDS(ld__chr01 ld_qty_oh)
               WHERE RECID(ld_det) = m_recid NO-LOCK:
           END. /**FOR FIRST ld_det**/
           IF AVAIL ld_det THEN
           DO:
              ASSIGN tt1_nbr     = ld__chr01
                     tt1_qtyoh   = ld_qty_oh.
              {xxqtylim.i tt1_qtyoh}
           END. /**IF AVAIL ld_det THEN**/

           FOR FIRST pt_mstr
               FIELDS(pt_um pt_desc1)
               WHERE pt_domain = GLOBAL_domain
                 AND pt_part = m_part NO-LOCK:
           END. /**FOR FIRST pt_mstr**/
           IF AVAIL pt_mstr THEN
              ASSIGN tt1_um     = pt_um
                     tt1_desc   = pt_desc1.

        END. /**IF NOT AVAIL tt1_det THEN**/

        IF m_screen THEN
        DO:
             DISP tt1_part tt1_um tt1_site tt1_loc tt1_qtyiss
                  tt1_loc1
                  WITH FRAME a1h.
             UPDATE tt1_qtyiss tt1_loc1
                    GO-ON (CTRL-D F5) WITH FRAME a1h DOWN.
             message "Sum to scan:" n_count.  /*jackl 20090527133626*/
        END. /**IF m_screen THEN**/
        ELSE DO:
            DISP tt1_part tt1_um tt1_site tt1_loc tt1_qtyiss
                   tt1_loc1
                   WITH FRAME a1.
            UPDATE tt1_qtyiss tt1_loc1
                   GO-ON (CTRL-D F5) WITH FRAME a1 DOWN.
        END. /**ELSE DO**/

        ASSIGN m_loc1   = (IF m_screen THEN INPUT FRAME a1h tt1_loc1
                           ELSE INPUT FRAME a1 tt1_loc1)
               m_trtype = "RCT-TR"
               m_error  = NO.

        RUN LOC-STAT-VALIDATION IN THIS-PROCEDURE.

        IF m_error THEN
        DO:
           tt1_loc1 = "".
           UNDO detloop , RETRY detloop.
        END. /**IF m_error THEN**/

        IF LASTKEY = KEYCODE("F5") OR LASTKEY = KEYCODE("CTRL-D")
        THEN do:
             del-yn = no.
             /* Please confirm delete */
             {pxmsg.i &MSGNUM=11 &ERRORLEVEL=1 &CONFIRM=del-yn}
             IF del-yn THEN
             DO:
                 DELETE tt1_det.
                 n_count = n_count - 1. /*jackl 20090527133626*/
                 message "Sum to scan:" n_count. /*jackl 20090527133626*/
                IF m_screen THEN
                   CLEAR FRAME a1h.
                ELSE
                   CLEAR FRAME a1.
                UNDO detloop, RETRY detloop.
             END. /**IF del-yn THEN**/
        END. /**IF LASTKEY = KEYCODE("F5") OR LASTKEY = KEYCODE("CTRL-D")*/

        IF NOT m_screen THEN
           DOWN 1 WITH FRAME a1.
      END. /**END OF REPEAT**/

      IF NOT CAN-FIND(FIRST tt1_det WHERE tt1_qtyiss <> 0
                                      AND tt1_loc1  <> "" ) THEN
      DO:
         MESSAGE m_mesdesc[14].
/*davidw:1959*/  RUN sendbell  IN THIS-PROCEDURE.
         PAUSE.
         LEAVE mainloop.
      END. /**IF NOT CAN-FIND(FIRST tt1_det WHERE tt1_qtyiss <> 0 ) THEN**/

      RUN STOCK-TRANSFER-CIM IN THIS-PROCEDURE.
      n_count = 0. /*jackl 20090527133626*/
    END. /**END OF REPEAT**/

END. /**TRANS-BYITEM**/

/**Jack Li****ADD BEGIN******ECO:20130110172731****/
PROCEDURE PALLETIZE-LOT-MULTI-ORDER:
  m_opt = Yes.
  RUN PALLETIZE-LOT /*THIS-PROCEDURE*/.
END. /**PALLETIZE-LOT-MULTI-ORDER**/
/**Jack Li****ADDED END******ECO:20130110172731****/

PROCEDURE PALLETIZE-LOT:

        /* Lee Li add   20091027123957 */

        DEFINE VARIABLE IsLinkedAgree        LIKE mfc_logical                     NO-UNDO.

        /* Lee Li add   20091027123957 */


  n_count = 0. /*jackl 20090527133626*/
  FORM
    tt3_ref  LABEL {&xxictpc_p_24}
    VALIDATE(INPUT FRAME a1 tt3_ref = "" OR
             CAN-FIND(FIRST tt3_det
                      WHERE tt3_ref = INPUT FRAME a1 tt3_ref NO-LOCK ) OR
             CAN-FIND(FIRST ld_det
                      WHERE ld_domain = GLOBAL_domain
                        AND ld_ref    = INPUT FRAME a1 tt3_ref NO-LOCK ) OR
             INPUT FRAME a1 tt3_ref BEGINS m_claimpref ,
             m_mesdesc[5])
        skip
        tt3_site LABEL {&xxictpc_p_23}  /*davidw FORMAT "X(2)" */
    VALIDATE(CAN-FIND(FIRST si_mstr NO-LOCK
                      WHERE si_domain  = GLOBAL_domain
                        AND si_site    = INPUT FRAME a1 tt3_site ) ,
             m_mesdesc[9])
    tt3_loc NO-LABEL
    VALIDATE(CAN-FIND(FIRST loc_mstr NO-LOCK
                      WHERE loc_domain  = GLOBAL_domain
                        AND loc_site    = INPUT FRAME a1 tt3_site
                        AND loc_loc     = INPUT FRAME a1 tt3_loc ) ,
               m_mesdesc[2])
    WITH FRAME a1 NO-LABEL SIDE-LABEL.

  FORM
    tt1_lot
    VALIDATE(INPUT FRAME a2 tt1_lot <> ""
             AND LENGTH(INPUT FRAME a2 tt1_lot) = 9, m_mesdesc[3])
    tt1_part
    tt1_um
    tt1_site
    tt1_loc
    tt1_qtyiss
    WITH FRAME a2 DOWN.

  FORM
    tt1_lot        COLUMN-LABEL {&xxictpc_p_09}
    VALIDATE(INPUT FRAME a2h tt1_lot <> ""
             AND LENGTH(INPUT FRAME a2h tt1_lot) = 9, m_mesdesc[3])
    WITH FRAME a2h DOWN.

    mainloop:
    REPEAT:
      EMPTY TEMP-TABLE tt3_det.
      EMPTY TEMP-TABLE tt1_det.

      /* Lee Li add 20091125132413 */

       EMPTY TEMP-TABLE tttempso.

      /* Lee Li add 20091125132413 */

      CLEAR FRAME a1  ALL NO-PAUSE.
      CLEAR FRAME a2  ALL NO-PAUSE.
      CLEAR FRAME a2h ALL NO-PAUSE.
      CLEAR FRAME a   ALL NO-PAUSE.    /*Jack Li*/

      PROMPT-FOR tt3_ref
          WITH FRAME a1 EDITING:
          {mfnp.i tt3_det tt3_ref tt3_ref tt3_ref tt3_ref tt3_ref}
           IF recno <> ? THEN
               DISP tt3_ref
                   WITH FRAME a1.
      END. /**ROMPT-FOR tt12_lot**/

      m_ref1  = INPUT FRAME a1 tt3_ref.

     /*Jack Li *ADD BEGIN*ECO#: 20100105155316*****/
      m_yn = No.
      m_pallet = Yes.
      find first code_mstr where code_domain = global_domain
                             and code_fldname = "xx_pallet_creation"
                             and code_value = "CHN"
                             no-lock no-error.
      if available code_mstr then do:
         if code_cmmt = "No" then
            m_pallet = No.
         else
            m_pallet = Yes.
      end.
      else do:
         m_pallet = Yes.
      end.
     /*Jack Li *ADDED END*ECO#: 20100105155316*****/

      IF m_ref1 = "" THEN
      DO:
         if m_pallet = Yes then do:
            m_yn = NO.
            MESSAGE m_mesdesc[23] UPDATE m_yn.
            IF NOT m_yn THEN
               UNDO mainloop, RETRY mainloop.

            RUN GET-PALLET-REF IN THIS-PROCEDURE.
         end.
        /*Jack Li *ADD BEGIN*ECO#: 20100105155316*****/
         else do:
            MESSAGE "ERROR: Blank pallet not allowed".
            UNDO mainloop, RETRY mainloop.
         end.
       /*Jack Li *ADDED END*ECO#: 20100105155316*****/
      END. /**IF m_ref = "" THEN**/



      /* Lee Li add 20091125132413 */
       for each ld_det where ld_domain = Global_domain and
                             ld_ref = m_ref1 no-lock:

            create tttempso.
            tttempso_nbr = ld__chr01.

       end.

        /* Lee Li add 20091125132413 */

      FIND FIRST tt3_det
           WHERE tt3_ref = m_ref1 NO-ERROR.
      IF NOT AVAIL tt3_det THEN
      DO:
         CREATE tt3_det.
         tt3_ref = m_ref1.
         DISP tt3_ref
              WITH FRAME a1.
         IF m_yn OR tt3_ref BEGINS m_claimpref THEN
            UPDATE tt3_site
                   tt3_loc
                   WITH FRAME a1.
         ELSE DO:
           FOR FIRST ld_det
               FIELDS(ld_site ld_loc ld__chr01)
               WHERE ld_domain = GLOBAL_domain
                 AND ld_ref    = tt3_ref
                 AND TRUNCATE(ld_qty_oh , 3) <> 0 NO-LOCK:
           END. /**FOR FIRST ld_det**/
           IF AVAIL ld_det THEN
              ASSIGN tt3_site = ld_site
                     tt3_loc  = ld_loc.
         END. /**ELSE DO:**/
      END. /**IF NOT AVAIL tt3_det THEN**/
      DISP tt3_ref tt3_site tt3_loc
           WITH FRAME a1.

      detloop:
      REPEAT:
        IF m_screen THEN
        DO:
           PROMPT-FOR tt1_lot
               GO-ON (CTRL-D F5) WITH FRAME a2h DOWN EDITING:
           {mfnp01.i tt1_det tt1_lot tt1_lot tt1_ref1 tt3_ref tt1_a}

           IF recno <> ? THEN
              DISP tt1_lot
                   WITH FRAME a2h.
           Message "Sum to scan:" n_count. /*jackl 20100102172216*/
           pause 0.  /*jackl 20110829121243**/
           END.  /**PROMPT-FOR tt42_lot EDITING**/
        END. /**HHT Screen**/
        ELSE DO:
            PROMPT-FOR tt1_lot
                GO-ON (CTRL-D F5) WITH FRAME a2 DOWN EDITING:
            {mfnp01.i tt1_det tt1_lot tt1_lot tt1_ref1 tt3_ref tt1_a}

            IF recno <> ? THEN
               DISP tt1_lot tt1_part tt1_um tt1_site tt1_loc tt1_qtyiss
                    WITH FRAME a2.
            END.  /**PROMPT-FOR tt42_lot EDITING**/

        END. /**ELSE DO**/

        ASSIGN m_part   = ""
               m_site   = ""
               m_loc    = ""
               m_lot    = (IF m_screen THEN INPUT FRAME a2h tt1_lot
                           ELSE INPUT FRAME a2 tt1_lot )
               m_syslot = ""
               m_ref    = ""
               m_nbr    = ""
               m_line   = ""   /*jackl**ECO:20110307095617*/
               m_cust   = ""
               m_recid  = ?
               gpglef   = 0
               m_trtype = "ISS-TR,RCT-TR"
               m_error  = NO.





        RUN GET-ITEM-FROM-LOTREF IN THIS-PROCEDURE.

/*20140210152952 add begin*/
        find first code_mstr no-lock
                             where code_domain  = global_domain
                               and code_fldname = "xx_palletise_istatus_validation"
                               and code_value   = "Yes"
                             no-error.
        if available code_mstr then do:
          for first ld_det no-lock
                                 where ld_domain     = global_domain
                                   and recid(ld_det) = m_recid
                                   and index(code_cmmt,trim(ld_status)) > 0 :
          end. /*for first ld_det*/
          if available ld_det then do:
                  MESSAGE "Inventory status " + ld_status + " is restricted." .
            RUN sendbell IN THIS-PROCEDURE.
            m_error = YES.
          end. /*if available ld_det*/
        end. /*if available code_mstr*/
/*20140210152952 add end*/


        /***Jack Li****ADD BEGIN*****/
         find first ld_det no-lock where ld_domain = global_domain
                                     and ld_site   = m_site
                                     and ld_loc    = m_loc
                                     and ld_lot    = m_syslot
                                     and ld_ref    <> "" no-error.
         if available ld_det then do:
            m_error = Yes.
            message m_mesdesc[3].
         end.
        /***Jack Li****ADDED END*****/

        IF m_error THEN
           UNDO detloop , RETRY detloop.

    /* Lee Li added      20091027123957   */
        /* If it is used in china , judge if the lot has been linked */
        /* if it's not china, no extrac programm execute */
        FIND FIRST code_mstr where code_domain = global_domain and
                                   code_fldname = 'xx_pallet_country' and
                                    code_value   = 'CHN' no-lock no-error.
       if available  code_mstr then
       do:


              /* Lee Li added 20091125132413   */
              /* if m_nbr is not empty, need to judge if the pallet has link other  so */

          IF NOT m_opt THEN DO: /*Jack Li**20130110172731*/
             FIND FIRST tttempso where tttempso_nbr <> m_nbr  no-lock no-error.

             if available tttempso then
             do:

                MESSAGE "The Pallet has linked To : " + tttempso_nbr + " can not link another SO " + m_nbr .
                RUN sendbell  IN THIS-PROCEDURE. /*Jihui 20100104204752*/
                UNDO detloop, RETRY detloop.
             end.
             else
             do:
                create tttempso.
                tttempso_nbr = m_nbr.
             end.
          END. /*IF NOT m_opt THEN DO*/


             /* Lee Li added  20091125132413 */



                if ( m_ref <> "" ) AND
                   ( m_ref <> tt3_ref ) then
                do:

                        IsLinkedAgree = NO.
          MESSAGE "The lot has been linked To : " + m_ref + ", continue?"
          UPDATE IsLinkedAgree.
          IF NOT IsLinkedAgree THEN
            UNDO detloop, RETRY detloop.


               end.


       end.

       /* Lee Li added     20091027123957 */


        IF m_site <> tt3_site THEN
        DO:
           MESSAGE m_mesdesc[3].
/*davidw:1959*/  RUN sendbell  IN THIS-PROCEDURE.
           UNDO detloop , RETRY detloop.
        END. /**IF m_site <> tt3_site THEN**/

        IF CAN-FIND(FIRST tt1_det
                    WHERE tt1_ref1  = tt3_ref) AND
           NOT CAN-FIND(FIRST tt1_det
                    WHERE tt1_ref1  = tt3_ref
                      AND tt1_site  = tt3_site) THEN
        DO:
            MESSAGE m_mesdesc[3].
/*davidw:1959*/  RUN sendbell  IN THIS-PROCEDURE.
            UNDO detloop, RETRY detloop.
        END. /**IF CAN_FIND**/

        /**IF ONE OF THE LOTS IS LINKED TO ORDER THEN SYSTEM SHOULD CHECK**/
        /**NEW LOTS PALLETIZE ALSO ARE LINKED TO ORDER**/
        IF (CAN-FIND(FIRST tt1_det
                     WHERE tt1_ref1  = tt3_ref
                       AND tt1_site  = tt3_site
                       AND tt1_nbr   <> "") OR
            CAN-FIND(FIRST ld_det NO-LOCK
                     WHERE ld_domain = GLOBAL_domain
                       AND ld_ref    = tt3_ref
                       AND ld_site   = tt3_site
                       AND ld__chr01 <> "" ))
            AND m_nbr = "" THEN
        DO:
           MESSAGE m_mesdesc[12].
/*davidw:1959*/  RUN sendbell  IN THIS-PROCEDURE.
           UNDO detloop, RETRY detloop.
        END. /**IF CAN-FIND(FIRST tt1_det**/

        IF (CAN-FIND(FIRST tt1_det
                    WHERE tt1_ref1  = tt3_ref
                      AND tt1_site  = tt3_site
                      AND tt1_nbr   = "") OR
           CAN-FIND(FIRST ld_det NO-LOCK
                    WHERE ld_domain = GLOBAL_domain
                      AND ld_ref    = tt3_ref
                      AND ld_site   = tt3_site
                      AND ld__chr01 = "" ))
           AND m_nbr <> "" THEN
        DO:
          MESSAGE m_mesdesc[30].
/*davidw:1959*/  RUN sendbell  IN THIS-PROCEDURE.
          UNDO detloop, RETRY detloop.
        END. /**IF CAN-FIND(FIRST tt1_det**/


/***Jihui*******************************************/
IF m_nbr <> "" AND NOT m_opt /*Jack Li**20130110172731*/ THEN DO:
   IF (CAN-FIND(FIRST ld_det NO-LOCK
                    WHERE ld_domain = GLOBAL_domain
                      AND ld_ref    = tt3_ref
                      AND ld_site   = tt3_site
                      AND ld__chr01 <> m_nbr )) THEN
        DO:
          MESSAGE "Error: Different SO can not be linked to same Pallet".
          RUN sendbell  IN THIS-PROCEDURE.
          UNDO detloop, RETRY detloop.
        END. /**IF CAN-FIND(FIRST tt1_det**/
END.
/***Jihui********************************************/

     IF NOT m_opt THEN DO: /*Jack Li**20130110172731*/
        /*jackl**begin add**ECO:20110307095617*/
        find first tt1_det no-lock no-error.
        if available tt1_det then do:
           find first tt1_det no-lock where tt1_nbr = m_nbr no-error.
           if not available tt1_det then do:
              message "ERROR: Lot not linked to same sales order".
              RUN sendbell  IN THIS-PROCEDURE.
              UNDO detloop, RETRY detloop.
           end.
        end.
        /*jackl**end added**ECO:20110307095617*/

        /***Jack Li****ADD BEGIN*****/
         find first ld_det no-lock where ld_domain = global_domain
                                     and ld_site   = m_site
                                     and ld_loc    = m_loc
                                     and ld_lot    = m_syslot
                                     and ld_ref    = tt3_ref no-error.
         if available ld_det then do:
            if ld__chr01 <> m_nbr then do:
               message "ERROR: Lot not linked to same sales order".
               RUN sendbell  IN THIS-PROCEDURE.
               UNDO detloop, RETRY detloop.
            end.
         end.
        /***Jack Li****ADDED END*****/

        FOR FIRST so_mstr
            FIELDS(so_cust)
            WHERE so_domain = GLOBAL_domain
              AND so_nbr    = m_nbr NO-LOCK:
          m_cust = so_cust.
        END. /**FOR FIRST so_mstr**/

        IF m_cust <> "" THEN
        DO:
           IF CAN-FIND(FIRST tt1_det
                       WHERE tt1_ref1  = tt3_ref
                         AND tt1_site  = tt3_site
                         AND tt1_cust  <> m_cust) THEN
           DO:
              MESSAGE m_mesdesc[39].
/*davidw:1959*/  RUN sendbell  IN THIS-PROCEDURE.
              UNDO detloop, RETRY detloop.
           END. /**IF CAN-FIND(FIRST tt1_det**/

           FOR EACH ld_det
               FIELDS(ld__chr01)
               WHERE ld_domain = GLOBAL_domain
                 AND ld_ref    = tt3_ref
                 AND ld_site   = tt3_site NO-LOCK:
              FOR FIRST so_mstr
                  FIELDS(so_cust)
                  WHERE so_domain = GLOBAL_domain
                    AND so_nbr    = ld__chr01 NO-LOCK:
                 IF so_cust <> m_cust THEN
                 DO:
                    MESSAGE m_mesdesc[39].
/*davidw:1959*/     RUN sendbell  IN THIS-PROCEDURE.
                    UNDO detloop, RETRY detloop.
                 END. /**IF CAN-FIND(FIRST tt1_det**/
              END. /**FOR FIRST so_mstr**/
              IF NOT AVAIL so_mstr THEN
              DO:
                 MESSAGE m_mesdesc[39].
                 UNDO detloop, RETRY detloop.
              END. /**IF NOT AVAIL so_mstr THEN**/
           END. /**FOR EACH ld_det**/

        END. /**IF m_cust <> "" THEN**/
     END. /* IF NOT m_opt THEN*/

        FIND FIRST tt1_det
             WHERE tt1_ref1 = tt3_ref
               AND tt1_lot  = m_lot NO-ERROR.
        IF NOT AVAIL tt1_det THEN
        DO:
           CREATE tt1_det.
           ASSIGN tt1_ref1   = tt3_ref
                  tt1_lot    = m_lot
                  tt1_syslot = m_syslot
                  tt1_part   = m_part
                  tt1_site   = m_site
                  tt1_loc    = m_loc
                  tt1_loc1   = tt3_loc.
            n_count = n_count + 1. /*jackl 20090527133626*/
           /* Message "Sum to scan:" n_count. *jackl 20090527133626*/
           FOR FIRST ld_det
               FIELDS(ld__chr01 ld_ref ld_qty_oh)
               WHERE RECID(ld_det) = m_recid NO-LOCK:
           END. /**FOR FIRST ld_det**/
           IF AVAIL ld_det THEN
           DO:
               ASSIGN tt1_qtyiss = ld_qty_oh
                      tt1_ref    = ld_ref
                      tt1_nbr    = ld__chr01
                      tt1_line   = ld__chr04.  /*jackl**ECO:20110307095617*/
               {xxqtylim.i tt1_qtyiss}
           END. /**IF AVAIL ld_det THEN**/

           IF tt1_nbr <> "" THEN
           DO:
            /****Jack Li***BEGIN DELETE**ECO:20110307095617*
               RUN GET-ORDER-DETAILS IN THIS-PROCEDURE
                   (INPUT tt1_nbr      , INPUT tt1_part , OUTPUT tt1_line ,
                    OUTPUT tt1_dataset , OUTPUT tt1_qtyopn, OUTPUT tt1_cust ,
                    OUTPUT tt1_recsite , OUTPUT tt1_qtyall,
                      OUTPUT tt1_soum    , OUTPUT tt1_um_conv).  /*20090605102535*/
            ****Jack Li***END DELETED**ECO:20110307095617*/

            /****Jack Li***BEGIN ADD**ECO:20110307095617*/
              RUN GET-ORDER-DETAILS2 IN THIS-PROCEDURE
                  (INPUT tt1_nbr      , INPUT tt1_part , INPUT-OUTPUT tt1_line ,
                   OUTPUT tt1_dataset , OUTPUT tt1_qtyopn, OUTPUT tt1_cust ,
                   OUTPUT tt1_recsite , OUTPUT tt1_qtyall,
                   OUTPUT tt1_soum    , OUTPUT tt1_um_conv,
		     OUTPUT m_chr01_a ). /*linas42955*/

            /****Jack Li***BEGIN ADD**ECO:20110307095617*/
           END. /**IF tt1_nbr <> "" THEN**/

        END. /**IF NOT AVAIL tt1_det THEN**/

        IF LASTKEY = KEYCODE("F5") OR LASTKEY = KEYCODE("CTRL-D")
        THEN do:
           del-yn = no.
           /* Please confirm delete */
           {pxmsg.i &MSGNUM=11 &ERRORLEVEL=1 &CONFIRM=del-yn}
           IF del-yn THEN
           DO:
              DELETE tt1_det.
              IF m_screen THEN DO:
                 CLEAR FRAME a2h.
                 n_count = n_count - 1. /*jackl 20090527133626*/
                 Message "Sum to scan:" n_count. /*jackl 20090527133626*/
              END.
              ELSE
                 CLEAR FRAME a2.
              UNDO detloop, RETRY detloop.
           END. /**IF del-yn THEN**/
        END. /**IF LASTKEY = KEYCODE("F5") OR LASTKEY = KEYCODE("CTRL-D")*/

        Message "Sum to scan:" n_count. /*jackl 20090527133626*/

        IF m_screen THEN
        DO:
            DISP tt1_lot
                 WITH FRAME a2h DOWN.
            DOWN 1 WITH FRAME a2h.
        END. /**HHT SCREEN**/
        ELSE DO:
            DISP tt1_lot
                 tt1_part
                 tt1_um
                 tt1_site
                 tt1_loc
                 tt1_qtyiss
                 WITH FRAME a2 DOWN.
            DOWN 1 WITH FRAME a2.
        END. /**NORMAL SCREEN**/

      END. /**END OF REPEAT**/

      IF NOT CAN-FIND(FIRST tt1_det WHERE tt1_qtyiss <> 0
                                      AND tt1_ref1   <> "" ) THEN
      DO:
         MESSAGE m_mesdesc[14].
/*davidw:1959*/  RUN sendbell  IN THIS-PROCEDURE.
         PAUSE.
         LEAVE mainloop.
      END. /**IF NOT CAN-FIND(FIRST tt1_det WHERE tt1_qtyiss <> 0 ) THEN**/

      RUN STOCK-TRANSFER-CIM IN THIS-PROCEDURE.
      n_count = 0. /*jackl 20090527133626*/
      IF NOT m_cimerr AND m_yn THEN DO:
      /*Jack Li***ADD BEGIN****ECO:20130313104409*/
         IF m_opt = Yes THEN
            m_prttype = 2.
         ELSE
            m_prttype = 1.
       /*Jack Li***ADDED END****ECO:20130313104409*/
         m_sernbr = m_ref1.
         PAUSE 0 BEFORE-HIDE.
         /* {gprun.i ""xxpltppc.p""} */    /* jerryg ECO:105119 */
/* jerryg add start ECO:105119 */
         IF m_epsma THEN DO:
            {gprun.i ""xxapltppc.p""}
         END. /* IF m_epsma */
         ELSE DO:
	    /***Jihui 20140205165345 Begin***/
	    FIND FIRST code_mstr where code_domain = global_domain
	                           and code_fldname = "xx_pallet_creation"
				   and code_value = "CHN"
				   no-lock no-error.
            IF AVAIL code_mstr then
               {gprun.i ""xxpltppccn.p""}
            ELSE
	    /***Jihui 20140205165345 END ***/
               {gprun.i ""xxpltppc.p""}
         END. /* ELSE DO: */
/* jerryg add end ECO:105119 */
         HIDE FRAME a NO-PAUSE.
      END. /**IF NOT m_cimerr THEN DO:**/

    END. /**END OF REPEAT**/

END. /**PALLETIZE-LOT**/

/*jackl --ADD BEGIN* 10/09/08***/
PROCEDURE PALLETIZE-LOTBATCH:


                /* Lee Li add   20091027123957 */


        DEFINE VARIABLE IsLinkedAgree        LIKE mfc_logical                     NO-UNDO.

        /* Lee Li add   20091027123957 */



  FORM
    tt3_ref  LABEL {&xxictpc_p_24}
    VALIDATE(INPUT FRAME a1 tt3_ref = "" OR
             CAN-FIND(FIRST tt3_det
                      WHERE tt3_ref = INPUT FRAME a1 tt3_ref NO-LOCK ) OR
             CAN-FIND(FIRST ld_det
                      WHERE ld_domain = GLOBAL_domain
                        AND ld_ref    = INPUT FRAME a1 tt3_ref NO-LOCK ) OR
             INPUT FRAME a1 tt3_ref BEGINS m_claimpref ,
             m_mesdesc[5])
        skip
        tt3_site LABEL {&xxictpc_p_23}  /*davidw FORMAT "X(2)" */
    VALIDATE(CAN-FIND(FIRST si_mstr NO-LOCK
                      WHERE si_domain  = GLOBAL_domain
                        AND si_site    = INPUT FRAME a1 tt3_site ) ,
             m_mesdesc[9])
    tt3_loc NO-LABEL
    VALIDATE(CAN-FIND(FIRST loc_mstr NO-LOCK
                      WHERE loc_domain  = GLOBAL_domain
                        AND loc_site    = INPUT FRAME a1 tt3_site
                        AND loc_loc     = INPUT FRAME a1 tt3_loc ) ,
               m_mesdesc[2])
    WITH FRAME a1 NO-LABEL SIDE-LABEL.

  FORM
    tt1_lot
    VALIDATE(INPUT FRAME a2 tt1_lot <> ""
             AND LENGTH(INPUT FRAME a2 tt1_lot) = 9, m_mesdesc[3])
    tt1_part
    tt1_um
    tt1_site
    tt1_loc
    tt1_qtyiss
    WITH FRAME a2 DOWN.

  FORM
       m_lot1      COLUMN-LABEL {&xxictpc_p_27}
       VALIDATE(INPUT FRAME a2h m_lot1 <> ""
                AND LENGTH(INPUT FRAME a2h m_lot1) = 9, m_mesdesc[3])
       m_lot2      COLUMN-LABEL {&xxictpc_p_28}
       VALIDATE(INPUT FRAME a2h m_lot2 <> ""
                AND LENGTH(INPUT FRAME a2h m_lot2) = 9, m_mesdesc[3])
    WITH FRAME a2h DOWN.


    mainloop:
    REPEAT:
      EMPTY TEMP-TABLE tt3_det.
      EMPTY TEMP-TABLE tt1_det.


      /* Lee Li add 20091125132413 */

       EMPTY TEMP-TABLE tttempso.

      /* Lee Li add 20091125132413 */


      CLEAR FRAME a1  ALL NO-PAUSE.
      CLEAR FRAME a2  ALL NO-PAUSE.
      CLEAR FRAME a2h ALL NO-PAUSE.

      PROMPT-FOR tt3_ref
          WITH FRAME a1 EDITING:
          {mfnp.i tt3_det tt3_ref tt3_ref tt3_ref tt3_ref tt3_ref}
           IF recno <> ? THEN
               DISP tt3_ref
                   WITH FRAME a1.
      END. /**ROMPT-FOR tt12_lot**/

      m_ref1  = INPUT FRAME a1 tt3_ref.

      IF m_ref1 = "" THEN
      DO:
          m_yn = NO.
          MESSAGE m_mesdesc[23] UPDATE m_yn.
          IF NOT m_yn THEN
            UNDO mainloop, RETRY mainloop.

          RUN GET-PALLET-REF IN THIS-PROCEDURE.
      END. /**IF m_ref = "" THEN**/



       /* Lee Li add 20091125132413 */
       for each ld_det where ld_domain = Global_domain and
                             ld_ref = m_ref1 no-lock:

            create tttempso.
            tttempso_nbr = ld__chr01.

       end.

        /* Lee Li add 20091125132413 */

      FIND FIRST tt3_det
           WHERE tt3_ref = m_ref1 NO-ERROR.
      IF NOT AVAIL tt3_det THEN
      DO:
         CREATE tt3_det.
         tt3_ref = m_ref1.
         DISP tt3_ref
              WITH FRAME a1.
         IF m_yn OR tt3_ref BEGINS m_claimpref THEN
            UPDATE tt3_site
                   tt3_loc
                   WITH FRAME a1.
         ELSE DO:
           FOR FIRST ld_det
               FIELDS(ld_site ld_loc ld__chr01)
               WHERE ld_domain = GLOBAL_domain
                 AND ld_ref    = tt3_ref
                 AND TRUNCATE(ld_qty_oh , 3) <> 0 NO-LOCK:
           END. /**FOR FIRST ld_det**/
           IF AVAIL ld_det THEN
              ASSIGN tt3_site = ld_site
                     tt3_loc  = ld_loc.
         END. /**ELSE DO:**/
      END. /**IF NOT AVAIL tt3_det THEN**/
      DISP tt3_ref tt3_site tt3_loc
           WITH FRAME a1.

      detloop:
      REPEAT:
        IF m_screen THEN
        DO:

            UPDATE m_lot1 m_lot2 WITH FRAME a2h down.

        END. /**HHT Screen**/
        ELSE DO:
            PROMPT-FOR tt1_lot
                GO-ON (CTRL-D F5) WITH FRAME a2 DOWN EDITING:
            {mfnp01.i tt1_det tt1_lot tt1_lot tt1_ref1 tt3_ref tt1_a}

            IF recno <> ? THEN
               DISP tt1_lot tt1_part tt1_um tt1_site tt1_loc tt1_qtyiss
                    WITH FRAME a2.
            END.  /**PROMPT-FOR tt42_lot EDITING**/

        END. /**ELSE DO**/

        assign m_int  = 0
               m_int1 = 0
               m_int2 = 0
               m_part1 = ""
               m_err  = no.

           /**linas084204**MARK BEGIN**

        m_int = int(substring(m_lot2,2,1)) no-error.
        IF ERROR-STATUS:ERROR THEN DO:
           /* MK05 >>
           m_int1 = int(substring(m_lot1,3,7)) no-error.
           m_int2 = int(substring(m_lot2,3,7)) no-error.
           << MK05 */
           /* MK05 >> */
           m_int1 = int(substring(m_lot1,3,6)) no-error.
           m_int2 = int(substring(m_lot2,3,6)) no-error.
           /* << MK05  */
           m_err  = yes.
        END.
        ELSE DO:
           /* MK05 >>
           m_int1 = int(substring(m_lot1,2,8)) no-error.
           m_int2 = int(substring(m_lot2,2,8)) no-error.
           << MK05 */
           /* MK05 >> */
           m_int1 = int(substring(m_lot1,2,7)) no-error.
           m_int2 = int(substring(m_lot2,2,7)) no-error.
           /* << MK05  */
           m_err  = no.
        END.
        if m_int1 > m_int2 then do:

           **linas084204**MARK END*/
        if m_lot1 > m_lot2 THEN DO: /***linas084204**/

           message "ERROR: FROM Lot is not exceed TO Lot".
/*davidw:1959*/ RUN sendbell  IN THIS-PROCEDURE.
           UNDO detloop , RETRY detloop.
        end.
        else do:

       /*linas084204 BEGIN*/
        assign m_lot3  = "".
        m_part1         = "".
        m_nbr         = "".

       for each ld_det no-lock where ld_domain = global_domain
                     and ld_site = input frame a1 tt3_site
                     and ld_lot  >= m_lot1 
                     and ld_lot  <= m_lot2 + "ZZ"
                     by ld_lot:
                     
                 if m_part1 = "" then m_part1 = ld_part.
                 if m_part1 <> ld_part then do:
                   message "ITEM Number Is Variance"  ld_lot.
                   UNDO detloop , RETRY detloop.
                 end.

                 if m_nbr = "" then m_nbr = ld__chr01.
                if m_nbr <> ld__chr01 then do:
                   message "Sales Order Is Variance" m_lot .
                   UNDO detloop , RETRY detloop.
                end.
                 
                assign m_lot3 = if m_lot3 = "" then ld_lot 
                            else m_lot3 + "," + ld_lot.
        end.
       /*linas084204 END*/

/*      do ii = m_int1 to m_int2: **linas084204*/
        REPEAT  ii = 1 to NUM-ENTRIES(m_lot3): /**linas084204*/
           if m_screen then do:

              m_lot = entry(ii,m_lot3). /**linas084204*/

           /**linas084204**MARK BEGIN**

              if m_err then do:
                 m_lot = substring(m_lot2,1,2) + string(ii,"999999") /* string(ii,"9999999") MK05 */ .
              end.
              else do:
                 m_lot = substring(m_lot2,1,1) + string(ii,"9999999") /* string(ii,"99999999") MK05 */.
              end.
              find first ld_det no-lock where ld_domain = global_domain
                     and ld_site = input frame a1 tt3_site
                    /* and ld_loc  = input frame a1 tt3_loc */
                     and ld_lot  = m_lot no-error.
              /*if not available ld_det then do:
                 message m_lot " IS NOT EXIST".
                 UNDO detloop , RETRY detloop.
              end. */
              if available ld_det then do:
                if ii = m_int1 then
                   assign m_part1 = ld_part
                          m_nbr   = ld__chr01. /*jackl**ECO:20110307095617*/
                if m_part1 <> ld_part then do:
                   message "ITEM Number Is Variance" m_lot .
                   UNDO detloop , RETRY detloop.
                end.

                /*jackl**begin add**ECO:20110307095617*/
                if m_nbr <> ld__chr01 then do:
                   message "Sales Order Is Variance" m_lot .
                   UNDO detloop , RETRY detloop.
                end.
                /*jackl**end added**ECO:20110307095617*/
              end.
           **linas084204**MARK END*/

           end.
           else do:
              m_lot = INPUT FRAME a2 tt1_lot.
           end.

        ASSIGN m_part   = ""
               m_site   = ""
               m_loc    = ""
               m_syslot = ""
               m_ref    = ""
               m_nbr    = ""
               m_cust   = ""
               m_recid  = ?
               gpglef   = 0
               m_trtype = "ISS-TR,RCT-TR"
               m_error  = NO.

        RUN GET-ITEM-FROM-LOTREF IN THIS-PROCEDURE.

        IF m_error THEN
           UNDO detloop , RETRY detloop.

        /* Lee Li added      20091027123957   */
        /* If it is used in china , judge if the lot has been linked */
        /* if it's not china, no extrac programm execute */
        FIND FIRST code_mstr where code_domain = global_domain and
                                   code_fldname = 'xx_pallet_country' and
                                    code_value   = 'CHN' no-lock no-error.
       if available  code_mstr then
       do:


                     /* Lee Li added 20091125132413   */
              /* if m_nbr is not empty, need to judge if the pallet has link other  so */


                  FIND FIRST tttempso where tttempso_nbr <> m_nbr  no-lock no-error.

                  if available tttempso then
                  do:

                    MESSAGE "The Pallet has linked To : " + tttempso_nbr + " can not link another SO " + m_nbr .
                    RUN sendbell  IN THIS-PROCEDURE. /*jihui 20100104204752 */
                    UNDO detloop, RETRY detloop.

                  end.
                  else
                  do:
                           create tttempso.
                           tttempso_nbr = m_nbr.

                  end.


             /* Lee Li added  20091125132413 */





                if ( m_ref <> "" ) AND
                   ( m_ref <> tt3_ref ) then
                do:

                        IsLinkedAgree = NO.
          MESSAGE  m_lot +  " has been linked To : " + m_ref + ", continue?" UPDATE IsLinkedAgree.
          IF NOT IsLinkedAgree THEN
            UNDO detloop, RETRY detloop.


               end.


       end.

       /* Lee Li added     20091027123957 */


        IF m_site <> tt3_site THEN
        DO:

           MESSAGE m_mesdesc[3].
/*davidw:1959*/  RUN sendbell  IN THIS-PROCEDURE.
           UNDO detloop , RETRY detloop.
        END. /**IF m_site <> tt3_site THEN**/

        IF CAN-FIND(FIRST tt1_det
                    WHERE tt1_ref1  = tt3_ref) AND
           NOT CAN-FIND(FIRST tt1_det
                    WHERE tt1_ref1  = tt3_ref
                      AND tt1_site  = tt3_site) THEN
        DO:

            MESSAGE m_mesdesc[3].
/*davidw:1959*/  RUN sendbell  IN THIS-PROCEDURE.
            UNDO detloop, RETRY detloop.
        END. /**IF CAN_FIND**/

        /**IF ONE OF THE LOTS IS LINKED TO ORDER THEN SYSTEM SHOULD CHECK**/
        /**NEW LOTS PALLETIZE ALSO ARE LINKED TO ORDER**/
        IF (CAN-FIND(FIRST tt1_det
                     WHERE tt1_ref1  = tt3_ref
                       AND tt1_site  = tt3_site
                       AND tt1_nbr   <> "") OR
            CAN-FIND(FIRST ld_det NO-LOCK
                     WHERE ld_domain = GLOBAL_domain
                       AND ld_ref    = tt3_ref
                       AND ld_site   = tt3_site
                       AND ld__chr01 <> "" ))
            AND m_nbr = "" THEN
        DO:
           MESSAGE m_mesdesc[12].
/*davidw:1959*/  RUN sendbell  IN THIS-PROCEDURE.
           UNDO detloop, RETRY detloop.
        END. /**IF CAN-FIND(FIRST tt1_det**/

        IF (CAN-FIND(FIRST tt1_det
                    WHERE tt1_ref1  = tt3_ref
                      AND tt1_site  = tt3_site
                      AND tt1_nbr   = "") OR
           CAN-FIND(FIRST ld_det NO-LOCK
                    WHERE ld_domain = GLOBAL_domain
                      AND ld_ref    = tt3_ref
                      AND ld_site   = tt3_site
                      AND ld__chr01 = "" ))
           AND m_nbr <> "" THEN
        DO:
          MESSAGE m_mesdesc[30].
/*davidw:1959*/  RUN sendbell  IN THIS-PROCEDURE.
          UNDO detloop, RETRY detloop.
        END. /**IF CAN-FIND(FIRST tt1_det**/

        FOR FIRST so_mstr
            FIELDS(so_cust)
            WHERE so_domain = GLOBAL_domain
              AND so_nbr    = m_nbr NO-LOCK:
          m_cust = so_cust.
        END. /**FOR FIRST so_mstr**/

        IF m_cust <> "" THEN
        DO:
           IF CAN-FIND(FIRST tt1_det
                       WHERE tt1_ref1  = tt3_ref
                         AND tt1_site  = tt3_site
                         AND tt1_cust  <> m_cust) THEN
           DO:
              MESSAGE m_mesdesc[39].
/*davidw:1959*/  RUN sendbell  IN THIS-PROCEDURE.
              UNDO detloop, RETRY detloop.
           END. /**IF CAN-FIND(FIRST tt1_det**/

           FOR EACH ld_det
               FIELDS(ld__chr01)
               WHERE ld_domain = GLOBAL_domain
                 AND ld_ref    = tt3_ref
                 AND ld_site   = tt3_site NO-LOCK:
              FOR FIRST so_mstr
                  FIELDS(so_cust)
                  WHERE so_domain = GLOBAL_domain
                    AND so_nbr    = ld__chr01 NO-LOCK:
                 IF so_cust <> m_cust THEN
                 DO:
                    MESSAGE m_mesdesc[39].
/*davidw:1959*/  RUN sendbell  IN THIS-PROCEDURE.
                    UNDO detloop, RETRY detloop.
                 END. /**IF CAN-FIND(FIRST tt1_det**/
              END. /**FOR FIRST so_mstr**/
              IF NOT AVAIL so_mstr THEN
              DO:
                 MESSAGE m_mesdesc[39].
                 UNDO detloop, RETRY detloop.
              END. /**IF NOT AVAIL so_mstr THEN**/
           END. /**FOR EACH ld_det**/

        END. /**IF m_cust <> "" THEN**/

        FIND FIRST tt1_det
             WHERE tt1_ref1 = tt3_ref
               AND tt1_lot  = m_lot NO-ERROR.
        IF NOT AVAIL tt1_det THEN
        DO:
           CREATE tt1_det.
           ASSIGN tt1_ref1   = tt3_ref
                  tt1_lot    = m_lot
                  tt1_syslot = m_syslot
                  tt1_part   = m_part
                  tt1_site   = m_site
                  tt1_loc    = m_loc
                  tt1_loc1   = tt3_loc.

           FOR FIRST ld_det
               FIELDS(ld__chr01 ld_ref ld_qty_oh)
               WHERE RECID(ld_det) = m_recid NO-LOCK:
           END. /**FOR FIRST ld_det**/
           IF AVAIL ld_det THEN
           DO:
               ASSIGN tt1_qtyiss = ld_qty_oh
                      tt1_ref    = ld_ref
                      tt1_line   = ld__chr04  /*jackl**ECO:20110307095617*/
                      tt1_nbr    = ld__chr01.
               {xxqtylim.i tt1_qtyiss}
           END. /**IF AVAIL ld_det THEN**/

           IF tt1_nbr <> "" THEN
           DO:
               RUN GET-ORDER-DETAILS IN THIS-PROCEDURE
                   (INPUT tt1_nbr      , INPUT tt1_part , OUTPUT tt1_line ,
                    OUTPUT tt1_dataset , OUTPUT tt1_qtyopn, OUTPUT tt1_cust ,
                    OUTPUT tt1_recsite , OUTPUT tt1_qtyall,
                      OUTPUT tt1_soum    , OUTPUT tt1_um_conv).  /*20090605102535*/

           END. /**IF tt1_nbr <> "" THEN**/

        END. /**IF NOT AVAIL tt1_det THEN**/
        end. /*do ii = m_int1 to m_int2:  jackl*10/09/08*/
        end. /*jackl*/

        IF LASTKEY = KEYCODE("F5") OR LASTKEY = KEYCODE("CTRL-D")
        THEN do:
           del-yn = no.
           /* Please confirm delete */
           {pxmsg.i &MSGNUM=11 &ERRORLEVEL=1 &CONFIRM=del-yn}
           IF del-yn THEN
           DO:
              DELETE tt1_det.
              IF m_screen THEN
                 CLEAR FRAME a2h.
              ELSE
                 CLEAR FRAME a2.
              UNDO detloop, RETRY detloop.
           END. /**IF del-yn THEN**/
        END. /**IF LASTKEY = KEYCODE("F5") OR LASTKEY = KEYCODE("CTRL-D")*/

        IF m_screen THEN
        DO:
            DISP m_lot1 m_lot2
                 WITH FRAME a2h DOWN.
            DOWN 1 WITH FRAME a2h.
            m_lot1 = "".
            m_lot2 = "".
        END. /**HHT SCREEN**/
        ELSE DO:
            DISP tt1_lot
                 tt1_part
                 tt1_um
                 tt1_site
                 tt1_loc
                 tt1_qtyiss
                 WITH FRAME a2 DOWN.
            DOWN 1 WITH FRAME a2.
        END. /**NORMAL SCREEN**/

      END. /**END OF REPEAT**/

      IF NOT CAN-FIND(FIRST tt1_det WHERE tt1_qtyiss <> 0
                                      AND tt1_ref1   <> "" ) THEN
      DO:
         MESSAGE m_mesdesc[14].
/*davidw:1959*/  RUN sendbell  IN THIS-PROCEDURE.
         PAUSE.
         LEAVE mainloop.
      END. /**IF NOT CAN-FIND(FIRST tt1_det WHERE tt1_qtyiss <> 0 ) THEN**/

      RUN STOCK-TRANSFER-CIM IN THIS-PROCEDURE.

      IF NOT m_cimerr AND m_yn THEN DO:
         m_sernbr = m_ref1.
         m_prttype = 1.  /*20130313104409*/
         PAUSE 0 BEFORE-HIDE.
         /* {gprun.i ""xxpltppc.p""} */    /* jerryg ECO:105119 */
/* jerryg add start ECO:105119 */
         IF m_epsma THEN DO:
            {gprun.i ""xxapltppc.p""}
         END. /* IF m_epsma */
         ELSE DO:
           /***Jihui 20140205165345 Begin***/
           FIND FIRST code_mstr where code_domain = global_domain
	               and code_fldname = "xx_pallet_creation"
                       and code_value = "CHN"
                       no-lock no-error.
           IF AVAIL code_mstr then
              {gprun.i ""xxpltppccn.p""}
           ELSE
           /***Jihui 20140205165345 END ***/
              {gprun.i ""xxpltppc.p""}
         END. /* ELSE DO: */
/* jerryg add end ECO:105119 */
         HIDE FRAME a NO-PAUSE.
      END. /**IF NOT m_cimerr THEN DO:**/

    END. /**END OF REPEAT**/
END. /**PALLETIZE-LOTBATCH**/
/*jackl --ADD BEGIN* 10/09/08***/

PROCEDURE PALLETIZE-LOTPARTIAL:
    n_count = 0. /*jackl 20090527133626*/
    FORM
      tt3_ref
      VALIDATE(INPUT FRAME a1 tt3_ref = "" OR
               CAN-FIND(FIRST tt3_det
                        WHERE tt3_ref = INPUT FRAME a1 tt3_ref NO-LOCK ) OR
               CAN-FIND(FIRST ld_det
                        WHERE ld_domain = GLOBAL_domain
                          AND ld_ref    = INPUT FRAME a1 tt3_ref NO-LOCK ) OR
             INPUT FRAME a1 tt3_ref BEGINS m_claimpref ,
               m_mesdesc[5])
       tt3_site
       VALIDATE(CAN-FIND(FIRST si_mstr NO-LOCK
                         WHERE si_domain  = GLOBAL_domain
                           AND si_site    = INPUT FRAME a1 tt3_site ) ,
                m_mesdesc[9])
       tt3_loc
       VALIDATE(CAN-FIND(FIRST loc_mstr NO-LOCK
                         WHERE loc_domain  = GLOBAL_domain
                           AND loc_site    = INPUT FRAME a1 tt3_site
                           AND loc_loc     = INPUT FRAME a1 tt3_loc ) ,
                  m_mesdesc[2])
      WITH FRAME a1 NO-LABEL SIDE-LABEL.

    FORM
      tt1_lot
      VALIDATE(INPUT FRAME a2 tt1_lot <> ""
               AND LENGTH(INPUT FRAME a2 tt1_lot) = 9, m_mesdesc[3])
      tt1_part
      tt1_um
      tt1_site
      tt1_loc
      tt1_qtyiss
      WITH FRAME a2 DOWN.

    FORM
      tt1_lot        COLUMN-LABEL {&xxictpc_p_09}
      VALIDATE(INPUT FRAME a2h tt1_lot <> ""
               AND LENGTH(INPUT FRAME a2h tt1_lot) = 9 , m_mesdesc[3])
      tt1_qtyiss      LABEL {&xxictpc_p_11} FORMAT ">>>>,>>9"
      VALIDATE(INPUT FRAME a2h tt1_qtyiss <= tt1_qtyoh ,
                   m_mesdesc[16])
      WITH FRAME a2h DOWN.

      mainloop:
      REPEAT:
        EMPTY TEMP-TABLE tt3_det.
        EMPTY TEMP-TABLE tt1_det.

        CLEAR FRAME a1  ALL NO-PAUSE.
        CLEAR FRAME a2  ALL NO-PAUSE.
        CLEAR FRAME a2h ALL NO-PAUSE.

        PROMPT-FOR tt3_ref
            WITH FRAME a1 EDITING:
            {mfnp.i tt3_det tt3_ref tt3_ref tt3_ref tt3_ref tt3_ref}
             IF recno <> ? THEN
                 DISP tt3_ref
                     WITH FRAME a1.
        END. /**ROMPT-FOR tt12_lot**/

        m_ref1  = INPUT FRAME a1 tt3_ref.

        IF m_ref1 = "" THEN
        DO:
            m_yn = NO.
            MESSAGE m_mesdesc[23] UPDATE m_yn.
            IF NOT m_yn THEN
              UNDO mainloop, RETRY mainloop.

            RUN GET-PALLET-REF IN THIS-PROCEDURE.
        END. /**IF m_ref = "" THEN**/

        FIND FIRST tt3_det
             WHERE tt3_ref = m_ref1 NO-ERROR.
        IF NOT AVAIL tt3_det THEN
        DO:
           CREATE tt3_det.
           tt3_ref = m_ref1.
           DISP tt3_ref
                WITH FRAME a1.
           IF m_yn THEN
              UPDATE tt3_site
                     tt3_loc
                     WITH FRAME a1.
           ELSE DO:
             FOR FIRST ld_det
                 FIELDS(ld_site ld_loc ld__chr01)
                 WHERE ld_domain = GLOBAL_domain
                   AND ld_ref    = tt3_ref
                   AND TRUNCATE(ld_qty_oh , 3) <> 0 NO-LOCK:
             END. /**FOR FIRST ld_det**/
             IF AVAIL ld_det THEN
                ASSIGN tt3_site = ld_site
                       tt3_loc  = ld_loc.
           END. /**ELSE DO:**/
        END. /**IF NOT AVAIL tt3_det THEN**/
        DISP tt3_ref tt3_site tt3_loc
             WITH FRAME a1.

        detloop:
        REPEAT:
          IF m_screen THEN
          DO:
             PROMPT-FOR tt1_lot
                 WITH FRAME a2h DOWN EDITING:
             {mfnp01.i tt1_det tt1_lot tt1_lot tt1_ref1 tt3_ref tt1_a}

             IF recno <> ? THEN
                DISP tt1_lot tt1_qtyiss
                     WITH FRAME a2h.
             END.  /**PROMPT-FOR tt42_lot EDITING**/
          END. /**HHT Screen**/
          ELSE DO:
              PROMPT-FOR tt1_lot
                  WITH FRAME a2 DOWN EDITING:
              {mfnp01.i tt1_det tt1_lot tt1_lot tt1_ref1 tt3_ref tt1_a}

              IF recno <> ? THEN
                 DISP tt1_lot tt1_part tt1_um tt1_site tt1_loc tt1_qtyiss
                      WITH FRAME a2.
              END.  /**PROMPT-FOR tt42_lot EDITING**/

          END. /**ELSE DO**/

          ASSIGN m_part   = ""
                 m_site   = ""
                 m_loc    = ""
                 m_lot    = (IF m_screen THEN INPUT FRAME a2h tt1_lot
                             ELSE INPUT FRAME a2 tt1_lot )
                 m_syslot = ""
                 m_ref    = ""
                 m_nbr    = ""
                 m_recid  = ?
                 gpglef   = 0
                 m_trtype = "ISS-TR,RCT-TR".

          RUN GET-ITEM-FROM-LOTREF IN THIS-PROCEDURE.

          IF m_error THEN
             UNDO detloop , RETRY detloop.

          IF CAN-FIND(FIRST tt1_det
                      WHERE tt1_ref1 = tt3_ref) AND
             NOT CAN-FIND(FIRST tt1_det
                      WHERE tt1_ref1 = tt3_ref
                        AND tt1_site = tt3_site) THEN
          DO:
              MESSAGE m_mesdesc[3].
/*davidw:1959*/  RUN sendbell  IN THIS-PROCEDURE.
              UNDO detloop, RETRY detloop.
          END. /**IF CAN_FIND**/

          /**IF ONE OF THE LOTS IS LINKED TO ORDER THEN SYSTEM SHOULD CHECK**/
          /**NEW LOTS PALLETIZE ALSO ARE LINKED TO ORDER**/
          IF (CAN-FIND(FIRST tt1_det
                       WHERE tt1_ref1  = tt3_ref
                         AND tt1_site  = tt3_site
                         AND tt1_nbr   <> "") OR
              CAN-FIND(FIRST ld_det NO-LOCK
                       WHERE ld_domain = GLOBAL_domain
                         AND ld_ref    = tt3_ref
                         AND ld_site   = tt3_site
                         AND ld__chr01 <> "" ))
              AND m_nbr = "" THEN
          DO:
             MESSAGE m_mesdesc[12].
/*davidw:1959*/  RUN sendbell  IN THIS-PROCEDURE.
             UNDO detloop, RETRY detloop.
          END. /**IF CAN-FIND(FIRST tt1_det**/

          IF (CAN-FIND(FIRST tt1_det
                      WHERE tt1_ref1  = tt3_ref
                       AND tt1_site  = tt3_site
                       AND tt1_nbr   = "") OR
            CAN-FIND(FIRST ld_det NO-LOCK
                     WHERE ld_domain = GLOBAL_domain
                       AND ld_ref    = tt3_ref
                       AND ld_site   = tt3_site
                       AND ld__chr01 = "" ))
            AND m_nbr <> "" THEN
          DO:
            MESSAGE m_mesdesc[30].
/*davidw:1959*/  RUN sendbell  IN THIS-PROCEDURE.
            UNDO detloop, RETRY detloop.
          END. /**IF CAN-FIND(FIRST tt1_det**/

          FIND FIRST tt1_det
               WHERE tt1_ref1 = tt3_ref
                 AND tt1_lot  = m_lot NO-ERROR.
          IF NOT AVAIL tt1_det THEN
          DO:
             CREATE tt1_det.
             ASSIGN tt1_ref1   = tt3_ref
                    tt1_lot    = m_lot
                    tt1_syslot = m_syslot
                    tt1_part   = m_part
                    tt1_site   = m_site
                    tt1_loc    = m_loc
                    tt1_loc1   = tt3_loc.
             n_count = n_count + 1. /*jackl 20090527133626*/
             FOR FIRST ld_det
                 FIELDS(ld__chr01 ld_qty_oh)
                 WHERE RECID(ld_det) = m_recid NO-LOCK:
             END. /**FOR FIRST ld_det**/
             IF AVAIL ld_det THEN
             DO:
                ASSIGN tt1_qtyoh = ld_qty_oh
                       tt1_nbr   = ld__chr01
                       tt1_line  = ld__chr04. /*jackl *ECO:20110307095617*/
                {xxqtylim.i tt1_qtyoh}
             END. /**IF AVAIL ld_det THEN**/

             IF tt1_nbr <> "" THEN
             DO:
              /**Jack Li ****BEGIN DELETE****ECO:20110307095617******
                 RUN GET-ORDER-DETAILS IN THIS-PROCEDURE
                     (INPUT tt1_nbr      , INPUT tt1_part , OUTPUT tt1_line ,
                      OUTPUT tt1_dataset , OUTPUT tt1_qtyopn , OUTPUT tt1_cust,
                      OUTPUT tt1_recsite , OUTPUT tt1_qtyall,
                      OUTPUT tt1_soum    , OUTPUT tt1_um_conv).  /*20090605102535*/          ***Jack Li ****END DELETED****ECO:20110307095617*****/

              /***Jack Li ****BEGIN ADD****ECO:20110307095617******/
                 RUN GET-ORDER-DETAILS2 IN THIS-PROCEDURE
                     (INPUT tt1_nbr      , INPUT tt1_part , INPUT-OUTPUT tt1_line ,
                      OUTPUT tt1_dataset , OUTPUT tt1_qtyopn , OUTPUT tt1_cust,
                      OUTPUT tt1_recsite , OUTPUT tt1_qtyall,
                      OUTPUT tt1_soum    , OUTPUT tt1_um_conv,
		     OUTPUT m_chr01_a ). /*linas42955*/

              /***Jack Li ****END ADDED****ECO:20110307095617******/

             END. /**IF tt42_nbr <> "" THEN**/

          END. /**IF NOT AVAIL tt1_det THEN**/


          IF m_screen THEN
          DO:
              DISP tt1_lot tt1_qtyiss
                   WITH FRAME a2h DOWN.
              UPDATE tt1_qtyiss
                     GO-ON(CTRL-D F5) WITH FRAME a2h.
                     Message "Sum to scan:" n_count. /*jackl 20090527133626*/
          END. /**HHT SCREEN**/
          ELSE DO:
              DISP tt1_lot
                   tt1_part
                   tt1_um
                   tt1_site
                   tt1_loc
                   tt1_qtyiss
                   WITH FRAME a2 DOWN.
              UPDATE tt1_qtyiss
                     GO-ON(CTRL-D F5) WITH FRAME a2.
          END. /**NORMAL SCREEN**/
          IF LASTKEY = KEYCODE("F5") OR LASTKEY = KEYCODE("CTRL-D")
          THEN do:
             del-yn = no.
             /* Please confirm delete */
             {pxmsg.i &MSGNUM=11 &ERRORLEVEL=1 &CONFIRM=del-yn}
             IF del-yn THEN
             DO:
                DELETE tt1_det.
                IF m_screen THEN DO:
                   CLEAR FRAME a2h.
                   n_count = n_count - 1. /*jackl 20090527133626*/
                   Message "Sum to scan:" n_count. /*jackl 20090527133626*/
                END.
                ELSE
                   CLEAR FRAME a2.
                UNDO detloop, RETRY detloop.
             END. /**IF del-yn THEN**/
          END. /**IF LASTKEY = KEYCODE("F5") OR LASTKEY = KEYCODE("CTRL-D")*/

          IF m_screen THEN
              DOWN 1 WITH FRAME a2h.
          ELSE DOWN 1 WITH FRAME a2.

        END. /**END OF REPEAT**/

        IF NOT CAN-FIND(FIRST tt1_det WHERE tt1_qtyiss <> 0 ) THEN
        DO:
           MESSAGE m_mesdesc[14].
/*davidw:1959*/  RUN sendbell  IN THIS-PROCEDURE.
           PAUSE.
           LEAVE mainloop.
        END. /**IF NOT CAN-FIND(FIRST tt1_det WHERE tt1_qtyiss <> 0 ) THEN**/

        RUN STOCK-TRANSFER-CIM IN THIS-PROCEDURE.
        n_count = 0. /*jackl 20090527133626*/
      END. /**END OF REPEAT**/
END. /**PALLETIZE-LOTPARTIAL**/

PROCEDURE PALLETIZE-ITEM:
  n_count = 0. /*jackl 20090527133626*/
  FORM
    tt3_ref  LABEL {&xxictpc_p_24}
    VALIDATE(INPUT FRAME a1 tt3_ref = "" OR
             CAN-FIND(FIRST tt3_det
                      WHERE tt3_ref = INPUT FRAME a1 tt3_ref NO-LOCK ) OR
             CAN-FIND(FIRST ld_det
                      WHERE ld_domain = GLOBAL_domain
                        AND ld_ref   = INPUT FRAME a1 tt3_ref NO-LOCK ) OR
             INPUT FRAME a1 tt3_ref BEGINS m_claimpref,
             m_mesdesc[5])
    skip
    tt3_site LABEL {&xxictpc_p_23}  /*davidw FORMAT "X(2)"  */
    VALIDATE(CAN-FIND(FIRST si_mstr NO-LOCK
                      WHERE si_domain  = GLOBAL_domain
                        AND si_site    = INPUT FRAME a1 tt3_site ) ,
             m_mesdesc[9])
    tt3_loc NO-LABEL
    VALIDATE(CAN-FIND(FIRST loc_mstr NO-LOCK
                      WHERE loc_domain  = GLOBAL_domain
                        AND loc_site    = INPUT FRAME a1 tt3_site
                        AND loc_loc     = INPUT FRAME a1 tt3_loc ) ,
               m_mesdesc[2])
    WITH FRAME a1 NO-LABEL SIDE-LABEL.

  FORM
    tt1_part
    VALIDATE(CAN-FIND(FIRST pt_mstr
                      WHERE pt_domain = GLOBAL_domain
                        AND pt_part = INPUT FRAME a2 tt1_part
                        AND pt_lot_ser = "" NO-LOCK ) ,
             m_mesdesc[1])
    tt1_site
    VALIDATE(CAN-FIND(FIRST si_mstr NO-LOCK
                      WHERE si_domain = GLOBAL_domain
                        AND si_site   = INPUT FRAME a2 tt1_site ) ,
             m_mesdesc[9])
    tt1_loc
    VALIDATE(CAN-FIND(FIRST loc_mstr NO-LOCK
                      WHERE loc_domain = GLOBAL_domain
                        AND loc_site = INPUT FRAME a2 tt1_site
                        AND loc_loc  = INPUT FRAME a2 tt1_loc ) ,
             m_mesdesc[2])
    tt1_qtyiss
    VALIDATE(INPUT FRAME a2 tt1_qtyiss <= tt1_qtyoh ,
             m_mesdesc[16])
    WITH FRAME a2 DOWN.

  FORM
    tt1_part   COLON 8 LABEL {&xxictpc_p_05}
    VALIDATE(CAN-FIND(FIRST pt_mstr
                      WHERE pt_domain = GLOBAL_domain
                        AND pt_part = INPUT FRAME a2h tt1_part
                        AND pt_lot_ser = "" NO-LOCK ) ,
             m_mesdesc[1])
    tt1_site   COLON 8 LABEL {&xxictpc_p_18}
    VALIDATE(CAN-FIND(FIRST si_mstr NO-LOCK
                      WHERE si_domain = GLOBAL_domain
                        AND si_site   = INPUT FRAME a2h tt1_site ) ,
             m_mesdesc[9])
    tt1_loc    NO-LABEL
    VALIDATE(CAN-FIND(FIRST loc_mstr NO-LOCK
                      WHERE loc_domain = GLOBAL_domain
                        AND loc_site = INPUT FRAME a2h tt1_site
                        AND loc_loc  = INPUT FRAME a2h tt1_loc ) ,
             m_mesdesc[2])
    tt1_qtyiss  COLON 8 LABEL {&xxictpc_p_11}
    VALIDATE(INPUT FRAME a2h tt1_qtyiss <= tt1_qtyoh ,
               m_mesdesc[16])
    WITH FRAME a2h SIDE-LABEL.

    mainloop:
    REPEAT:
      EMPTY TEMP-TABLE tt3_det.
      EMPTY TEMP-TABLE tt1_det.

      CLEAR FRAME a1  ALL NO-PAUSE.
      CLEAR FRAME a2  ALL NO-PAUSE.
      CLEAR FRAME a2h ALL NO-PAUSE.

      PROMPT-FOR tt3_ref
          WITH FRAME a1 EDITING:
          {mfnp.i tt3_det tt3_ref tt3_ref tt3_ref tt3_ref tt3_ref}
           IF recno <> ? THEN
               DISP tt3_ref
                   WITH FRAME a1.
      END. /**ROMPT-FOR tt12_lot**/

      m_ref1  = INPUT FRAME a1 tt3_ref.

      IF m_ref1 = "" THEN
      DO:
          m_yn = NO.
          MESSAGE m_mesdesc[23] UPDATE m_yn.
          IF NOT m_yn THEN
            UNDO mainloop, RETRY mainloop.

          RUN GET-PALLET-REF IN THIS-PROCEDURE.
      END. /**IF m_ref = "" THEN**/

      FIND FIRST tt3_det
           WHERE tt3_ref = m_ref1 NO-ERROR.
      IF NOT AVAIL tt3_det THEN
      DO:
         CREATE tt3_det.
         tt3_ref = m_ref1.
         DISP tt3_ref
              WITH FRAME a1.
         IF m_yn THEN
            UPDATE tt3_site
                   tt3_loc
                   WITH FRAME a1.
         ELSE DO:
           FOR FIRST ld_det
               FIELDS(ld_site ld_loc ld__chr01)
               WHERE ld_domain = GLOBAL_domain
                 AND ld_ref    = tt3_ref
                 AND TRUNCATE(ld_qty_oh , 3) <> 0 NO-LOCK:
           END. /**FOR FIRST ld_det**/
           IF AVAIL ld_det THEN
              ASSIGN tt3_site = ld_site
                     tt3_loc  = ld_loc.
         END. /**ELSE DO:**/
      END. /**IF NOT AVAIL tt3_det THEN**/
      DISP tt3_ref tt3_site tt3_loc
           WITH FRAME a1.

      detloop:
      REPEAT:
        IF m_screen THEN
        DO:
           PROMPT-FOR tt1_part tt1_site tt1_loc
               WITH FRAME a2h DOWN EDITING:
           {mfnp01.i tt1_det tt1_part tt1_part tt1_ref1 tt3_ref tt1_a}

           IF recno <> ? THEN
              DISP tt1_part tt1_site tt1_loc tt1_qtyiss
                   WITH FRAME a2h.
           END.  /**PROMPT-FOR tt42_lot EDITING**/
        END. /**HHT Screen**/
        ELSE DO:
            PROMPT-FOR tt1_part tt1_site tt1_loc
                 WITH FRAME a2 DOWN EDITING:
            {mfnp01.i tt1_det tt1_part tt1_part tt1_ref1 tt3_ref tt1_a}

            IF recno <> ? THEN
               DISP tt1_part tt1_site tt1_loc tt1_qtyiss
                    WITH FRAME a2.
            END.  /**PROMPT-FOR tt42_lot EDITING**/

        END. /**ELSE DO**/

        ASSIGN m_part   = (IF m_screen THEN INPUT FRAME a2h tt1_part
                           ELSE INPUT FRAME a2 tt1_part )
               m_site   = (IF m_screen THEN INPUT FRAME a2h tt1_site
                           ELSE INPUT FRAME a2 tt1_site )
               m_loc    = (IF m_screen THEN INPUT FRAME a2h tt1_loc
                           ELSE INPUT FRAME a2 tt1_loc )
               m_lot    = ""
               m_syslot = ""
               m_ref    = ""
               m_nbr    = ""
               m_recid  = ?
               gpglef   = 0
               m_trtype = "ISS-TR,RCT-TR"
               m_error  = NO.

       RUN GET-ITEM-FROM-LOTREF IN THIS-PROCEDURE.

       IF m_error THEN
          UNDO detloop , RETRY detloop.

        IF CAN-FIND(FIRST tt1_det
                     WHERE tt1_ref1 = tt3_ref) AND
            NOT CAN-FIND(FIRST tt1_det
                     WHERE tt1_ref1 = tt3_ref
                       AND tt1_site = tt3_site) THEN
         DO:
             MESSAGE m_mesdesc[8].
/*davidw:1959*/  RUN sendbell  IN THIS-PROCEDURE.
             UNDO detloop, RETRY detloop.
         END. /**IF CAN_FIND**/

        /**IF ONE OF THE LOTS IS LINKED TO ORDER THEN SYSTEM SHOULD CHECK**/
        /**NEW LOTS PALLETIZE ALSO ARE LINKED TO ORDER**/
        IF (CAN-FIND(FIRST tt1_det
                     WHERE tt1_ref1  = tt3_ref
                       AND tt1_site  = tt3_site
                       AND tt1_nbr   <> "") OR
            CAN-FIND(FIRST ld_det NO-LOCK
                     WHERE ld_domain = GLOBAL_domain
                       AND ld_ref    = tt3_ref
                       AND ld_site   = tt3_site
                       AND ld__chr01 <> "" ))
            AND m_nbr = "" THEN
        DO:
           MESSAGE m_mesdesc[12].
/*davidw:1959*/  RUN sendbell  IN THIS-PROCEDURE.
           UNDO detloop, RETRY detloop.
        END. /**IF CAN-FIND(FIRST tt1_det**/

        IF (CAN-FIND(FIRST tt1_det
                    WHERE tt1_ref1  = tt3_ref
                     AND tt1_site  = tt3_site
                     AND tt1_nbr   = "") OR
          CAN-FIND(FIRST ld_det NO-LOCK
                   WHERE ld_domain = GLOBAL_domain
                     AND ld_ref    = tt3_ref
                     AND ld_site   = tt3_site
                     AND ld__chr01 = "" ))
          AND m_nbr <> "" THEN
       DO:
          MESSAGE m_mesdesc[30].
/*davidw:1959*/  RUN sendbell  IN THIS-PROCEDURE.
          UNDO detloop, RETRY detloop.
        END. /**IF CAN-FIND(FIRST tt1_det**/

        FIND FIRST tt1_det
             WHERE tt1_ref1  = tt3_ref
               AND tt1_part  = m_part
               AND tt1_site  = m_site
               AND tt1_loc   = m_loc NO-ERROR.
        IF NOT AVAIL tt1_det THEN
        DO:
           CREATE tt1_det.
           ASSIGN tt1_ref1   = tt3_ref
                  tt1_part   = m_part
                  tt1_site   = m_site
                  tt1_loc    = m_loc
                  tt1_loc1   = tt3_loc.
           n_count = n_count + 1. /*jackl 20090527133626*/
           FOR FIRST ld_det
               FIELDS(ld__chr01 ld_qty_oh)
               WHERE RECID(ld_det) = m_recid NO-LOCK:
           END. /**FOR FIRST ld_det**/
           IF AVAIL ld_det THEN
           DO:
              ASSIGN tt1_qtyoh  = ld_qty_oh
                     tt1_nbr    = ld__chr01.
              {xxqtylim.i tt1_qtyoh}
           END. /**IF AVAIL ld_det THEN**/

           IF tt1_nbr <> "" THEN
           DO:
               RUN GET-ORDER-DETAILS IN THIS-PROCEDURE
                   (INPUT tt1_nbr      , INPUT tt1_part , OUTPUT tt1_line ,
                    OUTPUT tt1_dataset , OUTPUT tt1_qtyopn  , OUTPUT tt1_cust,
                    OUTPUT tt1_recsite , OUTPUT tt1_qtyall,
                      OUTPUT tt1_soum    , OUTPUT tt1_um_conv).  /*20090605102535*/

           END. /**IF tt42_nbr <> "" THEN**/

        END. /**IF NOT AVAIL tt1_det THEN**/

        IF m_screen THEN
        DO:
            DISP tt1_part tt1_site tt1_loc tt1_qtyiss
                 WITH FRAME a2h.
            UPDATE tt1_qtyiss
                   GO-ON(CTRL-D F5) WITH FRAME a2h.
            Message "Sum to scan:" n_count. /*jackl 20090527133626*/
        END. /**HHT SCREEN**/
        ELSE DO:
            DISP tt1_part tt1_site tt1_loc tt1_qtyiss
                 WITH FRAME a2 DOWN.
            UPDATE tt1_qtyiss
                   GO-ON(CTRL-D F5) WITH FRAME a2 DOWN.
        END. /**NORMAL SCREEN**/

        IF LASTKEY = KEYCODE("F5") OR LASTKEY = KEYCODE("CTRL-D")
        THEN do:
           del-yn = no.
           /* Please confirm delete */
           {pxmsg.i &MSGNUM=11 &ERRORLEVEL=1 &CONFIRM=del-yn}
           IF del-yn THEN
           DO:
              DELETE tt1_det.
              IF m_screen THEN do:
                 CLEAR FRAME a2h.
                 n_count = n_count - 1. /*jackl 20090527133626*/
                 Message "Sum to scan:" n_count. /*jackl 20090527133626*/
              END.
              ELSE
                 CLEAR FRAME a2.
              UNDO detloop, RETRY detloop.
           END. /**IF del-yn THEN**/
        END. /**IF LASTKEY = KEYCODE("F5") OR LASTKEY = KEYCODE("CTRL-D")*/

        IF NOT m_screen THEN
           DOWN 1 WITH FRAME a2.
      END. /**END OF REPEAT**/

      IF NOT CAN-FIND(FIRST tt1_det WHERE tt1_qtyiss <> 0 ) THEN
      DO:
         MESSAGE m_mesdesc[14].
/*davidw:1959*/  RUN sendbell  IN THIS-PROCEDURE.
         PAUSE.
         LEAVE mainloop.
      END. /**IF NOT CAN-FIND(FIRST tt1_det WHERE tt1_qtyiss <> 0 ) THEN**/

      RUN STOCK-TRANSFER-CIM IN THIS-PROCEDURE.
      n_count = 0. /*jackl 20090527133626*/
      IF NOT m_cimerr AND m_yn THEN DO:
         m_sernbr = m_ref1.
         m_prttype = 1.  /*20130313104409*/
         PAUSE 0 BEFORE-HIDE.
         /* {gprun.i ""xxpltppc.p""} */    /* jerryg ECO:105119 */
/* jerryg add start ECO:105119 */
         IF m_epsma THEN DO:
            {gprun.i ""xxapltppc.p""}
         END. /* IF m_epsma */
         ELSE DO:
           /***Jihui 20140205165345 Begin***/
           FIND FIRST code_mstr where code_domain = global_domain
	               and code_fldname = "xx_pallet_creation"
                       and code_value = "CHN"
                       no-lock no-error.
           IF AVAIL code_mstr then
              {gprun.i ""xxpltppccn.p""}
           ELSE
           /***Jihui 20140205165345 END ***/
              {gprun.i ""xxpltppc.p""}

         END. /* ELSE DO: */
/* jerryg add end ECO:105119 */
         HIDE FRAME a NO-PAUSE.
      END. /**IF NOT m_cimerr THEN DO:**/

    END. /**END OF REPEAT**/
END. /**PALLETIZE-ITEM**/

PROCEDURE DEPALLETIZE:
    n_count = 0. /*jackl 20090527133626*/
    FORM
      tt3_ref   COLON 8 LABEL {&xxictpc_p_10}
      VALIDATE(CAN-FIND(FIRST ld_det
                        WHERE ld_domain = GLOBAL_domain
                          AND ld_ref    = INPUT FRAME a1 tt3_ref NO-LOCK )
               AND INPUT FRAME a1 tt3_ref <> "" ,
               m_mesdesc[5])
      tt3_depall LABEL {&xxictpc_p_01}
      WITH FRAME a1 SIDE-LABEL.

    FORM
      tt1_lot
      VALIDATE(INPUT FRAME a2 tt1_lot <> ""
               AND LENGTH(INPUT FRAME a2 tt1_lot) = 9 , m_mesdesc[3])
      tt1_part
      tt1_um
      tt1_site
      tt1_loc
      tt1_qtyiss
      WITH FRAME a2 DOWN.

    FORM
      tt1_lot      LABEL {&xxictpc_p_09}
      VALIDATE(INPUT FRAME a2h tt1_lot <> ""
               AND LENGTH(INPUT FRAME a2h tt1_lot) = 9 , m_mesdesc[3])
      WITH FRAME a2h DOWN.

     mainloop:
     REPEAT:
        EMPTY TEMP-TABLE tt3_det.
        EMPTY TEMP-TABLE tt1_det.

        CLEAR FRAME a1  ALL NO-PAUSE.
        CLEAR FRAME a2  ALL NO-PAUSE.
        CLEAR FRAME a2h ALL NO-PAUSE.
        HIDE FRAME a2   NO-PAUSE.
        HIDE FRAME a2h  NO-PAUSE.

        PROMPT-FOR tt3_ref
            WITH FRAME a1 EDITING:
            {mfnp.i tt3_det tt3_ref tt3_ref tt3_ref tt3_ref tt3_ref}
             IF recno <> ? THEN
                 DISP tt3_ref tt3_depall
                     WITH FRAME a1.
        END. /**PROMPT-FOR tt12_lot**/

        ASSIGN m_part   = ""
               m_site   = ""
               m_loc    = ""
               m_lot    = ""
               m_syslot = ""
               m_ref    = INPUT FRAME a1 tt3_ref
               m_nbr    = ""
               m_recid  = ?
               gpglef   = 0
               m_trtype = "ISS-TR,RCT-TR"
               m_error  = NO.

        RUN GET-ITEM-FROM-LOTREF IN THIS-PROCEDURE.

        IF m_error THEN
           UNDO mainloop , RETRY mainloop.

        FIND FIRST tt3_det
             WHERE tt3_ref = m_ref NO-ERROR.
        IF NOT AVAIL tt3_det THEN
        DO:
           CREATE tt3_det.
           tt3_ref = m_ref.
        END. /**IF NOT AVAIL tt3_det THEN**/
        DISP tt3_ref
             WITH FRAME a1.

        UPDATE tt3_depall
               WITH FRAME a1.
        IF tt3_depall THEN
        DO:
          FOR EACH ld_det
              FIELDS(ld_part ld_site ld_loc ld_lot ld_ref ld__chr01 ld_qty_oh
                     ld__chr02)
              WHERE ld_domain  = GLOBAL_domain
                AND ld_ref     = m_ref NO-LOCK:

              IF ld__chr02 <> "" THEN
                  NEXT.
              ASSIGN m_part   = ""
                     m_site   = ""
                     m_loc    = ""
                     m_lot    = ld_lot
                     m_syslot = ""
                     m_nbr    = ""
                     m_recid  = ?
                     gpglef   = 0
                     m_trtype = "ISS-TR,RCT-TR"
                     m_error  = NO.

              IF ld_lot = "" THEN
                 ASSIGN m_part = ld_part
                        m_site = ld_site
                        m_loc  = ld_loc.

              RUN GET-ITEM-FROM-LOTREF IN THIS-PROCEDURE.

              IF m_error THEN
                 LEAVE.

              FIND FIRST tt1_det
                   WHERE tt1_ref  = ld_ref
                     AND tt1_lot  = ld_lot
                     AND tt1_site = ld_site
                     AND tt1_loc  = ld_loc
                     AND tt1_part = ld_part NO-ERROR.
              IF NOT AVAIL tt1_det THEN
              DO:
                 CREATE tt1_det.
                 ASSIGN tt1_ref    = ld_ref
                        tt1_lot    = ld_lot
                        tt1_syslot = ld_lot
                        tt1_site   = ld_site
                        tt1_loc    = ld_loc
                        tt1_loc1   = ld_loc
                        tt1_part   = ld_part
                        tt1_nbr    = ld__chr01
                        tt1_line   = ld__chr04  /*jackl**ECO:20110307095617*/
                        tt1_qtyiss = ld_qty_oh.


                 {xxqtylim.i tt1_qtyiss}

                 IF tt1_nbr <> "" THEN
                 DO:
                  /****Jack Li***BEGIN DELETE**ECO:20110307095617*
                    RUN GET-ORDER-DETAILS IN THIS-PROCEDURE
                     (INPUT tt1_nbr      , INPUT tt1_part , OUTPUT tt1_line ,
                      OUTPUT tt1_dataset , OUTPUT tt1_qtyopn, OUTPUT tt1_cust ,
                      OUTPUT tt1_recsite , OUTPUT tt1_qtyall,
                      OUTPUT tt1_soum    , OUTPUT tt1_um_conv).  /*20090605102535*/              ****Jack Li***END DELETED**ECO:20110307095617*/

                 /****Jack Li***BEGIN ADD**ECO:20110307095617*/
                  RUN GET-ORDER-DETAILS2 IN THIS-PROCEDURE
                      (INPUT tt1_nbr      , INPUT tt1_part , INPUT-OUTPUT tt1_line ,
                       OUTPUT tt1_dataset , OUTPUT tt1_qtyopn, OUTPUT tt1_cust ,
                       OUTPUT tt1_recsite , OUTPUT tt1_qtyall,
                       OUTPUT tt1_soum    , OUTPUT tt1_um_conv,
		     OUTPUT m_chr01_a ). /*linas42955*/

                 /****Jack Li***BEGIN ADD**ECO:20110307095617*/


                 END. /**IF tt1_nbr <> "" THEN**/

              END. /**IF NOT AVAIL tt1_det THEN**/
          END. /**EACH ld_det**/
          IF m_error THEN
          DO:
            FOR EACH tt1_det
                WHERE tt1_ref = m_ref :
                DELETE tt1_det.
            END. /**EACH tt1_det**/
            UNDO mainloop , RETRY mainloop.
          END. /**IF m_error THEN**/
        END. /**DE-PALLETIZE ALL**/
        ELSE DO:
            detloop:
            REPEAT:
              IF m_screen THEN
              DO:
                 PROMPT-FOR tt1_lot
                     GO-ON (CTRL-D F5) WITH FRAME a2h EDITING:
                 {mfnp01.i tt1_det tt1_lot tt1_lot tt1_ref tt3_ref tt1_a}
                 IF recno <> ? THEN
                    DISP tt1_lot
                         WITH FRAME a2h.
                 END.  /**PROMPT-FOR tt42_lot EDITING**/
              END. /**HHT Screen**/
              ELSE DO:
                  PROMPT-FOR tt1_lot
                      GO-ON (CTRL-D F5) WITH FRAME a2 EDITING:
                  {mfnp01.i tt1_det tt1_lot tt1_lot tt1_ref tt3_ref tt1_a}

                  IF recno <> ? THEN
                     DISP tt1_lot tt1_part tt1_um tt1_site tt1_loc
                          tt1_qtyiss WITH FRAME a2.
                  END.  /**PROMPT-FOR tt42_lot EDITING**/

              END. /**ELSE DO**/

              ASSIGN m_part   = ""
                     m_site   = ""
                     m_loc    = ""
                     m_lot    = (IF m_screen THEN INPUT FRAME a2h tt1_lot
                                 ELSE INPUT FRAME a2 tt1_lot )
                     m_syslot = ""
                     m_nbr    = ""
                     m_recid  = ?
                     gpglef   = 0
                     m_trtype = "ISS-TR,RCT-TR"
                     m_error  = NO.

              RUN GET-ITEM-FROM-LOTREF IN THIS-PROCEDURE.

              IF m_error THEN
                 UNDO detloop , RETRY detloop.

              FIND FIRST tt1_det
                   WHERE tt1_lot  = m_lot NO-ERROR.
              IF NOT AVAIL tt1_det THEN
              DO:
                 CREATE tt1_det.
                 ASSIGN tt1_lot    = m_lot
                        tt1_syslot = m_syslot
                        tt1_ref    = m_ref
                        tt1_part   = m_part
                        tt1_site   = m_site
                        tt1_loc    = m_loc
                        tt1_loc1   = m_loc.
                 n_count = n_count + 1. /*jackl 20090527133626*/
                 Message "Sum to scan:" n_count. /*jackl 20090527133626*/

                 FOR FIRST ld_det
                     FIELDS(ld__chr01 ld_qty_oh ld__chr02)
                     WHERE RECID(ld_det) = m_recid NO-LOCK :
                 END. /**FOR FIRST ld_det**/
                 IF AVAIL ld_det THEN
                 DO:
                     IF ld__chr02 <> "" THEN
                     DO:
                       MESSAGE m_mesdesc[35].
/*davidw:1959*/        RUN sendbell  IN THIS-PROCEDURE.
                       DELETE tt1_det.
                       UNDO detloop , RETRY detloop.
                     END. /**IF ld__chr02 <> "" THEN**/

                     ASSIGN tt1_nbr    = ld__chr01
                            tt1_line   = ld__chr04 /*jackl**ECO:20110307095617*/
                            tt1_qtyiss = ld_qty_oh.
                     {xxqtylim.i tt1_qtyiss}

                     IF tt1_nbr <> "" THEN
                     DO:
                      /****Jack Li***BEGIN DELETE**ECO:20110307095617*
                        RUN GET-ORDER-DETAILS IN THIS-PROCEDURE
                         (INPUT tt1_nbr      , INPUT tt1_part ,
                          OUTPUT tt1_line    ,OUTPUT tt1_dataset ,
                          OUTPUT tt1_qtyopn, OUTPUT tt1_cust ,
                          OUTPUT tt1_recsite , OUTPUT tt1_qtyall,
                      OUTPUT tt1_soum    , OUTPUT tt1_um_conv).  /*20090605102535*/
                      ****Jack Li***END DELETED**ECO:20110307095617*/

                      /****Jack Li***BEGIN ADD**ECO:20110307095617*/
                       RUN GET-ORDER-DETAILS2 IN THIS-PROCEDURE
                           (INPUT tt1_nbr      , INPUT tt1_part ,
                            INPUT-OUTPUT tt1_line     , OUTPUT tt1_dataset ,
                            OUTPUT tt1_qtyopn  , OUTPUT tt1_cust ,
                            OUTPUT tt1_recsite , OUTPUT tt1_qtyall,
                            OUTPUT tt1_soum    , OUTPUT tt1_um_conv,
  		            OUTPUT m_chr01_a ). /*linas42955*/

                      /****Jack Li***BEGIN ADD**ECO:20110307095617*/

                     END. /**IF tt1_nbr <> "" THEN**/

                 END. /**IF AVAIL ld_det THEN**/

                 FOR FIRST pt_mstr
                     FIELDS(pt_um pt_desc1)
                     WHERE pt_domain = GLOBAL_domain
                       AND pt_part = m_part NO-LOCK:
                 END. /**FOR FIRST pt_mstr**/
                 IF AVAIL pt_mstr THEN
                    ASSIGN tt1_um     = pt_um
                           tt1_desc   = pt_desc1.
              END. /**IF NOT AVAIL tt1_det THEN**/

              IF LASTKEY = KEYCODE("F5") OR LASTKEY = KEYCODE("CTRL-D")
              THEN do:
                 del-yn = no.
                 /* Please confirm delete */
                 {pxmsg.i &MSGNUM=11 &ERRORLEVEL=1 &CONFIRM=del-yn}
                 IF del-yn THEN
                 DO:
                    DELETE tt1_det.
                    IF m_screen THEN DO:
                       CLEAR FRAME a2h.
                       n_count = n_count - 1. /*jackl 20090527133626*/
                       Message "Sum to scan:" n_count. /*jackl 20090527133626*/
                    END.
                    ELSE
                       CLEAR FRAME a2.
                    UNDO detloop, RETRY detloop.
                 END. /**IF del-yn THEN**/
              END. /**IF LASTKEY = KEYCODE("F5") OR LASTKEY = KEYCODE("CTRL-D")*/

              IF m_screen THEN
              DO:
                  DISP tt1_lot
                       WITH FRAME a2h DOWN.
                  DOWN 1 WITH FRAME a2h.
              END. /**HHT SCREEN**/
              ELSE DO:
                  DISP tt1_lot
                       tt1_part
                       tt1_um
                       tt1_site
                       tt1_loc
                       tt1_qtyiss
                       WITH FRAME a2 DOWN.
                  DOWN 1 WITH FRAME a2.
              END. /**NORMAL SCREEN**/

            END. /**END OF REPEAT**/
        END. /**ELSE DO**/

        IF NOT CAN-FIND(FIRST tt1_det WHERE tt1_qtyiss <> 0 ) THEN
        DO:
           MESSAGE m_mesdesc[14].
/*davidw:1959*/  RUN sendbell  IN THIS-PROCEDURE.
           PAUSE.
           LEAVE mainloop.
        END. /**IF NOT CAN-FIND(FIRST tt1_det WHERE tt1_qtyiss <> 0 ) THEN**/

        RUN STOCK-TRANSFER-CIM IN THIS-PROCEDURE.
        n_count = 0. /*jackl 20090527133626*/
        IF NOT m_cimerr AND m_yn THEN DO:
           m_sernbr = m_ref.
           IF CAN-FIND(FIRST ld_det NO-LOCK
                       WHERE ld_domain = GLOBAL_domain
                         AND ld_ref    = m_ref
                         AND TRUNCATE(ld_qty_oh , 3) <> 0 ) THEN
           DO:
               PAUSE 0 BEFORE-HIDE.
               m_prttype = 1.  /*20130313104409*/
         /* {gprun.i ""xxpltppc.p""} */    /* jerryg ECO:105119 */
/* jerryg add start ECO:105119 */
         IF m_epsma THEN DO:
            {gprun.i ""xxapltppc.p""}
         END. /* IF m_epsma */
         ELSE DO:
           /***Jihui 20140205165345 Begin***/
           FIND FIRST code_mstr where code_domain = global_domain
	               and code_fldname = "xx_pallet_creation"
                       and code_value = "CHN"
                       no-lock no-error.
           IF AVAIL code_mstr then
              {gprun.i ""xxpltppccn.p""}
           ELSE
           /***Jihui 20140205165345 END ***/
           {gprun.i ""xxpltppc.p""}
         END. /* ELSE DO: */
/* jerryg add end ECO:105119 */
               HIDE FRAME a NO-PAUSE.
           END. /**IF CAN-FIND(FIRST ld_det NO-LOCK**/
        END. /**IF NOT m_cimerr THEN DO:**/

     END. /**END OF REPEAT**/
END. /**DEPALLETIZE**/

PROCEDURE SODOLINK-LOT:
  n_count = 0. /*jackl 20090527133626*/
  FORM
      tt1_lot
      VALIDATE(INPUT FRAME a1 tt1_lot <> ""
               AND LENGTH(INPUT FRAME a1 tt1_lot) = 9 , m_mesdesc[3])
      tt1_part
      tt1_um
      tt1_qtyiss
      tt1_site
      /* MK25112020 >>
      tt1_nbr  COLUMN-LABEL {&xxictpc_p_19} FORMAT "X(8)"
      VALIDATE(INPUT FRAME a1 tt1_nbr <> "" ,
               m_mesdesc[4])
      tt1_line COLUMN-LABEL "Ln" FORMAT "X" /* MK01 */
      << MK25112020 */
   /* m_soln COLUMN-LABEL "SO-Ln" FORMAT "X(11)"  *20111202175402*/
      m_soln COLUMN-LABEL "SO-Ln/DO" FORMAT "X(12)"    /*20111202175402*/
      VALIDATE(INPUT FRAME a1 m_soln <> "", m_mesdesc[4] ) /* MK25112010 */
      WITH FRAME a1 DOWN.

  FORM
    tt1_lot    COLUMN-LABEL {&xxictpc_p_09}
    VALIDATE(INPUT FRAME a1h tt1_lot <> ""
             AND LENGTH(INPUT FRAME a1h tt1_lot) = 9 , m_mesdesc[3])
    /* MK25112020 >>
    tt1_nbr  COLUMN-LABEL {&xxictpc_p_19} FORMAT "X(8)"
    tt1_line COLUMN-LABEL "Ln" FORMAT "X" /*MK01 */
    VALIDATE(INPUT FRAME a1h tt1_nbr <> "" ,
             m_mesdesc[4])
    << MK25112020 */
 /* m_soln COLUMN-LABEL "SO-Ln" FORMAT "X(11)" *20111202175402*/
    m_soln COLUMN-LABEL "SO-Ln/DO" FORMAT "X(12)" /*20111202175402*/

      VALIDATE(INPUT FRAME a1h m_soln <> "", m_mesdesc[4] ) /* MK25112010 */
      WITH FRAME a1h DOWN.

  /*** Jack removed Begin 20120102153825
  FIND FIRST soc_ctrl WHERE soc_domain = GLOBAL_domain NO-LOCK NO-ERROR.
  IF AVAIL soc_ctrl THEN
       ASSIGN m_sopre = soc_so_pre.
  ELSE ASSIGN m_sopre = "".
   *** Jack Removed End 20120102153825 */

  mainloop:
  REPEAT:
    EMPTY TEMP-TABLE tt1_det.
    EMPTY TEMP-TABLE tt4_det.

    CLEAR FRAME a1 ALL NO-PAUSE.
    CLEAR FRAME a1h ALL NO-PAUSE.

    m_sonbr = "".
    m_soln = "" . /* MK25112010 */
    detloop:
    REPEAT:

/*linas142955 BEGIN**/
       if CAN-FIND( FIRST code_mstr NO-LOCK WHERE code_domain = global_domain
                                              AND code_fldname = "xx_so_dupliate_item_not_allowed" )
/*        AND index(m_soln,"-") > 0 *linas84642 */ THEN DO: 
          IF  index(m_soln,"-") > 0 THEN   ASSIGN m_soln = entry(1,m_soln,"-").
           ASSIGN m_soln = substring(m_soln,1,8). /*linas84642*/

       END. /*CAN-FIND( FIRST code_mstr*/
/*linas142955 END**/


    ASSIGN m_soline = 0. /* MK01 */
      IF m_screen THEN
      DO:
          PROMPT-FOR tt1_lot
              WITH FRAME a1h EDITING:
              {mfnp.i tt1_det tt1_lot tt1_lot tt1_lot tt1_lot
                      tt1_a}
               IF recno <> ? THEN
                  DISP tt1_lot m_soln /* tt1_nbr MK25112010 */
                       WITH FRAME a1h.
          END. /**ROMPT-FOR tt12_lot**/
      END. /**HHT SCREEN**/
      ELSE DO:
          PROMPT-FOR tt1_lot
              WITH FRAME a1 EDITING:
              {mfnp.i tt1_det tt1_lot tt1_lot tt1_lot tt1_lot
                      tt1_a}
               IF recno <> ? THEN
                  DISP tt1_lot tt1_part tt1_um tt1_qtyiss tt1_site m_soln /* tt1_nbr MK25112010 */
                       WITH FRAME a1.
          END. /**PROMPT-FOR tt12_lot**/

      END. /**MFG/PRO SCREEN**/

      ASSIGN m_part   = ""
             m_site   = ""
             m_loc    = ""
             m_lot    = (IF m_screen THEN INPUT FRAME a1h tt1_lot
                       ELSE INPUT FRAME a1 tt1_lot )
             m_syslot = ""
             m_ref    = ""
             m_nbr    = ""
             m_recid  = ?
             gpglef   = 0
             m_trtype = ""
           /*  m_soln   = "" /* MK25112010 */  *Jack Li*20130320090553*/
             m_error  = NO.

      RUN GET-ITEM-FROM-LOTREF IN THIS-PROCEDURE.
      IF m_error THEN
         UNDO detloop , RETRY detloop.

      FIND FIRST tt1_det
           WHERE tt1_lot  = m_lot NO-ERROR.
      IF NOT AVAIL tt1_det THEN
      DO:

          CREATE tt1_det.
         ASSIGN tt1_lot    = m_lot
                tt1_syslot = m_syslot
                tt1_part   = m_part
                tt1_site   = m_site
                tt1_loc    = m_loc
                tt1_loc1   = m_loc.
         n_count = n_count + 1. /*jackl 20090527133626*/
         tt1_nbr = m_sonbr.

         FOR FIRST ld_det
             FIELDS(ld__chr01 ld_qty_oh)
             WHERE RECID(ld_det) = m_recid NO-LOCK:
         END. /**FOR FIRST ld_det**/
         IF AVAIL ld_det THEN
         DO:
            tt1_qtyiss = ld_qty_oh.
            {xxqtylim.i tt1_qtyiss}
         END. /**IF AVAIL ld_det THEN**/

         FOR FIRST pt_mstr
             FIELDS(pt_um pt_desc1)
             WHERE pt_domain = GLOBAL_domain
               AND pt_part = m_part NO-LOCK:
         END. /**FOR FIRST pt_mstr**/
         IF AVAIL pt_mstr THEN
            ASSIGN tt1_um     = pt_um
                   tt1_desc   = pt_desc1.
      END. /**IF NOT AVAIL tt1_det THEN**/
     /*Jack Li**ADD BEGIN***ECO:20130103164942**/
      ELSE DO:
         MESSAGE "This Lot has already scan".
         UNDO detloop , RETRY detloop.
      END.
    /*Jack Li**ADDED END***ECO:20130103164942**/

      IF m_screen THEN
          DISP tt1_lot m_soln /* tt1_nbr MK25112010 */
               WITH FRAME a1h.
      ELSE DISP tt1_lot tt1_part tt1_um tt1_qtyiss tt1_site m_soln /* tt1_nbr MK25112010 */
                WITH FRAME a1.

      IF m_screen THEN DO:
          UPDATE m_soln /* tt1_nbr  MK25112010 */
                 GO-ON (CTRL-D F5) WITH FRAME a1h DOWN.
          Message "Sum to scan:" n_count. /*jackl 20090527133626*/
      END.
      ELSE
          UPDATE m_soln /* tt1_nbr  MK25112010 */
                 GO-ON (CTRL-D F5) WITH FRAME a1 DOWN.

/*linas142955 BEGIN**/
       if CAN-FIND( FIRST code_mstr NO-LOCK WHERE code_domain = global_domain
                                              AND code_fldname = "xx_so_dupliate_item_not_allowed" )
        AND index(m_soln,"-") = 0 THEN DO:

	 ASSIGN m_soln = substring(m_soln,1,8). /*linas84642*/

           IF DUMPLICATE-SOLINE(m_soln , m_part) > 1  THEN DO:
	      MESSAGE "ERROR: Multiple line for same item, Please Contact CSR to change SO".
	      UNDO detloop, retry detloop.

	   END. /*IF m_socnt > 1 THEN DO*/
	   ELSE DO:
	      FIND FIRST sod_det no-lock where sod_domain = global_domain
	                                         and sod_nbr = m_soln 
						 and sod_part = m_part
						 NO-ERROR.
              IF NOT AVAILABLE sod_det THEN DO:
	          MESSAGE "ERROR: Invalid SO" . 
	          UNDO detloop, retry detloop.
	      END. /*IF NOT AVAILABLE sod_det*/
	      ELSE DO:
	          ASSIGN m_soln = m_soln + "-" + trim(string(sod_line,">>9")).
	      END.  /*ELSE DO*/
	   END. /*ELSE DO:*/
       END. /*CAN-FIND( FIRST code_mstr*/
/*linas142955 END**/

      /* MK25112010 >> */
      /* Jack Removed Begin 20120102153825
      IF m_soln BEGINS m_sopre THEN
      DO:               Jack Removed End 20120102153825 */
          ASSIGN tt1_nbr  = SUBSTRING(m_soln,1,R-INDEX(m_soln,"-") - 1)
                 tt1_line = TRIM(SUBSTRING(m_soln,R-INDEX(m_soln,"-") + 1))
                 NO-ERROR. /* MK25112010 */

        /***Jack Li***ADD BEGIN**ECO:TEMP****/
        find first so_mstr no-lock where so_domain = global_domain
                                     and so_nbr = tt1_nbr no-error.
        if available so_mstr then do:
           m_soline = INT(tt1_line) NO-ERROR.

           IF ERROR-STATUS:ERROR THEN DO:
              {pxmsg.i &MSGNUM=642 &ERRORLEVEL=3 }
              UNDO detloop , RETRY detloop.
           END.
        end.

      /* Jack Removed Begin 20120102153825
      END.
      ELSE
          ASSIGN tt1_nbr = m_soln.
         Jack Removed End 20120102153825 */

      /* << MK25112010 */


       m_sonbr = tt1_nbr.
      /* MK01 >> */
     ASSIGN m__chr01 = ''.
     EMPTY TEMP-TABLE tts21_det.

     /* Version Validation */
     FIND FIRST tt_ver WHERE tt_sono = tt1_nbr AND tt_vpart = m_part NO-LOCK NO-ERROR.
     IF  NOT AVAIL tt_ver THEN
     DO:
         CREATE tt_ver.
         ASSIGN tt_sono = tt1_nbr
                tt_vpart = m_part
                tt_version = SUBSTRING(tt1_syslot,2,1).

     END. /* NOT AVAIL tt_ver*/
     ELSE IF tt_version <> SUBSTRING(tt1_syslot,2,1) 
              AND NOT CAN-FIND(FIRST code_mstr NO-LOCK WHERE code_domain = global_domain   /*linas42955*/
                                 AND code_fldname = "xx_no_version_control" )              /*linas42955*/
     THEN
     DO:
        MESSAGE m_mesdesc[46].
        UNDO detloop , RETRY detloop.
     END.

   /**Jack Li***ADD BEGIN***ECO:20120710171823**/
   IF NOT CAN-FIND(FIRST code_mstr NO-LOCK WHERE code_domain = global_domain  /*linas42955*/
                                             AND code_fldname = "xx_no_version_control" ) THEN DO:   /*linas42955*/
     if tt1_nbr <> "" THEN DO: /**linas42955*/
     find first tr_hist no-lock where tr_domain = global_domain
                                  and tr_type = "ISS-SO"
                                  and tr_nbr  = tt1_nbr
                                  and string(tr_line) = tt1_line no-error.
     if available tr_hist then do:
        if substring(tr_serial,2,1) <> substring(tt1_syslot,2,1) then do:
           MESSAGE m_mesdesc[46].
           UNDO mainloop , RETRY mainloop.
        end.
     end.
     end. /* if tt1_nbr <> "" */ /**linas42955*/
     end. /*"xx_no_version_control" */ /*linas42955*/
   /**Jack Li***ADDED END***ECO:20120710171823**/


     FIND FIRST so_mstr WHERE so_domain = GLOBAL_domain
                          AND so_nbr = tt1_nbr NO-LOCK NO-ERROR.
     IF AVAIL so_mstr THEN
     DO:
        /* MK25112010 >>
         IF m_screen THEN
            UPDATE tt1_line VALIDATE(CAN-FIND (FIRST sod_det
                            WHERE sod_domain = GLOBAL_domain
                              AND sod_nbr = so_nbr
                              AND sod_line = INT(INPUT tt1_line)),
                              "Invalid Line") WITH FRAME a1h DOWN.
         ELSE
            UPDATE tt1_line VALIDATE(CAN-FIND (FIRST sod_det
                            WHERE sod_domain = GLOBAL_domain
                              AND sod_nbr = so_nbr
                              AND sod_line = INT(INPUT tt1_line)),
                              "Invalid Line") WITH FRAME a1 DOWN.
         m_soline = INT(tt1_line).
        << MK25112010 */
         FIND FIRST sod_det WHERE sod_domain = GLOBAL_domain
                AND sod_nbr = so_nbr
                AND sod_line = m_soline NO-LOCK NO-ERROR.
         IF AVAIL sod_det THEN
         DO:
             ASSIGN m__chr01 = sod__chr01.

/*david:1006*/ if m__chr01 <> "" and length(tt1_syslot) > 9 then do:

            DO m_slline  = 1 TO NUM-ENTRIES(m__chr01 , "@") :
                 ASSIGN m_slitdet = ENTRY(m_slline , m__chr01 , "@")
                        m_data    = "".
                 DO m_sernbr1  = 1 TO NUM-ENTRIES(m_slitdet , "^") :
                    m_data[m_sernbr1] = ENTRY(m_sernbr1 , m_slitdet , "^").
                 END. /**DO m_sernbr  = 1 TO NUM-ENTRIES(m_slitdet , "^")**/
                /* IF m_data[4] = "T" THEN NEXT. /* Type T */ maha220211*/

                FIND FIRST tts21_det
                  WHERE tts21_line   = INT(m_data[1])
                    AND tts21_srnbr  = INT(m_data[2]) NO-ERROR.
                 IF NOT AVAIL tts21_det THEN
                 DO:
                    CREATE tts21_det.
                    ASSIGN tts21_line     = INT(m_data[1])
                           tts21_srnbr    = INT(m_data[2])
                           tts21_rolls    = INT(m_data[5])
                           tts21_width    = DEC(m_data[6])
                           tts21_length   = DEC(m_data[7]).
                    /*maha14112010*/
                    IF tts21_width = 0  THEN
                    DO:
                        FIND FIRST pt_mstr WHERE pt_domain = GLOBAL_domain 
                                             AND pt_part = sod_part 
                                             NO-LOCK NO-ERROR.
                        IF AVAILABLE pt_mstr THEN tts21_width = pt__dec01.
                    END.
                    IF tts21_length = 0  THEN
                    DO:
                        FIND FIRST pt_mstr WHERE pt_domain = GLOBAL_domain 
                                             AND pt_part = sod_part 
                                             NO-LOCK NO-ERROR.
                        IF AVAILABLE pt_mstr THEN tts21_length = pt__dec02.
                    END.
                    /*maha14112010*/
                 END. /* NOT AVAIL tts21_det */
            END. /* DO m_slline  = 1 */

            /* ND071110 */
            /* Commented By Nilay Dasondi 07 Dec 2010 Temporarily */ /* ND091210 */


            /* Width & Length Validation */
            /* FIND FIRST tts21_det WHERE tts21_width = DEC(SUBSTRING(tt1_syslot, 10,4))  NO-LOCK NO-ERROR.   maha031220101*/
            FIND FIRST tts21_det  NO-LOCK NO-ERROR.

            IF NOT AVAIL tts21_det THEN
            DO:

                 FIND FIRST pt_mstr WHERE pt_domain = GLOBAL_domain 
                                      AND pt_part = sod_part 
                                      NO-LOCK NO-ERROR.
                 IF AVAILABLE pt_mstr THEN
                 DO:
                     IF  pt__dec01 <> DEC(SUBSTRING(tt1_syslot, 10,4)) 
		         AND DEC(SUBSTRING(tt1_syslot, 10,4)) > 0 THEN /*Jihui 20140206*/
                     DO:
                        
			MESSAGE m_mesdesc[47]. /*maha14112010 */
			
                        UNDO detloop , RETRY detloop.
                    END.
                END. /*if avail pt_mstr */
            END. /* if not avail */
            ELSE
            DO:
                /* ND091210 */
                FIND FIRST tts21_det WHERE tts21_width = DEC(SUBSTRING(tt1_syslot, 10,4)) NO-LOCK NO-ERROR.  /* ND091210 */
                IF NOT AVAILABLE tts21_det THEN DO: /* ND091210 */
                /* ND091210 */
                    /* ND091210
                    IF tts21_width <> DEC(SUBSTRING(tt1_syslot, 10,4)) THEN
                    DO:
                    */

			MESSAGE m_mesdesc[47]. /*maha14112010 */
			
                       UNDO detloop , RETRY detloop.
                    /* ND091210
                    END.
                    */

                /* nd091210 */
                END.
                ELSE DO:
                    /* sathish added starts ECO: 20110414093105 */
                    IF LENGTH(tt1_syslot) = 13 THEN
                     DO:
                         FIND FIRST pt_mstr WHERE pt_domain = GLOBAL_domain 
                                              AND pt_part = sod_part 
                                              NO-LOCK NO-ERROR.
                         IF AVAILABLE pt_mstr THEN
                         DO:
                            m_length1 = (IF CAN-FIND(FIRST CODE_mstr
                                        WHERE CODE_domain  = GLOBAL_domain
                                        AND CODE_fldname = "xx_pt"
                                        AND CODE_value   = "UM"
                                        AND CODE_cmmt    = pt_um NO-LOCK ) THEN
                                        tt1_qtyiss
                                        ELSE (IF pt_um = "M2"
                                        THEN (ld_qty_oh * 1000) / tts21_width
                                        ELSE pt__dec02 )).
                             IF m_length1 <> tts21_length  THEN
                                MESSAGE m_mesdesc[48].
                         END.

                     END.
                     ELSE
                     DO:
                     /* sathish added ends ECO: 20110414093105 */
                      /* ND091210 */
                       IF DEC(SUBSTRING(tt1_syslot, 14,5)) <> tts21_length  THEN
                        MESSAGE m_mesdesc[48].
                     END.
                END. /* ND091210*/
            END. /* if avail tts21_det */
            /*maha03122010 end */
            /* Commented By Nilay Dasondi 07 Dec 2010 Temporarily */
            /* ND091210 */ /* ND071110 */

/*david:1006*/  end. /* tt1_syslot > 9 */

         END. /* AVAIL sod_det */
         ELSE /* >> MK25112010 */
         DO:

                 MESSAGE m_mesdesc[19].
                 UNDO detloop , RETRY detloop.
         END. /* << MK25112010 */
    END. /* AVAIL so_mstr*/
    /* << MK01 */
    /* >> MK25112010 */
    ELSE
    DO:
      /****Jack Li****ADD BEGIN****ECO:TEMP***/
       FIND FIRST dss_mstr WHERE dss_domain = GLOBAL_domain
                             AND dss_nbr = tt1_nbr NO-LOCK NO-ERROR.

       IF NOT AVAIL dss_mstr THEN DO:
      /****Jack Li****ADDED END****ECO:TEMP***/
          MESSAGE m_mesdesc[26].
          UNDO detloop , RETRY detloop.
      /****Jack Li****ADD BEGIN****ECO:TEMP***/
       END.
       ELSE DO:
         FIND FIRST ds_det WHERE ds_domain = GLOBAL_domain
                             AND ds_nbr = dss_nbr
                             AND ds_part = tt1_part NO-LOCK NO-ERROR.
         IF AVAIL ds_det THEN DO:
            ASSIGN m__chr01 = ds__chr01.
            IF m__chr01 <> "" AND length(tt1_syslot) > 9 THEN DO:
               DO m_slline  = 1 TO NUM-ENTRIES(m__chr01 , "@") :
                  ASSIGN m_slitdet = ENTRY(m_slline , m__chr01 , "@")
                         m_data    = "".
                  DO m_sernbr1  = 1 TO NUM-ENTRIES(m_slitdet , "^") :
                     m_data[m_sernbr1] = ENTRY(m_sernbr1 , m_slitdet , "^").
                  END. /**DO m_sernbr  = 1 **/

                  FIND FIRST tts21_det
                       WHERE tts21_line   = INT(m_data[1])
                         AND tts21_srnbr  = INT(m_data[2]) NO-ERROR.
                  IF NOT AVAIL tts21_det THEN DO:
                     CREATE tts21_det.
                     ASSIGN tts21_line     = INT(m_data[1])
                            tts21_srnbr    = INT(m_data[2])
                            tts21_rolls    = INT(m_data[5])
                            tts21_width    = DEC(m_data[6])
                            tts21_length   = DEC(m_data[7]).
                     IF tts21_width = 0  THEN DO:
                        FIND FIRST pt_mstr WHERE pt_domain = GLOBAL_domain
                                           /*AND pt_part = sod_part Jihui 20130912094300*/
                                             AND pt_part = ds_part /*Jihui 20130912094300*/
                                             NO-LOCK NO-ERROR.
                        IF AVAILABLE pt_mstr THEN
                           tts21_width = pt__dec01.
                     END. /*IF tts21_width = 0*/

                     IF tts21_length = 0  THEN DO:
                        FIND FIRST pt_mstr WHERE pt_domain = GLOBAL_domain
                                           /*AND pt_part = sod_part  Jihui 20130912094300*/
                                             AND pt_part = ds_part /*Jihui 20130912094300*/
                                             NO-LOCK NO-ERROR.
                        IF AVAILABLE pt_mstr THEN tts21_length = pt__dec02.
                     END. /*IF tts21_length = 0*/
                  END. /* NOT AVAIL tts21_det */
               END. /* DO m_slline  = 1 */

               FIND FIRST tts21_det  NO-LOCK NO-ERROR.
               IF NOT AVAIL tts21_det THEN DO:
                  FIND FIRST pt_mstr WHERE pt_domain = GLOBAL_domain
                                     /*AND pt_part = sod_part  Jihui 20130912094300*/
                                       AND pt_part = ds_part /*Jihui 20130912094300*/
                                       NO-LOCK NO-ERROR.
                  IF AVAILABLE pt_mstr THEN DO:
                     IF  pt__dec01 <> DEC(SUBSTRING(tt1_syslot, 10,4)) 
		         AND DEC(SUBSTRING(tt1_syslot, 10,4)) > 0 THEN /*Jihui 20140206*/
                     DO:
                       
			 MESSAGE m_mesdesc[47].
                         UNDO detloop , RETRY detloop.
                     END.
                  END. /*if avail pt_mstr */
               END. /* if not avail */
               ELSE DO:
                 FIND FIRST tts21_det WHERE tts21_width =
                      DEC(SUBSTRING(tt1_syslot, 10,4)) AND 
		      DEC(SUBSTRING(tt1_syslot, 10,4)) > 0 /*Jihui 20140206*/
		      NO-LOCK NO-ERROR.
                 IF NOT AVAILABLE tts21_det THEN DO:
		    
                    MESSAGE m_mesdesc[47] .
                    UNDO detloop , RETRY detloop.
                 END.
                 ELSE DO:
                   IF LENGTH(tt1_syslot) = 13 THEN DO:
                      FIND FIRST pt_mstr WHERE pt_domain = GLOBAL_domain
                                         /*AND pt_part = sod_part  Jihui 20130912094300*/
                                           AND pt_part = ds_part /*Jihui 20130912094300*/
                                           NO-LOCK NO-ERROR.
                      IF AVAILABLE pt_mstr THEN DO:
                         m_length1 = (IF CAN-FIND(FIRST CODE_mstr
                                      WHERE CODE_domain  = GLOBAL_domain
                                        AND CODE_fldname = "xx_pt"
                                        AND CODE_value   = "UM"
                                        AND CODE_cmmt = pt_um NO-LOCK ) THEN
                                            tt1_qtyiss
                                       ELSE (IF pt_um = "M2"
                                       THEN (ld_qty_oh * 1000) / tts21_width
                                       ELSE pt__dec02 )).
                         IF m_length1 <> tts21_length  THEN
                            MESSAGE m_mesdesc[48].
                      END.
                   END.
                   ELSE DO:
                      IF DEC(SUBSTRING(tt1_syslot,14,5)) <> tts21_length THEN
                         MESSAGE m_mesdesc[48].
                   END.
                 END.
               END. /* if avail tts21_det */
            END. /**IF m__chr01 <> "" AND length(tt1_syslot) > 9*/
         END. /*IF AVAIL ds_det THEN*/
       END.
      /****Jack Li****ADDED END****ECO:TEMP***/
    END.
     /* << MK25112010 */
      IF tt1_nbr <> "" AND tt1_dataset = "" THEN
      DO:
          RUN GET-ORDER-DETAILS IN THIS-PROCEDURE
              (INPUT tt1_nbr      , INPUT tt1_part , OUTPUT tt1_line ,
               OUTPUT tt1_dataset , OUTPUT tt1_qtyopn , OUTPUT tt1_cust,
               OUTPUT tt1_recsite , OUTPUT tt1_qtyall,
               OUTPUT tt1_soum    , OUTPUT tt1_um_conv).  /*20090605102535*/

          ASSIGN m_error  = NO
                 m_recid1 = RECID(tt1_det)
                 m_count  = 0.

          RUN ORDER-VALIDATION IN THIS-PROCEDURE.
          IF m_error THEN
          DO:
             ASSIGN               /* 20110412165415  */
             tt1_nbr = ""
             tt1_dataset = "".    /* 20110412165415  */
              UNDO detloop , RETRY detloop.
          END. /**IF m_error THEN**/

          ASSIGN m_trtype = (IF tt1_dataset = "sod_det" THEN "ISS-SO"
                             ELSE "ISS-DO,RCT-GIT")
                 m_error  = NO.

          RUN LOC-DET-EXP-VALIDATION IN THIS-PROCEDURE.

          IF m_error THEN
          DO:
             tt1_nbr = "".
             UNDO detloop , RETRY detloop.
          END. /**IF m_error THEN**/

          FIND FIRST tt4_det
               WHERE tt4_nbr  = tt1_nbr
                 AND tt4_part = tt1_part
                 AND tt4_line = tt1_line /* MK03 */
                 NO-ERROR.
          IF NOT AVAIL tt4_det THEN
          DO:
             CREATE tt4_det.
             ASSIGN tt4_nbr     = tt1_nbr
                    tt4_part    = tt1_part
                    tt4_line    = tt1_line /* MK03 */
                    tt4_qtyord  = tt1_qtyopn
                    /* tt4_qtyall  = 0 /* tt1_qtyall */ /* MK03 - Allocated quantity calculation correction */ */  /* ND091210 */
                    tt4_qtyall  = tt1_qtyall /* ND091210 */
                    tt4_cust    = tt1_cust
                    tt4_dataset = tt1_dataset.
          END. /**IF NOT AVAIL tt4_det THEN**/
          tt4_qtyall = tt4_qtyall + tt1_qtyiss.
      END. /**IF tt42_nbr <> "" THEN**/

      /* DELETE */
      IF LASTKEY = KEYCODE("F5") OR LASTKEY = KEYCODE("CTRL-D")
      THEN do:
         del-yn = no.
         /* Please confirm delete */
         {pxmsg.i &MSGNUM=11 &ERRORLEVEL=1 &CONFIRM=del-yn}
         IF del-yn THEN
         DO:
            FOR EACH tt4_det
                WHERE tt4_nbr  = tt1_nbr
                  AND tt4_part = tt1_part:
                tt4_qtyall = tt4_qtyall - tt1_qtyiss.
                IF tt4_qtyall < 0 THEN tt4_qtyall = 0.
            END. /**EACH tt4_nbr*/

            DELETE tt1_det.
            IF m_screen THEN DO:
               CLEAR FRAME a1h.
               n_count = n_count - 1. /*jackl 20090527133626*/
               Message "Sum to scan:" n_count. /*jackl 20090527133626*/
            END.
            ELSE
               CLEAR FRAME a1.
            UNDO detloop, RETRY detloop.
         END. /**IF del-yn THEN**/
      END. /**IF LASTKEY = KEYCODE("F5") OR LASTKEY = KEYCODE("CTRL-D")*/

      IF AVAIL tt4_det THEN
      DO:

          MESSAGE "O"  + STRING(tt4_qtyord , "->>,>>9.99" ) +
                  " A" + STRING(tt4_qtyall , "->>,>>9.99" ).

         IF tt4_qtyall > tt4_qtyord * ( 1 + (m_overshipct * 0.01))
         AND tt4_dataset = "sod_det" AND
         NOT CAN-FIND(FIRST CODE_mstr
                      WHERE CODE_domain  = GLOBAL_domain
                        AND CODE_fldname = "xx_so_overshipment_CUST_EXC"
                        AND CODE_value   = tt4_cust)
        THEN DO:
           ASSIGN tt1_nbr     = ""
                  tt1_dataset = ""
                  tt4_qtyall  = tt4_qtyall - tt1_qtyiss.

           MESSAGE m_mesdesc[40].
/*davidw:1959*/  RUN sendbell  IN THIS-PROCEDURE.
           UNDO detloop, RETRY detloop.
        END. /**IF tt4_qtyall > tt4_qtyord * ( 1 + (m_overshipct * 0.01)) THEN**/

      END. /**IF AVAIL tt4_det THEN**/

      IF m_screen THEN
         DOWN 1 WITH FRAME a1h.
      ELSE DOWN 1 WITH FRAME a1.
    END. /**END OF REPEAT**/

    IF NOT CAN-FIND(FIRST tt1_det WHERE tt1_qtyiss <> 0
                                    AND tt1_nbr  <> "") THEN
    DO:

        MESSAGE m_mesdesc[14].
/*davidw:1959*/  RUN sendbell  IN THIS-PROCEDURE.
       PAUSE.
       LEAVE mainloop.
    END. /**IF NOT CAN-FIND(FIRST tt1_det WHERE tt1_qtyiss <> 0 ) THEN**/

   /**Jack Li***ADD BEGIN***ECO:20120710171823**/
  IF NOT CAN-FIND(FIRST code_mstr NO-LOCK WHERE code_domain = global_domain  /*linas42955*/
                                            AND code_fldname = "xx_no_version_control" ) THEN DO:   /*linas42955*/

   for each tt1_det no-lock
             WHERE tt1_qtyiss <> 0  /*linas42955*/
              AND tt1_nbr  <> ""    /*linas42955*/
    break by tt1_nbr by tt1_line:
       if first-of(tt1_nbr) or first-of(tt1_line) then do:
          find first tr_hist no-lock where tr_domain = global_domain
                                       and tr_type = "ISS-SO"
                                       and tr_nbr  = tt1_nbr
                                       and string(tr_line) = tt1_line no-error.
          if available tr_hist then do:
             if substring(tr_serial,2,1) <> substring(tt1_syslot,2,1) then do:
                MESSAGE m_mesdesc[46].
                UNDO mainloop , RETRY mainloop.
             end.
          end.
       end.
    end.
  END. /* IF NOT CAN-FIND(FIRST code_mstr NO-LOCK */  /*linas42955*/
 
   /**Jack Li***ADDED END***ECO:20120710171823**/

    RUN STOCK-ALLOCATION IN THIS-PROCEDURE.

    n_count = 0. /*jackl 20090527133626*/

    IF NOT m_cimerr AND m_yn THEN DO:
       EMPTY TEMP-TABLE tt2_det.
       FOR EACH tt1_det
           WHERE tt1_qtyiss <> 0
             AND tt1_nbr    <> "" :

          FIND FIRST tt2_det
               WHERE tt2_part = tt1_part
                 AND tt2_lot  = tt1_syslot
                 AND tt2_site = tt1_site
                 AND tt2_loc  = tt1_loc NO-ERROR.
          IF NOT AVAIL tt2_det THEN
          DO:
             CREATE tt2_det.
             ASSIGN tt2_part = tt1_part
                    tt2_lot  = tt1_syslot
                    tt2_site = tt1_site
                    tt2_loc  = tt1_loc.
          END. /**IF NOT AVAIL tt2_det THEN**/
       END. /**EACH tt1_det **/

       PAUSE 0 BEFORE-HIDE.

       {gprun.i ""xxlotppc.p""}
       HIDE FRAME a NO-PAUSE.
    END. /**IF NOT m_cimerr THEN DO:**/
  END. /**END OF REPEAT**/

END. /**END SODOLINK-LOT**/

/***linas42955****mark begin***
PROCEDURE SODOLINK-PALLET:
  n_count = 0. /*jackl 20090527133626*/
  FORM
      tt2a_ref    COLUMN-LABEL {&xxictpc_p_10}
      VALIDATE(CAN-FIND(FIRST ld_det
                        WHERE ld_domain = GLOBAL_domain
                          AND ld_ref    = INPUT FRAME a1 tt2a_ref
                          AND ld__chr01 = "" NO-LOCK ) AND
               INPUT FRAME a1 tt2a_ref <> "" ,
               m_mesdesc[5])
      tt2a_part
      tt2a_um
      tt2a_qtyoh
      tt2a_site
      tt2a_nbr     COLUMN-LABEL {&xxictpc_p_19}
      VALIDATE(INPUT FRAME a1 tt2a_nbr <> "" ,
               m_mesdesc[4])
      WITH FRAME a1 DOWN.

  FORM
      tt2a_ref     COLUMN-LABEL {&xxictpc_p_10}
      VALIDATE(CAN-FIND(FIRST ld_det
                        WHERE ld_domain = GLOBAL_domain
                          AND ld_ref    = INPUT FRAME a1h tt2a_ref
                          AND ld__chr01 = "" NO-LOCK ) AND
               INPUT FRAME a1h tt2a_ref <> "",
               m_mesdesc[5])
      /***Jack Li *****DELETE******ECO:20110307095617
      tt2a_nbr     COLUMN-LABEL {&xxictpc_p_19} FORMAT "X(8)"
      VALIDATE(INPUT FRAME a1h tt2a_nbr <> "" ,
               m_mesdesc[4])  *******/
      m_soln COLUMN-LABEL "SO-Ln" FORMAT "X(11)"
      VALIDATE(INPUT FRAME a1h m_soln <> "",
      m_mesdesc[4] )  /*Jack Li *ECO:20110307095617*/
    WITH FRAME a1h DOWN.

  mainloop:
  REPEAT:
    EMPTY TEMP-TABLE tt2a_det.
    EMPTY TEMP-TABLE tt1_det.
    EMPTY TEMP-TABLE tt4_det.

    CLEAR FRAME a1 ALL NO-PAUSE.
    CLEAR FRAME a1h ALL NO-PAUSE.
    ASSIGN m_sonbr = ""
           m_sernbr = ""
           m_soln   = "".  /*Jack Li ECO:20110307095617*/

    detloop:
    REPEAT:

      IF m_screen THEN
      DO:
          PROMPT-FOR tt2a_ref
              WITH FRAME a1h EDITING:
              {mfnp.i tt2a_det tt2a_ref tt2a_ref tt2a_ref tt2a_ref
                      tt2a_ref}
               IF recno <> ? THEN
                  DISP tt2a_ref /*tt2a_nbr*/
                       m_soln /*Jack Li ECO:20110307095617*/
                       WITH FRAME a1h.
          END. /**ROMPT-FOR tt12_lot**/
      END. /**HHT SCREEN**/
      ELSE DO:
          PROMPT-FOR tt2a_ref
              WITH FRAME a1 EDITING:
              {mfnp.i tt2a_det tt2a_ref tt2a_ref tt2a_ref tt2a_ref
                      tt2a_ref}
               IF recno <> ? THEN
                  DISP tt2a_ref tt2a_part tt2a_um tt2a_qtyoh tt2a_site tt2a_nbr
                       WITH FRAME a1.
          END. /**PROMPT-FOR tt12_lot**/

      END. /**MFG/PRO SCREEN**/

      ASSIGN m_part   = ""
             m_site   = ""
             m_loc    = ""
             m_lot    = ""
             m_syslot = ""
             m_ref    = (IF m_screen THEN INPUT FRAME a1h tt2a_ref
                         ELSE INPUT FRAME a1 tt2a_ref )
             m_sernbr = m_ref
             m_nbr    = ""
             m_recid  = ?
             gpglef   = 0
             m_trtype = ""
             m_soln   = "" /*Jack Li ECO:20110307095617*/
             m_error  = NO.

      RUN GET-ITEM-FROM-LOTREF IN THIS-PROCEDURE.

      IF m_error THEN
         UNDO detloop , RETRY detloop.

      IF CAN-FIND(FIRST ld_det
           WHERE ld_domain = GLOBAL_domain
             AND ld_ref    = m_ref
             AND ld__chr01 <> ""
             AND TRUNCATE(ld_qty_oh , 3) <> 0 NO-LOCK ) THEN
      DO:
          MESSAGE m_mesdesc[30].
/*davidw:1959*/  RUN sendbell  IN THIS-PROCEDURE.
          UNDO detloop , RETRY detloop.
      END. /**CAN-FIND(FIRST ld_det)***/

      FIND FIRST tt2a_det
           WHERE tt2a_ref  = m_ref NO-ERROR.
      IF NOT AVAIL tt2a_det THEN
      DO:
         CREATE tt2a_det.
         ASSIGN tt2a_ref   = m_ref
                tt2a_nbr   = m_sonbr.
         n_count = n_count + 1. /*jackl 20090527133626*/
      END. /**IF NOT AVAIL tt2a_det THEN**/

      IF m_screen THEN
         DISP tt2a_ref /*tt2a_nbr*/ m_soln /*Jack Li ECO:20110307095617*/
                 WITH FRAME a1h.
      ELSE DISP tt2a_ref tt2a_part tt2a_um tt2a_qtyoh tt2a_site tt2a_nbr
                WITH FRAME a1.

      IF m_screen THEN DO:
         /*Jack Li ***DELETE*ECO:20110307095617
         UPDATE tt2a_nbr
                GO-ON (CTRL-D F5) WITH FRAME a1h DOWN. ****/
         /*Jack Li *ECO:20110307095617*/
         UPDATE m_soln
                GO-ON (CTRL-D F5) WITH FRAME a1h DOWN.
         Message "Sum to scan:" n_count. /*jackl 20090527133626*/
      END.
      ELSE
         UPDATE tt2a_nbr
                GO-ON (CTRL-D F5) WITH FRAME a1 DOWN.

      /*Jack Li *BEGIN ADD****ECO:20110307095617*/
      tt2a_nbr  = SUBSTRING(m_soln,1,R-INDEX(m_soln,"-") - 1).
    m_soline  = INT(TRIM(SUBSTRING(m_soln,R-INDEX(m_soln,"-") + 1))) NO-ERROR.

      IF ERROR-STATUS:ERROR THEN DO:
         {pxmsg.i &MSGNUM=642 &ERRORLEVEL=3 }
         UNDO detloop , RETRY detloop.
      END.

      ASSIGN m__chr01 = ''.
      EMPTY TEMP-TABLE tts21_det.

      FIND FIRST so_mstr WHERE so_domain = GLOBAL_domain
                           AND so_nbr = tt2a_nbr NO-LOCK NO-ERROR.
      IF AVAIL so_mstr THEN DO:
         FIND FIRST sod_det WHERE sod_domain = GLOBAL_domain
                              AND sod_nbr = so_nbr
                              AND sod_line = m_soline NO-LOCK NO-ERROR.
         IF AVAIL sod_det THEN DO:
            ASSIGN m__chr01 = sod__chr01.

/*david:1006*/ if  m__chr01 <> "" and length(tt1_syslot) > 9 then do:

            DO m_slline  = 1 TO NUM-ENTRIES(m__chr01 , "@") :
               ASSIGN m_slitdet = ENTRY(m_slline , m__chr01 , "@")
                      m_data    = "".

               DO m_sernbr1  = 1 TO NUM-ENTRIES(m_slitdet , "^") :
                  m_data[m_sernbr1] = ENTRY(m_sernbr1 , m_slitdet , "^").
               END. /**DO m_sernbr  = 1 TO NUM-ENTRIES(m_slitdet , "^")**/

               FIND FIRST tts21_det
                    WHERE tts21_line   = INT(m_data[1])
                    AND tts21_srnbr  = INT(m_data[2]) NO-ERROR.
               IF NOT AVAIL tts21_det THEN DO:
                  CREATE tts21_det.
                  ASSIGN tts21_line     = INT(m_data[1])
                         tts21_srnbr    = INT(m_data[2])
                         tts21_rolls    = INT(m_data[5])
                         tts21_width    = DEC(m_data[6])
                         tts21_length   = DEC(m_data[7]).

                  IF tts21_width = 0  THEN DO:
                     FIND FIRST pt_mstr WHERE pt_domain = GLOBAL_domain
                            AND pt_part = sod_part NO-LOCK NO-ERROR.
                     IF AVAILABLE pt_mstr THEN tts21_width = pt__dec01.
                  END.

                  IF tts21_length = 0  THEN DO:
                     FIND FIRST pt_mstr WHERE pt_domain = GLOBAL_domain
                            AND pt_part = sod_part NO-LOCK NO-ERROR.
                     IF AVAILABLE pt_mstr THEN tts21_length = pt__dec02.
                  END.
               END. /* NOT AVAIL tts21_det */
            END. /* DO m_slline  = 1 */

/*david:1006*/  end.  /* tt1_syslot  > 9 */

         END. /***available sod_det*/
      END. /**avail so_mstr*/
      /*Jack Li *END ADDED***ECO:20110307095617*/


      m_sonbr = tt2a_nbr.

      IF tt2a_nbr <> "" AND tt2a_dataset = "" THEN
      DO:
          FOR EACH ld_det
              FIELDS(ld_part ld_site ld_loc ld_lot ld_ref ld_qty_oh
                     ld__chr01)
               WHERE ld_domain = GLOBAL_domain
                 AND ld_ref    = tt2a_ref
                 AND ld_site   = m_site
                 AND ld_loc    = m_loc
                 AND ld__chr01 = ""
                 AND TRUNCATE(ld_qty_oh , 3) <> 0 NO-LOCK :

              /***Jack Li****ADD BEGIN******ECO:TEMP***/
               FIND FIRST ds_det NO-LOCK WHERE ds_domain = global_domain
                                           AND ds_nbr    = tt2a_nbr
                                           AND ds_part   = ld_part NO-ERROR.
               IF AVAILABLE ds_det THEN DO:
                  m_soline = INT(ds_req_nbr) NO-ERROR.
               END.
              /***Jack Li****ADDED END******ECO:TEMP***/

              assign m_soum = ""                       /*20090605102535*/
                     m_um_conv = 1.                    /*20090605102535*/

              /****Jack Li***BEGIN ADD**ECO:20110307095617*/
               RUN GET-ORDER-DETAILS2 IN THIS-PROCEDURE
                   (INPUT tt2a_nbr      , INPUT ld_part ,
                    INPUT string(m_soline) ,
                    OUTPUT tt2a_dataset , OUTPUT tt2a_qtyopn, OUTPUT tt2a_cust ,
                    OUTPUT tt2a_recsite , OUTPUT tt2a_qtyall,
                    OUTPUT m_soum    , OUTPUT m_um_conv,
		     OUTPUT m_chr01_a ). /*linas42955*/

            /****Jack Li***BEGIN ADD**ECO:20110307095617*/
             tt2a_line = string(m_soline).

            /****Jack Li***BEGIN DELETE**ECO:20110307095617*
              RUN GET-ORDER-DETAILS IN THIS-PROCEDURE
                 (INPUT tt2a_nbr      , INPUT ld_part      , OUTPUT tt2a_line ,
                  OUTPUT tt2a_dataset , OUTPUT tt2a_qtyopn , OUTPUT tt2a_cust ,
                  OUTPUT tt2a_recsite , OUTPUT tt2a_qtyall,
                      OUTPUT   m_soum    , OUTPUT   m_um_conv).  /*20090605102535*/
            ****Jack Li***END DELETED**ECO:20110307095617*/

              ASSIGN m_recid  = RECID(ld_det)
                     m_trtype = (IF tt2a_dataset = "sod_det" THEN "ISS-SO"
                                 ELSE "ISS-DO,RCT-GIT")
                     m_error  = NO.

              RUN LOC-DET-EXP-VALIDATION IN THIS-PROCEDURE.

              IF m_error THEN
                 LEAVE.

              FIND FIRST tt1_det
                   WHERE tt1_lot   = ld_lot
                     AND tt1_ref   = ld_ref
                     AND tt1_site  = ld_site
                     AND tt1_loc   = ld_loc
                     AND tt1_part  = ld_part NO-ERROR.
              IF NOT AVAIL tt1_det THEN
              DO:
                 CREATE tt1_det.
                 ASSIGN tt1_lot    = ld_lot
                        tt1_syslot = ld_lot
                        tt1_ref    = ld_ref
                        tt1_ref1   = ld_ref
                        tt1_site   = ld_site
                        tt1_loc    = ld_loc
                        tt1_loc1   = ld_loc
                        tt1_part   = ld_part
                        tt1_qtyiss = ld_qty_oh.
                 {xxqtylim.i tt1_qtyiss}
              END. /**IF NOT AVAIL tt1_det THEN**/
              ASSIGN tt1_dataset  = tt2a_dataset
                     tt1_recsite  = tt2a_recsite
                     tt1_line     = /*tt2a_line*/  string(m_soline)
                     tt1_nbr      = tt2a_nbr
                     tt1_soum     = m_soum                 /*20090605102535*/
                     tt1_um_conv  = m_um_conv              /*20090605102535*/
                     m_error  = NO
                     m_recid1 = RECID(tt1_det)
                     m_count  = 0.

              RUN ORDER-VALIDATION IN THIS-PROCEDURE.

              IF m_error THEN
                  LEAVE.

              FIND FIRST tt4_det
                   WHERE tt4_nbr  = tt2a_nbr
                     AND tt4_line = string(m_soline) /*Jack Li **ECO:20110307095617*/
                     AND tt4_part = ld_part NO-ERROR.
              IF NOT AVAIL tt4_det THEN
              DO:
                 CREATE tt4_det.
                 ASSIGN tt4_nbr    = tt2a_nbr
                        tt4_line   = string(m_soline) /*Jack Li **ECO:20110307095617*/
                        tt4_part   = ld_part
                        tt4_qtyord = tt2a_qtyopn
                        tt4_qtyall = 0 /* tt2a_qtyall - MK03 */
                        tt4_cust    = tt2a_cust
                        tt4_dataset = tt2a_dataset.
              END. /**IF NOT AVAIL tt4_det THEN**/
              tt4_qtyall = tt4_qtyall + ld_qty_oh.
              {xxqtylim.i tt4_qtyall}


              IF tt4_qtyall > tt4_qtyord * ( 1 + (m_overshipct * 0.01))
               AND tt4_dataset = "sod_det" AND
               NOT CAN-FIND(FIRST CODE_mstr
                           WHERE CODE_domain  = GLOBAL_domain
                             AND CODE_fldname = "xx_so_overshipment_CUST_EXC"
                             AND CODE_value   = tt4_cust)
              THEN DO:
                 m_error = YES.
                 MESSAGE m_mesdesc[40].
/*davidw:1959*/  RUN sendbell  IN THIS-PROCEDURE.
                 LEAVE.
              END. /**IF tt4_qtyall > tt4_qtyord * ( 1 + (m_overshipct * 0.01)) THEN**/

          END. /**EACH ld_det**/

          /**Jack Li ***BEGIN ADD***ECO:20110307095617*/
          ASSIGN m_qtytol = 0.
          EMPTY TEMP-TABLE ttrs_det.

          FOR EACH tt1_det where tt1_nbr = tt2a_nbr
                             and tt1_line = string(m_soline):
              FIND FIRST ttrs_det WHERE ttrs_wid
                   = DEC(SUBSTRING(tt1_syslot, 10,4)) NO-ERROR.
              IF NOT AVAILABLE ttrs_det THEN DO:
                 CREATE ttrs_det.
                 ASSIGN ttrs_wid = DEC(SUBSTRING(tt1_syslot, 10,4))
                        ttrs_qty = tt1_qtyiss
                        ttrs_qtytol = 0.
                 FIND FIRST tts21_det WHERE tts21_width =
                      DEC(SUBSTRING(tt1_syslot, 10,4)) NO-LOCK NO-ERROR.
                 IF AVAILABLE tts21_det THEN DO:
                    ttrs_qtytol = tts21_roll * tts21_width
                                * tts21_length / 1000.
                 END.
              END.
              ELSE DO:
                 ttrs_qty = ttrs_qty + tt1_qtyiss.
              END.
          END.

          FOR EACH tt1_det where tt1_nbr = tt2a_nbr
                             and tt1_line = string(m_soline)
                             and tt1_dataset = "sod_det":
              FIND FIRST tts21_det  NO-LOCK NO-ERROR.
              IF NOT AVAIL tts21_det THEN DO:
                 FIND FIRST pt_mstr WHERE pt_domain = GLOBAL_domain
                        AND pt_part = tt1_part NO-LOCK NO-ERROR.
                 IF AVAILABLE pt_mstr THEN DO:
                    IF  pt__dec01 <> DEC(SUBSTRING(tt1_syslot, 10,4)) 
		        AND DEC(SUBSTRING(tt1_syslot, 10,4)) > 0 THEN /*Jihui 20140206*/
                    DO:
                        m_error = YES.
                        MESSAGE m_mesdesc[47].
                        UNDO detloop , RETRY detloop. 
                    END.
                 END. /*if avail pt_mstr */
              END. /*if not avail*/
              ELSE DO:
                FIND FIRST tts21_det WHERE tts21_width =
                 DEC(SUBSTRING(tt1_syslot, 10,4)) AND
		 DEC(SUBSTRING(tt1_syslot, 10,4)) > 0  /*Jihui 20140206*/
		 NO-LOCK NO-ERROR.
                IF NOT AVAILABLE tts21_det THEN DO:
                   m_error = YES.
                   MESSAGE m_mesdesc[47].
                   UNDO detloop , RETRY detloop. 
                END.
                ELSE DO:
                   IF DEC(SUBSTRING(tt1_syslot, 14,5)) <> tts21_length  THEN
                      MESSAGE m_mesdesc[48].
                END.
              END. /* if avail tts21_det */

              FOR EACH ld_det NO-LOCK WHERE ld_domain = global_domain
                                        and ld_part   = tt1_part
                                        and ld__chr01 = tt1_nbr
                                        and ld__chr04 = tt1_line
                                        and DEC(SUBSTRING(ld_lot, 10,4))
                                        = DEC(SUBSTRING(tt1_syslot, 10,4)):

              END.

           m_qtytol = 0.
           FOR EACH ttrs_det NO-LOCK:
              FOR EACH ld_det NO-LOCK WHERE ld_domain = global_domain
                   and ld__chr01 = tt1_nbr
                   and ld__chr04 = tt1_line
                   and DEC(SUBSTRING(ld_lot, 10,4)) = ttrs_wid:
                   m_qtytol = m_qtytol + ld_qty_oh.
              END.

              FOR EACH tr_hist NO-LOCK WHERE tr_domain = global_domain
                                         and (tr_type   = "ISS-SO"
                                          or tr_type    = "ISS-DO")
                                         and tr_nbr    = tt1_nbr
                                         and INT(tr_line) = INT(tt1_line)
                       and DEC(SUBSTRING(tr_serial, 10,4)) = ttrs_wid:
                  m_qtytol = m_qtytol - tr_qty_loc.
              END.

              IF ttrs_qty + m_qtytol > ttrs_qtytol THEN DO:
                 m_error = YES.
                 MESSAGE "Error: Shipping Ord < Pallet".
                 UNDO detloop , RETRY detloop.
              END.
           END.
          END.

          /**Jack Li ***END ADDED***ECO:20110307095617*/
          IF m_error THEN
          DO:
             FOR EACH tt1_det
                 WHERE tt1_ref = tt2a_ref :
               FOR EACH tt4_det
                   WHERE tt4_nbr  = tt2a_nbr :
                 tt4_qtyall = tt4_qtyall - tt1_qtyiss.
                 IF tt4_qtyall < 0 THEN
                    tt4_qtyall = 0.
               END. /**EACH tt4_det **/

               DELETE tt1_det.
             END. /**EACH tt1_det**/
             ASSIGN tt2a_nbr     = ""
                    tt2a_dataset = "".
             UNDO detloop , RETRY detloop.
          END. /**IF m_error THEN**/

      END. /**IF tt2a_nbr <> "" THEN**/

      /* DELETE */
      IF LASTKEY = KEYCODE("F5") OR LASTKEY = KEYCODE("CTRL-D")
      THEN do:
           del-yn = no.
           /* Please confirm delete */
           {pxmsg.i &MSGNUM=11 &ERRORLEVEL=1 &CONFIRM=del-yn}
           IF del-yn THEN
           DO:
              FOR EACH tt4_det
                  WHERE tt4_nbr  = tt2a_nbr :
                 tt4_qtyall = tt4_qtyall - tt2a_qtyoh.
                 IF tt4_qtyall < 0 THEN
                    tt4_qtyall = 0.
              END. /**EACH tt4_det **/

              FOR EACH tt1_det
                  WHERE tt1_ref = tt2a_ref:
                  DELETE tt1_det.
              END. /**EACH tt1_det**/

              DELETE tt2a_det.
              IF m_screen THEN DO:
                 CLEAR FRAME a1h.
                 n_count = n_count - 1. /*jackl 20090527133626*/
                 Message "Sum to scan:" n_count. /*jackl 20090527133626*/
              END.
              ELSE
                 CLEAR FRAME a1.
              UNDO detloop, RETRY detloop.
           END. /**IF del-yn THEN**/
      END. /**IF LASTKEY = KEYCODE("F5") OR LASTKEY = KEYCODE("CTRL-D")*/

      FOR EACH tt4_det where tt4_nbr = m_sonbr
                         and tt4_line = string(m_soline):
          MESSAGE "O"  + STRING(tt4_qtyord , "->>,>>9.99" ) +
                  " A" + STRING(tt4_qtyall , "->>,>>9.99" ).
      END. /**EACH tt4_det**/

      IF m_screen THEN
         DOWN 1 WITH FRAME a1h.
      ELSE DOWN 1 WITH FRAME a1.
    END. /**END OF REPEAT**/

    IF NOT CAN-FIND(FIRST tt1_det WHERE tt1_qtyiss <> 0
                                     AND tt1_nbr  <> ""  ) THEN
    DO:
       MESSAGE m_mesdesc[14].
/*davidw:1959*/  RUN sendbell  IN THIS-PROCEDURE.
       PAUSE.
       LEAVE mainloop.
    END. /**IF NOT CAN-FIND(FIRST tt1_det WHERE tt1_qtyiss <> 0 ) THEN**/

    RUN STOCK-ALLOCATION IN THIS-PROCEDURE.
    n_count = 0. /*jackl 20090527133626*/

    IF NOT m_cimerr AND m_yn THEN DO:
       m_prttype = 1.  /*20130313104409*/
       PAUSE 0 BEFORE-HIDE.
         /* {gprun.i ""xxpltppc.p""} */    /* jerryg ECO:105119 */
/* jerryg add start ECO:105119 */
         IF m_epsma THEN DO:
            {gprun.i ""xxapltppc.p""}
         END. /* IF m_epsma */
         ELSE DO:
           /***Jihui 20140205165345 Begin***/
           FIND FIRST code_mstr where code_domain = global_domain
	               and code_fldname = "xx_pallet_creation"
                       and code_value = "CHN"
                       no-lock no-error.
           IF AVAIL code_mstr then
             {gprun.i ""xxpltppccn.p""}
           ELSE
           /***Jihui 20140205165345 END ***/
             {gprun.i ""xxpltppc.p""}

         END. /* ELSE DO: */
/* jerryg add end ECO:105119 */
       HIDE FRAME a NO-PAUSE.
    END. /**IF NOT m_cimerr THEN DO:**/

  END. /**END OF REPEAT**/

END. /**SODOLINK-PALLET**/

*linas42955***MARK END***/


/*line 5500 - 6000*/
PROCEDURE SODOLINK-PALLET:
  n_count = 0. /*jackl 20090527133626*/
  FORM
      tt2a_ref    COLUMN-LABEL {&xxictpc_p_10}
      VALIDATE(CAN-FIND(FIRST ld_det
                        WHERE ld_domain = GLOBAL_domain
                          AND ld_ref    = INPUT FRAME a1 tt2a_ref
                          AND ld__chr01 = "" NO-LOCK ) AND
               INPUT FRAME a1 tt2a_ref <> "" ,
               m_mesdesc[5])
      tt2a_part
      tt2a_um
      tt2a_qtyoh
      tt2a_site
      tt2a_nbr     COLUMN-LABEL {&xxictpc_p_19}
      VALIDATE(INPUT FRAME a1 tt2a_nbr <> "" ,
               m_mesdesc[4])
      WITH FRAME a1 DOWN.

  FORM
      tt2a_ref     COLUMN-LABEL {&xxictpc_p_10}
      VALIDATE(CAN-FIND(FIRST ld_det
                        WHERE ld_domain = GLOBAL_domain
                          AND ld_ref    = INPUT FRAME a1h tt2a_ref
                          AND ld__chr01 = "" NO-LOCK ) AND
               INPUT FRAME a1h tt2a_ref <> "",
               m_mesdesc[5])
      tt2a_nbr     COLUMN-LABEL {&xxictpc_p_19} FORMAT "X(8)"
      VALIDATE(INPUT FRAME a1h tt2a_nbr <> "" ,
               m_mesdesc[4]) 
    WITH FRAME a1h DOWN.

  mainloop:
  REPEAT:
    EMPTY TEMP-TABLE tt2a_det.
    EMPTY TEMP-TABLE tt1_det.
    EMPTY TEMP-TABLE tt4_det.

    CLEAR FRAME a1 ALL NO-PAUSE.
    CLEAR FRAME a1h ALL NO-PAUSE.
    ASSIGN m_sonbr = ""
           m_sernbr = ""
           m_soln   = "".  /*Jack Li ECO:20110307095617*/

    detloop:
    REPEAT:

      IF m_screen THEN
      DO:
          PROMPT-FOR tt2a_ref
              WITH FRAME a1h EDITING:
              {mfnp.i tt2a_det tt2a_ref tt2a_ref tt2a_ref tt2a_ref
                      tt2a_ref}
               IF recno <> ? THEN
                  DISP tt2a_ref 
		  tt2a_nbr  
                       WITH FRAME a1h.
          END. /**ROMPT-FOR tt12_lot**/
      END. /**HHT SCREEN**/
      ELSE DO:
          PROMPT-FOR tt2a_ref
              WITH FRAME a1 EDITING:
              {mfnp.i tt2a_det tt2a_ref tt2a_ref tt2a_ref tt2a_ref
                      tt2a_ref}
               IF recno <> ? THEN
                  DISP tt2a_ref tt2a_part tt2a_um tt2a_qtyoh tt2a_site tt2a_nbr
                       WITH FRAME a1.
          END. /**PROMPT-FOR tt12_lot**/

      END. /**MFG/PRO SCREEN**/

      ASSIGN m_part   = ""
             m_site   = ""
             m_loc    = ""
             m_lot    = ""
             m_syslot = ""
             m_ref    = (IF m_screen THEN INPUT FRAME a1h tt2a_ref
                         ELSE INPUT FRAME a1 tt2a_ref )
             m_sernbr = m_ref
             m_nbr    = ""
             m_recid  = ?
             gpglef   = 0
             m_trtype = ""
             m_soln   = "" /*Jack Li ECO:20110307095617*/
             m_error  = NO.

      RUN GET-ITEM-FROM-LOTREF IN THIS-PROCEDURE.

      IF m_error THEN
         UNDO detloop , RETRY detloop.

      IF CAN-FIND(FIRST ld_det
           WHERE ld_domain = GLOBAL_domain
             AND ld_ref    = m_ref
             AND ld__chr01 <> ""
             AND TRUNCATE(ld_qty_oh , 3) <> 0 NO-LOCK ) THEN
      DO:
          MESSAGE m_mesdesc[30].
/*davidw:1959*/  RUN sendbell  IN THIS-PROCEDURE.
          UNDO detloop , RETRY detloop.
      END. /**CAN-FIND(FIRST ld_det)***/

      FIND FIRST tt2a_det
           WHERE tt2a_ref  = m_ref NO-ERROR.
      IF NOT AVAIL tt2a_det THEN
      DO:
         CREATE tt2a_det.
         ASSIGN tt2a_ref   = m_ref
                tt2a_nbr   = m_sonbr.
         n_count = n_count + 1. /*jackl 20090527133626*/
      END. /**IF NOT AVAIL tt2a_det THEN**/

      IF m_screen THEN
         DISP tt2a_ref  tt2a_nbr 
                 WITH FRAME a1h.
      ELSE DISP tt2a_ref tt2a_part tt2a_um tt2a_qtyoh tt2a_site tt2a_nbr
                WITH FRAME a1.


        m_sonbr = tt2a_nbr. /*linas42955*/

      IF m_screen THEN DO:
         UPDATE tt2a_nbr
                GO-ON (CTRL-D F5) WITH FRAME a1h DOWN.
         Message "Sum to scan:" n_count. /*jackl 20090527133626*/
      END.
      ELSE
         UPDATE tt2a_nbr
                GO-ON (CTRL-D F5) WITH FRAME a1 DOWN.


     empty temp-table tt4_det. /**linas42955*/

      IF ( tt2a_nbr <> "" AND tt2a_dataset = ""  )
         OR tt2a_nbr <> m_sonbr /*linas42955*/
      THEN DO:

         m_sonbr = tt2a_nbr.

	  FOR EACH ld_det
              FIELDS(ld_part ld_site ld_loc ld_lot ld_ref ld_qty_oh
                     ld__chr01)
               WHERE ld_domain = GLOBAL_domain
                 AND ld_ref    = tt2a_ref
                 AND ld_site   = m_site
                 AND ld_loc    = m_loc
                 AND ld__chr01 = ""
                 AND TRUNCATE(ld_qty_oh , 3) <> 0 NO-LOCK 
		 BREAK BY ld_part:

		 IF FIRST-OF(ld_part) AND DUMPLICATE-SOLINE(tt2a_nbr,ld_part) > 1 then DO:
		     MESSAGE "ERROR: Duplicate Line for same Item."  string(DUMPLICATE-SOLINE(tt2a_nbr,ld_part)).
		     m_error = yes.
		     LEAVE.
		 END.

                  tt2a_line =  "".
               assign m_soum = ""                       /*20090605102535*/
                     m_um_conv = 1.                    /*20090605102535*/

               RUN GET-ORDER-DETAILS2 IN THIS-PROCEDURE
                   (INPUT tt2a_nbr      , INPUT ld_part ,
                    INPUT-OUTPUT tt2a_line ,
                    OUTPUT tt2a_dataset , OUTPUT tt2a_qtyopn, OUTPUT tt2a_cust ,
                    OUTPUT tt2a_recsite , OUTPUT tt2a_qtyall,
                    OUTPUT m_soum    , OUTPUT m_um_conv,
		     OUTPUT m_chr01_a ). /*linas42955*/

	    /*linas42955 BEGIN*/

              if tt2a_line = "" THEN DO:  
		     MESSAGE "ERR:Item MisMatch " ld_part.
		     m_error = yes.
		     LEAVE.
	      END. 

	    /*linas42955 END*/

              ASSIGN m_recid  = RECID(ld_det)
                     m_trtype = (IF tt2a_dataset = "sod_det" THEN "ISS-SO"
                                 ELSE "ISS-DO,RCT-GIT")
                     m_error  = NO.

              RUN LOC-DET-EXP-VALIDATION IN THIS-PROCEDURE.

              IF m_error THEN
                 LEAVE.

           EMPTY TEMP-TABLE tts21_det.

            DO m_slline  = 1 TO NUM-ENTRIES(m_chr01_a , "@") :
                 ASSIGN m_slitdet = ENTRY(m_slline , m_chr01_a , "@")
                        m_data    = "".
                 DO m_sernbr1  = 1 TO NUM-ENTRIES(m_slitdet , "^") :
                    m_data[m_sernbr1] = ENTRY(m_sernbr1 , m_slitdet , "^").
                 END. /**DO m_sernbr  = 1 TO NUM-ENTRIES(m_slitdet , "^")**/
                /* IF m_data[4] = "T" THEN NEXT. /* Type T */ maha220211*/

                FIND FIRST tts21_det
                  WHERE tts21_line   = INT(m_data[1])
                    AND tts21_srnbr  = INT(m_data[2]) NO-ERROR.
                 IF NOT AVAIL tts21_det THEN
                 DO:
                    CREATE tts21_det.
                    ASSIGN tts21_line     = INT(m_data[1])
                           tts21_srnbr    = INT(m_data[2])
                           tts21_rolls    = INT(m_data[5])
                           tts21_width    = DEC(m_data[6])
                           tts21_length   = DEC(m_data[7]).
                    /*maha14112010*/
                    IF tts21_width = 0  THEN
                    DO:
                        FIND FIRST pt_mstr WHERE pt_domain = GLOBAL_domain 
                                             AND pt_part = ld_part 
                                             NO-LOCK NO-ERROR.
                        IF AVAILABLE pt_mstr THEN tts21_width = pt__dec01.
                    END.
                    IF tts21_length = 0  THEN
                    DO:
                        FIND FIRST pt_mstr WHERE pt_domain = GLOBAL_domain 
                                             AND pt_part = ld_part 
                                             NO-LOCK NO-ERROR.
                        IF AVAILABLE pt_mstr THEN tts21_length = pt__dec02.
                    END.
                    /*maha14112010*/
                 END. /* NOT AVAIL tts21_det */
            END. /* DO m_slline  = 1 */

/*linas20140205 begin **/
/*linas20140214084642***MARK BEGIN*****
*              FIND FIRST tts21_det  NO-LOCK NO-ERROR.
*              IF NOT AVAIL tts21_det THEN DO:
*
*                 FIND FIRST pt_mstr WHERE pt_domain = GLOBAL_domain
*                        AND pt_part = ld_part  NO-LOCK NO-ERROR.
*                 IF AVAILABLE pt_mstr THEN DO:
*                    IF  pt__dec01 <> DEC(SUBSTRING(ld_lot,10,4)) 
*		        AND DEC(SUBSTRING(ld_lot,10,4)) > 0 THEN
*                    DO:
*                        m_error = YES.
*			
*			MESSAGE m_mesdesc[47] SUBSTR(ld_lot,1,9) + " " +
*		                           SUBSTR(ld_lot,10,4) + " " +
*					   SUBSTR(ld_lot,14,5) + " " +
*					   ld_part.
*                  /*      UNDO detloop , RETRY detloop. linas42955*/
*                          LEAVE.  /*linas42955*/
*                    END.
*                 END. /*if avail pt_mstr */
*              END. /*if not avail*/
*              ELSE DO:
*linas20140214084642***MARK END*/
/*linas84642*/ FIND FIRST tts21_det  NO-LOCK NO-ERROR.   
/*linas84642*/ IF  AVAILABLE tts21_det AND length(ld_lot) >= 13 THEN DO:  

               FIND FIRST tts21_det WHERE tts21_width =
                DEC(SUBSTRING(ld_lot,10,4)) 
		 AND DEC(SUBSTRING(ld_lot,10,4)) > 0 
		 NO-LOCK NO-ERROR.

              IF NOT AVAILABLE tts21_det THEN DO:
                  m_error = YES.
		   
                  MESSAGE m_mesdesc[47] SUBSTR(ld_lot,1,9) + " " +
		                           SUBSTR(ld_lot,10,4) + " " +
					   SUBSTR(ld_lot,14,5) + " " +
					   ld_part.
                         LEAVE.  /*linas42955*/
               END.
               ELSE DO:
                  IF DEC(SUBSTRING(ld_lot ,14,5)) <> tts21_length  THEN
                     MESSAGE m_mesdesc[48].
               END.
               END. /* if avail tts21_det */

/*linas20140205 END */    

               IF NOT CAN-FIND(FIRST code_mstr NO-LOCK WHERE code_domain = global_domain  
                                 AND code_fldname = "xx_no_version_control" ) 
				 and available tt2a_det
				 and tt2a_nbr <> "" THEN DO:   
                     find first tr_hist no-lock where tr_domain = global_domain
                                                  and tr_type = "ISS-SO"
                                                  and tr_nbr  = tt2a_nbr
                                                  and string(tr_line) = tt2a_line no-error.
                     if available tr_hist and substring(tr_serial,2,1) <> substring(ld_lot,2,1) then do:
                           m_error = YES.
                           MESSAGE m_mesdesc[46].
			   leave.
                     end. /* if available tr_hist */ 
               END. /* IF NOT CAN-FIND(FIRST code_mstr  */


              FIND FIRST tt1_det
                   WHERE tt1_lot   = ld_lot
                     AND tt1_ref   = ld_ref
                     AND tt1_site  = ld_site
                     AND tt1_loc   = ld_loc
                     AND tt1_part  = ld_part NO-ERROR.
              IF NOT AVAIL tt1_det THEN
              DO:
                 CREATE tt1_det.
                 ASSIGN tt1_lot    = ld_lot
                        tt1_syslot = ld_lot
                        tt1_ref    = ld_ref
                        tt1_ref1   = ld_ref
                        tt1_site   = ld_site
                        tt1_loc    = ld_loc
                        tt1_loc1   = ld_loc
                        tt1_part   = ld_part
                        tt1_qtyiss = ld_qty_oh.
                 {xxqtylim.i tt1_qtyiss}
              END. /**IF NOT AVAIL tt1_det THEN**/
              ASSIGN tt1_dataset  = tt2a_dataset
                     tt1_recsite  = tt2a_recsite
                     tt1_line     = tt2a_line 
                     tt1_nbr      = tt2a_nbr
                     tt1_soum     = m_soum                 /*20090605102535*/
                     tt1_um_conv  = m_um_conv              /*20090605102535*/
                     m_error  = NO
                     m_recid1 = RECID(tt1_det)
                     m_count  = 0.


              RUN ORDER-VALIDATION IN THIS-PROCEDURE.

              IF m_error THEN
                  LEAVE.

              FIND FIRST tt4_det
                   WHERE tt4_nbr  = tt2a_nbr
                     AND tt4_line = tt2a_line 
                     AND tt4_part = ld_part NO-ERROR.
              IF NOT AVAIL tt4_det THEN
              DO:
                 CREATE tt4_det.
                 ASSIGN tt4_nbr    = tt2a_nbr
                        tt4_line   = tt2a_line
                        tt4_part   = ld_part
                        tt4_qtyord = tt2a_qtyopn
                        tt4_qtyall = 0 /* tt2a_qtyall - MK03 */
                        tt4_cust    = tt2a_cust
                        tt4_dataset = tt2a_dataset.
              END. /**IF NOT AVAIL tt4_det THEN**/
              tt4_qtyall = tt4_qtyall + ld_qty_oh.
              {xxqtylim.i tt4_qtyall}

              IF tt4_qtyall > tt4_qtyord * ( 1 + (m_overshipct * 0.01))
               AND tt4_dataset = "sod_det" AND
               NOT CAN-FIND(FIRST CODE_mstr
                           WHERE CODE_domain  = GLOBAL_domain
                             AND CODE_fldname = "xx_so_overshipment_CUST_EXC"
                             AND CODE_value   = tt4_cust)
              THEN DO:
                 m_error = YES.
                 MESSAGE m_mesdesc[40].
/*davidw:1959*/  RUN sendbell  IN THIS-PROCEDURE.
                 LEAVE.
              END. /**IF tt4_qtyall > tt4_qtyord * ( 1 + (m_overshipct * 0.01)) THEN**/

          END. /**EACH ld_det**/

          
          m_ver = "".            
          FOR EACH tt1_det where tt1_nbr = tt2a_nbr
                /*             and tt1_line =  string(m_soline) **linas131212*/  
                             and tt1_dataset = "sod_det"
/*LINAS42955*BEGIN*/
			     break by tt1_nbr
			     by tt1_line
			     by substring(tt1_syslot,2,1):

             if first-of(tt1_line) then m_ver = substring(tt1_syslot,2,1).
	     if last-of(tt1_line) then do:


	           if substring(tt1_syslot,2,1) <> m_ver 
		     AND NOT CAN-FIND(FIRST code_mstr no-lock where code_domain = global_domain
		                 AND code_fldname = "xx_no_version_control" ) THEN DO:
                        m_error = YES.
                         MESSAGE  m_mesdesc[46].
			 
                          LEAVE.  
	           END.  /* if substring(tt1_syslot,2,1) <> m_ver */
	     end. /* if last-of(tt1_line) */

/*LINAS42955*END*/
/*linas20140205 mark begin*** 

              FIND FIRST tts21_det  NO-LOCK NO-ERROR.

              IF NOT AVAIL tts21_det THEN DO:

                 FIND FIRST pt_mstr WHERE pt_domain = GLOBAL_domain
                        AND pt_part = tt1_part NO-LOCK NO-ERROR.
                 IF AVAILABLE pt_mstr THEN DO:
                    IF  pt__dec01 <> DEC(SUBSTRING(tt1_syslot, 10,4)) THEN
                    DO:
                        m_error = YES.
                        MESSAGE m_mesdesc[47].
                  /*      UNDO detloop , RETRY detloop. linas42955*/
                          LEAVE.  /*linas42955*/
                    END.
                 END. /*if avail pt_mstr */
              END. /*if not avail*/
              ELSE DO:
                FOR EACH TTS21_DET NO-LOCK:
                    MESSAGE tts21_width   tt1_syslot VIEW-AS ALERT-BOX.
                END.

                FIND FIRST tts21_det WHERE tts21_width =
                 DEC(SUBSTRING(tt1_syslot, 10,4)) NO-LOCK NO-ERROR.

               IF NOT AVAILABLE tts21_det THEN DO:
                   m_error = YES.
                   MESSAGE m_mesdesc[47] .
                          LEAVE.  /*linas42955*/
               /*    UNDO detloop , RETRY detloop. *linas42955*/
                END.
                ELSE DO:
                   IF DEC(SUBSTRING(tt1_syslot, 14,5)) <> tts21_length  THEN
                      MESSAGE m_mesdesc[48].
                END.
              END. /* if avail tts21_det */
**linas20140205 mark end ***/  
           m_qtytol = 0.
          END. /* FOR EACH tt1_det */

          IF m_error THEN
          DO:
             FOR EACH tt1_det
                 WHERE tt1_ref = tt2a_ref :
               FOR EACH tt4_det
                   WHERE tt4_nbr  = tt2a_nbr :
                 tt4_qtyall = tt4_qtyall - tt1_qtyiss.
                 IF tt4_qtyall < 0 THEN
                    tt4_qtyall = 0.
               END. /**EACH tt4_det **/

               DELETE tt1_det.
             END. /**EACH tt1_det**/
             ASSIGN tt2a_nbr     = ""
                    tt2a_dataset = "".
             UNDO detloop , RETRY detloop.
          END. /**IF m_error THEN**/

      END. /**IF tt2a_nbr <> "" THEN**/

      /* DELETE */
      IF LASTKEY = KEYCODE("F5") OR LASTKEY = KEYCODE("CTRL-D")
      THEN do:
           del-yn = no.
           /* Please confirm delete */
           {pxmsg.i &MSGNUM=11 &ERRORLEVEL=1 &CONFIRM=del-yn}
           IF del-yn THEN
           DO:
              FOR EACH tt4_det
                  WHERE tt4_nbr  = tt2a_nbr :
                 tt4_qtyall = tt4_qtyall - tt2a_qtyoh.
                 IF tt4_qtyall < 0 THEN
                    tt4_qtyall = 0.
              END. /**EACH tt4_det **/

              FOR EACH tt1_det
                  WHERE tt1_ref = tt2a_ref:
                  DELETE tt1_det.
              END. /**EACH tt1_det**/

              DELETE tt2a_det.
              IF m_screen THEN DO:
                 CLEAR FRAME a1h.
                 n_count = n_count - 1. /*jackl 20090527133626*/
                 Message "Sum to scan:" n_count. /*jackl 20090527133626*/
              END.
              ELSE
                 CLEAR FRAME a1.
              UNDO detloop, RETRY detloop.
           END. /**IF del-yn THEN**/
      END. /**IF LASTKEY = KEYCODE("F5") OR LASTKEY = KEYCODE("CTRL-D")*/

      FOR EACH tt4_det where tt4_nbr = m_sonbr
                         and tt4_line = string(m_soline):
          MESSAGE "O"  + STRING(tt4_qtyord , "->>,>>9.99" ) +
                  " A" + STRING(tt4_qtyall , "->>,>>9.99" ).
      END. /**EACH tt4_det**/

      IF m_screen THEN
         DOWN 1 WITH FRAME a1h.
      ELSE DOWN 1 WITH FRAME a1.
    END. /**END OF REPEAT**/

    IF NOT CAN-FIND(FIRST tt1_det WHERE tt1_qtyiss <> 0
                                     AND tt1_nbr  <> ""  ) THEN
    DO:
       MESSAGE m_mesdesc[14].
/*davidw:1959*/  RUN sendbell  IN THIS-PROCEDURE.
       PAUSE.
       LEAVE mainloop.
    END. /**IF NOT CAN-FIND(FIRST tt1_det WHERE tt1_qtyiss <> 0 ) THEN**/

    RUN STOCK-ALLOCATION IN THIS-PROCEDURE.
    n_count = 0. /*jackl 20090527133626*/

    IF NOT m_cimerr AND m_yn THEN DO:
       m_prttype = 1.  /*20130313104409*/
       PAUSE 0 BEFORE-HIDE.
         /* {gprun.i ""xxpltppc.p""} */    /* jerryg ECO:105119 */
/* jerryg add start ECO:105119 */
         IF m_epsma THEN DO:
            {gprun.i ""xxapltppc.p""}
         END. /* IF m_epsma */
         ELSE DO:
           /***Jihui 20140205165345 Begin***/
           FIND FIRST code_mstr where code_domain = global_domain
	               and code_fldname = "xx_pallet_creation"
                       and code_value = "CHN"
                       no-lock no-error.
           IF AVAIL code_mstr then
              {gprun.i ""xxpltppccn.p""}
           ELSE
           /***Jihui 20140205165345 END ***/
              {gprun.i ""xxpltppc.p""}

         END. /* ELSE DO: */
/* jerryg add end ECO:105119 */
       HIDE FRAME a NO-PAUSE.
    END. /**IF NOT m_cimerr THEN DO:**/

  END. /**END OF REPEAT**/

END. /**SODOLINK-PALLET**/



PROCEDURE SODOLINK-ITEM:
    n_count = 0. /*jackl 20090527133626*/
    FORM
        tt1_part
        VALIDATE(CAN-FIND(FIRST pt_mstr
                          WHERE pt_domain = GLOBAL_domain
                            AND pt_part = INPUT FRAME a1 tt1_part
                            AND pt_lot_ser = "" NO-LOCK ) ,
                 m_mesdesc[1])
        tt1_um
        tt1_site
        VALIDATE(CAN-FIND(FIRST si_mstr NO-LOCK
                          WHERE si_domain = GLOBAL_domain
                            AND si_site = INPUT FRAME a1 tt1_site ) ,
                 m_mesdesc[9])
        tt1_loc
        VALIDATE(CAN-FIND(FIRST loc_mstr NO-LOCK
                          WHERE loc_domain = GLOBAL_domain
                            AND loc_site = INPUT FRAME a1 tt1_site
                            AND loc_loc  = INPUT FRAME a1 tt1_loc ) ,
                 m_mesdesc[2])
        tt1_qtyiss
        VALIDATE(INPUT FRAME a1 tt1_qtyiss <= tt1_qtyoh ,
                 m_mesdesc[16] )
        tt1_nbr   COLUMN-LABEL {&xxictpc_p_19}
        WITH FRAME a1 DOWN.

    FORM
        tt1_part    COLON 8 LABEL {&xxictpc_p_05}
        VALIDATE(CAN-FIND(FIRST pt_mstr
                          WHERE pt_domain = GLOBAL_domain
                            AND pt_part = INPUT FRAME a1h tt1_part
                            AND pt_lot_ser = "" NO-LOCK ) ,
                 m_mesdesc[1])
        tt1_um      COLON 8
        tt1_site    COLON 8
        VALIDATE(CAN-FIND(FIRST si_mstr NO-LOCK
                          WHERE si_domain = GLOBAL_domain
                            AND si_site = INPUT FRAME a1h tt1_site ) ,
                 m_mesdesc[9])
        tt1_loc     COLON 8 LABEL {&xxictpc_p_08}
        VALIDATE(CAN-FIND(FIRST loc_mstr NO-LOCK
                          WHERE loc_domain = GLOBAL_domain
                            AND loc_site = INPUT FRAME a1h tt1_site
                            AND loc_loc  = INPUT FRAME a1h tt1_loc ) ,
                 m_mesdesc[2])
        tt1_qtyiss  COLON 8 LABEL {&xxictpc_p_11}
        VALIDATE(INPUT FRAME a1h tt1_qtyiss <= tt1_qtyoh ,
                 m_mesdesc[16] )
        tt1_nbr     COLON 8 LABEL {&xxictpc_p_19}
      WITH FRAME a1h SIDE-LABEL.

    mainloop:
    REPEAT:
      EMPTY TEMP-TABLE tt1_det.
      EMPTY TEMP-TABLE tt4_det.

      CLEAR FRAME a1 ALL NO-PAUSE.
      CLEAR FRAME a1h ALL NO-PAUSE.

      detloop:
      REPEAT:

        IF m_screen THEN
        DO:
            PROMPT-FOR tt1_part tt1_site tt1_loc
                WITH FRAME a1h EDITING:
                {mfnp.i tt1_det tt1_part tt1_part tt1_part tt1_part
                        tt1_a}
                 IF recno <> ? THEN
                     DISP tt1_part tt1_um tt1_site tt1_loc tt1_qtyiss
                          tt1_nbr
                         WITH FRAME a1h.
            END. /**ROMPT-FOR tt12_lot**/
        END. /**HHT SCREEN**/
        ELSE DO:
            PROMPT-FOR tt1_part tt1_site tt1_loc
                WITH FRAME a1 EDITING:
                {mfnp.i tt1_det tt1_part tt1_part tt1_part tt1_part
                        tt1_a}
                 IF recno <> ? THEN
                    DISP tt1_part tt1_um tt1_site tt1_loc tt1_qtyiss
                         tt1_nbr
                         WITH FRAME a1.
            END. /**PROMPT-FOR tt12_lot**/

        END. /**MFG/PRO SCREEN**/


        ASSIGN m_part   = (IF m_screen THEN INPUT FRAME a1h tt1_part
                           ELSE INPUT FRAME a1 tt1_part )
               m_site   = (IF m_screen THEN INPUT FRAME a1h tt1_site
                           ELSE INPUT FRAME a1 tt1_site )
               m_loc    = (IF m_screen THEN INPUT FRAME a1h tt1_loc
                           ELSE INPUT FRAME a1 tt1_loc )
               m_lot    = ""
               m_syslot = ""
               m_ref    = ""
               m_nbr    = ""
               m_recid  = ?
               gpglef   = 0
               m_trtype = ""
               m_error  = NO.

        RUN GET-ITEM-FROM-LOTREF IN THIS-PROCEDURE.

        IF m_error THEN
           UNDO detloop , RETRY detloop.

        FIND FIRST tt1_det
             WHERE tt1_part  = m_part
               AND tt1_site  = m_site
               AND tt1_loc   = m_loc  NO-ERROR.
        IF NOT AVAIL tt1_det THEN
        DO:
           CREATE tt1_det.
           ASSIGN tt1_part  = m_part
                  tt1_site  = m_site
                  tt1_loc   = m_loc.
           n_count = n_count + 1. /*jackl 20090527133626*/
           FOR FIRST ld_det
               FIELDS(ld__chr01 ld_qty_oh)
               WHERE RECID(ld_det) = m_recid NO-LOCK:
           END. /**FOR FIRST ld_det**/
           IF AVAIL ld_det THEN
           DO:
              tt1_qtyoh   = ld_qty_oh.
              {xxqtylim.i tt1_qtyoh}
           END. /**IF AVAIL ld_det THEN**/

           FOR FIRST pt_mstr
               FIELDS(pt_um pt_desc1)
               WHERE pt_domain = GLOBAL_domain
                 AND pt_part = m_part NO-LOCK:
           END. /**FOR FIRST pt_mstr**/
           IF AVAIL pt_mstr THEN
              ASSIGN tt1_um     = pt_um
                     tt1_desc   = pt_desc1.
        END. /**IF NOT AVAIL tt1_det THEN**/

        IF m_screen THEN
        DO:
             DISP tt1_part tt1_um tt1_site tt1_loc tt1_qtyiss
                  tt1_nbr
                  WITH FRAME a1h.
             UPDATE tt1_qtyiss tt1_nbr
                    GO-ON (CTRL-D F5) WITH FRAME a1h DOWN.

        END. /**IF m_screen THEN**/
        ELSE DO:
            DISP tt1_part tt1_um tt1_site tt1_loc tt1_qtyiss
                   tt1_nbr
                   WITH FRAME a1.
            UPDATE tt1_qtyiss tt1_nbr
                   GO-ON (CTRL-D F5) WITH FRAME a1 DOWN.
            Message "Sum to scan:" n_count. /*jackl 20090527133626*/
        END. /**ELSE DO**/

        IF tt1_nbr <> "" AND tt1_dataset = "" THEN
        DO:


            RUN GET-ORDER-DETAILS IN THIS-PROCEDURE
                (INPUT  tt1_nbr     , INPUT tt1_part     ,
                 OUTPUT tt1_line    , OUTPUT tt1_dataset ,
                 OUTPUT tt1_qtyopn  , OUTPUT tt1_cust,
                 OUTPUT tt1_recsite , OUTPUT tt1_qtyall,
                      OUTPUT tt1_soum    , OUTPUT tt1_um_conv).  /*20090605102535*/


            ASSIGN m_error  = NO
                   m_recid1 = RECID(tt1_det)
                   m_count  = 0.

            RUN ORDER-VALIDATION IN THIS-PROCEDURE.

            IF m_error THEN
            DO:
                tt1_nbr = "".
               UNDO detloop , RETRY detloop.
            END. /**IF m_error**/

            ASSIGN m_trtype = (IF tt1_dataset = "sod_det" THEN "ISS-SO"
                               ELSE "ISS-DO,RCT-GIT")
                   m_error  = NO.

            RUN LOC-DET-EXP-VALIDATION IN THIS-PROCEDURE.

            IF m_error THEN
            DO:
               tt1_nbr = "".
               UNDO detloop , RETRY detloop.
            END. /**IF m_error THEN**/

            FIND FIRST tt4_det
                 WHERE tt4_nbr  = tt1_nbr
                   AND tt4_part = tt1_part NO-ERROR.
            IF NOT AVAIL tt4_det THEN
            DO:
               CREATE tt4_det.
               ASSIGN tt4_nbr     = tt1_nbr
                      tt4_part    = tt1_part
                      tt4_qtyord  = tt1_qtyopn
                      tt4_qtyall  = 0 /* tt1_qtyall - MK03  */
                      tt4_cust    = tt1_cust
                      tt4_dataset = tt1_dataset.
            END. /**IF NOT AVAIL tt4_det THEN**/
            tt4_qtyall = tt4_qtyall + tt1_qtyiss.
        END. /**IF tt42_nbr <> "" THEN**/

        /* DELETE */
        IF LASTKEY = KEYCODE("F5") OR LASTKEY = KEYCODE("CTRL-D")
        THEN do:
           del-yn = no.
           /* Please confirm delete */
           {pxmsg.i &MSGNUM=11 &ERRORLEVEL=1 &CONFIRM=del-yn}
           IF del-yn THEN
           DO:
              FOR EACH tt4_det
                  WHERE tt4_nbr  = tt1_nbr
                    AND tt4_part = tt1_part:
                  tt4_qtyall = tt4_qtyall - tt1_qtyiss.
                  IF tt4_qtyall < 0 THEN tt4_qtyall = 0.
              END. /**EACH tt4_nbr*/

              DELETE tt1_det.
              IF m_screen THEN DO:
                 CLEAR FRAME a1h.
                 n_count = n_count - 1. /*jackl 20090527133626*/
                 Message "Sum to scan:" n_count. /*jackl 20090527133626*/
              END.
              ELSE
                 CLEAR FRAME a1.
              UNDO detloop, RETRY detloop.
           END. /**IF del-yn THEN**/
        END. /**IF LASTKEY = KEYCODE("F5") OR LASTKEY = KEYCODE("CTRL-D")*/

        MESSAGE "O"  + STRING(tt4_qtyord , "->>,>>9.99" ) +
                " A" + STRING(tt4_qtyall , "->>,>>9.99" ).

        IF tt4_qtyall > tt4_qtyord * ( 1 + (m_overshipct * 0.01))
           AND tt4_dataset = "sod_det" AND
           NOT CAN-FIND(FIRST CODE_mstr
                        WHERE CODE_domain  = GLOBAL_domain
                          AND CODE_fldname = "xx_so_overshipment_CUST_EXC"
                          AND CODE_value   = tt4_cust)
        THEN DO:
           ASSIGN tt1_nbr     = ""
                  tt1_dataset = ""
                  tt4_qtyall  = tt4_qtyall - tt1_qtyiss.
           MESSAGE m_mesdesc[40].
/*davidw:1959*/  RUN sendbell  IN THIS-PROCEDURE.
           UNDO detloop, RETRY detloop.
        END. /**IF tt4_qtyall > tt4_qtyord * ( 1 + (m_overshipct * 0.01)) THEN**/

        IF NOT m_screen THEN
           DOWN 1 WITH FRAME a1.
      END. /**END OF REPEAT**/

      IF NOT CAN-FIND(FIRST tt1_det WHERE tt1_qtyiss <> 0
                                      AND tt1_nbr  <> "" ) THEN
      DO:
         MESSAGE m_mesdesc[14].
/*davidw:1959*/  RUN sendbell  IN THIS-PROCEDURE.
         PAUSE.
         LEAVE mainloop.
      END. /**IF NOT CAN-FIND(FIRST tt1_det WHERE tt1_qtyiss <> 0 ) THEN**/

      RUN STOCK-ALLOCATION IN THIS-PROCEDURE.
      n_count = 0. /*jackl 20090527133626*/

    END. /**END OF REPEAT**/

END. /**SODOLINK-ITEM**/


PROCEDURE SODODELINK-LOT:

  FORM
      tt1_lot
      VALIDATE(INPUT FRAME a1 tt1_lot <> ""
               AND LENGTH(INPUT FRAME a1 tt1_lot) = 9 , m_mesdesc[3])
      tt1_part
      tt1_um
      tt1_qtyiss
      tt1_site
      tt1_nbr  COLUMN-LABEL {&xxictpc_p_19} FORMAT "X(8)"
      WITH FRAME a1 DOWN.

  FORM
    tt1_lot    LABEL {&xxictpc_p_09}
    VALIDATE(INPUT FRAME a1h tt1_lot <> ""
             AND LENGTH(INPUT FRAME a1h tt1_lot) = 9 , m_mesdesc[3])
    tt1_nbr  COLUMN-LABEL {&xxictpc_p_19} FORMAT "X(8)"
     WITH FRAME a1h DOWN.

  mainloop:
  REPEAT:
    EMPTY TEMP-TABLE tt1_det.

    CLEAR FRAME a1 ALL NO-PAUSE.
    CLEAR FRAME a1h ALL NO-PAUSE.

    detloop:
    REPEAT:

      IF m_screen THEN
      DO:
          PROMPT-FOR tt1_lot
              WITH FRAME a1h EDITING:
              {mfnp.i tt1_det tt1_lot tt1_lot tt1_lot tt1_lot
                      tt1_a}
               IF recno <> ? THEN
                  DISP tt1_lot tt1_nbr
                       WITH FRAME a1h.
          END. /**ROMPT-FOR tt12_lot**/
      END. /**HHT SCREEN**/
      ELSE DO:
          PROMPT-FOR tt1_lot
              WITH FRAME a1 EDITING:
              {mfnp.i tt1_det tt1_lot tt1_lot tt1_lot tt1_lot
                      tt1_a}
               IF recno <> ? THEN
                  DISP tt1_lot tt1_part tt1_um tt1_qtyiss tt1_site tt1_nbr
                       WITH FRAME a1.
          END. /**PROMPT-FOR tt12_lot**/

      END. /**MFG/PRO SCREEN**/

      ASSIGN m_part   = ""
             m_site   = ""
             m_loc    = ""
             m_lot    = (IF m_screen THEN INPUT FRAME a1h tt1_lot
                         ELSE INPUT FRAME a1 tt1_lot )
             m_syslot = ""
             m_ref    = ""
             m_nbr    = ""
             m_recid  = ?
             gpglef   = 0
             m_trtype = ""
             m_error  = NO
             m_soline = 0 . /*maha05122010*/

      RUN GET-ITEM-FROM-LOTREF IN THIS-PROCEDURE.

      IF m_error THEN
         UNDO detloop , RETRY detloop.

      /* DELETE */
      IF LASTKEY = KEYCODE("F5") OR LASTKEY = KEYCODE("CTRL-D")
      THEN do:
         del-yn = no.
         /* Please confirm delete */
         {pxmsg.i &MSGNUM=11 &ERRORLEVEL=1 &CONFIRM=del-yn}
         IF del-yn THEN
         DO:
            FIND FIRST tt1_det
                 WHERE tt1_lot  = m_lot NO-ERROR.
            IF AVAIL tt1_det THEN
               DELETE tt1_det.
            IF m_screen THEN
               CLEAR FRAME a1h.
            ELSE
               CLEAR FRAME a1.
            UNDO detloop, RETRY detloop.
         END. /**IF del-yn THEN**/
      END. /**IF LASTKEY = KEYCODE("F5") OR LASTKEY = KEYCODE("CTRL-D")*/

      FIND FIRST tt1_det
           WHERE tt1_lot  = m_lot NO-ERROR.
      IF NOT AVAIL tt1_det THEN
      DO:
         CREATE tt1_det.
         ASSIGN tt1_lot    = m_lot
                tt1_syslot = m_syslot
                tt1_part   = m_part
                tt1_site   = m_site
                tt1_loc    = m_loc
                tt1_loc1   = m_loc
                tt1_line   = m_line. /*maha05122010*/

         FOR FIRST ld_det
             FIELDS(ld__chr01 ld_qty_oh)
             WHERE RECID(ld_det) = m_recid NO-LOCK:
         END. /**FOR FIRST ld_det**/
         IF AVAIL ld_det THEN
         DO:
              IF ld__chr02 <> ""  THEN
                  MESSAGE "Lot Linked to Shipper " VIEW-AS ALERT-BOX . /*maha05122010*/

            ASSIGN tt1_nbr    = ld__chr01
                   tt1_line   = ld__Chr04 /*maha05122010*/
                   tt1_qtyiss = ld_qty_oh.
            {xxqtylim.i tt1_qtyiss}
         END. /**IF AVAIL ld_det THEN**/

         /* Nilay Code Starts Here */
         FIND FIRST lad_det WHERE lad_domain = GLOBAL_domain
                            AND   (lad_lot    = TRIM(m_syslot) OR lad_lot BEGINS m_lot)
         NO-LOCK NO-ERROR.
         IF AVAIL lad_det THEN
         DO:
            ASSIGN tt1_line = lad_line.
         END.
         /* Nilay Code Ends Here */

         IF tt1_nbr <> "" THEN
         DO:
             m_soline = int(tt1_line) no-error. /*maha05122010*/
             RUN GET-ORDER-DETAILS IN THIS-PROCEDURE
                 (INPUT tt1_nbr      , INPUT tt1_part , OUTPUT tt1_line ,
                  OUTPUT tt1_dataset , OUTPUT tt1_qtyopn , OUTPUT tt1_cust,
                  OUTPUT tt1_recsite , OUTPUT tt1_qtyall,
                  OUTPUT tt1_soum    , OUTPUT tt1_um_conv).  /*20090605102535*/
             /***Jack Li****ADD BEGIN***ECO:TEMP***/
             IF tt1_dataset = "sod_det" THEN DO:
                IF tt1_line = "" THEN
                   tt1_line = STRING(m_soline).
                m_soline = int(tt1_line).
             END.
             /***Jack Li****ADDED END***ECO:TEMP***/

             /***Jack Li****ADD BEGIN***ECO:20130424131717***/
             IF tt1_dataset = "" THEN DO:
                tt1_line = STRING(m_soline).
             END.
             /***Jack Li****ADDED END***ECO:20130424131717***/

         END. /**IF tt1_nbr <> "" THEN**/

         FOR FIRST pt_mstr
             FIELDS(pt_um pt_desc1)
             WHERE pt_domain = GLOBAL_domain
               AND pt_part = m_part NO-LOCK:
         END. /**FOR FIRST pt_mstr**/
         IF AVAIL pt_mstr THEN
            ASSIGN tt1_um     = pt_um
                   tt1_desc   = pt_desc1.
      END. /**IF NOT AVAIL tt1_det THEN**/

      IF m_screen THEN
          DISP tt1_lot tt1_nbr
               WITH FRAME a1h.
      ELSE DISP tt1_lot tt1_part tt1_um tt1_qtyiss tt1_site tt1_nbr
                WITH FRAME a1.

      IF m_screen THEN
         DOWN 1 WITH FRAME a1h.
      ELSE DOWN 1 WITH FRAME a1.
    END. /**END OF REPEAT**/

    IF NOT CAN-FIND(FIRST tt1_det WHERE tt1_qtyiss <> 0
                                     AND tt1_nbr  <> "") THEN
    DO:
       MESSAGE m_mesdesc[14].
/*davidw:1959*/  RUN sendbell  IN THIS-PROCEDURE.
       PAUSE.
       LEAVE mainloop.
    END. /**IF NOT CAN-FIND(FIRST tt1_det WHERE tt1_qtyiss <> 0 ) THEN**/

    RUN STOCK-DEALLOCATION IN THIS-PROCEDURE.

    /*Jack Li *ADD BEGIN**ECO#: 20091208165908****/
    IF NOT m_cimerr AND m_yn THEN DO:
       EMPTY TEMP-TABLE tt2_det.
       FOR EACH tt1_det
                WHERE tt1_qtyiss <> 0
                  AND tt1_nbr    <> "" :
           FIND FIRST tt2_det
                WHERE tt2_part = tt1_part
                  AND tt2_lot  = tt1_syslot
                  AND tt2_site = tt1_site
                  AND tt2_loc  = tt1_loc NO-ERROR.
           IF NOT AVAIL tt2_det THEN
           DO:
              CREATE tt2_det.
              ASSIGN tt2_part = tt1_part
                     tt2_lot  = tt1_syslot
                     tt2_site = tt1_site
                     tt2_loc  = tt1_loc.
           END. /**IF NOT AVAIL tt2_det THEN**/
       END. /**EACH tt1_det **/

       PAUSE 0 BEFORE-HIDE.
       {gprun.i ""xxlotppc.p""}
       HIDE FRAME a NO-PAUSE.
    END. /**IF NOT m_cimerr THEN DO:**/
    /*Jack Li *ADDED END**ECO#: 20091208165908****/
  END. /**END OF REPEAT**/

END. /**END SODODELINK-LOT**/

PROCEDURE SHIPPERDELINK-LOT:
  n_count = 0. /*jackl 20090527133626*/
  FORM
      tt1_lot
      VALIDATE(INPUT FRAME a1 tt1_lot <> ""
               AND LENGTH(INPUT FRAME a1 tt1_lot) = 9 , m_mesdesc[3])
      tt1_part
      tt1_um
      tt1_qtyiss
      tt1_site
      tt1_nbr  COLUMN-LABEL "Shipper" FORMAT "X(9)"
      WITH FRAME a1 DOWN.

  FORM
    tt1_lot    LABEL {&xxictpc_p_09}
    VALIDATE(INPUT FRAME a1h tt1_lot <> ""
             AND LENGTH(INPUT FRAME a1h tt1_lot) = 9 , m_mesdesc[3])
    tt1_nbr  COLUMN-LABEL "Shipper" FORMAT "X(9)"
     WITH FRAME a1h DOWN.

  mainloop:
  REPEAT:
    EMPTY TEMP-TABLE tt1_det.

    CLEAR FRAME a1 ALL NO-PAUSE.
    CLEAR FRAME a1h ALL NO-PAUSE.

    detloop:
    REPEAT:

      IF m_screen THEN
      DO:
          PROMPT-FOR tt1_lot
              WITH FRAME a1h EDITING:
              {mfnp.i tt1_det tt1_lot tt1_lot tt1_lot tt1_lot
                      tt1_a}
               IF recno <> ? THEN
                  DISP tt1_lot tt1_nbr
                       WITH FRAME a1h.
          END. /**ROMPT-FOR tt12_lot**/
      END. /**HHT SCREEN**/
      ELSE DO:
          PROMPT-FOR tt1_lot
              WITH FRAME a1 EDITING:
              {mfnp.i tt1_det tt1_lot tt1_lot tt1_lot tt1_lot
                      tt1_a}
               IF recno <> ? THEN
                  DISP tt1_lot tt1_part tt1_um tt1_qtyiss tt1_site tt1_nbr
                       WITH FRAME a1.
          END. /**PROMPT-FOR tt12_lot**/

      END. /**MFG/PRO SCREEN**/

      ASSIGN m_part   = ""
             m_site   = ""
             m_loc    = ""
             m_lot    = (IF m_screen THEN INPUT FRAME a1h tt1_lot
                         ELSE INPUT FRAME a1 tt1_lot )
             m_syslot = ""
             m_ref    = ""
             m_nbr    = ""
             m_recid  = ?
             gpglef   = 0
             m_trtype = ""
             m_error  = NO.

      RUN GET-ITEM-FROM-LOTREF IN THIS-PROCEDURE.

      IF m_error THEN
         UNDO detloop , RETRY detloop.

      /* DELETE */
      IF LASTKEY = KEYCODE("F5") OR LASTKEY = KEYCODE("CTRL-D")
      THEN do:
         del-yn = no.
         /* Please confirm delete */
         {pxmsg.i &MSGNUM=11 &ERRORLEVEL=1 &CONFIRM=del-yn}
         IF del-yn THEN
         DO:
            FIND FIRST tt1_det
                 WHERE tt1_lot  = m_lot NO-ERROR.
            IF AVAIL tt1_det THEN
               DELETE tt1_det.
            IF m_screen THEN DO:
               CLEAR FRAME a1h.
               n_count = n_count - 1. /*jackl 20090527133626*/
               Message "Sum to scan:" n_count. /*jackl 20090527133626*/
            END.
            ELSE
               CLEAR FRAME a1.
            UNDO detloop, RETRY detloop.
         END. /**IF del-yn THEN**/
      END. /**IF LASTKEY = KEYCODE("F5") OR LASTKEY = KEYCODE("CTRL-D")*/

      FIND FIRST tt1_det
           WHERE tt1_lot  = m_lot NO-ERROR.
      IF NOT AVAIL tt1_det THEN
      DO:
         CREATE tt1_det.
         ASSIGN tt1_lot    = m_lot
                tt1_syslot = m_syslot
                tt1_part   = m_part
                tt1_site   = m_site
                tt1_loc    = m_loc
                tt1_loc1   = m_loc.
         n_count = n_count + 1. /*jackl 20090527133626*/
         Message "Sum to scan:" n_count. /*jackl 20090527133626*/
         FOR FIRST ld_det
             FIELDS(ld__chr01 ld__chr02 ld_qty_oh)
             WHERE RECID(ld_det) = m_recid NO-LOCK:
         END. /**FOR FIRST ld_det**/
         IF AVAIL ld_det THEN
         DO:
            ASSIGN tt1_nbr    = ld__chr02
                   tt1_qtyiss = ld_qty_oh.

            IF tt1_nbr = "" THEN
            DO:
               MESSAGE m_mesdesc[34].
/*davidw:1959*/ RUN sendbell  IN THIS-PROCEDURE.
            END. /**IF tt1_nbr = "" THEN**/
         END. /**IF AVAIL ld_det THEN**/

      END. /**IF NOT AVAIL tt1_det THEN**/

      IF m_screen THEN
          DISP tt1_lot tt1_nbr
               WITH FRAME a1h.
      ELSE DISP tt1_lot tt1_part tt1_um tt1_qtyiss tt1_site tt1_nbr
                WITH FRAME a1.

      IF m_screen THEN
         DOWN 1 WITH FRAME a1h.
      ELSE DOWN 1 WITH FRAME a1.
    END. /**END OF REPEAT**/

    IF NOT CAN-FIND(FIRST tt1_det WHERE tt1_qtyiss <> 0
                                     AND tt1_nbr  <> "") THEN
    DO:
       MESSAGE m_mesdesc[14].
/*davidw:1959*/  RUN sendbell  IN THIS-PROCEDURE.
       PAUSE.
       LEAVE mainloop.
    END. /**IF NOT CAN-FIND(FIRST tt1_det WHERE tt1_qtyiss <> 0 ) THEN**/

    RUN SHIPPER-DEALLOCATION IN THIS-PROCEDURE.
    n_count = 0. /*jackl 20090527133626*/
  END. /**END OF REPEAT**/

END. /**END SODODELINK-LOT**/

PROCEDURE SODODELINK-PALLET:
  n_count = 0. /*jackl 20090527133626*/
  FORM
      tt2a_ref    COLUMN-LABEL {&xxictpc_p_10}
      VALIDATE(CAN-FIND(FIRST ld_det
                        WHERE ld_domain = GLOBAL_domain
                          AND ld_ref    = INPUT FRAME a1 tt2a_ref
                          AND ld__chr01 <> ""
                          AND ld__chr02 = "" NO-LOCK ) AND
               INPUT FRAME a1 tt2a_ref <> "" ,
               m_mesdesc[5])
      tt2a_part
      tt2a_um
      tt2a_qtyoh
      tt2a_site
      tt2a_nbr     COLUMN-LABEL {&xxictpc_p_19} FORMAT "X(8)"
      WITH FRAME a1 DOWN.

  FORM
      tt2a_ref     COLUMN-LABEL {&xxictpc_p_10}
      VALIDATE(CAN-FIND(FIRST ld_det
                        WHERE ld_domain = GLOBAL_domain
                          AND ld_ref    = INPUT FRAME a1h tt2a_ref
                          AND ld__chr01 <> ""
                          AND ld__chr02 = "" NO-LOCK ) AND
               INPUT FRAME a1h tt2a_ref <> "",
               m_mesdesc[5])
      tt2a_nbr     COLUMN-LABEL {&xxictpc_p_19} FORMAT "X(8)"
    WITH FRAME a1h DOWN.

  mainloop:
  REPEAT:
    EMPTY TEMP-TABLE tt2a_det.
    EMPTY TEMP-TABLE tt1_det.
    EMPTY TEMP-TABLE tt4_det.

    CLEAR FRAME a1 ALL NO-PAUSE.
    CLEAR FRAME a1h ALL NO-PAUSE.
    m_sernbr = "".
    detloop:
    REPEAT:

      IF m_screen THEN
      DO:
          PROMPT-FOR tt2a_ref
              WITH FRAME a1h EDITING:
              {mfnp.i tt2a_det tt2a_ref tt2a_ref tt2a_ref tt2a_ref
                      tt2a_ref}
               IF recno <> ? THEN
                  DISP tt2a_ref tt2a_nbr
                       WITH FRAME a1h.
          END. /**ROMPT-FOR tt12_lot**/
      END. /**HHT SCREEN**/
      ELSE DO:
          PROMPT-FOR tt2a_ref
              WITH FRAME a1 EDITING:
              {mfnp.i tt2a_det tt2a_ref tt2a_ref tt2a_ref tt2a_ref
                      tt2a_ref}
               IF recno <> ? THEN
                  DISP tt2a_ref tt2a_part tt2a_um tt2a_qtyoh tt2a_site tt2a_nbr
                       WITH FRAME a1.
          END. /**PROMPT-FOR tt12_lot**/

      END. /**MFG/PRO SCREEN**/

      ASSIGN m_part = ""
             m_site = ""
             m_loc  = ""
             m_lot  = ""
             m_ref  = (IF m_screen THEN INPUT FRAME a1h tt2a_ref
                       ELSE INPUT FRAME a1 tt2a_ref )
             m_sernbr = m_ref
             m_nbr    = ""
             m_recid  = ?
             gpglef   = 0
             m_trtype = ""
             m_error  = NO.

      RUN GET-ITEM-FROM-LOTREF IN THIS-PROCEDURE.

      IF m_error THEN
         UNDO detloop , RETRY detloop.

      /* DELETE */
      IF LASTKEY = KEYCODE("F5") OR LASTKEY = KEYCODE("CTRL-D")
      THEN do:
         del-yn = no.
         /* Please confirm delete */
         {pxmsg.i &MSGNUM=11 &ERRORLEVEL=1 &CONFIRM=del-yn}
         IF del-yn THEN
         DO:
            FOR EACH tt1_det
                WHERE tt1_ref = m_ref:
               DELETE tt1_det.
            END. /**EACH tt1_det**/

            FIND FIRST tt2a_det
                  WHERE tt2a_ref  = m_ref NO-ERROR.
            IF AVAIL tt2a_det THEN
               DELETE tt2a_det.
            IF m_screen THEN DO:
               CLEAR FRAME a1h.
               n_count = n_count - 1. /*jackl 20090527133626*/
               Message "Sum to scan:" n_count. /*jackl 20090527133626*/
            END.
            ELSE
               CLEAR FRAME a1.
            UNDO detloop, RETRY detloop.
         END. /**IF del-yn THEN**/
      END. /**IF LASTKEY = KEYCODE("F5") OR LASTKEY = KEYCODE("CTRL-D")*/

      FIND FIRST tt2a_det
           WHERE tt2a_ref  = m_ref NO-ERROR.
      IF NOT AVAIL tt2a_det THEN
      DO:
         CREATE tt2a_det.
         ASSIGN tt2a_ref   = m_ref
                tt2a_part  = m_part
                tt2a_site  = m_site.
         n_count = n_count + 1. /*jackl 20090527133626*/
         Message "Sum to scan:" n_count. /*jackl 20090527133626*/
         FOR FIRST pt_mstr
             FIELDS(pt_um pt_desc1)
             WHERE pt_domain = GLOBAL_domain
               AND pt_part = m_part NO-LOCK:

         END. /**FOR FIRST pt_mstr**/
         IF AVAIL pt_mstr THEN
            ASSIGN tt2a_um     = pt_um
                   tt2a_desc   = pt_desc1.

         FOR EACH ld_det
             FIELDS(ld_lot ld_qty_oh ld__chr01 ld__chr04 ld_part)
             WHERE ld_domain = GLOBAL_domain
               AND ld_ref    = m_ref
             /*  AND ld_part   = m_part   Jack Li*/
               AND ld_site   = m_site
               AND ld_loc    = m_loc
               AND ld__chr01 <> ""
               AND TRUNCATE(ld_qty_oh , 3) <> 0 NO-LOCK :
           FIND FIRST tt1_det
                WHERE tt1_lot   = ld_lot
                  AND tt1_ref   = m_ref
                  AND tt1_site  = m_site
                  AND tt1_loc   = m_loc
                  AND tt1_part  = ld_part NO-ERROR.
           IF NOT AVAIL tt1_det THEN
           DO:
              CREATE tt1_det.
              ASSIGN tt1_lot    = ld_lot
                     tt1_syslot = ld_lot
                     tt1_ref    = m_ref
                     tt1_ref1   = m_ref
                     tt1_site   = m_site
                     tt1_loc    = m_loc
                     tt1_loc1   = m_loc
                     tt1_part   = ld_part
                     tt1_qtyiss = ld_qty_oh
                     tt1_nbr    = ld__chr01
                     tt1_line   = ld__chr04 /*jackl *ECO:20110307095617*/
                     tt2a_nbr   = ld__chr01
                     tt2a_qtyoh = tt2a_qtyoh + ld_qty_oh.
              {xxqtylim.i tt1_qtyiss}
              {xxqtylim.i tt2a_qtyoh}

              IF tt1_nbr <> "" THEN
              DO:
                /****Jack Li***BEGIN DELETE**ECO:20110307095617*
                 RUN GET-ORDER-DETAILS IN THIS-PROCEDURE
                     (INPUT tt1_nbr      , INPUT tt1_part , OUTPUT tt1_line ,
                      OUTPUT tt1_dataset , OUTPUT tt1_qtyopn , OUTPUT tt1_cust,
                      OUTPUT tt1_recsite , OUTPUT tt1_qtyall,
                      OUTPUT tt1_soum    , OUTPUT tt1_um_conv).  /*20090605102535*/            ****Jack Li***END DELETED**ECO:20110307095617*/

                /****Jack Li***BEGIN ADD**ECO:20110307095617*/
                 RUN GET-ORDER-DETAILS2 IN THIS-PROCEDURE
                     (INPUT tt1_nbr      , INPUT tt1_part , INPUT-OUTPUT tt1_line ,
                      OUTPUT tt1_dataset , OUTPUT tt1_qtyopn, OUTPUT tt1_cust ,
                      OUTPUT tt1_recsite , OUTPUT tt1_qtyall,
                      OUTPUT tt1_soum    , OUTPUT tt1_um_conv,
		     OUTPUT m_chr01_a ). /*linas42955*/

            /****Jack Li***BEGIN ADD**ECO:20110307095617*/
              END. /**IF tt1_nbr <> "" THEN**/

              tt1_line   = ld__chr04. /*jackl**ECO:20110307095617*/
           END. /**IF NOT AVAIL tt1_det THEN**/
         END. /**EACH ld_det**/
      END. /**IF NOT AVAIL tt2a_det THEN**/

      IF m_screen THEN
         DISP tt2a_ref tt2a_nbr
                 WITH FRAME a1h.
      ELSE DISP tt2a_ref tt2a_part tt2a_um tt2a_qtyoh tt2a_site tt2a_nbr
                WITH FRAME a1.

      IF m_screen THEN
         DOWN 1 WITH FRAME a1h.
      ELSE DOWN 1 WITH FRAME a1.
    END. /**END OF REPEAT**/

    IF NOT CAN-FIND(FIRST tt1_det WHERE tt1_qtyiss <> 0
                                     AND tt1_nbr  <> ""  ) THEN
    DO:
       MESSAGE m_mesdesc[14].
/*davidw:1959*/  RUN sendbell  IN THIS-PROCEDURE.
       PAUSE.
       LEAVE mainloop.
    END. /**IF NOT CAN-FIND(FIRST tt1_det WHERE tt1_qtyiss <> 0 ) THEN**/

    RUN STOCK-DEALLOCATION IN THIS-PROCEDURE.
    n_count = 0. /*jackl 20090527133626*/
    IF NOT m_cimerr AND m_yn THEN DO:
       m_prttype = 1.  /*20130313104409*/
       PAUSE 0 BEFORE-HIDE.
         /* {gprun.i ""xxpltppc.p""} */    /* jerryg ECO:105119 */
/* jerryg add start ECO:105119 */
         IF m_epsma THEN DO:
            {gprun.i ""xxapltppc.p""}
         END. /* IF m_epsma */
         ELSE DO:
           /***Jihui 20140205165345 Begin***/
           FIND FIRST code_mstr where code_domain = global_domain
	               and code_fldname = "xx_pallet_creation"
                       and code_value = "CHN"
                       no-lock no-error.
           IF AVAIL code_mstr then
              {gprun.i ""xxpltppccn.p""}
           ELSE
           /***Jihui 20140205165345 END ***/
              {gprun.i ""xxpltppc.p""}

         END. /* ELSE DO: */
/* jerryg add end ECO:105119 */
       HIDE FRAME a NO-PAUSE.
    END. /**IF NOT m_cimerr THEN DO:**/


  END. /**END OF REPEAT**/

END. /**SODODELINK-PALLET**/


PROCEDURE SHIPPERDELINK-PALLET:
  n_count = 0. /*jackl 20090527133626*/
  FORM
      tt2a_ref    COLUMN-LABEL {&xxictpc_p_10}
      VALIDATE(CAN-FIND(FIRST ld_det
                        WHERE ld_domain = GLOBAL_domain
                          AND ld_ref    = INPUT FRAME a1 tt2a_ref
                          AND ld__chr01 <> ""
                          AND ld__chr02 <> "" NO-LOCK ) AND
               INPUT FRAME a1 tt2a_ref <> "" ,
               m_mesdesc[5])
      tt2a_part
      tt2a_um
      tt2a_qtyoh
      tt2a_site
      tt2a_nbr     COLUMN-LABEL "Shipper" FORMAT "X(9)"
      WITH FRAME a1 DOWN.

  FORM
      tt2a_ref     COLUMN-LABEL {&xxictpc_p_10}
      VALIDATE(CAN-FIND(FIRST ld_det
                        WHERE ld_domain = GLOBAL_domain
                          AND ld_ref    = INPUT FRAME a1h tt2a_ref
                          AND ld__chr01 <> ""
                          AND ld__chr02 <> "" NO-LOCK ) AND
               INPUT FRAME a1h tt2a_ref <> "",
               m_mesdesc[5])
      tt2a_nbr     COLUMN-LABEL "Shipper" FORMAT "X(9)"
    WITH FRAME a1h DOWN.

  mainloop:
  REPEAT:
    EMPTY TEMP-TABLE tt2a_det.
    EMPTY TEMP-TABLE tt1_det.
    EMPTY TEMP-TABLE tt4_det.

    CLEAR FRAME a1 ALL NO-PAUSE.
    CLEAR FRAME a1h ALL NO-PAUSE.
    m_sernbr = "".
    detloop:
    REPEAT:

      IF m_screen THEN
      DO:
          PROMPT-FOR tt2a_ref
              WITH FRAME a1h EDITING:
              {mfnp.i tt2a_det tt2a_ref tt2a_ref tt2a_ref tt2a_ref
                      tt2a_ref}
               IF recno <> ? THEN
                  DISP tt2a_ref tt2a_nbr
                       WITH FRAME a1h.
          END. /**ROMPT-FOR tt12_lot**/
      END. /**HHT SCREEN**/
      ELSE DO:
          PROMPT-FOR tt2a_ref
              WITH FRAME a1 EDITING:
              {mfnp.i tt2a_det tt2a_ref tt2a_ref tt2a_ref tt2a_ref
                      tt2a_ref}
               IF recno <> ? THEN
                  DISP tt2a_ref tt2a_part tt2a_um tt2a_qtyoh tt2a_site tt2a_nbr
                       WITH FRAME a1.
          END. /**PROMPT-FOR tt12_lot**/

      END. /**MFG/PRO SCREEN**/

      ASSIGN m_part = ""
             m_site = ""
             m_loc  = ""
             m_lot  = ""
             m_ref  = (IF m_screen THEN INPUT FRAME a1h tt2a_ref
                       ELSE INPUT FRAME a1 tt2a_ref )
             m_sernbr = m_ref
             m_nbr    = ""
             m_recid  = ?
             gpglef   = 0
             m_trtype = ""
             m_error  = NO.

      RUN GET-ITEM-FROM-LOTREF IN THIS-PROCEDURE.

      IF m_error THEN
         UNDO detloop , RETRY detloop.

      /* DELETE */
      IF LASTKEY = KEYCODE("F5") OR LASTKEY = KEYCODE("CTRL-D")
      THEN do:
         del-yn = no.
         /* Please confirm delete */
         {pxmsg.i &MSGNUM=11 &ERRORLEVEL=1 &CONFIRM=del-yn}
         IF del-yn THEN
         DO:
            FOR EACH tt1_det
                WHERE tt1_ref = m_ref:
               DELETE tt1_det.
            END. /**EACH tt1_det**/

            FIND FIRST tt2a_det
                  WHERE tt2a_ref  = m_ref NO-ERROR.
            IF AVAIL tt2a_det THEN
               DELETE tt2a_det.
            IF m_screen THEN DO:
               CLEAR FRAME a1h.
               n_count = n_count - 1. /*jackl 20090527133626*/
               Message "Sum to scan:" n_count. /*jackl 20090527133626*/
            END.
            ELSE
               CLEAR FRAME a1.
            UNDO detloop, RETRY detloop.
         END. /**IF del-yn THEN**/
      END. /**IF LASTKEY = KEYCODE("F5") OR LASTKEY = KEYCODE("CTRL-D")*/

      FIND FIRST tt2a_det
           WHERE tt2a_ref  = m_ref NO-ERROR.
      IF NOT AVAIL tt2a_det THEN
      DO:
         CREATE tt2a_det.
         ASSIGN tt2a_ref   = m_ref
                tt2a_part  = m_part
                tt2a_site  = m_site.
         n_count = n_count + 1. /*jackl 20090527133626*/
         Message "Sum to scan:" n_count. /*jackl 20090527133626*/
         FOR FIRST pt_mstr
             FIELDS(pt_um pt_desc1)
             WHERE pt_domain = GLOBAL_domain
               AND pt_part = m_part NO-LOCK:
         END. /**FOR FIRST pt_mstr**/
         IF AVAIL pt_mstr THEN
            ASSIGN tt2a_um     = pt_um
                   tt2a_desc   = pt_desc1.

         FOR EACH ld_det
             FIELDS(ld_lot ld_qty_oh ld__chr01 ld__chr02)
             WHERE ld_domain = GLOBAL_domain
               AND ld_ref    = m_ref
               AND ld_part   = m_part
               AND ld_site   = m_site
               AND ld_loc    = m_loc
               AND ld__chr02 <> ""
               AND TRUNCATE(ld_qty_oh , 3) <> 0 NO-LOCK :

           IF ld__chr02 = "" THEN
           DO:
              MESSAGE m_mesdesc[34].
              NEXT.
           END. /**IF tt1_nbr = "" THEN**/

           FIND FIRST tt1_det
                WHERE tt1_lot   = ld_lot
                  AND tt1_ref   = m_ref
                  AND tt1_site  = m_site
                  AND tt1_loc   = m_loc
                  AND tt1_part  = m_part NO-ERROR.
           IF NOT AVAIL tt1_det THEN
           DO:
              CREATE tt1_det.
              ASSIGN tt1_lot    = ld_lot
                     tt1_syslot = ld_lot
                     tt1_ref    = m_ref
                     tt1_ref1   = m_ref
                     tt1_site   = m_site
                     tt1_loc    = m_loc
                     tt1_loc1   = m_loc
                     tt1_part   = m_part
                     tt1_qtyiss = ld_qty_oh
                     tt1_nbr    = ld__chr02
                     tt2a_nbr   = ld__chr02
                     tt2a_qtyoh = tt2a_qtyoh + ld_qty_oh.

           END. /**IF NOT AVAIL tt1_det THEN**/
         END. /**EACH ld_det**/
      END. /**IF NOT AVAIL tt2a_det THEN**/

      IF m_screen THEN
         DISP tt2a_ref tt2a_nbr
                 WITH FRAME a1h.
      ELSE DISP tt2a_ref tt2a_part tt2a_um tt2a_qtyoh tt2a_site tt2a_nbr
                WITH FRAME a1.

      IF m_screen THEN
         DOWN 1 WITH FRAME a1h.
      ELSE DOWN 1 WITH FRAME a1.
    END. /**END OF REPEAT**/

    IF NOT CAN-FIND(FIRST tt1_det WHERE tt1_qtyiss <> 0
                                     AND tt1_nbr  <> ""  ) THEN
    DO:
       MESSAGE m_mesdesc[14].
/*davidw:1959*/  RUN sendbell  IN THIS-PROCEDURE.
       PAUSE.
       LEAVE mainloop.
    END. /**IF NOT CAN-FIND(FIRST tt1_det WHERE tt1_qtyiss <> 0 ) THEN**/

    RUN SHIPPER-DEALLOCATION IN THIS-PROCEDURE.
    n_count = 0. /*jackl 20090527133626*/
  END. /**END OF REPEAT**/

END. /**SODODELINK-PALLET**/

PROCEDURE SODODELINK-ORDER:
  n_count = 0. /*jackl 20090527133626*/
  FORM
      tt5_nbr   COLUMN-LABEL {&xxictpc_p_19}
      tt5_cust
      WITH FRAME a1 DOWN.

  mainloop:
  REPEAT:
    EMPTY TEMP-TABLE tt5_det.
    EMPTY TEMP-TABLE tt1_det.

    CLEAR FRAME a1 ALL NO-PAUSE.

    detloop:
    REPEAT:

      PROMPT-FOR tt5_nbr
          GO-ON (CTRL-D F5) WITH FRAME a1 EDITING:
          {mfnp.i tt5_det tt5_nbr tt5_nbr tt5_nbr tt5_nbr tt5_nbr}
           IF recno <> ? THEN
              DISP tt5_nbr tt5_cust
                   WITH FRAME a1 DOWN.
      END. /**PROMPT-FOR tt12_lot**/

      ASSIGN m_part   = ""
             m_site   = ""
             m_loc    = ""
             m_lot    = ""
             m_syslot = ""
             m_ref    = ""
             m_nbr    = INPUT FRAME a1 tt5_nbr
             m_recid  = ?
             gpglef   = 0
             m_trtype = ""
             m_error  = NO.

      RUN GET-ITEM-FROM-LOTREF IN THIS-PROCEDURE.

      IF m_error THEN
         UNDO detloop , RETRY detloop.

      /* DELETE */
      IF LASTKEY = KEYCODE("F5") OR LASTKEY = KEYCODE("CTRL-D")
      THEN do:
         del-yn = no.
         /* Please confirm delete */
         {pxmsg.i &MSGNUM=11 &ERRORLEVEL=1 &CONFIRM=del-yn}
         IF del-yn THEN
         DO:
            FOR EACH tt1_det
                WHERE tt1_nbr = m_nbr :
                DELETE tt1_det.
            END. /**EACH tt1_det**/

            FIND FIRST tt5_det
                 WHERE tt5_nbr = m_nbr NO-ERROR.
            IF AVAIL tt5_det THEN
               DELETE tt5_det.
            CLEAR FRAME a1.
            n_count = n_count - 1. /*jackl 20090527133626*/
            Message "Sum to scan:" n_count. /*jackl 20090527133626*/
            UNDO detloop, RETRY detloop.
         END. /**IF del-yn THEN**/
      END. /**IF LASTKEY = KEYCODE("F5") OR LASTKEY = KEYCODE("CTRL-D")*/

      FIND FIRST tt5_det
           WHERE tt5_nbr = m_nbr NO-ERROR.
      IF NOT AVAIL tt5_det THEN
      DO:
         CREATE tt5_det.
         ASSIGN tt5_nbr     = m_nbr
                tt5_dataset = m_dataset.
         n_count = n_count + 1. /*jackl 20090527133626*/
         Message "Sum to scan:" n_count. /*jackl 20090527133626*/
         IF tt5_dataset = "sod_det" THEN
         DO:
            FOR FIRST so_mstr
                FIELDS(so_cust)
                WHERE so_domain = global_domain
                  AND so_nbr = tt5_nbr NO-LOCK:
            END. /**FOR FIRST so_mstr**/
            IF AVAIL so_mstr THEN
               tt5_cust = so_cust.
            FOR EACH lad_det
                FIELDS(lad_part lad_site lad_loc lad_lot lad_ref  lad_qty_all
                       lad_nbr lad_line ) NO-LOCK
                WHERE lad_domain  = GLOBAL_domain
                  AND lad_dataset = m_dataset
                  AND lad_nbr     = m_nbr
                  AND lad_qty_all <> 0 :
                FIND FIRST tt1_det
                     WHERE tt1_lot   = lad_lot
                       AND tt1_ref   = lad_ref
                       AND tt1_site  = lad_site
                       AND tt1_loc   = lad_loc
                       AND tt1_part  = lad_part NO-ERROR.
                IF NOT AVAIL tt1_det THEN
                DO:
                   CREATE tt1_det.
                   ASSIGN tt1_lot     = lad_lot
                          tt1_syslot  = lad_lot
                          tt1_ref     = lad_ref
                          tt1_ref1    = lad_ref
                          tt1_site    = lad_site
                          tt1_loc     = lad_loc
                          tt1_loc1    = lad_loc
                          tt1_part    = lad_part
                          tt1_qtyiss  = lad_qty_all
                          tt1_nbr     = lad_nbr
                          tt1_line    = lad_line
                          tt1_dataset = m_dataset.
                END. /**IF NOT AVAIL tt1_det THEN**/
            END. /**EACH lad_det**/
         END. /**IF tt5_dataset = "sod_det" THEN**/
         ELSE DO:
             FOR FIRST dss_mstr
                 FIELDS(dss_rec_site dss_shipsite)
                 WHERE dss_domain = GLOBAL_domain
                   AND dss_nbr    = tt5_nbr NO-LOCK:
             END. /**FOR FIRST dss_mstr**/
             IF AVAIL dss_mstr THEN
                 ASSIGN tt5_cust     = dss_rec_site
                        tt5_shipsite = dss_shipsite
                        tt5_recsite  = dss_rec_site
                        tt5_site     = dss_shipsite.

             FOR EACH dsd_det
                 FIELDS(dsd_req_nbr)
                 WHERE dsd_domain   = GLOBAL_domain
                   AND dsd_nbr      = tt5_nbr
                   AND dsd_shipsite = dss_shipsite NO-LOCK :
                 FOR EACH lad_det
                     FIELDS(lad_part lad_site lad_loc lad_lot lad_ref
                            lad_qty_all ) NO-LOCK
                     WHERE lad_domain  = GLOBAL_domain
                       AND lad_dataset = m_dataset
                       AND lad_nbr     = dsd_req_nbr
                       AND lad_line    = tt5_recsite
                       AND lad_site    = tt5_site
                       AND lad_qty_all <> 0 :
                     FIND FIRST tt1_det
                          WHERE tt1_lot   = lad_lot
                            AND tt1_ref   = lad_ref
                            AND tt1_site  = lad_site
                            AND tt1_loc   = lad_loc
                            AND tt1_part  = lad_part NO-ERROR.
                     IF NOT AVAIL tt1_det THEN
                     DO:
                        CREATE tt1_det.
                        ASSIGN tt1_lot     = lad_lot
                               tt1_syslot  = lad_lot
                               tt1_ref     = lad_ref
                               tt1_ref1    = lad_ref
                               tt1_site    = lad_site
                               tt1_loc     = lad_loc
                               tt1_loc1    = lad_loc
                               tt1_part    = lad_part
                               tt1_qtyiss  = lad_qty_all
                               tt1_nbr     = tt5_nbr
                               tt1_line    = dsd_req_nbr
                               tt1_recsite = tt5_recsite
                               tt1_dataset = m_dataset.
                     END. /**IF NOT AVAIL tt1_det THEN**/
                 END. /**EACH lad_det**/
             END. /**EACH dsd_det**/
         END. /**ELSE DO**/
      END. /**IF NOT AVAIL tt5_det THEN**/
      DISP tt5_cust
           WITH FRAME a1 DOWN.

      DOWN 1 WITH FRAME a1.

    END. /**END OF REPEAT**/

    IF NOT CAN-FIND(FIRST tt1_det
                    WHERE tt1_qtyiss <> 0 AND tt1_nbr <> "" ) THEN
    DO:
       MESSAGE m_mesdesc[14].
/*davidw:1959*/  RUN sendbell  IN THIS-PROCEDURE.
       PAUSE.
       LEAVE mainloop.
    END. /**IF NOT CAN-FIND(FIRST tt1_det WHERE tt1_qtyiss <> 0 ) THEN**/

    RUN STOCK-DEALLOCATION IN THIS-PROCEDURE.
    n_count = 0. /*jackl 20090527133626*/
  END. /**END OF REPEAT**/
END. /**SODODELINK-ORDER**/

PROCEDURE SODOSHIP-LOT:
  n_count = 0. /*jackl 20090527133626*/
  m_effdate = today. /*David Wei*20130313151437*/
  FORM
      tt1_lot
      VALIDATE(INPUT FRAME a1 tt1_lot <> ""
               AND LENGTH(INPUT FRAME a1 tt1_lot) = 9 , m_mesdesc[3])
      tt1_part
      tt1_um
      tt1_qtyiss
      tt1_site
      tt1_nbr  COLUMN-LABEL {&xxictpc_p_19}
      WITH FRAME a1 DOWN.

  FORM
    tt1_lot    COLUMN-LABEL {&xxictpc_p_09}
    VALIDATE(INPUT FRAME a1h tt1_lot <> ""
             AND LENGTH(INPUT FRAME a1h tt1_lot) = 9 , m_mesdesc[3])
    tt1_nbr    COLUMN-LABEL {&xxictpc_p_19}
    WITH FRAME a1h DOWN.

  mainloop:
  REPEAT:
    EMPTY TEMP-TABLE tt1_det.

    ASSIGN m_soline = 0. /* Nilay */

    CLEAR FRAME a1 ALL NO-PAUSE.
    CLEAR FRAME a1h ALL NO-PAUSE.
    CLEAR FRAME a  ALL NO-PAUSE.  /*Jack Li**/

    detloop:
    REPEAT:

      IF m_screen THEN
      DO:
          PROMPT-FOR tt1_lot
              GO-ON (CTRL-D F5) WITH FRAME a1h EDITING:
              {mfnp.i tt1_det tt1_lot tt1_lot tt1_lot tt1_lot
                      tt1_a}
               IF recno <> ? THEN
                  DISP tt1_lot tt1_nbr
                       WITH FRAME a1h.
          END. /**ROMPT-FOR tt12_lot**/
      END. /**HHT SCREEN**/
      ELSE DO:
          PROMPT-FOR tt1_lot
              GO-ON (CTRL-D F5) WITH FRAME a1 EDITING:
              {mfnp.i tt1_det tt1_lot tt1_lot tt1_lot tt1_lot
                      tt1_a}
               IF recno <> ? THEN
                  DISP tt1_lot tt1_part tt1_um tt1_qtyiss tt1_site tt1_nbr
                       WITH FRAME a1.
          END. /**ROMPT-FOR tt12_lot**/

      END. /**MFG/PRO SCREEN**/

      ASSIGN m_part   = ""
             m_site   = ""
             m_loc    = ""
             m_lot    = (IF m_screen THEN INPUT FRAME a1h tt1_lot
                         ELSE INPUT FRAME a1 tt1_lot )
             m_syslot = ""
             m_ref    = ""
             m_nbr    = ""
             m_recid  = ?
             gpglef   = 0
             m_trtype = ""
             m_error  = NO.

      RUN GET-ITEM-FROM-LOTREF IN THIS-PROCEDURE.

      IF m_error THEN
         UNDO detloop , RETRY detloop.

      /* DELETE */
      IF LASTKEY = KEYCODE("F5") OR LASTKEY = KEYCODE("CTRL-D")
      THEN do:
         del-yn = no.
         /* Please confirm delete */
         {pxmsg.i &MSGNUM=11 &ERRORLEVEL=1 &CONFIRM=del-yn}
         IF del-yn THEN
         DO:
            FIND FIRST tt1_det
                 WHERE tt1_lot = m_lot NO-ERROR.
            IF AVAIL tt1_det THEN
               DELETE tt1_det.
            IF m_screen THEN DO:
               CLEAR FRAME a1h.
               n_count = n_count - 1. /*jackl 20090527133626*/
               Message "Tot Scanned:" n_count. /*jackl 20090527133626*/
            END.
            ELSE
               CLEAR FRAME a1.
            UNDO detloop, RETRY detloop.
         END. /**IF del-yn THEN**/
      END. /**IF LASTKEY = KEYCODE("F5") OR LASTKEY = KEYCODE("CTRL-D")*/

      FIND FIRST tt1_det
           WHERE tt1_lot  = m_lot NO-ERROR.
      IF NOT AVAIL tt1_det THEN
      DO:
         CREATE tt1_det.
         ASSIGN tt1_lot    = m_lot
                tt1_syslot = m_syslot
                tt1_part   = m_part
                tt1_site   = m_site
                tt1_loc    = m_loc.
         n_count = n_count + 1. /*jackl 20090527133626*/

         /* Nilay Code Starts Here */
         FIND FIRST lad_det WHERE lad_domain = GLOBAL_domain
                            AND   (lad_lot    = TRIM(m_syslot) OR lad_lot BEGINS m_lot)
         NO-LOCK NO-ERROR.
         IF AVAIL lad_det THEN
         DO:
            ASSIGN m_soline = INT(lad_line) NO-ERROR.
         END.
         /* Nilay Code Ends Here */

         /*Message "Sum to scan:" n_count. /*jackl 20090527133626*/ 20130912094300*/

         FOR FIRST pt_mstr
             FIELDS(pt_um pt_desc1)
             WHERE pt_domain = GLOBAL_domain
                AND pt_part = m_part NO-LOCK:
         END. /**FOR FIRST pt_mstr**/
         IF AVAIL pt_mstr THEN
            ASSIGN tt1_um    = pt_um
                   tt1_desc  = pt_desc1.

         FOR FIRST ld_det
             FIELDS(ld__chr01 ld_qty_oh)
             WHERE RECID(ld_det) = m_recid NO-LOCK:
         END. /**FOR FIRST ld_det**/
         IF AVAIL ld_det THEN
         DO:
            ASSIGN tt1_nbr    = ld__chr01
                   tt1_qtyiss = ld_qty_oh.
            {xxqtylim.i tt1_qtyiss}
         END. /**IF AVAIL ld_det THEN**/
         IF tt1_nbr <> "" THEN
         DO:
           /*Jack Li ***ADD BEGIN***ECO#:20091207165510*/
           FOR FIRST so_mstr
                     FIELDS(so_stat)
                      WHERE so_domain = global_domain
                        AND so_nbr    = tt1_nbr NO-LOCK :
             if so_stat = "HD" then do:
                if not m_error then do:
                   MESSAGE "ERROR:Sales Number " + tt1_nbr
                   + " placed on credit hold".
                   RUN sendbell  IN THIS-PROCEDURE.
                end.
                tt1_nbr = "".  m_error = Yes.
             end.
            END.
           /*Jack Li ***ADDED END***ECO#:20091207165510*/

             RUN GET-ORDER-DETAILS IN THIS-PROCEDURE
                 (INPUT tt1_nbr      , INPUT tt1_part , OUTPUT tt1_line ,
                  OUTPUT tt1_dataset , OUTPUT tt1_qtyopn  , OUTPUT tt1_cust,
                  OUTPUT tt1_recsite , OUTPUT tt1_qtyall,
                      OUTPUT tt1_soum    , OUTPUT tt1_um_conv).  /*20090605102535*/

            IF tt1_dataset = "" then DO:
               if not m_error then do:
                  MESSAGE m_mesdesc[4].
/*davidw:1959*/   RUN sendbell  IN THIS-PROCEDURE.
               end.
                  tt1_nbr = "".  m_error = Yes.
            END. /**IF tt1_dataset = "" THEN**/

            IF tt1_dataset = "sod_det" THEN
            DO:

               FOR FIRST sod_det
                   FIELDS(sod_btb_type)
                   WHERE sod_domain = GLOBAL_domain
                     AND sod_nbr = tt1_nbr
                     AND (sod_btb_type = "02" or sod_btb_type = "03") NO-LOCK:
               END. /**FOR FIRST sod_det**/
               IF AVAILABLE sod_det THEN DO:
                  if not m_error then  do:
                     MESSAGE m_mesdesc[28].
/*davidw:1959*/      RUN sendbell  IN THIS-PROCEDURE.
                  end.
                    tt1_nbr = "". m_error = Yes.
               END. /**IF AVAILABLE sod_det THEN DO:**/

        /*Jack Li*****ADD BEGIN****ECO:20130124143111*/
            FIND FIRST code_mstr NO-LOCK WHERE code_domain = global_domain
                   AND code_fldname = "xx_soreason_switch" NO-ERROR.
            IF NOT AVAILABLE code_mstr THEN DO:
        /*Jack Li*****ADDED END****ECO:20130124143111*/

               FOR FIRST sod_det
                   FIELD(sod_nbr sod_line)
                   WHERE sod_domain = GLOBAL_domain
                     AND sod_nbr    = tt1_nbr
                     AND sod_line   = INT(tt1_line)
                     AND sod_due_date < m_effdate NO-LOCK:


                  FOR LAST tr_hist
                      FIELD(tr_rsn_code)
                      WHERE tr_domain = GLOBAL_domain
                        AND tr_nbr    = sod_nbr
                        AND tr_line   = sod_line
                        AND tr_type   = "ORD-SO" 
                        AND (tr_program = "xxsosomt.p" /*Jihui 20130902142221*/
                         OR tr_program = "xxsosold.p") /*Jihui 20130902142221*/
                        NO-LOCK:
                  END. /** FOR LAST tr_hist **/
                  IF AVAIL tr_hist THEN
                  DO:
                  /* IF tr_rsn_code <> "" AND ENTRY(3 , tr_rsn_code) = ""
                     THEN DO:      *jackl*/
                     IF tr_rsn_code = "" or (tr_rsn_code <> ""
                        AND ENTRY(3 , tr_rsn_code) = "") THEN DO: /*jackl*/
                        if not m_error then do:
                           MESSAGE m_mesdesc[41].
/*davidw:1959*/            RUN sendbell  IN THIS-PROCEDURE.
                           n_count = max(0, (n_count - 1)). /*20130912094300*/
                           PAUSE. /*20121222144910*/
                           for each tt1_det where tt1_lot = INPUT FRAME a1h tt1_lot:
                               delete tt1_det.
                           end.
                           m_error = Yes. /*20130912094300*/
                           UNDO detloop , RETRY detloop. /*20130912094300*/
                        end.
                        /*tt1_nbr = "".  m_error = Yes. 20130912094300*/
                     END. /**IF AVAILABLE sod_det THEN DO:**/
                  END. /**IF AVAIL tr_hist THEN**/
               END. /**FOR FIRST sod_det**/
            END. /*IF NOT AVAILABLE code_mstr*/ /*20130124143111*/

               FOR FIRST so_mstr
                  FIELDS(so_ship)
                  WHERE so_domain = global_domain
                    AND so_nbr    = tt1_nbr NO-LOCK :
                FOR FIRST ad_mstr
                    FIELDS(ad_ctry)
                    WHERE ad_domain = GLOBAL_domain
                      AND ad_addr   = so_ship NO-LOCK:
                  IF m_ctry <> "" AND m_ctry <> ad_ctry THEN DO:
                    if not m_error then do:
                       MESSAGE m_mesdesc[37].
/*davidw:1959*/        RUN sendbell  IN THIS-PROCEDURE.
                    end.
                       tt1_nbr = "".  m_error = Yes.
                   END. /**IF m_ctry <> "" AND m_ctry <> ad_ctry THEN**/
                END. /**FOR FIRST ad_mstr**/

               END. /**FOR FIRST so_mstr**/

/*linas60107**begin*/
              IF SHIPPMENT-LOCK(tt1_nbr)   THEN DO:
                   MESSAGE "ERROR: Invoice is not done:"
                                   + tt1_nbr.

                   RUN sendbell  IN THIS-PROCEDURE.
                   tt1_nbr = "".  m_error = Yes.
                    UNDO detloop, RETRY detloop.
              END.
/*linas60107**end*/

            END. /**IF tt1_dataset = "sod_det" THEN**/

         END. /**IF tt42_nbr <> "" THEN**/

      END. /**IF NOT AVAIL tt1_det THEN**/
   /***Jack Li*****ADD BEGIN****ECO:20121222144910***/
      ELSE DO:
         IF tt1_nbr <> "" THEN                   /*Jihui 20130912094300*/
            MESSAGE "This Lot has already scan". 
         RUN sendbell  IN THIS-PROCEDURE.
         UNDO detloop, RETRY detloop.
      END.
   /***Jack Li*****ADDED END****ECO:20121222144910***/

      /* MK15122010 >> */

      FIND FIRST tt4_det
               WHERE tt4_nbr  = tt1_nbr
                 AND tt4_part = tt1_part
                 AND tt4_line = tt1_line
                 NO-ERROR.
          IF NOT AVAIL tt4_det THEN
          DO:
             CREATE tt4_det.
             ASSIGN tt4_nbr     = tt1_nbr
                    tt4_part    = tt1_part
                    tt4_line    = tt1_line
                    tt4_qtyord  = tt1_qtyopn
                    tt4_qtyall  = 0
                    tt4_cust    = tt1_cust
                    tt4_dataset = tt1_dataset.
          END. /**IF NOT AVAIL tt4_det THEN**/
          tt4_qtyall = tt4_qtyall + tt1_qtyiss.

          IF AVAIL tt4_det THEN
          DO:

              MESSAGE "O"  + STRING(tt4_qtyord , "->>,>>9.99" ) +
                      "S"  + STRING(tt4_qtyall , "->>,>>9.99" ).


             IF tt4_qtyall > tt4_qtyord * ( 1 + (m_overshipct * 0.01))
             AND tt4_dataset = "sod_det" AND
             NOT CAN-FIND(FIRST CODE_mstr
                          WHERE CODE_domain  = GLOBAL_domain
                            AND CODE_fldname = "xx_so_overshipment_CUST_EXC"
                            AND CODE_value   = tt4_cust)
            THEN DO:
               ASSIGN tt1_nbr     = ""
                      tt1_dataset = ""
                      tt4_qtyall  = tt4_qtyall - tt1_qtyiss.

               MESSAGE m_mesdesc[40].
               RUN sendbell  IN THIS-PROCEDURE.
               UNDO detloop, RETRY detloop.
            END. /**IF tt4_qtyall > tt4_qtyord * ( 1 + (m_overshipct * 0.01)) THEN**/

          END. /**IF AVAIL tt4_det THEN**/

      /* << MK15122010 */

      IF m_screen THEN DO:
          DISP tt1_lot tt1_nbr
               WITH FRAME a1h.
          Message "Tot Scanned:" n_count. /*20130912094300*/
      END.
      ELSE
          DISP tt1_lot tt1_part tt1_um tt1_qtyiss tt1_site tt1_nbr
               WITH FRAME a1.

        IF m_screen THEN
           DOWN 1 WITH FRAME a1h.
        ELSE DOWN 1 WITH FRAME a1.
    END. /**END OF REPEAT**/

    IF NOT CAN-FIND(FIRST tt1_det
                    WHERE tt1_qtyiss <> 0
                      AND tt1_nbr <> "" ) THEN
    DO:
       MESSAGE m_mesdesc[14].
/*davidw:1959*/  RUN sendbell  IN THIS-PROCEDURE.
       PAUSE.
       LEAVE mainloop.
    END. /**IF NOT CAN-FIND(FIRST tt1_det WHERE tt1_qtyiss <> 0 ) THEN**/

    RUN SODOSHIPCIM IN THIS-PROCEDURE.
    n_count = 0. /*jackl 20090527133626*/

  END. /**END OF REPEAT**/

END. /**SODOSHIP-LOT**/

PROCEDURE SODOSHIP-PALLET:
  n_count = 0. /*jackl 20090527133626*/
  FORM
      tt2a_ref    COLUMN-LABEL {&xxictpc_p_10}
      VALIDATE(CAN-FIND(FIRST ld_det
                        WHERE ld_domain = GLOBAL_domain
                          AND ld_ref    = INPUT FRAME a1 tt2a_ref
                          AND ld__chr01 <> ""
                          AND ld__chr02 = "" NO-LOCK ) AND
               INPUT FRAME a1 tt2a_ref <> "" ,
               m_mesdesc[5])
      tt2a_part
      tt2a_um
      tt2a_qtyoh
      tt2a_site
      tt2a_nbr    COLUMN-LABEL {&xxictpc_p_19}
      WITH FRAME a1 DOWN.

  FORM
    tt2a_ref     COLUMN-LABEL {&xxictpc_p_10}
    VALIDATE(CAN-FIND(FIRST ld_det
                        WHERE ld_domain = GLOBAL_domain
                          AND ld_ref    = INPUT FRAME a1h tt2a_ref
                          AND ld__chr01 <> ""
                          AND ld__chr02 = "" NO-LOCK ) AND
               INPUT FRAME a1h tt2a_ref <> "" ,
               m_mesdesc[5])
    tt2a_nbr     COLUMN-LABEL {&xxictpc_p_19}
    WITH FRAME a1h DOWN.

  mainloop:
  REPEAT:
    EMPTY TEMP-TABLE tt2a_det.
    EMPTY TEMP-TABLE tt1_det.

    CLEAR FRAME a1 ALL NO-PAUSE.
    CLEAR FRAME a1h ALL NO-PAUSE.

    detloop:
    REPEAT:

      IF m_screen THEN
      DO:
          PROMPT-FOR tt2a_ref
              GO-ON (CTRL-D F5) WITH FRAME a1h EDITING:
              {mfnp.i tt2a_det tt2a_ref tt2a_ref tt2a_ref tt2a_ref
                      tt2a_ref}
               IF recno <> ? THEN
                  DISP tt2a_ref tt2a_nbr
                       WITH FRAME a1h.
          END. /**ROMPT-FOR tt12_lot**/
      END. /**HHT SCREEN**/
      ELSE DO:
          PROMPT-FOR tt2a_ref
              GO-ON (CTRL-D F5) WITH FRAME a1 EDITING:
              {mfnp.i tt2a_det tt2a_ref tt2a_ref tt2a_ref tt2a_ref
                      tt2a_ref}
               IF recno <> ? THEN
                  DISP tt2a_ref tt2a_part tt2a_um tt2a_qtyoh tt2a_site tt2a_nbr
                       WITH FRAME a1.
          END. /**ROMPT-FOR tt12_lot**/

      END. /**MFG/PRO SCREEN**/

      ASSIGN m_part = ""
             m_lot  = ""
             m_site = ""
             m_loc  = ""
             m_ordqty  = 0 /*Jack Li*/
             m_shipqty = 0 /*Jack Li*/
             m_nbr  = ""
             m_trtype = "ISS-SO,ISS-DO,RCT-GIT"
             m_ref  = (IF m_screen THEN INPUT FRAME a1h tt2a_ref
                       ELSE INPUT FRAME a1 tt2a_ref ).

      EMPTY TEMP-TABLE ttord_det.

      RUN GET-ITEM-FROM-LOTREF IN THIS-PROCEDURE.

      IF m_error THEN
         UNDO detloop , RETRY detloop.

      /* DELETE */
      IF LASTKEY = KEYCODE("F5") OR LASTKEY = KEYCODE("CTRL-D")
      THEN do:
         del-yn = no.
         /* Please confirm delete */
         {pxmsg.i &MSGNUM=11 &ERRORLEVEL=1 &CONFIRM=del-yn}
         IF del-yn THEN
         DO:
            FOR EACH tt1_det
                WHERE tt1_ref = m_ref:
                DELETE tt1_det.
            END. /**EACH tt1_det**/

            FIND FIRST tt2a_det WHERE tt2a_ref = m_ref NO-ERROR.
            IF AVAIL tt2a_det THEN
               DELETE tt2a_det.
            IF m_screen THEN DO:
               CLEAR FRAME a1h.
               n_count = n_count - 1. /*jackl 20090527133626*/
               Message "Sum to scan:" n_count. /*jackl 20090527133626*/
            END.
            ELSE
               CLEAR FRAME a1.
            UNDO detloop, RETRY detloop.
         END. /**IF del-yn THEN**/
      END. /**IF LASTKEY = KEYCODE("F5") OR LASTKEY = KEYCODE("CTRL-D")*/

      FIND FIRST tt2a_det
           WHERE tt2a_ref  = m_ref NO-ERROR.
      IF NOT AVAIL tt2a_det THEN
      DO:
         CREATE tt2a_det.
         ASSIGN tt2a_ref    = m_ref
                tt2a_part   = m_part
                tt2a_site   = m_site
                tt2a_loc    = m_loc.
         n_count = n_count + 1. /*jackl 20090527133626*/
         /*Message "Sum to scan:" n_count. /*jackl 20090527133626*/ Jihui 20130912094300*/
         FOR EACH ld_det
             FIELDS(ld_part ld_lot ld__chr01 ld__chr04 ld_qty_oh)
             WHERE ld_domain = GLOBAL_domain
               AND ld_ref    = m_ref
               AND ld_site   = m_site
               AND ld_loc    = m_loc
               AND TRUNCATE(ld_qty_oh , 3) <> 0
               AND ld__chr01 <> ""  NO-LOCK :

               FIND FIRST tt1_det
                    WHERE tt1_ref   = m_ref
                      AND tt1_part  = ld_part
                      AND tt1_site  = m_site
                      AND tt1_loc   = m_loc
                      AND tt1_lot   = ld_lot NO-ERROR.
               IF NOT AVAIL tt1_det THEN
               DO:
                  CREATE tt1_det.
                  ASSIGN tt1_ref    = m_ref
                         tt1_part   = ld_part
                         tt1_site   = m_site
                         tt1_loc    = m_loc
                         tt1_lot    = ld_lot
                         tt1_syslot = ld_lot.
               END. /**IF NOT AVAIL tt1_det THEN**/
               ASSIGN tt1_nbr   = ld__chr01
                      tt1_line  = ld__chr04 /*jackl**ECO:20110307095617*/
                      tt2a_line  = ld__chr04 /*jackl**ECO:20110307095617*/
                      tt2a_nbr   = ld__chr01
                      tt1_qtyiss = ld_qty_oh
                      tt2a_qtyoh = tt2a_qtyoh + ld_qty_oh.
               m_shipqty = m_shipqty + ld_qty_oh.
               {xxqtylim.i m_shipqty}              /*Jack Li*/
               {xxqtylim.i tt1_qtyiss}
               {xxqtylim.i tt2a_qtyoh}

               IF tt1_nbr <> "" THEN
               DO:
                 /*Jack Li ***ADD BEGIN***ECO#:20091207165510*/
                 FOR FIRST so_mstr
                           FIELDS(so_stat)
                            WHERE so_domain = global_domain
                              AND so_nbr    = tt1_nbr NO-LOCK :
                  if so_stat = "HD" then do:
                     if not m_error then do:
                        MESSAGE "ERROR:Sales Number " + tt1_nbr
                        + " placed on credit hold".
                        RUN sendbell  IN THIS-PROCEDURE.
                     end.
                     tt1_nbr = "".  m_error = Yes.
                     tt2a_nbr = "".
                   end.
                  END.
                  /*Jack Li ***ADDED END***ECO#:20091207165510*/

                  /*Jack Li ***ADD BEGIN***ECO#:TEMP*/
                  FIND FIRST ds_det NO-LOCK WHERE ds_domain = global_domain
                                              AND ds_nbr = tt1_nbr
                                              AND ds_part = tt1_part
                                              NO-ERROR.
                  IF AVAILABLE ds_det THEN
                     tt1_line = ds_req_nbr.
                  /*Jack Li ***ADD BEGIN***ECO#:TEMP*/

                  /****Jack Li***BEGIN DELETE**ECO:20110307095617*
                  RUN GET-ORDER-DETAILS IN THIS-PROCEDURE
                      (INPUT tt1_nbr      , INPUT tt1_part , OUTPUT tt1_line ,
                       OUTPUT tt1_dataset , OUTPUT tt1_qtyopn , OUTPUT tt1_cust,
                       OUTPUT tt1_recsite , OUTPUT tt1_qtyall,
                      OUTPUT tt1_soum    , OUTPUT tt1_um_conv).  /*20090605102535*/              
                      ****Jack Li***END DELETED**ECO:20110307095617*/

                  /****Jack Li***BEGIN ADD**ECO:20110307095617*/
                  RUN GET-ORDER-DETAILS2 IN THIS-PROCEDURE
                      (INPUT tt1_nbr      , INPUT tt1_part , INPUT-OUTPUT tt1_line ,
                      OUTPUT tt1_dataset , OUTPUT tt1_qtyopn, OUTPUT tt1_cust ,
                      OUTPUT tt1_recsite , OUTPUT tt1_qtyall,
                      OUTPUT tt1_soum    , OUTPUT tt1_um_conv,
		     OUTPUT m_chr01_a ). /*linas42955*/

                  /****Jack Li***END ADDED**ECO:20110307095617*/

               FIND FIRST ttord_det
                    WHERE ttord_nbr  = tt1_nbr
                      and ttord_line = int(tt1_line)
                      NO-ERROR.
               IF NOT AVAIL ttord_det THEN
               DO:
                 CREATE ttord_det.
                 ASSIGN ttord_nbr    = tt1_nbr
                        ttord_line = int(tt1_line).
                        m_ordqty = m_ordqty + tt1_qtyopn.
                        {xxqtylim.i m_ordqty}
                END. /**IF NOT AVAIL tt4_det THEN**/

                  IF tt1_dataset = "" THEN DO:
/*davidw*/           if not m_error then do:
                        MESSAGE m_mesdesc[4].
/*davidw:1959*/         RUN sendbell  IN THIS-PROCEDURE.
                     end.
                     tt1_nbr = "".

                  END. /**IF tt1_dataset = "" THEN**/

                  IF tt1_dataset = "sod_det" THEN
                  DO:
                     FOR FIRST sod_det
                         FIELDS(sod_btb_type)
                         WHERE sod_domain = GLOBAL_domain
                           AND sod_nbr = tt1_nbr
                           AND (sod_btb_type = "02" or sod_btb_type = "03")
                      NO-LOCK:
                      END. /**FOR FIRST sod_det**/
                      IF AVAILABLE sod_det THEN DO:
/*davidw*/               if not m_error then do:
                            MESSAGE m_mesdesc[28].
/*davidw:1959*/             RUN sendbell  IN THIS-PROCEDURE.
                         end.
                         tt1_nbr = "".
                      END. /**IF AVAILABLE sod_det THEN DO:**/


                /*linas60107**begin*/
                     IF SHIPPMENT-LOCK(tt1_nbr)   THEN DO:
                         MESSAGE "ERROR: Invoice is not done:"
                                       + tt1_nbr.

                          RUN sendbell  IN THIS-PROCEDURE.
                          tt1_nbr = "".  m_error = Yes.
                          UNDO detloop , RETRY detloop.
                     END.
               /*linas60107**end*/

       /*Jack Li*****ADD BEGIN****ECO:20130124143111*/
               FIND FIRST code_mstr NO-LOCK WHERE code_domain = global_domain
                      AND code_fldname = "xx_soreason_switch" NO-ERROR.
               IF NOT AVAILABLE code_mstr THEN DO:
       /*Jack Li*****ADDED END****ECO:20130124143111*/
                     FOR FIRST sod_det
                         FIELD(sod_nbr sod_line)
                         WHERE sod_domain = GLOBAL_domain
                           AND sod_nbr    = tt1_nbr
                           AND sod_line   = INT(tt1_line)
                           AND sod_due_date < m_effdate NO-LOCK:

                        FOR LAST tr_hist
                            FIELD(tr_rsn_code)
                            WHERE tr_domain = GLOBAL_domain
                              AND tr_nbr    = sod_nbr
                              AND tr_line   = sod_line
                              AND tr_type   = "ORD-SO" 
                              AND (tr_program = "xxsosomt.p"  /*Jihui 20130902142221*/
                                OR tr_program = "xxsosold.p") /*Jihui 20130902142221*/
                              NO-LOCK:
                        END. /**FOR LAST tr_hist**/
                        IF AVAIL tr_hist THEN
                        DO:
                       /* IF tr_rsn_code <> "" AND ENTRY(3 , tr_rsn_code) = ""
                           THEN DO:      **jackl*/
                           IF tr_rsn_code = "" or (tr_rsn_code <> ""
/*jackl*/                     AND ENTRY(3 , tr_rsn_code) = "") THEN DO:
/*davidw*/                    if not m_error then do:
                                 MESSAGE m_mesdesc[41].
/*davidw:1959*/                  RUN sendbell  IN THIS-PROCEDURE.
                                 PAUSE. /*20121222144910*/
                                 n_count = max(0, (n_count - 1 )). /*Jihui 20130912094300*/                                 
                              end.
                              /* tt1_nbr = "".  m_error = Yes. Jihui 20130912094300*/

                              /***Jihui Added Begin 20130912094300***/
                              for each tt1_det where tt1_ref = INPUT FRAME a1h tt2a_ref:
                                  delete tt1_det.
                              end.
                              for each tt2a_det where tt2a_ref = INPUT FRAME a1h tt2a_ref:
                                  delete tt2a_det.
                              end.
                              /***Jihui Added End   20130912094300***/                              
 
                              UNDO detloop , RETRY detloop.
                           END. /**IF AVAILABLE sod_det THEN DO:**/
                        END. /**IF AVAIL tr_hist THEN**/
                     END. /**FOR FIRST sod_det**/
               END. /*IF NOT AVAILABLE code_mstr*/ /*20130124143111*/

                      FOR FIRST so_mstr
                        FIELDS(so_ship)
                        WHERE so_domain = global_domain
                          AND so_nbr    = tt1_nbr NO-LOCK :
                       FOR FIRST ad_mstr
                          FIELDS(ad_ctry)
                          WHERE ad_domain = GLOBAL_domain
                            AND ad_addr   = so_ship NO-LOCK:
                         IF m_ctry <> "" AND m_ctry <> ad_ctry THEN DO:
/*davidw*/                  if not m_error then do:
                               MESSAGE m_mesdesc[37].
/*davidw:1959*/                RUN sendbell  IN THIS-PROCEDURE.
                            end.
                            tt1_nbr = "".  m_error = Yes.
                          END. /**IF m_ctry <> "" AND m_ctry <> ad_ctry THEN*/
                       END. /**FOR FIRST ad_mstr**/

                      END. /**FOR FIRST so_mstr**/

                  END. /**IF tt1_dataset = "sod_det" THEN**/
               END. /**IF tt42_nbr <> "" THEN**/
         END. /**EACH ld_det**/

      END. /**IF NOT AVAIL tt2a_det THEN**/

      /* MK15122010 >> */

      FIND FIRST tt4_det
                   WHERE tt4_nbr  = tt1_nbr
                     and tt4_line = tt1_line /*jackl**ECO:20110307095617*/
                     AND tt4_part = tt1_part NO-ERROR.
              IF NOT AVAIL tt4_det THEN
              DO:
                 CREATE tt4_det.
                 ASSIGN tt4_nbr    = tt1_nbr
                        tt4_line = tt1_line /*jackl**ECO:20110307095617*/
                        tt4_part   = tt1_part
                        tt4_qtyord = tt1_qtyopn
                        tt4_qtyall = 0
                        tt4_cust    = tt1_cust
                        tt4_dataset = tt1_dataset.
              END. /**IF NOT AVAIL tt4_det THEN**/
              tt4_qtyall = tt4_qtyall + tt1_qtyiss.
              {xxqtylim.i tt4_qtyall}
            /*  MESSAGE "O"  + STRING(tt4_qtyord , "->>,>>9.99" ) +
                      "S" + STRING(tt4_qtyall , "->>,>>9.99" ). Jack Li*/

              MESSAGE "O"  + STRING(m_ordqty , "->>,>>9.99" ) +
                      "S"  + STRING(m_shipqty , "->>,>>9.99" ) .

              IF tt4_qtyall > tt4_qtyord * ( 1 + (m_overshipct * 0.01))
               AND tt4_dataset = "sod_det" AND
               NOT CAN-FIND(FIRST CODE_mstr
                           WHERE CODE_domain  = GLOBAL_domain
                             AND CODE_fldname = "xx_so_overshipment_CUST_EXC"
                             AND CODE_value   = tt4_cust)
              THEN DO:
                 m_error = YES.
                 MESSAGE m_mesdesc[40].
/*davidw:1959*/  RUN sendbell  IN THIS-PROCEDURE.
                 UNDO detloop, RETRY detloop.
              END. /**IF tt4_qtyall > tt4_qtyord * ( 1 + (m_overshipct * 0.01)) THEN**/

      /* << MK15122010 */
      IF m_screen THEN DO:
         DISP tt2a_ref tt2a_nbr
              WITH FRAME a1h.
         MESSAGE "Tot Scanned:" n_count. /*Jihui 20130912094300*/
      END. 
      ELSE
         DISP tt2a_ref tt2a_part tt2a_um tt2a_qtyoh tt2a_site tt2a_nbr
              WITH FRAME a1.

       IF m_screen THEN
          DOWN 1 WITH FRAME a1h.
       ELSE DOWN 1 WITH FRAME a1.
    END. /**END OF REPEAT**/

    IF NOT CAN-FIND(FIRST tt1_det
                    WHERE tt1_qtyiss <> 0
                      AND tt1_nbr    <> "") THEN
    DO:
       MESSAGE m_mesdesc[14].
/*davidw:1959*/  RUN sendbell  IN THIS-PROCEDURE.
       PAUSE.
       LEAVE mainloop.
    END. /**IF NOT CAN-FIND(FIRST tt1_det WHERE tt1_qtyiss <> 0 ) THEN**/

    RUN SODOSHIPCIM IN THIS-PROCEDURE.
    n_count = 0. /*jackl 20090527133626*/
  END. /**END OF REPEAT**/
END. /**SODOSHIP-PALLET**/

PROCEDURE SODOSHIP-ORDER:
  n_count = 0. /*jackl 20090527133626*/
  FORM
      tt5_nbr    COLUMN-LABEL {&xxictpc_p_19}
      tt5_cust
      WITH FRAME a1 DOWN.

  mainloop:
  REPEAT:
    EMPTY TEMP-TABLE tt5_det.
    EMPTY TEMP-TABLE tt1_det.

    CLEAR FRAME a1 ALL NO-PAUSE.

    detloop:
    REPEAT:

      PROMPT-FOR tt5_nbr
          GO-ON (CTRL-D F5) WITH FRAME a1 EDITING:
          {mfnp.i tt5_det tt5_nbr tt5_nbr tt5_nbr tt5_nbr tt5_nbr}
           IF recno <> ? THEN
              DISP tt5_nbr tt5_cust
                   WITH FRAME a1 DOWN.
      END. /**PROMPT-FOR tt12_lot**/

      ASSIGN m_part   = ""
             m_site   = ""
             m_loc    = ""
             m_lot    = ""
             m_ref    = ""
             m_nbr    = INPUT FRAME a1 tt5_nbr
             m_recid  = ?
             gpglef   = 0
             m_trtype = ""
             m_error  = NO.


      RUN GET-ITEM-FROM-LOTREF IN THIS-PROCEDURE.

      IF m_dataset = "" THEN DO:
         MESSAGE m_mesdesc[4].
/*davidw:1959*/  RUN sendbell  IN THIS-PROCEDURE.
         UNDO detloop , RETRY detloop.
      END. /**IF tt1_dataset = "" THEN**/

      IF m_dataset = "sod_det" THEN
      DO:
        /*Jack Li ***ADD BEGIN***ECO#:20091207165510*/
        FOR FIRST so_mstr
            FIELDS(so_stat)
             WHERE so_domain = global_domain
               AND so_nbr    = m_nbr NO-LOCK :
         if so_stat = "HD" then do:
            if not m_error then do:
               MESSAGE "ERROR:Sales Number " + m_nbr
               + " placed on credit hold".
              RUN sendbell  IN THIS-PROCEDURE.
            end.
            m_error = Yes.
            UNDO detloop , RETRY detloop.
          end.
         END.
         /*Jack Li ***ADDED END***ECO#:20091207165510*/


         FOR FIRST sod_det
             FIELDS(sod_btb_type)
             WHERE sod_domain = GLOBAL_domain
               AND sod_nbr = m_nbr
               AND (sod_btb_type = "02" or sod_btb_type = "03") NO-LOCK:
         END. /**FOR FIRST sod_det**/

         IF AVAILABLE sod_det THEN DO:
            MESSAGE m_mesdesc[28].
/*davidw:1959*/  RUN sendbell  IN THIS-PROCEDURE.
            m_error = YES.
            UNDO detloop , RETRY detloop.
         END. /**IF AVAILABLE sod_det THEN DO:**/
         FOR FIRST so_mstr
              FIELDS(so_ship)
              WHERE so_domain = global_domain
                AND so_nbr    = m_nbr NO-LOCK :
            FOR FIRST ad_mstr
                FIELDS(ad_ctry)
                WHERE ad_domain = GLOBAL_domain
                  AND ad_addr   = so_ship NO-LOCK:
              IF m_ctry <> "" AND m_ctry <> ad_ctry THEN DO:
                MESSAGE m_mesdesc[37].
/*davidw:1959*/  RUN sendbell  IN THIS-PROCEDURE.
                m_error = YES.
                UNDO detloop , RETRY detloop.
               END. /**IF m_ctry <> "" AND m_ctry <> ad_ctry THEN**/
           END. /**FOR FIRST ad_mstr**/

          END. /**FOR FIRST so_mstr**/

/*linas60107**begin*/
              IF SHIPPMENT-LOCK(m_nbr)  THEN DO:
                   MESSAGE "ERROR: Invoice is not done:"
                                   + m_nbr.
                   RUN sendbell  IN THIS-PROCEDURE.
                    m_error = YES.
                    UNDO detloop , RETRY detloop.
              END.
/*linas60107**end*/


      END. /**IF tt1_dataset = "sod_det" THEN**/

      IF m_error THEN
         UNDO detloop , RETRY detloop.

      /* DELETE */
      IF LASTKEY = KEYCODE("F5") OR LASTKEY = KEYCODE("CTRL-D")
      THEN do:
         del-yn = no.
         /* Please confirm delete */
         {pxmsg.i &MSGNUM=11 &ERRORLEVEL=1 &CONFIRM=del-yn}
         IF del-yn THEN
         DO:
            FOR EACH tt1_det
                WHERE tt1_nbr = m_nbr :
                DELETE tt1_det.
            END. /**EACH tt1_det**/

            FIND FIRST tt5_det
                 WHERE tt5_nbr = m_nbr NO-ERROR.
            IF AVAIL tt5_det THEN
               DELETE tt5_det.
            CLEAR FRAME a1.
            n_count = n_count - 1. /*jackl 20090527133626*/
            Message "Sum to scan:" n_count. /*jackl 20090527133626*/
            UNDO detloop, RETRY detloop.
         END. /**IF del-yn THEN**/
      END. /**IF LASTKEY = KEYCODE("F5") OR LASTKEY = KEYCODE("CTRL-D")*/

      FIND FIRST tt5_det
           WHERE tt5_nbr = m_nbr NO-ERROR.
      IF NOT AVAIL tt5_det THEN
      DO:
         CREATE tt5_det.
         ASSIGN tt5_nbr     = m_nbr
                tt5_dataset = m_dataset.
         n_count = n_count + 1. /*jackl 20090527133626*/
         /*Message "Sum to scan:" n_count. /*jackl 20090527133626*/Jihui 20130912094300*/
         IF tt5_dataset = "sod_det" THEN
         DO:
            FOR FIRST so_mstr
                FIELDS(so_cust)
                WHERE so_domain = global_domain
                  AND so_nbr = tt5_nbr NO-LOCK:
            END. /**FOR FIRST so_mstr**/
            IF AVAIL so_mstr THEN
               tt5_cust = so_cust.

            FOR EACH lad_det
                FIELDS(lad_part lad_site lad_loc lad_lot lad_ref lad_qty_all
/*davidw*/             lad_nbr lad_line lad_nbr lad_qty_pick) NO-LOCK
                WHERE lad_domain  = GLOBAL_domain
                  AND lad_dataset = m_dataset
                  AND lad_nbr     = m_nbr
                  AND (lad_qty_all <> 0 OR lad_qty_pick <> 0 ):

           /*Jack Li*****ADD BEGIN****ECO:20130124143111*/
              FIND FIRST code_mstr NO-LOCK WHERE code_domain = global_domain
                     AND code_fldname = "xx_soreason_switch" NO-ERROR.
              IF NOT AVAILABLE code_mstr THEN DO:
           /*Jack Li*****ADDED END****ECO:20130124143111*/
                  FOR FIRST sod_det
                    FIELD(sod_nbr sod_line)
                    WHERE sod_domain = GLOBAL_domain
                      AND sod_nbr    = lad_nbr
                      AND sod_line   = INT(lad_line)
                      AND sod_due_date < m_effdate NO-LOCK:

                  FOR LAST tr_hist
                      FIELD(tr_rsn_code)
                      WHERE tr_domain = GLOBAL_domain
                        AND tr_nbr    = sod_nbr
                        AND tr_line   = sod_line
                        AND tr_type   = "ORD-SO" 
                        AND (tr_program = "xxsosomt.p"  /*Jihui 20130902142221*/
                          OR tr_program = "xxsosold.p") /*Jihui 20130902142221*/
                        NO-LOCK:
                  END. /**FOR LAST tr_hist**/
                  IF AVAIL tr_hist THEN
                  DO:
                  /*IF tr_rsn_code <> "" AND ENTRY(3 , tr_rsn_code) = "" THEN
                     DO:        *jackl*/
                     IF tr_rsn_code = "" or (tr_rsn_code <> ""
                        AND ENTRY(3 , tr_rsn_code) = "") THEN DO: /*jackl*/
                        MESSAGE m_mesdesc[41].
                        PAUSE. /*20121222144910*/
/*davidw:1959*/  RUN sendbell  IN THIS-PROCEDURE.
                        n_count = max(0,(n_count - 1)).  /*Jihui 20130912094300*/
                        for each tt5_det where tt5_nbr = m_nbr:
                            delete tt5_det.
                        end.
                        UNDO detloop , RETRY detloop.
                     END. /**IF AVAILABLE sod_det THEN DO:**/
                  END. /**IF AVAIL tr_hist THEN**/
                END. /**FOR FIRST sod_det**/
              END. /*IF NOT AVAILABLE code_mstr*/ /*20130124143111*/

                FIND FIRST tt1_det
                     WHERE tt1_lot   = lad_lot
                       AND tt1_ref   = lad_ref
                       AND tt1_loc   = lad_loc
                       AND tt1_part  = lad_part
                       AND tt1_site  = lad_site   NO-ERROR.
                IF NOT AVAIL tt1_det THEN
                DO:
                   CREATE tt1_det.
                   ASSIGN tt1_lot     = lad_lot
                          tt1_syslot  = lad_lot
                          tt1_site    = lad_site
                          tt1_ref     = lad_ref
                          tt1_ref1    = lad_ref
                          tt1_loc     = lad_loc
                          tt1_loc1    = lad_loc
                          tt1_part    = lad_part
                          tt1_qtyiss  = lad_qty_all + lad_qty_pick
                          tt1_nbr     = m_nbr
                          tt1_line    = lad_line
                          tt1_dataset = m_dataset.
                END. /**IF NOT AVAIL tt1_det THEN**/

            END. /**EACH lad_det**/

         END. /**IF tt5_dataset = "sod_det" THEN**/
         ELSE DO:
             FOR FIRST dss_mstr
                 FIELDS(dss_rec_site dss_shipsite)
                  WHERE dss_domain = GLOBAL_domain
                    AND dss_nbr    = tt5_nbr NO-LOCK:
             END. /**FOR FIRST dss_mstr**/
             IF AVAIL dss_mstr THEN
                 ASSIGN tt5_cust     = dss_rec_site
                        tt5_shipsite = dss_shipsite
                        tt5_site     = dss_shipsite
                        tt5_recsite  = dss_rec_site.

             FOR EACH dsd_det
                 FIELDS(dsd_req_nbr)
                 WHERE dsd_domain   = global_domain
                   AND dsd_nbr      = tt5_nbr
                   AND dsd_shipsite = tt5_shipsite NO-LOCK :
                 FOR EACH lad_det
                     FIELDS(lad_part lad_loc lad_lot lad_ref lad_qty_all
                            lad_qty_pick) NO-LOCK
                     WHERE lad_domain  = GLOBAL_domain
                       AND lad_dataset = tt5_dataset
                       AND lad_nbr     = dsd_req_nbr
                       AND lad_line    = tt5_recsite
                       AND lad_site    = tt5_shipsite
                       AND (lad_qty_all <> 0 OR lad_qty_pick <> 0) :
                     FIND FIRST tt1_det
                          WHERE tt1_lot   = lad_lot
                            AND tt1_ref   = lad_ref
                            AND tt1_site  = tt5_shipsite
                            AND tt1_loc   = lad_loc
                            AND tt1_part  = lad_part
                             NO-ERROR.
                     IF NOT AVAIL tt1_det THEN
                     DO:
                        CREATE tt1_det.
                        ASSIGN tt1_lot      = lad_lot
                               tt1_syslot   = lad_lot
                               tt1_ref      = lad_ref
                               tt1_ref1     = lad_ref
                               tt1_site     = tt5_shipsite
                               tt1_loc      = lad_loc
                               tt1_loc1     = lad_loc
                               tt1_part     = lad_part
                               tt1_qtyiss   = lad_qty_all + lad_qty_pick
                               tt1_nbr      = tt5_nbr
                               tt1_line     = dsd_req_nbr
                               tt1_recsite  = tt5_recsite
                               tt1_dataset  = tt5_dataset.
                     END. /**IF NOT AVAIL tt1_det THEN**/
                 END. /**EACH lad_det**/
             END. /**EACH dsd_det**/
         END. /**ELSE DO**/
      END. /**IF NOT AVAIL tt5_det THEN**/
      DISP tt5_cust
           WITH FRAME a1 DOWN.
           MESSAGE "Tot Scanned:" n_count. /*Jihui 20130912094300*/

      DOWN 1 WITH FRAME a1.

    END. /**END OF REPEAT**/

    IF NOT CAN-FIND(FIRST tt1_det
                    WHERE tt1_qtyiss <> 0 AND tt1_nbr <> "" ) THEN
    DO:
       MESSAGE m_mesdesc[14].
/*davidw:1959*/  RUN sendbell  IN THIS-PROCEDURE.
       PAUSE.
       LEAVE mainloop.
    END. /**IF NOT CAN-FIND(FIRST tt1_det WHERE tt1_qtyiss <> 0 ) THEN**/

    RUN SODOSHIPCIM IN THIS-PROCEDURE.
    n_count = 0. /*jackl 20090527133626*/
  END. /**END OF REPEAT**/
END. /**SODOSHIP-ORDER**/

PROCEDURE SODOSHIP-ITEM:
    n_count = 0. /*jackl 20090527133626*/
    FORM
        tt1_part
        VALIDATE(CAN-FIND(FIRST pt_mstr
                          WHERE pt_domain = GLOBAL_domain
                            AND pt_part = INPUT FRAME a1 tt1_part
                            AND pt_lot_ser = "" NO-LOCK ) ,
                 m_mesdesc[1])
        tt1_um
        tt1_site
        VALIDATE(CAN-FIND(FIRST si_mstr NO-LOCK
                          WHERE si_domain = GLOBAL_domain
                            AND si_site = INPUT FRAME a1 tt1_site ) ,
                 m_mesdesc[9])
        tt1_loc
        VALIDATE(CAN-FIND(FIRST loc_mstr NO-LOCK
                          WHERE loc_domain = GLOBAL_domain
                            AND loc_site = INPUT FRAME a1 tt1_site
                            AND loc_loc  = INPUT FRAME a1 tt1_loc ) ,
                 m_mesdesc[2])
        tt1_qtyiss
        VALIDATE(INPUT FRAME a1 tt1_qtyiss <= tt1_qtyoh ,
                 m_mesdesc[16] )
        tt1_nbr LABEL {&xxictpc_p_19}
        VALIDATE(((CAN-FIND(FIRST sod_det NO-LOCK
                           WHERE sod_domain = GLOBAL_domain
                             AND sod_nbr  = INPUT FRAME a1 tt1_nbr
                             AND sod_part = tt1_part
                             AND sod_site = INPUT FRAME a1 tt1_site
                             AND sod_type = "" ) AND
                  CAN-FIND(FIRST so_mstr NO-LOCK
                           WHERE so_domain = global_domain
                             AND so_nbr  = INPUT FRAME a1 tt1_nbr
                             AND so_stat = "")) OR
                  CAN-FIND(FIRST ds_det NO-LOCK
                           WHERE ds_domain   = GLOBAL_domain
                             AND ds_nbr      = INPUT FRAME a1 tt1_nbr
                             AND ds_shipsite = INPUT FRAME a1 tt1_site
                             AND ds_part     = tt1_part )) AND
                  (NOT CAN-FIND(FIRST lad_det NO-LOCK
                           WHERE lad_domain  = GLOBAL_domain
                             AND lad_dataset = "sod_det"
                             AND lad_nbr     = INPUT FRAME a1 tt1_nbr
                             AND lad_part    = tt1_part ) OR
                   NOT CAN-FIND(FIRST lad_det NO-LOCK
                           WHERE lad_domain  = GLOBAL_domain
                             AND lad_dataset = "ds_det"
                             AND lad_nbr     = INPUT FRAME a1 tt1_nbr
                             AND lad_part    = tt1_part )) ,
                 m_mesdesc[4])

        WITH FRAME a1 DOWN.

    FORM
        tt1_part    COLON 8 LABEL {&xxictpc_p_05}
        VALIDATE(CAN-FIND(FIRST pt_mstr
                          WHERE pt_domain = GLOBAL_domain
                            AND pt_part = INPUT FRAME a1h tt1_part
                            AND pt_lot_ser = "" NO-LOCK ) ,
                 m_mesdesc[1])
        tt1_um      COLON 8
        tt1_site    COLON 8
        VALIDATE(CAN-FIND(FIRST si_mstr NO-LOCK
                          WHERE si_domain = GLOBAL_domain
                            AND si_site = INPUT FRAME a1h tt1_site ) ,
                 m_mesdesc[9])
        tt1_loc     COLON 8 LABEL {&xxictpc_p_04}
        VALIDATE(CAN-FIND(FIRST loc_mstr NO-LOCK
                          WHERE loc_domain = GLOBAL_domain
                            AND loc_site = INPUT FRAME a1h tt1_site
                            AND loc_loc  = INPUT FRAME a1h tt1_loc ) ,
                 m_mesdesc[2])
        tt1_qtyiss  COLON 8 LABEL {&xxictpc_p_11}
        VALIDATE(INPUT FRAME a1h tt1_qtyiss <= tt1_qtyoh ,
                 m_mesdesc[16] )
        tt1_nbr    COLON 8 LABEL {&xxictpc_p_19}
        VALIDATE(((CAN-FIND(FIRST sod_det NO-LOCK
                           WHERE sod_domain = GLOBAL_domain
                             AND sod_nbr  = INPUT FRAME a1h tt1_nbr
                             AND sod_part = tt1_part
                             AND sod_site = INPUT FRAME a1h tt1_site
                             AND sod_type = "" ) AND
                  CAN-FIND(FIRST so_mstr NO-LOCK
                           WHERE so_domain = global_domain
                             AND so_nbr  = INPUT FRAME a1h tt1_nbr
                             AND so_stat = "")) OR
                  CAN-FIND(FIRST ds_det NO-LOCK
                           WHERE ds_domain   = GLOBAL_domain
                             AND ds_nbr      = INPUT FRAME a1h tt1_nbr
                             AND ds_shipsite = INPUT FRAME a1h tt1_site
                             AND ds_part     = tt1_part )) AND
                  (NOT CAN-FIND(FIRST lad_det NO-LOCK
                           WHERE lad_domain  = GLOBAL_domain
                             AND lad_dataset = "sod_det"
                             AND lad_nbr     = INPUT FRAME a1h tt1_nbr
                             AND lad_part    = tt1_part ) OR
                   NOT CAN-FIND(FIRST lad_det NO-LOCK
                           WHERE lad_domain  = GLOBAL_domain
                             AND lad_dataset = "ds_det"
                             AND lad_nbr     = INPUT FRAME a1h tt1_nbr
                             AND lad_part    = tt1_part )) ,
                 m_mesdesc[4])
      WITH FRAME a1h SIDE-LABEL.

    mainloop:
    REPEAT:
      EMPTY TEMP-TABLE tt1_det.

      CLEAR FRAME a1 ALL NO-PAUSE.
      CLEAR FRAME a1h ALL NO-PAUSE.

      detloop:
      REPEAT:

        IF m_screen THEN
        DO:
            PROMPT-FOR tt1_part tt1_site tt1_loc
                WITH FRAME a1h EDITING:
                {mfnp.i tt1_det tt1_part tt1_part tt1_part tt1_part
                        tt1_a}
                 IF recno <> ? THEN
                     DISP tt1_part tt1_um tt1_site tt1_loc tt1_qtyiss
                          tt1_nbr
                         WITH FRAME a1h.
            END. /**ROMPT-FOR tt12_lot**/
        END. /**HHT SCREEN**/
        ELSE DO:
            PROMPT-FOR tt1_part tt1_site tt1_loc
                WITH FRAME a1 EDITING:
                {mfnp.i tt1_det tt1_part tt1_part tt1_part tt1_part
                        tt1_a}
                 IF recno <> ? THEN
                    DISP tt1_part tt1_um tt1_site tt1_loc tt1_qtyiss
                         tt1_nbr
                         WITH FRAME a1.
            END. /**PROMPT-FOR tt12_lot**/

        END. /**MFG/PRO SCREEN**/

        ASSIGN m_part   = (IF m_screen THEN INPUT FRAME a1h tt1_part
                           ELSE INPUT FRAME a1 tt1_part )
               m_site   = (IF m_screen THEN INPUT FRAME a1h tt1_site
                           ELSE INPUT FRAME a1 tt1_site )
               m_loc    = (IF m_screen THEN INPUT FRAME a1h tt1_loc
                           ELSE INPUT FRAME a1 tt1_loc )
               m_lot    = ""
               m_ref    = ""
               m_nbr    = ""
               m_recid  = ?
               gpglef   = 0
               m_trtype = ""
               m_error  = NO.

        RUN GET-ITEM-FROM-LOTREF IN THIS-PROCEDURE.

        IF m_error THEN
           UNDO detloop , RETRY detloop.

        FIND FIRST tt1_det
             WHERE tt1_part  = m_part
               AND tt1_site  = m_site
               AND tt1_loc   = m_loc  NO-ERROR.
        IF NOT AVAIL tt1_det THEN
        DO:
           CREATE tt1_det.
           ASSIGN tt1_part  = m_part
                  tt1_site  = m_site
                  tt1_loc   = m_loc.
           n_count = n_count + 1. /*jackl 20090527133626*/
           FOR FIRST ld_det
               FIELDS(ld__chr01 ld_qty_oh)
               WHERE RECID(ld_det) = m_recid NO-LOCK:
           END. /**FOR FIRST ld_det**/
           IF AVAIL ld_det THEN
           DO:
              tt1_qtyoh   = ld_qty_oh.
              {xxqtylim.i tt1_qtyoh}
           END. /**IF AVAIL ld_det THEN**/

           FOR FIRST pt_mstr
               FIELDS(pt_um pt_desc1)
               WHERE pt_domain = GLOBAL_domain
                 AND pt_part = m_part NO-LOCK:
           END. /**FOR FIRST pt_mstr**/
           IF AVAIL pt_mstr THEN
              ASSIGN tt1_um     = pt_um
                     tt1_desc   = pt_desc1.

        END. /**IF NOT AVAIL tt1_det THEN**/

        IF m_screen THEN
        DO:
             DISP tt1_part tt1_um tt1_site tt1_loc tt1_qtyiss
                  tt1_nbr
                  WITH FRAME a1h.
             UPDATE tt1_qtyiss tt1_nbr
                    GO-ON (CTRL-D F5) WITH FRAME a1h DOWN.
             Message "Sum to scan:" n_count. /*jackl 20090527133626*/
        END. /**IF m_screen THEN**/
        ELSE DO:
            DISP tt1_part tt1_um tt1_site tt1_loc tt1_qtyiss
                   tt1_nbr
                   WITH FRAME a1.
            UPDATE tt1_qtyiss tt1_nbr
                   GO-ON (CTRL-D F5) WITH FRAME a1 DOWN.
        END. /**ELSE DO**/

        IF LASTKEY = KEYCODE("F5") OR LASTKEY = KEYCODE("CTRL-D")
        THEN do:
             del-yn = no.
             /* Please confirm delete */
             {pxmsg.i &MSGNUM=11 &ERRORLEVEL=1 &CONFIRM=del-yn}
             IF del-yn THEN
             DO:
                FOR EACH tt4_det
                    WHERE tt4_nbr  = tt1_nbr
                      AND tt4_part = tt1_part:
                    tt4_qtyall = tt4_qtyall - tt1_qtyiss.
                    IF tt4_qtyall < 0 THEN tt4_qtyall = 0.
                END. /**EACH tt4_nbr*/

                DELETE tt1_det.
                IF m_screen THEN DO:
                   CLEAR FRAME a1h.
                   n_count = n_count - 1. /*jackl 20090527133626*/
                   Message "Sum to scan:" n_count. /*jackl 20090527133626*/
                END.
                ELSE
                   CLEAR FRAME a1.
                UNDO detloop, RETRY detloop.
             END. /**IF del-yn THEN**/
        END. /**IF LASTKEY = KEYCODE("F5") OR LASTKEY = KEYCODE("CTRL-D")*/

        IF tt1_nbr <> "" THEN
        DO:
            RUN GET-ORDER-DETAILS IN THIS-PROCEDURE
                (INPUT tt1_nbr      , INPUT tt1_part , OUTPUT tt1_line ,
                 OUTPUT tt1_dataset , OUTPUT tt1_qtyopn , OUTPUT tt1_cust,
                 OUTPUT tt1_recsite , OUTPUT tt1_qtyall,
                      OUTPUT tt1_soum    , OUTPUT tt1_um_conv).  /*20090605102535*/


            IF tt1_dataset = "" THEN DO:
               DELETE tt1_det.
               MESSAGE m_mesdesc[4].
/*davidw:1959*/  RUN sendbell  IN THIS-PROCEDURE.
               UNDO detloop , RETRY detloop.
            END. /**IF tt1_dataset = "" THEN**/

            IF tt1_dataset = "sod_det" THEN
            DO:
               FOR FIRST sod_det
                   FIELDS(sod_btb_type)
                   WHERE sod_domain = GLOBAL_domain
                     AND sod_nbr = tt1_nbr
                     AND (sod_btb_type = "02" or sod_btb_type = "03")
               NO-LOCK:
               END. /**FOR FIRST sod_det**/
               IF AVAILABLE sod_det THEN DO:
                  MESSAGE m_mesdesc[28].
/*davidw:1959*/   RUN sendbell  IN THIS-PROCEDURE.
                  DELETE tt1_det.
                  IF m_screen THEN
                     CLEAR FRAME a1h.
                  ELSE
                     CLEAR FRAME a1.
                  UNDO detloop, RETRY detloop.
               END. /**IF AVAILABLE sod_det THEN DO:**/

               FOR FIRST sod_det
                   FIELD(sod_nbr sod_line)
                   WHERE sod_domain = GLOBAL_domain
                     AND sod_nbr    = tt1_nbr
                     AND sod_line   = INT(tt1_line)
                     AND sod_due_date < m_effdate NO-LOCK:

                  FOR LAST tr_hist
                      FIELD(tr_rsn_code)
                      WHERE tr_domain = GLOBAL_domain
                        AND tr_nbr    = sod_nbr
                        AND tr_line   = sod_line
                        AND tr_type   = "ORD-SO" NO-LOCK:
                  END. /**FOR LAST tr_hist**/
                  IF AVAIL tr_hist THEN
                  DO:
                   /*IF tr_rsn_code <> "" AND ENTRY(3 , tr_rsn_code) = "" THEN
                     DO:     *jackl*/
                     IF tr_rsn_code = "" or (tr_rsn_code <> ""
                        AND ENTRY(3 , tr_rsn_code) = "") THEN DO:   /*jackl*/
                        MESSAGE m_mesdesc[41].
                        PAUSE. /*20121222144910*/
/*davidw:1959*/         RUN sendbell  IN THIS-PROCEDURE.
                        DELETE tt1_det.
                        IF m_screen THEN
                           CLEAR FRAME a1h.
                        ELSE
                           CLEAR FRAME a1.
                        UNDO detloop, RETRY detloop.
                     END. /**IF AVAILABLE sod_det THEN DO:**/
                  END. /**IF AVAIL tr_hist THEN**/
               END. /**FOR FIRST sod_det**/


               FOR FIRST so_mstr
                  FIELDS(so_ship)
                  WHERE so_domain = global_domain
                   AND so_nbr    = tt1_nbr NO-LOCK :
                FOR FIRST ad_mstr
                    FIELDS(ad_ctry)
                    WHERE ad_domain = GLOBAL_domain
                      AND ad_addr   = so_ship NO-LOCK:
                  IF m_ctry <> "" AND m_ctry <> ad_ctry THEN DO:
                    DELETE tt1_det.
                    MESSAGE m_mesdesc[37].
/*davidw:1959*/     RUN sendbell  IN THIS-PROCEDURE.
                    UNDO detloop, RETRY detloop.
                  END. /**IF m_ctry <> "" AND m_ctry <> ad_ctry THEN**/
                END. /**FOR FIRST ad_mstr**/
               END. /**FOR FIRST so_mstr**/

/*linas60107**begin*/
              IF SHIPPMENT-LOCK(tt1_nbr)   THEN DO:
                   MESSAGE "ERROR: Invoice is not done:"
                                   + tt1_nbr.

                   RUN sendbell  IN THIS-PROCEDURE.
                   UNDO detloop , RETRY detloop.
                   tt1_nbr = "".  m_error = Yes.
              END.
/*linas60107**end*/

            END. /**IF tt1_dataset = "sod_det" THEN**/

        END. /**IF tt42_nbr <> "" THEN**/
        FIND FIRST tt4_det
             WHERE tt4_nbr  = tt1_nbr
               AND tt4_part = tt1_part NO-ERROR.
        IF NOT AVAIL tt4_det THEN
        DO:
           CREATE tt4_det.
           ASSIGN tt4_nbr    = tt1_nbr
                  tt4_part   = tt1_part
                  tt4_qtyord = tt1_qtyopn.
        END. /**IF NOT AVAIL tt4_det THEN**/
        tt4_qtyall = tt4_qtyall + tt1_qtyiss.

        MESSAGE "O"  + STRING(tt4_qtyord , "->>,>>9.99" ) +
                " A" + STRING(tt4_qtyall , "->>,>>9.99" ).

        IF NOT m_screen THEN
           DOWN 1 WITH FRAME a1.
      END. /**END OF REPEAT**/

      IF NOT CAN-FIND(FIRST tt1_det WHERE tt1_qtyiss <> 0
                                       AND tt1_nbr   <> "" ) THEN
      DO:
         MESSAGE m_mesdesc[14].
/*davidw:1959*/  RUN sendbell  IN THIS-PROCEDURE.
         PAUSE.
         LEAVE mainloop.
      END. /**IF NOT CAN-FIND(FIRST tt1_det WHERE tt1_qtyiss <> 0 ) THEN**/

      RUN SODOSHIPCIM IN THIS-PROCEDURE.
      n_count = 0. /*jackl 20090527133626*/
    END. /**END OF REPEAT**/

END. /**SODOSHIP-ITEM**/

PROCEDURE DOREC-ITEM:
    n_count = 0. /*jackl 20090527133626*/
    FORM
        tt1_part
        VALIDATE(CAN-FIND(FIRST pt_mstr
                          WHERE pt_domain = GLOBAL_domain
                            AND pt_part = INPUT FRAME a1 tt1_part
                            AND pt_lot_ser = "" NO-LOCK ) ,
                 m_mesdesc[1])
        tt1_um
        tt1_nbr LABEL {&xxictpc_p_03}
        VALIDATE(CAN-FIND(FIRST ds_det NO-LOCK
                           WHERE ds_domain = GLOBAL_domain
                             AND ds_nbr    = INPUT FRAME a1 tt1_nbr) ,
                 m_mesdesc[26])
        tt1_qtyiss
        VALIDATE(INPUT FRAME a1 tt1_qtyiss <= tt1_qtyoh ,
                 m_mesdesc[16] )
        tt1_site
        tt1_loc1
        VALIDATE(CAN-FIND(FIRST loc_mstr NO-LOCK
                          WHERE loc_domain = GLOBAL_domain
                            AND loc_site = INPUT FRAME a1 tt1_site
                            AND loc_loc  = INPUT FRAME a1 tt1_loc1 ) ,
                 m_mesdesc[2])

        WITH FRAME a1 DOWN.

    FORM
        tt1_part    COLON 8 LABEL {&xxictpc_p_05}
        VALIDATE(CAN-FIND(FIRST pt_mstr
                          WHERE pt_domain = GLOBAL_domain
                            AND pt_part = INPUT FRAME a1h tt1_part
                            AND pt_lot_ser = "" NO-LOCK ) ,
                 m_mesdesc[1])
        tt1_um      COLON 8
        tt1_nbr    COLON 8 LABEL {&xxictpc_p_03}
        VALIDATE(CAN-FIND(FIRST dss_mstr NO-LOCK
                           WHERE dss_domain = GLOBAL_domain
                             AND dss_nbr    = INPUT FRAME a1h tt1_nbr) ,
                 m_mesdesc[26])
        tt1_qtyiss  COLON 8 LABEL {&xxictpc_p_11}
        VALIDATE(INPUT FRAME a1h tt1_qtyiss <= tt1_qtyoh ,
                 m_mesdesc[16] )
        tt1_site    COLON 8
        VALIDATE(CAN-FIND(FIRST si_mstr NO-LOCK
                          WHERE si_domain = GLOBAL_domain
                            AND si_site = INPUT FRAME a1h tt1_site ) ,
                 m_mesdesc[9])
        tt1_loc1     COLON 8 LABEL {&xxictpc_p_13}
        VALIDATE(CAN-FIND(FIRST loc_mstr NO-LOCK
                          WHERE loc_domain = GLOBAL_domain
                            AND loc_site = INPUT FRAME a1h tt1_site
                            AND loc_loc  = INPUT FRAME a1h tt1_loc1 ) ,
                 m_mesdesc[2])
      WITH FRAME a1h SIDE-LABEL.

    mainloop:
    REPEAT:
      EMPTY TEMP-TABLE tt1_det.

      CLEAR FRAME a1 ALL NO-PAUSE.
      CLEAR FRAME a1h ALL NO-PAUSE.

      detloop:
      REPEAT:

        IF m_screen THEN
        DO:
            PROMPT-FOR tt1_part tt1_nbr
                WITH FRAME a1h EDITING:
                {mfnp.i tt1_det tt1_part tt1_part tt1_part tt1_part
                        tt1_a}
                 IF recno <> ? THEN
                     DISP tt1_part tt1_um tt1_site tt1_loc1 tt1_qtyiss
                          tt1_nbr
                         WITH FRAME a1h.
            END. /**ROMPT-FOR tt12_lot**/
        END. /**HHT SCREEN**/
        ELSE DO:
            PROMPT-FOR tt1_part tt1_nbr
                WITH FRAME a1 EDITING:
                {mfnp.i tt1_det tt1_part tt1_part tt1_part tt1_part
                        tt1_a}
                 IF recno <> ? THEN
                    DISP tt1_part tt1_um tt1_site tt1_loc1 tt1_qtyiss
                         tt1_nbr
                         WITH FRAME a1.
            END. /**PROMPT-FOR tt12_lot**/

        END. /**MFG/PRO SCREEN**/

        ASSIGN m_part = (IF m_screen THEN INPUT FRAME a1h tt1_part
                         ELSE INPUT FRAME a1 tt1_part )
               m_site   = ""
               m_loc    = ""
               m_lot    = ""
               m_ref    = ""
               m_nbr    = (IF m_screen THEN INPUT FRAME a1h tt1_nbr
                           ELSE INPUT FRAME a1 tt1_nbr )
               m_recid  = ?
               gpglef   = 0
               m_trtype = "RCT-DO,ISS-GIT"
               m_error  = NO
               m_line = ""
               m_loc1 = ""
               m_qty  = 0.

        FOR EACH  dsd_det
            FIELDS(dsd_part dsd_git_site dsd_trans_id dsd_req_nbr dsd_site
                   dsd_qty_ship dsd_qty_rcvd)
            WHERE dsd_domain = global_domain
              AND dsd_nbr    = m_nbr NO-LOCK :
          IF dsd_part = m_part AND dsd_qty_ship <> dsd_qty_rcvd THEN
          DO:
              ASSIGN m_site   = dsd_git_site
                     m_loc    = dsd_trans_id
                     m_line   = dsd_req_nbr
                     m_qty    = m_qty + (dsd_qty_ship - dsd_qty_rcvd).

              FOR FIRST dsr_mstr
                  FIELDS(dsr_loc)
                  WHERE dsr_domain  = global_domain
                    AND dsr_req_nbr = dsd_req_nbr
                    AND dsr_site    = dsd_site NO-LOCK:
              END. /**FOR FIRST dsr_mstr**/
              IF AVAIL dsr_mstr THEN
                 m_loc1   = dsr_loc.
          END. /**IF dsd_part = m_part AND dsd_qty_ship <> dsd_qty_rcvd THEN**/
        END. /**EACH dsd_det**/

        IF m_line = "" THEN
        DO:
           MESSAGE m_mesdesc[26].
/*davidw:1959*/  RUN sendbell  IN THIS-PROCEDURE.
           UNDO detloop, RETRY detloop.
        END. /**IF m_line = "" THEN**/
        RUN OTHER-VALIDATION IN THIS-PROCEDURE.

        IF m_error THEN
           UNDO detloop , RETRY detloop.

        FOR FIRST ld_det
            FIELDS(ld__chr01 ld_qty_oh)
             WHERE ld_domain   = GLOBAL_domain
               AND ld_part     = m_part
               AND ld_site     = m_site
               AND ld_loc      = m_loc
               AND ld_ref      = ""
               AND ld_lot      = ""
               AND TRUNCATE(ld_qty_oh , 3) <> 0
               AND ld__chr01   = "" NO-LOCK:
        END. /**FOR FIRST ld_det**/
        IF NOT AVAIL ld_det THEN
        DO:

            /* MK01 >> */
            FOR FIRST ld_det
            FIELDS(ld__chr01 ld_qty_oh)
             WHERE ld_domain   = GLOBAL_domain
               AND ld_part     = m_part
               AND ld_site     = m_site
               AND ld_loc      = m_loc
               AND ld_ref      = ""
               AND ld_lot      = ""
              /* AND TRUNCATE(ld_qty_oh , 3) = 0 */
               AND ld_stat    = "NNN"
               AND ld__chr01   = ""  NO-LOCK:
            END. /**FOR FIRST ld_det**/

            IF AVAIL ld_det THEN
            DO:
                MESSAGE m_mesdesc[42].
                RUN sendbell  IN THIS-PROCEDURE.
                UNDO detloop, RETRY detloop.
            END. /* if avail loc_mstr */
            /* << MK01 */
           MESSAGE m_mesdesc[15].
/*davidw:1959*/  RUN sendbell  IN THIS-PROCEDURE.
           UNDO detloop, RETRY detloop.
        END. /**IF NOT AVAIL ld_det THEN**/

                   FIND FIRST tt1_det
             WHERE tt1_part  = m_part
               AND tt1_nbr   = m_nbr NO-ERROR.
        IF NOT AVAIL tt1_det THEN
        DO:
           CREATE tt1_det.
           ASSIGN tt1_part   = m_part
                  tt1_nbr    = m_nbr
                  tt1_site   = m_site
                  tt1_loc    = m_loc
                  tt1_loc1   = m_loc1
                  tt1_qtyoh  = m_qty
                  tt1_qtyiss = m_qty
                  tt1_line   = m_line.
           n_count = n_count + 1. /*jackl 20090527133626*/
           FOR FIRST pt_mstr
               FIELDS(pt_um pt_desc1)
                WHERE pt_domain = GLOBAL_domain
                  AND pt_part = m_part NO-LOCK:
           END. /**FOR FIRST pt_mstr**/
           IF AVAIL pt_mstr THEN
              ASSIGN tt1_um     = pt_um
                     tt1_desc   = pt_desc1.

           FOR FIRST dss_mstr
               FIELDS(dss_shipsite)
               WHERE dss_domain = GLOBAL_domain
                 AND dss_nbr    = m_nbr NO-LOCK:
           END. /**FOR FIRST dss_mstr**/
           IF AVAIL dss_mstr THEN
              tt1_shipsite = dss_shipsite.
        END. /**IF NOT AVAIL tt1_det THEN**/

        IF m_screen THEN
        DO:
             DISP tt1_part tt1_um tt1_site tt1_loc1 tt1_qtyiss
                  tt1_nbr
                  WITH FRAME a1h.
             UPDATE tt1_qtyiss tt1_loc1
                    GO-ON (CTRL-D F5) WITH FRAME a1h DOWN.
             Message "Sum to scan:" n_count. /*jackl 20090527133626*/
        END. /**IF m_screen THEN**/
        ELSE DO:
            DISP tt1_part tt1_um tt1_site tt1_loc1 tt1_qtyiss
                   tt1_nbr
                   WITH FRAME a1.
            UPDATE tt1_qtyiss tt1_loc1
                   GO-ON (CTRL-D F5) WITH FRAME a1 DOWN.
        END. /**ELSE DO**/


        ASSIGN m_loc1   = (IF m_screen THEN INPUT FRAME a1h tt1_loc1
                           ELSE INPUT FRAME a1 tt1_loc1)
               m_trtype = "RCT-DO"
               m_error  = NO.

        RUN LOC-STAT-VALIDATION IN THIS-PROCEDURE.

        IF m_error THEN
        DO:
           tt1_loc1 = "".
           UNDO detloop , RETRY detloop.
        END. /**IF m_error THEN**/

        IF LASTKEY = KEYCODE("F5") OR LASTKEY = KEYCODE("CTRL-D")
        THEN do:
             del-yn = no.
             /* Please confirm delete */
             {pxmsg.i &MSGNUM=11 &ERRORLEVEL=1 &CONFIRM=del-yn}
             IF del-yn THEN
             DO:
                 DELETE tt1_det.
                IF m_screen THEN DO:
                   CLEAR FRAME a1h.
                   n_count = n_count - 1. /*jackl 20090527133626*/
                   Message "Sum to scan:" n_count. /*jackl 20090527133626*/
                END.
                ELSE
                   CLEAR FRAME a1.
                UNDO detloop, RETRY detloop.
             END. /**IF del-yn THEN**/
        END. /**IF LASTKEY = KEYCODE("F5") OR LASTKEY = KEYCODE("CTRL-D")*/

        IF NOT m_screen THEN
           DOWN 1 WITH FRAME a1.
      END. /**END OF REPEAT**/

      IF NOT CAN-FIND(FIRST tt1_det WHERE tt1_qtyiss <> 0
                                      AND tt1_loc1  <> ""
                                      AND tt1_nbr   <> ""
                                      AND tt1_line  <> "") THEN
      DO:
         MESSAGE m_mesdesc[14].
/*davidw:1959*/  RUN sendbell  IN THIS-PROCEDURE.
         PAUSE.
         LEAVE mainloop.
      END. /**IF NOT CAN-FIND(FIRST tt1_det WHERE tt1_qtyiss <> 0 ) THEN**/

      RUN DORECCIM IN THIS-PROCEDURE.
      n_count = 0. /*jackl 20090527133626*/
    END. /**END OF REPEAT**/

END. /**DOREC-ITEM**/

PROCEDURE DOREC-LOT:
  n_count = 0. /*jackl 20090527133626*/
  FORM
      tt1_lot
      VALIDATE(INPUT FRAME a1 tt1_lot <> ""
               AND LENGTH(INPUT FRAME a1 tt1_lot) = 9 , m_mesdesc[3])
      tt1_part
      tt1_um
      tt1_qtyiss
      tt1_site
      tt1_loc1
      VALIDATE(CAN-FIND(FIRST loc_mstr NO-LOCK
                        WHERE loc_domain = GLOBAL_domain
                          AND loc_site = m_site
                          AND loc_loc  = INPUT FRAME a1 tt1_loc1 ) ,
               m_mesdesc[2])
      WITH FRAME a1 DOWN.

  FORM
    tt1_lot    LABEL {&xxictpc_p_09}
    VALIDATE(INPUT FRAME a1h tt1_lot <> ""
             AND LENGTH(INPUT FRAME a1h tt1_lot) = 9 , m_mesdesc[3])
    tt1_loc1   LABEL {&xxictpc_p_13}
    VALIDATE(CAN-FIND(FIRST loc_mstr NO-LOCK
                      WHERE loc_domain = GLOBAL_domain
                        AND loc_site = m_site
                        AND loc_loc  = INPUT FRAME a1h tt1_loc1 ) ,
             m_mesdesc[2])
    WITH FRAME a1h DOWN.

  mainloop:
  REPEAT:
    EMPTY TEMP-TABLE tt1_det.

    CLEAR FRAME a1 ALL NO-PAUSE.
    CLEAR FRAME a1h ALL NO-PAUSE.

    detloop:
    REPEAT:

      IF m_screen THEN
      DO:
          PROMPT-FOR tt1_lot
              WITH FRAME a1h EDITING:
              {mfnp.i tt1_det tt1_lot tt1_lot tt1_lot tt1_lot
                      tt1_a}
               IF recno <> ? THEN
                  DISP tt1_lot tt1_loc1
                       WITH FRAME a1h.
          END. /**ROMPT-FOR tt12_lot**/
      END. /**HHT SCREEN**/
      ELSE DO:
          PROMPT-FOR tt1_lot
              WITH FRAME a1 EDITING:
              {mfnp.i tt1_det tt1_lot tt1_lot tt1_lot tt1_lot
                      tt1_a}
               IF recno <> ? THEN
                  DISP tt1_lot tt1_part tt1_um tt1_qtyiss tt1_site tt1_loc1
                       WITH FRAME a1.
          END. /**PROMPT-FOR tt12_lot**/

      END. /**MFG/PRO SCREEN**/

      ASSIGN m_part   = ""
             m_site   = ""
             m_loc    = ""
             m_loc1   = ""
             m_lot    = (IF m_screen THEN INPUT FRAME a1h tt1_lot
                         ELSE INPUT FRAME a1 tt1_lot )
             m_syslot = ""
             m_ref    = ""
             m_nbr    = ""
             m_recid  = ?
             gpglef   = 0
             m_trtype = "RCT-DO,ISS-GIT"
             m_error  = NO
             m_line = "".

      RUN GET-ITEM-FROM-LOTREF IN THIS-PROCEDURE.

      IF m_error THEN
         UNDO detloop , RETRY detloop.

      FIND FIRST tt1_det
           WHERE tt1_lot  = m_lot NO-ERROR.
      IF NOT AVAIL tt1_det THEN
      DO:
         CREATE tt1_det.
         ASSIGN tt1_lot    = m_lot
                tt1_syslot = m_syslot
                tt1_part   = m_part
                tt1_site   = m_site
                tt1_loc    = m_loc
                tt1_nbr    = m_nbr
                tt1_loc1   = m_loc1
                tt1_line   = m_line.
         n_count = n_count + 1. /*jackl 20090527133626*/

         FOR FIRST ld_det
             FIELDS(ld__chr01 ld_qty_oh)
              WHERE RECID(ld_det) = m_recid NO-LOCK:
         END. /**FOR FIRST ld_det**/
         IF AVAIL ld_det THEN
         DO:
            tt1_qtyiss = ld_qty_oh.
            {xxqtylim.i tt1_qtyiss}
         END. /**IF AVAIL ld_det THEN**/

         FOR FIRST dss_mstr
             FIELDS(dss_shipsite)
             WHERE dss_domain = GLOBAL_domain
               AND dss_nbr    = m_nbr NO-LOCK:
         END. /**FOR FIRST dss_mstr**/
         IF AVAIL dss_mstr THEN
            tt1_shipsite = dss_shipsite.

         FOR FIRST pt_mstr
             FIELDS(pt_um pt_desc1)
              WHERE pt_domain = GLOBAL_domain
                AND pt_part = m_part NO-LOCK:
         END. /**FOR FIRST pt_mstr**/
         IF AVAIL pt_mstr THEN
            ASSIGN tt1_um     = pt_um
                   tt1_desc   = pt_desc1.
      END. /**IF NOT AVAIL tt1_det THEN**/

      IF m_screen THEN
          DISP tt1_lot tt1_loc1
               WITH FRAME a1h.
      ELSE DISP tt1_lot tt1_part tt1_um tt1_qtyiss tt1_site tt1_loc1
                WITH FRAME a1.

      IF m_screen THEN DO:
          UPDATE tt1_loc1
                 GO-ON (CTRL-D F5) WITH FRAME a1h DOWN.
          Message "Sum to scan:" n_count. /*jackl 20090527133626*/
      END.
      ELSE
          UPDATE tt1_loc1
                 GO-ON (CTRL-D F5) WITH FRAME a1 DOWN.

      ASSIGN m_loc1   = (IF m_screen THEN INPUT FRAME a1h tt1_loc1
                        ELSE INPUT FRAME a1 tt1_loc1)
             m_trtype = "RCT-DO"
             m_error  = NO.

      RUN LOC-STAT-VALIDATION IN THIS-PROCEDURE.

      IF m_error THEN
      DO:
         tt1_loc1 = "".
         UNDO detloop , RETRY detloop.
      END. /**IF m_error THEN**/

      /* DELETE */
      IF LASTKEY = KEYCODE("F5") OR LASTKEY = KEYCODE("CTRL-D")
      THEN do:
         del-yn = no.
        /* Please confirm delete */
        {pxmsg.i &MSGNUM=11 &ERRORLEVEL=1 &CONFIRM=del-yn}
        IF del-yn THEN
        DO:
           DELETE tt1_det.
           IF m_screen THEN DO:
              CLEAR FRAME a1h.
              n_count = n_count - 1. /*jackl 20090527133626*/
              Message "Sum to scan:" n_count. /*jackl 20090527133626*/
           END.
           ELSE
              CLEAR FRAME a1.
           UNDO detloop, RETRY detloop.
        END. /**IF del-yn THEN**/
      END. /**IF LASTKEY = KEYCODE("F5") OR LASTKEY = KEYCODE("CTRL-D")*/
      IF m_screen THEN
         DOWN 1 WITH FRAME a1h.
      ELSE DOWN 1 WITH FRAME a1.
    END. /**END OF REPEAT**/

    IF NOT CAN-FIND(FIRST tt1_det WHERE tt1_qtyiss <> 0
                                     AND tt1_loc1  <> ""
                                     AND tt1_nbr   <> ""
                                     AND tt1_line  <> "") THEN
    DO:
       MESSAGE m_mesdesc[14].
/*davidw:1959*/  RUN sendbell  IN THIS-PROCEDURE.
       PAUSE.
       LEAVE mainloop.
    END. /**IF NOT CAN-FIND(FIRST tt1_det WHERE tt1_qtyiss <> 0 ) THEN**/

    RUN DORECCIM IN THIS-PROCEDURE.
    n_count = 0. /*jackl 20090527133626*/
  END. /**END OF REPEAT**/

END. /**DOREC-LOT**/

PROCEDURE DOREC-PALLET:
  n_count = 0. /*jackl 20090527133626*/
  FORM
      tt2a_ref    COLUMN-LABEL {&xxictpc_p_10}
      VALIDATE(CAN-FIND(FIRST ld_det
                        WHERE ld_domain = GLOBAL_domain
                          AND ld_ref = INPUT FRAME a1 tt2a_ref NO-LOCK ) AND
               INPUT FRAME a1 tt2a_ref  <> "",
               m_mesdesc[5])
      tt2a_part
      tt2a_um
      tt2a_qtyoh
      tt2a_site
      tt2a_loc
      VALIDATE(CAN-FIND(FIRST loc_mstr NO-LOCK
                        WHERE loc_domain = GLOBAL_domain
                          AND loc_site = m_site
                          AND loc_loc  = INPUT FRAME a1 tt2a_loc ) ,
               m_mesdesc[2])
      WITH FRAME a1 DOWN.

  FORM
    tt2a_ref     COLUMN-LABEL {&xxictpc_p_10}
    VALIDATE(CAN-FIND(FIRST ld_det
                        WHERE ld_domain = GLOBAL_domain
                          AND ld_ref = INPUT FRAME a1h tt2a_ref NO-LOCK )
             AND INPUT FRAME a1h tt2a_ref  <> "",
               m_mesdesc[5])
    tt2a_loc     LABEL {&xxictpc_p_21}
    VALIDATE(CAN-FIND(FIRST loc_mstr NO-LOCK
                      WHERE loc_domain = GLOBAL_domain
                        AND loc_site = m_site
                        AND loc_loc  = INPUT FRAME a1h tt2a_loc ) ,
             m_mesdesc[2])
    WITH FRAME a1h DOWN.

  mainloop:
  REPEAT:
    EMPTY TEMP-TABLE tt2a_det.
    EMPTY TEMP-TABLE tt1_det.

    CLEAR FRAME a1 ALL NO-PAUSE.
    CLEAR FRAME a1h ALL NO-PAUSE.

    detloop:
    REPEAT:

      IF m_screen THEN
      DO:
          PROMPT-FOR tt2a_ref
              WITH FRAME a1h EDITING:
              {mfnp.i tt2a_det tt2a_ref tt2a_ref tt2a_ref tt2a_ref
                      tt2a_ref}
               IF recno <> ? THEN
                  DISP tt2a_ref tt2a_loc
                       WITH FRAME a1h.
          END. /**ROMPT-FOR tt12_lot**/
      END. /**HHT SCREEN**/
      ELSE DO:
          PROMPT-FOR tt2a_ref
              WITH FRAME a1 EDITING:
              {mfnp.i tt2a_det tt2a_ref tt2a_ref tt2a_ref tt2a_ref
                      tt2a_ref}
               IF recno <> ? THEN
                  DISP tt2a_ref tt2a_part tt2a_um tt2a_qtyoh tt2a_site tt2a_loc
                       WITH FRAME a1.
          END. /**PROMPT-FOR tt12_lot**/

      END. /**MFG/PRO SCREEN**/

      ASSIGN m_part   = ""
             m_site   = ""
             m_loc    = ""
             m_loc1   = ""
             m_lot    = ""
             m_ref    = (IF m_screen THEN INPUT FRAME a1h tt2a_ref
                         ELSE INPUT FRAME a1 tt2a_ref )
             m_nbr    = ""
             m_recid  = ?
             gpglef   = 0
             m_trtype = "RCT-DO,ISS-GIT"
             m_error  = NO
             m_line   = "".

      RUN GET-ITEM-FROM-LOTREF IN THIS-PROCEDURE.

      IF m_error THEN
         UNDO detloop , RETRY detloop.

      FIND FIRST tt2a_det
           WHERE tt2a_ref  = m_ref NO-ERROR.
      IF NOT AVAIL tt2a_det THEN
      DO:
         CREATE tt2a_det.
         ASSIGN tt2a_ref   = m_ref
                tt2a_part  = m_part
                tt2a_site  = m_site
                tt2a_loc   = m_loc1.
         n_count = n_count + 1. /*jackl 20090527133626*/
         FOR FIRST pt_mstr
             FIELDS(pt_um pt_desc1)
              WHERE pt_domain = GLOBAL_domain
                AND pt_part = m_part NO-LOCK:
         END. /**FOR FIRST pt_mstr**/
         IF AVAIL pt_mstr THEN
            ASSIGN tt2a_um     = pt_um
                   tt2a_desc   = pt_desc1.

      END. /**IF NOT AVAIL tt2a_det THEN**/

     IF m_screen THEN
         DISP tt2a_ref tt2a_loc
                 WITH FRAME a1h.
     ELSE DISP tt2a_ref tt2a_part tt2a_um tt2a_qtyoh tt2a_site tt2a_loc
               WITH FRAME a1.

     IF m_screen THEN DO:
        UPDATE tt2a_loc
               GO-ON (CTRL-D F5) WITH FRAME a1h DOWN.
        Message "Sum to scan:" n_count. /*jackl 20090527133626*/
     END.
     ELSE
        UPDATE tt2a_loc
               GO-ON (CTRL-D F5) WITH FRAME a1 DOWN.

     ASSIGN m_loc1   = (IF m_screen THEN INPUT FRAME a1h tt2a_loc
                        ELSE INPUT FRAME a1 tt2a_loc)
            m_trtype = "RCT-DO"
            m_error  = NO.

     RUN LOC-STAT-VALIDATION IN THIS-PROCEDURE.

     IF m_error THEN
     DO:
        tt1_loc1 = "".
        UNDO detloop , RETRY detloop.
     END. /**IF m_error THEN**/

      /* DELETE */
      IF LASTKEY = KEYCODE("F5") OR LASTKEY = KEYCODE("CTRL-D")
      THEN do:
           del-yn = no.
           /* Please confirm delete */
           {pxmsg.i &MSGNUM=11 &ERRORLEVEL=1 &CONFIRM=del-yn}
           IF del-yn THEN
           DO:
              FOR EACH tt1_det
                  WHERE tt1_ref = tt2a_ref:
                  DELETE tt1_det.
              END. /**EACH tt1_det**/

              DELETE tt2a_det.
              IF m_screen THEN DO:
                 CLEAR FRAME a1h.
                 n_count = n_count - 1. /*jackl 20090527133626*/
                 Message "Sum to scan:" n_count. /*jackl 20090527133626*/
              END.
              ELSE
                 CLEAR FRAME a1.
              UNDO detloop, RETRY detloop.
           END. /**IF del-yn THEN**/
      END. /**IF LASTKEY = KEYCODE("F5") OR LASTKEY = KEYCODE("CTRL-D")*/

      FOR EACH ld_det
          FIELDS(ld_part ld_lot ld_qty_oh ld__chr01)
          WHERE ld_domain = GLOBAL_domain
            AND ld_ref    = tt2a_ref
            AND ld_site   = m_site
            AND ld_loc    = m_loc
            AND ld__chr01 = ""
            AND TRUNCATE(ld_qty_oh , 3) <> 0 NO-LOCK :
        FIND FIRST tt1_det
             WHERE tt1_lot   = ld_lot
               AND tt1_ref   = tt2a_ref
               AND tt1_loc   = m_loc
               AND tt1_part  = ld_part
               AND tt1_site  = m_site  NO-ERROR.
        IF NOT AVAIL tt1_det THEN
        DO:
           CREATE tt1_det.
           ASSIGN tt1_lot    = ld_lot
                  tt1_syslot = ld_lot
                  tt1_ref    = tt2a_ref
                  tt1_ref1   = tt2a_ref
                  tt1_site   = m_site
                  tt1_loc    = m_loc
                  tt1_loc1   = tt2a_loc
                  tt1_part   = ld_part
                  tt1_qtyiss = ld_qty_oh.

           {xxqtylim.i tt1_qtyiss}

           m_maxtrnbr = 0.  /*Jack Li*/
           FOR /*LAST*/ EACH tr_hist
               FIELDS(tr_nbr tr_lot tr_trnbr)
               WHERE tr_domain = GLOBAL_domain
                 AND tr_serial = ld_lot
                 AND tr_qty_loc <> 0
                 AND tr_type   = "RCT-GIT" USE-INDEX tr_serial NO-LOCK:
              /**Jack Li***ADD BEGIN**/
              IF m_maxtrnbr < tr_trnbr THEN
                 ASSIGN tt1_nbr   = tr_nbr
                        tt1_line  = tr_lot
                        m_maxtrnbr = tr_trnbr.
              /**Jack Li***ADDED END**/
           END. /**FOR LAST tr_hist**/
          /** IF AVAIL tr_hist THEN
              ASSIGN tt1_nbr   = tr_nbr
                     tt1_line  = tr_lot.
             **/
           FOR FIRST dss_mstr
               FIELDS(dss_shipsite)
               WHERE dss_domain = GLOBAL_domain
                 AND dss_nbr    = tt1_nbr NO-LOCK:
           END. /**FOR FIRST dss_mstr**/
           IF AVAIL dss_mstr THEN
              tt1_shipsite = dss_shipsite.

        END. /**IF NOT AVAIL tt1_det THEN**/
      END. /**EACH ld_det**/

      IF m_screen THEN
         DOWN 1 WITH FRAME a1h.
      ELSE DOWN 1 WITH FRAME a1.
    END. /**END OF REPEAT**/

    IF NOT CAN-FIND(FIRST tt1_det WHERE tt1_qtyiss <> 0
                                    AND tt1_loc1  <> ""
                                    AND tt1_nbr   <> ""
                                    AND tt1_line  <> "") THEN
    DO:
       MESSAGE m_mesdesc[14].
/*davidw:1959*/  RUN sendbell  IN THIS-PROCEDURE.
       PAUSE.
       LEAVE mainloop.
    END. /**IF NOT CAN-FIND(FIRST tt1_det WHERE tt1_qtyiss <> 0 ) THEN**/

    RUN DORECCIM IN THIS-PROCEDURE.

  END. /**END OF REPEAT**/

END. /**DOREC-PALLET**/

PROCEDURE DOREC-ORDER:
  n_count = 0. /*jackl 20090527133626*/
  FORM
      tt5_nbr LABEL {&xxictpc_p_03}
      VALIDATE(CAN-FIND(FIRST dss_mstr NO-LOCK
                        WHERE dss_domain = GLOBAL_domain
                          AND dss_nbr    = INPUT FRAME a1 tt5_nbr ) ,
               m_mesdesc[26])
      tt5_loc
      VALIDATE(CAN-FIND(FIRST loc_mstr NO-LOCK
                        WHERE loc_domain = GLOBAL_domain
                          AND loc_site = m_site
                          AND loc_loc  = INPUT FRAME a1 tt5_loc ) ,
               m_mesdesc[2])
      WITH FRAME a1 DOWN.

  mainloop:
  REPEAT:
    EMPTY TEMP-TABLE tt5_det.
    EMPTY TEMP-TABLE tt1_det.

    CLEAR FRAME a1 ALL NO-PAUSE.

    detloop:
    REPEAT:

      PROMPT-FOR tt5_nbr
          GO-ON (CTRL-D F5) WITH FRAME a1 EDITING:
          {mfnp.i tt5_det tt5_nbr tt5_nbr tt5_nbr tt5_nbr tt5_nbr}
           IF recno <> ? THEN
              DISP tt5_nbr tt5_loc
                   WITH FRAME a1 DOWN.
      END. /**PROMPT-FOR tt12_lot**/

      ASSIGN m_part   = ""
             m_site   = ""
             m_loc    = ""
             m_loc1   = ""
             m_lot    = ""
             m_ref    = ""
             m_nbr    = INPUT FRAME a1 tt5_nbr
             m_recid  = ?
             gpglef   = 0
             m_trtype = "RCT-DO,ISS-GIT"
             m_error  = NO
             m_line   = "".

      RUN GET-ITEM-FROM-LOTREF IN THIS-PROCEDURE.

      IF m_error THEN
         UNDO detloop , RETRY detloop.

      FIND FIRST tt5_det
           WHERE tt5_nbr = m_nbr NO-ERROR.
      IF NOT AVAIL tt5_det THEN
      DO:
         CREATE tt5_det.
         ASSIGN tt5_nbr     = m_nbr
                tt5_dataset = m_dataset.
         n_count = n_count + 1. /*jackl 20090527133626*/
         Message "Sum to scan:" n_count. /*jackl 20090527133626*/
         FOR FIRST dss_mstr
             FIELDS(dss_rec_site dss_shipsite)
              WHERE RECID(dss_mstr) = m_recid NO-LOCK:
         END. /**FOR FIRST dss_mstr**/
         IF AVAIL dss_mstr THEN
         DO:
           FOR EACH dsd_det
               FIELDS(dsd_part dsd_req_nbr dsd_site dsd_shipsite dsd_nbr)
               WHERE dsd_domain   = global_domain
                 AND dsd_nbr      = m_nbr
                 AND dsd_shipsite = dss_shipsite
                 AND dsd_site     = dss_rec_site NO-LOCK:

             FOR EACH qad_wkfl
                 FIELDS (qad_charfld qad_decfld )
                 WHERE qad_domain = GLOBAL_domain
                   AND qad_key1 = "dsd_det" + "::" + dsd_req_nbr
                                   + "::" + dsd_site + "::" + dsd_shipsite
                   AND qad_key2 BEGINS dsd_nbr NO-LOCK:

                FOR FIRST dsr_mstr
                    FIELDS(dsr_loc)
                    WHERE dsr_domain  = global_domain
                      AND dsr_req_nbr = dsd_req_nbr
                      AND dsr_site    = dsd_site NO-LOCK:
                END. /**FOR FIRST dsr_mstr**/
                IF AVAIL dsr_mstr THEN
                  tt5_loc   = dsr_loc.

                FIND FIRST tt1_det
                     WHERE tt1_lot   = qad_charfld[4]
                       AND tt1_ref   = qad_charfld[5]
                       AND tt1_part  = dsd_part
                       AND tt1_site  = dsd_site  NO-ERROR.
                IF NOT AVAIL tt1_det THEN
                DO:
                   CREATE tt1_det.
                   ASSIGN tt1_lot      = qad_charfld[4]
                          tt1_syslot   = qad_charfld[4]
                          tt1_ref      = qad_charfld[5]
                          tt1_ref1     = qad_charfld[5]
                          tt1_line     = dsd_req_nbr
                          tt1_nbr      = dsd_nbr
                          tt1_part     = dsd_part
                          tt1_site     = dsd_site
                          tt1_shipsite = dsd_shipsite.

                END. /**IF NOT AVAIL tt1_det THEN**/
                tt1_qtyiss = tt1_qtyiss + qad_decfld[1].

             END. /**EACH qad_wkfl**/
           END. /**EACH dsd_det**/
         END. /**IF AVAIL dss_mstr THEN**/
      END. /**IF NOT AVAIL tt5_det THEN**/
      UPDATE tt5_loc
           GO-ON(CTRL-D F5) WITH FRAME a1 DOWN.

      ASSIGN m_loc1   = INPUT FRAME a1 tt5_loc
             m_trtype = "RCT-DO"
             m_error  = NO.

      RUN LOC-STAT-VALIDATION IN THIS-PROCEDURE.

      IF m_error THEN
      DO:
         tt5_loc = "".
         FOR EACH tt1_det
             WHERE tt1_nbr = m_nbr :
             DELETE tt1_det.
         END. /**EACH tt1_det**/
         UNDO detloop , RETRY detloop.
      END. /**IF m_error THEN**/

      /* DELETE */
      IF LASTKEY = KEYCODE("F5") OR LASTKEY = KEYCODE("CTRL-D")
      THEN do:
         del-yn = no.
         /* Please confirm delete */
         {pxmsg.i &MSGNUM=11 &ERRORLEVEL=1 &CONFIRM=del-yn}
         IF del-yn THEN
         DO:
            FOR EACH tt1_det
                WHERE tt1_nbr = m_nbr :
                DELETE tt1_det.
            END. /**EACH tt1_det**/

            DELETE tt5_det.
            CLEAR FRAME a1.
            n_count = n_count - 1. /*jackl 20090527133626*/
            Message "Sum to scan:" n_count. /*jackl 20090527133626*/
            UNDO detloop, RETRY detloop.
         END. /**IF del-yn THEN**/
      END. /**IF LASTKEY = KEYCODE("F5") OR LASTKEY = KEYCODE("CTRL-D")*/

      FOR EACH tt1_det
          WHERE tt1_nbr = m_nbr :
          tt1_loc1 = tt5_loc.
      END. /**EACH tt1_det**/

      DOWN 1 WITH FRAME a1.

    END. /**END OF REPEAT**/

    IF NOT CAN-FIND(FIRST tt1_det WHERE tt1_qtyiss <> 0
                                    AND tt1_loc1  <> ""
                                    AND tt1_nbr   <> ""
                                    AND tt1_line  <> "") THEN
    DO:
       MESSAGE m_mesdesc[14].
/*davidw:1959*/  RUN sendbell  IN THIS-PROCEDURE.
       PAUSE.
       LEAVE mainloop.
    END. /**IF NOT CAN-FIND(FIRST tt1_det WHERE tt1_qtyiss <> 0 ) THEN**/
    RUN DORECCIM IN THIS-PROCEDURE.
    n_count = 0. /*jackl 20090527133626*/
  END. /**END OF REPEAT**/
END. /**DOREC-ORDER**/

PROCEDURE SORETURNS-LOT:
  n_count = 0. /*jackl 20090527133626*/
  m_totsqumeter = 0 . /*tao 20100506130549*/
  FORM
    tt1_lot    COLON 5 LABEL {&xxictpc_p_09}
    tt1_part   COLON 5 LABEL {&xxictpc_p_05}

    VALIDATE(CAN-FIND(FIRST pt_mstr NO-LOCK
                      WHERE pt_domain = GLOBAL_domain
                        AND pt_part   = INPUT FRAME a1h tt1_part ) ,
                 m_mesdesc[1])
    tt1_um      NO-LABEL
    SKIP
    tt1_desc    NO-LABEL
    SKIP
    tt1_cust   COLON 5 LABEL {&xxictpc_p_02}
    VALIDATE(CAN-FIND(FIRST cm_mstr NO-LOCK
                      WHERE cm_domain = GLOBAL_domain
                        AND cm_addr   = INPUT FRAME a1h tt1_cust ) ,
                   m_mesdesc[27])
    tt1_site           LABEL {&xxictpc_p_16}
    VALIDATE(CAN-FIND(FIRST si_mstr NO-LOCK
                      WHERE si_domain = GLOBAL_domain
                        AND si_site   = INPUT FRAME a1h tt1_site ) ,
                     m_mesdesc[9])
    SKIP
    tt1_loc    COLON 5 LABEL {&xxictpc_p_08}
    VALIDATE(CAN-FIND(FIRST loc_mstr NO-LOCK
                      WHERE loc_domain = GLOBAL_domain
                        AND loc_site   = INPUT FRAME a1h tt1_site
                        AND loc_loc    = INPUT FRAME a1h tt1_loc ) ,
                       m_mesdesc[2])
    tt1_rsncd          LABEL {&xxictpc_p_15}
    VALIDATE(CAN-FIND(FIRST rsn_ref  NO-LOCK
               WHERE rsn_domain  = GLOBAL_domain
                 AND rsn_type = "SORETURN"
                 AND rsn_code = INPUT FRAME a1h tt1_rsncd ) ,
                       m_mesdesc[7])
    SKIP
    tt1_qtyiss   COLON 5 LABEL {&xxictpc_p_11}
     VALIDATE(INPUT FRAME a1h tt1_qtyiss > 0 ,
                       m_mesdesc[6])
    tt1_nbr             LABEL {&xxictpc_p_26}   FORMAT "X(5)"
    WITH FRAME a1h SIDE-LABEL.

/****Jack Li*****ADD BEGIN***ECO:20120427164911***/
  ON ASSIGN OF sod_det.sod_acct DO:
       FIND FIRST so_mstr
            WHERE so_domain = GLOBAL_domain
              AND so_nbr    = sod_det.sod_nbr NO-LOCK NO-ERROR.
       IF AVAIL so_mstr THEN DO:
          FIND FIRST cm_mstr
               WHERE cm_domain = so_domain
                 AND cm_addr   = so_bill NO-LOCK NO-ERROR.
          IF AVAIL cm_mstr THEN DO:
             IF CAN-FIND(FIRST CODE_mstr NO-LOCK
                         WHERE code_domain   = global_domain
                           AND code_fldname  = "xx_so_cmtype"
                           AND CAN-DO(CODE_value , cm_type)) THEN
                sod_det.sod_sub = so_bill.
          END. /**IF AVAIL cm_mstr THEN**/
       END. /**IF AVAIL so_mstr THEN**/
  END.
/****Jack Li*****ADDED END***ECO:20120427164911***/

  ON ASSIGN OF sod_det.sod_order_category
  DO:
      sod_det.sod__chr02 = sod_det.sod_order_category.
  END. /**ON ASSIGN sod_det.sod_order_category**/

  ON ASSIGN OF ld_det.ld_lot
  DO:
     FIND FIRST tt1_det WHERE tt1_syslot = ld_det.ld_lot NO-ERROR.
     IF AVAIL tt1_det THEN
     DO:
       IF tt1_expdt <> ? THEN
          ld_det.ld_expire = tt1_expdt.
     END. /**IF AVAIL tt1_det THEN**/
  END. /**ON ASSIGN OF ld_det.ld_lot:**/

  ON ASSIGN OF tr_hist.tr_so_job
  DO:
    FOR FIRST so_mstr
        FIELDS(so_po)
        WHERE so_domain = GLOBAL_domain
          AND so_nbr    = tr_hist.tr_nbr NO-LOCK :
       tr_hist.tr_so_job = so_po.
    END. /**FOR FIRST so_mstr**/
  END. /**ON ASSIGN OF ld_det.ld_expire**/

  ON ASSIGN OF ld_det.ld_expire
  DO:
      FIND FIRST tt1_det WHERE tt1_syslot = ld_det.ld_lot NO-ERROR.
      IF AVAIL tt1_det THEN
      DO:
        IF tt1_expdt <> ?
           and ld_det.ld_expire <> tt1_expdt  /*linas113534*/
         THEN
           ld_det.ld_expire = tt1_expdt.
      END. /**IF AVAIL tt1_det THEN**/

  END. /**ON ASSIGN OF ld_det.ld_lot:**/

/*linas113534 *BEGIN*/
  ON ASSIGN OF ld_det.ld_qty_oh 
  DO:
      IF ld_det.ld_expire = ? THEN DO:
              find first pt_mstr no-lock where pt_domain = global_domain
                                           and pt_part = ld_det.ld_part NO-ERROR.
              IF AVAILABLE pt_mstr then DO:
                   ASSIGN ld_det.ld_expire = today + pt_shelflife.
              END.
      END. /* IF ld_det.ld_expire = ? */

  END. /* ON ASSIGN OF ld_det.ld_qty_oh  */
/*linas113534 *END*/


  mainloop:
  REPEAT:
    EMPTY TEMP-TABLE tt1_det.
    CLEAR FRAME a1h ALL NO-PAUSE.
/*david:1806 begins */
     m_first_entity = "".
     m_first_itaxsite = "".
/*david:1806 end */
    detloop:
    REPEAT:
      CLEAR FRAME a1h ALL NO-PAUSE.
      ASSIGN m_yn = NO. /* MK01 */
      PROMPT-FOR tt1_lot
          WITH FRAME a1h EDITING:
          {mfnp.i tt1_det tt1_lot tt1_lot tt1_lot tt1_lot
                  tt1_a}
           IF recno <> ? THEN
              DISP tt1_lot tt1_part tt1_um tt1_desc tt1_site tt1_loc
                   tt1_rsncd tt1_qtyiss
                   WITH FRAME a1h.
      END. /**ROMPT-FOR tt12_lot**/

      ASSIGN m_part   = ""
             m_site   = ""
             m_loc    = ""
             m_lot    = INPUT FRAME a1h tt1_lot
             m_syslot = ""
             m_cust   = ""
             m_ref    = ""
             m_nbr    = ""
             m_curr   = ""   /*Jack Li ECO#:20110420093443*/
             m_recid  = ?
             gpglef   = 0
             m_qty    = 0
             m_trtype = ""
             m_expdt  = ?
             m_error  = NO .

      IF m_lot <> "" AND LENGTH(m_lot) = 9 THEN DO:
        FOR LAST tr_hist
            FIELDS(tr_serial tr_qty_loc tr_addr tr_part
                   tr_ex_rate tr_ex_rate2 tr_curr
                   tr_price tr_site tr_expire )
            WHERE tr_domain = GLOBAL_domain
              AND tr_serial = m_lot
              AND tr_type   = "ISS-SO" USE-INDEX tr_serial NO-LOCK:
            ASSIGN m_syslot    = tr_serial
                   m_qty       = - tr_qty_loc
                   m_expdt     = tr_expire
                   m_cust      = tr_addr
                   m_site      = tr_site
/**davidw:1440*    m_oldprice  = tr_price    **Jack ECO:20110420093443*/
                   m_oldprice  = tr_price * tr_ex_rate / tr_ex_rate2
                   m_curr      = tr_curr  /**Jack ECO:20110420093443*/
                   m_part      = tr_part.
        END. /**FOR LAST tr_hist**/
        IF NOT AVAIL tr_hist THEN
        DO:
            FOR LAST tr_hist
                FIELDS(tr_serial tr_qty_loc tr_addr tr_part
                       tr_ex_rate tr_ex_rate2 tr_curr
                       tr_price  tr_site tr_expire)
                WHERE tr_domain = GLOBAL_domain
                  AND tr_serial BEGINS m_lot
                  AND tr_type   = "ISS-SO" USE-INDEX tr_serial NO-LOCK:
                ASSIGN m_syslot    = tr_serial
                       m_qty       = - tr_qty_loc
                       m_expdt     = tr_expire
                       m_cust      = tr_addr
                       m_site      = tr_site
/**davidw:1440*        m_oldprice  = tr_price    **Jack ECO:20110420093443*/
                       m_oldprice  = tr_price * tr_ex_rate / tr_ex_rate2
                       m_curr      = tr_curr  /**Jack ECO:20110420093443*/
                       m_part      = tr_part.
            END. /**FOR LAST tr_hist**/
        END. /**IF NOT AVAIL tr_hist THEN**/

        IF NOT AVAIL tr_hist THEN
        DO:
          MESSAGE m_mesdesc[3].
/*davidw:1959*/  RUN sendbell  IN THIS-PROCEDURE.
          UNDO detloop , RETRY detloop.
        END. /**IF NOT AVAIL tr_hist THEN**/
      END. /**IF m_lot <> "" THEN**/
      ELSE DO:
        m_yn = NO.
        MESSAGE "Confirm Lot Creation" UPDATE m_yn.
        IF NOT m_yn THEN
            UNDO detloop , RETRY detloop.

        FOR FIRST code_mstr
            FIELDS(CODE_cmmt)
            WHERE CODE_domain  = GLOBAL_domain
              AND code_fldname = "XX_WO_RECEIPTS"
              AND code_value   = "NRMSeq" NO-LOCK :
        END. /**FOR FIRST code_mstr **/
        IF AVAIL code_mstr THEN
        DO:
            /*maha18112010 duplicate lot issue fix */
             prompt_lot:
             do on endkey undo prompt_lot, leave prompt_lot: /*maha18112010 duplicate lot issue fix */
             {gprun.i ""gpnrmgv.p""
             "(code_cmmt,
               input-output m_lot,
               output errorst,
               output errornum)" }
             /*maha18112010 duplicate lot issue fix */
/*david:2107*/  {gprun.i ""xxchan_nr.p"" "(input-output m_lot)"}
             IF errorst THEN
              DO:
                 {pxmsg.i &MSGNUM=errornum &ERRORLEVEL=3 }
                 undo prompt_lot, retry prompt_lot.
              END.
              /*maha18112010 duplicate lot issue fix */
          end.  /* prompt_blk */
        END. /**AVAIL code_mstr**/
         MESSAGE {&xxictpc_p_22}  UPDATE m_width.
         MESSAGE {&xxictpc_p_07} UPDATE m_length.

         MESSAGE {&xxictpc_p_29}  UPDATE m_splice. /* MK01 */

         IF m_width = 0 OR m_length = 0 THEN
            m_syslot = m_lot
                     + STRING(m_splice,"9").  /*Jack Li**20120512230642*/

         ELSE
         DO:
             m_syslot = m_lot + STRING(m_splice,"9") + STRING(m_width,"9999")  /* MK01 - Added Splice information as 9th Char */
                         + STRING(m_length , "99999").
         END.

     END. /**ELSE DO:**/
     DEFINE variable xxxnewtt1 as logical .   /*tao 20100506130549*/
     DEFINE variable xxxoldqty as decimal .  /*tao 20100506130549*/
     xxxnewtt1 = no .                       /*tao 20100506130549*/
      FIND FIRST tt1_det
           WHERE tt1_lot  = m_lot NO-ERROR.
      IF NOT AVAIL tt1_det THEN
      DO:
         CREATE tt1_det.
         ASSIGN tt1_lot    = m_lot
                tt1_site   = m_site
                tt1_syslot = m_syslot
                tt1_part   = m_part
            /*  tt1_qtyiss = m_qty  Jason ECO# 20120815160723 Removed  */
                tt1_qtyiss = round(m_qty , 3) /* Jason ECO# 20120815160723 Added */
                tt1_expdt  = m_expdt
/*davidw:1440*/ tt1_price  = m_oldprice
                tt1_cust   = m_cust
                tt1_curr   = m_curr /**Jack ECO:20110420093443*/
                xxxnewtt1 = yes .    /*tao 20100506130549*/
         n_count = n_count + 1. /*jackl 20090527133626*/


         FOR FIRST pt_mstr
             FIELDS(pt_um pt_desc1)
              WHERE pt_domain = GLOBAL_domain
                AND pt_part = m_part NO-LOCK:
         END. /**FOR FIRST pt_mstr**/
         IF AVAIL pt_mstr THEN
            ASSIGN tt1_um     = pt_um
                   tt1_desc   = pt_desc1.
      END. /**IF NOT AVAIL tt1_det THEN**/

/*david:1806 begins */
   if n_count = 1 then do:
      m_first_entity = get_sscentity(tt1_part).
      m_first_itaxsite = get_itaxsite(tt1_site, tt1_part).
   end.
   if n_count > 1 then do:
      if m_first_entity <> get_sscentity(tt1_part) then do:
         message "ERRROR: Item Entity Mismatch".
         m_error = Yes.
      end.
      if not m_error and
         m_first_itaxsite <> get_itaxsite(tt1_site, tt1_part) then do:
         message "ERROR: Itax Site Mismatch".
         m_error = Yes.
      end.
   end.  /* n_count > 1 */
   IF m_error THEN DO:
      n_count = n_count - 1.
      if n_count < 0 then n_count = 0.
      DELETE tt1_det.
      CLEAR FRAME a1h ALL NO-PAUSE.
      UNDO detloop, RETRY detloop.
   END. /**IF m_error THEN**/
/*david:1806 end */

/*      DISP tt1_lot tt1_part tt1_um tt1_desc tt1_site tt1_loc
           tt1_rsncd tt1_qtyiss tt1_nbr
           WITH FRAME a1h. MK01  - commented */

      UPDATE tt1_part WHEN m_part = ""
             tt1_cust
            WITH FRAME a1h.
      IF m_part = "" THEN ASSIGN m_part = tt1_part. /* MK02 */

      /*Jack Li*******ECO:20110512102922******/
      if tt1_curr = "" then do:
         find first cm_mstr no-lock where cm_domain = global_domain
                                      and cm_addr   = tt1_cust no-error.
         if available cm_mstr then
            tt1_curr = cm_curr.
      end.

      FOR FIRST pt_mstr
          FIELDS(pt_um pt_desc1 pt__chr05) /* MK01 - added pt__chr05 */
           WHERE pt_domain = GLOBAL_domain
             AND pt_part = m_part NO-LOCK:
      END. /**FOR FIRST pt_mstr**/
      IF AVAIL pt_mstr THEN
      DO:                             /* MK01 */
          ASSIGN tt1_um     = pt_um
                tt1_desc   = pt_desc1.
          ASSIGN m_ver = IF pt__chr05 <> '' THEN pt__chr05 ELSE '0'.
      END.                            /* MK01 */
      ELSE
          ASSIGN m_ver = '0'.
      /* MK01 >> */

      IF m_yn THEN
      ASSIGN tt1_syslot = SUBSTRING(tt1_syslot,1,1) + m_ver + SUBSTRING(tt1_syslot,2, LENGTH(tt1_syslot)) /* MK01 */
             tt1_lot = SUBSTRING(tt1_syslot,1,9).

      DISP tt1_lot tt1_part tt1_um tt1_desc tt1_site tt1_loc
           tt1_rsncd tt1_qtyiss tt1_nbr
           WITH FRAME a1h.
       /* << MK01 */

      DISP tt1_um tt1_desc
           WITH FRAME a1h.
       xxxoldqty = tt1_qtyiss . /*tao 20100506130549*/


       grloop: /* MK22112010 */
       DO ON ERROR UNDO grloop, RETRY grloop:     /* MK22112010 */
           UPDATE tt1_site tt1_loc tt1_rsncd tt1_qtyiss tt1_nbr
                 GO-ON (CTRL-D F5) WITH FRAME a1h.

         /* MK22112010 >>  - GR is mandatory if cm_po_reqd flag is set for that customer  */
            FIND FIRST cm_mstr WHERE cm_domain = GLOBAL_domain
                                 AND cm_addr   = tt1_cust
                                 AND cm_po_reqd NO-LOCK NO-ERROR.
            IF AVAIL cm_mstr AND tt1_nbr = "" THEN
            DO:
               MESSAGE m_mesdesc[45].
               UNDO grloop, RETRY grloop.
            END.
       END. /* grloop */
     /* << MK22112010 */


     if xxxnewtt1 = yes
     then   m_totsqumeter = m_totsqumeter + tt1_qtyiss . /*tao 20100506130549*/
      if  xxxoldqty <> tt1_qtyiss
      and LASTKEY <> KEYCODE("F5") and LASTKEY <> KEYCODE("CTRL-D")
      and xxxnewtt1 = no
      then
     m_totsqumeter = m_totsqumeter + tt1_qtyiss
      - xxxoldqty . /*tao 20100506130549*/

      Message "Tot R:" n_count "Tot S:" m_totsqumeter. /*jackl 20090527133626*/
      /* DELETE */
      IF LASTKEY = KEYCODE("F5") OR LASTKEY = KEYCODE("CTRL-D")
      THEN do:
         del-yn = no.
         /* Please confirm delete */
         {pxmsg.i &MSGNUM=11 &ERRORLEVEL=1 &CONFIRM=del-yn}
         IF del-yn THEN
         DO:
            m_totsqumeter = m_totsqumeter - tt1_qtyiss . /*tao 20100506130549*/
            n_count = n_count - 1. /*jackl 20090527133626*/
            DELETE tt1_det.
            CLEAR FRAME a1h.
            Message "Tot R:" n_count "Tot S:" m_totsqumeter. /*jackl 20090527133626*/
            UNDO detloop, RETRY detloop.
         END. /**IF del-yn THEN**/
      END. /**IF LASTKEY = KEYCODE("F5") OR LASTKEY = KEYCODE("CTRL-D")*/

      ASSIGN m_part   = tt1_part
             m_site   = tt1_site
             m_trtype = "ISS-SO".

      RUN OTHER-VALIDATION IN THIS-PROCEDURE.

      IF m_error THEN DO:
          DELETE tt1_det.
          CLEAR FRAME a1h ALL NO-PAUSE.
          UNDO detloop, RETRY detloop.
      END. /**IF m_error THEN**/

      FOR FIRST CODE_mstr
          FIELDS(CODE_cmmt)
          WHERE CODE_domain  = GLOBAL_domain
            AND CODE_fldname = "xx_soret_loc_channel"
            AND CODE_value   = tt1_loc NO-LOCK:
      END. /**FOR FIRST CODE_mstr**/
      IF AVAIL CODE_mstr THEN
         tt1_channel = CODE_cmmt.

    END. /**END OF REPEAT**/

    IF NOT CAN-FIND(FIRST tt1_det
                    WHERE tt1_qtyiss <> 0
                      AND tt1_cust <> "") THEN
    DO:
       MESSAGE m_mesdesc[14].
/*davidw:1959*/  RUN sendbell  IN THIS-PROCEDURE.
       PAUSE.
       LEAVE mainloop.
    END. /**IF NOT CAN-FIND(FIRST tt1_det WHERE tt1_qtyiss <> 0 ) THEN**/

    RUN PENDINGINVOICE-CIM IN THIS-PROCEDURE.

  END. /**END OF REPEAT**/

END. /**SORETURNS-LOT**/

PROCEDURE SORETURNS-ITEM:
   n_count = 0. /*jackl 20090527133626*/
   FORM
      tt1_part    COLON 8 LABEL {&xxictpc_p_05}
      VALIDATE(CAN-FIND(FIRST pt_mstr
                        WHERE pt_domain = GLOBAL_domain
                          AND pt_part = INPUT FRAME a1h tt1_part
                          AND pt_lot_ser = "" NO-LOCK ) ,
                m_mesdesc[1])
      tt1_um      COLON 8
      tt1_site           LABEL {&xxictpc_p_17}
      VALIDATE(CAN-FIND(FIRST si_mstr NO-LOCK
                        WHERE si_domain = GLOBAL_domain
                          AND si_site   = INPUT FRAME a1h tt1_site ) ,
                       m_mesdesc[9])
      SKIP
      tt1_loc    COLON 5 LABEL {&xxictpc_p_08}
      VALIDATE(CAN-FIND(FIRST loc_mstr NO-LOCK
                        WHERE loc_domain = GLOBAL_domain
                          AND loc_site   = INPUT FRAME a1h tt1_site
                          AND loc_loc    = INPUT FRAME a1h tt1_loc ) ,
                        m_mesdesc[2])
      SKIP
      tt1_cust   COLON 5 LABEL {&xxictpc_p_02}
      VALIDATE(CAN-FIND(FIRST cm_mstr NO-LOCK
                        WHERE cm_domain = GLOBAL_domain
                          AND cm_addr   = INPUT FRAME a1h tt1_cust ) ,
                     m_mesdesc[27])
      tt1_rsncd          LABEL {&xxictpc_p_15}
      VALIDATE(CAN-FIND(FIRST rsn_ref  NO-LOCK
                 WHERE rsn_domain  = GLOBAL_domain
                   AND rsn_type = "SORETURN"
                   AND rsn_code = INPUT FRAME a1h tt1_rsncd ) ,
                         m_mesdesc[7])
      tt1_qtyiss  COLON 5 LABEL {&xxictpc_p_11}
      tt1_nbr             LABEL {&xxictpc_p_26}   FORMAT "X(5)"
     WITH FRAME a1h SIDE-LABEL.

   ON ASSIGN OF sod_det.sod_order_category DO:
       sod_det.sod__chr02 = sod_det.sod_order_category.
   END. /**ON ASSIGN sod_det.sod_order_category**/

   ON ASSIGN OF tr_hist.tr_so_job
   DO:
     FOR FIRST so_mstr
         FIELDS(so_po)
         WHERE so_domain = GLOBAL_domain
           AND so_nbr    = tr_hist.tr_nbr NO-LOCK :
        tr_hist.tr_so_job = so_po.
     END. /**FOR FIRST so_mstr**/
   END. /**ON ASSIGN OF ld_det.ld_expire**/


   mainloop:
   REPEAT:
     EMPTY TEMP-TABLE tt1_det.

     CLEAR FRAME a1h ALL NO-PAUSE.

     detloop:
     REPEAT:

       PROMPT-FOR tt1_part tt1_site tt1_loc
           WITH FRAME a1h EDITING:
           {mfnp.i tt1_det tt1_part tt1_part tt1_part tt1_part
                   tt1_a}
            IF recno <> ? THEN
                DISP tt1_part tt1_um tt1_site tt1_loc tt1_qtyiss
                     WITH FRAME a1h.
       END. /**ROMPT-FOR tt12_lot**/


       ASSIGN m_part   = INPUT FRAME a1h tt1_part
              m_site   = INPUT FRAME a1h tt1_site
              m_loc    = INPUT FRAME a1h tt1_loc
              m_lot    = ""
              m_syslot = ""
              m_ref    = ""
              m_nbr    = ""
              m_recid  = ?
              gpglef   = 0
              m_trtype = "ISS-SO"
              m_error  = NO.

       FIND FIRST tt1_det
            WHERE tt1_part  = m_part
              AND tt1_site  = m_site
              AND tt1_loc   = m_loc  NO-ERROR.
       IF NOT AVAIL tt1_det THEN
       DO:
          CREATE tt1_det.
          ASSIGN tt1_part  = m_part
                 tt1_site  = m_site
                 tt1_loc   = m_loc
/*davidw:1440*/  tt1_price  = 0
                 tt1_loc1  = m_loc.
          n_count = n_count + 1. /*jackl 20090527133626*/

          FOR FIRST pt_mstr
              FIELDS(pt_um pt_desc1)
              WHERE pt_domain = GLOBAL_domain
                AND pt_part = m_part NO-LOCK:
          END. /**FOR FIRST pt_mstr**/
          IF AVAIL pt_mstr THEN
             ASSIGN tt1_um     = pt_um
                    tt1_desc   = pt_desc1.

       END. /**IF NOT AVAIL tt1_det THEN**/

       DISP tt1_part tt1_um tt1_site tt1_cust tt1_loc tt1_rsncd tt1_qtyiss
            tt1_nbr
            WITH FRAME a1h.
       UPDATE tt1_cust tt1_rsncd tt1_qtyiss tt1_nbr
              GO-ON (CTRL-D F5) WITH FRAME a1h DOWN.
       Message "Sum to scan:" n_count. /*jackl 20090527133626*/
       IF LASTKEY = KEYCODE("F5") OR LASTKEY = KEYCODE("CTRL-D")
       THEN do:
            del-yn = no.
            /* Please confirm delete */
            {pxmsg.i &MSGNUM=11 &ERRORLEVEL=1 &CONFIRM=del-yn}
            IF del-yn THEN
            DO:
                DELETE tt1_det.
                CLEAR FRAME a1h.
               n_count = n_count - 1. /*jackl 20090527133626*/
               Message "Sum to scan:" n_count. /*jackl 20090527133626*/
               UNDO detloop, RETRY detloop.
            END. /**IF del-yn THEN**/
       END. /**IF LASTKEY = KEYCODE("F5") OR LASTKEY = KEYCODE("CTRL-D")*/

       ASSIGN m_part   = tt1_part
              m_site   = tt1_site
              m_trtype = "ISS-SO".

       RUN OTHER-VALIDATION IN THIS-PROCEDURE.

       IF m_error THEN
       DO:
           DELETE tt1_det.
           CLEAR FRAME a1h ALL NO-PAUSE.
           UNDO detloop, RETRY detloop.
       END. /**IF m_error THEN**/

       FOR FIRST CODE_mstr
           FIELDS(CODE_cmmt)
           WHERE CODE_domain  = GLOBAL_domain
             AND CODE_fldname = "xx_soret_loc_channel"
             AND CODE_value   = tt1_loc NO-LOCK:
       END. /**FOR FIRST CODE_mstr**/
       IF AVAIL CODE_mstr THEN
          tt1_channel = CODE_cmmt.

     END. /**END OF REPEAT**/

     IF NOT CAN-FIND(FIRST tt1_det
                     WHERE tt1_qtyiss <> 0
                       AND tt1_cust <> "") THEN
     DO:
        MESSAGE m_mesdesc[14].
/*davidw:1959*/  RUN sendbell  IN THIS-PROCEDURE.
        PAUSE.
        LEAVE mainloop.
     END. /**IF NOT CAN-FIND(FIRST tt1_det WHERE tt1_qtyiss <> 0 ) THEN**/

     RUN PENDINGINVOICE-CIM IN THIS-PROCEDURE.
     n_count = 0. /*jackl 20090527133626*/
   END. /**END OF REPEAT**/
END. /**SORETURNS-ITEM**/

PROCEDURE SHIPPERCREATE-LOT:
  n_count = 0. /*jackl 20090527133626*/
  ON ASSIGN OF abs_mstr.abs_line
  DO:
     FOR EACH tt1_det
         WHERE tt1_nbr  = abs_mstr.abs_order
           AND tt1_line = abs_mstr.abs_line :
        tt1_shipid = SUBSTRING(abs_mstr.abs_par_id , 2).
     END. /**EACH tt1_det **/
  END. /**ON ASSIGN OF ld_det.ld_lot:**/

  FORM
      m_frsite  LABEL "Site"   /*davidw FORMAT "X(2)" */
      VALIDATE(CAN-FIND(FIRST si_mstr NO-LOCK
                  WHERE si_domain = GLOBAL_domain
                    AND si_site   = INPUT FRAME a2h m_frsite ) ,
         m_mesdesc[9])
      m_shipid  LABEL "Shp" FORMAT "X(9)"
      VALIDATE(CAN-FIND(FIRST abs_mstr  NO-LOCK
                        WHERE abs_domain    = GLOBAL_domain
                          AND ABS_shipfrom  = INPUT FRAME a2h m_frsite
                          AND ABS_id        = "S" + INPUT FRAME a2h m_shipid
                          AND SUBSTRING(abs_status , 2 , 1) = "" ) OR
      m_shipid = "" , "Error: Invalid ID")

      WITH FRAME a2h SIDE-LABEL.

  FORM
      tt1_lot
      VALIDATE(INPUT FRAME a1 tt1_lot <> ""
               AND LENGTH(INPUT FRAME a1 tt1_lot) = 9 , m_mesdesc[3])
      tt1_part
      tt1_um
      tt1_qtyiss
      tt1_site
      tt1_loc
      WITH FRAME a1 DOWN.

  FORM
    tt1_lot    LABEL {&xxictpc_p_09}
    VALIDATE(INPUT FRAME a1h tt1_lot <> ""
             AND LENGTH(INPUT FRAME a1h tt1_lot) = 9, m_mesdesc[3])
    /*WITH FRAME a1h DOWN .  Jack Li *ECO:20110118163438*/
    WITH FRAME a1h DOWN SIDE-LABEL.  /*Jack Li *ECO:20110118163438*/

  mainloop:
  REPEAT:
    EMPTY TEMP-TABLE tt1_det.

    ASSIGN m_soline = 0. /* MK06 */

    CLEAR FRAME a2hALL NO-PAUSE.
    CLEAR FRAME a1 ALL NO-PAUSE.
    CLEAR FRAME a1h ALL NO-PAUSE.

    UPDATE m_frsite m_shipid
           WITH FRAME a2h.

    IF m_shipid <> "" THEN
    DO:
      FIND FIRST abs_mstr
           WHERE abs_domain    = GLOBAL_domain
             AND ABS_shipfrom  = m_frsite
             AND ABS_id        = "S" + m_shipid
             AND SUBSTRING(abs_status , 2 , 1) = "" no-lock no-error NO-WAIT.
      IF LOCKED ABS_mstr THEN
      DO:
          MESSAGE m_mesdesc[36].
/*davidw:1959*/  RUN sendbell  IN THIS-PROCEDURE.
          UNDO mainloop , RETRY mainloop.
      END. /**IF LOCKED ABS_mstr THEN**/

    END. /**IF m_shipid <> "" THEN**/

    detloop:
    REPEAT:
      IF m_screen THEN
      DO:
          PROMPT-FOR tt1_lot
              GO-ON (CTRL-D F5) WITH FRAME a1h EDITING:
              {mfnp.i tt1_det tt1_lot tt1_lot tt1_lot tt1_lot
                      tt1_a}
               IF recno <> ? THEN
                  DISP tt1_lot
                       WITH FRAME a1h.

          END. /**ROMPT-FOR tt12_lot**/
      END. /**HHT SCREEN**/
      ELSE DO:
          PROMPT-FOR tt1_lot
              GO-ON (CTRL-D F5) WITH FRAME a1 EDITING:
              {mfnp.i tt1_det tt1_lot tt1_lot tt1_lot tt1_lot
                      tt1_a}
               IF recno <> ? THEN
                  DISP tt1_lot tt1_part tt1_um tt1_qtyiss tt1_site tt1_loc
                       WITH FRAME a1.
          END. /**ROMPT-FOR tt12_lot**/

      END. /**MFG/PRO SCREEN**/

      ASSIGN m_part   = ""
             m_lot    = (IF m_screen THEN INPUT FRAME a1h tt1_lot
                         ELSE INPUT FRAME a1 tt1_lot )
             m_syslot = ""
             m_trtype = "ISS-SO"
             m_site   = ""
             m_loc    = ""
             m_nbr    = ""
             m_ref    = "".

      RUN GET-ITEM-FROM-LOTREF IN THIS-PROCEDURE.
      IF m_error THEN
         UNDO detloop , RETRY detloop.
/*davidw across site */
        m_acrossflag = No.
        find first code_mstr where code_domain = global_domain and
             code_fldname = "xx_consume_site" and code_value = m_frsite
             and code_cmmt = m_site no-lock no-error.
        if avail code_mstr then  m_acrossflag = Yes.
/*davidw*/ IF not m_acrossflag and (m_site<> m_frsite)  THEN
      DO:
         MESSAGE m_mesdesc[32].

/*davidw:1959*/  RUN sendbell  IN THIS-PROCEDURE.
         UNDO detloop , RETRY detloop.
      END. /**IF m_site<> m_frsite  THEN**/

      IF m_shipid <> "" THEN
      DO:
        FOR FIRST abs_mstr
            FIELDS(ABS_shipto)
            WHERE abs_domain    = GLOBAL_domain
              AND ABS_shipfrom  = m_frsite
              AND ABS_id        = "S" + m_shipid
              AND SUBSTRING(abs_status , 2 , 1) = "" NO-LOCK:

            FOR FIRST ld_det
                FIELDS(ld__chr01 ld_part  ld_qty_oh)
                 WHERE RECID(ld_det) = m_recid NO-LOCK:
            END. /**FOR FIRST ld_det**/
            IF AVAIL ld_det THEN
            DO:
                IF ld__chr01 <> "" THEN
                DO:
                   ASSIGN m_cust     = ""
                           m_dataset = "".
                            /* maha05122010 >> */
                    FIND FIRST lad_det WHERE lad_domain = GLOBAL_domain
                                       AND (lad_lot    = TRIM(m_syslot) OR lad_lot BEGINS m_lot)
                                       NO-LOCK NO-ERROR.
                    IF AVAIL lad_det THEN
                    DO:
                      ASSIGN m_soline = INT(lad_line).

                    END.

                    /* maha05122010 << */
                   RUN GET-ORDER-DETAILS IN THIS-PROCEDURE
                       (INPUT  ld__chr01   , INPUT ld_part    , OUTPUT m_line ,
                        OUTPUT m_dataset , OUTPUT m_qty , OUTPUT m_cust ,
                        OUTPUT m_rsite , OUTPUT m_qty,
                      OUTPUT m_soum      , OUTPUT m_um_conv).  /*20090605102535*/

                   IF m_dataset <> "sod_det" OR m_cust <> abs_shipto OR
                      m_rsite <> m_frsite THEN
                   DO:
                      MESSAGE m_mesdesc[4].
/*davidw:1959*/  RUN sendbell  IN THIS-PROCEDURE.
                      UNDO detloop , RETRY detloop.
                   END. /**IF m_rsite <> "sod_det" THEN**/
                END. /**IF tt42_nbr <> "" THEN**/
            END. /**IF AVAIL ld_det THEN**/

        END. /**FOR FIRST abs_mstr**/

      END. /**IF m_shipid <> "" THEN**/


      /* DELETE */
      IF LASTKEY = KEYCODE("F5") OR LASTKEY = KEYCODE("CTRL-D")
      THEN do:
         del-yn = no.
         /* Please confirm delete */
         {pxmsg.i &MSGNUM=11 &ERRORLEVEL=1 &CONFIRM=del-yn}
         IF del-yn THEN
         DO:
            FIND FIRST tt1_det
                 WHERE tt1_lot = m_lot NO-ERROR.
            IF AVAIL tt1_det THEN
               DELETE tt1_det.
            IF m_screen THEN DO:
               CLEAR FRAME a1h.
               n_count = n_count - 1. /*jackl 20090527133626*/

               Message "Sum to scan:" n_count. /*jackl 20090527133626*/
            END.
            ELSE
               CLEAR FRAME a1.
            UNDO detloop, RETRY detloop.
         END. /**IF del-yn THEN**/
      END. /**IF LASTKEY = KEYCODE("F5") OR LASTKEY = KEYCODE("CTRL-D")*/


      FIND FIRST tt1_det
           WHERE tt1_lot  = m_lot NO-ERROR.
      IF NOT AVAIL tt1_det THEN
      DO:
         CREATE tt1_det.
         ASSIGN tt1_lot    = m_lot
                tt1_syslot = m_syslot
                tt1_part   = m_part
                tt1_site   = m_site
                tt1_loc    = m_loc.
         n_count = n_count + 1. /*jackl 20090527133626*/

         /* MK06 >> */
      FIND FIRST lad_det WHERE lad_domain = GLOBAL_domain
                           AND (lad_lot    = TRIM(m_syslot) OR lad_lot BEGINS m_lot)
                           NO-LOCK NO-ERROR.
      IF AVAIL lad_det THEN
      DO:
          ASSIGN m_soline = INT(lad_line).

      END.
        /* << MK06 */

        /* Message "Sum to scan:" n_count. jackl 20090527133626*/
         FOR FIRST pt_mstr
             FIELDS(pt_um pt_desc1)
             WHERE pt_domain = GLOBAL_domain
               AND pt_part = m_part NO-LOCK:
         END. /**FOR FIRST pt_mstr**/
         IF AVAIL pt_mstr THEN
            ASSIGN tt1_um    = pt_um
                   tt1_desc  = pt_desc1.

         FOR FIRST ld_det
             FIELDS(ld__chr01 ld_qty_oh)
              WHERE RECID(ld_det) = m_recid NO-LOCK:
         END. /**FOR FIRST ld_det**/
         IF AVAIL ld_det THEN
         DO:
            ASSIGN tt1_nbr   = ld__chr01
                   tt1_qtyiss = ld_qty_oh.
            {xxqtylim.i tt1_qtyiss}
         END. /**IF AVAIL ld_det THEN**/

         IF tt1_nbr = "" THEN
         DO:
             MESSAGE m_mesdesc[44]. /* MK04 */
             DELETE tt1_det. /* MK22112010 */
             n_count = n_count - 1.  /* MK22112010 */
             Message "Sum to scan:" n_count. /*jackl 20110118163438*/
             UNDO detloop, RETRY detloop. /*   MK22112010 - Return if lot is not selected */
         END.
         Message "Sum to scan:" n_count. /*jackl 20110118163438*/
         IF tt1_nbr <> "" THEN
         DO:
             MESSAGE m_mesdesc[43]. /* MK04 */
           /*Jack Li ***ADD BEGIN***ECO#:20091207165510*/
             FOR FIRST so_mstr
                FIELDS(so_stat)
                 WHERE so_domain = global_domain
                   AND so_nbr    = tt1_nbr NO-LOCK :
              if so_stat = "HD" then do:
                 if not m_error then do:
                    MESSAGE "ERROR:Sales Number " + tt1_nbr
                    + " placed on credit hold".
                    RUN sendbell  IN THIS-PROCEDURE.
                 end.
                 UNDO detloop , RETRY detloop.
                 tt1_nbr = "".  m_error = Yes.
              end.
             END.
            /*Jack Li ***ADDED END***ECO#:20091207165510*/

             RUN GET-ORDER-DETAILS IN THIS-PROCEDURE
                 (INPUT tt1_nbr      , INPUT tt1_part , OUTPUT tt1_line ,
                  OUTPUT tt1_dataset , OUTPUT tt1_qtyopn , OUTPUT tt1_cust,
                  OUTPUT tt1_recsite , OUTPUT tt1_qtyall,
                      OUTPUT tt1_soum    , OUTPUT tt1_um_conv).  /*20090605102535*/



         END. /**IF tt42_nbr <> "" THEN**/

      END. /**IF NOT AVAIL tt1_det THEN**/
      ELSE DO:
         Message "Sum to scan:" n_count. /*jackl 20110118163438*/
      END.

      IF m_screen THEN
          DISP tt1_lot
               WITH FRAME a1h.
      ELSE
          DISP tt1_lot tt1_part tt1_um tt1_qtyiss tt1_site tt1_loc
               WITH FRAME a1.

        IF m_screen THEN
           DOWN 1 WITH FRAME a1h.
        ELSE DOWN 1 WITH FRAME a1.


    END. /**END OF REPEAT**/

    EMPTY TEMP-TABLE tt1a_det.

    FOR EACH tt1_det
        WHERE tt1_qtyiss <> 0
          AND tt1_nbr    <> ""
          AND tt1_cust   <> ""
          AND tt1_dataset <> "" :


         FOR EACH lad_det
             FIELDS(lad_part lad_site lad_loc lad_lot lad_ref lad_nbr
                    lad_qty_all lad_line ) NO-LOCK
             WHERE lad_domain  = GLOBAL_domain
               AND lad_dataset = tt1_dataset
               AND lad_nbr     = (IF tt1_dataset = "sod_det" THEN tt1_nbr
                                  ELSE tt1_line)
               AND lad_line    = (IF tt1_dataset = "sod_det" THEN tt1_line
                                  ELSE tt1_recsite)
               AND lad_site    = tt1_site
               AND lad_part    = tt1_part
               AND lad_lot     BEGINS m_ofcutpref
               AND lad_qty_all <> 0
               AND lad_qty_pick = 0:

             IF NOT CAN-FIND(FIRST ld_det
                         WHERE ld_domain   = GLOBAL_domain
                           AND ld_part     = lad_part
                           AND ld_site     = lad_site
                           AND ld_loc      = lad_loc
                           AND ld_lot      = lad_lot
                           AND ld_ref      = lad_ref
                           AND ld__chr02   = "") THEN NEXT.

             FIND FIRST tt1a_det
                  WHERE tt1a_lot = SUBSTRING(lad_lot , 1 , 9) NO-ERROR.
             IF NOT AVAIL tt1a_det THEN
             DO:

                 CREATE tt1a_det.
                ASSIGN tt1a_lot     = SUBSTRING(lad_lot , 1 , 9)
                       tt1a_syslot  = lad_lot
                       tt1a_ref     = lad_ref
                       tt1a_part    = lad_part
                       tt1a_site    = lad_site
                       tt1a_loc     = lad_loc
                       tt1a_nbr     = tt1_nbr
                       tt1a_qtyiss  = lad_qty_all
                       tt1a_line    = tt1_line
                       tt1a_dataset = tt1_dataset
                       tt1a_cust    = tt1_cust
                       tt1a_recsite = tt1_recsite.

                FOR FIRST pt_mstr
                    FIELDS(pt_um pt_desc1)
                    WHERE pt_domain = GLOBAL_domain
                      AND pt_part = tt1a_part NO-LOCK:
                END. /**FOR FIRST pt_mstr**/
                IF AVAIL pt_mstr THEN
                   ASSIGN tt1a_um    = pt_um
                          tt1a_desc  = pt_desc1.

             END. /**IF NOT AVAIL tt1a_det THEN**/

         END. /**EACH lad_det**/

    END. /**EACH tt1_det **/

    FOR EACH tt1a_det :
        FIND FIRST tt1_det
             WHERE tt1_lot = tt1a_lot NO-ERROR.
        IF NOT AVAIL tt1_det THEN
        DO:

           CREATE tt1_det.
           ASSIGN tt1_lot     = tt1a_lot
                  tt1_syslot  = tt1a_syslot
                  tt1_ref     = tt1a_ref
                  tt1_part    = tt1a_part
                  tt1_site    = tt1a_site
                  tt1_loc     = tt1a_loc
                  tt1_nbr     = tt1a_nbr
                  tt1_qtyiss  = tt1a_qtyiss
                  tt1_line    = tt1a_line
                  tt1_dataset = tt1a_dataset
                  tt1_cust    = tt1a_cust
                  tt1_recsite = tt1a_recsite
                  tt1_um      = tt1a_um
                  tt1_desc    = tt1a_desc.
        END. /**IF NOT AVAIL tt1_det THEN**/
        DELETE tt1a_det.
    END. /**EACH tt1a_det**/

    IF NOT CAN-FIND(FIRST tt1_det
                    WHERE tt1_qtyiss <> 0
                      AND tt1_nbr <> ""
                      AND tt1_cust <> "") THEN
    DO:

        MESSAGE m_mesdesc[14].
/*davidw:1959*/  RUN sendbell  IN THIS-PROCEDURE.
       PAUSE.
       LEAVE mainloop.
    END. /**IF NOT CAN-FIND(FIRST tt1_det WHERE tt1_qtyiss <> 0 ) THEN**/

    RUN SOSHIPPERCIM IN THIS-PROCEDURE.
    n_count = 0. /*jackl 20090527133626*/
  END. /**END OF REPEAT**/

END. /**SHIPPERCREATE-LOT**/

PROCEDURE SHIPPERCREATE-PALLET:
  n_count = 0. /*jackl 20090527133626*/
  ON ASSIGN OF abs_mstr.abs_line
  DO:
     FOR EACH tt1_det
         WHERE tt1_nbr  = abs_mstr.abs_order
           AND tt1_line = abs_mstr.abs_line :
        tt1_shipid = SUBSTRING(abs_mstr.abs_par_id , 2).
     END. /**EACH tt1_det **/
  END. /**ON ASSIGN OF ld_det.ld_lot:**/

  FORM
      m_frsite  LABEL "Site"  /*davidw  FORMAT "X(2)"  */
      VALIDATE(CAN-FIND(FIRST si_mstr NO-LOCK
                  WHERE si_domain = GLOBAL_domain
                    AND si_site   = INPUT FRAME a2h m_frsite ) ,
         m_mesdesc[9])
      m_shipid  LABEL "Shp" FORMAT "X(9)"
      VALIDATE(CAN-FIND(FIRST abs_mstr  NO-LOCK
                        WHERE abs_domain    = GLOBAL_domain
                          AND ABS_shipfrom  = INPUT FRAME a2h m_frsite
                          AND ABS_id        = "S" + INPUT FRAME a2h m_shipid
                          AND SUBSTRING(abs_status , 2 , 1) = "" ) OR
      m_shipid = "" , "Error: Invalid ID")

      WITH FRAME a2h SIDE-LABEL.


  FORM
      tt2a_ref    COLUMN-LABEL {&xxictpc_p_10}
      VALIDATE(CAN-FIND(FIRST ld_det
                        WHERE ld_domain = GLOBAL_domain
                          AND ld_ref = INPUT FRAME a1 tt2a_ref
                          AND ld__chr01 <> ""
                          AND ld__chr02 = ""  NO-LOCK ) AND
                INPUT FRAME a1 tt2a_ref <> "" ,
               m_mesdesc[5])
      tt2a_part
      tt2a_um
      tt2a_qtyoh
      tt2a_site
      tt2a_loc
      VALIDATE(CAN-FIND(FIRST loc_mstr NO-LOCK
                        WHERE loc_domain = GLOBAL_domain
                          AND loc_site = m_site
                          AND loc_loc  = INPUT FRAME a1 tt2a_loc ) ,
               m_mesdesc[2])
      WITH FRAME a1 DOWN.

  FORM
    tt2a_ref     COLUMN-LABEL {&xxictpc_p_10}
    VALIDATE(CAN-FIND(FIRST ld_det
                        WHERE ld_domain = GLOBAL_domain
                          AND ld_ref = INPUT FRAME a1h tt2a_ref
                          AND ld__chr01 <> ""
                          AND ld__chr02 = "" NO-LOCK ) AND
             INPUT FRAME a1h tt2a_ref <> "",
               m_mesdesc[5])
    tt2a_qtyoh   LABEL {&xxictpc_p_12}
    WITH FRAME a1h DOWN.

  mainloop:
  REPEAT:
    EMPTY TEMP-TABLE tt2a_det.
    EMPTY TEMP-TABLE tt1_det.

    CLEAR FRAME a1 ALL NO-PAUSE.
    CLEAR FRAME a1h ALL NO-PAUSE.
    CLEAR FRAME a2hALL NO-PAUSE.
    UPDATE m_frsite m_shipid
           WITH FRAME a2h.

     IF m_shipid <> "" THEN
     DO:
        FIND FIRST abs_mstr
             WHERE abs_domain    = GLOBAL_domain
               AND ABS_shipfrom  = m_frsite
               AND ABS_id        = "S" + m_shipid
               AND SUBSTRING(abs_status , 2 , 1) = "" no-lock no-error NO-WAIT.
        IF LOCKED ABS_mstr THEN
        DO:
            MESSAGE m_mesdesc[36].
/*davidw:1959*/  RUN sendbell  IN THIS-PROCEDURE.
            UNDO mainloop , RETRY mainloop.
        END. /**IF LOCKED ABS_mstr THEN**/

    END. /**IF m_shipid <> "" THEN**/

    detloop:
    REPEAT:

      IF m_screen THEN
      DO:
          PROMPT-FOR tt2a_ref
              GO-ON (CTRL-D F5) WITH FRAME a1h EDITING:
              {mfnp.i tt2a_det tt2a_ref tt2a_ref tt2a_ref tt2a_ref
                      tt2a_ref}
               IF recno <> ? THEN
                  DISP tt2a_ref tt2a_qtyoh
                       WITH FRAME a1h.
          END. /**ROMPT-FOR tt12_lot**/
      END. /**HHT SCREEN**/
      ELSE DO:
          PROMPT-FOR tt2a_ref
              GO-ON (CTRL-D F5) WITH FRAME a1 EDITING:
              {mfnp.i tt2a_det tt2a_ref tt2a_ref tt2a_ref tt2a_ref
                      tt2a_ref}
               IF recno <> ? THEN
                  DISP tt2a_ref tt2a_part tt2a_um tt2a_qtyoh tt2a_site tt2a_loc
                       WITH FRAME a1.
          END. /**ROMPT-FOR tt12_lot**/

      END. /**MFG/PRO SCREEN**/

      ASSIGN m_part   = ""
             m_lot    = ""
             m_syslot = ""
             m_site   = ""
             m_loc    = ""
             m_nbr    = ""
             m_trtype = "ISS-SO"
             m_ref    = (IF m_screen THEN INPUT FRAME a1h tt2a_ref
                         ELSE INPUT FRAME a1 tt2a_ref ).

      RUN GET-ITEM-FROM-LOTREF IN THIS-PROCEDURE.

      IF m_error THEN
         UNDO detloop , RETRY detloop.
/*davidw across site */
       m_acrossflag = No.
       find first code_mstr where code_domain = global_domain and
            code_fldname = "xx_consume_site" and code_value = m_frsite
            and code_cmmt = m_site no-lock no-error.
       if avail code_mstr then  m_acrossflag = Yes.
/*davidw*/ IF not m_acrossflag and (m_site<> m_frsite)  THEN
      DO:
         MESSAGE m_mesdesc[32].
/*davidw:1959*/  RUN sendbell  IN THIS-PROCEDURE.
         UNDO detloop , RETRY detloop.
      END. /**IF m_site<> m_frsite  THEN**/

      IF m_shipid <> "" THEN
      DO:
        FOR FIRST abs_mstr
            FIELDS(ABS_shipto)
            WHERE abs_domain    = GLOBAL_domain
              AND ABS_shipfrom  = m_frsite
              AND ABS_id        = "S" + m_shipid
              AND SUBSTRING(abs_status , 2 , 1) = "" NO-LOCK:

            FOR EACH ld_det
                FIELDS(ld__chr01 ld__chr04 ld_part  ld_qty_oh)
                WHERE ld_domain = GLOBAL_domain
                  AND ld_part   = m_part
                  AND ld_ref    = m_ref
                  AND ld_site   = m_site
                  AND ld_loc    = m_loc
                  AND TRUNCATE(ld_qty_oh , 3) <> 0
                  AND ld__chr01 <> ""  NO-LOCK :
                   ASSIGN m_cust     = ""
                           m_dataset = "".

             assign m_soum = ""                               /*20090605102535*/
                    m_um_conv = 1.                            /*20090605102535*/

                   /****Jack Li***BEGIN ADD**ECO:20110307095617*/
                   m_line = ld__chr04.
                   RUN GET-ORDER-DETAILS2 IN THIS-PROCEDURE /*20110825144312*/
                       (INPUT  ld__chr01 , INPUT ld_part , INPUT-OUTPUT m_line ,
                        OUTPUT m_dataset , OUTPUT m_qty , OUTPUT m_cust ,
                        OUTPUT m_rsite , OUTPUT m_qty,
                        OUTPUT   m_soum    , OUTPUT   m_um_conv,
		     OUTPUT m_chr01_a ). /*linas42955*/
                   /****Jack Li***BEGIN ADD**ECO:20110307095617*/

                   /****Jack Li***BEGIN DELETE**ECO:20110307095617*
                   RUN GET-ORDER-DETAILS IN THIS-PROCEDURE
                       (INPUT  ld__chr01   , INPUT ld_part    , OUTPUT m_line ,
                        OUTPUT m_dataset , OUTPUT m_qty , OUTPUT m_cust ,
                        OUTPUT m_rsite , OUTPUT m_qty,
                      OUTPUT   m_soum    , OUTPUT   m_um_conv).  /*20090605102535*/               ****Jack Li***END DELETED**ECO:20110307095617*/

                   IF m_dataset <> "sod_det" OR m_cust <> abs_shipto OR
                      m_rsite <> m_frsite THEN
                   DO:
                      MESSAGE m_mesdesc[4].
/*davidw:1959*/  RUN sendbell  IN THIS-PROCEDURE.
                      UNDO detloop , RETRY detloop.
                   END. /**IF m_rsite <> "sod_det" THEN**/
            END. /**IF AVAIL ld_det THEN**/

        END. /**FOR FIRST abs_mstr**/

      END. /**IF m_shipid <> "" THEN**/


      /* DELETE */
      IF LASTKEY = KEYCODE("F5") OR LASTKEY = KEYCODE("CTRL-D")
      THEN do:
         del-yn = no.
         /* Please confirm delete */
         {pxmsg.i &MSGNUM=11 &ERRORLEVEL=1 &CONFIRM=del-yn}
         IF del-yn THEN
         DO:
            FOR EACH tt1_det
                WHERE tt1_ref = m_ref:
                DELETE tt1_det.
            END. /**EACH tt1_det**/

            FIND FIRST tt2a_det WHERE tt2a_ref = m_ref NO-ERROR.
            IF AVAIL tt2a_det THEN
               DELETE tt2a_det.
            IF m_screen THEN DO:
               CLEAR FRAME a1h.
               n_count = n_count - 1. /*jackl 20090527133626*/
               Message "Sum to scan:" n_count. /*jackl 20090527133626*/
            END.
            ELSE
               CLEAR FRAME a1.
            UNDO detloop, RETRY detloop.
         END. /**IF del-yn THEN**/
      END. /**IF LASTKEY = KEYCODE("F5") OR LASTKEY = KEYCODE("CTRL-D")*/

      FIND FIRST tt2a_det
           WHERE tt2a_ref  = m_ref NO-ERROR.
      IF NOT AVAIL tt2a_det THEN
      DO:
         CREATE tt2a_det.
         ASSIGN tt2a_ref    = m_ref
                tt2a_part   = m_part
                tt2a_site   = m_site
                tt2a_loc    = m_loc.
         n_count = n_count + 1. /*jackl 20090527133626*/
         Message "Sum to scan:" n_count. /*jackl 20090527133626*/
          FOR EACH ld_det
              FIELDS(ld_part ld_lot ld__chr01 ld__chr04 ld_qty_oh)
              WHERE ld_domain = GLOBAL_domain
                AND ld_ref    = m_ref
                AND ld_site   = m_site
                AND ld_loc    = m_loc
                AND TRUNCATE(ld_qty_oh , 3) <> 0
                AND ld__chr01 <> ""  NO-LOCK :

               FIND FIRST tt1_det
                    WHERE tt1_ref   = m_ref
                      AND tt1_part  = ld_part
                      AND tt1_site  = m_site
                      AND tt1_loc   = m_loc
                      AND tt1_lot   = ld_lot NO-ERROR.
               IF NOT AVAIL tt1_det THEN
               DO:
                  CREATE tt1_det.
                  ASSIGN tt1_ref    = m_ref
                         tt1_part   = ld_part
                         tt1_site   = m_site
                         tt1_loc    = m_loc
                         tt1_lot    = ld_lot
                         tt1_syslot = ld_lot.
               END. /**IF NOT AVAIL tt1_det THEN**/
               ASSIGN tt1_nbr   = ld__chr01
                      tt1_line  = ld__chr04  /*jackl**ECO:20110307095617*/
                      tt1_qtyiss = ld_qty_oh
                      tt2a_qtyoh = tt2a_qtyoh + ld_qty_oh.

              {xxqtylim.i tt1_qtyiss}
               {xxqtylim.i tt2a_qtyoh}
               IF tt1_nbr <> "" THEN
               DO:
                 /*Jack Li ***ADD BEGIN***ECO#:20091207165510*/
                   FOR FIRST so_mstr
                       FIELDS(so_stat)
                        WHERE so_domain = global_domain
                          AND so_nbr    = tt1_nbr NO-LOCK :
                     if so_stat = "HD" then do:
                        if not m_error then do:
                           MESSAGE "ERROR:Sales Number " + tt1_nbr
                           + " placed on credit hold".
                           RUN sendbell  IN THIS-PROCEDURE.
                        end.
                        tt1_nbr = "".  m_error = Yes.
                        UNDO detloop, RETRY detloop.
                     end.
                   END.
                 /*Jack Li ***ADDED END***ECO#:20091207165510*/

                 /****Jack Li***BEGIN DELETE**ECO:20110307095617*
                  RUN GET-ORDER-DETAILS IN THIS-PROCEDURE
                      (INPUT tt1_nbr      , INPUT tt1_part , OUTPUT tt1_line ,
                       OUTPUT tt1_dataset , OUTPUT tt1_qtyopn , OUTPUT tt1_cust,
                       OUTPUT tt1_recsite , OUTPUT tt1_qtyall,
                       OUTPUT tt1_soum    , OUTPUT tt1_um_conv).  /*20090605102535*/           ****Jack Li***END DELETED**ECO:20110307095617*/

                 /****Jack Li***BEGIN ADD**ECO:20110307095617*/
                  RUN GET-ORDER-DETAILS2 IN THIS-PROCEDURE
                      (INPUT tt1_nbr      , INPUT tt1_part , INPUT-OUTPUT tt1_line ,
                       OUTPUT tt1_dataset , OUTPUT tt1_qtyopn, OUTPUT tt1_cust ,
                       OUTPUT tt1_recsite , OUTPUT tt1_qtyall,
                       OUTPUT tt1_soum    , OUTPUT tt1_um_conv,
		     OUTPUT m_chr01_a ). /*linas42955*/

                 /****Jack Li***BEGIN ADD**ECO:20110307095617*/
               END. /**IF tt42_nbr <> "" THEN**/

           END. /**EACH ld_det**/

        END. /**IF NOT AVAIL tt2a_det THEN**/

        IF m_screen THEN
            DISP tt2a_ref tt2a_qtyoh
                 WITH FRAME a1h.
        ELSE
            DISP tt2a_ref tt2a_part tt2a_um tt2a_qtyoh tt2a_site tt2a_loc
                 WITH FRAME a1.

        IF m_screen THEN
           DOWN 1 WITH FRAME a1h.
        ELSE DOWN 1 WITH FRAME a1.
    END. /**END OF REPEAT**/

    EMPTY TEMP-TABLE tt1a_det.

    FOR EACH tt1_det
        WHERE tt1_qtyiss  <> 0
          AND tt1_nbr     <> ""
          AND tt1_cust    <> ""
          AND tt1_dataset <> "":
         FOR EACH lad_det
             FIELDS(lad_part lad_site lad_loc lad_lot lad_ref lad_nbr
                    lad_line lad_qty_all) NO-LOCK
              WHERE lad_domain  = GLOBAL_domain
                AND lad_dataset = tt1_dataset
                AND lad_nbr     = (IF tt1_dataset = "sod_det" THEN tt1_nbr
                                   ELSE tt1_line)
                AND lad_line    = (IF tt1_dataset = "sod_det" THEN tt1_line
                                   ELSE tt1_recsite)
                AND lad_site    = tt1_site
                AND lad_part    = tt1_part
                AND lad_lot     BEGINS m_ofcutpref
                AND lad_qty_all <> 0
                AND lad_qty_pick = 0:

             IF NOT CAN-FIND(FIRST ld_det
                         WHERE ld_domain   = GLOBAL_domain
                           AND ld_part     = lad_part
                           AND ld_site     = lad_site
                           AND ld_loc      = lad_loc
                           AND ld_lot      = lad_lot
                           AND ld_ref      = lad_ref
                           AND ld__chr02   = "") THEN NEXT.

             FIND FIRST tt1a_det
                  WHERE tt1a_lot = SUBSTRING(lad_lot , 1 , 9) NO-ERROR.
             IF NOT AVAIL tt1a_det THEN
             DO:
                CREATE tt1a_det.
                ASSIGN tt1a_lot     = SUBSTRING(lad_lot , 1 , 9)
                       tt1a_syslot  = lad_lot
                       tt1a_ref     = lad_ref
                       tt1a_part    = lad_part
                       tt1a_site    = lad_site
                       tt1a_loc     = lad_loc
                       tt1a_nbr     = tt1_nbr
                       tt1a_qtyiss  = lad_qty_all
                       tt1a_line    = tt1_line
                       tt1a_dataset = tt1_dataset
                       tt1a_cust    = tt1_cust
                       tt1a_recsite = tt1_recsite.

                FOR FIRST pt_mstr
                    FIELDS(pt_um pt_desc1)
                    WHERE pt_domain = GLOBAL_domain
                      AND pt_part = tt1a_part NO-LOCK:
                END. /**FOR FIRST pt_mstr**/
                IF AVAIL pt_mstr THEN
                   ASSIGN tt1a_um    = pt_um
                          tt1a_desc  = pt_desc1.

             END. /**IF NOT AVAIL tt1a_det THEN**/

         END. /**EACH lad_det**/

    END. /**EACH tt1_det **/

    FOR EACH tt1a_det :
        FIND FIRST tt1_det
             WHERE tt1_lot = tt1a_lot NO-ERROR.
        IF NOT AVAIL tt1_det THEN
        DO:
           CREATE tt1_det.
           ASSIGN tt1_lot     = tt1a_lot
                  tt1_syslot  = tt1a_syslot
                  tt1_ref     = tt1a_ref
                  tt1_part    = tt1a_part
                  tt1_site    = tt1a_site
                  tt1_loc     = tt1a_loc
                  tt1_nbr     = tt1a_nbr
                  tt1_qtyiss  = tt1a_qtyiss
                  tt1_line    = tt1a_line
                  tt1_dataset = tt1a_dataset
                  tt1_cust    = tt1a_cust
                  tt1_recsite = tt1a_recsite
                  tt1_um      = tt1a_um
                  tt1_desc    = tt1a_desc.
        END. /**IF NOT AVAIL tt1_det THEN**/
        DELETE tt1a_det.
    END. /**EACH tt1a_det**/

    IF NOT CAN-FIND(FIRST tt1_det
                    WHERE tt1_qtyiss <> 0
                      AND tt1_nbr   <> "") THEN
    DO:
       MESSAGE m_mesdesc[14].
/*davidw:1959*/  RUN sendbell  IN THIS-PROCEDURE.
       PAUSE.
       LEAVE mainloop.
    END. /**IF NOT CAN-FIND(FIRST tt1_det WHERE tt1_qtyiss <> 0 ) THEN**/

    RUN SOSHIPPERCIM IN THIS-PROCEDURE.
    n_count = 0. /*jackl 20090527133626*/
  END. /**END OF REPEAT**/
END. /**SHIPPERCREATE-PALLET**/


PROCEDURE CYCCNT-LOT:
  n_count = 0. /*jackl 20090527133626*/
  FORM
      tt1_lot    COLON 5 LABEL {&xxictpc_p_09}
      VALIDATE(INPUT FRAME a1h tt1_lot <> ""
               AND LENGTH(INPUT FRAME a1h tt1_lot) = 9 , m_mesdesc[3])
      tt1_part   COLON 5 LABEL {&xxictpc_p_05}
      tt1_um     NO-LABEL
      tt1_qtyiss COLON 5 LABEL {&xxictpc_p_11}
      SKIP
      tt1_desc   NO-LABEL
      tt1_site   COLON 8 LABEL {&xxictpc_p_18}
      tt1_loc1   NO-LABEL
      tt1_ref    COLON 5 LABEL {&xxictpc_p_14}
      tt1_rsncd          LABEL {&xxictpc_p_15}
      VALIDATE(CAN-FIND(FIRST rsn_ref  NO-LOCK
                 WHERE rsn_domain  = GLOBAL_domain
                   AND rsn_type = "PHYINV"
                   AND rsn_code = INPUT FRAME a1h tt1_rsncd )
               AND (CAN-FIND(
                    FIRST code_mstr
                    WHERE CODE_domain  = global_domain
                      AND code_fldname = "XX_CYCCNT_REASONCD"
                      AND code_value   = "PREFIX"
                      AND INPUT FRAME a1h tt1_rsncd BEGINS code_cmmt
                      AND LOOKUP(GLOBAL_userid , code_desc  )  <> 0 NO-LOCK)
                    OR NOT CAN-FIND(
                    FIRST code_mstr
                    WHERE CODE_domain  = global_domain
                      AND code_fldname = "XX_CYCCNT_REASONCD"
                      AND code_value   = "PREFIX"
                      AND INPUT FRAME a1h tt1_rsncd  BEGINS code_cmmt NO-LOCK)
                   ) ,m_mesdesc[7])
      WITH FRAME a1h SIDE-LABEL.

  ON ASSIGN OF ld_det.ld_qty_oh
  DO:
     FIND FIRST tt1_det WHERE tt1_syslot = ld_det.ld_lot NO-ERROR.
     IF AVAIL tt1_det THEN
     DO:
       IF tt1_expdt <> ? THEN
          ld_det.ld_expire = tt1_expdt.

     END. /**IF AVAIL tt1_det THEN**/
  END. /**ON ASSIGN OF ld_det.ld_lot:**/

  ON ASSIGN OF ld_det.ld_expire
  DO:
     FIND FIRST tt1_det WHERE tt1_syslot = ld_det.ld_lot NO-ERROR.
     IF AVAIL tt1_det THEN
     DO:
        IF tt1_expdt <> ? THEN
           ld_det.ld_expire = tt1_expdt.
     END. /**IF AVAIL tt1_det THEN**/
  END. /**ON ASSIGN  OF ld_det.ld_lot:**/

/* Jason Added Begin ECO#: 20130719115244 */
 ON ASSIGN OF tr_hist.tr_rmks 
  DO:
      tr_hist.tr_rsn_code  = tr_hist.tr_rmks.
 END. /** ON ASSIGN OF tr_hist.tr_rmks **/
/* Jason Added End ECO#: 20130719115244 */

  mainloop:
  REPEAT:
    EMPTY TEMP-TABLE tt1_det.

    CLEAR FRAME a1h ALL NO-PAUSE.

    detloop:
    REPEAT:

      PROMPT-FOR tt1_lot
          WITH FRAME a1h EDITING:
        {mfnp.i tt1_det tt1_lot tt1_lot tt1_lot tt1_lot
                tt1_a}
         IF recno <> ? THEN
            DISP tt1_lot tt1_part tt1_um tt1_qtyiss tt1_desc tt1_site
                 tt1_loc1 tt1_ref tt1_rsncd
                 WITH FRAME a1h.
      END. /**ROMPT-FOR tt12_lot**/

      ASSIGN m_part   = ""
             m_site   = ""
             m_loc    = ""
             m_syslot = ""
             m_lot    = INPUT FRAME a1h tt1_lot
             m_ref    = ""
             m_nbr    = ""
             m_recid  = ?
             gpglef   = 0
             m_trtype = "CYC-RCNT"
             m_error  = NO.

      RUN GET-ITEM-FROM-LOTREF IN THIS-PROCEDURE.

      IF m_error THEN
         UNDO detloop , RETRY detloop.

      FIND FIRST tt1_det
           WHERE tt1_lot  = m_lot NO-ERROR.
      IF NOT AVAIL tt1_det THEN
      DO:
         CREATE tt1_det.
         ASSIGN tt1_lot    = m_lot
                tt1_syslot = m_syslot
                tt1_part   = m_part
                tt1_site   = m_site
                tt1_loc    = m_loc
                tt1_loc1   = m_loc
                tt1_ref    = m_ref
              /*tt1_rsncd  = "00" 20140108135120*/
                tt1_qtyiss = INPUT FRAME a1h tt1_qtyiss
                tt1_qtyoh  = tt1_qtyiss.
         n_count = n_count + 1. /*jackl 20090527133626*/
         FOR FIRST pt_mstr
             FIELDS(pt_um pt_desc1)
              WHERE pt_domain = GLOBAL_domain
                AND pt_part   = m_part NO-LOCK:
         END. /**FOR FIRST pt_mstr**/
         IF AVAIL pt_mstr THEN
            ASSIGN tt1_um     = pt_um
                   tt1_desc   = pt_desc1.
         FOR FIRST ld_det
             FIELDS(ld_qty_oh ld_expire ld__chr01)
             WHERE RECID(ld_det) = m_recid NO-LOCK:
         END. /**FOR FIRST ld_det**/
         IF AVAIL ld_det THEN
            ASSIGN tt1_qtyoh  = ld_qty_oh
                   tt1_expdt  = ld_expire.
         ELSE DO:
           FOR LAST tr_hist
               FIELDS(tr_expire)
               WHERE tr_domain  = GLOBAL_domain
                 AND tr_serial  = m_syslot USE-INDEX tr_serial NO-LOCK:
             tt1_expdt  = tr_expire.
           END. /**FOR LAST tr_hist**/
         END. /**ELSE DO:**/

         {xxqtylim.i tt1_qtyoh}

         tt1_qtyiss = tt1_qtyoh.

      END. /**IF NOT AVAIL tt1_det THEN**/

      DISP tt1_lot tt1_part tt1_um tt1_qtyiss tt1_desc tt1_site
           tt1_loc1 tt1_ref tt1_rsncd
           WITH FRAME a1h.

      UPDATE tt1_qtyiss tt1_loc1 tt1_rsncd
             GO-ON (CTRL-D F5) WITH FRAME a1h.
      Message "Sum to scan:" n_count. /*jackl 20090527133626*/

      ASSIGN m_loc1   = tt1_loc1
             m_trtype = "CYC-RCNT"
             m_error  = NO.

      RUN LOC-STAT-VALIDATION IN THIS-PROCEDURE.

      IF m_error THEN
      DO:
         tt1_loc1 = "".
         UNDO detloop , RETRY detloop.
      END. /**IF m_error THEN**/

      FOR FIRST rsn_ref
          FIELDS(rsn_user2)
          WHERE rsn_domain  = GLOBAL_domain
            AND rsn_type    = "PHYINV"
            AND rsn_code    = tt1_rsncd NO-LOCK:
      END. /**FOR FIRST rsn_ref **/
      IF AVAIL rsn_ref THEN
      DO:
        /* IF SUBSTRING(rsn_user2 , 1 , 8) <> "" THEN
            tt1_sub = SUBSTRING(rsn_user2 , 1 , 8). *20130627135149*/
     
         tt1_sub = entry(1,rsn_user2,",") no-error.  /*20130627135149*/
         tt1_acct = entry(2,rsn_user2,",") no-error. /*20130627135149*/
          
      END. /**IF AVAIL rsn_ref THEN**/

      IF tt1_qtyiss <> tt1_qtyoh THEN
      DO:
          FOR FIRST in_mstr
              FIELDS(in_gl_cost_site in_gl_set)
               WHERE in_domain = GLOBAL_domain
                 AND in_site   = tt1_site
                 AND in_part   = tt1_part NO-LOCK :
          END. /**FOR FIRST in_mstr**/
          IF AVAIL in_mstr THEN
          DO:
             FOR FIRST sct_det
                 FIELDS(sct_cst_tot)
                 WHERE sct_domain = GLOBAL_domain
                   AND sct_site   = in_gl_cost_site
                   AND sct_sim    =
                   (IF in_gl_set  = "" THEN "STANDARD" ELSE in_gl_set)
                   AND sct_part   = tt1_part NO-LOCK:
             END. /**FOR FIRST sct_det**/
             IF AVAIL sct_det THEN
                tt1_value = ABS(tt1_qtyiss - tt1_qtyoh ) * sct_cst_tot.
          END. /**IF AVAIL in_mstr THEN**/
      END. /**IF tt1_qtyiss <> tt1_qtyoh THEN**/

      /* DELETE */
      IF LASTKEY = KEYCODE("F5") OR LASTKEY = KEYCODE("CTRL-D")
      THEN do:
         del-yn = no.
        /* Please confirm delete */
        {pxmsg.i &MSGNUM=11 &ERRORLEVEL=1 &CONFIRM=del-yn}
        IF del-yn THEN
        DO:
           DELETE tt1_det.
           CLEAR FRAME a1h ALL NO-PAUSE.
           n_count = n_count - 1. /*jackl 20090527133626*/
           Message "Sum to scan:" n_count. /*jackl 20090527133626*/
           UNDO detloop, RETRY detloop.
        END. /**IF del-yn THEN**/
      END. /**IF LASTKEY = KEYCODE("F5") OR LASTKEY = KEYCODE("CTRL-D")*/
    END. /**END OF REPEAT**/

    IF NOT CAN-FIND(FIRST tt1_det) THEN  /*20121206143700*/
       LEAVE mainloop.                   /*20121206143700*/
    IF NOT CAN-FIND(FIRST tt1_det WHERE tt1_loc1  <> ""
                                    AND tt1_rsncd <> "") /*20140108135120*/
    THEN
    DO:
       MESSAGE m_mesdesc[14].
/*davidw:1959*/  RUN sendbell  IN THIS-PROCEDURE.
       PAUSE.
       LEAVE mainloop.
    END. /**IF NOT CAN-FIND(FIRST tt1_det WHERE tt1_qtyiss <> 0 ) THEN**/

    ASSIGN m_value = 0
           m_apamt = 0.
    FOR EACH tt1_det
        WHERE tt1_value <> 0 :
       IF NOT CAN-FIND(FIRST code_mstr
                       WHERE CODE_domain  = global_domain
                         AND code_fldname = "XX_CYCCNT_REASONCD"
                         AND code_value   = "PREFIX"
                         AND tt1_rsncd  BEGINS code_cmmt NO-LOCK) THEN
          m_value = m_value + tt1_value.
    END. /**EACH tt1_det**/

    IF m_value > 0 THEN
    DO:
       FOR FIRST rqa_mstr
           FIELDS(rqa__chr01)
           WHERE rqa_mstr.rqa_domain    = GLOBAL_domain
             AND rqa_mstr.rqa_type      = 4
             AND rqa_mstr.rqa_apr       = GLOBAL_userid
             AND rqa_mstr.rqa_site      = m_site
             AND rqa_mstr.rqa_prod_line = ""
             AND (rqa_mstr.rqa_start  = ? OR
                  rqa_mstr.rqa_start <= TODAY)
             AND (rqa_mstr.rqa_end    = ? OR
                  rqa_mstr.rqa_end   >= TODAY) NO-LOCK:
       END. /**FOR FIRST rqa_mstr**/
       IF AVAIL rqa_mstr THEN
         m_apamt = DECIMAL(rqa_mstr.rqa__chr01) NO-ERROR.

       IF m_value > m_apamt THEN
       DO:
          MESSAGE m_mesdesc[29].
/*davidw:1959*/  RUN sendbell  IN THIS-PROCEDURE.
          PAUSE.
          LEAVE mainloop.
       END. /**IF m_value > rql_amt THEN**/
    END. /**IF m_value > 0 THEN**/

    RUN CYCLE-RECOUNT-CIM IN THIS-PROCEDURE.
    n_count = 0. /*jackl 20090527133626*/
  END. /**END OF REPEAT**/

END. /**CYCCNT-LOT**/

PROCEDURE CYCCNT-ITEM:
    n_count = 0. /*jackl 20090527133626*/
    FORM
        tt1_part    COLON 8 LABEL {&xxictpc_p_05}
        VALIDATE(CAN-FIND(FIRST pt_mstr
                          WHERE pt_domain = GLOBAL_domain
                            AND pt_part = INPUT FRAME a1h tt1_part
                            AND pt_lot_ser = "" NO-LOCK ) ,
                 m_mesdesc[1])
        tt1_um      COLON 8
        tt1_site    COLON 8
        VALIDATE(CAN-FIND(FIRST si_mstr NO-LOCK
                          WHERE si_domain = GLOBAL_domain
                            AND si_site = INPUT FRAME a1h tt1_site ) ,
                 m_mesdesc[9])
        tt1_loc     COLON 8 LABEL {&xxictpc_p_04}
        VALIDATE(CAN-FIND(FIRST loc_mstr NO-LOCK
                          WHERE loc_domain = GLOBAL_domain
                            AND loc_site = INPUT FRAME a1h tt1_site
                            AND loc_loc  = INPUT FRAME a1h tt1_loc ) ,
                 m_mesdesc[2])
        tt1_qtyiss  COLON 8 LABEL {&xxictpc_p_11}
        tt1_rsncd          LABEL {&xxictpc_p_15}
        VALIDATE(CAN-FIND(FIRST rsn_ref  NO-LOCK
                   WHERE rsn_domain  = GLOBAL_domain
                     AND rsn_type = "PHYINV"
                     AND rsn_code = INPUT FRAME a1h tt1_rsncd )
                 AND (CAN-FIND(
                      FIRST code_mstr
                      WHERE CODE_domain  = global_domain
                        AND code_fldname = "XX_CYCCNT_REASONCD"
                        AND code_value   = "PREFIX"
                        AND INPUT FRAME a1h tt1_rsncd BEGINS code_cmmt
                        AND LOOKUP(GLOBAL_userid , code_desc  )  <> 0 NO-LOCK)
                      OR NOT CAN-FIND(
                      FIRST code_mstr
                      WHERE CODE_domain  = global_domain
                        AND code_fldname = "XX_CYCCNT_REASONCD"
                        AND code_value   = "PREFIX"
                        AND INPUT FRAME a1h tt1_rsncd  BEGINS code_cmmt NO-LOCK)
                     ) ,m_mesdesc[7])
      WITH FRAME a1h SIDE-LABEL.

    mainloop:
    REPEAT:
      EMPTY TEMP-TABLE tt1_det.

      CLEAR FRAME a1h ALL NO-PAUSE.

      detloop:
      REPEAT:

        PROMPT-FOR tt1_part tt1_site tt1_loc
            WITH FRAME a1h EDITING:
            {mfnp.i tt1_det tt1_part tt1_part tt1_part tt1_part
                    tt1_a}
             IF recno <> ? THEN
                 DISP tt1_part tt1_um tt1_site tt1_loc tt1_qtyiss
                      WITH FRAME a1h.
        END. /**ROMPT-FOR tt12_lot**/


        ASSIGN m_part   = INPUT FRAME a1h tt1_part
               m_site   = INPUT FRAME a1h tt1_site
               m_loc    = INPUT FRAME a1h tt1_loc
               m_lot    = ""
               m_syslot = ""
               m_ref    = ""
               m_nbr    = ""
               m_recid  = ?
               gpglef   = 0
               m_trtype = "CYC-RCNT"
               m_error  = NO.

        RUN GET-ITEM-FROM-LOTREF IN THIS-PROCEDURE.

        IF m_error THEN
           UNDO detloop , RETRY detloop.

        FIND FIRST tt1_det
             WHERE tt1_part  = m_part
               AND tt1_site  = m_site
               AND tt1_loc   = m_loc  NO-ERROR.
        IF NOT AVAIL tt1_det THEN
        DO:
           CREATE tt1_det.
           ASSIGN tt1_part  = m_part
                  tt1_site  = m_site
                  tt1_loc   = m_loc
                  tt1_loc1  = m_loc
                  tt1_rsncd = "00".
           n_count = n_count + 1. /*jackl 20090527133626*/
           FOR FIRST ld_det
               FIELDS(ld__chr01 ld_qty_oh)
               WHERE RECID(ld_det) = m_recid NO-LOCK:
           END. /**FOR FIRST ld_det**/
           IF AVAIL ld_det THEN
           DO:
              ASSIGN tt1_nbr     = ld__chr01
                     tt1_qtyoh   = ld_qty_oh.
              {xxqtylim.i tt1_qtyoh}
              tt1_qtyiss  = tt1_qtyoh.
           END. /**IF AVAIL ld_det THEN**/

           FOR FIRST pt_mstr
               FIELDS(pt_um pt_desc1)
               WHERE pt_domain = GLOBAL_domain
                 AND pt_part = m_part NO-LOCK:
           END. /**FOR FIRST pt_mstr**/
           IF AVAIL pt_mstr THEN
              ASSIGN tt1_um     = pt_um
                     tt1_desc   = pt_desc1.

        END. /**IF NOT AVAIL tt1_det THEN**/

        DISP tt1_part tt1_um tt1_site tt1_loc tt1_qtyiss
             WITH FRAME a1h.
        UPDATE tt1_qtyiss tt1_rsncd
               GO-ON (CTRL-D F5) WITH FRAME a1h DOWN.
        Message "Sum to scan:" n_count. /*jackl 20090527133626*/

        IF tt1_qtyiss <> tt1_qtyoh THEN
        DO:
            FOR FIRST in_mstr
                FIELDS(in_gl_cost_site in_gl_set)
                 WHERE in_domain = GLOBAL_domain
                   AND in_site   = tt1_site
                   AND in_part   = tt1_part NO-LOCK :
            END. /**FOR FIRST in_mstr**/
            IF AVAIL in_mstr THEN
            DO:
               FOR FIRST sct_det
                   FIELDS(sct_cst_tot)
                   WHERE sct_domain = GLOBAL_domain
                     AND sct_site   = in_gl_cost_site
                     AND sct_sim    =
                     (IF in_gl_set  = "" THEN "STANDARD" ELSE in_gl_set)
                     AND sct_part   = tt1_part NO-LOCK:
               END. /**FOR FIRST sct_det**/
               IF AVAIL sct_det THEN
                  tt1_value = ABS(tt1_qtyiss - tt1_qtyoh ) * sct_cst_tot.
            END. /**IF AVAIL in_mstr THEN**/
        END. /**IF tt1_qtyiss <> tt1_qtyoh THEN**/


        IF LASTKEY = KEYCODE("F5") OR LASTKEY = KEYCODE("CTRL-D")
        THEN do:
             del-yn = no.
             /* Please confirm delete */
             {pxmsg.i &MSGNUM=11 &ERRORLEVEL=1 &CONFIRM=del-yn}
             IF del-yn THEN
             DO:
                 DELETE tt1_det.
                 CLEAR FRAME a1h.
                n_count = n_count - 1. /*jackl 20090527133626*/
                Message "Sum to scan:" n_count. /*jackl 20090527133626*/
                UNDO detloop, RETRY detloop.
             END. /**IF del-yn THEN**/
        END. /**IF LASTKEY = KEYCODE("F5") OR LASTKEY = KEYCODE("CTRL-D")*/

      END. /**END OF REPEAT**/

      IF NOT CAN-FIND(FIRST tt1_det WHERE tt1_loc1  <> "" ) THEN
      DO:
         MESSAGE m_mesdesc[14].
/*davidw:1959*/  RUN sendbell  IN THIS-PROCEDURE.
         PAUSE.
         LEAVE mainloop.
      END. /**IF NOT CAN-FIND(FIRST tt1_det WHERE tt1_qtyiss <> 0 ) THEN**/

      ASSIGN m_value = 0
             m_apamt = 0.
      FOR EACH tt1_det
          WHERE tt1_value <> 0 :
         IF NOT CAN-FIND(FIRST code_mstr
                         WHERE CODE_domain  = global_domain
                           AND code_fldname = "XX_CYCCNT_REASONCD"
                           AND code_value   = "PREFIX"
                           AND tt1_rsncd  BEGINS code_cmmt NO-LOCK) THEN
            m_value = m_value + tt1_value.
      END. /**EACH tt1_det**/

      IF m_value > 0 THEN
      DO:
         FOR FIRST rqa_mstr
             FIELDS(rqa__chr01)
             WHERE rqa_mstr.rqa_domain    = GLOBAL_domain
               AND rqa_mstr.rqa_type      = 4
               AND rqa_mstr.rqa_apr       = GLOBAL_userid
               AND rqa_mstr.rqa_site      = m_site
               AND rqa_mstr.rqa_prod_line = ""
               AND (rqa_mstr.rqa_start  = ? OR
                    rqa_mstr.rqa_start <= TODAY)
               AND (rqa_mstr.rqa_end    = ? OR
                    rqa_mstr.rqa_end   >= TODAY) NO-LOCK:
         END. /**FOR FIRST rqa_mstr**/
         IF AVAIL rqa_mstr THEN
           m_apamt = DECIMAL(rqa_mstr.rqa__chr01) NO-ERROR.

         IF m_value > m_apamt THEN
         DO:
            MESSAGE m_mesdesc[29].
/*davidw:1959*/  RUN sendbell  IN THIS-PROCEDURE.
            PAUSE.
            LEAVE mainloop.
         END. /**IF m_value > rql_amt THEN**/
      END. /**IF m_value > 0 THEN**/

      RUN CYCLE-RECOUNT-CIM IN THIS-PROCEDURE.
      n_count = 0. /*jackl 20090527133626*/
    END. /**END OF REPEAT**/

END. /**CYCCNT-ITEM**/


PROCEDURE PHYINV-LOT:
  DEFINE VARIABLE t_yn AS LOGIC INIT NO.  /**Jack Li*20120517161745**/
  n_count = 0. /*jackl 20090527133626*/
  FORM
      tt1_tag   COLON 5 LABEL {&xxictpc_p_20}
      VALIDATE(CAN-FIND(FIRST tag_mstr NO-LOCK
                        WHERE tag_domain = GLOBAL_domain
                          AND tag_nbr    = INPUT FRAME a1h tt1_tag
                          AND NOT tag_void
                          AND NOT tag_posted ) ,
               m_mesdesc[10])
      tt1_lot    COLON 5 LABEL {&xxictpc_p_09}
      /*VALIDATE(INPUT FRAME a1h tt1_lot <> ""
               AND LENGTH(INPUT FRAME a1h tt1_lot) = 9 , m_mesdesc[3])           */  tt1_part   COLON 5 LABEL {&xxictpc_p_05}
      tt1_um     NO-LABEL
      tt1_qtyiss COLON 5 LABEL {&xxictpc_p_11}
      SKIP
      tt1_site   COLON 8 LABEL {&xxictpc_p_18}
      tt1_loc1   NO-LABEL
      tt1_ref    COLON 5 LABEL {&xxictpc_p_14}
      xx_cnt_qty COLON 12 LABEL "Qty Counted"           /* 20090522130248 */
      WITH FRAME a1h SIDE-LABEL.

  ON ASSIGN OF tag_mstr.tag_serial
  DO:
     FIND FIRST tt1_det WHERE tt1_syslot = tag_mstr.tag_serial NO-ERROR.
     IF AVAIL tt1_det THEN
     DO:
      /**Jack Li****ECO:20120220104853*****
       IF tt1_expdt <> ? THEN
          tag_user1 = STRING(tt1_expdt).
       ***********ECO:20120220104853******/

       IF tt1_user1 <> "" THEN
          tag_user1 = tt1_user1.   /*Jack Li**ECO:20120220104853*/
     END. /**IF AVAIL tt1_det THEN**/
  END. /**ON ASSIGN OF ld_det.ld_lot:**/

  mainloop:
  REPEAT:
    EMPTY TEMP-TABLE tt1_det.

    CLEAR FRAME a1h ALL NO-PAUSE.

    detloop:
    REPEAT:

      PROMPT-FOR tt1_tag
          WITH FRAME a1h EDITING:
        {mfnp.i tt1_det tt1_tag tt1_tag tt1_tag tt1_tag
                tt1_tag}
         IF recno <> ? THEN
            DISP tt1_tag tt1_lot tt1_part tt1_um tt1_qtyiss tt1_site
                 tt1_loc1 tt1_ref
                 WITH FRAME a1h.
      END. /**ROMPT-FOR tt12_lot**/

      /*jackl  --ADD BEGIN*/
        t_yn = No.   /***Jack Li**20120517161745**/
        FIND FIRST tag_mstr NO-LOCK
                      WHERE tag_domain = GLOBAL_domain
                        AND tag_nbr    = INPUT FRAME a1h tt1_tag
                        AND NOT tag_void
                        AND NOT tag_posted NO-ERROR.
             IF AVAILABLE tag_mstr then do:
                /* MESSAGE "Tag Number:" FRAME a1h tt1_tag " is exist".*/
                /**Jack Li**ADD BEGIN***ECO:20120517161745***/
                 ASSIGN m_part   = tag_part
                        m_site   = tag_site
                        m_loc    = tag_loc
                        m_syslot = tag_serial
                        m_lot    = substring(tag_serial,1,9)
                        m_ref    = tag_ref
                        m_nbr    = ""
                        m_recid  = ?
                        gpglef   = 0
                        m_trtype = "TAG-CNT"
                        m_error  = NO.
               /***Jack Li***ADDED END***ECO:20120517161745****/

                 display tag_serial @ tt1_lot
                         tag_part   @ tt1_part
                         tag_site   @ tt1_site
                         tag_loc    @ tt1_loc1
                         with frame a1h.

                 display tag_cnt_qty @ xx_cnt_qty with frame a1h.  /*20090522130248*/           if tag_serial <> "" then
                  t_yn = Yes.        /**Jack Li**20120517161745**/
             end.
             else message "m_mesdesc[10]".
      /*jackl  --ADDED END*/

     m_tag = INPUT FRAME a1h tt1_tag.
      FIND FIRST tt1_det
           WHERE tt1_tag  = m_tag NO-ERROR.
      IF AVAIL tt1_det THEN
         MESSAGE "Tag Number:" FRAME a1h tt1_tag " is exist".
      IF NOT AVAIL tt1_det THEN
      DO:
        /**
         DISP /*"" @ tt1_lot*/ "" @ tt1_part "" @ tt1_um
              0 @ tt1_qtyiss "" @ tt1_site
              "" @ tt1_loc1 "" @ tt1_ref
              WITH FRAME a1h.   20120517161745***/

       IF t_yn = No THEN DO:  /**Jack Li**20120517161745**/
         PROMPT-FOR tt1_lot
                    WITH WITH FRAME a1h.
         /*jackl  --ADD BEGIN*/
         find first tt1_det no-lock
                      where tt1_lot = input frame a1h tt1_lot no-error.
          if available tt1_det then do:
             MESSAGE "Tag Number:" tt1_tag " exist for this lot/loc".
             UNDO detloop , RETRY detloop.
          end.
          else do:
            FIND FIRST tag_mstr NO-LOCK
                       WHERE tag_domain = GLOBAL_domain
                AND substring(tag_serial,1,9) = INPUT FRAME a1h tt1_lot
                         AND tag_site <> ""
                         AND NOT tag_void
                         AND NOT tag_posted NO-ERROR.
              IF AVAILABLE tag_mstr then do:
                 IF tag_nbr <> INPUT FRAME a1h tt1_tag THEN DO:
                 MESSAGE "Tag Number:" tag_nbr " exist for this lot/loc".
                 UNDO detloop , RETRY detloop.
                 END.
              end.
           end.
     /*jackl  --ADDED END*/

         ASSIGN m_part   = ""
                m_site   = ""
                m_loc    = ""
                m_syslot = ""
                m_lot    = INPUT FRAME a1h tt1_lot
               m_ref    = ""
                m_nbr    = ""
                m_recid  = ?
                gpglef   = 0
                m_trtype = "TAG-CNT"
                m_error  = NO.

         RUN GET-ITEM-FROM-LOTREF IN THIS-PROCEDURE.
       END.

         IF m_error THEN
            UNDO detloop , RETRY detloop.
         CREATE tt1_det.
         ASSIGN tt1_tag    = m_tag
                tt1_lot    = m_lot
                tt1_syslot = m_syslot
                tt1_part   = m_part
                tt1_site   = m_site
                tt1_loc    = m_loc
                tt1_loc1   = m_loc
                tt1_ref    = m_ref.
         n_count = n_count + 1. /*jackl 20090527133626*/
         FOR FIRST ld_det
             FIELDS(ld_qty_oh ld_expire ld__chr01)
             WHERE RECID(ld_det) = m_recid NO-LOCK:
         END. /**FOR FIRST ld_det**/
         IF AVAIL ld_det THEN DO:
            ASSIGN tt1_expdt  = ld_expire
                   tt1_qtyoh  = ld_qty_oh.
         END.
         ELSE DO:
           FOR LAST tr_hist
               FIELDS(tr_expire)
               WHERE tr_domain  = GLOBAL_domain
                 AND tr_serial  = m_syslot USE-INDEX tr_serial NO-LOCK:
             tt1_expdt  = tr_expire.
           END. /**FOR LAST tr_hist**/
         END. /**ELSE DO:**/

     /**Jack Li****ADD BEGIN****ECO:20120220104853***/
        FIND FIRST tag_mstr NO-LOCK
             WHERE tag_domain = GLOBAL_domain
               AND tag_nbr    = INPUT FRAME a1h tt1_tag
               AND tag_serial = m_syslot
               AND NOT tag_void
               AND NOT tag_posted NO-ERROR.
        IF AVAILABLE tag_mstr THEN DO:
           tt1_qtyoh = tag_cnt_qty.
        END.

        assign tt1_user1  = "".
        find first ld_det no-lock where ld_domain = global_domain
                                    and ld_lot    = m_syslot no-error.
        if available ld_det then do:
           if ld_date = ? then
              tt1_user1 = "?".
           else
              tt1_user1 = string(ld_date).

           if ld_expire = ? then
              tt1_user1 = tt1_user1 + ",?".
           else
              tt1_user1 = tt1_user1 + "," + string(ld_expire).
        end.
      /**  find first tr_hist no-lock where tr_domain = global_domain
                                     and tr_serial = m_syslot
                                     and (tr_type   = "RCT-PO"  or
                                          tr_type   = "RCT-UNP" or
                                          tr_type   = "CYC-RCNT" or
                                          tr_type   = "RCT-WO")
                                     and tr_part   = m_part use-index
                                     tr_serial no-error.
        if available tr_hist then do:
           if tt1_user1 = "" then
              tt1_user1 = string(tr_date) + "," +
                          string(tr_expire).

           tt1_user1 = tt1_user1 + "," + tr_vend_lot.
        end.
        ******/

     /**Jack Li****ADDED END****ECO:20120220104853***/
         {xxqtylim.i tt1_qtyoh}
         tt1_qtyiss = tt1_qtyoh.
         FOR FIRST pt_mstr
             FIELDS(pt_um pt_desc1)
             WHERE pt_domain = GLOBAL_domain
                AND pt_part   = m_part NO-LOCK:
         END. /**FOR FIRST pt_mstr**/
         IF AVAIL pt_mstr THEN
            ASSIGN tt1_um     = pt_um
                   tt1_desc   = pt_desc1.

      END. /**IF NOT AVAIL tt1_det THEN**/

      DISP tt1_tag tt1_lot tt1_part tt1_um tt1_qtyiss tt1_site
           tt1_loc1 tt1_ref
           WITH FRAME a1h.

      UPDATE tt1_qtyiss tt1_loc1
             GO-ON (CTRL-D F5) WITH FRAME a1h.
      Message "Sum to scan:" n_count. /*jackl 20090527133626*/
      IF tt1_loc1 <> tt1_loc AND tt1_qtyoh <> 0 THEN
      DO:
        FOR LAST tag_mstr
             FIELD(tag_nbr)
             WHERE tag_domain = GLOBAL_domain NO-LOCK:
        END. /**FOR LAST tag_mstr**/
        IF AVAIL tag_mstr THEN
           tt1_tag1 = tag_nbr + 1.
        ELSE tt1_tag1 = 1.
      END. /**IF tt1_loc1 <> tt1_loc THEN**/

      ASSIGN m_loc1   = tt1_loc1
             m_trtype = "TAG-CNT"
             m_error  = NO.

      RUN LOC-STAT-VALIDATION IN THIS-PROCEDURE.

      IF m_error THEN
      DO:
         tt1_loc1 = "".
         UNDO detloop , RETRY detloop.
      END. /**IF m_error THEN**/

      /* DELETE */
      IF LASTKEY = KEYCODE("F5") OR LASTKEY = KEYCODE("CTRL-D")
      THEN do:
         del-yn = no.
        /* Please confirm delete */
        {pxmsg.i &MSGNUM=11 &ERRORLEVEL=1 &CONFIRM=del-yn}
        IF del-yn THEN
        DO:
           DELETE tt1_det.
           CLEAR FRAME a1h ALL NO-PAUSE.
           n_count = n_count - 1. /*jackl 20090527133626*/
           Message "Sum to scan:" n_count. /*jackl 20090527133626*/
           UNDO detloop, RETRY detloop.
        END. /**IF del-yn THEN**/
      END. /**IF LASTKEY = KEYCODE("F5") OR LASTKEY = KEYCODE("CTRL-D")*/
      IF tt1_tag1 <> 0 THEN
      DO:
        FOR FIRST tag_mstr
            FIELDS(tag_domain tag_type tag_nbr )
             WHERE tag_domain  = GLOBAL_domain
               AND tag_nbr     = tt1_tag1 :
        END. /**FOR FIRST tag_mstr**/
        IF NOT AVAIL tag_mstr THEN
        DO:
           CREATE tag_mstr.
           ASSIGN tag_domain  = GLOBAL_domain
                  tag_type    = "B"
                  tag_nbr     = tt1_tag1.
        END. /**IF NOT AVAIL tag_mstr THEN**/
      END. /**IF tt1_tag1 <> 0 THEN**/

    END. /**END OF REPEAT**/

    IF NOT CAN-FIND(FIRST tt1_det WHERE tt1_loc1  <> "") THEN
    DO:
       MESSAGE m_mesdesc[14].
       PAUSE.
       LEAVE mainloop.
    END. /**IF NOT CAN-FIND(FIRST tt1_det WHERE tt1_qtyiss <> 0 ) THEN**/

   /**Jack Li***ADD BEGIN*****ECO:20120613111428**/
    FOR EACH tt1_det NO-LOCK:
        FIND FIRST tag_mstr NO-LOCK WHERE tag_domain = global_domain
                                      AND tag_nbr <> tt1_tag
                                      AND NOT tag_void  /*20130224184324*/
                                      AND tag_serial = tt1_syslot NO-ERROR.
        IF AVAILABLE tag_mstr THEN DO:
           MESSAGE "The Lot No. " tt1_syslot " does exist in other Tag No."
                   tag_nbr.
           UNDO mainloop, RETRY mainloop.
        END.
    END.
   /**Jack Li***ADDED END*****ECO:20120613111428**/

    RUN TAG-RECOUNT-CIM IN THIS-PROCEDURE.
    n_count = 0. /*jackl 20090527133626*/
  END. /**END OF REPEAT**/

END. /**PHYINV-LOT**/

PROCEDURE PHYINV-ITEM:
    n_count = 0. /*jackl 20090527133626*/
    FORM
        tt1_tag   COLON 5 LABEL {&xxictpc_p_20}
        VALIDATE(CAN-FIND(FIRST tag_mstr NO-LOCK
                          WHERE tag_domain = GLOBAL_domain
                            AND tag_nbr    = INPUT FRAME a1h tt1_tag
                            AND NOT tag_void
                            AND NOT tag_posted) ,
             m_mesdesc[10])
        tt1_part    COLON 8 LABEL {&xxictpc_p_05}
        VALIDATE(CAN-FIND(FIRST pt_mstr
                          WHERE pt_domain = GLOBAL_domain
                            AND pt_part = INPUT FRAME a1h tt1_part
                            AND pt_lot_ser = "" NO-LOCK ) ,
                 m_mesdesc[1])
        tt1_um      COLON 8
        tt1_site    COLON 8
        VALIDATE(CAN-FIND(FIRST si_mstr NO-LOCK
                          WHERE si_domain = GLOBAL_domain
                            AND si_site = INPUT FRAME a1h tt1_site ) ,
                 m_mesdesc[9])
        tt1_loc    COLON 8 LABEL {&xxictpc_p_08}
        VALIDATE(CAN-FIND(FIRST loc_mstr NO-LOCK
                      WHERE loc_domain = GLOBAL_domain
                        AND loc_site = INPUT FRAME a1h tt1_site
                        AND loc_loc  = INPUT FRAME a1h tt1_loc ),
             m_mesdesc[2])
        tt1_qtyiss  COLON 8 LABEL {&xxictpc_p_11}
        WITH FRAME a1h SIDE-LABEL.

    ON ASSIGN OF tag_mstr.tag_nbr
    DO:
       FIND FIRST tt1_det WHERE tt1_tag = tag_mstr.tag_nbr NO-ERROR.
       IF AVAIL tt1_det THEN
       DO:
         IF tt1_expdt <> ? THEN
            tag_user1 = STRING(tt1_expdt).
       END. /**IF AVAIL tt1_det THEN**/
       ELSE DO:
           FIND FIRST tt1_det WHERE tt1_tag1 = tag_mstr.tag_nbr NO-ERROR.
           IF AVAIL tt1_det THEN
           DO:
             IF tt1_expdt <> ? THEN
                tag_user1 = STRING(tt1_expdt).
           END. /**IF AVAIL tt1_det THEN**/
       END. /**ELSE DO:**/
    END. /**ON ASSIGN OF ld_det.ld_lot:**/


    mainloop:
    REPEAT:
      EMPTY TEMP-TABLE tt1_det.

      CLEAR FRAME a1 ALL NO-PAUSE.
      CLEAR FRAME a1h ALL NO-PAUSE.

      detloop:
      REPEAT:
        PROMPT-FOR tt1_tag
            WITH FRAME a1h EDITING:
          {mfnp.i tt1_det tt1_tag tt1_tag tt1_tag tt1_tag
              tt1_tag}
          IF recno <> ? THEN
             DISP tt1_tag tt1_part tt1_um tt1_qtyiss tt1_site
                  tt1_loc
                  WITH FRAME a1h.
        END. /**ROMPT-FOR tt12_lot**/

        m_tag = INPUT FRAME a1h tt1_tag.

        FIND FIRST tt1_det
             WHERE tt1_tag  = m_tag   NO-ERROR.
        IF NOT AVAIL tt1_det THEN
        DO:
           DISP "" @ tt1_part "" @ tt1_um
                0 @ tt1_qtyiss "" @ tt1_site
                "" @ tt1_loc ""
                WITH FRAME a1h.

           PROMPT-FOR tt1_part tt1_site tt1_loc
                  WITH FRAME a1h.

           ASSIGN m_part   = INPUT FRAME a1h tt1_part
                  m_site   = INPUT FRAME a1h tt1_site
                  m_loc    = INPUT FRAME a1h tt1_loc
                  m_loc1   = m_loc
                  m_lot    = ""
                  m_syslot = ""
                  m_ref    = ""
                  m_nbr    = ""
                  m_recid  = ?
                  gpglef   = 0
                  m_trtype = "TAG-CNT"
                  m_error  = NO.

           RUN GET-ITEM-FROM-LOTREF IN THIS-PROCEDURE.


           IF m_error THEN
             UNDO detloop , RETRY detloop.

           CREATE tt1_det.
           ASSIGN tt1_tag   = m_tag
                  tt1_part  = m_part
                  tt1_site  = m_site
                  tt1_loc   = m_loc
                  tt1_loc1  = m_loc.
           n_count = n_count + 1. /*jackl 20090527133626*/
           FOR FIRST ld_det
               FIELDS(ld_qty_oh ld_expire ld__chr01)
               WHERE RECID(ld_det) = m_recid NO-LOCK:
           END. /**FOR FIRST ld_det**/
           IF AVAIL ld_det THEN
           DO:
              ASSIGN tt1_qtyoh   = ld_qty_oh
                     tt1_expdt   = ld_expire.
              {xxqtylim.i tt1_qtyoh}
              tt1_qtyiss = tt1_qtyoh.
           END. /**IF AVAIL ld_det THEN**/

           FOR FIRST pt_mstr
               FIELDS(pt_um pt_desc1)
               WHERE pt_domain = GLOBAL_domain
                 AND pt_part = m_part NO-LOCK:
           END. /**FOR FIRST pt_mstr**/
           IF AVAIL pt_mstr THEN
              ASSIGN tt1_um     = pt_um
                     tt1_desc   = pt_desc1.
        END. /**IF NOT AVAIL tt1_det THEN**/
        DISP tt1_tag tt1_part tt1_um tt1_qtyiss tt1_site
             tt1_loc WITH FRAME a1h.

        UPDATE tt1_qtyiss
               GO-ON (CTRL-D F5) WITH FRAME a1h.


        IF tt1_loc1 <> tt1_loc AND tt1_qtyoh <> 0 THEN
        DO:
           FOR LAST tag_mstr
               FIELD(tag_nbr)
               WHERE tag_domain = GLOBAL_domain NO-LOCK:
           END. /**FOR LAST tag_mstr**/
           IF AVAIL tag_mstr THEN
               tt1_tag1 = tag_nbr + 1.
           ELSE tt1_tag1 = 1.
        END. /**IF tt1_loc1 <> tt1_loc THEN**/

        ASSIGN m_loc1   = tt1_loc1
               m_trtype = "TAG-CNT"
               m_error  = NO.

        RUN LOC-STAT-VALIDATION IN THIS-PROCEDURE.

        IF m_error THEN
        DO:
          tt1_loc1 = "".
          UNDO detloop , RETRY detloop.
        END. /**IF m_error THEN**/

        /* DELETE */
        IF LASTKEY = KEYCODE("F5") OR LASTKEY = KEYCODE("CTRL-D")
        THEN do:
           del-yn = no.
          /* Please confirm delete */
          {pxmsg.i &MSGNUM=11 &ERRORLEVEL=1 &CONFIRM=del-yn}
          IF del-yn THEN
          DO:
             DELETE tt1_det.
             CLEAR FRAME a1h ALL NO-PAUSE.
             n_count = n_count - 1. /*jackl 20090527133626*/
             Message "Sum to scan:" n_count. /*jackl 20090527133626*/
             UNDO detloop, RETRY detloop.
          END. /**IF del-yn THEN**/
        END. /**IF LASTKEY = KEYCODE("F5") OR LASTKEY = KEYCODE("CTRL-D")*/

        IF tt1_tag1 <> 0 THEN
        DO:
          FOR FIRST tag_mstr
              FIELDS(tag_domain tag_type tag_nbr )
               WHERE tag_domain  = GLOBAL_domain
                 AND tag_nbr     = tt1_tag1 :
          END. /**FOR FIRST tag_mstr**/
          IF NOT AVAIL tag_mstr THEN
          DO:
            CREATE tag_mstr.
            ASSIGN tag_domain  = GLOBAL_domain
                   tag_type    = "B"
                   tag_nbr     = tt1_tag1.
          END. /**IF NOT AVAIL tag_mstr THEN**/
        END. /**IF tt1_tag1 <> 0 THEN**/

      END. /**END OF REPEAT**/

      IF NOT CAN-FIND(FIRST tt1_det WHERE tt1_loc1  <> "") THEN
      DO:
        MESSAGE m_mesdesc[14].
        PAUSE.
        LEAVE mainloop.
      END. /**IF NOT CAN-FIND(FIRST tt1_det WHERE tt1_qtyiss <> 0 ) THEN**/

      RUN TAG-RECOUNT-CIM IN THIS-PROCEDURE.
      n_count = 0. /*jackl 20090527133626*/
    END. /**END OF REPEAT**/

END. /**PHYINV-ITEM*/


PROCEDURE PHYINV-LOT-OPENING:
  n_count = 0. /*jackl 20090527133626*/
  FORM
      tt1_tag   COLON 5 LABEL {&xxictpc_p_20}
      VALIDATE(CAN-FIND(FIRST tag_mstr NO-LOCK
                        WHERE tag_domain = GLOBAL_domain
                          AND tag_nbr    = INPUT FRAME a1h tt1_tag
                          AND NOT tag_void
                          AND NOT tag_posted) ,
               m_mesdesc[10])
      tt1_lot    COLON 5 LABEL {&xxictpc_p_09} FORMAT "X(9)"
      VALIDATE(CAN-FIND(FIRST usrw_wkfl NO-LOCK
                        WHERE usrw_domain = "AU001"
                          AND usrw_key1   = "XXIVLOAD"
                          AND usrw_key2   = INPUT FRAME a1h tt1_lot) OR
               CAN-FIND(FIRST usrw_wkfl NO-LOCK
                        WHERE usrw_domain = "AU001"
                          AND usrw_key1   = "XXIVLOAD"
                          AND usrw_key2  BEGINS INPUT FRAME a1h tt1_lot )
                                                            OR
               CAN-FIND(FIRST usrw_wkfl NO-LOCK
                        WHERE usrw_domain = "NZ003"
                          AND usrw_key1   = "XXIVLOAD"
                          AND usrw_key2   = INPUT FRAME a1h tt1_lot) OR
               CAN-FIND(FIRST usrw_wkfl NO-LOCK
                        WHERE usrw_domain = "NZ003"
                         AND usrw_key1   = "XXIVLOAD"
                         AND usrw_key2  BEGINS INPUT FRAME a1h tt1_lot )
               AND LENGTH(INPUT FRAME a1h tt1_lot) = 9
                    ,
             m_mesdesc[3])
      tt1_part   COLON 5 LABEL {&xxictpc_p_05}
      VALIDATE(CAN-FIND(FIRST pt_mstr NO-LOCK
                        WHERE pt_domain = GLOBAL_domain
                          AND pt_part   = INPUT FRAME a1h tt1_part ) ,
             m_mesdesc[1])
      tt1_um     NO-LABEL
      tt1_qtyiss COLON 5 LABEL {&xxictpc_p_11}
      SKIP
      tt1_site   COLON 8 LABEL {&xxictpc_p_18}
      VALIDATE(CAN-FIND(FIRST si_mstr NO-LOCK
                        WHERE si_domain = GLOBAL_domain
                          AND si_site   = INPUT FRAME a1h tt1_site ) ,
             m_mesdesc[9])
      tt1_loc1   NO-LABEL
      VALIDATE(CAN-FIND(FIRST loc_mstr NO-LOCK
                        WHERE loc_domain = GLOBAL_domain
                          AND loc_site   = INPUT FRAME a1h tt1_site
                          AND loc_loc    = INPUT FRAME a1h tt1_loc1  ) ,
             m_mesdesc[2])

      tt1_ref    COLON 5 LABEL {&xxictpc_p_14}
      WITH FRAME a1h SIDE-LABEL.

  ON ASSIGN OF tag_mstr.tag_serial
  DO:
     FIND FIRST tt1_det WHERE tt1_syslot = tag_mstr.tag_serial NO-ERROR.
     IF AVAIL tt1_det THEN
     DO:
       IF tt1_user2 <> "" THEN
          tag_user2 = tt1_user2.
     END. /**IF AVAIL tt1_det THEN**/
  END. /**ON ASSIGN OF ld_det.ld_lot:**/

  mainloop:
  REPEAT:
    EMPTY TEMP-TABLE tt1_det.

    CLEAR FRAME a1h ALL NO-PAUSE.

    detloop:
    REPEAT:

      PROMPT-FOR tt1_tag
          WITH FRAME a1h EDITING:
        {mfnp.i tt1_det tt1_tag tt1_tag tt1_tag tt1_tag
                tt1_tag}
         IF recno <> ? THEN
            DISP tt1_tag tt1_lot tt1_part tt1_um tt1_qtyiss tt1_site
                 tt1_loc1 tt1_ref
                 WITH FRAME a1h.
      END. /**ROMPT-FOR tt12_lot**/

      m_tag = INPUT FRAME a1h tt1_tag.

      FIND FIRST tt1_det
           WHERE tt1_tag  = m_tag  NO-ERROR.
      IF NOT AVAIL tt1_det THEN
      DO:
         DISP "" @ tt1_lot "" @ tt1_part "" @ tt1_um
              0 @ tt1_qtyiss "" @ tt1_site
              "" @ tt1_loc1 "" @ tt1_ref
              WITH FRAME a1h.

         PROMPT-FOR tt1_lot
                    WITH WITH FRAME a1h.

         ASSIGN m_part   = ""
                m_site   = ""
                m_loc    = ""
                m_syslot = ""
                m_lot    = INPUT FRAME a1h tt1_lot
               m_ref    = ""
                m_nbr    = ""
                m_recid  = ?
                gpglef   = 0
                m_trtype = "TAG-CNT"
                m_error  = NO.


         FOR FIRST usrw_wkfl
             FIELDS(usrw_charfld usrw_decfld usrw_key2)
             WHERE usrw_domain   = "AU001"
               AND usrw_key1     = "XXIVLOAD"
               AND usrw_key2     = m_lot NO-LOCK:
         END. /**FOR FIRST usrw_wkfl**/
         IF NOT AVAIL usrw_wkfl THEN
         DO:
             FOR FIRST usrw_wkfl
                 FIELDS(usrw_charfld usrw_decfld usrw_key2)
                 WHERE usrw_domain               = "AU001"
                   AND usrw_key1                 = "XXIVLOAD"
                   AND usrw_key2  BEGINS m_lot NO-LOCK:
             END. /**FOR FIRST usrw_wkfl**/
             IF NOT AVAIL usrw_wkfl THEN
             DO:

               FOR FIRST usrw_wkfl
                   FIELDS(usrw_charfld usrw_decfld usrw_key2)
                    WHERE usrw_domain   = "NZ003"
                      AND usrw_key1     = "XXIVLOAD"
                     AND usrw_key2     = m_lot NO-LOCK:
               END. /**FOR FIRST usrw_wkfl**/
               IF NOT AVAIL usrw_wkfl THEN
               DO:
                 FOR FIRST usrw_wkfl
                     FIELDS(usrw_charfld usrw_decfld usrw_key2)
                     WHERE usrw_domain               = "NZ003"
                       AND usrw_key1                 = "XXIVLOAD"
                       AND usrw_key2 BEGINS m_lot NO-LOCK:
                 END. /**FOR FIRST usrw_wkfl**/
               END. /**IF NOT AVAIL usrw_wkfl THEN**/
             END. /**IF NOT AVAIL usrw_wkfl THEN**/
         END. /**IF NOT AVAIL usrw_wkfl THEN**/

         IF AVAIL usrw_wkfl THEN
         DO:
            CREATE tt1_det.
            ASSIGN tt1_tag    = m_tag
                   tt1_lot    = m_lot
                   tt1_syslot = usrw_key2
                   m_part     = usrw_charfld[1]
                   tt1_part   = usrw_charfld[1]
                   tt1_site   = usrw_charfld[2]
                   tt1_loc    = usrw_charfld[3]
                   tt1_loc1   = usrw_charfld[3]
                   tt1_ref    = m_ref
                   tt1_user2  = STRING(usrw_charfld[5]) + "," +
                                STRING(usrw_charfld[6]) + "," +
                                usrw_charfld[7]         + "," +
                                STRING(usrw_charfld[8])
                   tt1_qtyoh  = usrw_decfld[1].
             n_count = n_count + 1. /*jackl 20090527133626*/
             {xxqtylim.i tt1_qtyoh}
             tt1_qtyiss = tt1_qtyoh.
             FOR FIRST pt_mstr
                 FIELDS(pt_um pt_desc1)
                 WHERE pt_domain = GLOBAL_domain
                    AND pt_part   = m_part NO-LOCK:
             END. /**FOR FIRST pt_mstr**/
             IF AVAIL pt_mstr THEN
                ASSIGN tt1_um     = pt_um
                       tt1_desc   = pt_desc1.
         END. /**IF AVAIL ld_det THEN**/

      END. /**IF NOT AVAIL tt1_det THEN**/

      DISP tt1_tag tt1_lot tt1_part tt1_um tt1_qtyiss tt1_site
           tt1_loc1 tt1_ref
           WITH FRAME a1h.

      UPDATE tt1_qtyiss tt1_site tt1_loc1
             GO-ON (CTRL-D F5) WITH FRAME a1h.
      Message "Sum to scan:" n_count. /*jackl 20090527133626*/

      ASSIGN m_loc1   = tt1_loc1
             m_trtype = "TAG-CNT"
             m_error  = NO.

      RUN LOC-STAT-VALIDATION IN THIS-PROCEDURE.

      IF m_error THEN
      DO:
         tt1_loc1 = "".
         UNDO detloop , RETRY detloop.
      END. /**IF m_error THEN**/

      /* DELETE */
      IF LASTKEY = KEYCODE("F5") OR LASTKEY = KEYCODE("CTRL-D")
      THEN do:
         del-yn = no.
        /* Please confirm delete */
        {pxmsg.i &MSGNUM=11 &ERRORLEVEL=1 &CONFIRM=del-yn}
        IF del-yn THEN
        DO:
           DELETE tt1_det.
           CLEAR FRAME a1h ALL NO-PAUSE.
           n_count = n_count - 1. /*jackl 20090527133626*/
           Message "Sum to scan:" n_count. /*jackl 20090527133626*/
           UNDO detloop, RETRY detloop.
        END. /**IF del-yn THEN**/
      END. /**IF LASTKEY = KEYCODE("F5") OR LASTKEY = KEYCODE("CTRL-D")*/

    END. /**END OF REPEAT**/

    IF NOT CAN-FIND(FIRST tt1_det WHERE tt1_loc1  <> "") THEN
    DO:
       MESSAGE m_mesdesc[14].
/*davidw:1959*/  RUN sendbell  IN THIS-PROCEDURE.
       PAUSE.
       LEAVE mainloop.
    END. /**IF NOT CAN-FIND(FIRST tt1_det WHERE tt1_qtyiss <> 0 ) THEN**/

    RUN TAG-RECOUNT-CIM IN THIS-PROCEDURE.
    n_count = 0. /*jackl 20090527133626*/
  END. /**END OF REPEAT**/

END. /**PHYINV-LOT**/


PROCEDURE proc_loadcimfile:
    batchrun = YES.
    ASSIGN m_trflg = NO. /* MK24112010 */
    OUTPUT TO VALUE(m_outfile).
    INPUT FROM VALUE(m_cimfile) NO-ECHO.
    IF m_option BEGINS "SORETURNS" THEN
    DO:
        {gprun.i ""soivmt.p""}
    END. /**SO RETURNS**/
    ELSE IF m_option BEGINS "SHIPPERCREATE" THEN
    DO:
        {gprun.i ""rcshwb.p""}
    END. /**DO RECEIPTS**/
    ELSE IF m_option BEGINS "DOREC" THEN
    DO:
        {gprun.i ""dsdorc.p""}
    END. /**DO RECEIPTS**/
    ELSE IF m_option BEGINS "SODOSHIP" THEN
    DO:
        ASSIGN m_trflg = YES. /* MK24112010 */
        {gprun.i ""sosois.p""}
        {gprun.i ""dsdois.p""}

    END. /**SALES ORDER/DISTRIBUTION ORDER SHIPMENTS**/
    ELSE IF m_option BEGINS "CYCCNT" THEN
    DO:
        {gprun.i ""icccaj.p""}
    END. /**CYCLE RECOUNT**/
    ELSE IF m_option BEGINS "PHYINV" THEN
    DO:
        {gprun.i ""pitcmt1.p""}
    END. /**PHYSICAL INVENTORY COUNT**/
    ELSE DO:
        {gprun.i ""iclotr04.p""}
    END. /**ELSE DO**/
    INPUT CLOSE.
    OUTPUT CLOSE.
    batchrun = NO.

    /* ROLLBACK */
    ASSIGN m_cimerr = NO.

    OUTPUT TO VALUE (m_errfile).
    INPUT FROM VALUE(m_outfile) NO-ECHO.
    REPEAT:
        IMPORT UNFORMATTED m_message.

        IF m_message BEGINS "** Value" AND m_option BEGINS "CYCCNT"
           THEN NEXT.

        IF (m_message BEGINS "ERROR"
        OR m_message BEGINS "**") AND (m_message <> "** Array subscript 0 is out of range. (26)")  /* MK01 */
        THEN
        DO:
            m_cimerr = yes.
            PUT m_message AT 2 SKIP (1).
        END. /**IF m_message BEGINS "ERROR"**/
    END. /**REPEAT**/
    INPUT CLOSE.
    OUTPUT CLOSE.

END. /* PROCEDURE  proc_loadcimfile */

PROCEDURE GET-ITEM-FROM-LOTREF:

    FOR FIRST icc_ctrl
        FIELDS(icc_iss_days)
        WHERE icc_domain = GLOBAL_domain NO-LOCK :

    END. /**FOR FIRST icc_ctrl**/
    IF NOT AVAIL icc_ctrl THEN
       RETURN.

   IF m_part <> "" THEN
   DO:

       FOR FIRST ld_det
           FIELDS(ld__chr01)
           WHERE ld_domain   = GLOBAL_domain
             AND ld_part     = m_part
             AND ld_site     = m_site
             AND ld_loc      = m_loc
             AND ld_lot      = m_lot
             AND ld_ref      = m_ref
             AND TRUNCATE(ld_qty_oh , 3) <> 0  NO-LOCK:
       END. /**FOR FIRST ld_det**/
       IF AVAIL ld_det THEN
       DO:
         m_recid = RECID(ld_det).
         IF m_option BEGINS "PALLETIZE" THEN
            assign m_nbr   = ld__chr01.
         RUN LOC-DET-VALIDATIONS IN THIS-PROCEDURE
             (INPUT m_recid , OUTPUT m_error).
       END. /**IF AVAIL ld_det THEN**/
   END. /**m_part**/
   ELSE IF m_nbr <> "" THEN
   DO:

     m_dataset = "".
     FOR FIRST so_mstr
         FIELDS(so_nbr)
          WHERE so_domain = global_domain
            AND so_nbr = m_nbr NO-LOCK:
     END. /**FOR FIRST so_mstr**/
     IF AVAIL so_mstr THEN
     DO:

        m_dataset = "sod_det".
        FOR FIRST lad_det
            FIELDS(lad_part lad_site lad_loc)
             WHERE lad_domain  = GLOBAL_domain
               AND lad_dataset = m_dataset
               AND lad_nbr     = m_nbr
               AND (lad_qty_all <> 0  OR lad_qty_pick <> 0) NO-LOCK:
        END. /**FOR FIRST lad_det **/
        IF AVAIL lad_det THEN
            ASSIGN m_site    = lad_site
                   m_loc     = lad_loc
                   m_part    = lad_part
                   m_recid = RECID(lad_det).
        ELSE m_dataset = "".
     END. /**IF AVAIL so_mstr THEN**/
     ELSE DO:
        m_qty     = 0.

        FOR FIRST dss_mstr
            FIELDS(dss_rec_site dss_shipsite)
             WHERE dss_domain = GLOBAL_domain
               AND dss_nbr    = m_nbr NO-LOCK:
        END. /**FOR FIRST dss_mstr**/
        IF AVAIL dss_mstr THEN
        DO:
           m_dataset = "ds_det".
           IF m_option = "DOREC-ORDER" THEN
              ASSIGN m_recid   = RECID(dss_mstr)
                     m_site    = dss_rec_site.

           IF m_option <> "DOREC-ORDER" THEN
           DO:
               FOR EACH  dsd_det
                   FIELDS(dsd_part dsd_qty_ship dsd_qty_rcvd dsd_git_site
                          dsd_site dsd_req_nbr dsd_shipsite dsd_trans_id)
                   WHERE dsd_domain   = GLOBAL_domain
                     AND dsd_nbr      = m_nbr
                     AND dsd_shipsite = dss_shipsite NO-LOCK :

                   IF dsd_part = m_part AND dsd_qty_ship <> dsd_qty_rcvd THEN
                   DO:
                       ASSIGN m_site   = dsd_git_site
                              m_loc    = dsd_trans_id.

                       FOR FIRST dsr_mstr
                           FIELDS(dsr_loc)
                           WHERE dsr_domain  = global_domain
                             AND dsr_req_nbr = dsd_req_nbr
                             AND dsr_site    = dsd_site NO-LOCK:
                       END. /**FOR FIRST dsr_mstr**/
                       IF AVAIL dsr_mstr THEN
                          m_loc1   = dsr_loc.

                   END. /**IF dsd_part = m_part AND dsd_qty_sh THEN**/

                   FOR FIRST lad_det
                       FIELDS(lad_part lad_site lad_loc)
                       WHERE lad_domain  = GLOBAL_domain
                          AND lad_dataset = m_dataset
                          AND lad_nbr     = dsd_req_nbr
                          AND lad_line    = dss_rec_site
                          AND lad_part    = dsd_part
                          AND lad_site    = dsd_shipsite
                          AND (lad_qty_all <> 0  OR lad_qty_pick <> 0) NO-LOCK:
                   END. /**FOR FIRST lad_det**/
                   IF AVAIL lad_det THEN
                       ASSIGN m_site    = lad_site
                              m_loc     = lad_loc
                              m_part    = lad_part
                              m_line    = dsd_req_nbr
                              m_recid   = RECID(lad_det).
               END. /**EACH dsd_det**/
           END. /**IF m_option <> "DOREC-ORDER" THEN**/
        END. /**IF AVAIL dss_mstr THEN**/
     END. /**ELSE DO**/
     IF m_recid = ? THEN
     DO:
        MESSAGE m_mesdesc[20].
/*davidw:1959*/  RUN sendbell  IN THIS-PROCEDURE.
        m_error = YES.
     END. /**IF m_recid = ? THEN**/

   END. /**IF m_nbr <> "" THEN**/
   ELSE DO:


       IF m_lot <> "" THEN
       DO:
          m_maxtrnbr = 0.   /*Jack Li*20130528142050*/
          IF m_option BEGINS "DOREC" THEN
          DO:
           /*Jack Li****DELETE BEGIN****ECO:20130528142050**** 
              FOR LAST tr_hist
                  FIELDS(tr_serial tr_part tr_site tr_loc tr_ref tr_nbr tr_lot)
                   WHERE tr_domain = GLOBAL_domain
                     AND tr_serial = m_lot
                     AND tr_type   = "RCT-GIT"
                     USE-INDEX tr_serial NO-LOCK:
                  ASSIGN m_syslot = tr_serial
                         m_site   = tr_site
                         m_loc    = tr_loc
                         m_ref    = tr_ref
                         m_part   = tr_part
                         m_nbr    = tr_nbr
                         m_line   = tr_lot.
              END. /**FOR LAST tr_hist **/
              IF NOT AVAIL tr_hist THEN
              DO:
                  FOR LAST tr_hist
                      FIELDS(tr_serial tr_part tr_site tr_loc tr_ref
                             tr_nbr tr_lot)
                     WHERE tr_domain = GLOBAL_domain
                       AND tr_serial BEGINS m_lot
                       AND tr_type   = "RCT-GIT"
                       USE-INDEX tr_serial NO-LOCK:
                      ASSIGN m_syslot = tr_serial
                             m_site   = tr_site
                             m_loc    = tr_loc
                             m_ref    = tr_ref
                             m_part   = tr_part
                             m_nbr    = tr_nbr
                             m_line   = tr_lot.
                  END. /**FOR LAST tr_hist **/
              END. /**IF NOT AVAIL tr_hist THEN**/
              IF NOT AVAIL tr_hist THEN
              DO :
                 m_error = YES.

                 MESSAGE m_mesdesc[3].
/*davidw:1959*/  RUN sendbell  IN THIS-PROCEDURE.
              END. /**ELSE DO : **/
              IF m_error THEN
                 RETURN.
           *Jack Li****DELETED END****ECO:20130528142050****/

           /*Jack Li****ADD  BEGIN****ECO:20130528142050****/
            FOR LAST ld_det WHERE ld_domain = global_domain
                               AND ld_lot    = m_lot
                               AND ld_qty_oh <> 0
                               NO-LOCK :
               ASSIGN m_syslot = ld_lot
                      m_site   = ld_site
                      m_loc    = ld_loc
                      m_ref    = ld_ref
                      m_part   = ld_part
                      m_nbr    = ld__chr01
                      m_line   = ld__chr04.
            END.                    
            IF NOT AVAILABLE ld_det THEN DO:
               FOR LAST ld_det WHERE ld_domain = global_domain
                                 AND ld_lot    BEGINS m_lot
                                 AND ld_qty_oh <> 0
                                 NO-LOCK :
                   ASSIGN m_syslot = ld_lot
                          m_site   = ld_site
                          m_loc    = ld_loc
                          m_ref    = ld_ref
                          m_part   = ld_part
                          m_nbr    = ld__chr01
                          m_line   = ld__chr04.
               END.
            END.
            IF NOT AVAILABLE ld_det THEN DO:
               m_error = YES.
               
               MESSAGE m_mesdesc[3].
               RUN sendbell  IN THIS-PROCEDURE.
            END. /**ELSE DO : **/
            IF m_error THEN
               RETURN.
           /*Jack Li****ADDED END****ECO:20130528142050****/
           
              FOR FIRST dsd_det
                  FIELDS(dsd_loc)
                  WHERE dsd_domain  = GLOBAL_domain
                    AND dsd_req_nbr = m_line NO-LOCK:
              END. /**FOR FIRST dsd_det **/
              IF AVAIL dsd_det THEN
                 m_loc1 = dsd_loc.
              ELSE m_nbr = "".

              FOR FIRST ld_det
                  FIELDS(ld__chr01 ld_qty_oh)
                  WHERE ld_domain   = GLOBAL_domain
                    AND ld_part     = m_part
                    AND ld_lot      = m_syslot
                    AND ld_site     = m_site
                    AND ld_loc      = m_loc
                    AND ld_ref      = ""
                    AND TRUNCATE(ld_qty_oh , 3) <> 0  NO-LOCK:
              END. /**FOR FIRST ld_det**/
              IF AVAIL ld_det THEN
              DO:
                 m_recid = RECID(ld_det).
                 RUN LOC-DET-VALIDATIONS IN THIS-PROCEDURE
                     (INPUT m_recid , OUTPUT m_error).
              END. /**IF AVAIL ld_det THEN**/
              ELSE DO:
                  /* MK01 >> */
                  FOR FIRST ld_det
                          FIELDS(ld__chr01 ld_qty_oh)
                          WHERE ld_domain   = GLOBAL_domain
                            AND ld_part     = m_part
                            AND ld_lot      = m_syslot
                            AND ld_site     = m_site
                            AND ld_loc      = m_loc
                            AND ld_ref      = ""
                           /*  AND TRUNCATE(ld_qty_oh , 3) = 0 */
                            AND ld_stat     = "NNN" NO-LOCK:
                      END. /**FOR FIRST ld_det**/

                    IF AVAIL ld_det THEN
                        MESSAGE m_mesdesc[42].
                    ELSE
                    /* << MK01 */
                        MESSAGE m_mesdesc[15].
/*davidw:1959*/     RUN sendbell  IN THIS-PROCEDURE.
                    m_error = YES.
              END. /**ELSE DO:**/
              IF m_error THEN
                 RETURN.

          END. /**IF m_option BEGINS "DOREC" THEN**/
          ELSE DO:
              /* FOR FIRST tr_hist  */ /* Nilay Dasondi 07 Dec 2010 */ /* ND071110 */
              FOR LAST tr_hist /* Nilay Dasondi 07 Dec 2010 */         /* ND071110 */
                FIELDS(tr_serial tr_part tr_site tr_loc tr_ref tr_nbr tr_lot tr__chr13)
                WHERE tr_domain = GLOBAL_domain
                  AND tr_serial = m_lot
                  AND tr_qty_loc /*<>*20121227151806*/ > 0
                  USE-INDEX tr_serial NO-LOCK:
                ASSIGN m_syslot = tr_serial
                       m_site   = tr_site
                       m_part   = tr_part
                       m_nbr    = tr_nbr
                       /*m_line   = tr_lot*/
                       m_line = tr__chr13.
                END. /**FOR LAST tr_hist **/
            IF NOT AVAIL tr_hist THEN
            DO:
                /* FOR FIRST tr_hist  */ /* Nilay Dasondi 07 Dec 2010 */ /* ND071110 */
                FOR LAST tr_hist /* Nilay Dasondi 07 Dec 2010 */         /* ND071110 */
                   FIELDS(tr_serial tr_part tr_site tr_loc tr_ref tr_nbr tr_lot tr__chr13)
                   WHERE tr_domain = GLOBAL_domain
                     AND tr_serial BEGINS m_lot
                     AND tr_qty_loc /*<>20121227151806*/ > 0
                     USE-INDEX tr_serial NO-LOCK:
                   ASSIGN m_syslot = tr_serial
                          m_site   = tr_site
                          m_part   = tr_part
                          m_nbr    = tr_nbr
                          /*m_line   = tr_lot*/
                          m_line = tr__chr13.
               END. /**FOR LAST tr_hist **/
            END. /**IF NOT AVAIL tr_hist THEN**/
            IF NOT AVAIL tr_hist THEN
            DO :

                m_error = YES.
               MESSAGE m_mesdesc[3].
/*davidw:1959*/  RUN sendbell  IN THIS-PROCEDURE.
            END. /**ELSE DO : **/

            IF m_error THEN
               RETURN.

            IF m_part <> "" THEN
            DO:
                FOR FIRST ld_det
                   FIELDS(ld__chr01 ld_lot ld_ref ld_loc ld_site ld__chr02  ld_status )    /* sat140611 */
                   WHERE ld_domain   = GLOBAL_domain
                     AND ld_part     = m_part
                     AND (ld_lot      = m_syslot OR ld_lot BEGINS m_lot)    /* sat140611 */
                     AND ((ld_ref     <> "" AND
                           (m_option = "Depalletize" OR
                            m_option BEGINS "CYC" OR
                            m_option BEGINS "PHY" OR
                            m_option BEGINS "PALLETIZE" ))
                          OR
                          (ld_ref     =  "" AND m_option <> "Depalletize"))
                     AND TRUNCATE(ld_qty_oh , 3) <> 0 NO-LOCK:
               END. /**FOR FIRST ld_det**/
               IF AVAIL ld_det THEN
               DO:
                    ASSIGN m_recid = RECID(ld_det)
                         m_loc    = ld_loc
                         m_ref    = ld_ref
                         m_site   = ld_site
                         m_syslot = ld_lot.      /* sat140611 */
                  IF m_option BEGINS "PALLETIZE" THEN
                     m_nbr   = ld__chr01.


                  /* Lee Li added 05/24/10  20100414164007  */

                  IF m_option BEGINS "SODOLINK-LOT" AND ld_status = "TRANSIT" THEN
                  DO:
                     MESSAGE "The lot have been shipped by DO : " +  m_nbr .
                     RUN sendbell  IN THIS-PROCEDURE.
                     m_error = YES.
                  END. /**CHECK FOR DO already ship by old do */


                  /* Lee Li added 05/24/10  20100414164007  */


                  IF m_option BEGINS "SODOLINK-LOT" AND ld__chr01 <> "" THEN
                  DO:

                    MESSAGE m_mesdesc[33].
/*davidw:1959*/  RUN sendbell  IN THIS-PROCEDURE.
                    m_error = YES.
                  END. /**CHECK FOR ALREDY LINK LOT*/
                  ELSE IF (m_option BEGINS "SODODELINK-LOT"  OR
                           m_option BEGINS "SODOSHIP-LOT" ) /* AND ld__chr01 = "" maha05122010*/
                  THEN DO:
                      IF ld__chr01 = "" THEN
                      DO:

                      MESSAGE m_mesdesc[34].
/*davidw:1959*/       RUN sendbell  IN THIS-PROCEDURE.
                      m_error = YES.
                      END.
                      IF ld__chr02 <> "" THEN
                      DO:
                          MESSAGE m_mesdesc[35].
                          RUN sendbell  IN THIS-PROCEDURE.
                          m_error = YES.

                      END.
                  END. /**DELINK ONLY FOR LINK LOTS**/
                  ELSE IF m_option BEGINS "SODOSHIP-LOT" AND ld__chr01 <> ""
                  AND ld__chr02 <> ""
                  THEN DO:

                    MESSAGE m_mesdesc[35].
/*davidw:1959*/     RUN sendbell  IN THIS-PROCEDURE.
                    m_error = YES.
                  END. /**DELINK ONLY FOR LINK LOTS**/

                  IF m_error THEN
                     RETURN.

                  RUN LOC-DET-VALIDATIONS IN THIS-PROCEDURE
                      (INPUT m_recid , OUTPUT m_error).
               END. /**IF AVAIL ld_det THEN**/
               ELSE DO:

                 IF NOT (m_option BEGINS "CYC" OR
                         m_option BEGINS "PHY") THEN
                 DO:
                     /* MK01 >> */
                     FOR FIRST ld_det
                           /* FIELDS(ld__chr01 ld_ref ld_loc ld_site ld__chr02  ld_status ) */
                           WHERE ld_domain   = GLOBAL_domain
                             AND ld_part     = m_part
                             AND ld_lot      = m_syslot
                            /* AND ((ld_ref     <> "" AND
                                   (m_option = "Depalletize" OR
                                    m_option BEGINS "CYC" OR
                                    m_option BEGINS "PHY" OR
                                    m_option BEGINS "PALLETIZE" ))
                                  OR
                                  (ld_ref     =  "" AND m_option <> "Depalletize"))
                             AND TRUNCATE(ld_qty_oh , 3) = 0 */
                             AND ld_stat = "NNN" NO-LOCK:
                       END. /**FOR FIRST ld_det**/

                       IF AVAIL ld_det THEN
                           MESSAGE m_mesdesc[42].
                       ELSE
                        /* << MK01 */
                           MESSAGE m_mesdesc[15].

/*davidw:1959*/      RUN sendbell  IN THIS-PROCEDURE.
                     m_error = YES.
                     RETURN.
                 END. /**IF NOT m_option BEGINS "CYC" THEN**/
                 ELSE DO:
                    FOR LAST tr_hist
                        FIELDS(tr_site tr_loc)
                        WHERE tr_domain = GLOBAL_domain
                          AND tr_serial = m_syslot
                          AND tr_qty_loc <> 0 USE-INDEX tr_serial NO-LOCK:
                       ASSIGN m_loc    = tr_loc
                              m_site   = tr_site.
                    END. /**FOR LAST tr_hist**/
                 END. /**ELSE DO:**/
               END. /**ELSE DO:**/

            END. /**IF m_part <> "" THEN**/

            IF m_error THEN
               RETURN.

          END. /**ELSE DO:**/

       END.  /**IF m_lot <> "" THEN**/
       ELSE IF m_ref <> "" THEN
       DO:
           FOR EACH ld_det
               FIELDS(ld_part ld_site ld_loc ld__chr01)
               WHERE ld_domain   = GLOBAL_domain
                 AND ld_ref      = m_ref
                 AND TRUNCATE(ld_qty_oh , 3) <> 0  NO-LOCK:
              ASSIGN m_recid = RECID(ld_det)
                     m_part  = ld_part
                     m_site  = ld_site
                     m_loc   = ld_loc.
               RUN LOC-DET-VALIDATIONS IN THIS-PROCEDURE
                   (INPUT m_recid , OUTPUT m_error).
              IF m_error THEN
                 LEAVE.
           END. /**FOR FIRST ld_det**/
       END. /**ELSE IF m_ref <> "" THEN**/
   END. /**ELSE DO**/

   RUN OTHER-VALIDATION IN THIS-PROCEDURE.

END. /**END PROCEDURE GET-ITEM-FROM-LOT**/

PROCEDURE LOC-DET-VALIDATIONS:
   DEFINE INPUT  PARAMETER m_recid AS RECID.
   DEFINE OUTPUT PARAMETER m_error LIKE mfc_logical.
    FOR FIRST icc_ctrl
        FIELDS(icc_iss_days)
        WHERE icc_domain = GLOBAL_domain NO-LOCK :
    END. /**FOR FIRST icc_ctrl**/
    IF NOT AVAIL icc_ctrl THEN
       RETURN.

   FOR FIRST ld_det
       FIELDS(ld_status ld_expire ld__chr01 ld__chr02 ld_site ld_loc ld_lot)
       WHERE RECID(ld_det) = m_recid NO-LOCK :
   END. /**FOR FIRST ld_det**/

   IF AVAIL ld_det THEN
   DO:
       IF CAN-FIND(FIRST IS_mstr NO-LOCK
                   WHERE IS_domain  = GLOBAL_domain
                     AND IS_status  = ld_status
                     AND is_avail   = NO ) AND
          NOT(m_option BEGINS "TRANS" OR
              m_option BEGINS "CYC"   OR
              m_option BEGINS "PHY"   OR
              m_option BEGINS "PALLETIZE" OR
              m_option BEGINS "DEPALLETIZE" ) THEN
       DO:
         {pxmsg.i &MSGNUM=9228 &ERRORLEVEL=3 &MSGARG1=ld_status}
          m_error = YES.
       END. /**ERROR: INVENTORY STATUS NOT AVAILABLE**/

       IF NOT(m_option BEGINS "TRANS-BYPALLET" OR
              m_option BEGINS "SODO") THEN
       DO:
           DO m_count = 1 TO NUM-ENTRIES(m_trtype) :
              FOR FIRST isd_det
                  FIELDS(isd_status)
                    WHERE isd_domain  = GLOBAL_domain
                      AND isd_status  = ld_status
                      AND isd_tr_type = ENTRY(m_count , m_trtype)
                      NO-LOCK:
             END. /**FOR FIRST isd_det**/
              IF AVAILABLE isd_det THEN
              DO:
                 {pxmsg.i &MSGNUM=9228 &ERRORLEVEL=3 &MSGARG1=isd_status}
                 m_error = YES.
                 LEAVE.
              END. /**IF AVAILABLE isd_det THEN**/

           END. /**DO m_count**/

       END. /**IF NOT m_option BEGINS "TRANS-BYPALLET" THEN**/

       IF ld_expire < TODAY + icc_iss_days
         AND m_option BEGINS "SODO"
       THEN DO:
          {pxmsg.i &MSGNUM=9212 &ERRORLEVEL=3}
           m_error = YES.
       END.

       IF (ld__chr01 = "" AND ld__chr02 = ""  AND
          m_option BEGINS "TRANS" ) OR
          (ld__chr02 = "" AND
          m_option BEGINS "PALLETIZE" ) OR
         (ld__chr01 <> "" AND ld__chr02 = ""  AND
          m_option BEGINS "SHIPPER" ) OR
         (ld__chr02 = ""  AND
          m_option BEGINS "DEPALLETIZE" ) OR
         (ld__chr01 = "" AND ld__chr02 = ""  AND
          m_option BEGINS "SODOLINK" ) OR
         (ld__chr01 <> "" AND ld__chr02 = ""  AND
          m_option BEGINS "SODODELINK" ) OR
         (ld__chr01 <> "" AND ld__chr02 = ""  AND
          m_option BEGINS "SODOSHIP" ) OR
         (ld__chr01 = "" AND ld__chr02 = ""  AND
          m_option BEGINS "DOREC" )    OR
         (ld__chr01 <> "" AND ld__chr02 = ""  AND
          m_option BEGINS "SHIPPERCREATE" ) THEN
         ASSIGN m_site    = ld_site
                m_loc     = ld_loc.

       IF NOT m_option BEGINS "PALLETIZE"
               AND ld_lot <> "" /*linas20121228113029 */

       THEN
       DO:
          m_maxtrnbr = 0.  /**Jack Li**/
          FOR /*LAST*/ EACH tr_hist
              FIELDS(tr_nbr tr_lot tr_trnbr)
              WHERE tr_domain = GLOBAL_domain
                AND tr_serial = ld_lot
                AND tr_type   = "RCT-GIT"
                AND tr_qty_loc <> 0 USE-INDEX tr_serial NO-LOCK:
             IF m_maxtrnbr < tr_trnbr THEN DO: /**Jack Li**/
                ASSIGN m_nbr   = tr_nbr
                       m_line  = tr_lot
                       m_maxtrnbr = tr_trnbr. /**Jack Li**/
             END.
          END. /**FOR LAST tr_hist**/

          FOR FIRST dsd_det
              FIELDS(dsd_loc)
              WHERE dsd_domain  = GLOBAL_domain
                AND dsd_req_nbr = m_line NO-LOCK:
          END. /**FOR FIRST dsd_det**/
          IF AVAIL dsd_det THEN
             m_loc1 = dsd_loc.
          ELSE m_nbr = "".
       END. /**IF NOT m_option BEGINS "PALLETIZE" THEN**/
   END. /**AVAIL ld_det**/

END. /**LOC-DEL-VALIDATIONS**/

PROCEDURE LOC-DET-EXP-VALIDATION:
  FOR FIRST icc_ctrl
      FIELDS(icc_iss_days)
      WHERE icc_domain = GLOBAL_domain NO-LOCK :
  END. /**FOR FIRST icc_ctrl**/
  IF NOT AVAIL icc_ctrl THEN
     RETURN.

  FOR FIRST ld_det
      FIELDS(ld_status ld_expire ld__chr01)
      WHERE RECID(ld_det) = m_recid NO-LOCK:
  END. /**FOR FIRST ld_det **/
  IF AVAIL ld_det THEN
  DO:

      DO m_count = 1 TO NUM-ENTRIES(m_trtype) :
       FOR FIRST isd_det
           FIELDS(isd_status)
           WHERE isd_domain  = GLOBAL_domain
             AND isd_status  = ld_status
             AND isd_tr_type = ENTRY(m_count , m_trtype)NO-LOCK:
       END. /**FOR FIRST isd_det **/
       IF AVAILABLE isd_det THEN
       DO:

           {pxmsg.i &MSGNUM=9228 &ERRORLEVEL=3 &MSGARG1=isd_status}
          m_error = YES.
          LEAVE.
       END. /**IF AVAILABLE isd_det THEN**/

     END. /**DO m_count**/

     IF ld_expire < TODAY + icc_iss_days
        AND m_option BEGINS "SODOSHIP"
     THEN DO:
        {pxmsg.i &MSGNUM=9212 &ERRORLEVEL=3}
        m_error = YES.
     END. /**EXPIRY CHECK**/
  END. /**IF AVAIL ld_det THEN**/
END.  /**LOC-DET-EXP-VALIDATION**/

PROCEDURE OTHER-VALIDATION:
    IF m_site = "" THEN
    DO:
       MESSAGE m_mesdesc[25].
/*davidw:1959*/  RUN sendbell  IN THIS-PROCEDURE.
       m_error = YES.
    END. /**IF m_site = "" THEN**/

    /* VALIDATE RECEIVING SITE */
    {gprun.i ""gpsiver.p""
             "(input  m_site,
              input  ?,
              output return_int)"}


    IF return_int = 0 THEN
    DO:
       MESSAGE m_mesdesc[17].
/*davidw:1959*/  RUN sendbell  IN THIS-PROCEDURE.
       m_error = YES.
    END. /**IF return_int = 0 THEN**/

    FOR FIRST si_mstr
        FIELDS(si_entity)
        WHERE si_domain = GLOBAL_domain
          AND si_site = m_site NO-LOCK:
    END. /**FOR FIRST si_mstr**/
    IF AVAIL si_mstr THEN
    DO:
      {gpglef01.i  ""IC"" si_entity m_effdate}
    END. /**EACH si_mstr**/

    IF gpglef > 0 THEN
    DO: /* GL period is closed*/
       {pxmsg.i &msgnum=9217 &errorlevel=3}
       m_error = YES.
    END. /* if glperiod is closed  */

    FOR FIRST pt_mstr
        FIELDS(pt_status)
        WHERE pt_domain = GLOBAL_domain
          AND pt_part = m_part NO-LOCK:
    END. /**FOR FIRST pt_mstr**/
    IF AVAILABLE pt_mstr THEN DO:
       DO m_count = 1 TO NUM-ENTRIES(m_trtype) :
           FOR FIRST isd_det
               FIELDS(isd_status)
                WHERE isd_domain  = GLOBAL_domain
                  AND isd_status  = STRING(pt_status,"x(8)") + "#"
                  AND isd_tr_type = ENTRY(m_count , m_trtype) NO-LOCK:
           END. /**FOR FIRST isd_det**/
           IF AVAIL isd_det THEN
           DO:
             /* Restricted Procedure for Item Status code */
             {pxmsg.i &MSGNUM=9228 &ERRORLEVEL=3 &MSGARG1=isd_status}
             m_error = YES.
             LEAVE.
           END. /**ITEM STATUS CHECK**/
       END. /**DO m_count**/

    END. /* available pt_mstr */
END. /**PROCEDURE OTHER-VALIDATION**/

PROCEDURE LOC-STAT-VALIDATION:
   FOR FIRST loc_mstr
       FIELDS(loc_status)
        WHERE loc_domain = GLOBAL_domain
          AND loc_site   = m_site
          AND loc_loc    = m_loc1 NO-LOCK:
   END. /**FOR FIRST loc_mstr**/
   IF AVAIL loc_mstr THEN
   DO:
     DO m_count = 1 TO NUM-ENTRIES(m_trtype) :
       FOR FIRST isd_det
           FIELDS(isd_status)
            WHERE isd_domain  = GLOBAL_domain
              AND isd_status  = loc_status
              AND isd_tr_type = ENTRY(m_count , m_trtype)NO-LOCK:
       END. /**FOR FIRST isd_det**/
       IF AVAILABLE isd_det THEN
       DO:
          {pxmsg.i &MSGNUM=9228 &ERRORLEVEL=3 &MSGARG1=isd_status}
          m_error = YES.
          LEAVE.
       END. /**IF AVAILABLE isd_det THEN**/

     END. /**DO m_count**/
   END. /**IF AVAIL loc_mstr THEN**/
END. /**LOC-STAT-RESTRICTION**/

PROCEDURE PENDINGINVOICE-CIM:
    m_yn = NO.
    {pxmsg.i &msgnum=32 &errorlevel=1 &confirm=m_yn}

    IF m_yn THEN
    DO:
      CIMBLOCK:
      DO TRANSACTION:

        OUTPUT TO VALUE(m_cimfile).
        FOR EACH tt1_det
            WHERE tt1_qtyiss <> 0
              AND tt1_cust  <> ""
            BREAK BY tt1_cust BY tt1_channel :

          FOR FIRST cm_mstr
              FIELDS(cm_curr cm_slspsn)
              WHERE cm_domain  = GLOBAL_domain
                AND cm_addr    = tt1_cust NO-LOCK,
              FIRST ad_mstr where ad_domain = cm_domain
                    and cm_addr = ad_addr   no-lock  :
          END. /**FOR FIRST cm_mstr**/
          IF AVAIL cm_mstr THEN
          DO:

            IF FIRST-OF(tt1_channel) THEN
            DO:
              m_nbr = "".
              FOR FIRST CODE_mstr
                  FIELDS(CODE_cmmt)
                  WHERE CODE_domain  = GLOBAL_domain
                    AND CODE_fldname = "xx_soret_nbr"
                    AND CODE_value   = "nrm" NO-LOCK :
              END. /**FOR FIRST CODE_mstr**/
              IF AVAIL CODE_mstr THEN
              DO :
                 /*maha18112010 duplicate lot issue fix */
                 prompt_lot:
                 do on endkey undo prompt_lot, leave prompt_lot: /*maha18112010 duplicate lot issue fix */
                  {gprun.i ""gpnrmgv.p""
                  "(code_cmmt,
                    input-output m_nbr ,
                    output errorst,
                    output errornum)" }
                     /*maha18112010 duplicate lot issue fix */
                     IF errorst THEN
                      DO:
                         {pxmsg.i &MSGNUM=errornum &ERRORLEVEL=3 }
                         undo prompt_lot, retry prompt_lot.
                      END.
                      /*maha18112010 duplicate lot issue fix */
                     end.  /* prompt_blk */
              END. /**IF AVAIL CODE_mstr THEN**/

              PUT UNFORMATTED
                 '"' m_nbr  '"'                     /**Order Number**/
                 SKIP
                 '"' tt1_cust '"'                   /**SOLD-TO**/
                 SKIP(2)
                 " - - - - - "
                 '"' tt1_nbr     '"'                /**PO**/
                 " - - - "
                 '"' tt1_site    '" '               /**SITE**/
                 '"' tt1_channel '" '               /**CHANNEL**/
                 " - - "
                 '"' tt1_curr '" '                  /*Jack Li***/
                 SKIP.

        /**   IF cm_curr <> base_curr THEN    **Jackl*/
              IF tt1_curr <> base_curr THEN  /**Jack Li*/
                 PUT "-"
                     SKIP.

              PUT UNFORMATTED
                  "-"
                  SKIP
                  "- yes - - - - - - - - - no"
                  SKIP(1).
            END. /**IF FIRST-OF(tt1_cust) THEN**/

           PUT UNFORMATTED
               "-"
               SKIP
               '"' tt1_part   '"'                 /**ITEM NUMBER**/
               SKIP(1)
               -1 * tt1_qtyiss .                    /**INVOICE QTY**/
/*davidw:1440*/ if m_return_oldprice and (tt1_price <> 0) then
                   PUT UNFORMATTED skip(1) tt1_price skip(1).
/*davidw:1440*/ ELSE PUT UNFORMATTED SKIP(3).
/*davidw:1440*/ PUT UNFORMATTED
               '"' tt1_loc    '" '                /**LOCATION**/
               '"' tt1_syslot '" '                /**LOT**/
               " - ".

            m_count = 0.

            IF cm_slspsn[1] <> "" THEN
               m_count =  m_count + 1.
            IF cm_slspsn[2] <> "" THEN
               m_count =  m_count + 1.
            IF cm_slspsn[3] <> "" THEN
               m_count =  m_count + 1.
            IF cm_slspsn[4] <> "" THEN
               m_count =  m_count + 1.

            IF m_count > 0 THEN
               PUT " - ".

            PUT " - - - - - - - - - - - - - - ".

            PUT '"' tt1_rsncd '"'  /**CATEGORY**/
                " - - - no"
                SKIP.

            IF m_count > 1 THEN
               PUT "-"
                   SKIP.

            FOR FIRST pt_mstr
                FIELDS(pt_taxable)
                 WHERE pt_domain  = GLOBAL_domain
                   AND pt_part    = tt1_part NO-LOCK:
            END. /**FOR FIRST pt_mstr**/
            IF AVAIL pt_mstr THEN
            DO:
               IF pt_taxable
                  /* Lee Li added 20100528112030 */
                  and ad_taxable
                  /* Lee Li added 20100528112030 */
                      THEN
                do:
                  PUT "-"
                      SKIP.
                end.
            END. /**IF AVAIL pt_mstr THEN**/
          END. /**IF AVAIL cm_mstr THEN**/

          IF LAST-OF(tt1_channel) THEN
            PUT "."
                SKIP
                "."
                SKIP(1)
                " - - - - - - no"
                SKIP.
        END. /**EACH tt1_det**/
        PUT "."
            SKIP.
        OUTPUT CLOSE.

        /*LOAD CIM FILE*/
        run proc_loadcimfile in this-procedure.
        IF NOT m_cimerr THEN DO:
/*davidw add return no */
         message "Sales Return No:" m_nbr.
/*davidw:1959*/  RUN sendbell  IN THIS-PROCEDURE.
          /*CIM Load sucessful*/
         {pxmsg.i &msgnum=9101 &errorlevel=1}

         {gpfildel.i &filename=m_cimfile}
         {gpfildel.i &filename=m_outfile}
         {gpfildel.i &filename=m_errfile}

        END. /*IF NOT m_cimerr*/
        ELSE DO:
          /*CIM Load error*/
         {pxmsg.i &msgnum=9102 &errorlevel=1}
             /**
         {gpfildel.i &filename=m_cimfile}   **/
          UNDO CIMBLOCK, LEAVE CIMBLOCK.
        END. /*Else NOT m_cimerr*/
      END. /**END TRANSACTION**/

    END. /**IF m_yn THEN**/
END. /**PENDINGINVOICE-CIM:**/

PROCEDURE STOCK-TRANSFER-CIM:
    m_yn = NO.
    {pxmsg.i &msgnum=32 &errorlevel=1 &confirm=m_yn}

    IF m_yn THEN
    DO:
      CIMBLOCK:
      DO TRANSACTION:

        OUTPUT TO VALUE(m_cimfile).
        FOR EACH tt1_det
            WHERE tt1_qtyiss <> 0
              AND (tt1_loc1  <> tt1_loc OR
                   tt1_ref1  <> tt1_ref ):

            PUT UNFORMATTED
               '"' tt1_part '"'                 /**ITEM NUMBER**/
               SKIP
               tt1_qtyiss                        /**QUANTITY**/
               SPACE(1)
               m_effdate                        /**EFFECTIVE DATE**/
               " - - - "
               SKIP(1)
               '"' tt1_site   '" '              /**FROM SITE**/
               '"' tt1_loc    '" '              /**FROM LOC**/
               '"' tt1_syslot '" '              /**FROM LOT**/
               '"' tt1_ref    '" '              /**FROM REF**/
               SKIP
               '"' tt1_site       '" '          /**TO SITE**/
               '"' tt1_loc1       '" '          /**TO LOC**/
               '"' tt1_syslot     '" '          /**TO LOT**/
               '"' tt1_ref1       '" '          /**TO REF**/
               SKIP
               "."
               SKIP.

        END. /**EACH tt1_det**/
        PUT "."
            SKIP.
        OUTPUT CLOSE.

        /*LOAD CIM FILE*/
        run proc_loadcimfile in this-procedure.
        IF NOT m_cimerr THEN DO:

          FOR EACH tt1_det
              WHERE tt1_nbr     <> ""
                AND tt1_dataset <> "":
            FOR FIRST ld_det
                FIELDS(ld_qty_oh ld__chr01)
                 WHERE ld_domain  = GLOBAL_domain
                   AND ld_part    = tt1_part
                   AND ld_site    = tt1_site
                   AND ld_loc     = tt1_loc
                   AND ld_lot     = tt1_syslot
                   AND ld_ref     = tt1_ref :
            END. /**FOR FIRST ld_det**/
            IF AVAIL ld_det THEN
            DO:

              FOR FIRST lad_det
                  FIELDS(lad_qty_all)
                   WHERE lad_domain  = GLOBAL_domain
                     AND lad_dataset = tt1_dataset
                     AND lad_nbr     =
                     (IF tt1_dataset = "sod_det" THEN tt1_nbr
                      ELSE tt1_line)
                     AND lad_line    =
                    (IF tt1_dataset = "sod_det" THEN tt1_line
                    ELSE tt1_recsite)
                     AND lad_site    = tt1_site
                     AND lad_loc     = tt1_loc
                     AND lad_part    = tt1_part
                     AND lad_lot     = tt1_syslot
                     AND lad_ref     = tt1_ref :
              END. /**FOR FIRST lad_det**/
              IF AVAIL lad_det THEN
                 DELETE lad_det.
              ASSIGN ld__chr01  = ""
                     ld_qty_all = 0
                     ld__chr04 = "". /* MK01122010 */

              IF ld_qty_oh = 0 THEN
                 DELETE ld_det.
            END. /**AVAIL ld_det**/

            FOR FIRST ld_det
                FIELDS(ld_qty_oh ld_qty_all ld__chr01)
                 WHERE ld_domain  = GLOBAL_domain
                   AND ld_part    = tt1_part
                   AND ld_site    = tt1_site
                   AND ld_loc     = tt1_loc1
                   AND ld_lot     = tt1_syslot
                   AND ld_ref     = tt1_ref1 :
            END. /**FOR FIRST ld_det**/

            IF AVAIL ld_det THEN
            DO:
               ASSIGN ld_qty_all  = ld_qty_oh
                      ld__chr01   = tt1_nbr.

               IF tt1_dataset = "sod_det" THEN ASSIGN ld__chr04 = tt1_line. /* MK01122010 */


              {xxqtylim.i ld_qty_all}
               FOR FIRST lad_det
                   FIELDS(lad_domain lad_dataset lad_nbr lad_line lad_site
                          lad_loc lad_part lad_lot lad_ref lad_qty_all
                          lad_ord_site)
                    WHERE lad_domain  = GLOBAL_domain
                      AND lad_dataset = tt1_dataset
                      AND lad_nbr     =
                      (IF tt1_dataset = "sod_det" THEN tt1_nbr
                       ELSE tt1_line)
                      AND lad_line    =
                     (IF tt1_dataset = "sod_det" THEN tt1_line
                     ELSE tt1_recsite)
                      AND lad_site    = tt1_site
                      AND lad_loc     = tt1_loc1
                      AND lad_part    = tt1_part
                      AND lad_lot     = tt1_syslot
                      AND lad_ref     = tt1_ref1 :
               END. /**FOR FIRST lad_det**/
               IF NOT AVAIL lad_det THEN
               DO:
                  CREATE lad_det.
                  ASSIGN lad_domain  = GLOBAL_domain
                         lad_dataset = tt1_dataset
                         lad_nbr     = (IF tt1_dataset = "sod_det" THEN tt1_nbr
                                       ELSE tt1_line)
                         lad_line    = (IF tt1_dataset = "sod_det" THEN tt1_line
                                        ELSE tt1_recsite)
                         lad_site    = tt1_site
                         lad_loc     = tt1_loc1
                         lad_part    = tt1_part
                         lad_lot     = tt1_syslot
                         lad_ref     = tt1_ref1.
               END. /**IF NOT AVAIL lad_det THEN**/
               ASSIGN lad_qty_all    = ld_qty_oh
                      lad_ord_site   = tt1_site.

               {xxqtylim.i lad_qty_all}
            END. /**AVAIL ld_det**/

         END. /**EACH tt1_det**/

          /*CIM Load sucessful*/
         {pxmsg.i &msgnum=9101 &errorlevel=1}
         {gpfildel.i &filename=m_cimfile}
         {gpfildel.i &filename=m_outfile}
         {gpfildel.i &filename=m_errfile}
        END. /*IF NOT m_cimerr*/
        ELSE DO:
          /*CIM Load error*/
         {pxmsg.i &msgnum=9102 &errorlevel=1}
             /**
         {gpfildel.i &filename=m_cimfile}   **/
          UNDO CIMBLOCK, LEAVE CIMBLOCK.
        END. /*Else NOT m_cimerr*/
      END. /**END TRANSACTION**/
      RELEASE lad_det.
      RELEASE ld_det.
    END. /**IF m_yn THEN**/
END. /**PROCEDURE STOCK-TRANSFER-CIM**/

/***Jack Li *****BEGIN ADD****ECO:20110307095617*/
PROCEDURE GET-ORDER-DETAILS2:
    DEFINE INPUT  PARAMETER m_nbr       LIKE lad_nbr.
    DEFINE INPUT  PARAMETER m_part      LIKE ld_part.
/*  DEFINE INPUT  PARAMETER m_line      LIKE lad_line. *linas42955*/
    DEFINE INPUT-OUTPUT  PARAMETER m_line      LIKE lad_line. /*linas42955*/
    DEFINE OUTPUT PARAMETER m_dataset   LIKE lad_dataset.
    DEFINE OUTPUT PARAMETER m_qtyopn    LIKE sod_qty_ord.
    DEFINE OUTPUT PARAMETER m_cust      LIKE so_cust.
    DEFINE OUTPUT PARAMETER m_recsite   LIKE dss_rec_site.
    DEFINE OUTPUT PARAMETER m_qtyall    LIKE sod_qty_all.
    DEFINE OUTPUT PARAMETER mm_soum      LIKE sod_um.
    DEFINE OUTPUT PARAMETER mm_um_conv   LIKE sod_um_conv.
    DEFINE OUTPUT PARAMETER m_chr01_b      LIKE sod__chr01. /*linas42955*/
 
    m_chr01_b = "".  /*linas42955*/
    FOR FIRST sod_det
              FIELD(sod_line sod_site sod_qty_ord sod_qty_ship sod_qty_all
	      sod__Chr01 /*linas42955*/
              sod_um sod_um_conv)
        WHERE sod_domain = GLOBAL_domain
          AND sod_nbr  = m_nbr
          AND ( sod_line = INT(m_line)
	        or m_line = ""   ) /*linas42955*/
          AND sod_part = m_part
         AND sod_type = "" NO-LOCK:
    END. /**FOR FIRST sod_det**/

    IF AVAIL sod_det THEN DO:
       ASSIGN m_dataset = "sod_det"
              m_recsite = sod_site
              m_qtyall  = sod_qty_all
              mm_soum   = sod_um
                  mm_um_conv = sod_um_conv
                m_qtyopn  = ( sod_qty_ord - sod_qty_ship ) * sod_um_conv
		m_chr01_b = sod__chr01 /*linas42955*/
		m_line  = STRING(sod_line). /*linas42955*/

        FOR FIRST so_mstr
           FIELDS(so_cust so_ship)
            WHERE so_domain = global_domain
              AND so_nbr = m_nbr NO-LOCK:
       END. /**FOR FIRST so_mstr**/
       IF AVAIL so_mstr THEN
          m_cust  = (IF m_option BEGINS "SHIPPERCREATE"
                     THEN so_ship ELSE so_cust).
     END. /**IF AVAIL sod_det THEN**/
     ELSE DO:
          FOR FIRST dss_mstr
              FIELDS(dss_rec_site dss_shipsite)
              WHERE dss_domain = GLOBAL_domain
                AND dss_nbr    = m_nbr NO-LOCK:
          END. /**FOR FIRST dss_mstr**/
          IF AVAIL dss_mstr THEN DO:
             m_dataset = "ds_det".  /*20130130195514*/
             m_recsite = dss_rec_site.
             FOR EACH ds_det
                 FIELDS(ds_part ds_req_nbr ds_qty_conf ds_qty_ship ds_qty_all
		 ds__chr01 ) /*linas42955*/
                 WHERE ds_domain    = GLOBAL_domain
                   AND ds_nbr       = m_nbr
                   AND ds_req_nbr   = m_line
                   AND ds_shipsite  = dss_shipsite
                   AND ds_site      = dss_rec_site NO-LOCK:
                 IF ds_part = m_part THEN DO:
                    ASSIGN m_dataset = "ds_det"
                           m_qtyall  = ds_qty_all
   		           m_chr01_b = ds__chr01 /*linas42955*/
                           m_qtyopn  = ds_qty_conf - ds_qty_ship.
                 END. /**IF ds_part = m_part THEN**/
             END. /**EACH ds_det**/
          END. /**IF AVAIL dss_mstr THEN**/
    END. /**ELSE DO**/
END. /**PROCEDURE GET-ORDER-DETAILS2:**/
/***Jack Li *****END ADDED****ECO:20110307095617*/

PROCEDURE GET-ORDER-DETAILS:
    DEFINE INPUT  PARAMETER m_nbr       LIKE lad_nbr.
    DEFINE INPUT  PARAMETER m_part      LIKE ld_part.
    DEFINE OUTPUT PARAMETER m_line      LIKE lad_line.
    DEFINE OUTPUT PARAMETER m_dataset   LIKE lad_dataset.
    DEFINE OUTPUT PARAMETER m_qtyopn    LIKE sod_qty_ord.
    DEFINE OUTPUT PARAMETER m_cust      LIKE so_cust.
    DEFINE OUTPUT PARAMETER m_recsite   LIKE dss_rec_site.
    DEFINE OUTPUT PARAMETER m_qtyall    LIKE sod_qty_all.
    DEFINE OUTPUT PARAMETER mm_soum      LIKE sod_um.                   /*20090605102535*/
    DEFINE OUTPUT PARAMETER mm_um_conv   LIKE sod_um_conv.              /*20090605102535*/

    /* MK01 >> */
    /* IF m_option BEGINS "SODOLINK-LOT" OR
    m_option BEGINS "SHIPPERCREATE-LOT" THEN /* MK06 - added Shippercreate option */ */ /* Commented By Nilay */
    IF m_option BEGINS "SODOLINK-LOT" OR m_option BEGINS "SHIPPERCREATE-LOT" OR m_option BEGINS "SODOSHIP-LOT"
           OR m_option BEGINS "SODODELINK" OR m_option BEGINS "TRANS-BYLOT"  THEN /* Added By Nilay */ /* sat040311 */
    DO:
        FOR FIRST sod_det
        FIELD(sod_line sod_site sod_qty_ord sod_qty_ship sod_qty_all
                       sod_um sod_um_conv)                                    /*20090605102535*/
        WHERE sod_domain = GLOBAL_domain
          AND sod_nbr  = m_nbr
          AND sod_line = m_soline
          AND sod_part = m_part
          AND sod_type = "" NO-LOCK:
        END. /**FOR FIRST sod_det**/

    END.
    ELSE
    DO:
        /* << MK01 */
        FOR FIRST sod_det
        FIELD(sod_line sod_site sod_qty_ord sod_qty_ship sod_qty_all
                       sod_um sod_um_conv)                                    /*20090605102535*/
        WHERE sod_domain = GLOBAL_domain
          AND sod_nbr  = m_nbr
          AND sod_part = m_part
          AND sod_type = "" NO-LOCK:
        END. /**FOR FIRST sod_det**/
    END. /* ELSE DO - END MK01 */

    IF AVAIL sod_det THEN
    DO:
        ASSIGN m_line    = STRING(sod_line)
              m_dataset = "sod_det"
              m_recsite = sod_site
              m_qtyall  = sod_qty_all
/********     m_qtyopn  = sod_qty_ord - sod_qty_ship.                  ***20090605102535*/
              mm_soum   = sod_um                                        /*20090605102535*/
              mm_um_conv = sod_um_conv                                   /*20090605102535*/
              m_qtyopn  = ( sod_qty_ord - sod_qty_ship ) * sod_um_conv.  /*20090605102535*/
       FOR FIRST so_mstr
           FIELDS(so_cust so_ship)
           WHERE so_domain = global_domain
             AND so_nbr = m_nbr NO-LOCK:
       END. /**FOR FIRST so_mstr**/
       IF AVAIL so_mstr THEN
          m_cust  = (IF m_option BEGINS "SHIPPERCREATE"
                     THEN so_ship ELSE so_cust).
    END. /**IF AVAIL sod_det THEN**/
    ELSE DO:
      FOR FIRST dss_mstr
          FIELDS(dss_rec_site dss_shipsite)
           WHERE dss_domain = GLOBAL_domain
             AND dss_nbr    = m_nbr NO-LOCK:
      END. /**FOR FIRST dss_mstr**/
      IF AVAIL dss_mstr THEN
      DO:
          m_recsite = dss_rec_site.
          FOR EACH ds_det
              FIELDS(ds_part ds_req_nbr ds_qty_conf ds_qty_ship ds_qty_all)
              WHERE ds_domain    = GLOBAL_domain
                AND ds_nbr       = m_nbr
                AND ds_shipsite  = dss_shipsite
                AND ds_site      = dss_rec_site NO-LOCK:
             IF ds_part = m_part THEN
             DO:
                ASSIGN m_line    = ds_req_nbr
                       m_dataset = "ds_det"
                       m_qtyall  = ds_qty_all
                       m_qtyopn  = ds_qty_conf - ds_qty_ship.
             END. /**IF ds_part = m_part THEN**/
          END. /**EACH ds_det**/
      END. /**IF AVAIL dss_mstr THEN**/

    END. /**ELSE DO**/
END. /**END GET-ORDER-DETAILS**/

PROCEDURE GET-PALLET-REF:

    FOR FIRST code_mstr
        FIELDS(CODE_cmmt)
        WHERE CODE_domain  = GLOBAL_domain
          AND code_fldname = "XX_PALLET_REF"
          AND code_value   = "NRMSeq" NO-LOCK:
    END. /**FOR FIRST code_mstr **/
    IF AVAIL code_mstr THEN
    DO:
     /*maha18112010 duplicate lot issue fix */
     prompt_lot:
     do on endkey undo prompt_lot, leave prompt_lot: /*maha18112010 duplicate lot issue fix */
       {gprun.i ""gpnrmgv.p""
               "(code_cmmt,
                 input-output m_ref1 ,
                 output errorst,
                 output errornum)" }
         /*maha18112010 duplicate lot issue fix */
         IF errorst THEN
          DO:
             {pxmsg.i &MSGNUM=errornum &ERRORLEVEL=3 }
             undo prompt_lot, retry prompt_lot.
          END.
          /*maha18112010 duplicate lot issue fix */
     end.  /* prompt_blk */
    END. /**AVAIL code_mstr**/
END. /**END PROCEDURE GET-PALLET-REF**/

PROCEDURE STOCK-ALLOCATION:

    m_yn = NO.
    {pxmsg.i &msgnum=32 &errorlevel=1 &confirm=m_yn}

    IF m_yn THEN
    DO:
      CIMBLOCK:
      DO TRANSACTION:
            FOR EACH tt1_det
            WHERE tt1_nbr     <> ""
              AND tt1_dataset <> "":
            FOR FIRST ld_det
                FIELDS(ld__chr01 ld_qty_oh ld_qty_all)
                 WHERE ld_domain  = GLOBAL_domain
                   AND ld_part    = tt1_part
                   AND ld_site    = tt1_site
                   AND ld_loc     = tt1_loc
                   AND ld_lot     = tt1_syslot
                   AND ld_ref     = tt1_ref :
            END. /**FOR FIRST ld_det**/
            IF AVAIL ld_det THEN
            DO:
               ASSIGN ld_qty_all  = (IF tt1_syslot <> "" THEN ld_qty_oh ELSE
                                      tt1_qtyiss)
                      ld__chr01   = tt1_nbr.

              /* IF m_option = "SODOLINK-LOT" THEN - commented - MK01122010  */
                   ASSIGN ld__chr04 = tt1_line. /* MK22112010 - Store Line no in ld_det */

               {xxqtylim.i ld_qty_all}

               FOR FIRST IN_mstr
                   FIELDS(IN_qty_all)
                    WHERE IN_domain = GLOBAL_domain
                      AND IN_part   = tt1_part
                      AND IN_site   = tt1_site :
               END. /**FOR FIRST IN_mstr**/
               IF AVAIL IN_mstr THEN
                  IN_qty_all = IN_qty_all + ld_qty_all.

               IF tt1_dataset = "sod_det" THEN
               DO:
                 FOR FIRST sod_det
                     FIELDS(sod_qty_all)
                     WHERE sod_domain = GLOBAL_domain
                       AND sod_nbr    = tt1_nbr
                       AND sod_line   = INT(tt1_line)
                       AND sod_type   = "" :
                     sod_qty_all = sod_qty_all +
                                   (IF tt1_syslot <> "" THEN ld_qty_oh
                                    ELSE tt1_qtyiss).
                 END. /**FOR FIRST sod_det**/
               END. /**IF tt1_dataset = "sod_det" THEN**/
               ELSE DO:
                   FOR FIRST ds_det
                       FIELDS(ds_qty_all)
                       WHERE ds_domain   = GLOBAL_domain
                         AND ds_req_nbr  = tt1_line
                         AND ds_site     = tt1_recsite
                         AND ds_shipsite = tt1_site
                         AND ds_nbr      = ld__chr01  :
                       ds_qty_all = ds_qty_all +
                                     (IF tt1_syslot<> "" THEN ld_qty_oh
                                      ELSE tt1_qtyiss).
                   END. /**FOR FIRST sod_det**/
               END. /**ELSE DO:**/

               FOR FIRST lad_det
                   FIELDS(lad_domain lad_nbr lad_line lad_site lad_loc
                          lad_part lad_lot lad_ref lad_qty_all lad_ord_site)
                    WHERE lad_domain  = GLOBAL_domain
                      AND lad_dataset = tt1_dataset
                      AND lad_nbr     =
                      (IF tt1_dataset = "sod_det" THEN tt1_nbr
                       ELSE tt1_line)
                      AND lad_line    =
                     (IF tt1_dataset = "sod_det" THEN tt1_line
                     ELSE tt1_recsite)
                      AND lad_site    = tt1_site
                      AND lad_loc     = tt1_loc
                      AND lad_part    = tt1_part
                      AND lad_lot     = tt1_syslot
                      AND lad_ref     = tt1_ref :
               END. /**FOR FIRST lad_det**/
               IF NOT AVAIL lad_det THEN
               DO:
                  CREATE lad_det.
                  ASSIGN lad_domain  = GLOBAL_domain
                         lad_dataset = tt1_dataset
                         lad_nbr     = (IF tt1_dataset = "sod_det" THEN tt1_nbr
                                       ELSE tt1_line)
                         lad_line    = (IF tt1_dataset = "sod_det" THEN tt1_line
                                        ELSE tt1_recsite)
                         lad_site    = tt1_site
                         lad_loc     = tt1_loc
                         lad_part    = tt1_part
                         lad_lot     = tt1_syslot
                         lad_ref     = tt1_ref.
               END. /**IF NOT AVAIL lad_det THEN**/
               ASSIGN lad_qty_all    = (IF tt1_syslot <> "" THEN ld_qty_oh
                                        ELSE tt1_qtyiss)
                      lad_ord_site   = tt1_site.
               {xxqtylim.i lad_qty_all}

            END. /**AVAIL ld_det**/
        END. /**EACH tt1_det**/
        {pxmsg.i &msgnum=9101 &errorlevel=1}
        /*LOAD CIM FILE*/
      END. /**END TRANSACTION**/
      RELEASE ld_det.
      RELEASE lad_det.
      RELEASE in_mstr.
      RELEASE sod_det.
      RELEASE ds_det.

    END. /**IF m_yn THEN**/
END. /**END STOCK-ALLOCATION**/

PROCEDURE STOCK-DEALLOCATION:

    m_yn = NO.
    {pxmsg.i &msgnum=32 &errorlevel=1 &confirm=m_yn}

    IF m_yn THEN
    DO:
      CIMBLOCK:
      DO TRANSACTION:
        FOR EACH tt1_det
            WHERE tt1_nbr     <> "" :
            FOR FIRST ld_det
                FIELDS(ld__chr01 ld_qty_all)
                 WHERE ld_domain  = GLOBAL_domain
                   AND ld_part    = tt1_part
                   AND ld_site    = tt1_site
                   AND ld_loc     = tt1_loc
                   AND ld_lot     = tt1_syslot
                   AND ld_ref     = tt1_ref
                   AND (ld__chr04 = tt1_line   /*maha05122010 included line*/
  /*20130213114418*/ OR (ld__chr04 = "" AND tt1_dataset = "ds_det")):
            END. /**FOR FIRST ld_det**/
            IF AVAIL ld_det THEN
            DO:
               FOR FIRST IN_mstr
                   FIELDS(IN_qty_all)
                   WHERE IN_domain = GLOBAL_domain
                     AND IN_part   = tt1_part
                     AND IN_site   = tt1_site :
               END. /**FOR FIRST IN_mstr**/
               IF AVAIL IN_mstr THEN
                  in_qty_all = in_qty_all - ld_qty_all.

               IF in_qty_all < 0 THEN
                  in_qty_all = 0.

               IF tt1_dataset = "sod_det" THEN
               DO:
                 FOR FIRST sod_det
                     FIELDS(sod_qty_all)
                     WHERE sod_domain = GLOBAL_domain
                       AND sod_nbr    = tt1_nbr
                       AND sod_line   = INT(tt1_line)
                       AND sod_type   = "" :
                     sod_qty_all = sod_qty_all -
                                   (IF tt1_syslot<> "" THEN ld_qty_all
                                    ELSE tt1_qtyiss).
                 END. /**FOR FIRST sod_det**/
               END. /**IF tt1_dataset = "sod_det" THEN**/
               ELSE DO:
                   FOR FIRST ds_det
                       FIELDS(ds_qty_all)
                       WHERE ds_domain   = GLOBAL_domain
                         AND ds_req_nbr  = tt1_line
                         AND ds_site     = tt1_recsite
                         AND ds_shipsite = tt1_site
                         AND ds_nbr      = ld__chr01  :
                       ds_qty_all = ds_qty_all -
                                     (IF tt1_syslot<> "" THEN ld_qty_all
                                      ELSE tt1_qtyiss).
                   END. /**FOR FIRST sod_det**/
               END. /**ELSE DO:**/

               ASSIGN ld_qty_all  = 0
                      ld__chr01   = ""
                      ld__chr04   = "". /* MK22112010 - Remove Line no also from ld_det */.

               FOR FIRST lad_det
                   FIELDS(lad_qty_all)
                   WHERE lad_domain  = GLOBAL_domain
                     AND lad_dataset = tt1_dataset
                     AND lad_nbr     = (IF tt1_dataset = "sod_det" THEN tt1_nbr
                                        ELSE tt1_line)
                     AND lad_line    = (IF tt1_dataset = "sod_det" THEN tt1_line
                                        ELSE tt1_recsite)
                     AND lad_site    = tt1_site
                     AND lad_loc     = tt1_loc
                     AND lad_part    = tt1_part
                     AND lad_lot     = tt1_syslot
                     AND lad_ref     = tt1_ref :
               END. /**FOR FIRST lad_det**/

               IF AVAIL lad_det THEN
                  DELETE lad_det.

            END. /**AVAIL ld_det**/
        END. /**EACH tt1_det**/
        {pxmsg.i &msgnum=9101 &errorlevel=1}
        /*LOAD CIM FILE*/
      END. /**END TRANSACTION**/
      RELEASE ld_det.
      RELEASE lad_det.
      RELEASE in_mstr.
      RELEASE sod_det.
      RELEASE ds_det.

    END. /**IF m_yn THEN**/
END. /**END STOCK-ALLOCATION**/

PROCEDURE SODOSHIPCIM:
    m_yn = NO.
    {pxmsg.i &msgnum=32 &errorlevel=1 &confirm=m_yn}

  /**Jack Li****ADD BEGIN***ECO:20120706155109*/
    FOR EACH tt1_det NO-LOCK
       WHERE tt1_nbr    <> ""
         AND tt1_qtyiss <> 0
         AND tt1_dataset <> "" :
       FIND FIRST ld_det NO-LOCK WHERE ld_domain = GLOBAL_domain
                                   AND ld_part   = tt1_part
                                   AND ld_site   = tt1_site
                                   AND ld_loc    = tt1_loc
                                   AND ld_lot    = tt1_syslot
                                   AND ABS(ld_qty_oh - tt1_qtyiss) < 0.08
                                   NO-ERROR.
       IF NOT AVAILABLE ld_det THEN DO:
          m_yn = No.
          MESSAGE "ERROR:Lot" tt1_lot "already shipped".
       END. /**IF AVAILABLE ld_det THEN DO**/
    END.
  /**Jack Li****ADDED END***ECO:20120706155109*/

    IF m_yn THEN
    DO:
      CIMBLOCK:
      DO TRANSACTION:
          FOR EACH ttso_det: DELETE ttso_det. END. /*jackl*/
          FOR EACH tt_doc:   DELETE tt_doc. END. /* MK24112010 */

          FOR EACH tt1_det
              WHERE tt1_nbr    <> ""
                AND tt1_qtyiss <> 0
                AND tt1_dataset <> "" :

              FOR FIRST ld_det
                  FIELDS(ld_qty_oh ld__chr01)
                  WHERE ld_domain  = GLOBAL_domain
                    AND ld_part    = tt1_part
                    AND ld_site    = tt1_site
                    AND ld_loc     = tt1_loc
                    AND ld_lot     = tt1_syslot
                    AND ld_ref     = tt1_ref EXCLUSIVE-LOCK:
              END. /**FOR FIRST ld_det**/
              IF AVAIL ld_det THEN
              DO:

                 FOR FIRST lad_det
                     FIELDS(lad_domain lad_dataset lad_nbr lad_line lad_site
                            lad_loc lad_part lad_lot lad_ref lad_qty_all
                            lad_qty_pick lad_ord_site)
                      WHERE lad_domain  = GLOBAL_domain
                        AND lad_dataset = tt1_dataset
               AND lad_nbr     = (IF tt1_dataset = "sod_det" THEN tt1_nbr
                                           ELSE tt1_line)
               AND lad_line    = (IF tt1_dataset = "sod_det" THEN tt1_line
                                           ELSE tt1_recsite)
                        AND lad_site    = tt1_site
                        AND lad_loc     = tt1_loc
                        AND lad_part    = tt1_part
                        AND lad_lot     = tt1_syslot
                        AND lad_ref     = tt1_ref :
                 END. /**FOR FIRST lad_det**/
                 IF NOT AVAIL lad_det THEN
                 DO:
                    CREATE lad_det.
                    ASSIGN lad_domain  = GLOBAL_domain
                           lad_dataset = tt1_dataset
                lad_nbr     = (IF tt1_dataset = "sod_det" THEN tt1_nbr
                                         ELSE tt1_line)
                lad_line    = (IF tt1_dataset = "sod_det" THEN tt1_line
                                         ELSE tt1_recsite)
                           lad_site    = tt1_site
                           lad_loc     = tt1_loc
                           lad_part    = tt1_part
                           lad_lot     = tt1_syslot
                           lad_ref     = tt1_ref.
                 END. /**IF NOT AVAIL lad_det THEN**/
                 ASSIGN lad_qty_all    = 0
/********               lad_qty_pick   = tt1_qtyiss                     **20090819160740**/
                        lad_qty_pick   = min(tt1_qtyiss,ld_qty_oh)     /**20090819160740**/
                        lad_ord_site   = tt1_site.

                 FOR EACH lad_det
                     FIELDS(lad_qty_all lad_qty_pick lad_ord_site)
                      WHERE lad_domain  = GLOBAL_domain
                        AND lad_dataset = tt1_dataset
                 AND lad_nbr     = (IF tt1_dataset = "sod_det" THEN tt1_nbr
                                           ELSE tt1_line)
                 AND lad_line    = (IF tt1_dataset = "sod_det" THEN tt1_line
                                           ELSE tt1_recsite)
                        AND lad_site    = tt1_site
                        AND lad_part    = tt1_part
                        AND lad_lot     BEGINS m_ofcutpref
                        AND lad_qty_all <> 0 :

/*****               ASSIGN lad_qty_pick   = lad_qty_all                  **20090819160740*/
                     ASSIGN lad_qty_pick   = min(lad_qty_all,ld_qty_oh)  /**20090819160740*/
                            lad_qty_all    = 0
                            lad_ord_site   = tt1_site.
                 END. /**EACH lad_det**/

IF NOT ld_lot BEGINS m_ofcutpref THEN                                                /* RS001 */
DO:                                                                                                /* RS001 */
                /*jackl ADD BEGIN *20/11/08*/
                CREATE ttso_det.
                ASSIGN ttso_nbr  = tt1_nbr
                       ttso_date = today
                       ttso_site = tt1_site
                       ttso_part = tt1_part
                       ttso_ref  = ld_ref
                       ttso_lot  = ld_lot
                       ttso_type = "C"
                       ttso_qty  = - ld_qty_all
                       ttso_line = tt1_line .  /* 20110909113649 Jason  Added */
END.                                                                                                /* RS001 */
               if tt1_syslot <> "" then do:
                FOR EACH lddet NO-LOCK
                     WHERE lddet.ld_domain = global_domain
                       AND lddet.ld__chr01 = tt1_nbr
                       AND lddet.ld_part = tt1_part
/***                   AND lddet.ld_lot BEGINS "OA" :           ** 20090522130248 */
                       AND lddet.ld_lot BEGINS m_ofcutpref:     /* 20090522130248 */
                   FIND FIRST ttso_det
                        WHERE ttso_nbr = tt1_nbr
                          AND ttso_lot = lddet.ld_lot
                          AND ttso_type = "T" NO-ERROR.
                   IF NOT AVAIL /*tt5_det */ ttso_det THEN DO:                                /* RS009 Changed the table name from tt5_det to ttso_det */
                      CREATE ttso_det.
                      ASSIGN ttso_nbr  = tt1_nbr
                             ttso_date = today
                             ttso_site = tt1_site
                             ttso_part = tt1_part
                             ttso_ref  = lddet.ld_ref
                             ttso_lot  = lddet.ld_lot
                             ttso_type = "T"
                             ttso_qty  = - lddet.ld_qty_all
                             ttso_line = tt1_line .  /* 20110909113649 Jason  Added */
                   END.
                END.
              end.
                /*jackl ADDED END *20/11/08*/
                 FIND FIRST tt5_det
                      WHERE tt5_nbr = tt1_nbr NO-ERROR.
                 IF NOT AVAIL tt5_det THEN
                 DO:
                    CREATE tt5_det.
                    ASSIGN tt5_nbr     = tt1_nbr
                           tt5_dataset = tt1_dataset.

                    IF tt5_dataset = "sod_det" THEN
                    DO:
                       FOR FIRST so_mstr
                           FIELDS(so_cust)
                            WHERE so_domain = global_domain
                              AND so_nbr = tt5_nbr NO-LOCK:
                       END. /**FOR FIRST so_mstr **/
                       IF AVAIL so_mstr THEN
                          tt5_cust = so_cust.
                    END. /**IF tt5_dataset = "sod_det" THEN**/
                    ELSE DO:
                        FOR FIRST dss_mstr
                            FIELDS(dss_rec_site dss_shipsite)
                            WHERE dss_domain = GLOBAL_domain
                              AND dss_nbr    = tt5_nbr NO-LOCK:
                        END. /**FOR FIRST dss_mstr**/
                        IF AVAIL dss_mstr THEN
                            ASSIGN tt5_cust     = dss_rec_site
                                   tt5_shipsite = dss_shipsite
                                   tt5_recsite  = dss_rec_site.
                    END. /**ELSE DO**/

                 END. /**IF NOT AVAIL tt5_det THEN**/
                 IF tt1_syslot = "" THEN
                    ld_det.ld__chr01 = "".

              END. /**AVAIL ld_det**/
          END. /**EACH tt1_det**/
          /*LOAD CIM FILE*/
          OUTPUT TO VALUE(m_cimfile).
          FOR EACH tt5_det
              WHERE tt5_dataset = "sod_det" :
                 PUT UNFORMATTED
                     '"' tt5_nbr      '" '  /**ORDER**/
                     m_effdate
                     " no yes "
                     SKIP. /* MK01 - Added . at end*/
                 /* 20110704131840 */
                 IF m_option BEGINS "SODOSHIP" AND global_domain = m_domain  THEN
                 DO:
                     IF m_doc = "" THEN
                         PUT UNFORMATTED
                             "-" SKIP.
                     ELSE
                        PUT UNFORMATTED
                           m_doc SKIP.
                 END.
                 /* 20110704131840 */
                /* MK01 >> */
                 IF m_option BEGINS "SODOSHIP" THEN
                 DO:
                    FIND FIRST so_mstr WHERE so_domain = GLOBAL_domain
                                         AND so_nbr    = tt5_nbr
                                         NO-LOCK NO-ERROR.
                    IF AVAIL so_mstr THEN
                    DO:
                        IF so_fr_list <> "" AND so_fr_terms <> "" THEN
                            PUT UNFORMATTED SKIP(1).
                    END.

                 END. /* m_option BEGINS */

                 PUT UNFORMATTED /* << MK01 */
                     "."
                     SKIP
                     "no"
                     SKIP
                     "yes"
                     SKIP(2).
                 /* 20110704131840 */
                 IF global_domain = m_domain THEN
                 DO:
                     PUT UNFORMATTED
                      /*   "no" */
                         SKIP(1).
                 END.
                 /* 20110704131840 */
                 /* MK01 >> */
                 IF m_option BEGINS "SODOSHIP" THEN
                 DO:
                    FIND FIRST so_mstr WHERE so_domain = GLOBAL_domain
                                         AND so_nbr    = tt5_nbr
                                         NO-LOCK NO-ERROR.
                    IF AVAIL so_mstr THEN
                    DO:
                        IF so_fr_list <> "" AND so_fr_terms <> "" THEN
                            PUT UNFORMATTED SKIP(3).
                    END.

                 END. /* m_option BEGINS */
                 /* << MK01 */


          END. /**EACH tt5_det**/
          PUT "."
              SKIP.

          FOR EACH tt5_det
              WHERE tt5_dataset = "ds_det" :

              PUT UNFORMATTED
                  '"' tt5_nbr         '" '  /**ORDER**/
                  '"' tt5_shipsite    '" '  /**SHIPPING SITE**/
                  '"' tt5_recsite     '" '  /**RECEIVING SITE**/
                  m_effdate
                  " no yes "
                  SKIP
                  "."
                  SKIP
                  "no"
                  SKIP
                  "yes"
                  SKIP
                  " - - no"
                  SKIP.
          END. /**EACH tt5_det**/
          PUT "."
              SKIP.

          OUTPUT CLOSE.

          /* MK24112010 >> added - Generate Doc no thru NRM for each Cust and Site of this Shipment */
          FOR FIRST code_mstr
            FIELDS(CODE_cmmt)
            WHERE CODE_domain  = GLOBAL_domain
              AND code_fldname = "XX_DOCNO"
              AND code_value   = "NRMSeq_docno" NO-LOCK :
          END. /**FOR FIRST code_mstr **/
          IF AVAIL code_mstr THEN
          DO:
                FOR EACH tt1_det:
                    FIND FIRST so_mstr WHERE  so_domain = GLOBAL_domain
                           AND so_nbr = tt1_nbr NO-LOCK NO-ERROR.
                    IF AVAIL so_mstr THEN
                    DO:
                        FIND FIRST tt_doc WHERE tt_cust = so_cust
                               AND tt_nbr = so_nbr /*Jack Li*ECO:20110608020155*/
                               AND tt_site = tt1_site NO-LOCK NO-ERROR.
                        IF NOT AVAIL tt_doc THEN
                        DO:
                            /* Generate a Doc No. thru NRM */
                            ASSIGN m_docno = "".
                            {gprun.i ""gpnrmgv.p""
                             "(code_cmmt,
                               input-output m_docno,
                               output errorst,
                               output errornum)" }
                             IF errorst THEN
                             DO:
                                {pxmsg.i &MSGNUM=errornum &ERRORLEVEL=3 }
                             END.
                             ELSE
                             DO:
                                    CREATE tt_doc.
                                    ASSIGN tt_docno = m_docno
                                           tt_cust  = so_cust
                                           tt_nbr   = so_nbr /*Jack Li**ECO*20110608020155*/
                                           tt_site  = tt1_site.
                             END.
                        END. /* NOT AVAIL tt_doc */
                    END. /* AVAIL so_mstr */
                    ELSE
                    DO: /* DO - Distribution Order */
                       FIND FIRST dss_mstr WHERE dss_domain    = GLOBAL_domain
                                              AND dss_nbr      = tt1_nbr
                                              AND dss_shipsite = tt1_site NO-LOCK NO-ERROR.
                       IF AVAIL dss_mstr THEN
                       DO:
                           FIND FIRST tt_doc WHERE tt_site = tt1_site
                                  AND tt_nbr = tt1_nbr /*Jack Li**ECO:20110608020155*/
                                  AND tt_cust = "" NO-LOCK NO-ERROR.
                           IF NOT AVAIL tt_doc THEN
                               DO:
                                /* Generate a Doc No. thru NRM */
                                ASSIGN m_docno = "".
                                {gprun.i ""gpnrmgv.p""
                                 "(code_cmmt,
                                   input-output m_docno,
                                   output errorst,
                                   output errornum)" }
                                 IF errorst THEN
                                 DO:
                                    {pxmsg.i &MSGNUM=errornum &ERRORLEVEL=3 }
                                 END.
                                 ELSE
                                 DO:
                                        CREATE tt_doc.
                                        ASSIGN tt_docno = m_docno
                                               tt_cust  = ""
                                               tt_nbr   = tt1_nbr /*Jack Li**ECO:20110608020155*/
                                               tt_site  = tt1_site.
                                 END.
                            END. /* NOT AVAIL tt_doc */
                       END. /* AVAIL dss_mstr */
                    END.

                END. /* EACH tt1_det */
          END. /**AVAIL code_mstr**/
          /* << MK24112010 */

          run proc_loadcimfile in this-procedure.
            OUTPUT TO VALUE(m_outfile) APPEND. /*linas20120815123419*/
        /***Jack Li*****ADD BEGIN***ECO:20120706155109***/
         for each tt1_det no-lock where tt1_nbr <> ""
                                    AND tt1_qtyiss <> 0
                                    AND tt1_dataset <> "" :
           if tt1_dataset = "sod_det" then do:
              find last tr_hist no-lock where tr_domain = global_domain
                                          and tr_serial = tt1_syslot
                                          and tr_type   = "ISS-SO"
                                          and tr_nbr    = tt1_nbr
                                          and string(tr_line)   = tt1_line
/*linas20120815123419*                    and tr_date   = today no-error. */
/*linas20120815123419*/                   and tr_date   >= today - 1
/*linas20120815123419*/                   use-index tr_serial no-error.
              if not available tr_hist then do:
                 m_cimerr = Yes.
 /*linas20120815123419*/
                 put "tr_hist updated error " tt1_nbr " " tt1_syslot.
                 leave.
              end.
           end.
           else do:
             find last tr_hist no-lock where tr_domain = global_domain
                                         and tr_serial = tt1_syslot
                                         and tr_type   = "ISS-DO"
/*linas20120815123419*                   and tr_nbr    = tt1_line */
/*linas20120815123419*/                  and tr_nbr    = tt1_nbr
                                         and tr_part   = tt1_part
                                         and tr_date   >= today - 1
/*linas20120815123419*/                  use-index tr_serial no-error.
             if not available tr_hist then do:
                m_cimerr = Yes.
 /*linas20120815123419*/
                 put "tr_hist updated error " tt1_nbr " " tt1_syslot.
                leave.
             end.
           end.
         end. /*for each tt1_det no-lock*/
            OUTPUT CLOSE.  /*linas20120815123419*/

        /***Jack Li*****ADDED END***ECO:20120706155109***/
          IF NOT m_cimerr THEN DO:
/*davidw add copy lost reason code begins  */
          FOR EACH tt1_det
              WHERE tt1_nbr <> "" AND tt1_qtyiss <> 0
              AND tt1_dataset = "sod_det"
          break by tt1_nbr by tt1_line :
           if first-of(tt1_line) then do:
              m_rsncode = "".
              find last tr_hist where tr_domain = global_domain
              and tr_type = "ord-so"  and tr_nbr = tt1_nbr
              and tr_line = int(tt1_line)
              and not tr_program begins "xxict"
              use-index tr_type no-lock no-error.
              if avail tr_hist then m_rsncode = tr_rsn_code.
              if m_rsncode <> "" then do:
                 find last tr_hist where tr_domain = global_domain
                 and tr_type = "ord-so"  and tr_nbr = tt1_nbr
                 and tr_line = int(tt1_line) and tr_program begins "xxict"
                 EXCLUSIVE-LOCK NO-ERROR .
                 if avail tr_hist then
                    assign tr_rsn_code = m_rsncode.
              end.
           end.
          end.
/*davidw end */
           /*CIM Load sucessful*/

           {pxmsg.i &msgnum=9101 &errorlevel=1}
          /***Jack Li*****ADD BEGIN***ECO:20120706155109***/
           find first tt_doc no-lock where tt_flag = No no-error.
           if available tt_doc then do:
              FIND first usrw_wkfl no-lock where usrw_domain = global_domain
                     and usrw_key1 begins "E-Alert program"
                     and usrw_key2 begins "xxictrpc.p" no-error.

              IF available usrw_wkfl THEN DO:
                 m_mail = "".
                 do m_ii = 3 to 14:
                    IF usrw_charfld[m_ii] > "" THEN
                       m_mail = m_mail +  usrw_charfld[3] + ",".
                 end.

                IF m_mail > "" THEN DO:
                   ASSIGN m_mail = SUBSTRING(m_mail,1,LENGTH(m_mail) - 1)
                          m_fileper = "'" + m_cimfile + "'" NO-ERROR.

                  IF SEARCH(m_cimfile)  <> ? THEN
                   UNIX SILENT uuencode VALUE(m_fileper) VALUE(m_fileper) | mailx -s '"DD Number Errors CIMFile"' VALUE(m_mail).

                  m_fileper = "'" + m_outfile + "'".
                  IF SEARCH(m_outfile)  <> ? THEN
                     UNIX SILENT uuencode VALUE(m_fileper) VALUE(m_fileper) |
                     mailx -s '"DD Numbern Errors OutFile"' VALUE(m_mail).

                END.
              END.
           end.
          /***Jack Li*****ADDED END***ECO:20120706155109***/


           {gpfildel.i &filename=m_cimfile}
           {gpfildel.i &filename=m_outfile}
           {gpfildel.i &filename=m_errfile}
           RELEASE ld_det.
           RELEASE lad_det.
           RELEASE dsd_det.
           RELEASE mrp_det.

           run DDPRINT in this-procedure.  /*Jack Li*20120706155109*/
          END. /*IF NOT m_cimerr*/
          ELSE DO:
            /*CIM Load error*/

           {pxmsg.i &msgnum=9102 &errorlevel=1}
               /**
           {gpfildel.i &filename=m_cimfile}   **/
            UNDO CIMBLOCK, LEAVE CIMBLOCK.
          END. /*Else NOT m_cimerr*/
      END. /**END TRANSACTION**/
      RELEASE ld_det.
      RELEASE lad_det.
      RELEASE dsd_det.
      RELEASE mrp_det.
      RELEASE nr_mstr.

      IF m_sernbr <> "" THEN DO:
        /***Jack Li*****ADD BEGIN***ECO:20120706155109***/
         find first tt_doc no-lock where tt_flag = Yes no-error.
         if not available tt_doc then next.
        /***Jack Li*****ADDED END***ECO:20120706155109***/

       /* ASSIGN m_docprn = SUBSTRING(m_docprn,1,LENGTH(m_docprn) - 1).*/
        MESSAGE "DOC No: " m_docprn. /*PAUSE*/ .
                /* << MK24112010 */

        PAUSE 0 BEFORE-HIDE.
        {gprun.i ""xxdchpp1.p""}
        HIDE FRAME a NO-PAUSE.
       END.
    END. /**IF m_yn THEN**/
END. /**SODOSHIPCIM**/

PROCEDURE DDPRINT:
      m_sernbr = "".

      FOR EACH tt5_det:
          FIND FIRST tt1_det
               WHERE tt1_nbr = tt5_nbr NO-ERROR.
          IF AVAIL tt1_det THEN
          DO:
          /***Jack Li**DELETE BEGIN***ECO:20120511113853***
            IF NOT CAN-FIND(FIRST lad_det
                      WHERE lad_domain  = GLOBAL_domain
                        AND lad_dataset = tt1_dataset
                        AND lad_nbr     = (IF tt1_dataset = "sod_det"
                                           THEN tt1_nbr
                                           ELSE tt1_line))
            THEN DO:
          ***Jack Li**DELETED END***ECO:20120511113853***/
              IF m_sernbr = "" THEN
                 m_sernbr = tt5_nbr.
              ELSE 
                   IF LOOKUP(tt5_nbr,m_sernbr,"_") = 0 THEN  /*linas35941*/
                     m_sernbr = m_sernbr + "_" + tt5_nbr.
           /* END. /**FOR FIRST lad_det**/ *20120511113853***/
          END. /**IF AVAIL tt1_det THEN**/

      END. /**FOR EACH tt5_det:**/

      IF m_sernbr <> "" THEN
      DO:
         m_sernbr = "ORDONL" + "," + m_sernbr + "," + "ORDONL".

         ASSIGN m_refon   = YES
                m_recid   = ?
                m_printer = NO.

         /* MK24112010 >> */
         ASSIGN m_docprn = "".
         FOR EACH tt_doc
            WHERE tt_flag = Yes:  /*Jack Li 20120706155109*/

         m_sernbr = m_sernbr + "_" + tt_docno. /*linas35941*/

            IF m_docprn = "" THEN
               ASSIGN m_docprn = tt_docno.
            ELSE
               ASSIGN m_docprn = m_docprn + "," + tt_docno.
         END.

       /***Jack Li*****ADD BEGIN***ECO:20120227144052***/
        if m_track = Yes then do:
           m_tmp = mfguser + string(year(today)) + string(month(today),"99") +
                   string(day(today),"99") + string(time). /*20120706155109*/

           for each tt_doc no-lock:
               create usrw_wkfl.
               assign usrw_domain = global_domain
                      usrw_key1 = tt_cust + "," + tt_nbr + "," +
                                  tt_site + "," + tt_docno
                      usrw_key2 = global_userid + string(year(today)) +
                                  string(month(today)) +
                                  string(day(today)) + string(time)
                      usrw_key3 = "tt_doc"
                      usrw_key4 = tt_nbr
                      usrw_key5 = tt_docno
                      usrw_key6 = string(time,"HH:MM:SS")
                      usrw_charfld[1] = m_tmp     /*20120706155109*/
                      usrw_charfld[2] = execname  /*20120706155109*/
                      usrw_logfld[1]  = tt_flag   /*20120706155109*/
                      usrw_datefld[1] = today     /*20120706155109*/
                      usrw_user1 = global_userid no-error.
           end.

           for each ttso_det:
               find first tt_doc no-lock where tt_nbr = ttso_nbr no-error.
               if available tt_doc then
                  ttso_docno = tt_docno. /*20120706155109*/

               create usrw_wkfl.
               assign usrw_domain = global_domain
                      usrw_key1 = ttso_nbr + "," + ttso_line + "," +
                                  ttso_lot
                      usrw_key2 = global_userid + string(year(today)) +
                                  string(month(today)) +
                                  string(day(today)) + string(time)
                      usrw_key3 = "ttso_det"
                      usrw_key4 = ttso_nbr
                      usrw_key5 = ttso_site
                      usrw_key6 = string(time,"HH:MM:SS")
                      usrw_charfld[1] = ttso_part
                      usrw_charfld[2] = ttso_ref
                      usrw_charfld[3] = ttso_lot
                      usrw_charfld[4] = ttso_type
                      usrw_charfld[5] = ttso_line
                      usrw_charfld[6] = ttso_docno  /*20120706155109*/
                      usrw_charfld[7] = execname    /*20120706155109*/
                      usrw_datefld[1] = ttso_date
                      usrw_decfld[1]  = ttso_qty
                      usrw_user1 = global_userid no-error.
           end.
        end.
       /***Jack Li*****ADDED END***ECO:20120227144052***/

     /*  /***Jack Li*****ADD BEGIN***ECO:20120706155109***/
        find first tt_doc no-lock where tt_flag = Yes no-error.
        if not available tt_doc then next.
       /***Jack Li*****ADDED END***ECO:20120706155109***/

        /* ASSIGN m_docprn = SUBSTRING(m_docprn,1,LENGTH(m_docprn) - 1).*/
         MESSAGE "DOC No: " m_docprn. /*PAUSE*/ .
         /* << MK24112010 */

         PAUSE 0 BEFORE-HIDE.
         {gprun.i ""xxdchpp1.p""}
          HIDE FRAME a NO-PAUSE.  */
      END. /**IF m_sernbr <> "" THEN**/
END. /**DDPRINT**/

PROCEDURE DORECCIM:
    m_yn = NO.
    {pxmsg.i &msgnum=32 &errorlevel=1 &confirm=m_yn}

    IF m_yn THEN
    DO:
      CIMBLOCK:
      DO TRANSACTION:

        OUTPUT TO VALUE(m_cimfile).
        FOR EACH tt1_det
            WHERE tt1_qtyiss <> 0
              AND tt1_nbr    <> "" :
            PUT UNFORMATTED
                '"' tt1_site      '" '   /**SITE**/
                '"' tt1_nbr       '" '   /**NUMBER**/
                '"' tt1_shipsite  '" '   /*SOURCE**/
                m_effdate
                " no"
                SKIP
                '"' tt1_part    '" '     /**ITEM**/
                '"' tt1_line    '" '     /**REQUISTION**/
                SKIP
                tt1_qtyiss               /**QUANTITY**/
                ' "' tt1_site    '"'     /**SITE**/
                ' "' tt1_loc1    '"'     /**LOCATION**/
                ' "' tt1_syslot  '"'     /**LOT**/
                ' "' tt1_ref     '" '    /**REFERENCE**/
                SKIP
                "."
                SKIP.

        END. /**EACH tt1_det**/
        PUT "."
            SKIP.
        OUTPUT CLOSE.

        /*LOAD CIM FILE*/
        run proc_loadcimfile in this-procedure.
        IF NOT m_cimerr THEN DO:
          /*CIM Load sucessful*/
         {pxmsg.i &msgnum=9101 &errorlevel=1}
         {gpfildel.i &filename=m_cimfile}
         {gpfildel.i &filename=m_outfile}
         {gpfildel.i &filename=m_errfile}
        END. /*IF NOT m_cimerr*/
        ELSE DO:
          /*CIM Load error*/
         {pxmsg.i &msgnum=9102 &errorlevel=1}
             /**
         {gpfildel.i &filename=m_cimfile}   **/
          UNDO CIMBLOCK, LEAVE CIMBLOCK.
        END. /*Else NOT m_cimerr*/
      END. /**END TRANSACTION**/

    END. /**IF m_yn THEN**/
END. /**PROCEDURE STOCK-TRANSFER-CIM**/

PROCEDURE SOSHIPPERCIM:
    m_yn = NO.
    {pxmsg.i &msgnum=32 &errorlevel=1 &confirm=m_yn}

    IF m_yn THEN
    DO:
      CIMBLOCK:
      DO TRANSACTION:
          OUTPUT TO VALUE(m_cimfile).
          FOR EACH tt1_det
              WHERE tt1_nbr   <> ""
                AND tt1_qtyiss <> 0
                AND tt1_cust   <> ""
                BREAK BY tt1_site BY tt1_cust BY tt1_nbr BY tt1_line:

             IF FIRST-OF(tt1_cust) THEN
             DO:
/*davidw*/     if tt1_dataset = "sod_det" then
                  PUT '"' tt1_recsite '" '.  /**SHIP-FROM**/
               else
                  PUT '"' tt1_site '" '.    /**SHIP-FROM**/

                put '"S" '                /**SHIPPER**/
                    '"' m_shipid '" '     /**ID**/
                    '"' tt1_cust '" '     /**CUSTOMER**/
                    SKIP(1).
             END. /**IF FIRST-OF(tt1_cust) THEN*/

             IF FIRST-OF(tt1_line) THEN
             DO:
                PUT "1"
                    SKIP
                    "- - - - "
                    '"' tt1_nbr  '" '  /**SALES ORDER**/
                    '"' tt1_line '" '  /**SALES ORDER LINE**/
                    SKIP
/***                "0 - - - - - - - - - - - yes no "              **20090605102535*/
                    "0 "
                    '"' tt1_soum  '" '  /**Unit of MeasureE**/    /**20090605102535*/
                    '"' tt1_um_conv '" '  /**Conversion********/  /**20090605102535*/
                    "- - - - - - - - - yes no "                   /**20090605102535*/
                    SKIP
                    "no"
                    SKIP.

             END. /**IF FIRST-OF(tt1_line) THEN**/

             PUT UNFORMATTED
                 '"' tt1_site    '" '     /**SITE**/
                 '"' tt1_loc     '" '     /**LOC**/
                 '"' tt1_syslot  '" '     /**LOT**/
                 '"' tt1_ref     '" '     /**REF**/
                 SKIP
/*******         tt1_qtyiss               /**QUANTITY ISSUE**/        **20090605102535*/
                 tt1_qtyiss / tt1_um_conv /**QUANTITY ISSUE**/       /**20090605102535*/
                 SKIP.

             IF LAST-OF(tt1_line) THEN
                PUT "."
                    SKIP.

             IF LAST-OF(tt1_cust) THEN
             DO:  /*  MK01 */

                 PUT "."
                    SKIP(2).

                /* MK01 >> */
                IF m_option BEGINS "SHIPPERCREATE" THEN
                DO:
                 FIND FIRST so_mstr WHERE so_domain = GLOBAL_domain AND so_nbr = tt1_nbr NO-LOCK NO-ERROR.
                 IF AVAIL so_mstr THEN
                 DO:
                    IF so_fr_list <> "" AND so_fr_terms <> "" THEN
                        PUT UNFORMATTED SKIP(2).
                 END. /* AVAIL so_mstr */
                END. /* IF m_option */
                /* << MK01 */


                PUT  /* MK01 */
                    "SHIP"
                    SKIP
                    "yes"
                    SKIP.
             END. /*  MK01 */

          END. /**EACH tt1_det**/
          PUT "."
              SKIP.

          OUTPUT CLOSE.

          run proc_loadcimfile in this-procedure.
          IF NOT m_cimerr THEN DO:
            /*CIM Load sucessful*/
           FOR EACH tt1_det
                  WHERE tt1_nbr   <> ""
                    AND tt1_qtyiss <> 0
                    AND tt1_cust   <> ""
               BREAK BY tt1_shipid:
               IF FIRST-OF(tt1_shipid) AND m_shipid = "" THEN DO:
                  MESSAGE m_mesdesc[24] tt1_shipid.
                  PAUSE.
               END.
               FOR FIRST ld_det
                   FIELDS(ld__chr01 ld__chr02)
                    WHERE ld_domain = GLOBAL_domain
                      AND ld_part   = tt1_part
                      AND ld_site   = tt1_site
                      AND ld_loc    = tt1_loc
                      AND ld_lot    = tt1_syslot
                      AND ld_ref    = tt1_ref:
               END. /**FOR FIRST ld_det**/
               IF AVAIL ld_det THEN
                  ld__chr02 = tt1_shipid.
           END. /**EACH tt1_det**/

           {pxmsg.i &msgnum=9101 &errorlevel=1}

           {gpfildel.i &filename=m_cimfile}
           {gpfildel.i &filename=m_outfile}
           {gpfildel.i &filename=m_errfile}


          END. /*IF NOT m_cimerr*/
          ELSE DO:
            /*CIM Load error*/
           {pxmsg.i &msgnum=9102 &errorlevel=1}
               /**
           {gpfildel.i &filename=m_cimfile}   **/
            UNDO CIMBLOCK, LEAVE CIMBLOCK.
          END. /*Else NOT m_cimerr*/
      END. /**END TRANSACTION**/
      RELEASE ld_det.

    END. /**IF m_yn THEN**/
END. /**SOSHIPPERCIM**/

PROCEDURE CYCLE-RECOUNT-CIM:
    m_yn = NO.
    {pxmsg.i &msgnum=32 &errorlevel=1 &confirm=m_yn}

    IF m_yn THEN
    DO:
      CIMBLOCK:
      DO TRANSACTION:
          OUTPUT TO VALUE(m_cimfile).
          FOR EACH tt1_det
              WHERE tt1_loc1   <> ""
                BREAK BY tt1_part :

            IF FIRST-OF(tt1_part) THEN
            DO:
               PUT '"R" '             /**RECOUNT**/
                   SKIP.
            END. /**IF FIRST(tt1_part) THEN**/

            PUT UNFORMATTED
                '"' tt1_part '" '     /**Item**/
                SKIP
                '"' tt1_site    '" '  /**SITE**/
                '"' tt1_loc1    '" '  /**LOC**/
                '"' tt1_syslot  '" '  /**LOT**/
                '"' tt1_ref     '" '  /**REF**/
                SKIP
                tt1_qtyiss               /**QUANTITY COUNTED**/
                SKIP
                '"' tt1_rsncd   '" '     /**REMARKS**/
                m_effdate.               /**EFFECTIVE DATE**/

            /*Jack Li******ADD BEGIN******ECO:20130627135149*/
            IF tt1_acct <> "" THEN
               PUT UNFORMATTED
                  ' "' tt1_acct '" '.
            ELSE
               PUT " - ".
            /*Jack Li******ADDED END******ECO:20130627135149*/

            IF tt1_sub <> "" THEN
               PUT UNFORMATTED
                  /* " - "  *20130627135149*/
                   '"' tt1_sub '"'.

            PUT " "
                SKIP
                "yes"
                SKIP.

            IF tt1_loc1 <> tt1_loc AND tt1_qtyoh <> 0 THEN
            DO:
               PUT UNFORMATTED
                   '"' tt1_part '" '     /**Item**/
                   SKIP
                   '"' tt1_site    '" '  /**SITE**/
                   '"' tt1_loc     '" '  /**LOC**/
                   '"' tt1_syslot  '" '  /**LOT**/
                   '"' tt1_ref     '" '  /**REF**/
                   SKIP
                   0                     /**QUANTITY COUNTED**/
                   SKIP
                   '"' tt1_rsncd   '" '  /**REMARKS**/
                   m_effdate.             /**EFFECTIVE DATE**/
               /*Jack Li******ADD BEGIN******ECO:20130627135149*/
               IF tt1_acct <> "" THEN
                  PUT UNFORMATTED
                      ' "' tt1_acct '" '.
               ELSE
                  PUT " - ".
               /*Jack Li******ADDED END******ECO:20130627135149*/
             
               IF tt1_sub <> "" THEN
                   PUT UNFORMATTED
                     /*  " - " *20130627135149*/
                       '"' tt1_sub '"'.

               PUT " "
                   SKIP
                   "yes"
                   SKIP.
            END. /**IF tt1_loc1 <> tt1_loc THEN**/


             IF LAST-OF(tt1_part) THEN
                PUT "."
                    SKIP.

             IF LAST(tt1_part) THEN
             DO:
                PUT "."
                    SKIP.
             END. /**IF LAST(tt1_part) THEN**/
          END. /**EACH tt1_det**/
          PUT "."
              SKIP.

          OUTPUT CLOSE.

          run proc_loadcimfile in this-procedure.
          IF NOT m_cimerr THEN DO:
            /*CIM Load sucessful*/
           {pxmsg.i &msgnum=9101 &errorlevel=1}
           {gpfildel.i &filename=m_cimfile}
           {gpfildel.i &filename=m_outfile}
           {gpfildel.i &filename=m_errfile}
          END. /*IF NOT m_cimerr*/
          ELSE DO:
            /*CIM Load error*/
           {pxmsg.i &msgnum=9102 &errorlevel=1}
               /**
           {gpfildel.i &filename=m_cimfile}   **/
            UNDO CIMBLOCK, LEAVE CIMBLOCK.
          END. /*Else NOT m_cimerr*/
      END. /**END TRANSACTION**/

    END. /**IF m_yn THEN**/
END. /**CYCLE-RECOUNT-CIM**/

PROCEDURE TAG-RECOUNT-CIM:
    m_yn = NO.
    {pxmsg.i &msgnum=32 &errorlevel=1 &confirm=m_yn}

    IF m_yn THEN
    DO:
      CIMBLOCK:
      DO TRANSACTION:
          OUTPUT TO VALUE(m_cimfile).
          FOR EACH tt1_det
              WHERE tt1_loc1   <> ""
                BREAK BY tt1_tag :

            PUT UNFORMATTED
                tt1_tag
                SKIP
                '"' tt1_site    '" '  /**SITE**/
                SKIP
                '"' tt1_loc1    '" '  /**LOC**/
                SKIP
                '"' tt1_part    '" '  /**Item**/
                '"' tt1_syslot  '" '  /**LOT**/
                '"' tt1_ref     '" '  /**REF**/
                SKIP
                tt1_qtyiss            /**QUANTITY COUNTED**/
                SKIP
                " - - "
                m_effdate             /**EFFECTIVE DATE**/
                ' "" '                /**REMARKS**/
                SKIP.

            IF tt1_tag1 <> 0 THEN
                PUT UNFORMATTED
                    tt1_tag1
                    SKIP
                    '"' tt1_site    '" '  /**SITE**/
                    SKIP
                    '"' tt1_loc     '" '  /**LOC**/
                    SKIP
                    '"' tt1_part    '" '  /**Item**/
                    '"' tt1_syslot  '" '  /**LOT**/
                    '"' tt1_ref     '" '  /**REF**/
                    SKIP
                    0                     /**QUANTITY COUNTED**/
                    SKIP
                    " - - "
                    m_effdate             /**EFFECTIVE DATE**/
                    ' "" '                /**REMARKS**/
                    SKIP.
          END. /**EACH tt1_det**/
          PUT "."
              SKIP.
          OUTPUT CLOSE.

          /*************jackl --DELETE BEGIN***ECO:20120220104853**
          OUTPUT TO VALUE(m_cimfile).
          FOR EACH tt1_det WHERE tt1_loc1 <> "" BREAK BY tt1_tag :
        /* find first tag_mstr no-lock  where tag_domain = "AU001" and jackl*/
            find first tag_mstr no-lock  where tag_domain = global_domain and
                                      tag_nbr = tt1_tag    and
                                      tag_type = "B"  no-error.
              IF available tag_mstr THEN
                 PUT UNFORMATTED
                     tt1_tag  SKIP
                 '"' tt1_site    '" '  SKIP /**SITE**/
                 '"' tt1_loc1    '" '  SKIP /**LOC**/
                 '"' tt1_part    '" '  /**Item**/
                 '"' tt1_syslot  '" '  /**LOT**/
                 '"' tt1_ref     '" '  /**REF**/    SKIP
                     tt1_qtyiss        /**QUANTITY COUNTED**/
                   " - "               SKIP
                   " - - "
                  m_effdate             /**EFFECTIVE DATE**/
                   ' "" '                /**REMARKS**/  SKIP.
              ELSE
                 PUT UNFORMATTED
                     tt1_tag   SKIP
                     tt1_qtyiss " - " SKIP
                     " - - " m_effdate " - " SKIP.
          END.
          PUT "." SKIP.
          OUTPUT CLOSE.
          *************jackl --DELETED END*****ECO:20120220104853**/

          run proc_loadcimfile in this-procedure.
          IF NOT m_cimerr THEN DO:
            /*CIM Load sucessful*/
           {pxmsg.i &msgnum=9101 &errorlevel=1}
          /* {gpfildel.i &filename=m_cimfile}
           {gpfildel.i &filename=m_outfile}
           {gpfildel.i &filename=m_errfile}  */
          END. /*IF NOT m_cimerr*/
          ELSE DO:
            /*CIM Load error*/
           {pxmsg.i &msgnum=9102 &errorlevel=1}
               /**
           {gpfildel.i &filename=m_cimfile}   **/
            UNDO CIMBLOCK, LEAVE CIMBLOCK.
          END. /*Else NOT m_cimerr*/
      END. /**END TRANSACTION**/
      RELEASE tag_mstr.
    END. /**IF m_yn THEN**/
END. /**TAG-RECOUNT-CIM**/

PROCEDURE SHIPPER-DEALLOCATION:
    m_yn = NO.
    {pxmsg.i &msgnum=32 &errorlevel=1 &confirm=m_yn}

    IF m_yn THEN
    DO:
      CIMBLOCK:
      DO TRANSACTION:

        FOR EACH tt1_det
            WHERE tt1_nbr     <> "" :

            FOR FIRST ABS_mstr
                FIELDS(ABS_lotser)
                WHERE ABS_domain    = GLOBAL_domain
                  AND ABS_shipfrom  = tt1_site
                  AND abs_par_id    = "S" + tt1_nbr
                  AND abs_lotser    = tt1_syslot
                  AND abs_ref       = tt1_ref
                  AND ABS_item      = tt1_part
                  AND ABS_site      = tt1_site
                  AND ABS_loc       = tt1_loc  :
               DELETE ABS_mstr.
            END. /**FOR FIRST ABS_mstr**/

            FOR FIRST ld_det
                FIELDS(ld__chr01 ld__chr02)
                 WHERE ld_domain  = GLOBAL_domain
                   AND ld_part    = tt1_part
                   AND ld_site    = tt1_site
                   AND ld_loc     = tt1_loc
                   AND ld_lot     = tt1_syslot
                   AND ld_ref     = tt1_ref :
            END. /**FOR FIRST ld_det**/
            IF AVAIL ld_det THEN
               ld__chr02  = "".
        END. /**EACH tt1_det**/
        {pxmsg.i &msgnum=9101 &errorlevel=1}
        /*LOAD CIM FILE*/
      END. /**END TRANSACTION**/
      RELEASE ld_det.
      RELEASE ABS_mstr.
    END. /**IF m_yn THEN**/

END. /**PROCEDURE SHIPPER-DEALLOCATION:**/

PROCEDURE ORDER-VALIDATION:
   FIND FIRST tt1_det
        WHERE RECID(tt1_det) = m_recid1 NO-LOCK NO-ERROR.
   IF AVAIL tt1_det THEN
   DO:
       IF tt1_dataset = "sod_det"  THEN
       DO:
/*davidw across site */
         m_acrossflag = No.


         find first code_mstr where code_domain = global_domain and
              code_fldname = "xx_consume_site" and code_value = tt1_recsite
              and code_cmmt = tt1_site no-lock no-error.
         if avail code_mstr then  m_acrossflag = Yes.


         IF NOT(CAN-FIND(FIRST sod_det NO-LOCK
                     WHERE sod_domain = GLOBAL_domain
                       AND sod_nbr  = tt1_nbr
                       AND sod_part = tt1_part
                       AND (  sod_line = int(tt1_line)  /*linas35941*/
		             and tt1_line <> "" ) /*linas42955*/
/*davidw*/             AND (sod_site = tt1_site  or
                       (m_acrossflag and sod_site = tt1_recsite))
                       AND sod_type = "" ) AND
            CAN-FIND(FIRST so_mstr NO-LOCK
                     WHERE so_domain = global_domain
                       AND so_nbr  = tt1_nbr
/*linas91834**         AND so_stat = "" */ )    AND 
             NOT CAN-FIND(FIRST lad_det NO-LOCK
                          WHERE lad_domain  = GLOBAL_domain
                            AND lad_dataset = "sod_det"
                            AND lad_nbr     = tt1_nbr
                            AND lad_part    = tt1_part
                            AND lad_site    = tt1_site
                            AND lad_loc     = tt1_loc
                            AND lad_lot     = tt1_syslot
                            AND lad_ref     = tt1_ref))
         THEN
         DO:
            MESSAGE m_mesdesc[19].
/*davidw:1959*/  RUN sendbell  IN THIS-PROCEDURE.
            m_error = YES.
         END. /**SALED ORDER CHECK**/
       END. /**IF tt1_dataset = "sod_det"  THEN**/
       ELSE DO:

          FOR EACH  dsd_det
              FIELDS(dsd_site dsd_part dsd_trans_id dsd_status)
              WHERE dsd_domain    = GLOBAL_domain
                AND dsd_nbr       = tt1_nbr
                AND dsd_shipsite  = tt1_site
                AND dsd_qty_conf - dsd_qty_ship > 0 NO-LOCK :
             IF dsd_part = tt1_part THEN
             DO:
                 /*linas90338 BEGIN*/
                IF  dsd_status = "C" THEN DO:
                   MESSAGE "ERROR: DO Already Canceled". 
                   RUN sendbell  IN THIS-PROCEDURE.
                  m_error = YES. 
                END. 
                 /*linas90338 END */ 

                m_count = m_count + 1.
                IF CAN-FIND(FIRST lad_det NO-LOCK
                       WHERE lad_domain  = GLOBAL_domain
                         AND lad_dataset = "ds_det"
                         AND lad_nbr     = tt1_line
                         AND lad_line    = tt1_recsite
                         AND lad_part    = tt1_part
                         AND lad_site    = tt1_site
                         AND lad_loc     = tt1_loc
                         AND lad_lot     = tt1_syslot) THEN
                DO:
                  MESSAGE m_mesdesc[26] .
/*davidw:1959*/  RUN sendbell  IN THIS-PROCEDURE.
                  m_error = YES.
                END. /**SALED ORDER CHECK**/

                IF NOT CAN-FIND(FIRST loc_mstr NO-LOCK
                                WHERE loc_domain = GLOBAL_domain
                                  AND loc_site   = dsd_site
                                  AND loc_loc    = dsd_trans_id ) THEN
                DO:
                    MESSAGE m_mesdesc[22] dsd_trans_id.
                    m_error = YES.
                END. /**IF NOT CAN-FIND**/
             END. /**IF dsd_part = tt1_part THEN**/
          END. /**EACH dsd_det**/
          IF m_count = 0 THEN DO:
              MESSAGE m_mesdesc[26].
/*davidw:1959*/  RUN sendbell  IN THIS-PROCEDURE.
              m_error = YES.
          END. /*IF m_count = 0 THEN DO**/

       END. /**ELSE DO**/
   END. /**AVAIL tt1_det**/
END. /**ORDER-VALIDATION**/

/***20090210125358***begin ***/
PROCEDURE DRIVERLINK-PALLET:
  n_count = 0. /*jackl 20090527133626*/
  FORM
      ttdr_ref      COLUMN-LABEL {&xxictpc_p_10}
      VALIDATE(INPUT FRAME a1h  ttdr_ref <> "" ,
               m_mesdesc[4])
      ttdr_driver   COLUMN-LABEL "Driver"        FORMAT "X(8)"
      VALIDATE(INPUT FRAME a1h ttdr_driver <> ""
                AND CAN-FIND(AD_MSTR NO-LOCK WHERE AD_DOMAIN = GLOBAL_DOMAIN
                                               AND AD_ADDR = INPUT FRAME A1H TTdr_driver),
               "Driver Does not exist")
    WITH FRAME a1h DOWN.

  mainloop:
  REPEAT:
    EMPTY TEMP-TABLE ttdr_det.

    CLEAR FRAME a1h ALL NO-PAUSE.
    ASSIGN m_ref = ""
           m_driver = ""
           m_shipid = "".

    detloop:
    REPEAT:

      IF m_screen THEN
      DO:
          PROMPT-FOR ttdr_ref
              WITH FRAME a1h EDITING:
              {mfnp.i ttdr_det ttdr_ref ttdr_ref ttdr_ref ttdr_ref
                      ttdr_ref}
               IF recno <> ? THEN
                  DISP ttdr_ref ttdr_driver
                       WITH FRAME a1h.
          END. /**ROMPT-FOR tt12_lot**/
      END. /**HHT SCREEN**/

      ASSIGN
             m_ref    =  INPUT FRAME a1h ttdr_ref.


      FIND FIRST abs_mstr no-lock where abs_domain = global_domain
                                   and  abs_id begins "IS"
                                   and  abs_ref = m_ref NO-ERROR.

      IF  AVAILABLE ABS_MSTR THEN DO:
             ASSIGN m_shipid = substring(abs_par_id,2,10).
             ASSIGN m_shipfrom  = abs_shipfrom.
             MESSAGE "Shipper ID: " m_shipid.
      END.
      ELSE DO:
          MESSAGE "Shipper ID does not exist!!".
          UNDO detloop , RETRY detloop.
      END.

      FIND FIRST ttdr_det
           WHERE ttdr_ref  = m_ref NO-ERROR.
      IF NOT AVAIL ttdr_det THEN
      DO:
         CREATE ttdr_det.
         ASSIGN ttdr_ref   = m_ref
                ttdr_driver = m_driver
                ttdr_shipid   = m_shipid
                ttdr_shipfrom = m_shipfrom.
         n_count = n_count + 1. /*jackl 20090527133626*/
      END. /**IF NOT AVAIL tt2a_det THEN**/

      IF m_screen THEN
         DISP ttdr_ref ttdr_driver
                 WITH FRAME a1h.

      IF m_screen THEN DO:
         UPDATE ttdr_driver
                GO-ON (CTRL-D F5) WITH FRAME a1h DOWN.
         Message "Sum to scan:" n_count. /*jackl 20090527133626*/
      END.
      m_driver =  ttdr_driver.

      FIND FIRST ad_mstr no-lock where ad_domain = global_domain
                                   and  ad_addr = m_driver NO-ERROR.

      IF  AVAILABLE ad_mstr THEN MESSAGE "Driver:   " ad_name.
      ELSE DO:
          MESSAGE "Driver ID does not exist!!".
/*davidw:1959*/  RUN sendbell  IN THIS-PROCEDURE.
          UNDO detloop , RETRY detloop.
      END.



      /* DELETE */
      IF LASTKEY = KEYCODE("F5") OR LASTKEY = KEYCODE("CTRL-D")
      THEN do:
           del-yn = no.
           /* Please confirm delete */
           {pxmsg.i &MSGNUM=11 &ERRORLEVEL=1 &CONFIRM=del-yn}
           IF del-yn THEN
           DO:
              DELETE ttdr_det.
              IF m_screen THEN DO:
                 CLEAR FRAME a1h.
                 n_count = n_count - 1. /*jackl 20090527133626*/
                 Message "Sum to scan:" n_count. /*jackl 20090527133626*/
              END.
              ELSE
                 CLEAR FRAME a1.
              UNDO detloop, RETRY detloop.
           END. /**IF del-yn THEN**/
      END. /**IF LASTKEY = KEYCODE("F5") OR LASTKEY = KEYCODE("CTRL-D")*/

         DOWN 1 WITH FRAME a1h.

    END. /**END OF REPEAT**/

    IF NOT CAN-FIND(FIRST ttdr_det) THEN
    DO:
       MESSAGE m_mesdesc[14].
/*davidw:1959*/  RUN sendbell  IN THIS-PROCEDURE.
       PAUSE.
       LEAVE mainloop.
    END. /**IF NOT CAN-FIND(FIRST ttdr_det **/

    RUN WRITE-DRIVER  IN THIS-PROCEDURE.
    n_count = 0. /*jackl 20090527133626*/

  END. /**END OF REPEAT**/

END. /**PROCEDURE DRIVERLINK-PALLET: */

PROCEDURE WRITE-DRIVER:

   m_yn = NO.
   {pxmsg.i &msgnum=32 &errorlevel=1 &confirm=m_yn}

   IF m_yn THEN
   DO:

    FOR EACH ttdr_det no-lock:

             FOR FIRST ABS_MSTR WHERE ABS_DOMAIN = GLOBAL_DOMAIN
                                  AND ABS_SHIPFROM = ttdr_SHIPFROM
                                  AND ABS_ID     = "S" +  ttdr_shipid:
                  ASSIGN  SUBSTRING(ABS__CHR02,1,8) = string(year(today),"9999") + string(month(today),"99")
                                                                  + string(day(today),"99").

                  ASSIGN  SUBSTRING(ABS__CHR02,10,8) = string(int(time),"HH:MM:SS").
             END.

             FIND FIRST ABSC_DET WHERE ABSC_DOMAIN = GLOBAL_DOMAIN
                                   AND ABSC_ABS_ID = "S" + ttdr_SHIPID NO-ERROR.

             IF NOT AVAILABLE ABSC_DET THEN DO:
                       CREATE ABSC_DET.
                       ASSIGN ABSC_ABS_ID = "S" + ttdr_SHIPID
                              ABSC_DOMAIN = GLOBAL_DOMAIN
                              ABSC_SEQ    = 1.
             END. /* IF NOT AVAILABLE ABSC_DET */

                  ASSIGN ABSC_CARRIER = ttdr_DRIVER.
    END. /* FOR EACH ttdr_det no-lock: */
   END. /* IF m_yn */

END.  /* PROCEDURE WRITE-DRIVER: */

/***20090210125358** END   ***/

/*davidw:1959 begin*/
procedure sendbell:
  if m_bell then bell.
end.
/*davidw:1959 end*/

/*david:1806 begin*/
FUNCTION get_sscentity RETURNS CHAR PRIVATE (INPUT ssc_part AS CHAR):
     FIND FIRST pt_mstr WHERE pt_domain = global_domain AND
          pt_part =  ssc_part NO-LOCK NO-ERROR.
       IF AVAILABLE pt_mstr THEN DO:
          FIND FIRST pl_mstr NO-LOCK WHERE pl_domain = global_domain AND
                     pl_prod_line = pt_prod_line NO-ERROR.
           IF AVAIL pl_mstr THEN RETURN pl__chr01.
      END. /* if available pt_mstr */
END FUNCTION.

FUNCTION get_itaxsite RETURNS CHAR PRIVATE
     (INPUT ssc_site AS CHAR, INPUT ssc_part AS CHAR):
      FIND FIRST pt_mstr WHERE pt_domain = global_domain AND
           pt_part = ssc_part NO-LOCK NO-ERROR.
       IF AVAILABLE pt_mstr THEN DO:
          FIND FIRST code_mstr NO-LOCK WHERE code_domain = global_domain AND
               code_fldname = "xx_itax_site" and
               code_value = ssc_site + "," + pt_prod_line NO-ERROR.
          IF AVAIL code_mstr THEN RETURN code_cmmt.
      END. /* if available pt_mstr */
END FUNCTION.
/*david:1806 end*/

/*linas60107* begin*/
FUNCTION SHIPPMENT-LOCK RETURNS LOGICAL(parm1 as CHAR):

   IF not m_option BEGINS "SODOSHIP" THEN RETURN NO.
   ELSE DO:
          FIND FIRST code_mstr where code_domain = global_domain
                                 and code_fldname = "xx_single_invoice_control"
                                no-lock no-error.
          if not available code_mstr then return no.
          else do:
                 find last tr_hist no-lock where tr_domain = global_domain
                                             and tr_nbr    = parm1
                                             and tr_type   = "ISS-SO"
                                             and tr_rmks   = "" NO-ERROR.
                 if available tr_hist then return yes.
                 else return no.
          end.
   END. /* ELSE DO: */
END FUNCTION.

/*linas60107* end  */

/*linas42955* BEGIN**/
FUNCTION DUMPLICATE-SOLINE RETURNS INT PRIVATE ( INPUT m_str1 AS CHAR , INPUT m_str2 AS CHAR ):
    m_socnt = 0.
   SELECT COUNT(*) into m_socnt from sod_det where sod_domain = global_domain
                               and sod_nbr = m_str1 
			       and sod_part = m_str2. 

   RETURN m_socnt.
END FUNCTION.
/*linas42955* END**/
