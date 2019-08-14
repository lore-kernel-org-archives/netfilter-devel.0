Return-Path: <SRS0=qEnH=WK=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7DE0FC32750
	for <netfilter-devel@archiver.kernel.org>; Wed, 14 Aug 2019 02:31:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4CFAA205F4
	for <netfilter-devel@archiver.kernel.org>; Wed, 14 Aug 2019 02:31:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1565749904;
	bh=16fTqFdG9M6Y56zMIAUmBN+BNC2ON1gMz7VKsrMtRFE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=rHAcrapN6Ed84HxiAtYiR2zdcY7DMNT6xdd6b/ruT8XKehntoVWrHI4/6VExvfI1V
	 4lxQCMdpQyPJZYX0srVa4kiKlGKzgV27RJV3cwZuVNXI8eeiIVWj3xfROUrTdvFDNp
	 EiOBv+mu9ob7zY/PnRN0wrGoXmY0c8BzhHvnQHSg=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729098AbfHNCQe (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 13 Aug 2019 22:16:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:47988 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729049AbfHNCQe (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 13 Aug 2019 22:16:34 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 397EB20842;
        Wed, 14 Aug 2019 02:16:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565748993;
        bh=16fTqFdG9M6Y56zMIAUmBN+BNC2ON1gMz7VKsrMtRFE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zSMojvRxRzjlwegu/CrV+ZVsJJZlBUv3H67pOhq7TknSUYr/ZWShXfWaSzp/LB2RG
         7fkB4Yi3a9RPR3PKv+qtOh99Fbg1o3VqOclR8sjHIGcVtQoqFxMx5SwJNEqGigbd4n
         3GkuWBx7xRNHoSnhBjkgKGWTpmuvEMCN72wUTwVQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Stefano Brivio <sbrivio@redhat.com>, Chen Yi <yiche@redhat.com>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Sasha Levin <sashal@kernel.org>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 25/68] netfilter: ipset: Actually allow destination MAC address for hash:ip,mac sets too
Date:   Tue, 13 Aug 2019 22:15:03 -0400
Message-Id: <20190814021548.16001-25-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190814021548.16001-1-sashal@kernel.org>
References: <20190814021548.16001-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Stefano Brivio <sbrivio@redhat.com>

[ Upstream commit b89d15480d0cacacae1a0fe0b3da01b529f2914f ]

In commit 8cc4ccf58379 ("ipset: Allow matching on destination MAC address
for mac and ipmac sets"), ipset.git commit 1543514c46a7, I removed the
KADT check that prevents matching on destination MAC addresses for
hash:mac sets, but forgot to remove the same check for hash:ip,mac set.

Drop this check: functionality is now commented in man pages and there's
no reason to restrict to source MAC address matching anymore.

Reported-by: Chen Yi <yiche@redhat.com>
Fixes: 8cc4ccf58379 ("ipset: Allow matching on destination MAC address for mac and ipmac sets")
Signed-off-by: Stefano Brivio <sbrivio@redhat.com>
Signed-off-by: Jozsef Kadlecsik <kadlec@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/ipset/ip_set_hash_ipmac.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/net/netfilter/ipset/ip_set_hash_ipmac.c b/net/netfilter/ipset/ip_set_hash_ipmac.c
index fd87de3ed55b3..75c21c8b76514 100644
--- a/net/netfilter/ipset/ip_set_hash_ipmac.c
+++ b/net/netfilter/ipset/ip_set_hash_ipmac.c
@@ -95,10 +95,6 @@ hash_ipmac4_kadt(struct ip_set *set, const struct sk_buff *skb,
 	struct hash_ipmac4_elem e = { .ip = 0, { .foo[0] = 0, .foo[1] = 0 } };
 	struct ip_set_ext ext = IP_SET_INIT_KEXT(skb, opt, set);
 
-	 /* MAC can be src only */
-	if (!(opt->flags & IPSET_DIM_TWO_SRC))
-		return 0;
-
 	if (skb_mac_header(skb) < skb->head ||
 	    (skb_mac_header(skb) + ETH_HLEN) > skb->data)
 		return -EINVAL;
-- 
2.20.1

