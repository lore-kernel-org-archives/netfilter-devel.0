From: Giuseppe Longo <giuseppelng@gmail.com>
Subject: Re: [PATCH 1/2] xtables: bootstrap xtables-eb for nftables
Date: Thu, 6 Feb 2014 00:26:47 +0100
Message-ID: <CAFpD06RF4ApiQTpnNyFaNVU4w=xa1d9AE7V1PnkQ_ctowvkJ_g@mail.gmail.com>
References: <1391624279-4323-1-git-send-email-giuseppelng@gmail.com>
	<1391624279-4323-2-git-send-email-giuseppelng@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wg0-f42.google.com ([74.125.82.42]:59265 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752390AbaBEX0s (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 5 Feb 2014 18:26:48 -0500
Received: by mail-wg0-f42.google.com with SMTP id l18so5866609wgh.1
        for <netfilter-devel@vger.kernel.org>; Wed, 05 Feb 2014 15:26:47 -0800 (PST)
In-Reply-To: <1391624279-4323-2-git-send-email-giuseppelng@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

I made these changes, if I am not wrong now is possible to parse
target and match using libxtables:

diff --git a/iptables/xtables-eb.c b/iptables/xtables-eb.c
index 90bfc65..c43e10c 100644
--- a/iptables/xtables-eb.c
+++ b/iptables/xtables-eb.c
@@ -459,6 +459,8 @@ int do_commandeb(struct nft_handle *h, int argc,
char *argv[], char **table)
        int rulenum_end = 0;
        int ret = 0;
        struct xtables_target *t;
+       struct xtables_rule_match *matchp = NULL;
+       struct xtables_match *m = NULL;

        memset(&fw, 0, sizeof(fw));

@@ -925,19 +927,23 @@ big_iface_length:
                        continue;
                default:
                        /* Is it a target option? */
-                       /*t = (struct ebt_u_target *)new_entry->t;
-                       if ((t->parse(c - t->option_offset, argv,
argc, new_entry, &t->flags, &t->t))) {
-                               if (ebt_errormsg[0] != '\0')
-                                       return -1;
+                       if (fw.target) {
+                               xtables_option_tpcall(c, argv,
fw.invflags, fw.target, &fw);
                                goto check_extension;
-                       }*/
+                       }

                        /* Is it a match_option? */
-                       /*for (m = ebt_matches; m; m = m->next)
-                               if (m->parse(c - m->option_offset,
argv, argc, new_entry, &m->flags, &m->m))
-                                       break;
+                       for (matchp = fw.matches; matchp; matchp =
matchp->next) {
+                               m = matchp->match;
+
+                               if (matchp->completed ||
+                                  (m->x6_parse == NULL && m->parse == NULL))
+                                       continue;
+
+                               xtables_option_mpcall(c, argv,
fw.invflags, m, &fw);
+                       }

-                       if (m != NULL) {
+                       /*if (m != NULL) {
                                if (ebt_errormsg[0] != '\0')
                                        return -1;
                                if (m->used == 0) {
