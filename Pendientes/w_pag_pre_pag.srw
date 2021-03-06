$PBExportHeader$w_pag_pre_pag.srw
$PBExportComments$Ventana de prepagos
forward
global type w_pag_pre_pag from w_gen
end type
type cb_ext from commandbutton within w_pag_pre_pag
end type
type cb_cerrar from commandbutton within w_pag_pre_pag
end type
type st_cnv_det from statictext within w_pag_pre_pag
end type
type dw_cre_lis from uo_dw_mant within w_pag_pre_pag
end type
type dw_bus_per from uo_dw_mant within w_pag_pre_pag
end type
type cb_bus_alf from commandbutton within w_pag_pre_pag
end type
type cb_buscar from commandbutton within w_pag_pre_pag
end type
type dw_pag_mto from uo_dw_mant within w_pag_pre_pag
end type
type st_1 from statictext within w_pag_pre_pag
end type
type cb_nuevo from commandbutton within w_pag_pre_pag
end type
type dw_c1 from uo_dw_mant within w_pag_pre_pag
end type
type dw_c2 from uo_dw_mant within w_pag_pre_pag
end type
type cb_cron from commandbutton within w_pag_pre_pag
end type
type st_error from statictext within w_pag_pre_pag
end type
type dw_cuo_pre_pag from datawindow within w_pag_pre_pag
end type
type gb_gral from groupbox within w_pag_pre_pag
end type
end forward

global type w_pag_pre_pag from w_gen
integer width = 5303
integer height = 2460
string title = "Prepagos"
boolean maxbox = false
boolean resizable = false
windowtype windowtype = popup!
cb_ext cb_ext
cb_cerrar cb_cerrar
st_cnv_det st_cnv_det
dw_cre_lis dw_cre_lis
dw_bus_per dw_bus_per
cb_bus_alf cb_bus_alf
cb_buscar cb_buscar
dw_pag_mto dw_pag_mto
st_1 st_1
cb_nuevo cb_nuevo
dw_c1 dw_c1
dw_c2 dw_c2
cb_cron cb_cron
st_error st_error
dw_cuo_pre_pag dw_cuo_pre_pag
gb_gral gb_gral
end type
global w_pag_pre_pag w_pag_pre_pag

type variables
st_cre_cro ist_gen_cro_lib
st_pri_ven ist_ven
st_cuo_cron ist_cuo_cron[]
s_struct is_struct, is_struct_ci
st_cron_lib ist_cron_lib
LONG il_nro_cuo

Boolean ib_neg, ib_reset
STRING is_num_cre, is_eval

st_cre_cre ist_cre
st_cre_pre_pag ist_pre_pag

uo_cre_cre iuo_cre
w_preview iw_reporte
end variables

forward prototypes
public subroutine wf_bloquear_controles (boolean ab_estado)
public subroutine wf_limpiar_controles ()
public function boolean wf_valida_datos ()
public subroutine wf_act_bot ()
public subroutine wf_cargar_datos (long al_row)
public subroutine wf_llenar_cuo (date ad_fecha)
end prototypes

public subroutine wf_bloquear_controles (boolean ab_estado);cb_nuevo.text = F_IIF(ib_modificar or ii_accion = 1, 'Grabar', 'Nuevo')
cb_cerrar.text = F_IIF(ib_modificar or ii_accion = 1, 'Cancelar', 'Cerrar')

cb_nuevo.enabled = ab_estado
dw_pag_mto.enabled = ab_estado

end subroutine

public subroutine wf_limpiar_controles ();dw_cre_lis.reset( )

dw_pag_mto.reset( )
dw_pag_mto.insertrow(0)

dw_pag_mto.setitem( 1, 'fecha', guo_gen.gd_fec_act )

dw_c1.reset( )
dw_c1.accepttext( )
dw_c1.groupcalc( )

dw_c2.reset( )
dw_c2.accepttext( )
dw_c2.groupcalc( )

 is_num_cre = ''

end subroutine

public function boolean wf_valida_datos ();Tab tab_aux

IF NOT f_val_dw_cfg_usu (dw_pag_mto , tab_aux, FALSE, 0) THEN 
	RETURN FALSE
END IF

IF dw_c2.rowcount( ) = 0 THEN
	MessageBox(gs_nomapl, "Debe generar cronograma. Verifique.")
	RETURN FALSE
END IF

RETURN TRUE
end function

public subroutine wf_act_bot ();ii_accion = 1
ib_modificar =TRUE
wf_bloquear_controles(TRUE)

end subroutine

public subroutine wf_cargar_datos (long al_row);LONG ll_mov
STRING ls_cod_ofi

IF al_row <= 0 THEN RETURN

IF dw_cre_lis.getitemnumber(al_row, 'nro_cuo_pag') = 0 THEN
	MessageBox(gs_nomapl, "Crédito no posee pago que cumpla para poder realizar prepagos")
	
	wf_Limpiar_Controles ()
	dw_cre_lis.reset( )
	RETURN
END IF

is_num_cre = dw_cre_lis.getitemstring(al_row, 'cre_num_cre')

st_cnv_det.text  = 'Distribución de nuevo cronograma de pagos - ' + STRING(is_num_cre, "@@@-@@@-@@@@@@@@@@@")

//Obtenemos último movimiento de pago
SELECT TOP 1 mov_nro_mov, mov_cod_ofi
INTO :ll_mov, :ls_cod_ofi
FROM mov_pag 
WHERE cre_num_cre = :is_num_cre and mov_ext ='0'
ORDER BY mov_nro_mov DESC;

dw_pag_mto.reset()
dw_pag_mto.insertrow( 0)
dw_pag_mto.setitem( 1, 'fecha', guo_gen.fec_act_dt( ) )

dw_pag_mto.setitem( 1, 'fecha', dw_cre_lis.getitemdate(al_row, 'fec_ult_pag'))
dw_pag_mto.setitem( 1, 'nro_cuo_ini', dw_cre_lis.getitemnumber(al_row, 'nro_cuo_ini'))
dw_pag_mto.setitem( 1, 'mto_ini', dw_cre_lis.getitemdecimal(al_row, 'mto_ini'))
dw_pag_mto.setitem( 1, 'nro_cuo_fin', dw_cre_lis.getitemnumber(al_row, 'nro_cuo_cron'))
dw_pag_mto.setitem( 1, 'mto_cron', dw_cre_lis.getitemdecimal(al_row, 'mto_cron'))
dw_pag_mto.setitem( 1, 'tea', dw_cre_lis.getitemdecimal(al_row, 'cre_tea'))
dw_pag_mto.setitem( 1, 'fec_ult_pag', dw_cre_lis.getitemdate(al_row, 'fec_ult_pag'))
dw_pag_mto.setitem( 1, 'cre_sal_cap', dw_cre_lis.getitemdecimal(al_row, 'cre_sal_cap'))
dw_pag_mto.setitem( 1, 'cre_tot_int', 0)
dw_pag_mto.setitem( 1, 'nro_cuo_pag', dw_cre_lis.getitemnumber(al_row, 'nro_cuo_pag'))
dw_pag_mto.setitem( 1, 'fec_prox_ven', dw_cre_lis.getitemdate(al_row, 'fec_prox_ven'))
dw_pag_mto.setitem( 1, 'mov_nro_mov', ll_mov)
dw_pag_mto.setitem( 1, 'mov_cod_ofi', ls_cod_ofi)

wf_llenar_cuo(dw_cre_lis.getitemdate(al_row, 'fec_ult_pag'))
dw_pag_mto.accepttext( )




dw_pag_mto.setfocus( )

end subroutine

public subroutine wf_llenar_cuo (date ad_fecha);INTEGER li
DECIMAL {2} lr_saldo

//Obtenemos datawindows de cuotas que quedarán de prepago
dw_cuo_pre_pag.retrieve(is_num_cre,  ad_fecha)
FOR li = 1 TO dw_cuo_pre_pag.rowcount( )
	If li = 1 then
		lr_saldo = dw_cuo_pre_pag.getitemdecimal( li, 'cuo_sal_cap') - dw_cuo_pre_pag.getitemdecimal( li, 'cuo_cap_cuo') 
	Else
		dw_cuo_pre_pag.setitem( li, 'cuo_sal_cap', lr_saldo)
		lr_saldo = dw_cuo_pre_pag.getitemdecimal( li, 'cuo_sal_cap') - dw_cuo_pre_pag.getitemdecimal( li, 'cuo_cap_cuo') 
	End IF
	 dw_cuo_pre_pag.setitem(li, 'cuo_nro_cuo', li)
NEXT
 dw_cuo_pre_pag.accepttext( )
end subroutine

on w_pag_pre_pag.create
int iCurrent
call super::create
this.cb_ext=create cb_ext
this.cb_cerrar=create cb_cerrar
this.st_cnv_det=create st_cnv_det
this.dw_cre_lis=create dw_cre_lis
this.dw_bus_per=create dw_bus_per
this.cb_bus_alf=create cb_bus_alf
this.cb_buscar=create cb_buscar
this.dw_pag_mto=create dw_pag_mto
this.st_1=create st_1
this.cb_nuevo=create cb_nuevo
this.dw_c1=create dw_c1
this.dw_c2=create dw_c2
this.cb_cron=create cb_cron
this.st_error=create st_error
this.dw_cuo_pre_pag=create dw_cuo_pre_pag
this.gb_gral=create gb_gral
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_ext
this.Control[iCurrent+2]=this.cb_cerrar
this.Control[iCurrent+3]=this.st_cnv_det
this.Control[iCurrent+4]=this.dw_cre_lis
this.Control[iCurrent+5]=this.dw_bus_per
this.Control[iCurrent+6]=this.cb_bus_alf
this.Control[iCurrent+7]=this.cb_buscar
this.Control[iCurrent+8]=this.dw_pag_mto
this.Control[iCurrent+9]=this.st_1
this.Control[iCurrent+10]=this.cb_nuevo
this.Control[iCurrent+11]=this.dw_c1
this.Control[iCurrent+12]=this.dw_c2
this.Control[iCurrent+13]=this.cb_cron
this.Control[iCurrent+14]=this.st_error
this.Control[iCurrent+15]=this.dw_cuo_pre_pag
this.Control[iCurrent+16]=this.gb_gral
end on

on w_pag_pre_pag.destroy
call super::destroy
destroy(this.cb_ext)
destroy(this.cb_cerrar)
destroy(this.st_cnv_det)
destroy(this.dw_cre_lis)
destroy(this.dw_bus_per)
destroy(this.cb_bus_alf)
destroy(this.cb_buscar)
destroy(this.dw_pag_mto)
destroy(this.st_1)
destroy(this.cb_nuevo)
destroy(this.dw_c1)
destroy(this.dw_c2)
destroy(this.cb_cron)
destroy(this.st_error)
destroy(this.dw_cuo_pre_pag)
destroy(this.gb_gral)
end on

event open;DataWindowChild ldwch

iuo_cre = CREATE uo_cre_cre
 
//1.-Cargamos Tab_1
dw_cre_lis.settransobject( SQLCA)
dw_cuo_pre_pag.settransobject( SQLCA)

dw_c1.settransobject( SQLCA)
dw_c1.insertrow(0)
dw_c1.setitem( 1, 'cuo_tip_cron', '0')
dw_c1.groupcalc( )

dw_c2.settransobject( SQLCA)
dw_c2.insertrow(0)
dw_c2.setitem( 1, 'cuo_tip_cron', '1')
dw_c2.groupcalc( )

//Cargamos Tipo de documento
dw_bus_per.getchild('per_tip_doc', ldwch)
ldwch.settransobject( SQLCA)
ldwch.retrieve(gi_v_tip_doc)

//Cargamos búsqueda
dw_bus_per.insertrow(0)

ii_accion = 0
ib_modificar = FALSE

wf_bloquear_controles(FALSE)
wf_limpiar_controles ()
end event

type st_win from w_gen`st_win within w_pag_pre_pag
integer x = 4896
integer y = 0
integer width = 347
string text = "w_pag_pre_pag"
alignment alignment = right!
end type

type cb_ext from commandbutton within w_pag_pre_pag
integer x = 1847
integer y = 2240
integer width = 343
integer height = 100
integer taborder = 100
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Extorno"
end type

event clicked;OPEN(w_pre_pag_ext)

ii_accion = 0
ib_modificar = FALSE
wf_limpiar_controles ()
	 
wf_bloquear_controles(FALSE)

end event

type cb_cerrar from commandbutton within w_pag_pre_pag
integer x = 2245
integer y = 2240
integer width = 343
integer height = 100
integer taborder = 110
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Cerrar"
boolean cancel = true
end type

event clicked;BOOLEAN lb_estado

IF ii_accion <> 0 AND ib_modificar THEN
	IF MessageBox(gs_nomapl, "Ha realizado cambios en el formulario.~r¿Desea guardar la información?", Question!, YesNo!, 2) = 1 THEN
		cb_nuevo.triggerevent( Clicked!)
	ELSE		
		ii_accion = 0
		ib_modificar = FALSE
		wf_limpiar_controles ()
		wf_bloquear_controles (lb_estado)
		dw_bus_per.setfocus( )
	END IF
ELSE
	Close(PARENT)
END IF
end event

type st_cnv_det from statictext within w_pag_pre_pag
integer x = 2629
integer y = 40
integer width = 2624
integer height = 76
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 12632256
string text = "Distribución de nuevo cronograma de pagos"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

type dw_cre_lis from uo_dw_mant within w_pag_pre_pag
integer x = 50
integer y = 420
integer width = 1079
integer height = 1224
integer taborder = 50
boolean bringtotop = true
string dataobject = "d_pag_cre_list_pre_pag"
borderstyle borderstyle = stylelowered!
end type

event doubleclicked;IF THIS.rowcount( ) >0 AND row > 0 THEN
	wf_cargar_datos (row)
END IF
end event

event rowfocuschanged;THIS.selectrow (0, FALSE)
THIS.selectrow (THIS.getrow (), TRUE)

end event

type dw_bus_per from uo_dw_mant within w_pag_pre_pag
integer x = 64
integer y = 64
integer width = 2377
integer height = 312
integer taborder = 20
boolean bringtotop = true
string title = ""
string dataobject = "d_pag_cre_bus_per"
boolean hscrollbar = false
boolean vscrollbar = false
boolean border = false
boolean livescroll = false
end type

event itemchanged;call super::itemchanged;IF THIS.getcolumnname( ) = 'per_tip_per' or THIS.getcolumnname( ) = 'per_tip_bus' THEN
	THIS.setitem( 1, 'per_num_doc', '')
	THIS.setitem( 1, 'per_nom_alf', '')	
	THIS.accepttext( )
	
	IF THIS.getcolumnname( ) = 'per_tip_bus' THEN
		THIS.modify( "per_nom_alf.Protect='1'  per_tip_doc.Protect='0'  per_num_doc.Protect='0' ")
		IF data = '2' THEN
			PARENT.cb_bus_alf.enabled =TRUE
			THIS.modify( "per_nom_alf.Protect='0' per_tip_doc.Protect='1'  per_num_doc.Protect='1' ")
			THIS.setcolumn( 'per_nom_alf')
			THIS.SetFocus()
		ELSE
			PARENT.cb_bus_alf.enabled =FALSE
			THIS.setcolumn( 'per_num_doc')
			THIS.SetFocus()			
		END IF
	END IF
	wf_limpiar_controles()
	ii_accion = 0
	ib_modificar = FALSE
	wf_limpiar_controles ()
	wf_bloquear_controles (FALSE)	
	is_num_cre =''
END IF

IF THIS.getcolumnname( ) = 'per_tip_per' THEN
	IF data = 'N' THEN
		THIS.setitem( 1, 'per_tip_doc', 'DNI')
	ELSE
		THIS.setitem( 1, 'per_tip_doc', 'RUC')
	END IF
	THIS.setcolumn( 'per_num_doc')
ELSEIF THIS.getcolumnname( ) = 'per_tip_doc' THEN
		THIS.setcolumn( 'per_num_doc')
		THIS.setfocus( )
ELSEIF THIS.getcolumnname( ) = 'per_tip_bus' and data = '2' THEN
		this.setitem( 1,  'per_tip_bus', data)
		PARENT.cb_bus_alf.triggerevent( Clicked!)
ELSEIF THIS.getcolumnname( ) = 'per_num_doc' THEN
	THIS.setitem( row, 'per_nom_alf', '')
ELSEIF THIS.getcolumnname( ) = 'per_nom_alf' THEN
	THIS.setitem( row, 'per_num_doc', '')	
END IF 
end event

type cb_bus_alf from commandbutton within w_pag_pre_pag
integer x = 2418
integer y = 252
integer width = 123
integer height = 76
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
boolean enabled = false
string text = "..."
end type

event clicked;st_bus_per lst_bus_per

OPENWITHPARM(w_recup_bus_alf_cli, Parent.dw_bus_per.getitemstring(1,'per_tip_per'))

lst_bus_per = Message.powerobjectparm

IF lst_bus_per.is_per_cod <> '' THEN
	Parent.dw_bus_per.setitem( 1, 'per_cod', lst_bus_per.is_per_cod )
	Parent.dw_bus_per.setitem( 1, 'per_nom_alf', lst_bus_per.is_per_nom_alf )
	Parent.dw_bus_per.accepttext( )

	Parent.cb_buscar.triggerevent( Clicked!)
END IF
	
	
end event

type cb_buscar from commandbutton within w_pag_pre_pag
integer x = 2194
integer y = 140
integer width = 343
integer height = 92
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Buscar"
end type

event clicked;STRING ls_cod_per, ls_tip_doc, ls_num_doc, ls_tip_bus, ls_tip_per, ls_des_alf

ls_tip_per	=  dw_bus_per.getitemstring( 1, 'per_tip_per')
ls_tip_doc	=  dw_bus_per.getitemstring( 1, 'per_tip_doc')
ls_num_doc	=  dw_bus_per.getitemstring( 1, 'per_num_doc')
ls_tip_bus	=  dw_bus_per.getitemstring( 1, 'per_tip_bus')
ls_des_alf	=  dw_bus_per.getitemstring( 1, 'per_nom_alf')

IF ls_tip_bus = '1' THEN //Por DNI
	IF ls_num_doc ='' OR ISNULL(ls_num_doc) THEN
		MessageBox(gs_nomapl, "Debe indicar un nro de documento", Exclamation!)
		dw_bus_per.setfocus( )
		RETURN
	END IF

	SELECT per_cod, per_nom_alf
	INTO :ls_cod_per, :ls_des_alf
	FROM Persona
	WHERE per_tip_doc = :ls_tip_doc  AND per_num_doc = :ls_num_doc;
	
	IF ls_cod_per ='' OR ISNULL(ls_cod_per) THEN
		dw_cre_lis.Reset()
		dw_c1.reset( )
		dw_c2.reset( )	
		MessageBox(gs_nomapl, "Cliente no existe")
		dw_bus_per.setfocus( )
		RETURN
	END IF
	
	dw_bus_per.setitem( 1, 'per_nom_alf', ls_des_alf)
	
	//Recuperamos datos de créditos
	dw_cre_lis.retrieve(ls_cod_per )
	
else //Por Nombre
	ls_tip_doc = '%%'
	ls_num_doc =''

	ls_cod_per = dw_bus_per.getitemstring(1, 'per_cod')
	
	//Recuperamos datos de créditos
	dw_cre_lis.retrieve(ls_cod_per)
end if

//Muestra Mensaje o posiciona información
IF dw_cre_lis.rowcount( ) = 0 THEN
	MessageBox(gs_nomapl, "No existen créditos con convenio vigentes para ésta persona ó ha cancelado todos sus creditos")
ELSE
	wf_cargar_datos (1)
	IF ii_accion = 0  THEN  wf_act_bot()	
	dw_pag_mto.setfocus( )
END IF
end event

type dw_pag_mto from uo_dw_mant within w_pag_pre_pag
integer x = 1166
integer y = 484
integer width = 1394
integer height = 1148
integer taborder = 60
boolean bringtotop = true
boolean enabled = false
string dataobject = "d_pag_pre_pago_mto"
boolean hscrollbar = false
boolean vscrollbar = false
end type

event losefocus;THIS.accepttext( )

end event

event ue_keypress;IF key = KeyEnter! THEN
	THIS.accepttext( )
END IF
	
end event

event ue_captura_datos;call super::ue_captura_datos;st_cre_pre_pag lst_aux

ist_pre_pag = lst_aux
	
ist_pre_pag.ii_pre_pag_cod = 0
ist_pre_pag.is_cre_num_cre = is_num_cre
ist_pre_pag.id_pre_pag_fec = THIS.getitemdate(1, "fecha") 
ist_pre_pag.is_pre_pag_tipo = THIS.getitemstring(1, "tipo") 
ist_pre_pag.is_pre_pag_est = '0'
ist_pre_pag.id_pre_pag_fec_prox_ven = THIS.getitemdate(1, "fec_prox_ven") 
ist_pre_pag.idt_pre_pag_fec_act = guo_gen.fec_act_dt( )
ist_pre_pag.is_cod_usu = guo_gen.gs_cod_usu
ist_pre_pag.il_mov_nro_mov = THIS.getitemnumber(1, "mov_nro_mov") 
ist_pre_pag.is_mov_cod_ofi = THIS.getitemstring(1, "mov_cod_ofi") 

SETNULL(ist_pre_pag.id_pre_pag_fec_apl)

IF ist_pre_pag.id_pre_pag_fec < guo_gen.gd_fec_act THEN
	ist_pre_pag.it_pre_pag_hor = TiME('23:59:50')
	ist_pre_pag.id_pre_pag_fec_apl = guo_gen.gd_fec_act
ELSE
	ist_pre_pag.it_pre_pag_hor	= TIME (STRiNG(guo_gen.fec_act_dt( ),'hh:mm:ss'))
END IF

end event

event itemchanged;call super::itemchanged;INTEGER li_val, li_remp_ini, li_remp_fin

IF THIS.getcolumnname( ) = 'tipo' THEN
	li_val = THIS.getitemnumber( row, 'nro_cuo_pag')
	li_remp_ini = THIS.getitemnumber( row, 'nro_cuo_ini')
	li_remp_fin= THIS.getitemnumber( row, 'nro_cuo_fin')
		
	IF data ='2' THEN
		IF li_remp_ini >0 THEN
			THIS.setitem( row,  'nro_cuo_ini', li_remp_ini + li_val)
		ELSE
			THIS.setitem( row,  'nro_cuo_fin', li_remp_fin + li_val)			
		END IF
	ELSE
		IF li_remp_ini >0 THEN
			THIS.setitem( row,  'nro_cuo_ini', li_remp_ini - li_val)
		ELSE
			THIS.setitem( row,  'nro_cuo_fin', li_remp_fin - li_val)			
		END IF		
	END IF	
END IF

dw_c1.reset( )
dw_c2.reset( )
end event

type st_1 from statictext within w_pag_pre_pag
integer x = 1166
integer y = 412
integer width = 1394
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 12632256
string text = "Monto de Pre-Pago"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

type cb_nuevo from commandbutton within w_pag_pre_pag
integer x = 1490
integer y = 2240
integer width = 343
integer height = 100
integer taborder = 100
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
boolean enabled = false
string text = "Nuevo"
end type

event clicked;BOOLEAN lb_nuevo

IF ii_accion = 0  OR NOT ib_modificar THEN
	 wf_act_bot()
	 wf_limpiar_controles ()
	 
	 cb_buscar.event clicked( )
ELSE
	//Validamos datos del usuario
	IF NOT wf_valida_datos() THEN 
		RETURN
	END IF

	//Capturamos información
	dw_pag_mto.triggerevent("ue_captura_datos")
	dw_c1.triggerevent("ue_captura_datos")
	dw_c2.triggerevent("ue_captura_datos")
	dw_cuo_pre_pag.triggerevent("ue_captura_datos")
	
	//Procedemos a guardar información
	IF iuo_cre.grabar_pre_pagos(is_num_cre, ist_pre_pag, ist_cre,true) = 0 THEN
		MessageBox (gs_nomapl, "Los datos se guardaron correctamente")
		
		ii_accion = 0
		ib_modificar = FALSE
		wf_limpiar_controles ()		
		
		wf_bloquear_controles (TRUE)
	ELSE
		MessageBox (gs_nomapl, "Error al grabar la información.~r" + iuo_cre.is_error , Exclamation!)
	END IF

END IF

end event

type dw_c1 from uo_dw_mant within w_pag_pre_pag
event ue_key_press pbm_dwnkey
event ue_cron_libre_fecha ( integer ai_num_cuo,  date ad_fecha,  date ad_fecha_anterior )
event ue_cron_libre_cap ( integer ai_num_cuo,  decimal ar_cap_cuo,  decimal ar_cap_cuo_orig )
event ue_cron_libre_tot ( integer ai_num_cuo,  decimal ar_tot_cuo )
event ue_verifica_neg ( )
event ue_gen_cron ( decimal ar_mto_cred,  decimal ar_tea,  integer ai_ncuota,  integer ai_per,  date ad_fec_des )
event ue_fec_pri_ven ( date ad_fecha,  integer ai_dia_semana,  integer ai_per_gra,  integer ai_per_pag,  integer ai_nro_cuo,  decimal ar_mto_pres )
integer x = 2629
integer y = 120
integer width = 2624
integer height = 1120
integer taborder = 50
boolean bringtotop = true
string title = ""
string dataobject = "d_vent_lot_cuo_rea"
boolean hscrollbar = false
borderstyle borderstyle = stylelowered!
end type

event ue_cron_libre_fecha(integer ai_num_cuo, date ad_fecha, date ad_fecha_anterior);Long ll_i, ll_dia_fijo
Integer li_dias, li_nmeses = 0, li_resultado
Date ld_fecha, ld_fecha_aux_ant_cuo
Decimal{2} lr_monto, lr_interes = 0, lr_seg_des, lr_tot_cuo, lr_mon_cap_cuo, lr_itf = 0
Decimal{6} lr_tasa
Decimal{8} lr_por_des

ll_dia_fijo	= day(ad_fecha)
ld_fecha		= ad_fecha
lr_tasa 		= is_struct_ci.str_tasa
lr_por_des	= ist_gen_cro_lib.idec_por_des
li_dias 		= DaysAfter(ad_fecha_anterior, ad_fecha)
lr_monto		= THIS.getitemdecimal( ai_num_cuo, 'cuo_sal_cap')
lr_tot_cuo 	= THIS.getitemdecimal( ai_num_cuo, 'cuo_tot')
lr_interes 	= f_formulas(lr_monto, lr_tasa, li_dias, THIS.rowcount( ),  'iN'	)
li_nmeses 	= (Month(ad_fecha) - Month(ad_fecha_anterior))+ (Year(ad_fecha) - Year(ad_fecha_anterior))*12
lr_seg_des 	= ROUND(ROUND(( lr_monto * (lr_por_des / 100) ),2) * li_nmeses,2)

THIS.setitem( ai_num_cuo, 'cuo_car_des', lr_seg_des)
THIS.setitem( ai_num_cuo, 'cuo_int_com', lr_interes)

IF ai_num_cuo < THIS.rowcount( ) THEN
	lr_mon_cap_cuo = lr_tot_cuo - lr_interes - lr_seg_des
	IF lr_mon_cap_cuo < 0 THEN lr_mon_cap_cuo = 0	
ELSE
	lr_mon_cap_cuo = THIS.getitemdecimal( ai_num_cuo, 'cuo_sal_cap')
END IF
THIS.setitem( ai_num_cuo, 'cuo_cap_cuo', lr_mon_cap_cuo)

lr_tot_cuo = lr_mon_cap_cuo + lr_interes + lr_seg_des
IF lr_tot_cuo = guo_gen.gr_mon_min_itf THEN
	lr_itf = F_OBT_ITF(lr_tot_cuo, is_struct_ci.str_moneda)
	lr_tot_cuo = lr_tot_cuo + lr_itf
ELSEIF lr_tot_cuo > guo_gen.gr_mon_min_itf THEN
	IF MOD(lr_tot_cuo, guo_gen.gr_mon_min_itf) = 0 THEN
		lr_itf = int(lr_tot_cuo*guo_gen.gr_ITF*20)/20 - 0.05
	ELSE
		lr_itf = int(lr_tot_cuo*guo_gen.gr_ITF*20)/20
	END IF
END IF
THIS.setitem( ai_num_cuo, 'cuo_itf', lr_itf)
lr_mon_cap_cuo = F_IIF(lr_mon_cap_cuo - lr_itf < 0, lr_mon_cap_cuo, lr_mon_cap_cuo - lr_itf)	
THIS.setitem( ai_num_cuo, 'cuo_cap_cuo', lr_mon_cap_cuo)
THIS.setitem( ai_num_cuo, 'cuo_tot', lr_mon_cap_cuo + lr_interes + lr_seg_des  + lr_itf)

FOR ll_i = ai_num_cuo + 1 TO THIS.rowcount( )
	lr_itf = 0
	ld_fecha_aux_ant_cuo = ld_fecha
	ld_fecha = f_fec_sig_mes_habil(ld_fecha, li_dias, ad_fecha, 30, ll_dia_fijo)
	THIS.setitem( ll_i, 'cuo_sal_cap', THIS.getitemdecimal( ll_i - 1, 'cuo_sal_cap') - THIS.getitemdecimal( ll_i - 1, 'cuo_cap_cuo'))
	lr_monto = THIS.getitemdecimal( ll_i, 'cuo_sal_cap')
	THIS.setitem( ll_i, 'fec_pag_cuo', ld_fecha)
	lr_interes = f_formulas(lr_monto, lr_tasa, li_dias, THIS.rowcount( ),  'iN'	)
	THIS.setitem( ll_i, 'cuo_int_com', lr_interes)
	
	li_nmeses = (Month(ld_fecha) - Month(ld_fecha_aux_ant_cuo))+ (Year(ld_fecha) - Year(ld_fecha_aux_ant_cuo))*12
	lr_seg_des = ROUND(ROUND(( lr_monto * (lr_por_des / 100) ),2) * li_nmeses,2)	
	THIS.setitem( ll_i, 'cuo_car_des', lr_seg_des)
	lr_tot_cuo = THIS.getitemdecimal( ll_i, 'cuo_tot')
	IF lr_tot_cuo < lr_interes + lr_seg_des THEN
		lr_tot_cuo = lr_interes + lr_seg_des
		THIS.setitem(ll_i, 'cuo_tot', lr_tot_cuo)
	END IF
	
	IF ll_i = THIS.rowcount( ) THEN
		THIS.setitem( ll_i, 'cuo_cap_cuo', lr_monto)
		lr_mon_cap_cuo = THIS.getitemdecimal(ll_i, 'cuo_cap_cuo')
		lr_tot_cuo = lr_mon_cap_cuo + lr_interes + lr_seg_des
		lr_itf = F_OBT_ITF(lr_tot_cuo, is_struct_ci.str_moneda)
		THIS.setitem( ll_i, 'cuo_itf', lr_itf)
		THIS.setitem( ll_i, 'cuo_tot', lr_tot_cuo + lr_itf)
	ELSE
		THIS.setitem( ll_i, 'cuo_cap_cuo', lr_tot_cuo - lr_interes - lr_seg_des)
		lr_mon_cap_cuo = THIS.getitemdecimal(ll_i, 'cuo_cap_cuo')
		IF lr_tot_cuo = guo_gen.gr_mon_min_itf THEN
			lr_itf = F_OBT_ITF(lr_tot_cuo, is_struct_ci.str_moneda)
			lr_tot_cuo = lr_tot_cuo + lr_itf
		ELSEIF lr_tot_cuo > guo_gen.gr_mon_min_itf THEN
			IF MOD(lr_tot_cuo, guo_gen.gr_mon_min_itf) = 0 THEN
				lr_itf = int(lr_tot_cuo*guo_gen.gr_ITF*20)/20 - 0.05
			ELSE
				lr_itf = int(lr_tot_cuo*guo_gen.gr_ITF*20)/20
			END IF
		END IF	
		THIS.setitem( ll_i, 'cuo_itf', lr_itf)
		lr_mon_cap_cuo = F_IIF(lr_mon_cap_cuo - lr_itf < 0, lr_mon_cap_cuo, lr_mon_cap_cuo - lr_itf)	
		THIS.setitem( ll_i, 'cuo_cap_cuo', lr_mon_cap_cuo)
		THIS.setitem( ll_i, 'cuo_tot', lr_mon_cap_cuo + lr_interes + lr_seg_des + lr_itf)
	END IF
NEXT

THIS.accepttext( )
this.event ue_verifica_neg()

end event

event ue_cron_libre_cap(integer ai_num_cuo, decimal ar_cap_cuo, decimal ar_cap_cuo_orig);Long ll_i
Integer li_dias, li_nmeses = 0, li_resultado
Date ld_fecha_ant, ld_fecha
Decimal{2} lr_monto, lr_interes = 0, lr_seg_des, lr_tot_cuo, lr_mon_cap_cuo, lr_itf = 0
Decimal{6} lr_tasa
Decimal{8} lr_por_des

ib_neg = false
lr_tasa 		= is_struct_ci.str_tasa
lr_por_des	= ist_gen_cro_lib.idec_por_des
lr_interes 	= THIS.getitemdecimal(ai_num_cuo, 'cuo_int_com')
lr_seg_des 	= THIS.getitemdecimal(ai_num_cuo, 'cuo_car_des')

lr_tot_cuo = ar_cap_cuo + lr_interes + lr_seg_des
lr_itf = F_OBT_ITF(lr_tot_cuo, is_struct_ci.str_moneda)
THIS.setitem( ai_num_cuo, 'cuo_itf', lr_itf)
THIS.setitem( ai_num_cuo, 'cuo_tot', lr_tot_cuo + lr_itf)

FOR ll_i = ai_num_cuo + 1 TO THIS.rowcount( )
	lr_itf = 0
	ld_fecha_ant = THIS.getitemdate(ll_i - 1, 'cuo_fec_ven')
	ld_fecha = THIS.getitemdate(ll_i, 'cuo_fec_ven')
	IF ll_i = ai_num_cuo + 1 THEN
		THIS.setitem( ll_i, 'cuo_sal_cap', THIS.getitemdecimal( ll_i - 1, 'cuo_sal_cap') - ar_cap_cuo)
	ELSE
		THIS.setitem( ll_i, 'cuo_sal_cap', THIS.getitemdecimal( ll_i - 1, 'cuo_sal_cap') - THIS.getitemdecimal( ll_i - 1, 'cuo_cap_cuo'))
	END IF
	lr_monto = THIS.getitemdecimal( ll_i, 'cuo_sal_cap')
	li_dias = DaysAfter(ld_fecha_ant, ld_fecha)
	lr_interes = f_formulas(lr_monto, lr_tasa, li_dias, THIS.rowcount( ),  'iN'	)
	THIS.setitem( ll_i, 'cuo_int_com', lr_interes)
	
	li_nmeses = (Month(ld_fecha) - Month(ld_fecha_ant))+ (Year(ld_fecha) - Year(ld_fecha_ant))*12
	lr_seg_des = ROUND(ROUND(( lr_monto * (lr_por_des / 100) ),2) * li_nmeses,2)	
	THIS.setitem( ll_i, 'cuo_car_des', lr_seg_des)
		
	lr_tot_cuo = THIS.getitemdecimal( ll_i, 'cuo_tot')	
	
	IF ll_i = THIS.rowcount( ) THEN
		THIS.setitem( ll_i, 'cuo_cap_cuo', lr_monto)
		lr_mon_cap_cuo = THIS.getitemdecimal( ll_i, 'cuo_cap_cuo')
		lr_tot_cuo = lr_mon_cap_cuo + lr_interes + lr_seg_des
		lr_itf = F_OBT_ITF(lr_tot_cuo, is_struct_ci.str_moneda)
		THIS.setitem( ll_i, 'cuo_itf', lr_itf)
		THIS.setitem( ll_i, 'cuo_tot', lr_tot_cuo + lr_itf)
	ELSE
		THIS.setitem( ll_i, 'cuo_cap_cuo', lr_tot_cuo - lr_interes - lr_seg_des)
		lr_mon_cap_cuo = THIS.getitemdecimal( ll_i, 'cuo_cap_cuo')
		lr_tot_cuo = lr_mon_cap_cuo + lr_interes + lr_seg_des
		IF lr_tot_cuo = guo_gen.gr_mon_min_itf THEN
			lr_itf = F_OBT_ITF(lr_tot_cuo, is_struct_ci.str_moneda)
			lr_tot_cuo = lr_tot_cuo + lr_itf
		ELSEIF lr_tot_cuo > guo_gen.gr_mon_min_itf THEN
			IF guo_gen.gr_mon_min_itf = 0 THEN
				lr_itf = int(lr_tot_cuo*guo_gen.gr_ITF*20)/20
			ELSE
				IF MOD(lr_tot_cuo, guo_gen.gr_mon_min_itf) = 0 THEN
					lr_itf = int(lr_tot_cuo*guo_gen.gr_ITF*20)/20 - 0.05
				ELSE
					lr_itf = int(lr_tot_cuo*guo_gen.gr_ITF*20)/20
				END IF
			END IF
		END IF	
		THIS.setitem( ll_i, 'cuo_itf', lr_itf)
		lr_mon_cap_cuo = F_IIF(lr_mon_cap_cuo - lr_itf < 0, lr_mon_cap_cuo, lr_mon_cap_cuo - lr_itf)
		THIS.setitem( ll_i, 'cuo_cap_cuo', lr_mon_cap_cuo)
		THIS.setitem( ll_i, 'cuo_tot', lr_mon_cap_cuo + lr_interes + lr_seg_des + lr_itf)
	END IF		
NEXT

THIS.accepttext( )
this.event ue_verifica_neg()

end event

event ue_cron_libre_tot(integer ai_num_cuo, decimal ar_tot_cuo);Long ll_i
Integer li_dias, li_nmeses = 0, li_resultado, li_rpta
Date ld_fecha_ant, ld_fecha
Decimal{2} lr_monto, lr_interes = 0, lr_seg_des, lr_tot_cuo, lr_mon_cap_cuo, lr_itf = 0
Decimal{6} lr_tasa
Decimal{8} lr_por_des

ib_neg = false
lr_tasa 		= is_struct_ci.str_tasa
lr_por_des	= ist_gen_cro_lib.idec_por_des
lr_interes 	= THIS.getitemdecimal(ai_num_cuo, 'cuo_int_com')
lr_seg_des 	= THIS.getitemdecimal(ai_num_cuo, 'cuo_car_des')
lr_mon_cap_cuo = ar_tot_cuo - lr_interes - lr_seg_des

IF ar_tot_cuo >= guo_gen.gr_mon_min_itf AND ar_tot_cuo < guo_gen.gr_mon_min_itf + 0.05 THEN	
	lr_itf = F_OBT_ITF(guo_gen.gr_mon_min_itf, is_struct_ci.str_moneda)
	ar_tot_cuo = guo_gen.gr_mon_min_itf + lr_itf	
ELSEIF ar_tot_cuo > guo_gen.gr_mon_min_itf THEN
	IF guo_gen.gr_mon_min_itf = 0 THEN
		lr_itf = int(ar_tot_cuo*guo_gen.gr_ITF*20)/20
	ELSE
		IF MOD(ar_tot_cuo, guo_gen.gr_mon_min_itf) = 0 THEN
			lr_itf = int(ar_tot_cuo*guo_gen.gr_ITF*20)/20 - 0.05
		ELSE
			lr_itf = int(ar_tot_cuo*guo_gen.gr_ITF*20)/20
		END IF
	END IF
END IF
THIS.setitem( ai_num_cuo, 'cuo_itf', lr_itf)
lr_mon_cap_cuo = F_IIF(lr_mon_cap_cuo - lr_itf < 0, lr_mon_cap_cuo, lr_mon_cap_cuo - lr_itf)
THIS.setitem( ai_num_cuo, 'cuo_tot', ar_tot_cuo)
THIS.setitem( ai_num_cuo, 'cuo_cap_cuo', ar_tot_cuo - lr_interes - lr_seg_des - lr_itf)

IF THIS.getitemdecimal( ai_num_cuo, 'cuo_cap_cuo') < 0 THEN ib_neg = true

li_rpta = messagebox(gs_nomapl, '¿Desea replicar el monto total en las cuotas siguientes?', Question!, YesNo!,2)

IF NOT ib_neg THEN	
	FOR ll_i = ai_num_cuo + 1 TO THIS.rowcount( )
		lr_itf = 0
		ld_fecha_ant = THIS.getitemdate(ll_i - 1, 'cuo_fec_ven')
		ld_fecha = THIS.getitemdate(ll_i, 'cuo_fec_ven')
		THIS.setitem( ll_i, 'cuo_sal_cap', THIS.getitemdecimal( ll_i - 1, 'cuo_sal_cap') - THIS.getitemdecimal( ll_i - 1, 'cuo_cap_cuo'))
		lr_monto = THIS.getitemdecimal( ll_i, 'cuo_sal_cap')
		li_dias = DaysAfter(ld_fecha_ant, ld_fecha)
		lr_interes = f_formulas(lr_monto, lr_tasa, li_dias, THIS.rowcount( ),  'iN'	)
		THIS.setitem( ll_i, 'cuo_int_com', lr_interes)
		
		li_nmeses = (Month(ld_fecha) - Month(ld_fecha_ant))+ (Year(ld_fecha) - Year(ld_fecha_ant))*12
		lr_seg_des = ROUND(ROUND(( lr_monto * (lr_por_des / 100) ),2) * li_nmeses,2)	
		THIS.setitem( ll_i, 'cuo_car_des', lr_seg_des)
		
		IF li_rpta = 1 THEN
			lr_tot_cuo = ar_tot_cuo
			IF lr_tot_cuo < lr_interes + lr_seg_des THEN lr_tot_cuo = lr_interes + lr_seg_des
		ELSE
			lr_tot_cuo = THIS.getitemdecimal( ll_i, 'cuo_tot')
		END IF
		
		IF ll_i = THIS.rowcount( ) THEN
			lr_mon_cap_cuo = lr_monto
			THIS.setitem( ll_i, 'cuo_cap_cuo', lr_mon_cap_cuo)
			lr_itf = F_OBT_ITF(lr_mon_cap_cuo + lr_interes + lr_seg_des, is_struct_ci.str_moneda)
			THIS.setitem( ll_i, 'cuo_itf', lr_itf)
			THIS.setitem( ll_i, 'cuo_tot', lr_mon_cap_cuo + lr_interes + lr_seg_des + lr_itf)
		ELSE
			lr_mon_cap_cuo = lr_tot_cuo - lr_interes - lr_seg_des			
			THIS.setitem( ll_i, 'cuo_cap_cuo', lr_mon_cap_cuo)
			IF lr_tot_cuo = guo_gen.gr_mon_min_itf THEN
				lr_itf = F_OBT_ITF(lr_tot_cuo, is_struct_ci.str_moneda)
				lr_tot_cuo = lr_tot_cuo + lr_itf
			ELSEIF lr_tot_cuo > guo_gen.gr_mon_min_itf THEN
				IF MOD(lr_tot_cuo, guo_gen.gr_mon_min_itf) = 0 THEN
					lr_itf = int(lr_tot_cuo*guo_gen.gr_ITF*20)/20 - 0.05
				ELSE
					lr_itf = int(lr_tot_cuo*guo_gen.gr_ITF*20)/20
				END IF
			END IF	
			THIS.setitem( ll_i, 'cuo_itf', lr_itf)
			lr_mon_cap_cuo = F_IIF(lr_mon_cap_cuo - lr_itf < 0, lr_mon_cap_cuo, lr_mon_cap_cuo - lr_itf)
			THIS.setitem( ll_i, 'cuo_cap_cuo', lr_mon_cap_cuo)
			THIS.setitem( ll_i, 'cuo_tot', lr_mon_cap_cuo + lr_interes + lr_seg_des + lr_itf)
		END IF		
	NEXT
END IF

THIS.accepttext( )
this.event ue_verifica_neg()

end event

event ue_verifica_neg();Long ll_pos
Integer li_resultado

THIS.accepttext( )

IF THIS.rowcount( ) <= 0 THEN
	RETURN
END IF

ll_pos = THIS.find( "cuo_sal_cap < 0 OR cuo_cap_cuo < 0 OR cuo_int_com < 0 OR cuo_tot < 0", 1, THIS.rowcount())

st_error.visible = ll_pos > 0
this.object.b_back.visible = st_error.visible
cb_nuevo.enabled = not st_error.visible

/*IF ll_pos <= 0 THEN
	dw_c2_aux.reset( )
	li_resultado = THIS.rowscopy( 1, THIS.rowcount(), Primary!, dw_c2_aux, 1, Primary!)
	IF li_resultado = -1 THEN
		Messagebox(gs_nomapl,"Error al copiar los datos", Exclamation!)
	END IF
END IF*/

end event

event ue_gen_cron(decimal ar_mto_cred, decimal ar_tea, integer ai_ncuota, integer ai_per, date ad_fec_des);Decimal{6} ldec_por_des, lr_sal_cap
Date ld_fec_des, ld_fec_pri_ven, ld_fec_pri_ven_orig, ld_fec_pri_ven_fij
String ls_tip_cre, ls_sub_tip_cre_pro
Integer li_dia_pag_fij, li_i, li_resultado
Boolean lb_existe_fec_ven

IF (ar_mto_cred > 0 and ai_ncuota = 0 ) THEN
	RETURN
ELSE
	
	is_struct_ci.str_monto = ar_mto_cred
	is_struct_ci.str_tasa = ar_tea
	is_struct_ci.str_ncuota = ai_ncuota
	is_struct_ci.str_periodo = ai_per
	is_struct_ci.is_tip_per_gra = '02'
	is_struct_ci.str_tip_des = '1'
	is_struct_ci.str_codpro = 172
	is_struct_ci.str_ind_int = f_iif(is_struct_ci.is_tip_per_gra='02','1','0')
	is_struct_ci.str_seg_inc = '1'
	
	ist_gen_cro_lib.idec_por_des  = 0
	ist_gen_cro_lib.ii_dia_pag_fij =  DAY(dw_pag_mto.getitemdate(1, 'fec_prox_ven') ) //DAY(ad_fec_des)
	ist_gen_cro_lib.is_tip_cre = '10'
	ist_gen_cro_lib.is_sub_tip_cre_pro ='001'
	ist_gen_cro_lib.ib_existe_fec_ven = false
	ist_gen_cro_lib.id_fec_pri_ven_fij =  dw_pag_mto.getitemdate(1, 'fec_prox_ven') 
	
	//THIS.event ue_fec_pri_ven(ad_fec_des, DayNumber(ad_fec_des), 0, ai_per, ai_ncuota, ar_mto_cred)
	 ist_gen_cro_lib.id_fec_pri_ven = dw_pag_mto.getitemdate(1, 'fec_prox_ven') 
	 ist_gen_cro_lib.id_fec_pri_ven_orig =dw_pag_mto.getitemdate(1, 'fec_prox_ven') 
	 
	ldec_por_des 	= ist_gen_cro_lib.idec_por_des
	ld_fec_des 		= ad_fec_des
	ld_fec_pri_ven = ist_gen_cro_lib.id_fec_pri_ven
	ld_fec_pri_ven_orig = ist_gen_cro_lib.id_fec_pri_ven_orig
	ls_tip_cre		= ist_gen_cro_lib.is_tip_cre
	li_dia_pag_fij 	= ist_gen_cro_lib.ii_dia_pag_fij
	ls_sub_tip_cre_pro = ist_gen_cro_lib.is_sub_tip_cre_pro
	lb_existe_fec_ven 	= ist_gen_cro_lib.ib_existe_fec_ven
	ld_fec_pri_ven_fij 	= ist_gen_cro_lib.id_fec_pri_ven_fij
	
	//Obtenemos Cronograma
	ist_ven = f_cre_cron_prod(is_struct_ci, ldec_por_des, ld_fec_des, ld_fec_pri_ven, ld_fec_pri_ven_orig, ls_tip_cre, &
										li_dia_pag_fij,  lb_existe_fec_ven, ld_fec_pri_ven_fij)
	
	ist_cuo_cron = ist_ven.ist_cuo_cron
	
	IF UPPERBOUND(ist_cuo_cron) <= 0 THEN
		messagebox(gs_nomapl, 'No se podrá generar cronograma inicial')
		RETURN
	END IF
	
	lr_sal_cap = dw_pag_mto.getitemdecimal( 1, 'mto_cron') 
	
	//Llenamos Dw de cuotas
	THIS.setredraw( false)
	THIS.reset( )
	FOR li_i = 1 TO UPPERBOUND(ist_cuo_cron)
		THIS.insertrow( 0)
		THIS.setitem(li_i, 'cuo_nro_cuo', li_i)
		THIS.setitem(li_i, 'cuo_fec_ven', ist_cuo_cron[li_i].id_fec_pag_cuo)
		THIS.setitem(li_i, 'cuo_sal_cap', lr_sal_cap)
		THIS.setitem(li_i, 'cuo_cap_cuo', ist_cuo_cron[li_i].idec_mon_cap_cuo)
		THIS.setitem(li_i, 'cuo_int_com', ist_cuo_cron[li_i].idec_mon_int_cuo)
		THIS.setitem(li_i, 'cuo_car_des', ist_cuo_cron[li_i].idec_mon_int_com_cuo)
		THIS.setitem(li_i, 'cuo_itf', ist_cuo_cron[li_i].idec_itf)
		THIS.setitem(li_i, 'cuo_tot', THIS.getitemdecimal(li_i,'cmp_mon_tot') )
		THIS.setitem(li_i, 'cuo_tip_cron', '0' )
		
		lr_sal_cap = lr_sal_cap - ist_cuo_cron[li_i].idec_mon_cap_cuo
	NEXT
	THIS.accepttext( )
	THIS.GroupCalc()
	THIS.setredraw( true)
	
	THIS.event ue_verifica_neg()
END IF
end event

event ue_fec_pri_ven(date ad_fecha, integer ai_dia_semana, integer ai_per_gra, integer ai_per_pag, integer ai_nro_cuo, decimal ar_mto_pres);//FECHAS PRIMER VENC Y PRIMERA CUOTA
st_pri_ven lst

lst = f_datos_pri_ven(ad_fecha , ai_nro_cuo, ai_per_pag, ar_mto_pres, '01', ai_per_gra, DAY(ad_fecha)) //01:Gracia Absoluta

IF lst.ib_correcto THEN
	ist_gen_cro_lib.id_fec_pri_ven = lst.id_fec_pri_ven 
	ist_gen_cro_lib.id_fec_pri_ven_orig = lst.id_fec_ven_base
else
	messagebox(gs_nomapl, lst.is_mensaje)
end if
end event

event itemchanged;STRING ls_column
DATE ld_fec_pag, ld_fecha_ant
DECIMAL {2} lr_valor, lr_valor_aux
INTEGER li_resultado

ls_column = this.getcolumnname( )
	
CHOOSE CASE ls_column
	/*CASE 'b_back'		
		THIS.reset( )
		li_resultado = dw_c2_aux.rowscopy( 1, dw_c2_aux.rowcount(), Primary!, THIS, 1, Primary!)
		IF li_resultado = -1 THEN
			Messagebox(gs_nomapl,"Error al revertir los datos", Exclamation!)
		END IF
		
		THIS.Object.b_back.visible = false
		st_error.visible = false
		cb_nuevo.enabled = true
		ib_reset = false*/

	CASE 'cuo_fec_ven'
		//Validamos que fecha sea correcta
		IF ISNULL(data) THEN
			messagebox(gs_nomapl, 'Fecha de pago no es válida', Information!)
			RETURN 2
		END IF
		
		ld_fec_pag = DATE(data)
		//Obtenemos fecha anterior
		IF row > 1 THEN
			ld_fecha_ant = this.getitemdate( row - 1, 'cuo_fec_ven')
		ELSE
			ld_fecha_ant = ist_gen_cro_lib.id_fec_des
		END IF		
		//Validamos que fecha nueva sea mayor que fecha anterior
		IF ld_fec_pag <= ld_fecha_ant THEN
			IF row > 1 THEN
				messagebox(gs_nomapl, 'Fecha de pago ingresada debe ser mayor a fecha de pago anterior', Information!)
			ELSE
				messagebox(gs_nomapl, 'Fecha de pago ingresada debe ser mayor a fecha de desembolso', Information!)
			END IF
			RETURN 2
		END IF		
		//Verificamos que día elegido no sea domingo ni feriado
		IF f_verif_feriado(ld_fec_pag) OR (dayname(ld_fec_pag) = 'Sunday' OR dayname(ld_fec_pag) = 'Domingo') THEN
			messagebox(gs_nomapl, 'Fecha de pago ingresada no puede ser domingo ni feriado', Information!)
			RETURN 2
		END IF
		//Mostramos mensaje si dias atranscurridos < 30
		IF DaysAfter(ld_fecha_ant, ld_fec_pag) < 30 AND DAY(ld_fecha_ant) <> DAY(ld_fec_pag) THEN
			IF row > 1 THEN
				messagebox(gs_nomapl, 'Fecha ingresada es muy próxima a la fecha de cuota anterior', Information!)
			ELSE
				messagebox(gs_nomapl, 'Fecha ingresada no debe ser muy próxima a la fecha de desembolso', Information!)
				RETURN 2
			END IF
		END IF
		//Recalculamos cronograma
		this.event ue_cron_libre_fecha(row, ld_fec_pag, ld_fecha_ant)
		
	CASE 'cuo_cap_cuo'
		IF row = this.rowcount( ) THEN
			messagebox(gs_nomapl, 'Valor de última cuota no puede modificarse', Information!)
			RETURN 2
		END IF
		lr_valor_aux = this.getitemdecimal( row, 'cuo_cap_cuo')
		lr_valor = dec(data)
		IF lr_valor < 0 THEN
			messagebox(gs_nomapl, 'Amortización de capital no debe ser negativo', Information!)
			RETURN 2
		END IF		
		this.event ue_cron_libre_cap(row, lr_valor, lr_valor_aux)
	CASE 'cuo_tot'
		IF row = this.rowcount( ) THEN
			messagebox(gs_nomapl, 'Valor de última cuota no puede modificarse', Information!)
			RETURN 2
		END IF
		lr_valor_aux = this.getitemdecimal( row, 'cuo_cap_cuo')
		lr_valor = dec(data)
		IF lr_valor <= 0 THEN
			messagebox(gs_nomapl, 'Monto total debe ser mayor a cero', Information!)
			RETURN 2
		END IF
		IF lr_valor < this.getitemdecimal( row, 'cuo_int_com') + this.getitemdecimal( row, 'cuo_car_des') + this.getitemdecimal( row, 'cuo_itf') THEN
			messagebox(gs_nomapl, 'Monto total debe ser mayor a la suma del Interés + Seg. Desg. + ITF', Information!)
			RETURN 2
		END IF
		this.event ue_cron_libre_tot(row, lr_valor)
END CHOOSE
this.accepttext( )

IF ls_column = 'cuo_tot' THEN
	IF ((MOD(lr_valor, guo_gen.gr_mon_min_itf) = 0) OR (lr_valor >= guo_gen.gr_mon_min_itf AND lr_valor < guo_gen.gr_mon_min_itf + 0.05)) THEN
		this.setitem( row, 'cuo_tot', this.getitemdecimal(row,'cuo_cap_cuo') + this.getitemdecimal(row,'cuo_int_com') + this.getitemdecimal(row,'cuo_car_des') + this.getitemdecimal(row,'cuo_itf'))
		RETURN 2
	END IF
END IF

end event

event rowfocuschanged;call super::rowfocuschanged;if THIS.rowcount( )> 0 then
	if THIS.getrow () = 0 then
		THIS.selectrow (1, TRUE)
	else
		THIS.selectrow (0, FALSE)
		THIS.selectrow (THIS.getrow (), TRUE)
	end if
end if
end event

event ue_captura_datos;st_cre_cuo lst_aux[]
INTEGER i

//Limpiamos estructura
ist_cre.ist_cre_cuo_c1 = lst_aux

IF THIS.getitemdecimal( 1, 'cmp_cap_cuo') > 0 THEN	
	//Capturamos datos
	FOR i = 1 To THIS.rowcount( )
		ist_cre.ist_cre_cuo_c1[i].is_cre_num_cre = ''
		ist_cre.ist_cre_cuo_c1[i].ii_cuo_nro_cuo = THIS.getitemnumber(i,  'cuo_nro_cuo')
		ist_cre.ist_cre_cuo_c1[i].id_cuo_fec_ven  = THIS.getitemdate(i,  'cuo_fec_ven')
		ist_cre.ist_cre_cuo_c1[i].ir_cuo_sal_cap = THIS.getitemdecimal(i,  'cuo_sal_cap')
		ist_cre.ist_cre_cuo_c1[i].ir_cuo_cap_cuo = THIS.getitemdecimal(i,  'cuo_cap_cuo')
		ist_cre.ist_cre_cuo_c1[i].ir_cuo_int_com = THIS.getitemdecimal(i,  'cuo_int_com')
		ist_cre.ist_cre_cuo_c1[i].ir_cuo_car_des = THIS.getitemdecimal(i,  'cuo_car_des')
		ist_cre.ist_cre_cuo_c1[i].ir_cuo_itf = THIS.getitemdecimal(i,  'cuo_itf')
		ist_cre.ist_cre_cuo_c1[i].is_cuo_tip_cron = THIS.getitemstring( i,  'cuo_tip_cron')
	NEXT
END IF

end event

type dw_c2 from uo_dw_mant within w_pag_pre_pag
event ue_key_press pbm_dwnkey
event ue_cron_libre_fecha ( integer ai_num_cuo,  date ad_fecha,  date ad_fecha_anterior )
event ue_cron_libre_cap ( integer ai_num_cuo,  decimal ar_cap_cuo,  decimal ar_cap_cuo_orig )
event ue_cron_libre_tot ( integer ai_num_cuo,  decimal ar_tot_cuo )
event ue_verifica_neg ( )
event ue_gen_cron ( decimal ar_mto_cred,  decimal ar_tea,  integer ai_ncuota,  integer ai_per,  date ad_fec_des )
event ue_fec_pri_ven ( date ad_fecha,  integer ai_dia_semana,  integer ai_per_gra,  integer ai_per_pag,  integer ai_nro_cuo,  decimal ar_mto_pres )
integer x = 2629
integer y = 1240
integer width = 2624
integer height = 1120
integer taborder = 40
boolean bringtotop = true
string title = ""
string dataobject = "d_vent_lot_cuo_rea"
boolean hscrollbar = false
borderstyle borderstyle = stylelowered!
end type

event ue_cron_libre_fecha(integer ai_num_cuo, date ad_fecha, date ad_fecha_anterior);Long ll_i, ll_dia_fijo
Integer li_dias, li_nmeses = 0, li_resultado
Date ld_fecha, ld_fecha_aux_ant_cuo
Decimal{2} lr_monto, lr_interes = 0, lr_seg_des, lr_tot_cuo, lr_mon_cap_cuo, lr_itf = 0
Decimal{6} lr_tasa
Decimal{8} lr_por_des

ll_dia_fijo	= day(ad_fecha)
ld_fecha		= ad_fecha
lr_tasa 		= is_struct.str_tasa
lr_por_des	= ist_gen_cro_lib.idec_por_des
li_dias 		= DaysAfter(ad_fecha_anterior, ad_fecha)
lr_monto		= THIS.getitemdecimal( ai_num_cuo, 'cuo_sal_cap')
lr_tot_cuo 	= THIS.getitemdecimal( ai_num_cuo, 'cuo_tot')
lr_interes 	= f_formulas(lr_monto, lr_tasa, li_dias, THIS.rowcount( ),  'iN'	)
li_nmeses 	= (Month(ad_fecha) - Month(ad_fecha_anterior))+ (Year(ad_fecha) - Year(ad_fecha_anterior))*12
lr_seg_des 	= ROUND(ROUND(( lr_monto * (lr_por_des / 100) ),2) * li_nmeses,2)

THIS.setitem( ai_num_cuo, 'cuo_car_des', lr_seg_des)
THIS.setitem( ai_num_cuo, 'cuo_int_com', lr_interes)

IF ai_num_cuo < THIS.rowcount( ) THEN
	lr_mon_cap_cuo = lr_tot_cuo - lr_interes - lr_seg_des
	IF lr_mon_cap_cuo < 0 THEN lr_mon_cap_cuo = 0	
ELSE
	lr_mon_cap_cuo = THIS.getitemdecimal( ai_num_cuo, 'cuo_sal_cap')
END IF
THIS.setitem( ai_num_cuo, 'cuo_cap_cuo', lr_mon_cap_cuo)

lr_tot_cuo = lr_mon_cap_cuo + lr_interes + lr_seg_des
IF lr_tot_cuo = guo_gen.gr_mon_min_itf THEN
	lr_itf = F_OBT_ITF(lr_tot_cuo, is_struct.str_moneda)
	lr_tot_cuo = lr_tot_cuo + lr_itf
ELSEIF lr_tot_cuo > guo_gen.gr_mon_min_itf THEN
	IF MOD(lr_tot_cuo, guo_gen.gr_mon_min_itf) = 0 THEN
		lr_itf = int(lr_tot_cuo*guo_gen.gr_ITF*20)/20 - 0.05
	ELSE
		lr_itf = int(lr_tot_cuo*guo_gen.gr_ITF*20)/20
	END IF
END IF
THIS.setitem( ai_num_cuo, 'cuo_itf', lr_itf)
lr_mon_cap_cuo = F_IIF(lr_mon_cap_cuo - lr_itf < 0, lr_mon_cap_cuo, lr_mon_cap_cuo - lr_itf)	
THIS.setitem( ai_num_cuo, 'cuo_cap_cuo', lr_mon_cap_cuo)
THIS.setitem( ai_num_cuo, 'cuo_tot', lr_mon_cap_cuo + lr_interes + lr_seg_des  + lr_itf)

FOR ll_i = ai_num_cuo + 1 TO THIS.rowcount( )
	lr_itf = 0
	ld_fecha_aux_ant_cuo = ld_fecha
	ld_fecha = f_fec_sig_mes_habil(ld_fecha, li_dias, ad_fecha, 30, ll_dia_fijo)
	THIS.setitem( ll_i, 'cuo_sal_cap', THIS.getitemdecimal( ll_i - 1, 'cuo_sal_cap') - THIS.getitemdecimal( ll_i - 1, 'cuo_cap_cuo'))
	lr_monto = THIS.getitemdecimal( ll_i, 'cuo_sal_cap')
	THIS.setitem( ll_i, 'fec_pag_cuo', ld_fecha)
	lr_interes = f_formulas(lr_monto, lr_tasa, li_dias, THIS.rowcount( ),  'iN'	)
	THIS.setitem( ll_i, 'cuo_int_com', lr_interes)
	
	li_nmeses = (Month(ld_fecha) - Month(ld_fecha_aux_ant_cuo))+ (Year(ld_fecha) - Year(ld_fecha_aux_ant_cuo))*12
	lr_seg_des = ROUND(ROUND(( lr_monto * (lr_por_des / 100) ),2) * li_nmeses,2)	
	THIS.setitem( ll_i, 'cuo_car_des', lr_seg_des)
	lr_tot_cuo = THIS.getitemdecimal( ll_i, 'cuo_tot')
	IF lr_tot_cuo < lr_interes + lr_seg_des THEN
		lr_tot_cuo = lr_interes + lr_seg_des
		THIS.setitem(ll_i, 'cuo_tot', lr_tot_cuo)
	END IF
	
	IF ll_i = THIS.rowcount( ) THEN
		THIS.setitem( ll_i, 'cuo_cap_cuo', lr_monto)
		lr_mon_cap_cuo = THIS.getitemdecimal(ll_i, 'cuo_cap_cuo')
		lr_tot_cuo = lr_mon_cap_cuo + lr_interes + lr_seg_des
		lr_itf = F_OBT_ITF(lr_tot_cuo, is_struct.str_moneda)
		THIS.setitem( ll_i, 'cuo_itf', lr_itf)
		THIS.setitem( ll_i, 'cuo_tot', lr_tot_cuo + lr_itf)
	ELSE
		THIS.setitem( ll_i, 'cuo_cap_cuo', lr_tot_cuo - lr_interes - lr_seg_des)
		lr_mon_cap_cuo = THIS.getitemdecimal(ll_i, 'cuo_cap_cuo')
		IF lr_tot_cuo = guo_gen.gr_mon_min_itf THEN
			lr_itf = F_OBT_ITF(lr_tot_cuo, is_struct.str_moneda)
			lr_tot_cuo = lr_tot_cuo + lr_itf
		ELSEIF lr_tot_cuo > guo_gen.gr_mon_min_itf THEN
			IF MOD(lr_tot_cuo, guo_gen.gr_mon_min_itf) = 0 THEN
				lr_itf = int(lr_tot_cuo*guo_gen.gr_ITF*20)/20 - 0.05
			ELSE
				lr_itf = int(lr_tot_cuo*guo_gen.gr_ITF*20)/20
			END IF
		END IF	
		THIS.setitem( ll_i, 'cuo_itf', lr_itf)
		lr_mon_cap_cuo = F_IIF(lr_mon_cap_cuo - lr_itf < 0, lr_mon_cap_cuo, lr_mon_cap_cuo - lr_itf)	
		THIS.setitem( ll_i, 'cuo_cap_cuo', lr_mon_cap_cuo)
		THIS.setitem( ll_i, 'cuo_tot', lr_mon_cap_cuo + lr_interes + lr_seg_des + lr_itf)
	END IF
NEXT

THIS.accepttext( )
this.event ue_verifica_neg()

end event

event ue_cron_libre_cap(integer ai_num_cuo, decimal ar_cap_cuo, decimal ar_cap_cuo_orig);Long ll_i
Integer li_dias, li_nmeses = 0, li_resultado
Date ld_fecha_ant, ld_fecha
Decimal{2} lr_monto, lr_interes = 0, lr_seg_des, lr_tot_cuo, lr_mon_cap_cuo, lr_itf = 0
Decimal{6} lr_tasa
Decimal{8} lr_por_des

ib_neg = false
lr_tasa 		= is_struct.str_tasa
lr_por_des	= ist_gen_cro_lib.idec_por_des
lr_interes 	= THIS.getitemdecimal(ai_num_cuo, 'cuo_int_com')
lr_seg_des 	= THIS.getitemdecimal(ai_num_cuo, 'cuo_car_des')

lr_tot_cuo = ar_cap_cuo + lr_interes + lr_seg_des
lr_itf = F_OBT_ITF(lr_tot_cuo, is_struct.str_moneda)
THIS.setitem( ai_num_cuo, 'cuo_itf', lr_itf)
THIS.setitem( ai_num_cuo, 'cuo_tot', lr_tot_cuo + lr_itf)

FOR ll_i = ai_num_cuo + 1 TO THIS.rowcount( )
	lr_itf = 0
	ld_fecha_ant = THIS.getitemdate(ll_i - 1, 'cuo_fec_ven')
	ld_fecha = THIS.getitemdate(ll_i, 'cuo_fec_ven')
	IF ll_i = ai_num_cuo + 1 THEN
		THIS.setitem( ll_i, 'cuo_sal_cap', THIS.getitemdecimal( ll_i - 1, 'cuo_sal_cap') - ar_cap_cuo)
	ELSE
		THIS.setitem( ll_i, 'cuo_sal_cap', THIS.getitemdecimal( ll_i - 1, 'cuo_sal_cap') - THIS.getitemdecimal( ll_i - 1, 'cuo_cap_cuo'))
	END IF
	lr_monto = THIS.getitemdecimal( ll_i, 'cuo_sal_cap')
	li_dias = DaysAfter(ld_fecha_ant, ld_fecha)
	lr_interes = f_formulas(lr_monto, lr_tasa, li_dias, THIS.rowcount( ),  'iN'	)
	THIS.setitem( ll_i, 'cuo_int_com', lr_interes)
	
	li_nmeses = (Month(ld_fecha) - Month(ld_fecha_ant))+ (Year(ld_fecha) - Year(ld_fecha_ant))*12
	lr_seg_des = ROUND(ROUND(( lr_monto * (lr_por_des / 100) ),2) * li_nmeses,2)	
	THIS.setitem( ll_i, 'cuo_car_des', lr_seg_des)
		
	lr_tot_cuo = THIS.getitemdecimal( ll_i, 'cuo_tot')	
	
	IF ll_i = THIS.rowcount( ) THEN
		THIS.setitem( ll_i, 'cuo_cap_cuo', lr_monto)
		lr_mon_cap_cuo = THIS.getitemdecimal( ll_i, 'cuo_cap_cuo')
		lr_tot_cuo = lr_mon_cap_cuo + lr_interes + lr_seg_des
		lr_itf = F_OBT_ITF(lr_tot_cuo, is_struct.str_moneda)
		THIS.setitem( ll_i, 'cuo_itf', lr_itf)
		THIS.setitem( ll_i, 'cuo_tot', lr_tot_cuo + lr_itf)
	ELSE
		THIS.setitem( ll_i, 'cuo_cap_cuo', lr_tot_cuo - lr_interes - lr_seg_des)
		lr_mon_cap_cuo = THIS.getitemdecimal( ll_i, 'cuo_cap_cuo')
		lr_tot_cuo = lr_mon_cap_cuo + lr_interes + lr_seg_des
		IF lr_tot_cuo = guo_gen.gr_mon_min_itf THEN
			lr_itf = F_OBT_ITF(lr_tot_cuo, is_struct.str_moneda)
			lr_tot_cuo = lr_tot_cuo + lr_itf
		ELSEIF lr_tot_cuo > guo_gen.gr_mon_min_itf THEN
			IF guo_gen.gr_mon_min_itf = 0 THEN
				lr_itf = int(lr_tot_cuo*guo_gen.gr_ITF*20)/20
			ELSE
				IF MOD(lr_tot_cuo, guo_gen.gr_mon_min_itf) = 0 THEN
					lr_itf = int(lr_tot_cuo*guo_gen.gr_ITF*20)/20 - 0.05
				ELSE
					lr_itf = int(lr_tot_cuo*guo_gen.gr_ITF*20)/20
				END IF
			END IF
		END IF	
		THIS.setitem( ll_i, 'cuo_itf', lr_itf)
		lr_mon_cap_cuo = F_IIF(lr_mon_cap_cuo - lr_itf < 0, lr_mon_cap_cuo, lr_mon_cap_cuo - lr_itf)
		THIS.setitem( ll_i, 'cuo_cap_cuo', lr_mon_cap_cuo)
		THIS.setitem( ll_i, 'cuo_tot', lr_mon_cap_cuo + lr_interes + lr_seg_des + lr_itf)
	END IF		
NEXT

THIS.accepttext( )
this.event ue_verifica_neg()

end event

event ue_cron_libre_tot(integer ai_num_cuo, decimal ar_tot_cuo);Long ll_i
Integer li_dias, li_nmeses = 0, li_resultado, li_rpta
Date ld_fecha_ant, ld_fecha
Decimal{2} lr_monto, lr_interes = 0, lr_seg_des, lr_tot_cuo, lr_mon_cap_cuo, lr_itf = 0
Decimal{6} lr_tasa
Decimal{8} lr_por_des

ib_neg = false
lr_tasa 		= is_struct.str_tasa
lr_por_des	= ist_gen_cro_lib.idec_por_des
lr_interes 	= THIS.getitemdecimal(ai_num_cuo, 'cuo_int_com')
lr_seg_des 	= THIS.getitemdecimal(ai_num_cuo, 'cuo_car_des')
lr_mon_cap_cuo = ar_tot_cuo - lr_interes - lr_seg_des

IF ar_tot_cuo >= guo_gen.gr_mon_min_itf AND ar_tot_cuo < guo_gen.gr_mon_min_itf + 0.05 THEN	
	lr_itf = F_OBT_ITF(guo_gen.gr_mon_min_itf, is_struct.str_moneda)
	ar_tot_cuo = guo_gen.gr_mon_min_itf + lr_itf	
ELSEIF ar_tot_cuo > guo_gen.gr_mon_min_itf THEN
	IF guo_gen.gr_mon_min_itf = 0 THEN
		lr_itf = int(ar_tot_cuo*guo_gen.gr_ITF*20)/20
	ELSE
		IF MOD(ar_tot_cuo, guo_gen.gr_mon_min_itf) = 0 THEN
			lr_itf = int(ar_tot_cuo*guo_gen.gr_ITF*20)/20 - 0.05
		ELSE
			lr_itf = int(ar_tot_cuo*guo_gen.gr_ITF*20)/20
		END IF
	END IF
END IF
THIS.setitem( ai_num_cuo, 'cuo_itf', lr_itf)
lr_mon_cap_cuo = F_IIF(lr_mon_cap_cuo - lr_itf < 0, lr_mon_cap_cuo, lr_mon_cap_cuo - lr_itf)
THIS.setitem( ai_num_cuo, 'cuo_tot', ar_tot_cuo)
THIS.setitem( ai_num_cuo, 'cuo_cap_cuo', ar_tot_cuo - lr_interes - lr_seg_des - lr_itf)

IF THIS.getitemdecimal( ai_num_cuo, 'cuo_cap_cuo') < 0 THEN ib_neg = true

li_rpta = messagebox(gs_nomapl, '¿Desea replicar el monto total en las cuotas siguientes?', Question!, YesNo!,2)

IF NOT ib_neg THEN	
	FOR ll_i = ai_num_cuo + 1 TO THIS.rowcount( )
		lr_itf = 0
		ld_fecha_ant = THIS.getitemdate(ll_i - 1, 'cuo_fec_ven')
		ld_fecha = THIS.getitemdate(ll_i, 'cuo_fec_ven')
		THIS.setitem( ll_i, 'cuo_sal_cap', THIS.getitemdecimal( ll_i - 1, 'cuo_sal_cap') - THIS.getitemdecimal( ll_i - 1, 'cuo_cap_cuo'))
		lr_monto = THIS.getitemdecimal( ll_i, 'cuo_sal_cap')
		li_dias = DaysAfter(ld_fecha_ant, ld_fecha)
		lr_interes = f_formulas(lr_monto, lr_tasa, li_dias, THIS.rowcount( ),  'iN'	)
		THIS.setitem( ll_i, 'cuo_int_com', lr_interes)
		
		li_nmeses = (Month(ld_fecha) - Month(ld_fecha_ant))+ (Year(ld_fecha) - Year(ld_fecha_ant))*12
		lr_seg_des = ROUND(ROUND(( lr_monto * (lr_por_des / 100) ),2) * li_nmeses,2)	
		THIS.setitem( ll_i, 'cuo_car_des', lr_seg_des)
		
		IF li_rpta = 1 THEN
			lr_tot_cuo = ar_tot_cuo
			IF lr_tot_cuo < lr_interes + lr_seg_des THEN lr_tot_cuo = lr_interes + lr_seg_des
		ELSE
			lr_tot_cuo = THIS.getitemdecimal( ll_i, 'cuo_tot')
		END IF
		
		IF ll_i = THIS.rowcount( ) THEN
			lr_mon_cap_cuo = lr_monto
			THIS.setitem( ll_i, 'cuo_cap_cuo', lr_mon_cap_cuo)
			lr_itf = F_OBT_ITF(lr_mon_cap_cuo + lr_interes + lr_seg_des, is_struct.str_moneda)
			THIS.setitem( ll_i, 'cuo_itf', lr_itf)
			THIS.setitem( ll_i, 'cuo_tot', lr_mon_cap_cuo + lr_interes + lr_seg_des + lr_itf)
		ELSE
			lr_mon_cap_cuo = lr_tot_cuo - lr_interes - lr_seg_des			
			THIS.setitem( ll_i, 'cuo_cap_cuo', lr_mon_cap_cuo)
			IF lr_tot_cuo = guo_gen.gr_mon_min_itf THEN
				lr_itf = F_OBT_ITF(lr_tot_cuo, is_struct.str_moneda)
				lr_tot_cuo = lr_tot_cuo + lr_itf
			ELSEIF lr_tot_cuo > guo_gen.gr_mon_min_itf THEN
				IF MOD(lr_tot_cuo, guo_gen.gr_mon_min_itf) = 0 THEN
					lr_itf = int(lr_tot_cuo*guo_gen.gr_ITF*20)/20 - 0.05
				ELSE
					lr_itf = int(lr_tot_cuo*guo_gen.gr_ITF*20)/20
				END IF
			END IF	
			THIS.setitem( ll_i, 'cuo_itf', lr_itf)
			lr_mon_cap_cuo = F_IIF(lr_mon_cap_cuo - lr_itf < 0, lr_mon_cap_cuo, lr_mon_cap_cuo - lr_itf)
			THIS.setitem( ll_i, 'cuo_cap_cuo', lr_mon_cap_cuo)
			THIS.setitem( ll_i, 'cuo_tot', lr_mon_cap_cuo + lr_interes + lr_seg_des + lr_itf)
		END IF		
	NEXT
END IF

THIS.accepttext( )
this.event ue_verifica_neg()

end event

event ue_verifica_neg();Long ll_pos
Integer li_resultado

THIS.accepttext( )

IF THIS.rowcount( ) <= 0 THEN
	RETURN
END IF

ll_pos = THIS.find( "cuo_sal_cap < 0 OR cuo_cap_cuo < 0 OR cuo_int_com < 0 OR cuo_tot < 0", 1, THIS.rowcount())

st_error.visible = ll_pos > 0
this.object.b_back.visible = st_error.visible
cb_nuevo.enabled = not st_error.visible

/*IF ll_pos <= 0 THEN
	dw_c2_aux.reset( )
	li_resultado = THIS.rowscopy( 1, THIS.rowcount(), Primary!, dw_c2_aux, 1, Primary!)
	IF li_resultado = -1 THEN
		Messagebox(gs_nomapl,"Error al copiar los datos", Exclamation!)
	END IF
END IF*/

end event

event ue_gen_cron(decimal ar_mto_cred, decimal ar_tea, integer ai_ncuota, integer ai_per, date ad_fec_des);Decimal{6} ldec_por_des
DECIMAL {2} lr_mto_cuo_inic
Date ld_fec_des, ld_fec_pri_ven, ld_fec_pri_ven_orig, ld_fec_pri_ven_fij
String ls_tip_cre, ls_sub_tip_cre_pro
Integer li_dia_pag_fij, li_i, li_resultado
Boolean lb_existe_fec_ven

IF ar_tea <= 0 THEN
	messagebox(gs_nomapl, 'Debe ingresar el valor de la TEA', Information!)
	RETURN
ELSE
	
	is_struct.str_monto = ar_mto_cred
	is_struct.str_tasa = ar_tea
	is_struct.str_ncuota = ai_ncuota
	is_struct.str_periodo = ai_per
	is_struct.is_tip_per_gra = '02'
	is_struct.str_tip_des = '1'
	is_struct.str_codpro = 172
	is_struct.str_ind_int = f_iif(is_struct.is_tip_per_gra='02','1','0')
	is_struct.str_seg_inc = '1'
	
	ist_gen_cro_lib.idec_por_des  = 0
	ist_gen_cro_lib.ii_dia_pag_fij =  DAY(dw_pag_mto.getitemdate(1, 'fec_prox_ven')) //DAY(ad_fec_des)
	ist_gen_cro_lib.is_tip_cre = '10'
	ist_gen_cro_lib.is_sub_tip_cre_pro ='001'
	ist_gen_cro_lib.ib_existe_fec_ven = false
	//ist_gen_cro_lib.id_fec_pri_ven_fij = ad_fec_des
		
	lr_mto_cuo_inic = dw_pag_mto.getitemdecimal( 1, 'mto_ini')
	if isnull(lr_mto_cuo_inic) then lr_mto_cuo_inic = 0
	IF lr_mto_cuo_inic > 0 THEN
		THIS.event ue_fec_pri_ven(ad_fec_des, ist_gen_cro_lib.ii_dia_pag_fij, 0, ai_per, ai_ncuota, ar_mto_cred) //DayNumber(ad_fec_des)
	ELSE
		 ist_gen_cro_lib.id_fec_pri_ven = dw_pag_mto.getitemdate(1, 'fec_prox_ven') 
		 ist_gen_cro_lib.id_fec_pri_ven_orig =dw_pag_mto.getitemdate(1, 'fec_prox_ven') 
	END IF	
	
	ist_gen_cro_lib.id_fec_pri_ven_fij = ist_gen_cro_lib.id_fec_pri_ven
	
	ldec_por_des 	= ist_gen_cro_lib.idec_por_des
	ld_fec_des 		= ad_fec_des
	ld_fec_pri_ven = ist_gen_cro_lib.id_fec_pri_ven
	ld_fec_pri_ven_orig = ist_gen_cro_lib.id_fec_pri_ven_orig
	ls_tip_cre		= ist_gen_cro_lib.is_tip_cre
	li_dia_pag_fij 	= ist_gen_cro_lib.ii_dia_pag_fij
	ls_sub_tip_cre_pro = ist_gen_cro_lib.is_sub_tip_cre_pro
	lb_existe_fec_ven 	= ist_gen_cro_lib.ib_existe_fec_ven
	ld_fec_pri_ven_fij 	= ist_gen_cro_lib.id_fec_pri_ven_fij
	
	//Obtenemos Cronograma
	ist_ven = f_cre_cron_prod(is_struct, ldec_por_des, ld_fec_des, ld_fec_pri_ven, ld_fec_pri_ven_orig, ls_tip_cre, &
										li_dia_pag_fij,  lb_existe_fec_ven, ld_fec_pri_ven_fij)
	
	ist_cuo_cron = ist_ven.ist_cuo_cron
	
	IF UPPERBOUND(ist_cuo_cron) <= 0 THEN
		messagebox(gs_nomapl, 'No se podrá generar cronograma inicial')
		RETURN
	END IF
	
	//Llenamos Dw de cuotas
	THIS.setredraw( false)
	THIS.reset( )
	FOR li_i = 1 TO UPPERBOUND(ist_cuo_cron)
		THIS.insertrow( 0)
		THIS.setitem(li_i, 'cuo_nro_cuo', li_i +il_nro_cuo)
		THIS.setitem(li_i, 'cuo_fec_ven', ist_cuo_cron[li_i].id_fec_pag_cuo)
		THIS.setitem(li_i, 'cuo_sal_cap', ist_cuo_cron[li_i].idec_sal_cap_cuo)
		THIS.setitem(li_i, 'cuo_cap_cuo', ist_cuo_cron[li_i].idec_mon_cap_cuo)
		THIS.setitem(li_i, 'cuo_int_com', ist_cuo_cron[li_i].idec_mon_int_cuo)
		THIS.setitem(li_i, 'cuo_car_des', ist_cuo_cron[li_i].idec_mon_int_com_cuo)
		THIS.setitem(li_i, 'cuo_itf', ist_cuo_cron[li_i].idec_itf)
		THIS.setitem(li_i, 'cuo_tot', THIS.getitemdecimal(li_i,'cmp_mon_tot') )
		THIS.setitem(li_i, 'cuo_tip_cron', '1' )
	NEXT
	THIS.accepttext( )
	THIS.GroupCalc()
	
	THIS.setredraw( true)
	
	THIS.event ue_verifica_neg()
END IF
end event

event ue_fec_pri_ven(date ad_fecha, integer ai_dia_semana, integer ai_per_gra, integer ai_per_pag, integer ai_nro_cuo, decimal ar_mto_pres);//FECHAS PRIMER VENC Y PRIMERA CUOTA
st_pri_ven lst

lst = f_datos_pri_ven(ad_fecha , ai_nro_cuo, ai_per_pag, ar_mto_pres, '01', ai_per_gra, DAY(ad_fecha)) //01:Gracia Absoluta

IF lst.ib_correcto THEN
	ist_gen_cro_lib.id_fec_pri_ven = lst.id_fec_pri_ven 
	ist_gen_cro_lib.id_fec_pri_ven_orig = lst.id_fec_ven_base
else
	messagebox(gs_nomapl, lst.is_mensaje)
end if
end event

event itemchanged;STRING ls_column
DATE ld_fec_pag, ld_fecha_ant
DECIMAL {2} lr_valor, lr_valor_aux
INTEGER li_resultado

ls_column = this.getcolumnname( )
	
CHOOSE CASE ls_column
	/*CASE 'b_back'		
		THIS.reset( )
		li_resultado = dw_c2_aux.rowscopy( 1, dw_c2_aux.rowcount(), Primary!, THIS, 1, Primary!)
		IF li_resultado = -1 THEN
			Messagebox(gs_nomapl,"Error al revertir los datos", Exclamation!)
		END IF
		
		THIS.Object.b_back.visible = false
		st_error.visible = false
		cb_nuevo.enabled = true
		ib_reset = false*/

	CASE 'cuo_fec_ven'
		//Validamos que fecha sea correcta
		IF ISNULL(data) THEN
			messagebox(gs_nomapl, 'Fecha de pago no es válida', Information!)
			RETURN 2
		END IF
		
		ld_fec_pag = DATE(data)
		//Obtenemos fecha anterior
		IF row > 1 THEN
			ld_fecha_ant = this.getitemdate( row - 1, 'cuo_fec_ven')
		ELSE
			ld_fecha_ant = ist_gen_cro_lib.id_fec_des
		END IF		
		//Validamos que fecha nueva sea mayor que fecha anterior
		IF ld_fec_pag <= ld_fecha_ant THEN
			IF row > 1 THEN
				messagebox(gs_nomapl, 'Fecha de pago ingresada debe ser mayor a fecha de pago anterior', Information!)
			ELSE
				messagebox(gs_nomapl, 'Fecha de pago ingresada debe ser mayor a fecha de desembolso', Information!)
			END IF
			RETURN 2
		END IF		
		//Verificamos que día elegido no sea domingo ni feriado
		IF f_verif_feriado(ld_fec_pag) OR (dayname(ld_fec_pag) = 'Sunday' OR dayname(ld_fec_pag) = 'Domingo') THEN
			messagebox(gs_nomapl, 'Fecha de pago ingresada no puede ser domingo ni feriado', Information!)
			RETURN 2
		END IF
		//Mostramos mensaje si dias atranscurridos < 30
		IF DaysAfter(ld_fecha_ant, ld_fec_pag) < 30 AND DAY(ld_fecha_ant) <> DAY(ld_fec_pag) THEN
			IF row > 1 THEN
				messagebox(gs_nomapl, 'Fecha ingresada es muy próxima a la fecha de cuota anterior', Information!)
			ELSE
				messagebox(gs_nomapl, 'Fecha ingresada no debe ser muy próxima a la fecha de desembolso', Information!)
				RETURN 2
			END IF
		END IF
		//Recalculamos cronograma
		this.event ue_cron_libre_fecha(row, ld_fec_pag, ld_fecha_ant)
		
	CASE 'cuo_cap_cuo'
		IF row = this.rowcount( ) THEN
			messagebox(gs_nomapl, 'Valor de última cuota no puede modificarse', Information!)
			RETURN 2
		END IF
		lr_valor_aux = this.getitemdecimal( row, 'cuo_cap_cuo')
		lr_valor = dec(data)
		IF lr_valor < 0 THEN
			messagebox(gs_nomapl, 'Amortización de capital no debe ser negativo', Information!)
			RETURN 2
		END IF		
		this.event ue_cron_libre_cap(row, lr_valor, lr_valor_aux)
	CASE 'cuo_tot'
		IF row = this.rowcount( ) THEN
			messagebox(gs_nomapl, 'Valor de última cuota no puede modificarse', Information!)
			RETURN 2
		END IF
		lr_valor_aux = this.getitemdecimal( row, 'cuo_cap_cuo')
		lr_valor = dec(data)
		IF lr_valor <= 0 THEN
			messagebox(gs_nomapl, 'Monto total debe ser mayor a cero', Information!)
			RETURN 2
		END IF
		IF lr_valor < this.getitemdecimal( row, 'cuo_int_com') + this.getitemdecimal( row, 'cuo_car_des') + this.getitemdecimal( row, 'cuo_itf') THEN
			messagebox(gs_nomapl, 'Monto total debe ser mayor a la suma del Interés + Seg. Desg. + ITF', Information!)
			RETURN 2
		END IF
		this.event ue_cron_libre_tot(row, lr_valor)
END CHOOSE
this.accepttext( )

IF ls_column = 'cuo_tot' THEN
	IF ((MOD(lr_valor, guo_gen.gr_mon_min_itf) = 0) OR (lr_valor >= guo_gen.gr_mon_min_itf AND lr_valor < guo_gen.gr_mon_min_itf + 0.05)) THEN
		this.setitem( row, 'cuo_tot', this.getitemdecimal(row,'cuo_cap_cuo') + this.getitemdecimal(row,'cuo_int_com') + this.getitemdecimal(row,'cuo_car_des') + this.getitemdecimal(row,'cuo_itf'))
		RETURN 2
	END IF
END IF

end event

event rowfocuschanged;call super::rowfocuschanged;if THIS.rowcount( )> 0 then
	if THIS.getrow () = 0 then
		THIS.selectrow (1, TRUE)
	else
		THIS.selectrow (0, FALSE)
		THIS.selectrow (THIS.getrow (), TRUE)
	end if
end if
end event

event ue_captura_datos;st_cre_cuo lst_aux[]
INTEGER i

//Limpiamos estructura
ist_cre.ist_cre_cuo_c2 = lst_aux

//Capturamos datos
FOR i = 1 To THIS.rowcount( )
	ist_cre.ist_cre_cuo_c2[i].is_cre_num_cre = ''
	ist_cre.ist_cre_cuo_c2[i].ii_cuo_nro_cuo = THIS.getitemnumber(i,  'cuo_nro_cuo')
	ist_cre.ist_cre_cuo_c2[i].id_cuo_fec_ven  = THIS.getitemdate(i,  'cuo_fec_ven')
	ist_cre.ist_cre_cuo_c2[i].ir_cuo_sal_cap = THIS.getitemdecimal(i,  'cuo_sal_cap')
	ist_cre.ist_cre_cuo_c2[i].ir_cuo_cap_cuo = THIS.getitemdecimal(i,  'cuo_cap_cuo')
	ist_cre.ist_cre_cuo_c2[i].ir_cuo_int_com = THIS.getitemdecimal(i,  'cuo_int_com')
	ist_cre.ist_cre_cuo_c2[i].ir_cuo_car_des = THIS.getitemdecimal(i,  'cuo_car_des')
	ist_cre.ist_cre_cuo_c2[i].ir_cuo_itf = THIS.getitemdecimal(i,  'cuo_itf')
	ist_cre.ist_cre_cuo_c2[i].is_cuo_tip_cron = THIS.getitemstring( i,  'cuo_tip_cron')
NEXT
end event

type cb_cron from commandbutton within w_pag_pre_pag
integer x = 1239
integer y = 1464
integer width = 517
integer height = 100
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Generar Cronograma"
end type

event clicked;DECIMAL {2} lr_mto, lr_mto_cuo_inic, lr_mto_int
DECIMAL {4} lr_tea
INTEGER li_nro_cuo, li_nro_per, li, li_val
DATE ld_fec_des

il_nro_cuo =0
li_nro_per = 30 //dw_man.getitemdecimal( 1, 'cre_tea')

//Cronograma Cuota Inicial
lr_mto_cuo_inic = dw_pag_mto.getitemdecimal( 1, 'mto_ini')
if isnull(lr_mto_cuo_inic) then lr_mto_cuo_inic = 0
IF lr_mto_cuo_inic > 0 THEN
	ld_fec_des = dw_pag_mto.getitemdate( 1, 'fec_ult_pag') 
	lr_tea = 0
	li_nro_cuo = dw_pag_mto.getitemdecimal( 1, 'nro_cuo_ini')	
	dw_c1.event ue_gen_cron( lr_mto_cuo_inic, lr_tea, li_nro_cuo, li_nro_per, ld_fec_des)
	
	ld_fec_des = dw_c1.getitemdate( dw_c1.rowcount( ),  'cuo_fec_ven')
	il_nro_cuo = dw_c1.rowcount( )
ELSE
	ld_fec_des = dw_pag_mto.getitemdate( 1, 'fec_ult_pag') 
END IF


//Cronograma Final
lr_mto = dw_pag_mto.getitemdecimal( 1, 'mto_cron') //- lr_mto_cuo_inic
lr_tea = dw_pag_mto.getitemdecimal( 1, 'tea')
li_nro_cuo = dw_pag_mto.getitemdecimal( 1, 'nro_cuo_fin')

dw_c2.event ue_gen_cron( lr_mto, lr_tea, li_nro_cuo, li_nro_per, ld_fec_des)

lr_mto_int = dw_c2.getitemdecimal( 1, 'cmp_tot_int')
dw_pag_mto.setitem(1, 'cre_tot_int', lr_mto_int) 
dw_pag_mto.accepttext( )


//Reordena nro de cuotas
li_val = dw_cuo_pre_pag.rowcount( )
li_val ++

For li = 1 to dw_c1.rowcount( )
	dw_c1.setitem( li, 'cuo_nro_cuo', li_val)
	li_val ++
	SetPointer(Hourglass!)
Next

For li = 1 to dw_c2.rowcount( )
	dw_c2.setitem( li, 'cuo_nro_cuo', li_val)
	li_val ++	
	SetPointer(Hourglass!)
Next


end event

type st_error from statictext within w_pag_pre_pag
boolean visible = false
integer x = 283
integer y = 1924
integer width = 1778
integer height = 64
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean italic = true
long textcolor = 16711680
long backcolor = 67108864
string text = "Cronograma no podrá registrarse con montos negativos. Verifique."
boolean focusrectangle = false
end type

type dw_cuo_pre_pag from datawindow within w_pag_pre_pag
event ue_captura_datos ( )
boolean visible = false
integer x = 2039
integer y = 1676
integer width = 329
integer height = 344
integer taborder = 110
boolean bringtotop = true
boolean titlebar = true
string title = "none"
string dataobject = "d_cre_cuo_pre_pag"
boolean controlmenu = true
boolean resizable = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event ue_captura_datos();st_cre_cuo_pre lst_aux[]
INTEGER i

//Limpiamos estructura
ist_cre.ist_cre_cuo_pre = lst_aux

//Capturamos datos
FOR i = 1 To THIS.rowcount( )
	ist_cre.ist_cre_cuo_pre[i].is_cre_num_cre = ''
	ist_cre.ist_cre_cuo_pre[i].ii_cuo_nro_cuo = THIS.getitemnumber(i,  'cuo_nro_cuo')
	ist_cre.ist_cre_cuo_pre[i].id_cuo_fec_ven  = THIS.getitemdate(i,  'cuo_fec_ven')
	ist_cre.ist_cre_cuo_pre[i].is_cuo_ind_est_cuo  = THIS.getitemstring(i,  'cuo_ind_est_cuo')
	ist_cre.ist_cre_cuo_pre[i].ir_cuo_sal_cap = THIS.getitemdecimal(i,  'cuo_sal_cap')
	ist_cre.ist_cre_cuo_pre[i].ir_cuo_cap_cuo = THIS.getitemdecimal(i,  'cuo_cap_cuo')
	ist_cre.ist_cre_cuo_pre[i].ir_cuo_int_com = THIS.getitemdecimal(i,  'cuo_int_com')
	ist_cre.ist_cre_cuo_pre[i].ir_cuo_int_mor = THIS.getitemdecimal(i,  'cuo_int_mor')	
	ist_cre.ist_cre_cuo_pre[i].ir_cuo_car_des = THIS.getitemdecimal(i,  'cuo_car_des')
	ist_cre.ist_cre_cuo_pre[i].ir_cuo_itf = THIS.getitemdecimal(i,  'cuo_itf')
	ist_cre.ist_cre_cuo_pre[i].is_cuo_tip_cron = THIS.getitemstring( i,  'cuo_tip_cron')
	ist_cre.ist_cre_cuo_pre[i].id_cuo_fec_pag_cuo  = THIS.getitemdate(i,  'cuo_fec_pag_cuo')	
	ist_cre.ist_cre_cuo_pre[i].ir_cuo_cap_cuo_pag = THIS.getitemdecimal(i,  'cuo_cap_cuo_pag')
	ist_cre.ist_cre_cuo_pre[i].ir_cuo_int_com_pag = THIS.getitemdecimal(i,  'cuo_int_com_pag')
	ist_cre.ist_cre_cuo_pre[i].ir_cuo_int_mor_pag = THIS.getitemdecimal(i,  'cuo_int_mor_pag')
	ist_cre.ist_cre_cuo_pre[i].ir_cuo_car_des_pag = THIS.getitemdecimal(i,  'cuo_car_des_pag')
	ist_cre.ist_cre_cuo_pre[i].id_cuo_fec_act_cuo  = THIS.getitemdate(i,  'cuo_fec_act_cuo')
NEXT

end event

type gb_gral from groupbox within w_pag_pre_pag
integer x = 23
integer y = 20
integer width = 2569
integer height = 2196
integer taborder = 10
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 16777215
long backcolor = 67108864
end type

