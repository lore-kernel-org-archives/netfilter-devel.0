Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA77D35202A;
	Sat, 20 Jun 2026 22:27:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781994476; cv=none; b=uKQ/9VPvEXaANGdis78fw5sO2X5kQKQuHkMacC9TExTtT0yov3JSDqPGLV0sDHSiTVKPqehMXtGt35CclSvZbik908AmZZFp4XMZC7rHfzDHtEdf5VtUcWU/r0CtXVv3cvstnk8m+Ou3VvgqKtYh7HY7rCCahj0zG8jY8WGCEQ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781994476; c=relaxed/simple;
	bh=Iujzt5heb9H8WLppDhY1E1rPktZleQ5dnFQhD90BUFc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D/H3GNwpyYFNSv495cYKQayqykK0PXFsNbc66yku6Qxsoqas5lLmyau8E4yJ1X5U64LTpeX3NsUG9FN0k+lhQMFoT3ynex6dZGe9a3ZXZGUJ4F2rsxVBwzX/HqL8akwW9s+OULgZmXyLs+EaKHGB6/7yWWVWNrpMau5UoCO576Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=X4C1l2wn; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="X4C1l2wn"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id A610D601A2;
	Sun, 21 Jun 2026 00:27:51 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1781994472;
	bh=fUUW68ZRi9UR+MamkxJBulOTEpebj5NGu71sMmoSmRI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X4C1l2wnd5csQ6jzPe53DdWK2PlJF2QC285Mpuk3bDUFhNanpuNP2D8N2+esPlOaq
	 aKNimUPLcmkwa15MtjjwB3Jmy8T3hd4ZRf1l1UM3bkG4ROlWpBufGGcAF3Br9BfmmM
	 cHBgi+ADE78QL/G2NpadOHmWzISzfdhmQ2+bkrm8EPQwGEw7E+zPnAH8+5oJ/wgUa8
	 yFLHV78SmbrCSoBHXWpbUb3PvfeYf+TgbUagiZjK4ZD6O+3Z4x4/LqlhpXTSF13CGT
	 uGzsCEAGX1aSn357Au9/hpD0OLNM/3yPE/x/+BkjQiNZ5GchyIgBROAdxPgxAxtRMq
	 tm7ljG/KzEVUg==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH net 08/14] netfilter: ipset: make sure gc is properly stopped
Date: Sun, 21 Jun 2026 00:27:32 +0200
Message-ID: <20260620222738.112506-9-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260620222738.112506-1-pablo@netfilter.org>
References: <20260620222738.112506-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Jozsef Kadlecsik <kadlec@netfilter.org>

Sashiko noticed that when destroying a set,
cancel_delayed_work_sync() was called while gc
calls queue_delayed_work() unconditionally which
can lead not to properly shutting down the gc.

Fixes: f66ee0410b1c ("netfilter: ipset: Fix "INFO: rcu detected stall in hash_xxx" reports")
Signed-off-by: Jozsef Kadlecsik <kadlec@netfilter.org>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/ipset/ip_set_hash_gen.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/ipset/ip_set_hash_gen.h b/net/netfilter/ipset/ip_set_hash_gen.h
index 00c27b95207f..dedf59b661dd 100644
--- a/net/netfilter/ipset/ip_set_hash_gen.h
+++ b/net/netfilter/ipset/ip_set_hash_gen.h
@@ -606,7 +606,7 @@ mtype_cancel_gc(struct ip_set *set)
 	struct htype *h = set->data;
 
 	if (SET_WITH_TIMEOUT(set))
-		cancel_delayed_work_sync(&h->gc.dwork);
+		disable_delayed_work_sync(&h->gc.dwork);
 }
 
 static int
-- 
2.47.3

