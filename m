From: rodanber@gmail.com
Subject: [PATCH] iptables: extensions: libxt_CONNMARK: Add translation to nft
Date: Fri, 17 Jun 2016 18:10:50 +0200
Message-ID: <1466179850-20928-1-git-send-email-rodanber@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: pablo@netfilter.org, netfilter-devel@vger.kernel.org,
	=?UTF-8?q?Roberto=20Garc=C3=ADa?= <rodanber@gmail.com>
To: arturo.borrero.glez@gmail.com
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:36669 "EHLO
	mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753109AbcFQQK7 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 17 Jun 2016 12:10:59 -0400
Received: by mail-wm0-f67.google.com with SMTP id m124so810676wme.3
        for <netfilter-devel@vger.kernel.org>; Fri, 17 Jun 2016 09:10:58 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

=46rom: Roberto Garc=C3=ADa <rodanber@gmail.com>

Add translation for the CONNMARK target to nftables.

The following options have no available translation:

  --save-mark [--nfmask nfmask] [--ctmask ctmask]
  --restore-mark [--nfmask nfmask] [--ctmask ctmask]

Examples:

  # iptables-translate -t mangle -A PREROUTING -j CONNMARK --set-mark 0=
x16
  nft add rule ip mangle PREROUTING counter ct mark set 0x16

  # iptables-translate -t mangle -A PREROUTING -j CONNMARK --set-xmark =
0x16/0x12
  nft add rule ip mangle PREROUTING counter ct mark set ct mark xor 0x1=
6 and
  0xffffffed

  # iptables-translate -t mangle -A PREROUTING -j CONNMARK --and-mark 0=
x16
  nft add rule ip mangle PREROUTING counter ct mark set ct mark and 0x1=
6

  # iptables-translate -t mangle -A PREROUTING -j CONNMARK --or-mark 0x=
16
  nft add rule ip mangle PREROUTING counter ct mark set ct mark or 0x16

  # iptables-translate -t mangle -A PREROUTING -j CONNMARK --save-mark
  nft add rule ip mangle PREROUTING counter ct mark set mark

  # iptables-translate -t mangle -A PREROUTING -j CONNMARK --save-mark =
\
    --mask 0x12
  nft add rule ip mangle PREROUTING counter ct mark set mark and 0x12

  # iptables-translate -t mangle -A PREROUTING -j CONNMARK --restore-ma=
rk
  nft add rule ip mangle PREROUTING counter meta mark set ct mark

  # iptables-translate -t mangle -A PREROUTING -j CONNMARK --restore-ma=
rk \
    --mask 0x12
  nft add rule ip mangle PREROUTING counter meta mark set ct mark and 0=
x12

Signed-off-by: Roberto Garc=C3=ADa <rodanber@gmail.com>
---
 extensions/libxt_CONNMARK.c | 45 +++++++++++++++++++++++++++++++++++++=
++++++++
 1 file changed, 45 insertions(+)

diff --git a/extensions/libxt_CONNMARK.c b/extensions/libxt_CONNMARK.c
index 42cf207..7940dcd 100644
--- a/extensions/libxt_CONNMARK.c
+++ b/extensions/libxt_CONNMARK.c
@@ -347,6 +347,50 @@ connmark_tg_save(const void *ip, const struct xt_e=
ntry_target *target)
 	}
 }
=20
+static int
+connmark_tg_xlate(const void *ip, const struct xt_entry_target *target=
,
+		  struct xt_xlate *xl, int numeric)
+{
+	const struct xt_connmark_tginfo1 *info =3D (const void *)target->data=
;
+=09
+	switch (info->mode) {
+	case XT_CONNMARK_SET:
+		xt_xlate_add(xl, "ct mark set ");
+		if (info->ctmark =3D=3D 0)
+			xt_xlate_add(xl, "ct mark and 0x%x", ~info->ctmask);
+		else if (info->ctmark =3D=3D info->ctmask)
+			xt_xlate_add(xl, "ct mark or 0x%x",
+				     info->ctmark);
+		else if (info->ctmask =3D=3D 0)
+			xt_xlate_add(xl, "ct mark xor 0x%x",
+				     info->ctmark);
+		else if (info->ctmask =3D=3D 0xFFFFFFFFU)
+			xt_xlate_add(xl, "0x%x ", info->ctmark);
+		else
+			xt_xlate_add(xl, "ct mark xor 0x%x and 0x%x",
+				     info->ctmark, ~info->ctmask);
+		break;
+	case XT_CONNMARK_SAVE:
+		xt_xlate_add(xl, "ct mark set mark");
+		if (!(info->nfmask =3D=3D UINT32_MAX && info->ctmask =3D=3D UINT32_M=
AX))
+		{
+			if (info->nfmask =3D=3D info->ctmask)
+				xt_xlate_add(xl, " and 0x%x", info->nfmask);
+		}
+		break;
+	case XT_CONNMARK_RESTORE:
+		xt_xlate_add(xl, "meta mark set ct mark");
+		if (!(info->nfmask =3D=3D UINT32_MAX && info->ctmask =3D=3D UINT32_M=
AX))
+		{
+			if (info->nfmask =3D=3D info->ctmask)
+				xt_xlate_add(xl, " and 0x%x", info->nfmask);
+		}
+		break;
+	}
+=09
+	return 1;
+}
+
 static struct xtables_target connmark_tg_reg[] =3D {
 	{
 		.family        =3D NFPROTO_UNSPEC,
@@ -377,6 +421,7 @@ static struct xtables_target connmark_tg_reg[] =3D =
{
 		.x6_parse      =3D connmark_tg_parse,
 		.x6_fcheck     =3D connmark_tg_check,
 		.x6_options    =3D connmark_tg_opts,
+		.xlate	       =3D connmark_tg_xlate,
 	},
 };
=20
--=20
2.8.0

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
