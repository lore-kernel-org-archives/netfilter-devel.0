Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33365C433FE
	for <netfilter-devel@archiver.kernel.org>; Thu,  6 Oct 2022 00:28:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229545AbiJFA2u (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 5 Oct 2022 20:28:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229567AbiJFA2r (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 5 Oct 2022 20:28:47 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E82B84E6D
        for <netfilter-devel@vger.kernel.org>; Wed,  5 Oct 2022 17:28:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=0AJFi9cWm0rXgAZuI2RTamfbOZYUg9fVjSjDjqznzXU=; b=Vwrjos9/E8BWp0rlGWEimsNxK+
        DHDBXtK0jxKls7XfPgS5db2iaF+nAHICRG6nk/3rENnPfgZB4DxQuLjurabsraVC7rU9hAlg6yC8x
        O0r9P9DkSb4/Dyf+LUn/ZBlUMr7T333dneOLbK8V/6sAc0d72Hpe3olLOs5QCMoNT7E3iTdPO9UYp
        CLQ2OgOFYgS8kQwDr6uQVcuE7dajSYBLwZEPtb300R1fYtBACU8L5f5ofgqzOLX9kEq4A3IK/sbpR
        utvEQ0Yokc/+M8Qvm2Z5ztfQPXtdFrtQiS676tWH9lNF29l4IeUu/4dIEpmqEAdSXdV9lAL5ztLUd
        dOOZkW+Q==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1ogEkl-0001y9-0a; Thu, 06 Oct 2022 02:28:43 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     netfilter-devel@vger.kernel.org
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Jan Engelhardt <jengelh@inai.de>
Subject: [iptables PATCH 12/12] extensions: NFQUEUE: Do not print default queue number 0
Date:   Thu,  6 Oct 2022 02:28:02 +0200
Message-Id: <20221006002802.4917-13-phil@nwl.cc>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221006002802.4917-1-phil@nwl.cc>
References: <20221006002802.4917-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Instead make sure it is mentioned in help output.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 extensions/libxt_NFQUEUE.c | 27 +++++++++++++++------------
 extensions/libxt_NFQUEUE.t |  4 ++--
 2 files changed, 17 insertions(+), 14 deletions(-)

diff --git a/extensions/libxt_NFQUEUE.c b/extensions/libxt_NFQUEUE.c
index fe5190789e306..9de417ae633ca 100644
--- a/extensions/libxt_NFQUEUE.c
+++ b/extensions/libxt_NFQUEUE.c
@@ -24,7 +24,7 @@ static void NFQUEUE_help(void)
 	printf(
 "NFQUEUE target options\n"
 "  --queue-num value		Send packet to QUEUE number <value>.\n"
-"  		                Valid queue numbers are 0-65535\n"
+"  		                Valid queue numbers are 0-65535 (default 0)\n"
 );
 }
 
@@ -33,7 +33,7 @@ static void NFQUEUE_help_v1(void)
 	printf(
 "NFQUEUE target options\n"
 "  --queue-num value            Send packet to QUEUE number <value>.\n"
-"                               Valid queue numbers are 0-65535\n"
+"                               Valid queue numbers are 0-65535 (default 0)\n"
 "  --queue-balance first:last	Balance flows between queues <value> to <value>.\n");
 }
 
@@ -42,7 +42,7 @@ static void NFQUEUE_help_v2(void)
 	printf(
 "NFQUEUE target options\n"
 "  --queue-num value            Send packet to QUEUE number <value>.\n"
-"                               Valid queue numbers are 0-65535\n"
+"                               Valid queue numbers are 0-65535 (default 0)\n"
 "  --queue-balance first:last   Balance flows between queues <value> to <value>.\n"
 "  --queue-bypass		Bypass Queueing if no queue instance exists.\n"
 "  --queue-cpu-fanout	Use current CPU (no hashing)\n");
@@ -53,7 +53,7 @@ static void NFQUEUE_help_v3(void)
 	printf(
 "NFQUEUE target options\n"
 "  --queue-num value            Send packet to QUEUE number <value>.\n"
-"                               Valid queue numbers are 0-65535\n"
+"                               Valid queue numbers are 0-65535 (default 0)\n"
 "  --queue-balance first:last   Balance flows between queues <value> to <value>.\n"
 "  --queue-bypass               Bypass Queueing if no queue instance exists.\n"
 "  --queue-cpu-fanout	Use current CPU (no hashing)\n");
@@ -157,7 +157,9 @@ static void NFQUEUE_print(const void *ip,
 {
 	const struct xt_NFQ_info *tinfo =
 		(const struct xt_NFQ_info *)target->data;
-	printf(" NFQUEUE num %u", tinfo->queuenum);
+
+	if (tinfo->queuenum)
+		printf(" NFQUEUE num %u", tinfo->queuenum);
 }
 
 static void NFQUEUE_print_v1(const void *ip,
@@ -169,7 +171,7 @@ static void NFQUEUE_print_v1(const void *ip,
 	if (last > 1) {
 		last += tinfo->queuenum - 1;
 		printf(" NFQUEUE balance %u:%u", tinfo->queuenum, last);
-	} else {
+	} else if (tinfo->queuenum) {
 		printf(" NFQUEUE num %u", tinfo->queuenum);
 	}
 }
@@ -183,7 +185,7 @@ static void NFQUEUE_print_v2(const void *ip,
 	if (last > 1) {
 		last += info->queuenum - 1;
 		printf(" NFQUEUE balance %u:%u", info->queuenum, last);
-	} else
+	} else if (info->queuenum)
 		printf(" NFQUEUE num %u", info->queuenum);
 
 	if (info->bypass & NFQ_FLAG_BYPASS)
@@ -199,7 +201,7 @@ static void NFQUEUE_print_v3(const void *ip,
 	if (last > 1) {
 		last += info->queuenum - 1;
 		printf(" NFQUEUE balance %u:%u", info->queuenum, last);
-	} else
+	} else if (info->queuenum)
 		printf(" NFQUEUE num %u", info->queuenum);
 
 	if (info->flags & NFQ_FLAG_BYPASS)
@@ -214,7 +216,8 @@ static void NFQUEUE_save(const void *ip, const struct xt_entry_target *target)
 	const struct xt_NFQ_info *tinfo =
 		(const struct xt_NFQ_info *)target->data;
 
-	printf(" --queue-num %u", tinfo->queuenum);
+	if (tinfo->queuenum)
+		printf(" --queue-num %u", tinfo->queuenum);
 }
 
 static void NFQUEUE_save_v1(const void *ip, const struct xt_entry_target *target)
@@ -225,7 +228,7 @@ static void NFQUEUE_save_v1(const void *ip, const struct xt_entry_target *target
 	if (last > 1) {
 		last += tinfo->queuenum - 1;
 		printf(" --queue-balance %u:%u", tinfo->queuenum, last);
-	} else {
+	} else if (tinfo->queuenum) {
 		printf(" --queue-num %u", tinfo->queuenum);
 	}
 }
@@ -238,7 +241,7 @@ static void NFQUEUE_save_v2(const void *ip, const struct xt_entry_target *target
 	if (last > 1) {
 		last += info->queuenum - 1;
 		printf(" --queue-balance %u:%u", info->queuenum, last);
-	} else
+	} else if (info->queuenum)
 		printf(" --queue-num %u", info->queuenum);
 
 	if (info->bypass & NFQ_FLAG_BYPASS)
@@ -254,7 +257,7 @@ static void NFQUEUE_save_v3(const void *ip,
 	if (last > 1) {
 		last += info->queuenum - 1;
 		printf(" --queue-balance %u:%u", info->queuenum, last);
-	} else
+	} else if (info->queuenum)
 		printf(" --queue-num %u", info->queuenum);
 
 	if (info->flags & NFQ_FLAG_BYPASS)
diff --git a/extensions/libxt_NFQUEUE.t b/extensions/libxt_NFQUEUE.t
index b51b19fd435f7..de816247ef024 100644
--- a/extensions/libxt_NFQUEUE.t
+++ b/extensions/libxt_NFQUEUE.t
@@ -1,6 +1,6 @@
 :INPUT,FORWARD,OUTPUT
 -j NFQUEUE;=;OK
--j NFQUEUE --queue-num 0;=;OK
+-j NFQUEUE --queue-num 0;-j NFQUEUE;OK
 -j NFQUEUE --queue-num 65535;=;OK
 -j NFQUEUE --queue-num 65536;;FAIL
 -j NFQUEUE --queue-num -1;;FAIL
@@ -13,4 +13,4 @@
 -j NFQUEUE --queue-balance 0:6 --queue-cpu-fanout --queue-bypass;-j NFQUEUE --queue-balance 0:6 --queue-bypass --queue-cpu-fanout;OK
 -j NFQUEUE --queue-bypass --queue-balance 0:6 --queue-cpu-fanout;-j NFQUEUE --queue-balance 0:6 --queue-bypass --queue-cpu-fanout;OK
 -j NFQUEUE --queue-balance 0:6 --queue-bypass;=;OK
--j NFQUEUE --queue-bypass;-j NFQUEUE --queue-num 0 --queue-bypass;OK
+-j NFQUEUE --queue-bypass;=;OK
-- 
2.34.1

