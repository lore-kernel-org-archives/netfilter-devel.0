Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36938478841;
	Tue, 20 Jan 2026 19:18:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768936699; cv=none; b=M1EFHcYAMBEk8P8IhbZQWcffs3el7M8w2qmc+wfeuW2mKwBnmfSroZSaDqzAno4fIqA/LM94h0bK1U/G3UG6XEAj7wcU61xtEfOawODimBQkDiW4vJuzKUbeLPOS2q+OibAF1n+2Nvb3xh6OjcKLqwdKqqcOhMfvzMX1xV6N9SY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768936699; c=relaxed/simple;
	bh=eW563qpwKCDct05uBuv+qaimQOkppWUpauty7RhA68c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Hs8FHLwLgwa71q09VavA4NJ52xj9CNbvlmekRyd0lCjF7HL08Kly2d+rlCP/ZlKVjvrAPXSYplRTr9H4sBA5HqeoE8QU+5723PVzsASM/ZVAN0+7ditfsxpFSMnBor8hxA9aowl4emZ+aBrRgrGyim+cZu3VHYOlb5qKhf9zK6A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id ED45F602AB; Tue, 20 Jan 2026 20:18:15 +0100 (CET)
From: Florian Westphal <fw@strlen.de>
To: <netdev@vger.kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	<netfilter-devel@vger.kernel.org>,
	pablo@netfilter.org
Subject: [PATCH net-next 02/10] netfilter: nf_conntrack: Add allow_clash to generic protocol handler
Date: Tue, 20 Jan 2026 20:17:55 +0100
Message-ID: <20260120191803.22208-3-fw@strlen.de>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260120191803.22208-1-fw@strlen.de>
References: <20260120191803.22208-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Yuto Hamaguchi <Hamaguchi.Yuto@da.MitsubishiElectric.co.jp>

The upstream commit, 71d8c47fc653711c41bc3282e5b0e605b3727956
 ("netfilter: conntrack: introduce clash resolution on insertion race"),
sets allow_clash=true in the UDP/UDPLITE protocol handler
but does not set it in the generic protocol handler.

As a result, packets composed of connectionless protocols at each layer,
such as UDP over IP-in-IP, still drop packets due to conflicts during conntrack insertion.

To resolve this, this patch sets allow_clash in the nf_conntrack_l4proto_generic.

Signed-off-by: Yuto Hamaguchi <Hamaguchi.Yuto@da.MitsubishiElectric.co.jp>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nf_conntrack_proto_generic.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/netfilter/nf_conntrack_proto_generic.c b/net/netfilter/nf_conntrack_proto_generic.c
index e831637bc8ca..cb260eb3d012 100644
--- a/net/netfilter/nf_conntrack_proto_generic.c
+++ b/net/netfilter/nf_conntrack_proto_generic.c
@@ -67,6 +67,7 @@ void nf_conntrack_generic_init_net(struct net *net)
 const struct nf_conntrack_l4proto nf_conntrack_l4proto_generic =
 {
 	.l4proto		= 255,
+	.allow_clash            = true,
 #ifdef CONFIG_NF_CONNTRACK_TIMEOUT
 	.ctnl_timeout		= {
 		.nlattr_to_obj	= generic_timeout_nlattr_to_obj,
-- 
2.52.0

