From: =?UTF-8?q?Roberto=20Garc=C3=ADa?= <rodanber@gmail.com>
Subject: [PATCH] iptables: extensions: libxt_TEE: Add translation to nft
Date: Wed, 23 Mar 2016 12:42:52 +0100
Message-ID: <1458733372-2543-1-git-send-email-rodanber@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: =?UTF-8?q?Roberto=20Garc=C3=ADa?= <rodanber@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f43.google.com ([74.125.82.43]:38263 "EHLO
	mail-wm0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752116AbcCWLnk (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 23 Mar 2016 07:43:40 -0400
Received: by mail-wm0-f43.google.com with SMTP id l68so20075130wml.1
        for <netfilter-devel@vger.kernel.org>; Wed, 23 Mar 2016 04:43:39 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Add translation for TEE target to nft. However, there is a
problem with the output when using ip6tables-translate. I couldn't find=
 a fix
for that.

Examples:

$ iptables-translate -t mangle -A PREROUTING -j TEE --gateway 192.168.0=
=2E2 --oif
eth0

nft add rule ip mangle PREROUTING counter dup to 192.168.0.2 oif eth0

$ iptables-translate -t mangle -A PREROUTING -j TEE --gateway 192.168.0=
=2E2

nft add rule ip mangle PREROUTING counter dup to 192.168.0.2

$ ip6tables-translate -t mangle -A PREROUTING -j TEE --gateway
ab12:00a1:1112:acba::

nft add rule ip6 mangle PREROUTING counter comment \"=EF=BF=BD=EF=BF=BD=
z\" dup to
ab12:a1:1112:acba::

$ ip6tables-translate -t mangle -A PREROUTING -j TEE --gateway
ab12:00a1:1112:acba:: --oif eth0

nft add rule ip6 mangle PREROUTING counter comment \"=EF=BF=BD=EF=BF=BD=
{\" dup to
ab12:a1:1112:acba:: oif eth0

Signed-off-by: Roberto Garc=C3=ADa <rodanber@gmail.com>
---
 extensions/libxt_TEE.c | 37 +++++++++++++++++++++++++++++++++++++
 1 file changed, 37 insertions(+)

diff --git a/extensions/libxt_TEE.c b/extensions/libxt_TEE.c
index 66c060d..0b6fb0d 100644
--- a/extensions/libxt_TEE.c
+++ b/extensions/libxt_TEE.c
@@ -92,6 +92,41 @@ static void tee_tg6_save(const void *ip, const struc=
t xt_entry_target *target)
 		printf(" --oif %s", info->oif);
 }
=20
+static int tee_tg_xlate(const void *ip, const struct xt_entry_target *=
target,
+			struct xt_xlate *xl, int numeric)=20
+{
+	const struct xt_tee_tginfo *info =3D
+		(const void *)target->data;
+
+	if (numeric)
+		xt_xlate_add(xl, "dup to %s",
+			     xtables_ipaddr_to_numeric(&info->gw.in));
+	else
+		xt_xlate_add(xl, "dup to %s",
+			     xtables_ipaddr_to_anyname(&info->gw.in));
+	if (*info->oif !=3D '\0')
+		xt_xlate_add(xl, " oif %s", info->oif);
+
+	return 1;
+}
+
+static int tee_tg6_xlate(const void *ip, const struct xt_entry_target =
*target,
+			 struct xt_xlate *xl, int numeric)
+{
+	const struct xt_tee_tginfo *info =3D (const void *)target->data;
+=09
+	if (numeric)
+		xt_xlate_add(xl, "dup to %s",
+			     xtables_ip6addr_to_numeric(&info->gw.in6));
+	else
+		xt_xlate_add(xl, "dup to %s",
+			     xtables_ip6addr_to_anyname(&info->gw.in6));
+	if (*info->oif !=3D '\0')
+		xt_xlate_add(xl, " oif %s", info->oif);
+
+	return 1;
+}
+
 static struct xtables_target tee_tg_reg[] =3D {
 	{
 		.name          =3D "TEE",
@@ -105,6 +140,7 @@ static struct xtables_target tee_tg_reg[] =3D {
 		.save          =3D tee_tg_save,
 		.x6_parse      =3D xtables_option_parse,
 		.x6_options    =3D tee_tg_opts,
+		.xlate         =3D tee_tg_xlate,
 	},
 	{
 		.name          =3D "TEE",
@@ -118,6 +154,7 @@ static struct xtables_target tee_tg_reg[] =3D {
 		.save          =3D tee_tg6_save,
 		.x6_parse      =3D xtables_option_parse,
 		.x6_options    =3D tee_tg_opts,
+		.xlate         =3D tee_tg6_xlate,
 	},
 };
=20
--=20
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
