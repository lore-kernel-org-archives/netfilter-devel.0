Return-Path: <SRS0=qgEK=A7=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA2E8C4345E
	for <netfilter-devel@archiver.kernel.org>; Mon, 20 Jul 2020 12:53:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C0ED422D02
	for <netfilter-devel@archiver.kernel.org>; Mon, 20 Jul 2020 12:53:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="b3r2mKtI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729583AbgGTMxA (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 20 Jul 2020 08:53:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728639AbgGTMsJ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 20 Jul 2020 08:48:09 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93D01C0619D6;
        Mon, 20 Jul 2020 05:48:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=KEtThMnZn1T5ZTjfnNtMK17c9WUSVU4JmbBC5GmCo8k=; b=b3r2mKtIMupzynpcKcbswq0IqO
        x3CWNt0l1PaHzJxn2EcCC+srtF/Mq7HfV7lip1uXJnLFShlYH6QJQY2jSIkrIhnf3sVEJDkDqNjCk
        V9gH3mJH8SwG877l7uoU1FWRwM1GLEq8XtvlkXitbXzib9XAND6UehTN8tWUA9fqsXsKJmKc92eZP
        41LRqgsw0A7LsuqS0rj5uDt0YAbFizVFlTTXyAufbzXcu0u4npMvicFmVcDeqbg1ysEaqfgYRNkAX
        lniUhrynXQcYhppU4L4hxBrdsYQ3Wipg5bJvAirZt9QkqUN7wtobU7Ll7F9/YFeTzKA4LaNkLx22I
        ibp2wKgg==;
Received: from [2001:4bb8:105:4a81:2a8f:15b1:2c3:7be7] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jxVCp-0004WT-Jf; Mon, 20 Jul 2020 12:47:46 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Eric Dumazet <edumazet@google.com>
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        linux-sctp@vger.kernel.org, linux-hams@vger.kernel.org,
        linux-bluetooth@vger.kernel.org, bridge@lists.linux-foundation.org,
        linux-can@vger.kernel.org, dccp@vger.kernel.org,
        linux-decnet-user@lists.sourceforge.net,
        linux-wpan@vger.kernel.org, linux-s390@vger.kernel.org,
        mptcp@lists.01.org, lvs-devel@vger.kernel.org,
        rds-devel@oss.oracle.com, linux-afs@lists.infradead.org,
        tipc-discussion@lists.sourceforge.net, linux-x25@vger.kernel.org
Subject: [PATCH 02/24] bpfilter: fix up a sparse annotation
Date:   Mon, 20 Jul 2020 14:47:15 +0200
Message-Id: <20200720124737.118617-3-hch@lst.de>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200720124737.118617-1-hch@lst.de>
References: <20200720124737.118617-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The __user doesn't make sense when casting to an integer type.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 net/bpfilter/bpfilter_kern.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/bpfilter/bpfilter_kern.c b/net/bpfilter/bpfilter_kern.c
index 977e9dad72ca4f..713b4b3d02005d 100644
--- a/net/bpfilter/bpfilter_kern.c
+++ b/net/bpfilter/bpfilter_kern.c
@@ -49,7 +49,7 @@ static int __bpfilter_process_sockopt(struct sock *sk, int optname,
 	req.is_set = is_set;
 	req.pid = current->pid;
 	req.cmd = optname;
-	req.addr = (long __force __user)optval;
+	req.addr = (__force long)optval;
 	req.len = optlen;
 	if (!bpfilter_ops.info.tgid)
 		goto out;
-- 
2.27.0

