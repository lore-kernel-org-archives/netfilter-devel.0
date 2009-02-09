From: jamal <hadi@cyberus.ca>
Subject: [PATCH] libxtables: define xtables_free_opts()
Date: Mon, 09 Feb 2009 16:01:27 -0500
Message-ID: <1234213287.20903.19.camel@dogo.mojatatu.com>
Reply-To: hadi@cyberus.ca
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-lBJym+GYSA50tkFXwd7R"
Cc: Jan Engelhardt <jengelh@medozas.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ew0-f21.google.com ([209.85.219.21]:41144 "EHLO
	mail-ew0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752919AbZBIVDU (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 9 Feb 2009 16:03:20 -0500
Received: by ewy14 with SMTP id 14so2783893ewy.13
        for <netfilter-devel@vger.kernel.org>; Mon, 09 Feb 2009 13:03:19 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--=-lBJym+GYSA50tkFXwd7R
Content-Type: text/plain
Content-Transfer-Encoding: 7bit


A user of the structure xtables_globals. Next goal is to attack
exit_error() so i can compile that basic program..

cheers,
jamal

--=-lBJym+GYSA50tkFXwd7R
Content-Disposition: attachment; filename=iptv2-1
Content-Type: text/plain; name=iptv2-1; charset=UTF-8
Content-Transfer-Encoding: 7bit

commit 0d4663ae7dc54b5f4d28960dec4f7a1af4cd4d1a
Author: Jamal Hadi Salim <hadi@cyberus.ca>
Date:   Mon Feb 9 15:33:29 2009 -0500

    Introduce xtables_free_opts() an xtables variant of
    free_opts() which uses xtables_globals already set
    by xtables_set_params(). The end goal is to have all internal
    references in xtables.c use xtables_free_opts() instead of
    depending on external defined free_opts()
    
    Signed-off-by: Jamal Hadi Salim <hadi@cyberus.ca>

diff --git a/include/xtables.h.in b/include/xtables.h.in
index 61dbc76..1d33394 100644
--- a/include/xtables.h.in
+++ b/include/xtables.h.in
@@ -204,6 +204,7 @@ extern void *xtables_malloc(size_t);
 extern int xtables_insmod(const char *, const char *, bool);
 extern int xtables_load_ko(const char *, bool);
 int xtables_set_params(struct xtables_globals *xtp);
+void xtables_free_opts(int reset_offset, struct option *original_opts);
 
 extern struct xtables_match *xtables_find_match(const char *name,
 	enum xtables_tryload, struct xtables_rule_match **match);
diff --git a/xtables.c b/xtables.c
index aad5e53..95be5f8 100644
--- a/xtables.c
+++ b/xtables.c
@@ -68,6 +68,17 @@ int xtables_set_params(struct xtables_globals *xtp)
 	return 0;
 }
 
+void xtables_free_opts(int reset_offset, struct option *original_opts)
+{
+	if (xt_params->opts != original_opts) {
+		if (original_opts) 
+			free(xt_params->opts);
+		xt_params->opts = original_opts;
+		if (reset_offset)
+			xt_params->option_offset = 0;
+	}
+}
+
 /**
  * xtables_afinfo - protocol family dependent information
  * @kmod:		kernel module basename (e.g. "ip_tables")

--=-lBJym+GYSA50tkFXwd7R--

