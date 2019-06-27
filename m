Return-Path: <SRS0=TR/Z=U2=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C399EC48BD6
	for <netfilter-devel@archiver.kernel.org>; Thu, 27 Jun 2019 00:44:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9C35A20815
	for <netfilter-devel@archiver.kernel.org>; Thu, 27 Jun 2019 00:44:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1561596283;
	bh=6Z3cj53GSfYzAfPAXGYhyrX0O/+vCJfobNxE5a6Ybk8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=yLYDHKtozRDzXjXKzNzzxM0z7m+Wft+seOv4s7n5O/j5rMRsi6J0X0gwgtNNGSO/R
	 m5C9a86iiUE8LR2v5gxEGLGcdlfNIm2jL2heIis+TuWNC+v4wejPOyG6Dr/Ii00aPK
	 w3+nyZmfMR7qI0gQh73TRTvk1KeVe1/JlDbYOagk=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729598AbfF0Alz (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 26 Jun 2019 20:41:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:45608 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729594AbfF0Alx (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 26 Jun 2019 20:41:53 -0400
Received: from sasha-vm.mshome.net (unknown [107.242.116.147])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BBFD721852;
        Thu, 27 Jun 2019 00:41:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561596113;
        bh=6Z3cj53GSfYzAfPAXGYhyrX0O/+vCJfobNxE5a6Ybk8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=z7f4WBvEvBSAV/nNdMoQnTbocTBIpNqtMz4cLA/JDoVEqfl1r/cO9Twjdi3bUbugc
         aDun5ziXmLUYvx+OrIe5wLbfdWkPujyKLPNyjZvEXs4K1Bp/Tg9F8/7JHDHnvFpHIH
         T2hLMgK4UHSFvjocRanX2R40ZqhM+Uvz0oWm0Vk0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Guillaume Nault <gnault@redhat.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 09/21] netfilter: ipv6: nf_defrag: accept duplicate fragments again
Date:   Wed, 26 Jun 2019 20:41:09 -0400
Message-Id: <20190627004122.21671-9-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190627004122.21671-1-sashal@kernel.org>
References: <20190627004122.21671-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Guillaume Nault <gnault@redhat.com>

[ Upstream commit 8a3dca632538c550930ce8bafa8c906b130d35cf ]

When fixing the skb leak introduced by the conversion to rbtree, I
forgot about the special case of duplicate fragments. The condition
under the 'insert_error' label isn't effective anymore as
nf_ct_frg6_gather() doesn't override the returned value anymore. So
duplicate fragments now get NF_DROP verdict.

To accept duplicate fragments again, handle them specially as soon as
inet_frag_queue_insert() reports them. Return -EINPROGRESS which will
translate to NF_STOLEN verdict, like any accepted fragment. However,
such packets don't carry any new information and aren't queued, so we
just drop them immediately.

Fixes: a0d56cb911ca ("netfilter: ipv6: nf_defrag: fix leakage of unqueued fragments")
Signed-off-by: Guillaume Nault <gnault@redhat.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/netfilter/nf_conntrack_reasm.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/net/ipv6/netfilter/nf_conntrack_reasm.c b/net/ipv6/netfilter/nf_conntrack_reasm.c
index e6114a6710e0..0b53d1907e4a 100644
--- a/net/ipv6/netfilter/nf_conntrack_reasm.c
+++ b/net/ipv6/netfilter/nf_conntrack_reasm.c
@@ -264,8 +264,14 @@ static int nf_ct_frag6_queue(struct frag_queue *fq, struct sk_buff *skb,
 
 	prev = fq->q.fragments_tail;
 	err = inet_frag_queue_insert(&fq->q, skb, offset, end);
-	if (err)
+	if (err) {
+		if (err == IPFRAG_DUP) {
+			/* No error for duplicates, pretend they got queued. */
+			kfree_skb(skb);
+			return -EINPROGRESS;
+		}
 		goto insert_error;
+	}
 
 	if (dev)
 		fq->iif = dev->ifindex;
@@ -303,8 +309,6 @@ static int nf_ct_frag6_queue(struct frag_queue *fq, struct sk_buff *skb,
 	return -EINPROGRESS;
 
 insert_error:
-	if (err == IPFRAG_DUP)
-		goto err;
 	inet_frag_kill(&fq->q);
 err:
 	skb_dst_drop(skb);
-- 
2.20.1

