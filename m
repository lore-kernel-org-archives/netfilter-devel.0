From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: [PATCH 2/6] arp specific extensions
Date: Sat, 20 Jun 2009 23:58:02 +0200 (CEST)
Message-ID: <alpine.DEB.2.00.0906202356150.11764@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.26]:37243 "EHLO smtp1.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753219AbZFTV6A (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 20 Jun 2009 17:58:00 -0400
Received: from localhost (localhost [127.0.0.1])
	by smtp1.kfki.hu (Postfix) with ESMTP id 90C1B188224
	for <netfilter-devel@vger.kernel.org>; Sat, 20 Jun 2009 23:58:02 +0200 (CEST)
Received: from smtp1.kfki.hu ([127.0.0.1])
	by localhost (smtp1.kfki.hu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id HmumIbJxGtfU for <netfilter-devel@vger.kernel.org>;
	Sat, 20 Jun 2009 23:58:02 +0200 (CEST)
Received: from blackhole.kfki.hu (blackhole.kfki.hu [148.6.0.114])
	by smtp1.kfki.hu (Postfix) with ESMTP id 7927E18821F
	for <netfilter-devel@vger.kernel.org>; Sat, 20 Jun 2009 23:58:02 +0200 (CEST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The arptable specific extensions with the new error reporting methods.

Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
---

 include/linux/netfilter_arp/arpt_mangle.h |    7 +++++++
 net/ipv4/netfilter/arpt_mangle.c          |    8 ++++----
 2 files changed, 11 insertions(+), 4 deletions(-)

diff --git a/include/linux/netfilter_arp/arpt_mangle.h b/include/linux/netfilter_arp/arpt_mangle.h
index 250f502..41d1a90 100644
--- a/include/linux/netfilter_arp/arpt_mangle.h
+++ b/include/linux/netfilter_arp/arpt_mangle.h
@@ -2,6 +2,13 @@
 #define _ARPT_MANGLE_H
 #include <linux/netfilter_arp/arp_tables.h>
 
+enum {
+	ARPT_MANGLE_ERR_NONE,
+	ARPT_MANGLE_ERR_FLAGS,
+	ARPT_MANGLE_ERR_TARGET,
+	ARPT_MANGLE_ERR_MAX,
+};
+
 #define ARPT_MANGLE_ADDR_LEN_MAX sizeof(struct in_addr)
 struct arpt_mangle
 {
diff --git a/net/ipv4/netfilter/arpt_mangle.c b/net/ipv4/netfilter/arpt_mangle.c
index b0d5b1d..87c5e4c 100644
--- a/net/ipv4/netfilter/arpt_mangle.c
+++ b/net/ipv4/netfilter/arpt_mangle.c
@@ -54,18 +54,18 @@ target(struct sk_buff *skb, const struct xt_target_param *par)
 	return mangle->target;
 }
 
-static bool checkentry(const struct xt_tgchk_param *par)
+static unsigned int checkentry(const struct xt_tgchk_param *par)
 {
 	const struct arpt_mangle *mangle = par->targinfo;
 
 	if (mangle->flags & ~ARPT_MANGLE_MASK ||
 	    !(mangle->flags & ARPT_MANGLE_MASK))
-		return false;
+		return ARPT_MANGLE_ERR_FLAGS;
 
 	if (mangle->target != NF_DROP && mangle->target != NF_ACCEPT &&
 	   mangle->target != ARPT_CONTINUE)
-		return false;
-	return true;
+		return ARPT_MANGLE_ERR_TARGET;
+	return ARPT_MANGLE_ERR_MAX;
 }
 
 static struct xt_target arpt_mangle_reg __read_mostly = {


Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@mail.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
