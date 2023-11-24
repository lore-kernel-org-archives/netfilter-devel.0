Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29D7D33076;
	Fri, 24 Nov 2023 19:28:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J9XImoJM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACF31C433C7;
	Fri, 24 Nov 2023 19:28:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700854129;
	bh=y3VC7sFgLNCbZVrKvLWtnhpEI0thfgj/FZOeOklv0j4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J9XImoJMmkuGcO2JpSGWYr/CcKWH3Hc2c+TefLINjzNR4zOJddrjVggW4+0KBa0rT
	 jR984pvw8ZznyysxzcilJ0O4qq3yqpCMdGkLrDabwiYOgeTM0c4fm6ijAi3S4dLneA
	 wIwyfIA8r3RO915KHHv5gpF+SaggPZ4AM6zut9uw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org,
	netfilter-devel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>
Subject: [PATCH 5.4 145/159] netfilter: nf_tables: fix GC transaction races with netns and netlink event exit path
Date: Fri, 24 Nov 2023 17:56:02 +0000
Message-ID: <20231124171947.830097689@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124171941.909624388@linuxfoundation.org>
References: <20231124171941.909624388@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pablo Neira Ayuso <pablo@netfilter.org>

commit 6a33d8b73dfac0a41f3877894b38082bd0c9a5bc upstream.

Netlink event path is missing a synchronization point with GC
transactions. Add GC sequence number update to netns release path and
netlink event path, any GC transaction losing race will be discarded.

Fixes: 5f68718b34a5 ("netfilter: nf_tables: GC transaction API to avoid race with control plane")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/netfilter/nf_tables_api.c |   29 +++++++++++++++++++++++++----
 1 file changed, 25 insertions(+), 4 deletions(-)

--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -7178,6 +7178,22 @@ static void nf_tables_commit_release(str
 	mutex_unlock(&nft_net->commit_mutex);
 }
 
+static unsigned int nft_gc_seq_begin(struct nftables_pernet *nft_net)
+{
+	unsigned int gc_seq;
+
+	/* Bump gc counter, it becomes odd, this is the busy mark. */
+	gc_seq = READ_ONCE(nft_net->gc_seq);
+	WRITE_ONCE(nft_net->gc_seq, ++gc_seq);
+
+	return gc_seq;
+}
+
+static void nft_gc_seq_end(struct nftables_pernet *nft_net, unsigned int gc_seq)
+{
+	WRITE_ONCE(nft_net->gc_seq, ++gc_seq);
+}
+
 static int nf_tables_commit(struct net *net, struct sk_buff *skb)
 {
 	struct nftables_pernet *nft_net = net_generic(net, nf_tables_net_id);
@@ -7242,9 +7258,7 @@ static int nf_tables_commit(struct net *
 	while (++nft_net->base_seq == 0)
 		;
 
-	/* Bump gc counter, it becomes odd, this is the busy mark. */
-	gc_seq = READ_ONCE(nft_net->gc_seq);
-	WRITE_ONCE(nft_net->gc_seq, ++gc_seq);
+	gc_seq = nft_gc_seq_begin(nft_net);
 
 	/* step 3. Start new generation, rules_gen_X now in use. */
 	net->nft.gencursor = nft_gencursor_next(net);
@@ -7386,7 +7400,7 @@ static int nf_tables_commit(struct net *
 
 	nf_tables_gen_notify(net, skb, NFT_MSG_NEWGEN);
 
-	WRITE_ONCE(nft_net->gc_seq, ++gc_seq);
+	nft_gc_seq_end(nft_net, gc_seq);
 	nf_tables_commit_release(net);
 
 	return 0;
@@ -8256,11 +8270,18 @@ static void __net_exit nf_tables_pre_exi
 static void __net_exit nf_tables_exit_net(struct net *net)
 {
 	struct nftables_pernet *nft_net = net_generic(net, nf_tables_net_id);
+	unsigned int gc_seq;
 
 	mutex_lock(&nft_net->commit_mutex);
+
+	gc_seq = nft_gc_seq_begin(nft_net);
+
 	if (!list_empty(&nft_net->commit_list))
 		__nf_tables_abort(net, NFNL_ABORT_NONE);
 	__nft_release_tables(net);
+
+	nft_gc_seq_end(nft_net, gc_seq);
+
 	mutex_unlock(&nft_net->commit_mutex);
 	WARN_ON_ONCE(!list_empty(&nft_net->tables));
 	WARN_ON_ONCE(!list_empty(&nft_net->module_list));


