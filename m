From: Jan Engelhardt <jengelh@medozas.de>
Subject: netfilter: xt_time: print timezone for user information
Date: Wed, 10 Dec 2008 20:49:09 +0100 (CET)
Message-ID: <alpine.LNX.1.10.0812102048230.6340@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:53182 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753520AbYLJTtN (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 10 Dec 2008 14:49:13 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


commit 5f6c55d201590a9360135fa5dbea78a9e958edb6
Author: Jan Engelhardt <jengelh@medozas.de>
Date:   Wed Dec 10 20:48:26 2008 +0100

netfilter: xt_time: print timezone for user information

Let users have a way to figure out if their distro set the kernel 
timezone at all.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 net/netfilter/xt_time.c |   11 +++++++++++
 1 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/net/netfilter/xt_time.c b/net/netfilter/xt_time.c
index 29375ba..93acaa5 100644
--- a/net/netfilter/xt_time.c
+++ b/net/netfilter/xt_time.c
@@ -243,6 +243,17 @@ static struct xt_match xt_time_mt_reg __read_mostly = {
 
 static int __init time_mt_init(void)
 {
+	int minutes = sys_tz.tz_minuteswest;
+
+	if (minutes < 0) /* east of Greenwich */
+		printk(KERN_INFO KBUILD_MODNAME
+		       ": kernel timezone is +%02d%02d\n",
+		       -minutes / 60, -minutes % 60);
+	else /* west of Greenwich */
+		printk(KERN_INFO KBUILD_MODNAME
+		       ": kernel timezone is -%02d%02d\n",
+		       minutes / 60, minutes % 60);
+
 	return xt_register_match(&xt_time_mt_reg);
 }
 

