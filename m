Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54CCA142911;
	Thu, 13 Jun 2024 11:44:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718279089; cv=none; b=GF06uYniTUhGoZGKYnH93wk6tv2xwwrQNCUNJMJAerHGRsCWSjME1CXUbgsa7ASpw70ma4JBaEQv86BqPNrgTy1Br6bKlWsyDvy8m8zA/CfflX8Hvsn2f5/ELPOP1PlWp6LoXoebphUmNc95fdXHGNPXraYxRFrVLYT1SiH7p9c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718279089; c=relaxed/simple;
	bh=FQS4ZOJlri7LL5Cp8F2gswHEfFtfb//Q4CJBEdGXUdM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Emzveys0PPhXsyQjbEi/02JuzXhlIZP2vSrbqvlOxmaV1MKQo7qZhcmUnJ6xlJRVTZOCrXrY161+ll+ez+5ew0T4FKDkaQUcMktFle6b8DLXSHToMGZNjgNKOtvHpUYQ44ZtDTnd7ZDibfe/nhXKudeP+tQ2omwrt9yuBIa3A9A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uA3hZgD0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uA3hZgD0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AFB4C2BBFC;
	Thu, 13 Jun 2024 11:44:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718279089;
	bh=FQS4ZOJlri7LL5Cp8F2gswHEfFtfb//Q4CJBEdGXUdM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uA3hZgD0RBTFBd+KtamxkKlFGibqtKcyy1rBtROUM0205t+USD8WrTq/2RrqzYVIV
	 QLqEitAl1Scbo7bYXVLZuQksAbjq+S66nvAu7flGNDKUt6+MIJ03e/RXw+wDACFL+C
	 Ii55jajm4e8iRdND6T7FxBGM3cGDnBKbBzRF9e84=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org,
	netfilter-devel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>
Subject: [PATCH 4.19 171/213] netfilter: nf_tables: fix GC transaction races with netns and netlink event exit path
Date: Thu, 13 Jun 2024 13:33:39 +0200
Message-ID: <20240613113234.580337363@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113227.969123070@linuxfoundation.org>
References: <20240613113227.969123070@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
 net/netfilter/nf_tables_api.c |   30 ++++++++++++++++++++++++++----
 1 file changed, 26 insertions(+), 4 deletions(-)

--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -6899,6 +6899,22 @@ void nft_trans_gc_queue_sync_done(struct
 }
 EXPORT_SYMBOL_GPL(nft_trans_gc_queue_sync_done);
 
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
@@ -6953,9 +6969,7 @@ static int nf_tables_commit(struct net *
 	while (++nft_net->base_seq == 0)
 		;
 
-	/* Bump gc counter, it becomes odd, this is the busy mark. */
-	gc_seq = READ_ONCE(nft_net->gc_seq);
-	WRITE_ONCE(nft_net->gc_seq, ++gc_seq);
+	gc_seq = nft_gc_seq_begin(nft_net);
 
 	/* step 3. Start new generation, rules_gen_X now in use. */
 	net->nft.gencursor = nft_gencursor_next(net);
@@ -7083,7 +7097,7 @@ static int nf_tables_commit(struct net *
 	nf_tables_commit_release(net);
 	nf_tables_gen_notify(net, skb, NFT_MSG_NEWGEN);
 
-	WRITE_ONCE(nft_net->gc_seq, ++gc_seq);
+	nft_gc_seq_end(nft_net, gc_seq);
 	mutex_unlock(&nft_net->commit_mutex);
 
 	return 0;
@@ -7898,11 +7912,19 @@ static int __net_init nf_tables_init_net
 static void __net_exit nf_tables_exit_net(struct net *net)
 {
 	struct nftables_pernet *nft_net = net_generic(net, nf_tables_net_id);
+	unsigned int gc_seq;
 
 	mutex_lock(&nft_net->commit_mutex);
+
+	gc_seq = nft_gc_seq_begin(nft_net);
+
 	if (!list_empty(&nft_net->commit_list))
 		__nf_tables_abort(net);
+
 	__nft_release_tables(net);
+
+	nft_gc_seq_end(nft_net, gc_seq);
+
 	mutex_unlock(&nft_net->commit_mutex);
 	WARN_ON_ONCE(!list_empty(&nft_net->tables));
 }


