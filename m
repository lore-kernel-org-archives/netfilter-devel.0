From: =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <zenczykowski@gmail.com>
Subject: [PATCH 5/5] add xtables-multi{32,64} recognition
Date: Mon, 18 Apr 2011 18:23:53 -0700
Message-ID: <1303176233-14063-5-git-send-email-zenczykowski@gmail.com>
References: <BANLkTikeSwL=TU9nPFsUJeLXTHnPdu5BUg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org,
	=?UTF-8?q?Maciej=20=C5=BBenczykowski?= <maze@google.com>
To: =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <maze@google.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pv0-f174.google.com ([74.125.83.174]:53958 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753745Ab1DSBYb (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 18 Apr 2011 21:24:31 -0400
Received: by pvg12 with SMTP id 12so2377163pvg.19
        for <netfilter-devel@vger.kernel.org>; Mon, 18 Apr 2011 18:24:31 -0700 (PDT)
In-Reply-To: <BANLkTikeSwL=TU9nPFsUJeLXTHnPdu5BUg@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

=46rom: Maciej =C5=BBenczykowski <maze@google.com>

Signed-off-by: Maciej Zenczykowski <maze@google.com>
---
 xtables-multi.c |   14 ++++++++++++++
 1 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/xtables-multi.c b/xtables-multi.c
index f8d56ce..7f98286 100644
--- a/xtables-multi.c
+++ b/xtables-multi.c
@@ -14,20 +14,34 @@
 static const struct subcommand multi_subcommands[] =3D {
 #ifdef ENABLE_IPV4
 	{"iptables",            iptables_main},
+	{"iptables32",          iptables_main},
+	{"iptables64",          iptables_main},
 	{"main4",               iptables_main},
 	{"iptables-save",       iptables_save_main},
+	{"iptables-save32",     iptables_save_main},
+	{"iptables-save64",     iptables_save_main},
 	{"save4",               iptables_save_main},
 	{"iptables-restore",    iptables_restore_main},
+	{"iptables-restore32",  iptables_restore_main},
+	{"iptables-restore64",  iptables_restore_main},
 	{"restore4",            iptables_restore_main},
 	{"iptables-xml",        iptables_xml_main},
+	{"iptables-xml32",      iptables_xml_main},
+	{"iptables-xml64",      iptables_xml_main},
 	{"xml4",                iptables_xml_main},
 #endif
 #ifdef ENABLE_IPV6
 	{"ip6tables",           ip6tables_main},
+	{"ip6tables32",         ip6tables_main},
+	{"ip6tables64",         ip6tables_main},
 	{"main6",               ip6tables_main},
 	{"ip6tables-save",      ip6tables_save_main},
+	{"ip6tables-save32",    ip6tables_save_main},
+	{"ip6tables-save64",    ip6tables_save_main},
 	{"save6",               ip6tables_save_main},
 	{"ip6tables-restore",   ip6tables_restore_main},
+	{"ip6tables-restore32", ip6tables_restore_main},
+	{"ip6tables-restore64", ip6tables_restore_main},
 	{"restore6",            ip6tables_restore_main},
 #endif
 	{NULL},
--=20
1.7.3.1

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
