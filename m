Return-Path: <SRS0=LpWG=7J=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.8 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 505D2C433E2
	for <netfilter-devel@archiver.kernel.org>; Wed, 27 May 2020 22:40:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2D5B7208C3
	for <netfilter-devel@archiver.kernel.org>; Wed, 27 May 2020 22:40:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725956AbgE0Wkp (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 27 May 2020 18:40:45 -0400
Received: from correo.us.es ([193.147.175.20]:33432 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725601AbgE0Wko (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 27 May 2020 18:40:44 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id E173BEB47D
        for <netfilter-devel@vger.kernel.org>; Thu, 28 May 2020 00:40:42 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id D5567DA715
        for <netfilter-devel@vger.kernel.org>; Thu, 28 May 2020 00:40:42 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id CA770DA709; Thu, 28 May 2020 00:40:42 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id BAEE6DA709;
        Thu, 28 May 2020 00:40:39 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 28 May 2020 00:40:39 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 8CE1342EF4E0;
        Thu, 28 May 2020 00:40:39 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH 1/3] netfilter: conntrack: Pass value of ctinfo to __nf_conntrack_update
Date:   Thu, 28 May 2020 00:40:16 +0200
Message-Id: <20200527224018.3610-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200527224018.3610-1-pablo@netfilter.org>
References: <20200527224018.3610-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Nathan Chancellor <natechancellor@gmail.com>

Clang warns:

net/netfilter/nf_conntrack_core.c:2068:21: warning: variable 'ctinfo' is
uninitialized when used here [-Wuninitialized]
        nf_ct_set(skb, ct, ctinfo);
                           ^~~~~~
net/netfilter/nf_conntrack_core.c:2024:2: note: variable 'ctinfo' is
declared here
        enum ip_conntrack_info ctinfo;
        ^
1 warning generated.

nf_conntrack_update was split up into nf_conntrack_update and
__nf_conntrack_update, where the assignment of ctinfo is in
nf_conntrack_update but it is used in __nf_conntrack_update.

Pass the value of ctinfo from nf_conntrack_update to
__nf_conntrack_update so that uninitialized memory is not used
and everything works properly.

Fixes: ee04805ff54a ("netfilter: conntrack: make conntrack userspace helpers work again")
Link: https://github.com/ClangBuiltLinux/linux/issues/1039
Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_conntrack_core.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 08e0c19f6b39..e3b054a2f796 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -2017,11 +2017,11 @@ static void nf_conntrack_attach(struct sk_buff *nskb, const struct sk_buff *skb)
 }
 
 static int __nf_conntrack_update(struct net *net, struct sk_buff *skb,
-				 struct nf_conn *ct)
+				 struct nf_conn *ct,
+				 enum ip_conntrack_info ctinfo)
 {
 	struct nf_conntrack_tuple_hash *h;
 	struct nf_conntrack_tuple tuple;
-	enum ip_conntrack_info ctinfo;
 	struct nf_nat_hook *nat_hook;
 	unsigned int status;
 	int dataoff;
@@ -2146,7 +2146,7 @@ static int nf_conntrack_update(struct net *net, struct sk_buff *skb)
 		return 0;
 
 	if (!nf_ct_is_confirmed(ct)) {
-		err = __nf_conntrack_update(net, skb, ct);
+		err = __nf_conntrack_update(net, skb, ct, ctinfo);
 		if (err < 0)
 			return err;
 	}
-- 
2.20.1

