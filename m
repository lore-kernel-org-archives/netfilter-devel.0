Return-Path: <SRS0=TR/Z=U2=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65EFCC48BD3
	for <netfilter-devel@archiver.kernel.org>; Thu, 27 Jun 2019 00:49:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3D30B2084B
	for <netfilter-devel@archiver.kernel.org>; Thu, 27 Jun 2019 00:49:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1561596578;
	bh=nLlFqg5KO2/WNwbDcbQbSwsk6pUXyLSYlEn8F/TGQ5I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=hqdDiMTaUXR3yOQ3ALaTz3/w3wH092JfBkl7a0aIWYg4ajUFxaKYtNngdUkGfOgc3
	 GG3uCDOLNlG5dFDISwmuPdYKO7WlcXmJWR/PGIA+bM/fLANQp1NHJPjJD250q1+VGl
	 kQ+LUgN4uK5vdd0s6LEG9ZJpqp2TNPJyAJzXl3YI=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728533AbfF0AhL (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 26 Jun 2019 20:37:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:41720 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727283AbfF0AhK (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 26 Jun 2019 20:37:10 -0400
Received: from sasha-vm.mshome.net (unknown [107.242.116.147])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 178082080C;
        Thu, 27 Jun 2019 00:37:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561595829;
        bh=nLlFqg5KO2/WNwbDcbQbSwsk6pUXyLSYlEn8F/TGQ5I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tWZA3Se0OMHeF85DCtgdoBH3BQ5N8fSoclCpSIDFYzgbDhDAvTMkxgjmwX6X3ruVJ
         b8YBl0P/o3aGp9QiF1MNobAzhMIjClJPOutFNFNGIx7JtsQ/V4vb4oDAB4HH09sO2j
         JVkez3L5aJppZjwQ1pgr21OWs8vRRhZGfiaQ8CL4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Guillaume Nault <gnault@redhat.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 18/60] netfilter: ipv6: nf_defrag: fix leakage of unqueued fragments
Date:   Wed, 26 Jun 2019 20:35:33 -0400
Message-Id: <20190627003616.20767-18-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190627003616.20767-1-sashal@kernel.org>
References: <20190627003616.20767-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Guillaume Nault <gnault@redhat.com>

[ Upstream commit a0d56cb911ca301de81735f1d73c2aab424654ba ]

With commit 997dd9647164 ("net: IP6 defrag: use rbtrees in
nf_conntrack_reasm.c"), nf_ct_frag6_reasm() is now called from
nf_ct_frag6_queue(). With this change, nf_ct_frag6_queue() can fail
after the skb has been added to the fragment queue and
nf_ct_frag6_gather() was adapted to handle this case.

But nf_ct_frag6_queue() can still fail before the fragment has been
queued. nf_ct_frag6_gather() can't handle this case anymore, because it
has no way to know if nf_ct_frag6_queue() queued the fragment before
failing. If it didn't, the skb is lost as the error code is overwritten
with -EINPROGRESS.

Fix this by setting -EINPROGRESS directly in nf_ct_frag6_queue(), so
that nf_ct_frag6_gather() can propagate the error as is.

Fixes: 997dd9647164 ("net: IP6 defrag: use rbtrees in nf_conntrack_reasm.c")
Signed-off-by: Guillaume Nault <gnault@redhat.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/netfilter/nf_conntrack_reasm.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/net/ipv6/netfilter/nf_conntrack_reasm.c b/net/ipv6/netfilter/nf_conntrack_reasm.c
index cb1b4772dac0..73c29ddcfb95 100644
--- a/net/ipv6/netfilter/nf_conntrack_reasm.c
+++ b/net/ipv6/netfilter/nf_conntrack_reasm.c
@@ -293,7 +293,11 @@ static int nf_ct_frag6_queue(struct frag_queue *fq, struct sk_buff *skb,
 		skb->_skb_refdst = 0UL;
 		err = nf_ct_frag6_reasm(fq, skb, prev, dev);
 		skb->_skb_refdst = orefdst;
-		return err;
+
+		/* After queue has assumed skb ownership, only 0 or
+		 * -EINPROGRESS must be returned.
+		 */
+		return err ? -EINPROGRESS : 0;
 	}
 
 	skb_dst_drop(skb);
@@ -481,12 +485,6 @@ int nf_ct_frag6_gather(struct net *net, struct sk_buff *skb, u32 user)
 		ret = 0;
 	}
 
-	/* after queue has assumed skb ownership, only 0 or -EINPROGRESS
-	 * must be returned.
-	 */
-	if (ret)
-		ret = -EINPROGRESS;
-
 	spin_unlock_bh(&fq->q.lock);
 	inet_frag_put(&fq->q);
 	return ret;
-- 
2.20.1

