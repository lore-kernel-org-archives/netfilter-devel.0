From: Jan Engelhardt <jengelh@medozas.de>
Subject: netfilter: xtables: add missing const qualifier to xt_tgchk_param
Date: Tue, 18 Nov 2008 12:30:26 +0100 (CET)
Message-ID: <alpine.LNX.1.10.0811181229370.17946@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:47295 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751332AbYKRLa2 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 18 Nov 2008 06:30:28 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


This should go in the currently-rolling -rc!

===

# linux-kernel
commit d64b245064738f4ad3cae9a1266ff6158ea6e728
Author: Jan Engelhardt <jengelh@medozas.de>
Date:   Tue Nov 18 12:28:33 2008 +0100

netfilter: xtables: add missing const qualifier to xt_tgchk_param

When entryinfo was a standalone parameter to functions, it used to be
"const void *". Put the const back in.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 include/linux/netfilter/x_tables.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/netfilter/x_tables.h b/include/linux/netfilter/x_tables.h
index be41b60..e52ce47 100644
--- a/include/linux/netfilter/x_tables.h
+++ b/include/linux/netfilter/x_tables.h
@@ -251,7 +251,7 @@ struct xt_target_param {
  */
 struct xt_tgchk_param {
 	const char *table;
-	void *entryinfo;
+	const void *entryinfo;
 	const struct xt_target *target;
 	void *targinfo;
 	unsigned int hook_mask;

