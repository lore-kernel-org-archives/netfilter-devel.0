From: Phil Oester <kernel@linuxace.com>
Subject: [PATCH] iptables: state match incompatibilty across versions
Date: Wed, 7 Aug 2013 16:44:49 -0700
Message-ID: <20130807234449.GA22535@linuxace.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="TB36FDmn/VVEgNH/"
Cc: pablo@netfilter.org, ljlane@debian.org, jengelh@medozas.de
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pa0-f50.google.com ([209.85.220.50]:63894 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752651Ab3HGXow (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 7 Aug 2013 19:44:52 -0400
Received: by mail-pa0-f50.google.com with SMTP id fb10so2730821pad.37
        for <netfilter-devel@vger.kernel.org>; Wed, 07 Aug 2013 16:44:52 -0700 (PDT)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--TB36FDmn/VVEgNH/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

As reported in Debian bug #718810 [1], state match rules added in < 1.4.16
iptables versions are incorrectly displayed by >= 1.4.16 iptables versions.
Issue bisected to commit 0d701631 (libxt_state: replace as an alias to
xt_conntrack).

Fix this by adding the missing .print and .save functions for state match
aliases in the conntrack match.

Signed-off-by: Phil Oester <kernel@linuxace.com>

[1] http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=718810


--TB36FDmn/VVEgNH/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=patch-state

diff --git a/extensions/libxt_conntrack.c b/extensions/libxt_conntrack.c
index 9f7b5db..128bbd2 100644
--- a/extensions/libxt_conntrack.c
+++ b/extensions/libxt_conntrack.c
@@ -1272,6 +1272,8 @@ static struct xtables_match conntrack_mt_reg[] = {
 		.size          = XT_ALIGN(sizeof(struct xt_conntrack_mtinfo1)),
 		.userspacesize = XT_ALIGN(sizeof(struct xt_conntrack_mtinfo1)),
 		.help          = state_help,
+		.print         = state_print,
+		.save          = state_save,
 		.x6_parse      = state_ct1_parse,
 		.x6_options    = state_opts,
 	},
@@ -1285,6 +1287,8 @@ static struct xtables_match conntrack_mt_reg[] = {
 		.size          = XT_ALIGN(sizeof(struct xt_conntrack_mtinfo2)),
 		.userspacesize = XT_ALIGN(sizeof(struct xt_conntrack_mtinfo2)),
 		.help          = state_help,
+		.print         = state_print,
+		.save          = state_save,
 		.x6_parse      = state_ct23_parse,
 		.x6_options    = state_opts,
 	},
@@ -1298,6 +1302,8 @@ static struct xtables_match conntrack_mt_reg[] = {
 		.size          = XT_ALIGN(sizeof(struct xt_conntrack_mtinfo3)),
 		.userspacesize = XT_ALIGN(sizeof(struct xt_conntrack_mtinfo3)),
 		.help          = state_help,
+		.print         = state_print,
+		.save          = state_save,
 		.x6_parse      = state_ct23_parse,
 		.x6_options    = state_opts,
 	},

--TB36FDmn/VVEgNH/--
