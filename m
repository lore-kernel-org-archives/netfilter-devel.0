Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59B693750AC;
	Mon,  1 Jun 2026 11:59:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780315178; cv=none; b=fETJSMmhZNbPqDVwwFYlDgZ4IrXiw2X+q+cxjfz5fGOZm/1zTNvm7xDoRkUbnbKzTiutRG2sUGnvNGPFGkP766/rwq13VRiEYGkYevH1Y8KQfEw9+fjd9JWbfjwIDZ/2MjuqzyPJ9xCoUwQcExJwkzDGNsYjHQIXiGv3XtNpWRA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780315178; c=relaxed/simple;
	bh=QZ0apMCbznkAV09Rae3k0byTKykQFRZjLsyp+2UFI14=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UBndxgf9N7Z+mgFCYZumvEEPJfOMl28s4wacDemgz5dSFJiSgZm6kUvO7nKTOdFhiqOYfs3d4TFhIuStn7Z/LxWNLnsuOJY+ankKhT17XJz+yHsooakpLcQHx0LnLZShnkV6R8hpzReexvEbgpRRRGFAj3YUrZ+uy0ZlsHUdg4s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=thYHiBs0; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="thYHiBs0"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 798B2601C0;
	Mon,  1 Jun 2026 13:59:35 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1780315175;
	bh=eKRDaHlGUG6ho3Yv9yKjx24a6ppl0LwRpybO7OmgciY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=thYHiBs04h/xt0nBv81Od6Huq5NMOJmSNZI38RC5AfzZMECrIhP8G5CRANEn6k9A9
	 vkCPlGnJmkpdGV9HJPeVKk6scGVJFzLNid8J8uB8Y3PPaKWQw8zYrzYMGpoAWP7Bms
	 jYaVo026NOGhN107Y+xh9/FrlVSkPZ8Eykd/Dp6FIHyNiOLqrHeLuYx6vl+CpM7lhN
	 xKtGminA5ZmQHyfycIeeUZhMnQMmXgSQLX4OOgOiuKzricpVHzzGtpnDx7UDTiUQAX
	 LTvfzvrYu7MTXYXK4ITIISiu+HLf9gSPUKnnDjJIFKMQM7EVaSAzNIxcdDesGcM20f
	 VzKJwdr/aoRHQ==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH net 6/9] netfilter: nft_tunnel: fix use-after-free on object destroy
Date: Mon,  1 Jun 2026 13:59:20 +0200
Message-ID: <20260601115923.433946-7-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260601115923.433946-1-pablo@netfilter.org>
References: <20260601115923.433946-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Tristan Madani <tristan@talencesecurity.com>

nft_tunnel_obj_destroy() calls metadata_dst_free() which directly
kfree()s the metadata_dst, ignoring the dst_entry refcount. Packets
that took a reference via dst_hold() in nft_tunnel_obj_eval() and
are still queued (e.g. in a netem qdisc) are left with a dangling
pointer. When these packets are eventually dequeued, dst_release()
operates on freed memory.

Replace metadata_dst_free() with dst_release() so the metadata_dst
is freed only after all references are dropped. The dst subsystem
already handles metadata_dst cleanup in dst_destroy() when
DST_METADATA is set.

Fixes: af308b94a2a4 ("netfilter: nf_tables: add tunnel support")
Cc: stable@vger.kernel.org
Signed-off-by: Tristan Madani <tristan@talencesecurity.com>
Reviewed-by: Fernando Fernandez Mancera <fmancera@suse.de>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_tunnel.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nft_tunnel.c b/net/netfilter/nft_tunnel.c
index 0b987bc2132a..68f7cfbbee06 100644
--- a/net/netfilter/nft_tunnel.c
+++ b/net/netfilter/nft_tunnel.c
@@ -676,7 +676,7 @@ static void nft_tunnel_obj_destroy(const struct nft_ctx *ctx,
 {
 	struct nft_tunnel_obj *priv = nft_obj_data(obj);
 
-	metadata_dst_free(priv->md);
+	dst_release(&priv->md->dst);
 }
 
 static struct nft_object_type nft_tunnel_obj_type;
-- 
2.47.3

