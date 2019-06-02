Return-Path: <SRS0=NG1t=UB=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1C70C282DC
	for <netfilter-devel@archiver.kernel.org>; Sun,  2 Jun 2019 13:13:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A8FC727915
	for <netfilter-devel@archiver.kernel.org>; Sun,  2 Jun 2019 13:13:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726616AbfFBNNx (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 2 Jun 2019 09:13:53 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:53398 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726084AbfFBNNw (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 2 Jun 2019 09:13:52 -0400
Received: by mail-wm1-f65.google.com with SMTP id d17so1062243wmb.3
        for <netfilter-devel@vger.kernel.org>; Sun, 02 Jun 2019 06:13:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=iMDuebfalYVbvDyIm8oZK6A1oCkIXWhd4+TpMKu6Z0Y=;
        b=OjtsBS7Jfim4Y42JUrPSJi3cY/AXx3KHpsY+oU0IoEnvlvifZQgbxyaETmy7Z5BR6S
         hB54mp3gpNQtxY99AqlE2DB0D4YfFcV05Mk8zKjQ6sPRFni4XnlCiy4oMHsZesYxyMCE
         O9aZYsiSECr7dwIvCIu33t6hqjQKkfyRCHiXN+5iqeG1tgokMg9/R6q54W0QrcAfR4ar
         Cub/1G/2vM7JnIiIoEgPQ5p00emWuDmmvgAYFZCkUU3+5lMsEEk5AVX8PXmNUpEmpw65
         uOhZ57KEan6fj/K8qpp4w1n6nDRz7SZnjK2MDqCMYsIKiOUsidgKiCW2cNWaRfXKHARp
         Ywew==
X-Gm-Message-State: APjAAAV0bg8cY1XAK0dLG78v8i+4NqGBomDxKbTTCplKnR4KqS3EGCFI
        +YRixQSJ0oRkxfvcPe1yUPhQz/na00E=
X-Google-Smtp-Source: APXvYqyYaeL3NU4KBZyB56XCOqKug+UFoybzHMzRTXMLQJ7Z4FnbqJ5i9GcrIFzW3+pyQSraoituTQ==
X-Received: by 2002:a1c:c909:: with SMTP id f9mr11271945wmb.115.1559481230772;
        Sun, 02 Jun 2019 06:13:50 -0700 (PDT)
Received: from linux.home (2a01cb05850ddf00045dd60e6368f84b.ipv6.abo.wanadoo.fr. [2a01:cb05:850d:df00:45d:d60e:6368:f84b])
        by smtp.gmail.com with ESMTPSA id f10sm21506134wrg.24.2019.06.02.06.13.48
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Sun, 02 Jun 2019 06:13:50 -0700 (PDT)
Date:   Sun, 2 Jun 2019 15:13:47 +0200
From:   Guillaume Nault <gnault@redhat.com>
To:     netdev@vger.kernel.org, netfilter-devel@vger.kernel.org
Cc:     Peter Oskolkov <posk@google.com>, Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH net] netfilter: ipv6: nf_defrag: fix leakage of unqueued
 fragments
Message-ID: <51d82a9bd6312e51a56ccae54e00452a0ef957dd.1559480671.git.gnault@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

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
---
Not sure if this should got to the net or nf tree (as the original patch
went through net). Anyway this patch applies cleanly to both.

 net/ipv6/netfilter/nf_conntrack_reasm.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/net/ipv6/netfilter/nf_conntrack_reasm.c b/net/ipv6/netfilter/nf_conntrack_reasm.c
index 3de0e9b0a482..5b3f65e29b6f 100644
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
@@ -480,12 +484,6 @@ int nf_ct_frag6_gather(struct net *net, struct sk_buff *skb, u32 user)
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

