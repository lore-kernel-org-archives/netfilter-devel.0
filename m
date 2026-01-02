Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D01B30DD1F;
	Fri,  2 Jan 2026 11:41:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767354115; cv=none; b=QtH+hTZgKcthmwB0euJ4QRMIfb1LMCBhRKS/xQAxx5ocHWv22g9rN8jQynS3MSD8uOKmNmxBCJsAoCnDHsAFkpqIv2urFCkl8HhqRnBQ7Ep0kqxyROALlflCNgl6ar1cf4l0Jft2QJnzsOQlXSmJ7pjteue5wWOCRVQZUL/op2Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767354115; c=relaxed/simple;
	bh=nD7CDz5VvNs4eMNH5Jikd/2qDM/wjsgsq7JhjLbJ+IA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FxKnCaxIIgPFBisBJHo91Jix7yQmEnY6Oc2ATeWzfokG4fhRosgQYZGCZRzDENnuQouIZP35Bl9YH5P13ENxQGIV+g/SJWBq8Y+AI5pGOj7v6PAfRDLORhcmuwDi0+mJTKmi7T4nKqi6HxD/GyKUHmQAQ4Ta6Jh02lDV9M+oV1M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 9AF61602F8; Fri, 02 Jan 2026 12:41:50 +0100 (CET)
From: Florian Westphal <fw@strlen.de>
To: <netdev@vger.kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	<netfilter-devel@vger.kernel.org>,
	pablo@netfilter.org
Subject: [PATCH net 3/6] netfilter: nft_synproxy: avoid possible data-race on update operation
Date: Fri,  2 Jan 2026 12:41:25 +0100
Message-ID: <20260102114128.7007-4-fw@strlen.de>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260102114128.7007-1-fw@strlen.de>
References: <20260102114128.7007-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Fernando Fernandez Mancera <fmancera@suse.de>

During nft_synproxy eval we are reading nf_synproxy_info struct which
can be modified on update operation concurrently. As nf_synproxy_info
struct fits in 32 bits, use READ_ONCE/WRITE_ONCE annotations.

Fixes: ee394f96ad75 ("netfilter: nft_synproxy: add synproxy stateful object support")
Signed-off-by: Fernando Fernandez Mancera <fmancera@suse.de>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nft_synproxy.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/nft_synproxy.c b/net/netfilter/nft_synproxy.c
index 5d3e51825985..4d3e5a31b412 100644
--- a/net/netfilter/nft_synproxy.c
+++ b/net/netfilter/nft_synproxy.c
@@ -48,7 +48,7 @@ static void nft_synproxy_eval_v4(const struct nft_synproxy *priv,
 				 struct tcphdr *_tcph,
 				 struct synproxy_options *opts)
 {
-	struct nf_synproxy_info info = priv->info;
+	struct nf_synproxy_info info = READ_ONCE(priv->info);
 	struct net *net = nft_net(pkt);
 	struct synproxy_net *snet = synproxy_pernet(net);
 	struct sk_buff *skb = pkt->skb;
@@ -79,7 +79,7 @@ static void nft_synproxy_eval_v6(const struct nft_synproxy *priv,
 				 struct tcphdr *_tcph,
 				 struct synproxy_options *opts)
 {
-	struct nf_synproxy_info info = priv->info;
+	struct nf_synproxy_info info = READ_ONCE(priv->info);
 	struct net *net = nft_net(pkt);
 	struct synproxy_net *snet = synproxy_pernet(net);
 	struct sk_buff *skb = pkt->skb;
@@ -340,7 +340,7 @@ static void nft_synproxy_obj_update(struct nft_object *obj,
 	struct nft_synproxy *newpriv = nft_obj_data(newobj);
 	struct nft_synproxy *priv = nft_obj_data(obj);
 
-	priv->info = newpriv->info;
+	WRITE_ONCE(priv->info, newpriv->info);
 }
 
 static struct nft_object_type nft_synproxy_obj_type;
-- 
2.51.2

