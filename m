Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93776C77B76
	for <netfilter-devel@archiver.kernel.org>; Sun, 23 Apr 2023 02:38:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229970AbjDWCif (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 22 Apr 2023 22:38:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229556AbjDWCie (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 22 Apr 2023 22:38:34 -0400
X-Greylist: delayed 438 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sat, 22 Apr 2023 19:38:32 PDT
Received: from mail-m2849.qiye.163.com (mail-m2849.qiye.163.com [103.74.28.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5F612109;
        Sat, 22 Apr 2023 19:38:32 -0700 (PDT)
Received: from localhost.localdomain (unknown [106.75.220.2])
        by mail-m2839.qiye.163.com (Hmail) with ESMTPA id 0E826C028F;
        Sun, 23 Apr 2023 10:31:04 +0800 (CST)
From:   Faicker Mo <faicker.mo@ucloud.cn>
To:     faicker.mo@ucloud.cn
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] netfilter: conntrack: allow insertion clash of gre protocol
Date:   Sun, 23 Apr 2023 10:29:57 +0800
Message-Id: <20230423022958.1770634-1-faicker.mo@ucloud.cn>
X-Mailer: git-send-email 2.39.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-HM-Spam-Status: e1kfGhgUHx5ZQUhXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
        tZV1koWUFJQjdXWS1ZQUlXWQ8JGhUIEh9ZQVkZHh1MVktOQ0MZTUlJQkoeGFUZERMWGhIXJBQOD1
        lXWRgSC1lBWUpLTVVMTlVJSUtVSVlXWRYaDxIVHRRZQVlPS0hVSkhCQk1KVU9VSk9ZBg++
X-HM-Tid: 0a87abf357f88421kuqw0e826c028f
X-HM-MType: 1
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6KzI6Ayo4LjJCPz0RIQJITEwR
        HTcaCxVVSlVKTUNJSUpMS01OSkNLVTMWGhIXVR0aEhgQHglVFhQ7DhgXFA4fVRgVRVlXWRILWUFZ
        SktNVUxOVUlJS1VJWVdZCAFZQUlISks3Bg++
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

NVGRE tunnel is used in the VM-to-VM communications. The VM packets
are encapsulated in NVGRE and sent from the host. For NVGRE
there are two tuples(outer sip and outer dip) in the host conntrack item.
Insertion clashes are more likely to happen if the concurrent connections
are sent from the VM.

Signed-off-by: Faicker Mo <faicker.mo@ucloud.cn>
---
 net/netfilter/nf_conntrack_proto_gre.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/netfilter/nf_conntrack_proto_gre.c b/net/netfilter/nf_conntrack_proto_gre.c
index 728eeb0aea87..ad6f0ca40cd2 100644
--- a/net/netfilter/nf_conntrack_proto_gre.c
+++ b/net/netfilter/nf_conntrack_proto_gre.c
@@ -296,6 +296,7 @@ void nf_conntrack_gre_init_net(struct net *net)
 /* protocol helper struct */
 const struct nf_conntrack_l4proto nf_conntrack_l4proto_gre = {
 	.l4proto	 = IPPROTO_GRE,
+	.allow_clash	 = true,
 #ifdef CONFIG_NF_CONNTRACK_PROCFS
 	.print_conntrack = gre_print_conntrack,
 #endif
-- 
2.39.1

