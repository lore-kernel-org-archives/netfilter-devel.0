Return-Path: <SRS0=/8pw=SU=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B171C10F14
	for <netfilter-devel@archiver.kernel.org>; Thu, 18 Apr 2019 13:22:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3B6DE2183E
	for <netfilter-devel@archiver.kernel.org>; Thu, 18 Apr 2019 13:22:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="Fs0VyDQS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389041AbfDRNWP (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 18 Apr 2019 09:22:15 -0400
Received: from terminus.zytor.com ([198.137.202.136]:42299 "EHLO
        terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729497AbfDRNWP (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 18 Apr 2019 09:22:15 -0400
Received: from terminus.zytor.com (localhost [127.0.0.1])
        by terminus.zytor.com (8.15.2/8.15.2) with ESMTPS id x3IDLQnF202464
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
        Thu, 18 Apr 2019 06:21:26 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 terminus.zytor.com x3IDLQnF202464
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
        s=2019041745; t=1555593687;
        bh=f39eIQZ5TlLhxbNH4SALdnUKF1DtiDvWIKSLTxUulvU=;
        h=Date:From:Cc:Reply-To:To:Subject:From;
        b=Fs0VyDQSaVUTxo1Ch9LuCWLBXTfn1R1XhudrU1pvTZR0XFl/WeDPxX4n81uDD5LJK
         VXmDgNijliBczO4bsR71V/1ZssXCd0+Zq8Po7c8rJi2yeYc0ByZ36Tftl3IiXtkZBu
         YvG29cJV7gJE3aD2XqV4yJ3B7cB/zluK8lTvK/T9STQ5DZUCidZBcz5yyo+6WbAtNG
         cEV30sH6GR1q004pISO/3a833T69TjWlfdZ7Zhg2VCMyDCgp3h7EWm33dF7L3L/LTe
         01cPHsJnry+OSUocCIJOYGV/lLK4a3KAQpj/vtnm17ve4DUURs9AvEtJQq85mpAPAQ
         uD2ZfU+VFWsfw==
Received: (from tipbot@localhost)
        by terminus.zytor.com (8.15.2/8.15.2/Submit) id x3IDLPbQ202461;
        Thu, 18 Apr 2019 06:21:25 -0700
Date:   Thu, 18 Apr 2019 06:21:25 -0700
X-Authentication-Warning: terminus.zytor.com: tipbot set sender to tipbot@zytor.com using -f
From:   "tip-bot for Paul E. McKenney" <tipbot@zytor.com>
Message-ID: <tip-bee58fe346750d53e3cf141554eea6164c8c748a@git.kernel.org>
Cc:     paulmck@linux.ibm.com, yoshfuji@linux-ipv6.org, hpa@zytor.com,
        davem@davemloft.net, tglx@linutronix.de,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, fw@strlen.de, kuznet@ms2.inr.ac.ru,
        mingo@kernel.org, pablo@netfilter.org
Reply-To: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
          pablo@netfilter.org, fw@strlen.de, kuznet@ms2.inr.ac.ru,
          mingo@kernel.org, hpa@zytor.com, yoshfuji@linux-ipv6.org,
          paulmck@linux.ibm.com, netfilter-devel@vger.kernel.org,
          coreteam@netfilter.org, davem@davemloft.net, tglx@linutronix.de
To:     linux-tip-commits@vger.kernel.org
Subject: [tip:core/rcu] net/ipv4/netfilter: Update comment from
 call_rcu_bh() to call_rcu()
Git-Commit-ID: bee58fe346750d53e3cf141554eea6164c8c748a
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from
 these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Commit-ID:  bee58fe346750d53e3cf141554eea6164c8c748a
Gitweb:     https://git.kernel.org/tip/bee58fe346750d53e3cf141554eea6164c8c748a
Author:     Paul E. McKenney <paulmck@linux.ibm.com>
AuthorDate: Wed, 9 Jan 2019 14:52:05 -0800
Committer:  Paul E. McKenney <paulmck@linux.ibm.com>
CommitDate: Tue, 9 Apr 2019 08:06:41 -0700

net/ipv4/netfilter: Update comment from call_rcu_bh() to call_rcu()

The RCU flavors have been consolidated, so this commit replaces a
comment's mention of call_rcu_bh() with call_rcu().

Signed-off-by: Paul E. McKenney <paulmck@linux.ibm.com>
Cc: Florian Westphal <fw@strlen.de>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>
Cc: Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
Cc: <netfilter-devel@vger.kernel.org>
Cc: <coreteam@netfilter.org>
Cc: <netdev@vger.kernel.org>
Acked-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/ipv4/netfilter/ipt_CLUSTERIP.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/netfilter/ipt_CLUSTERIP.c b/net/ipv4/netfilter/ipt_CLUSTERIP.c
index 835d50b279f5..a2a88ab07f7b 100644
--- a/net/ipv4/netfilter/ipt_CLUSTERIP.c
+++ b/net/ipv4/netfilter/ipt_CLUSTERIP.c
@@ -56,7 +56,7 @@ struct clusterip_config {
 #endif
 	enum clusterip_hashmode hash_mode;	/* which hashing mode */
 	u_int32_t hash_initval;			/* hash initialization */
-	struct rcu_head rcu;			/* for call_rcu_bh */
+	struct rcu_head rcu;			/* for call_rcu */
 	struct net *net;			/* netns for pernet list */
 	char ifname[IFNAMSIZ];			/* device ifname */
 };
