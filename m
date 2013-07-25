From: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Subject: [iptables-nftables - RFC v2 PATCH  04/17] nft: Add nft expressions translation engine as a library
Date: Thu, 25 Jul 2013 20:16:24 +0300
Message-ID: <1374772597-20548-5-git-send-email-tomasz.bursztyka@linux.intel.com>
References: <1374772597-20548-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:53512 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756427Ab3GYRQs (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 25 Jul 2013 13:16:48 -0400
In-Reply-To: <1374772597-20548-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

libnfttrans is a generic translation engine from nft expressions to
registered "complex instructions". It works on a simple tree based
pattern matching algorithm.

Idea is to be able to register any kind of expressions suit (or pattern=
)
linked to a parsing function representing the "complex instruction".
Then, being able to go through the whole expression list of a rule and
retrieving the original complex instructions suit.

This will fix at once the parsing of a rule, taking into account
current compatilbe layer for extentions but also their pure nft version=
=2E
As soon as an expression will implement its method to express itself as
pur nft expression the change will be totally transparent.

Once applied on xtables (iptables over nftables), this will allow to
retrieve the exact iptables_command_state structure for instance.
However, such engine is generic enough to be reused in any other tool,
like future arptables and ebtables compatible tool over nftables.

Signed-off-by: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
---
 Makefile.am                       |   3 +
 configure.ac                      |   1 +
 include/nft-translator.h          |  81 ++++++
 libnfttrans/.nft-translator.c.swp | Bin 0 -> 28672 bytes
 libnfttrans/Makefile.am           |  28 ++
 libnfttrans/libnfttrans.pc        |  11 +
 libnfttrans/libnfttrans.pc.in     |  11 +
 libnfttrans/nft-translator.c      | 571 ++++++++++++++++++++++++++++++=
++++++++
 8 files changed, 706 insertions(+)
 create mode 100644 include/nft-translator.h
 create mode 100644 libnfttrans/.nft-translator.c.swp
 create mode 100644 libnfttrans/Makefile.am
 create mode 100644 libnfttrans/libnfttrans.pc
 create mode 100644 libnfttrans/libnfttrans.pc.in
 create mode 100644 libnfttrans/nft-translator.c

diff --git a/Makefile.am b/Makefile.am
index c38d360..fa762d4 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -4,6 +4,9 @@ ACLOCAL_AMFLAGS  =3D -I m4
 AUTOMAKE_OPTIONS =3D foreign subdir-objects
=20
 SUBDIRS          =3D libiptc libxtables
+if ENABLE_NFTABLES
+SUBDIRS		+=3D libnfttrans
+endif
 if ENABLE_DEVEL
 SUBDIRS         +=3D include
 endif
diff --git a/configure.ac b/configure.ac
index 68f661c..4ca6f65 100644
--- a/configure.ac
+++ b/configure.ac
@@ -207,6 +207,7 @@ AC_CONFIG_FILES([Makefile extensions/GNUmakefile in=
clude/Makefile
 	libiptc/Makefile libiptc/libiptc.pc
 	libiptc/libip4tc.pc libiptc/libip6tc.pc
 	libxtables/Makefile utils/Makefile
+	libnfttrans/Makefile libnfttrans/libnfttrans.pc
 	include/xtables-version.h include/iptables/internal.h])
 AC_OUTPUT
=20
diff --git a/include/nft-translator.h b/include/nft-translator.h
new file mode 100644
index 0000000..318f248
--- /dev/null
+++ b/include/nft-translator.h
@@ -0,0 +1,81 @@
+/*
+ * (C) 2013 by Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
+ *
+ * This program is free software; you can redistribute it and/or modif=
y
+ * it under the terms of the GNU General Public License as published b=
y
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#ifndef _NFT_TRANSLATOR_H
+#define _NFT_TRANSLATOR_H
+
+#include <stdint.h>
+#include <libnftables/rule.h>
+#include <libnftables/expr.h>
+
+enum nft_instruction {
+	NFT_INSTRUCTION_BITWISE   =3D 0,
+	NFT_INSTRUCTION_BYTEORDER =3D 1,
+	NFT_INSTRUCTION_CMP       =3D 2,
+	NFT_INSTRUCTION_COUNTER   =3D 3,
+	NFT_INSTRUCTION_CT        =3D 4,
+	NFT_INSTRUCTION_EXTHDR    =3D 5,
+	NFT_INSTRUCTION_IMMEDIATE =3D 6,
+	NFT_INSTRUCTION_LIMIT     =3D 7,
+	NFT_INSTRUCTION_LOG       =3D 8,
+	NFT_INSTRUCTION_LOOKUP    =3D 9,
+	NFT_INSTRUCTION_MATCH     =3D 10,
+	NFT_INSTRUCTION_META      =3D 11,
+	NFT_INSTRUCTION_NAT       =3D 12,
+	NFT_INSTRUCTION_PAYLOAD   =3D 13,
+	NFT_INSTRUCTION_REJECT    =3D 14,
+	NFT_INSTRUCTION_TARGET    =3D 15,
+	NFT_INSTRUCTION_MAX       =3D 16,
+};
+
+struct nft_trans_instruction_tree;
+struct nft_trans_rule_context;
+struct nft_trans_instruction_context;
+
+typedef int (*nft_trans_parse_callback_f)(const char *ident,
+					  void *data,
+					  void *user_data);
+
+typedef int
+(*nft_trans_parse_instruction_f)(struct nft_trans_rule_context *rule_c=
tx,
+				 struct nft_trans_instruction_context *first,
+				 struct nft_trans_instruction_context *last,
+				 nft_trans_parse_callback_f user_cb,
+				 void *user_data);
+
+struct nft_trans_instruction {
+	enum nft_instruction *instructions;
+	nft_trans_parse_instruction_f function;
+};
+
+struct nft_trans_instruction_tree *nft_trans_instruction_tree_new(void=
);
+
+void
+nft_trans_instruction_tree_destroy(struct nft_trans_instruction_tree *=
tree);
+
+int nft_trans_add_instruction(struct nft_trans_instruction_tree *tree,
+			      struct nft_trans_instruction *ipt_i);
+
+int
+nft_trans_rule_translate_to_instructions(struct nft_trans_instruction_=
tree *tree,
+					 struct nft_rule *rule,
+					 nft_trans_parse_callback_f user_cb,
+					 void *user_data);
+
+struct nft_trans_instruction_context *
+nft_trans_instruction_context_get_next(struct nft_trans_instruction_co=
ntext *i_ctx);
+
+struct nft_rule_expr *
+nft_trans_instruction_context_get_expr(struct nft_trans_instruction_co=
ntext *i_ctx);
+
+struct nft_rule_expr *
+nft_trans_instruction_context_get_register(struct nft_trans_instructio=
n_context *i_ctx,
+					   int reg);
+
+#endif /* _NFT_TRANSLATOR_H */
diff --git a/libnfttrans/.nft-translator.c.swp b/libnfttrans/.nft-trans=
lator.c.swp
new file mode 100644
index 0000000000000000000000000000000000000000..0f94354ee52aee937427989=
2aa9b04fe93da0dcd
GIT binary patch
literal 28672
zcmeI4eUKc*b--7cuQf&pa0TLuVGtPK9eW=3DV5g-o99MU13eIG)c09(fEz1=3Dz8z~1g<
zXI9eb0AZ_uN({)PY+MBnlmjLh98B570+NdDP*M?7#vzo8fH46KHsuc-Q53c-5a;*0
zr)PV1XYWHH`opzb`ssFidb(e~e%&+uUeAp6Trx1^oZWS1iqDc%>gBWcUv%1U4oNLq
zoJs}d$(+AK4$S_k6grok(=3D&S>IeLvQuzN$Le1)42{BCb5$c+_Uzq2&1zjPP9F}??t
zT*>d|OQ-r)%mw92SAOmaS~*%8XlWo>1Jz)>^PHnoXD(l+M(U|cPjQYvZc}pJR%%NF
zEe*6Z(9%Fl11$}-G|<vOO9L$p{84Hkm^v)Ala?J4w(gej@1nZDhljuaI{bTg-SI=3Di
z-#3PTSB3?cat;gAr^CN{>yE!COg}#Sds!%uIX_Hp{b^~SrGb_PS{i6+prwJ923i_u
zX`rQnmIhiHXlbCOfdkM$u8>MS$0GY&S-=3DzjH|zg*j!C5+g*{M)55vps3HV3Y1K)<f
zg_~gpcEH835zc}Y@aEB})NAk@{5$M}@4!QF4}2NE0DlQPVJnni3@(L17=3DZO~GMog9
zVG;cDeUuG9hsWSvm;e_Fa6YudAC5|;-iH5%XW#+2AMS%)a0zUJ9yl6acyB88V|Wf8
zg<Wth?1WFiN;nb@gG1r5bSm{dxEKBocEBJwa2y;1i(&tfsnl=3Dab+{Mqft%qb$iX12
zg7e^XSOUkuAC5?+-hsE_dvFij4ZGm8a4D>Uqu@=3DPH2(oVgoof8@BrKnUxHg<7hDTF
zVH{S#$#5vVjg#hOcmaL_Pr&1_5B9><FasCC1~?Ah!EPRgJ772544XjgX(gNuC&Hh=3D
zKAb#z;W79s+yz&{6)*uGh4t`$_#OVAN8n-D6Z(Q|^G>JJ-ni2iR9v@nb*Wr%eP`7w
zXL!@#V0$W^jwL&Ow&?jmcB<k|xut?WXV%jXplIZo^(;9)YX-X^af#<T^Z!tEs0^*Z
zjHA_7DVOJ}vhx2>XVBi8qU+LI%0bz2E0uDkm!GvxMy#N*k9De(&lQX1eA}{&<9j>Y
z@_3scRI2&FVGmJO?IFr~C7tAzOIfj(cB+d?cTNdy$C*hf<8f9kut-sz6q!oTTC-$x
zI^_S})J$p~S(6(e1!PO^wzjQhuh7oOOr`mk9w)gCGvDf!tG-sJB-b72TwTZoIca`6
z?G}Ak<;cd)wX;YMsH2gRI6)FkMLM%N>YRSMBjsm<a#_-P+C`^!ev?xUXt_;EXkA9C
zvI8Y}OeozT)zI0RRBKbZd83p-4XuiaIiF_5PO#gR9xqp%wqDg7lOF!kZDi7Nw+C7U
zp&96D%IUDQA@i9S3hi}77uoS@DIbUlk2^~Gc5EmYczH(*!Au)UYjuT+UNeqY3Zl-*
zD6^@!LA6qHN@|J}#p`ccyr@5-ROwk#<&Wy6@O0g4N*nroYoMBhrUOd1J2rTXDvVe%
zR8%wTT2(i**B#YuR+{NhCU3WR_`=3Dcb!0^SR8#k>P9T*wT4)t9oEmCIZgw68Q7)i^J
zF1n>Q8H=3D%LBsb}9_AYO4m)7>kb;l7qCwD17In^wC#wl@LCZ$cpLz_Llj^~``BuV6W
zXPlvp#4S}P)pTY_;2>b6n#2sqvRsR;=3D0hx}Enj9Pbn+9qiqj#I$n-%wL)|6MH=3DGk-
zuGnVT_r(4<L6;MrW;)E+r{CK+xs8{rrGl+M8UORITD3bHN|IE5rCM~&@uo#r+%1d*
zw-ROSFewz7PSl~L@VK5-h3@t#6q&D9DsCyr$}cga`Ds(8fCNQZ6-Ht<s>-UJCTte#
z+1S5M?D+D8GEFOIDKPmu>2$~?w$^ad)9Ripp(0y&b+v1hyjex6NY#+Kfk}gmMosmz
z8JaDElv!sCrU<S5bZvf!S`+3#@?d((Ex6-)dTr~dn}gfc_1Ec;E0Y-V(jZsa;s#3@
z+)FF2>~U6Kr*hN9a;~7hmvTC7(hYJdVKNuwC)BrMxqM}HD*U=3Dd|Mez4o!^_BbPHZC
za8){XGf}9huVEc|1{Y?nlO}a3W7C0Kt`x%5F)!HW`Eq_Zm&PW7q^T`oLb{yk3bmZ-
zmGZ?Znmv#C!rr7kvD!XZ^h(w3-6b~|_lgL|j_$19=3DiL?0$K773ENQiJ89-iXOMO~_
z{o(3dr=3DvUNbU1Cfz?m*rD^7VzW~Fu~SDJR%F78&Gt!~99sY|j26RvY1mrv*7@_4W<
zSK*h;MO;ys$sE_?cyxlZ+$oQ%GX}l9Tk_qEQ?5uMUf^&J8KpF8nDkA?b;FySb#BS6
z<ciLQ>R6G>ad@ti^PMS4@h9AZGd3;dj81qYR?1r{xk-nwVpEPE3f3#l;YwNJ5>#NK
zs(547z?Hglr9wCN6qDtGH!kH!QEhA5o#j2t&ZJ~#RBhIGE~r-g9l`XKIp;jR+rDee
zq@1t1ql<e0x7d|0Pp(dNccf(f|2*sIwXD}=3D{cqy$UuV64AKVHz!1dt478r*S_$}wW
z0MEmHa6N2;t*{RILCReNtxrn>Ee*6Z(9%Fl11$}-G|<vOO9L$pv^3Dtz#oAIaGDyA
zX*M5h?_6!XO}_fN+5E)$S8%uE&B0X~o}fM4__rk`bj_(;&T2w3HJ=3DvVRq?HQQoeC6
zJ6B!hs06D*>sV?=3D{N}_eaC*nfZcokX=3DFH;5$(l1}k0eEoQ6-1CR-&+z<)5?t&Y{5d
z4#PTqG_<vy*32!mxE~iHaJyRnABzcIE-_Zt|2Kx__ygAWPk^ldW!--vtc5jjHvA83
z`p01($R2<k^ukIw2abk+#;<S_d=3D4%HiRmwaH;K!?3a`Me@I|;9J_Qo9cR=3DFykHdH1
zZnzGvf-zVQ?Qj%4Lk#{&_<Pt2ldu6+Kn51WbHv}Df`{OK*bSG%D6E7YI2N8K-u^WF
z1AGZ2KJP;TJ`Gt|4;Ml|oCH57?*1w~0Mjr6ov;Lsfv1S8KMME5eefA5!KWb$AB4l<
zcf`_v3;zZW!{=3DZUif{&;2x&MHen>3+0r)GJfgSKExBxx`r@_(i3*zWMg(u+q@CZB%
zp9P7zZ-!66a_ELGH~|iWL*XTC;zf88egOO6cDN08!C$}>i0yn58a{f+iZ{;0S7qd@
z@D%nhLrkKSDwp|f=3DOm~fRLaxYn%&zj{x<z1*iI2DTzoEthqH<~Br}bi9gW4Thcwx+
z;5PXozS{-JB=3DI5T@?WKbF?9utOW7(lA(kDr)7q_2OLMAIcqQFv^6}f0FFWH%l^Mrm
z)H2I2H5)qouUe4~lcMOII#7%98ntw;R>hiF09z+?5jw6Lm237>&}0gVO|p?Fbe}$G
zIo&Bv{fdrJViX<Wpb3&B#roBWY7%dZ&q;($KI*ctX|O-rf7ynO*}l=3DyjoIP8p?($7
zXST;^sD%IPBVTb#kV&3QZA!Ib14+GAyVywOp|%&a*C4z?=3D<wz&0VYuv;xym15M63?
zr*50@ims!ikH!qH`S}}XY@dZ(Z=3D~O4NSaG1Ev_Xsjow;=3D(_FvfO>U@1Mx9lM{+TqI
z@)eiCpvJkj`1n18$ZRayDzBC_ADOL~VJre2vlXX9o2=3DbI@saOzNHgfehA!0NnE0s?
zE-`1F{!~;k>=3DCuIDd{9@*qPz1&(pSQHV|x4;R$9ItGleG+xHA2B0)d?k2V*~(J1@&
zhD|B8*-IuRiHn(OIlS4+=3DX^IQ+I=3DoL$LRAbIVCaAXy3+l{i9?{Ji4*}qy1~-XjDkL
zZaQVlM0qkBhU4_WcVYr#X31r5=3D=3D=3DEKNZ(q!@I)Dg`{p5l#Qqjk`%wRA-<(ws^^LA=
s
zZ|6#Gy^b<2sQST?k&kWKU>BX(_Q8>L<Vij>Ff=3Dd^#Y92Q1&KE>G}OO#pl`I_mN2>T
zI&Qk4()%wPUB7nY+(qYu1r-}N)I_DN8QC;E+AmcnA0CQzNpgdu5b%P8yWr!a{UaOK
zs=3DDVGOkq@cVZ{%OUOI5GbeF%)Bl^v<uC_T(?{=3DAVC-YO&ZLz_biB@rb^KE`+*=3D8o=
g
z@VeW0<%kt+T|Vm4=3DW`9Io3|UTBYM9>y=3D3gZiO-cY%v^HY62Ap#Jk6x|?Wwx?&2O7)
z0}G0)RiG|La%I!kw`gO4m8F^JYRZpp#?*aSI7MdHvJ0hM_6da7%xGO7Is;-?R<+cw
zp1EAxk6sGIGkAX1cg@(6JHN)tWNnNrj(p}JdvpE8uMbvH%`_!@M-o&a^Yy{eL#?Jr
z36|K+de72;#Q*PP?RF>YMOpuw=3DkuRujsIgXet_@u{abJaEQcOg1V3V(|25bN*MJ9`
zU=3D&utVtAD`|10n>@O9V$({K@-1uNhPc!PESUbqu(gInMRxE_2cLkWgq5IzPUgrDLE
z_$KUtVORlY!hf;$e-OS1Ux3Z<Avg{8v)&h<z#jM(JP6-_ufUyf2iykh;S5*=3DzhJ%p
z8tj4H;DY!DE`qhN24vs<?^*Z%3VsQD;cIXe%)q(uVORuju<qXvvRD5G2*8B`{5kv?
z{3)CWzh>S4D|iWBglFMC*a_D_1$dQ1stoJlP5Sc<cmc#;@FY9}d*It3{e3Uo1~<S)
zxClnzeE0~Q2N@7w!qfNzo`UP)I@kr<VH+%i9yke(0P!FE2%Gv0Tn$%2;zvx?GFNMq
z*|(IT$4qb6VxTw9<tj&Q4xd?QnSRjZjK*ZYF-hjnh01FeL+$TQq3V{uX<KBIc&NH&
z8l6Lo`osLLm;6B6QeQOJ4qtr|uT~4ywo;7oX3WQrs{A;XOpQAhqt&?5rL2_duG`iv
zjky<zn@Q&~Ssu;b$CcK*64kbEwYRuIC~k{*074d7tYhk3Vm%A1E!>zNZujMC&dy)$
zR$_^?KvCr49P<Jwj~@lrhOFF5sNqjnWuz{(%Q)jyec7rz7JgBixTSt|E;kr%p51Y*
zH;eAp9J_BVoj21^6Gu;NS!|V2C!fe@B$I`r@+>xX0=3Di<DRXlgAz1p^mRZk#gM3VVg
z4V6+|=3D<qQT#GF1+B6X`}y}0XCmB#icf%?MnFQ%vZz+|>MqL$>$<us72F~>|)uG;t;
zc{mTiD-!L|O?rMuv@vhZh1=3DC<Xgwdjk+(ycm3|~ZC)fIaDp&E@MvjkfESJBM=3DPZl~
zh6Pv^OZ&B_BxA*9lmeAm$VOBigR#xhw>>Qlw!@=3DJ=3DJB9Rim;VE&uQO@9+v7M1=3DE>=
c
zcD!@7F#t59K1OIQy=3DtlSagTDLisQ`epN>3e_Na>$sSMS!b*&)Fp3#vh4ci|t>IY{;
z67>+wc#%|9qRHj=3DlFQhy`mRrtSywOrnmk-kltQfz&<bpPuAqbJq|(}|lDSKi!1>{W
zIrg!dD6!P~0*rVwqGPq#&|Amj#-t9+)0|Y^hW1!On9*B%@Pe)7O;<W<<kx!|GpSjp
z$*^`a-mJR)=3DIcQ#S4~3OSZnRKvZ^UaxdXLtlK;&WMH*#1f9b0o^HiF)^JWt*k26g%
z=3Dc}o>Sstt)ylnDRm3sP9s!GdtZr{mGO%*-%WwV!D61zK`fq<RaDxc4Tgr&UeEG?Ex
zTZltBQ@LQm8TTrFuvA?`(yH>>$fG72BnC<pMda#S9oaj_<T(T@Ma{<KZ1%KbgH4N5
zAu3wxGC>GQl>uE>fwAduJf+oh5Jn97;cr&@xB7>;yj@h2Om@NMnk4;cB7DRkh`GsA
z7prQ|lgjfWk|{o<L<zH6zbd9f{^$ILoDDj{2``FI%4;>VX0f`z>PA4a=3D_0vtrAsd~
z$dXvTm58rquA72c%d{^H$&bR>!_QnR<`Mgp_5UYXoPAf;XsrLu`~CK_wtpRd4gU!*
zz%w9zfPVscH^3usEnEXbFbFH58@k|d_&w`?c~0Oh*biTYyWsO6&kI}!@|=3DL|88Gh+
zcpYEBcR}_K$om20y#Q5^_X2Ey5$J^zLEZzf5AK2rh;QIrI15(53GfQOfS2G!xE*eT
z-Eb4!2-ku<|K9~4fF*DYyoI0OHTW643eUnVup72R31q*)S~vm@ho9gl_$FKj0Zc&|
z*1-Aj5$J*ph+pAk_!&Nf2jKzO3IlK|oB|HKAD+cu@D;cdTsQ}g1=3D(Y;7!H9a@e}+F
z$n*Xa&<h^`@gJN3N5Rwh2JV0_gA3=3Dt@o+3GfkWY6S?}KhyJ0hQ!TaF7kcM|y-|vOb
z!_9Chbbze;-vfuhTiBD>)LkHcfNNnV)PJgVE=3D=3Du$QxOs~AZE!?oyX~R_`lB4*~ERP
z;~fXbfoInhx$xc<H)a^<F<M->8i=3DbL934azSqgY}T)DM?(t)c%2Y?QaChWQ_Wmv-N
zTVCV9tzFAZN@Gw!kEk&6WtF7XDGA>HCWB(l=3D)qBesV8i{CGdeZoyeS3%DkE##TlYV
z*uiOhU3HcTygTEe77kpfM%1Po6?(ZqNAC`jLhQ<Hby)Hrs9l)QrB&3N#-aAEsa)JV
zD&L2!Q6$ycSz+DxnE|R^mZ9?NHw?%-9^`IVHgL&p_X3KL`_HuYc!&4gygne@2&Vq(
zMU~w6hbwS%)X1Ia8nU#Y6`IfrZm^}IjDAN&bWa>}CDj)mUl@c=3D3!0p~duJv!heNbM
zOx>vZRd2L)C7R7t&nfX`B~|-nZEMs0qkUwdgrVwczT<gxb%Th_HQ6X;=3D%G{IT3Ps5
zYew{4x0bET5H5&or$h!S%LmLtmVJ$-SO<AG1$jh4W(lXOP-kxLPz}-Bw_`4-&i>(%
zq5dH`&034bPO?0VV!zGSy|${9C`uM3OenvRf_B(z;Mx*6xmq<E(rMj<rZ3wNhmn5a
zM)-D)a5G`JptqzGAEeZT7+Qb&EeUAA_*nY~hA-*k?JY_pYW-$8L=3D)rmS~$*_)q+&5
z;i7m(G_Jfzje&1V*l=3DOoE<Q!I(N2%>Tp{*44*M$EI0dK{s5cj7)KXK8AW4)S3hgpV
z3;RmNBUHem$?T}Q*z!y#YO7hmMk<fC^3JNVn(XbV_=3DFG&5Nm*>)y5D(m7XZ55_NAV
zsOk%=3DTW6I*WmX-B(P(ev3~{5{>wD(XRQR?D?YFkVd3w38=3Dd`d#>Z3oBEP7VM){e#e
EFV{Li$N&HU

literal 0
HcmV?d00001

diff --git a/libnfttrans/Makefile.am b/libnfttrans/Makefile.am
new file mode 100644
index 0000000..5befb63
--- /dev/null
+++ b/libnfttrans/Makefile.am
@@ -0,0 +1,28 @@
+# -*- Makefile -*-
+if ENABLE_NFTABLES
+if HAVE_LIBMNL
+if HAVE_LIBNFTABLES
+
+AM_CFLAGS   =3D ${regular_CFLAGS}
+AM_CPPFLAGS =3D ${regular_CPPFLAGS}  -I${top_builddir}/include \
+		-I${top_srcdir}/include  -I./ ${kinclude_CPPFLAGS}
+
+lib_LTLIBRARIES       =3D libnfttrans.la
+libnfttrans_la_SOURCES =3D nft-translator.c
+libnfttrans_la_LDFLAGS =3D
+libnfttrans_la_LIBADD  =3D
+if ENABLE_STATIC
+# With --enable-static, shipped extensions are linked into the main ex=
ecutable,
+# so we need all the LIBADDs here too
+libnfttrans_la_LIBADD +=3D -lm
+endif
+if ENABLE_SHARED
+libnfttrans_la_CFLAGS  =3D ${AM_CFLAGS}
+libnfttrans_la_LIBADD +=3D -ldl
+else
+libnfttrans_la_CFLAGS  =3D ${AM_CFLAGS} -DNO_SHARED_LIBS=3D1
+endif
+
+endif # HAVE_LIBNFTABLES
+endif #=C2=A0HAVE_LIBMNL
+endif # ENABLE_NFTABLES
diff --git a/libnfttrans/libnfttrans.pc b/libnfttrans/libnfttrans.pc
new file mode 100644
index 0000000..fe0b4c0
--- /dev/null
+++ b/libnfttrans/libnfttrans.pc
@@ -0,0 +1,11 @@
+
+prefix=3D/usr
+exec_prefix=3D${prefix}
+libdir=3D${exec_prefix}/lib
+includedir=3D${prefix}/include
+
+Name:		libnfttrans
+Description:	Small engine to translate nft expressions list into more =
complex registered subset
+Version:	1.4.19.1
+Libs:		-L${libdir} -lnfttrans
+Cflags:		-I${includedir}
diff --git a/libnfttrans/libnfttrans.pc.in b/libnfttrans/libnfttrans.pc=
=2Ein
new file mode 100644
index 0000000..f3363de
--- /dev/null
+++ b/libnfttrans/libnfttrans.pc.in
@@ -0,0 +1,11 @@
+
+prefix=3D@prefix@
+exec_prefix=3D@exec_prefix@
+libdir=3D@libdir@
+includedir=3D@includedir@
+
+Name:		libnfttrans
+Description:	Small engine to translate nft expressions list into more =
complex registered subset
+Version:	@PACKAGE_VERSION@
+Libs:		-L${libdir} -lnfttrans
+Cflags:		-I${includedir}
diff --git a/libnfttrans/nft-translator.c b/libnfttrans/nft-translator.=
c
new file mode 100644
index 0000000..12bd7e5
--- /dev/null
+++ b/libnfttrans/nft-translator.c
@@ -0,0 +1,571 @@
+/*
+ * (C) 2013 by Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
+ *
+ * This program is free software; you can redistribute it and/or modif=
y
+ * it under the terms of the GNU General Public License as published b=
y
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#include <stdlib.h>
+#include <string.h>
+#include <errno.h>
+
+#include <linux/netfilter/nf_tables.h>
+
+#include <nft-translator.h>
+
+static const char *nft_instruction_name[NFT_INSTRUCTION_MAX] =3D {
+	"bitwise",
+	"byteorder",
+	"cmp",
+	"counter",
+	"ct",
+	"exthdr",
+	"immediate",
+	"limit",
+	"log",
+	"lookup",
+	"match",
+	"meta",
+	"nat",
+	"payload",
+	"reject",
+	"target",
+};
+
+typedef void (*free_function_f)(void *);
+
+struct s_list {
+	void *data;
+	struct s_list *next;
+};
+
+struct nft_trans_instruction_node {
+	struct s_list *functions;
+	struct nft_trans_instruction_node *nodes[NFT_INSTRUCTION_MAX];
+};
+
+struct nft_trans_instruction_tree {
+	struct s_list *nodes;
+	struct nft_trans_instruction_node *root;
+};
+
+struct nft_trans_register_context {
+	struct nft_rule_expr *reg[NFT_REG_MAX];
+};
+
+struct nft_trans_instruction_context {
+	struct nft_trans_instruction_context *next;
+
+	struct nft_rule_expr *current_expr;
+	enum nft_instruction instruction;
+	struct nft_trans_register_context *registers;
+};
+
+struct nft_trans_rule_context {
+	struct nft_trans_instruction_context *instr_contexts;
+};
+
+struct nft_trans_found_instruction {
+	const struct s_list *functions;
+	struct nft_trans_instruction_context *position;
+};
+
+static enum nft_instruction str2nft_intruction(const char *name)
+{
+	enum nft_instruction i;
+
+	for (i =3D 0; i < NFT_INSTRUCTION_MAX; i++) {
+		 if (strncmp(nft_instruction_name[i], name,
+					strlen(nft_instruction_name[i])) =3D=3D 0)
+			 return i;
+	}
+
+	return NFT_INSTRUCTION_MAX;
+}
+
+static struct s_list *s_list_prepend(struct s_list *list, void *data)
+{
+	struct s_list *n_list;
+
+	n_list =3D calloc(1, sizeof(struct s_list));
+	if (n_list =3D=3D NULL)
+		return list;
+
+	n_list->data =3D data;
+	n_list->next =3D list;
+
+	return n_list;
+}
+
+static void s_list_free(struct s_list *list, int data_too,
+			 free_function_f _free)
+{
+	struct s_list *previous =3D NULL;
+
+	for (; list !=3D NULL; list =3D list->next) {
+		if (previous !=3D NULL) {
+			if (previous->data !=3D NULL && data_too !=3D 0) {
+				if (_free !=3D NULL)
+					_free(previous->data);
+				else
+					free(previous->data);
+			}
+
+			free(previous);
+		}
+
+		previous =3D list;
+	}
+
+	if (previous !=3D NULL) {
+		if (previous->data !=3D NULL && data_too !=3D 0) {
+			if (_free !=3D NULL)
+				_free(previous->data);
+			else
+				free(previous->data);
+		}
+
+		free(previous);
+	}
+}
+
+struct nft_trans_instruction_tree *nft_trans_instruction_tree_new(void=
)
+{
+	struct nft_trans_instruction_tree *tree;
+
+	tree =3D calloc(1, sizeof(struct nft_trans_instruction_tree));
+	if (tree !=3D NULL) {
+		tree->root =3D calloc(1, sizeof(struct nft_trans_instruction_node));
+		if (tree->root =3D=3D NULL)
+			goto error;
+
+		tree->nodes =3D s_list_prepend(tree->nodes, tree->root);
+		if (tree->nodes =3D=3D NULL)
+			goto error;
+	}
+
+	return tree;
+
+error:
+	free(tree);
+	return NULL;
+}
+
+static void _free_nft_trans_instruction_node(void *data)
+{
+	struct nft_trans_instruction_node *node =3D data;
+
+	if (node =3D=3D NULL)
+		return;
+
+	s_list_free(node->functions, 0, NULL);
+	free(node);
+}
+
+void
+nft_trans_instruction_tree_destroy(struct nft_trans_instruction_tree *=
tree)
+{
+	if (tree =3D=3D NULL)
+		return;
+
+	s_list_free(tree->nodes, 1, _free_nft_trans_instruction_node);
+	free(tree);
+}
+
+int nft_trans_add_instruction(struct nft_trans_instruction_tree *tree,
+			      struct nft_trans_instruction *ipt_i)
+{
+	struct nft_trans_instruction_node *node;
+	enum nft_instruction *instr;
+
+	if (tree =3D=3D NULL)
+		return -EINVAL;
+
+	node =3D tree->root;
+	for (instr =3D ipt_i->instructions;
+				*instr < NFT_INSTRUCTION_MAX; instr++) {
+		if (node->nodes[*instr] =3D=3D NULL) {
+			node->nodes[*instr] =3D calloc(1,
+					sizeof(struct nft_trans_instruction_node));
+			if (node->nodes[*instr] =3D=3D NULL)
+				return -ENOMEM;
+		}
+
+		node =3D node->nodes[*instr];
+		tree->nodes =3D s_list_prepend(tree->nodes, node);
+	}
+
+	node->functions =3D s_list_prepend(node->functions, ipt_i->function);
+
+	return 0;
+}
+
+static void
+free_nft_trans_instruction_context(struct nft_trans_instruction_contex=
t *i_ctx)
+{
+	if (i_ctx =3D=3D NULL)
+		return;
+
+	free(i_ctx->registers);
+	free(i_ctx);
+}
+
+static void
+destroy_nft_trans_rule_context(struct nft_trans_rule_context *rule_ctx=
)
+{
+	if (rule_ctx =3D=3D NULL)
+		return;
+
+	if (rule_ctx->instr_contexts !=3D NULL) {
+		struct nft_trans_instruction_context *i_ctx, *prev =3D NULL;
+
+		for (i_ctx =3D rule_ctx->instr_contexts;
+					i_ctx !=3D NULL; i_ctx =3D i_ctx->next) {
+			free_nft_trans_instruction_context(prev);
+			prev =3D i_ctx;
+		}
+
+		free_nft_trans_instruction_context(prev);
+	}
+
+	free(rule_ctx);
+}
+
+static void
+update_register_from_bitwise(struct nft_rule_expr *expr,
+			     struct nft_trans_register_context *registers)
+{
+	if (nft_rule_expr_is_set(expr, NFT_EXPR_BITWISE_DREG))
+		registers->reg[nft_rule_expr_get_u32(expr,
+						NFT_EXPR_BITWISE_DREG)] =3D expr;
+}
+
+static void
+update_register_from_byteorder(struct nft_rule_expr *expr,
+			       struct nft_trans_register_context *registers)
+{
+	if (nft_rule_expr_is_set(expr, NFT_EXPR_BYTEORDER_DREG))
+		registers->reg[nft_rule_expr_get_u32(expr,
+					NFT_EXPR_BYTEORDER_DREG)] =3D expr;
+}
+
+static void
+update_register_from_ct(struct nft_rule_expr *expr,
+			struct nft_trans_register_context *registers)
+{
+	if (nft_rule_expr_is_set(expr, NFT_EXPR_CT_DREG))
+		registers->reg[nft_rule_expr_get_u32(expr,
+						NFT_EXPR_CT_DREG)] =3D expr;
+}
+
+static void
+update_register_from_exthdr(struct nft_rule_expr *expr,
+			    struct nft_trans_register_context *registers)
+{
+	if (nft_rule_expr_is_set(expr, NFT_EXPR_EXTHDR_DREG))
+		registers->reg[nft_rule_expr_get_u32(expr,
+						NFT_EXPR_EXTHDR_DREG)] =3D expr;
+}
+
+static void
+update_register_from_immediate(struct nft_rule_expr *expr,
+			       struct nft_trans_register_context *registers)
+{
+	if (nft_rule_expr_is_set(expr, NFT_EXPR_IMM_DREG))
+		registers->reg[nft_rule_expr_get_u32(expr,
+						NFT_EXPR_IMM_DREG)] =3D expr;
+}
+
+static void
+update_register_from_lookup(struct nft_rule_expr *expr,
+			    struct nft_trans_register_context *registers)
+{
+	if (nft_rule_expr_is_set(expr, NFT_EXPR_LOOKUP_DREG))
+		registers->reg[nft_rule_expr_get_u32(expr,
+						NFT_EXPR_LOOKUP_DREG)] =3D expr;
+}
+
+static void
+update_register_from_meta(struct nft_rule_expr *expr,
+			  struct nft_trans_register_context *registers)
+{
+	if (nft_rule_expr_is_set(expr, NFT_EXPR_META_DREG))
+		registers->reg[nft_rule_expr_get_u32(expr,
+						NFT_EXPR_META_DREG)] =3D expr;
+}
+
+static void
+update_register_from_payload(struct nft_rule_expr *expr,
+			     struct nft_trans_register_context *registers)
+{
+	if (nft_rule_expr_is_set(expr, NFT_EXPR_PAYLOAD_DREG))
+		registers->reg[nft_rule_expr_get_u32(expr,
+						NFT_EXPR_PAYLOAD_DREG)] =3D expr;
+}
+
+static struct nft_trans_register_context *
+update_registers(enum nft_instruction instruction, struct nft_rule_exp=
r *expr,
+		 struct nft_trans_register_context *registers)
+{
+	struct nft_trans_register_context *new_registers;
+
+	new_registers =3D calloc(1, sizeof(struct nft_trans_register_context)=
);
+	if (new_registers =3D=3D NULL)
+		return NULL;
+
+	memcpy(new_registers, registers, sizeof(struct nft_trans_register_con=
text));
+
+	switch (instruction) {
+	case NFT_INSTRUCTION_BITWISE:
+		update_register_from_bitwise(expr, new_registers);
+		break;
+	case NFT_INSTRUCTION_BYTEORDER:
+		update_register_from_byteorder(expr, new_registers);
+		break;
+	case NFT_INSTRUCTION_CMP:
+	case NFT_INSTRUCTION_COUNTER:
+		break;
+	case NFT_INSTRUCTION_CT:
+		update_register_from_ct(expr, new_registers);
+		break;
+	case NFT_INSTRUCTION_EXTHDR:
+		update_register_from_exthdr(expr, new_registers);
+		break;
+	case NFT_INSTRUCTION_IMMEDIATE:
+		update_register_from_immediate(expr, new_registers);
+		break;
+	case NFT_INSTRUCTION_LIMIT:
+	case NFT_INSTRUCTION_LOG:
+		break;
+	case NFT_INSTRUCTION_LOOKUP:
+		update_register_from_lookup(expr, new_registers);
+		break;
+	case NFT_INSTRUCTION_MATCH:
+		break;
+	case NFT_INSTRUCTION_META:
+		update_register_from_meta(expr, new_registers);
+		break;
+	case NFT_INSTRUCTION_NAT:
+		break;
+	case NFT_INSTRUCTION_PAYLOAD:
+		update_register_from_payload(expr, new_registers);
+		break;
+	case NFT_INSTRUCTION_REJECT:
+	case NFT_INSTRUCTION_TARGET:
+		break;
+	case NFT_INSTRUCTION_MAX:
+		return NULL;
+	};
+
+	return new_registers;
+}
+
+static struct nft_trans_rule_context *
+generate_nft_trans_rule_context(struct nft_rule *rule)
+{
+	struct nft_trans_instruction_context *cur_ctx =3D NULL;
+	struct nft_trans_register_context *cur_regs =3D NULL;
+	struct nft_trans_rule_context *rule_ctx;
+	struct nft_rule_expr_iter *iter;
+	struct nft_rule_expr *expr;
+
+	rule_ctx =3D calloc(1, sizeof(struct nft_trans_rule_context));
+	if (rule_ctx =3D=3D NULL)
+		return NULL;
+
+	iter =3D nft_rule_expr_iter_create(rule);
+	if (iter =3D=3D NULL)
+		goto error;
+
+	cur_regs =3D calloc(1, sizeof(struct nft_trans_register_context));
+	if (cur_regs =3D=3D NULL)
+		goto error;
+
+	expr =3D nft_rule_expr_iter_next(iter);
+	while (expr !=3D NULL) {
+		struct nft_trans_instruction_context *ctx;
+		enum nft_instruction instr;
+
+		ctx =3D calloc(1, sizeof(struct nft_trans_instruction_context));
+		if (ctx =3D=3D NULL)
+			goto error;
+
+		instr =3D str2nft_intruction(nft_rule_expr_get_str(expr,
+						NFT_RULE_EXPR_ATTR_NAME));
+		if (instr =3D=3D NFT_INSTRUCTION_MAX)
+			goto error;
+
+		ctx->current_expr =3D expr;
+		ctx->instruction =3D instr;
+		ctx->registers =3D cur_regs;
+
+		if (cur_ctx =3D=3D NULL)
+			rule_ctx->instr_contexts =3D ctx;
+		else
+			cur_ctx->next =3D ctx;
+
+		cur_ctx =3D ctx;
+
+		cur_regs =3D update_registers(instr, expr, cur_regs);
+		if (cur_regs =3D=3D NULL)
+			goto error;
+
+		expr =3D nft_rule_expr_iter_next(iter);
+	}
+
+	if (cur_regs !=3D NULL)
+		free(cur_regs);
+
+	nft_rule_expr_iter_destroy(iter);
+
+	return rule_ctx;
+
+error:
+	destroy_nft_trans_rule_context(rule_ctx);
+
+	if (cur_regs !=3D NULL)
+		free(cur_regs);
+
+	if (iter !=3D NULL)
+		nft_rule_expr_iter_destroy(iter);
+
+	return NULL;
+}
+
+static struct s_list *
+retrieve_nft_trans_instructions(struct nft_trans_instruction_tree *tre=
e,
+				struct nft_trans_instruction_context *instructions)
+{
+	struct s_list *nft_trans_instructions =3D NULL;
+	struct nft_trans_instruction_context *ctx;
+	struct nft_trans_found_instruction *ipt_i;
+	struct nft_trans_instruction_node *node;
+
+	ctx =3D instructions;
+	node =3D tree->root;
+
+	while (ctx !=3D NULL) {
+		if (node->nodes[ctx->instruction] !=3D NULL) {
+			node =3D node->nodes[ctx->instruction];
+
+			if (node->functions !=3D NULL) {
+				ipt_i =3D calloc(1,
+					sizeof(struct nft_trans_found_instruction));
+
+				ipt_i->functions =3D node->functions;
+				ipt_i->position =3D ctx;
+
+				/* It prepends since "longest path first"
+				 * is applied */
+				nft_trans_instructions =3D s_list_prepend(
+						nft_trans_instructions, ipt_i);
+			}
+		} else
+			break;
+
+		ctx =3D ctx->next;
+	};
+
+	return nft_trans_instructions;
+}
+
+static struct nft_trans_instruction_context *
+execute_relevant_instruction(struct s_list *instructions,
+			     struct nft_trans_rule_context *rule_ctx,
+			     struct nft_trans_instruction_context *position,
+			     nft_trans_parse_callback_f user_cb,
+			     void *user_data)
+{
+	for (; instructions !=3D NULL; instructions =3D instructions->next) {
+		struct nft_trans_found_instruction *i_f =3D instructions->data;
+		const struct s_list *fl;
+
+		for (fl =3D i_f->functions; fl !=3D NULL; fl =3D fl->next) {
+			nft_trans_parse_instruction_f function =3D fl->data;
+
+			if (function(rule_ctx, position, i_f->position,
+						user_cb, user_data) =3D=3D 0)
+				return i_f->position;
+		}
+	}
+
+	return NULL;
+}
+
+int
+nft_trans_rule_translate_to_instructions(struct nft_trans_instruction_=
tree *tree,
+					 struct nft_rule *rule,
+					 nft_trans_parse_callback_f user_cb,
+					 void *user_data)
+{
+	struct nft_trans_instruction_context *position;
+	struct s_list *nft_trans_instructions;
+	struct nft_trans_rule_context *rule_ctx;
+
+	if (tree =3D=3D NULL)
+		return -1;
+
+	rule_ctx =3D generate_nft_trans_rule_context(rule);
+	if (rule_ctx =3D=3D NULL)
+		return -1;
+
+	position =3D rule_ctx->instr_contexts;
+	while (position !=3D NULL) {
+		struct nft_trans_instruction_context *pos;
+
+		nft_trans_instructions =3D retrieve_nft_trans_instructions(tree,
+								position);
+		if (nft_trans_instructions =3D=3D NULL)
+			goto error;
+
+		pos =3D execute_relevant_instruction(nft_trans_instructions,
+				rule_ctx, position, user_cb, user_data);
+		if (pos =3D=3D NULL)
+			goto error;
+
+		s_list_free(nft_trans_instructions, 1, NULL);
+		position =3D pos->next;
+	}
+
+	destroy_nft_trans_rule_context(rule_ctx);
+
+	return 0;
+
+error:
+	s_list_free(nft_trans_instructions, 1, NULL);
+	destroy_nft_trans_rule_context(rule_ctx);
+
+	return -1;
+}
+
+struct nft_trans_instruction_context *
+nft_trans_instruction_context_get_next(struct nft_trans_instruction_co=
ntext *i_ctx)
+{
+	if (i_ctx =3D=3D NULL)
+		return NULL;
+
+	return i_ctx->next;
+}
+
+struct nft_rule_expr *
+nft_trans_instruction_context_get_expr(struct nft_trans_instruction_co=
ntext *i_ctx)
+{
+	if (i_ctx =3D=3D NULL)
+		return NULL;
+
+	return i_ctx->current_expr;
+}
+
+struct nft_rule_expr *
+nft_trans_instruction_context_get_register(struct nft_trans_instructio=
n_context *i_ctx,
+					int register_index)
+{
+	if (i_ctx =3D=3D NULL || i_ctx->registers =3D=3D NULL ||
+					register_index >=3D NFT_REG_MAX)
+		return NULL;
+
+	return i_ctx->registers->reg[register_index];
+}
+
--=20
1.8.3.2

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
