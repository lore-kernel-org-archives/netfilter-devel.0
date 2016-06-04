From: rodanber@gmail.com
Subject: [PATCH] iptables: extensions: libxt_MARK: Add translation to nft
Date: Sat,  4 Jun 2016 14:42:30 +0200
Message-ID: <1465044150-13229-1-git-send-email-rodanber@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: =?UTF-8?q?Roberto=20Garc=C3=ADa?= <rodanber@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:35337 "EHLO
	mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750838AbcFDMml (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 4 Jun 2016 08:42:41 -0400
Received: by mail-wm0-f66.google.com with SMTP id e3so5189850wme.2
        for <netfilter-devel@vger.kernel.org>; Sat, 04 Jun 2016 05:42:40 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

=46rom: Roberto Garc=C3=ADa <rodanber@gmail.com>

Add translation for the MARK target to nftables.

Examples:

$ sudo iptables-translate -t mangle -A OUTPUT -p tcp --dport 22 -j MARK
--set-mark 64
nft add rule ip mangle OUTPUT tcp dport 22 counter meta mark set 0x40

$ sudo iptables-translate -t mangle -A OUTPUT -p tcp --dport 22 -j MARK
--set-xmark 64
nft add rule ip mangle OUTPUT tcp dport 22 counter meta mark set 0x40

$ sudo iptables-translate -t mangle -A OUTPUT -p tcp --dport 22 -j MARK
--or-mark 64
nft add rule ip mangle OUTPUT tcp dport 22 counter meta mark set mark o=
r 0x40

$ sudo iptables-translate -t mangle -A OUTPUT -p tcp --dport 22 -j MARK=
 --and-mark
64
nft add rule ip mangle OUTPUT tcp dport 22 counter meta mark set mark a=
nd 0x40

$ sudo iptables-translate -t mangle -A OUTPUT -p tcp --dport 22 -j MARK
--xor-mark 64

nft add rule ip mangle OUTPUT tcp dport 22 counter meta mark set mark x=
or 0x40

Signed-off-by: Roberto Garc=C3=ADa <rodanber@gmail.com>
---
 extensions/libxt_MARK.c | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/extensions/libxt_MARK.c b/extensions/libxt_MARK.c
index 556dbde..9383f64 100644
--- a/extensions/libxt_MARK.c
+++ b/extensions/libxt_MARK.c
@@ -245,6 +245,26 @@ static void mark_tg_save(const void *ip, const str=
uct xt_entry_target *target)
 	printf(" --set-xmark 0x%x/0x%x", info->mark, info->mask);
 }
=20
+static int mark_tg_xlate(const void *ip, const struct xt_entry_target =
*target,
+			 struct xt_xlate *xl, int numeric)
+{
+	const struct xt_mark_tginfo2 *info =3D (const void *)target->data;
+
+	if (info->mark =3D=3D 0)
+		xt_xlate_add(xl, "meta mark set mark and 0x%x",
+			     (unsigned int)(uint32_t)~info->mask);
+	else if (info->mark =3D=3D info->mask)
+		xt_xlate_add(xl, "meta mark set mark or 0x%x", info->mark);
+	else if (info->mask =3D=3D 0)
+		xt_xlate_add(xl, "meta mark set mark xor 0x%x", info->mark);
+	else if (info->mask =3D=3D 0xffffffffU)
+		xt_xlate_add(xl, "meta mark set 0x%x", info->mark);
+	else
+		xt_xlate_add(xl, "meta mark xset 0x%x/0x%x", info->mark, info->mask)=
;
+
+	return 1;
+}
+
 static struct xtables_target mark_tg_reg[] =3D {
 	{
 		.family        =3D NFPROTO_UNSPEC,
@@ -287,6 +307,7 @@ static struct xtables_target mark_tg_reg[] =3D {
 		.x6_parse      =3D mark_tg_parse,
 		.x6_fcheck     =3D mark_tg_check,
 		.x6_options    =3D mark_tg_opts,
+		.xlate	       =3D mark_tg_xlate,
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
