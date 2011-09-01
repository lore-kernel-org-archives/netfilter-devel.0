From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 1/3] xtoptions: fill in fallback value for nvals
Date: Thu,  1 Sep 2011 11:15:48 +0200
Message-ID: <1314868551-4281-2-git-send-email-jengelh@medozas.de>
References: <1314868551-4281-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:54858 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755872Ab1IAJPz (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 1 Sep 2011 05:15:55 -0400
In-Reply-To: <1314868551-4281-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Parsing for libxt_conntrack rev 2 is done by using rev 2's option
structure, which specifies XTTYPE_PORT, and using rev 3's parser
skeleton, which uses cb->nvals. Reading cb->nvals when not using
XTTYPE_PORTRC (or any other multi-value type) is undefined behavior.

Make it defined. Since XTTYPE_NONE is the only type that can take
void, nvals logically ought to be 1.

References: http://marc.info/?l=netfilter-devel&m=131370592105298&w=2
Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 iptables/xtoptions.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/iptables/xtoptions.c b/iptables/xtoptions.c
index 04344af..5f617a4 100644
--- a/iptables/xtoptions.c
+++ b/iptables/xtoptions.c
@@ -826,6 +826,12 @@ void xtables_option_parse(struct xt_option_call *cb)
 		xt_params->exit_err(PARAMETER_PROBLEM,
 			"%s: option \"--%s\" requires an argument.\n",
 			cb->ext_name, entry->name);
+	/*
+	 * Fill in fallback value for "nvals", in case an extension (as it
+	 * happened with libxt_conntrack.2) tries to read it, despite not using
+	 * a *RC option type.
+	 */
+	cb->nvals = 1;
 	if (entry->type <= ARRAY_SIZE(xtopt_subparse) &&
 	    xtopt_subparse[entry->type] != NULL)
 		xtopt_subparse[entry->type](cb);
-- 
1.7.3.4

