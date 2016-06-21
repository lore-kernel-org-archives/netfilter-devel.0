From: rodanber@gmail.com
Subject: [PATCH] iptables: extensions: libxt_MARK: Add translation for revision 1 to nft
Date: Tue, 21 Jun 2016 22:08:24 +0200
Message-ID: <1466539704-1666-1-git-send-email-rodanber@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: pablo@netfilter.org, netfilter-devel@vger.kernel.org,
	=?UTF-8?q?Roberto=20Garc=C3=ADa?= <rodanber@gmail.com>
To: arturo.borrero.glez@gmail.com
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-lb0-f193.google.com ([209.85.217.193]:33483 "EHLO
	mail-lb0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750906AbcFUUIt (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 21 Jun 2016 16:08:49 -0400
Received: by mail-lb0-f193.google.com with SMTP id o4so3055630lbp.0
        for <netfilter-devel@vger.kernel.org>; Tue, 21 Jun 2016 13:08:48 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

=46rom: Roberto Garc=C3=ADa <rodanber@gmail.com>

Add translation for revision 1 of the MARK target to nft.

Examples:

  # iptables-translate -t mangle -A PREROUTING -j MARK --set-mark 0x64
  nft add rule ip mangle PREROUTING counter meta mark set 0x64

  # iptables-translate -t mangle -A PREROUTING -j MARK --and-mark 0x64
  nft add rule ip mangle PREROUTING counter meta mark set mark and 0x64

  # iptables-translate -t mangle -A PREROUTING -j MARK --or-mark 0x64
  nft add rule ip mangle PREROUTING counter meta mark set mark or 0x64

Signed-off-by: Roberto Garc=C3=ADa <rodanber@gmail.com>
---
 extensions/libxt_MARK.c | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/extensions/libxt_MARK.c b/extensions/libxt_MARK.c
index ec1ed05..2aaf29c 100644
--- a/extensions/libxt_MARK.c
+++ b/extensions/libxt_MARK.c
@@ -267,6 +267,29 @@ static int mark_tg_xlate(const void *ip, const str=
uct xt_entry_target *target,
 	return 1;
 }
=20
+static int MARK_xlate(const void *ip, const struct xt_entry_target *ta=
rget,
+			 struct xt_xlate *xl, int numeric)
+{
+	const struct xt_mark_target_info_v1 *markinfo =3D
+		(const struct xt_mark_target_info_v1 *)target->data;
+
+	xt_xlate_add(xl, "meta mark set ");
+
+	switch(markinfo->mode) {
+	case XT_MARK_SET:
+		xt_xlate_add(xl, "0x%x ", markinfo->mark);
+		break;
+	case XT_MARK_AND:
+		xt_xlate_add(xl, "mark and 0x%x ", markinfo->mark);
+		break;
+	case XT_MARK_OR:=20
+		xt_xlate_add(xl, "mark or 0x%x ", markinfo->mark);
+		break;
+	}
+=09
+	return 1;
+}
+
 static struct xtables_target mark_tg_reg[] =3D {
 	{
 		.family        =3D NFPROTO_UNSPEC,
@@ -295,6 +318,7 @@ static struct xtables_target mark_tg_reg[] =3D {
 		.x6_parse      =3D MARK_parse_v1,
 		.x6_fcheck     =3D MARK_check,
 		.x6_options    =3D MARK_opts,
+		.xlate	       =3D MARK_xlate,
 	},
 	{
 		.version       =3D XTABLES_VERSION,
--=20
2.8.0

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
