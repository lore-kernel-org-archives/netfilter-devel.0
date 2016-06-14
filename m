From: rodanber@gmail.com
Subject: [PATCH] iptables: extensions: libxt_MARK: Add translation to nft
Date: Tue, 14 Jun 2016 19:12:22 +0200
Message-ID: <1465924342-2680-1-git-send-email-rodanber@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: pablo@netfilter.org,
	=?UTF-8?q?Roberto=20Garc=C3=ADa?= <rodanber@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:36132 "EHLO
	mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751153AbcFNRNF (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 14 Jun 2016 13:13:05 -0400
Received: by mail-wm0-f67.google.com with SMTP id m124so60486wme.3
        for <netfilter-devel@vger.kernel.org>; Tue, 14 Jun 2016 10:13:04 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

=46rom: Roberto Garc=C3=ADa <rodanber@gmail.com>

Add translation for the MARK target to nftables.

Examples:

$ sudo iptables-translate -t mangle -A OUTPUT -j MARK --set-mark 64

nft add rule ip mangle OUTPUT counter meta mark set 0x40

$ sudo iptables-translate -t mangle -A OUTPUT -j MARK --set-xmark 0x40/=
0x32

nft add rule ip mangle OUTPUT counter meta mark set mark xor 0x40 and 0=
x32

$ sudo iptables-translate -t mangle -A OUTPUT -j MARK --or-mark 64

nft add rule ip mangle OUTPUT counter meta mark set mark or 0x40

$ sudo iptables-translate -t mangle -A OUTPUT -j MARK --and-mark 64

nft add rule ip mangle OUTPUT counter meta mark set mark and 0x40

$ sudo iptables-translate -t mangle -A OUTPUT -j MARK --xor-mark 64

nft add rule ip mangle OUTPUT counter meta mark set mark xor 0x40

Signed-off-by: Roberto Garc=C3=ADa <rodanber@gmail.com>
---
 extensions/libxt_MARK.c | 23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/extensions/libxt_MARK.c b/extensions/libxt_MARK.c
index 556dbde..ec1ed05 100644
--- a/extensions/libxt_MARK.c
+++ b/extensions/libxt_MARK.c
@@ -245,6 +245,28 @@ static void mark_tg_save(const void *ip, const str=
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
+	xt_xlate_add(xl, "meta mark set ");
+
+	if (info->mark =3D=3D 0)
+		xt_xlate_add(xl, "mark and 0x%x ", ~info->mask);
+	else if (info->mark =3D=3D info->mask)
+		xt_xlate_add(xl, "mark or 0x%x ", info->mark);
+	else if (info->mask =3D=3D 0)
+		xt_xlate_add(xl, "mark xor 0x%x ", info->mark);
+	else if (info->mask =3D=3D 0xffffffffU)
+		xt_xlate_add(xl, "0x%x ", info->mark);
+	else
+		xt_xlate_add(xl, "mark xor 0x%x and 0x%x ", info->mark,
+			     info->mask);
+
+	return 1;
+}
+
 static struct xtables_target mark_tg_reg[] =3D {
 	{
 		.family        =3D NFPROTO_UNSPEC,
@@ -287,6 +309,7 @@ static struct xtables_target mark_tg_reg[] =3D {
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
