From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 2/2] iptables: do not emit orig_opts twice
Date: Sun, 28 Nov 2010 15:44:04 +0100
Message-ID: <1290955445-17833-3-git-send-email-jengelh@medozas.de>
References: <1290955445-17833-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:48198 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753196Ab0K1OoJ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 28 Nov 2010 09:44:09 -0500
In-Reply-To: <1290955445-17833-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This just happened to cross my eye; there was no error, but fixing
this up saves a pitfall, and some memory.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 xtables.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/xtables.c b/xtables.c
index d0aa868..2137c98 100644
--- a/xtables.c
+++ b/xtables.c
@@ -103,6 +103,10 @@ struct option *xtables_merge_options(struct option *orig_opts,
 	memcpy(merge, orig_opts, sizeof(*mp) * num_oold);
 	mp = merge + num_oold;
 
+	/* Since @opts also has @orig_opts already, skip the entries */
+	oldopts += num_oold;
+	num_old -= num_oold;
+
 	/* Second, the new options */
 	xt_params->option_offset += 256;
 	*option_offset = xt_params->option_offset;
-- 
1.7.1

