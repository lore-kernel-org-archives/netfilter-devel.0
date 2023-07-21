Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40174EB64DD
	for <netfilter-devel@archiver.kernel.org>; Fri, 21 Jul 2023 20:14:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229597AbjGUUOh (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 21 Jul 2023 16:14:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229560AbjGUUOh (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 21 Jul 2023 16:14:37 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B525D30CB
        for <netfilter-devel@vger.kernel.org>; Fri, 21 Jul 2023 13:14:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=I0tBntSA3pJIvdcW0hqT8eiT2RvjBdVJgANbpcH7//Q=; b=Gtn27H5JitjTbzd3ncgsjDcQV4
        bAxEX+xf4hkLmTEy7pabuYIKmJi1/OBCgaHuPG7GRni1eFla+rFQCwiGBlb0xap1IMpk7cDoSkbAf
        2VqVAEa+K6am8exSDy1BkqvyTQcxFrdihJ/CKYjvTps0jDn64l4DGMQm3JcWj3/WBd5qbItFbffaT
        Nt2MKkPf0zl3/CztkAMA8rlcvoifNFODkk8W+WWYST5pkJBVGxj/CLsKW9X1lxd8T5E8X/6dFY8Dq
        70pfwegBq2ZHGEcv4iybSejyD6DuNsyFUd0SUN67tcMHvWCLbf82DNh/WfHIcbKMIE8UUtlufFWSa
        fgsQpkIA==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1qMwWH-0005j5-Rq
        for netfilter-devel@vger.kernel.org; Fri, 21 Jul 2023 22:14:33 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 1/2] nft: Special casing for among match in compare_matches()
Date:   Fri, 21 Jul 2023 22:14:24 +0200
Message-Id: <20230721201425.16448-1-phil@nwl.cc>
X-Mailer: git-send-email 2.40.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

When other extensions may have "garbage" appended to their data which
should not be considered for match comparison, among match is the
opposite in that it extends its data beyond the value in 'size' field.
Add special casing to cover for this, avoiding false-positive rule
comparison.

Fixes: 26753888720d8 ("nft: bridge: Rudimental among extension support")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/nft-shared.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/iptables/nft-shared.c b/iptables/nft-shared.c
index 12860fbf6d575..0cd082b5396d0 100644
--- a/iptables/nft-shared.c
+++ b/iptables/nft-shared.c
@@ -381,6 +381,7 @@ bool compare_matches(struct xtables_rule_match *mt1,
 	for (mp1 = mt1, mp2 = mt2; mp1 && mp2; mp1 = mp1->next, mp2 = mp2->next) {
 		struct xt_entry_match *m1 = mp1->match->m;
 		struct xt_entry_match *m2 = mp2->match->m;
+		size_t cmplen = mp1->match->userspacesize;
 
 		if (strcmp(m1->u.user.name, m2->u.user.name) != 0) {
 			DEBUGP("mismatching match name\n");
@@ -392,8 +393,10 @@ bool compare_matches(struct xtables_rule_match *mt1,
 			return false;
 		}
 
-		if (memcmp(m1->data, m2->data,
-			   mp1->match->userspacesize) != 0) {
+		if (!strcmp(m1->u.user.name, "among"))
+			cmplen = m1->u.match_size - sizeof(*m1);
+
+		if (memcmp(m1->data, m2->data, cmplen) != 0) {
 			DEBUGP("mismatch match data\n");
 			return false;
 		}
-- 
2.40.0

