Return-Path: <SRS0=A3Nh=UF=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A79CAC04AB5
	for <netfilter-devel@archiver.kernel.org>; Thu,  6 Jun 2019 16:04:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 86F1B20645
	for <netfilter-devel@archiver.kernel.org>; Thu,  6 Jun 2019 16:04:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729500AbfFFQEF (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 6 Jun 2019 12:04:05 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:38235 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729173AbfFFQEF (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 6 Jun 2019 12:04:05 -0400
Received: by mail-wm1-f65.google.com with SMTP id t5so508131wmh.3
        for <netfilter-devel@vger.kernel.org>; Thu, 06 Jun 2019 09:04:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=OszubVnCVODNZBmqQGFzjHSNQQ6y2nl9r4rIlLMfwbM=;
        b=OyGBIsYMEH8uxMFbsb/deIUi1VNTEgxy16yxgvUIwoHPbIbL6Cw0dhVy4vhyCqRtsp
         Ask2/0FQwa7Nbi3n9iP5bz7xm/5EDXO8AEAaw/ygJyzIwwEAN0e0S9z0rwKZpVTjpkKX
         vqYEb1xihxK7ygH8YW4NBIxou/K4w8lF2phrADLwWGJqGu9Sh8/Ipgr6QOtbo6mXXL5D
         RWpvgOaAMJB+yyWikHsZzXY8EkIZyN/NOtK7cVmTcWx72+mWLoFQBBckztsjqM5dje28
         pK6zqMwdmHu+iUDTzAhfI9HyId+Uv6Fcq2zZWSHjZrT9IB8o7RQ1iCbQX5zpasIzh1ry
         MNWw==
X-Gm-Message-State: APjAAAWCZSwyKThxxJBhrZEG4h/npr1ya1G1Ly1ZZ4mlxOX6wRakMBEB
        hp4SyW+RfnNAFohKIjbyYNyLm664Koo=
X-Google-Smtp-Source: APXvYqwjF2VLquNG/ihL10n2cbuhB43kVabPYxPUydyvwkCYT8QP/MQlNIbeMpDi3DAGgZiWhywAhw==
X-Received: by 2002:a1c:452:: with SMTP id 79mr527646wme.149.1559837042708;
        Thu, 06 Jun 2019 09:04:02 -0700 (PDT)
Received: from linux.home (2a01cb058382ea004233e954b48ed30d.ipv6.abo.wanadoo.fr. [2a01:cb05:8382:ea00:4233:e954:b48e:d30d])
        by smtp.gmail.com with ESMTPSA id 65sm2556940wro.85.2019.06.06.09.04.01
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 06 Jun 2019 09:04:02 -0700 (PDT)
Date:   Thu, 6 Jun 2019 18:04:00 +0200
From:   Guillaume Nault <gnault@redhat.com>
To:     netfilter-devel@vger.kernel.org
Cc:     Peter Oskolkov <posk@google.com>, Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nf] netfilter: ipv6: nf_defrag: accept duplicate fragments
 again
Message-ID: <e8f3e725c5546df221c4aeec340b6bb73631145e.1559836971.git.gnault@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

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
---
 net/ipv6/netfilter/nf_conntrack_reasm.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/net/ipv6/netfilter/nf_conntrack_reasm.c b/net/ipv6/netfilter/nf_conntrack_reasm.c
index 5b3f65e29b6f..8951de8b568f 100644
--- a/net/ipv6/netfilter/nf_conntrack_reasm.c
+++ b/net/ipv6/netfilter/nf_conntrack_reasm.c
@@ -265,8 +265,14 @@ static int nf_ct_frag6_queue(struct frag_queue *fq, struct sk_buff *skb,
 
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
@@ -304,8 +310,6 @@ static int nf_ct_frag6_queue(struct frag_queue *fq, struct sk_buff *skb,
 	return -EINPROGRESS;
 
 insert_error:
-	if (err == IPFRAG_DUP)
-		goto err;
 	inet_frag_kill(&fq->q);
 err:
 	skb_dst_drop(skb);
-- 
2.20.1

