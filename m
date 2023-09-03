Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E08BC83F2D
	for <netfilter-devel@archiver.kernel.org>; Sun,  3 Sep 2023 17:12:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236699AbjICRMZ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 3 Sep 2023 13:12:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343839AbjICRMZ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 3 Sep 2023 13:12:25 -0400
Received: from taras.nevrast.org (unknown [IPv6:2a05:d01c:431:aa03:b7e1:333d:ea2a:b14e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 357CD19B
        for <netfilter-devel@vger.kernel.org>; Sun,  3 Sep 2023 10:11:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20220717; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=w0BFYdFXIE9jgruSz4HmqWrS3ykGMU9T+gxKBAaMZmo=; b=JO8ggBrh/GiKKIDF1jl//+8oSI
        2MoCJ3pJqH6fLQiEdpEv2QWr7oJRJ/gJvJYiWs3iOzzT4NjEACUeKXwkSPbZd63Yb0leaULWRU7U0
        tqeGGmpI76Ri1TsgO9I2I/HuQ9HuEketK4Rgju8IqKlB9y2zMZU9vUDb0L3z06G/Oreu6iMO6G2Pi
        V452I9+RkxPlBtNeBSISwlVzd6LI8NmyiR/Rrrv0WnYW9on4DaXZpb50W7PQmO/DCcxZaLD1YxeMs
        HWqgNYLiI4IRxrzygBdj6Ttt8HKflMQf5RjqmhetX70UbRPaD5GHxq19uc99E9IPi4jfDSHRrdTAz
        EGVb9WTA==;
Received: from [2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608] (helo=ulthar.dreamlands)
        by taras.nevrast.org with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.96)
        (envelope-from <jeremy@azazel.net>)
        id 1qcqc3-0048iL-1B
        for netfilter-devel@vger.kernel.org;
        Sun, 03 Sep 2023 18:10:15 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH libnetfilter_conntrack 2/2] conntrack: fix BPF for filtering IPv6 addresses
Date:   Sun,  3 Sep 2023 18:10:09 +0100
Message-Id: <20230903171009.2002392-2-jeremy@azazel.net>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230903171009.2002392-1-jeremy@azazel.net>
References: <20230903171009.2002392-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on taras.nevrast.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Each address in the filter is matched one 32-bit word at a time.  If any of the
first three words don't match, we jump to the end of the filter.  If the last
word does match, we jump to the end of the filter.  However, this is not right:
it means that if any of the first three words of an address don't match, all
subsequent addresses will be skipped.  Instead, jump to the next address.

Fix formatting of `nfct_bsf_cmp_k_stack`.

Link: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=690676
Closes: https://bugzilla.netfilter.org/show_bug.cgi?id=1062
Fixes: dd73e5708cc2 ("bsf: add support for IPv6 address filtering")
Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 src/conntrack/bsf.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/src/conntrack/bsf.c b/src/conntrack/bsf.c
index 35cc8b7690c0..48fd4fafbc3e 100644
--- a/src/conntrack/bsf.c
+++ b/src/conntrack/bsf.c
@@ -163,7 +163,7 @@ struct jump {
 
 static int
 nfct_bsf_cmp_k_stack(struct sock_filter *this, int k, 
-	       int jump_true, int pos, struct stack *s)
+		     int jump_true, int pos, struct stack *s)
 {
 	struct sock_filter __code = {
 		.code	= BPF_JMP|BPF_JEQ|BPF_K,
@@ -640,8 +640,8 @@ bsf_add_addr_ipv6_filter(const struct nfct_filter *f,
 					      j);
 			if (k < 3) {
 				j += nfct_bsf_cmp_k_stack_jf(this, ip,
-						jf - j - 1,
-						j, s);
+							     (3 - k) * 3 + 1,
+							     j, s);
 			} else {
 				/* last word: jump if true */
 				j += nfct_bsf_cmp_k_stack(this, ip, jf - j,
@@ -655,7 +655,7 @@ bsf_add_addr_ipv6_filter(const struct nfct_filter *f,
 			this[jmp.line].jt += jmp.jt + j;
 		}
 		if (jmp.jf) {
-			this[jmp.line].jf += jmp.jf + j;
+			this[jmp.line].jf += jmp.jf;
 		}
 	}
 
-- 
2.40.1

