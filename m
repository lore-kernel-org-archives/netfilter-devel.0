Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE02114265E;
	Thu, 13 Jun 2024 11:44:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718279095; cv=none; b=dxeyP6cF+CW4oAwmZz6iWb02QuyWPS26G/R42SKr/Q1FqWOBDrI9aoV94Otlh48KCFeA5yeSzdxmk1b2qVxUjFs4uUZE5S8KAUnnbgH41A7Xjx1aXKnDswcSVoduJLchh2jRSkaB/4NAn3HHYH4+msihBCiGGn08U+5Vj6I3V3A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718279095; c=relaxed/simple;
	bh=qzlKT4fcHXVEBSswqCe1rkOpfAVYTIqPYfQkBN3Lu5k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VZRoDt5iGDwiaopcJyY3RGdy3UUkkEPfOaQ0l3uhBZtJ6GaKqWGCazvFcBiBcyhGT1zBmQiKpyoajzj1ZaLDzJwFkT4f3zq1NW+mWBPV5Bbc4jsbMdXH8sVmPBjIpXU54zfVRMfTXhmAAgjMpXevsTrl6flkchI7RLM/Hr3XrkI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Fk0dtEjS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Fk0dtEjS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3867AC2BBFC;
	Thu, 13 Jun 2024 11:44:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718279095;
	bh=qzlKT4fcHXVEBSswqCe1rkOpfAVYTIqPYfQkBN3Lu5k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Fk0dtEjSCMKwy6pLV3HoKCOky+RuwfzO+riJtr061aVhid3DOAv96xdN9Sl79QvWD
	 +9xAoAMskYjzuq5TxymR4A9bLuEblevgSt1kqEphb92TJ1PgBRpO+U0GL9noB4Xzay
	 R9XUR8gEsEsDmCSl3khtUPhkYZi2oO1mZIawSgfQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org,
	netfilter-devel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 4.19 173/213] netfilter: nf_tables: GC transaction race with abort path
Date: Thu, 13 Jun 2024 13:33:41 +0200
Message-ID: <20240613113234.657005933@linuxfoundation.org>
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

commit 720344340fb9be2765bbaab7b292ece0a4570eae upstream.

Abort path is missing a synchronization point with GC transactions. Add
GC sequence number hence any GC transaction losing race will be
discarded.

Fixes: 5f68718b34a5 ("netfilter: nf_tables: GC transaction API to avoid race with control plane")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/netfilter/nf_tables_api.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -7263,7 +7263,12 @@ static int __nf_tables_abort(struct net
 static int nf_tables_abort(struct net *net, struct sk_buff *skb)
 {
 	struct nftables_pernet *nft_net = net_generic(net, nf_tables_net_id);
-	int ret = __nf_tables_abort(net);
+	unsigned int gc_seq;
+	int ret;
+
+	gc_seq = nft_gc_seq_begin(nft_net);
+	ret = __nf_tables_abort(net);
+	nft_gc_seq_end(nft_net, gc_seq);
 
 	mutex_unlock(&nft_net->commit_mutex);
 


