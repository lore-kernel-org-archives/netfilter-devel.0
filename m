Received: from sender-op-o17.zoho.eu (sender-op-o17.zoho.eu [136.143.169.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8129B3C4143;
	Tue, 16 Jun 2026 18:30:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.169.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781634656; cv=pass; b=HPIUjUeLUPheIMFv2wx2PNlyoud/o5eD7WvvTeckzdsOHLweJJBwmHwbogrGlUV4Za1F0h6Zd86WqQitdhSWxoE7kxX66LrtPztgpyxUD2d8NJv8bNdXUDvmBVI3slmtjuwZaLD6CtedzAxuXhOtE8RDkKFsPHfSIBVDKWZ1d2c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781634656; c=relaxed/simple;
	bh=2A6STF/MS+4ul6GuxfPH6JzRgXXUBeXshuUyEuGTass=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pqV/MScV+GG3faPGq/VWP4AId2s/uyRzyQ5/yY+gF0BiKmcOlIdP0U/r0v0VjTgjoYEU04/fleSwMt08Xozd6FJpPooT5F303GodweXq04qK9Lk0nHwfbMbEHYYR16Jdwq/PIEuBcYhtt78m8ytxQXc2P/zz99kLll4jECcihvc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=carlosgrillet.me; spf=pass smtp.mailfrom=carlosgrillet.me; dkim=pass (1024-bit key) header.d=carlosgrillet.me header.i=carlos@carlosgrillet.me header.b=hh5XxhAN; arc=pass smtp.client-ip=136.143.169.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=carlosgrillet.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=carlosgrillet.me
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=carlosgrillet.me header.i=carlos@carlosgrillet.me header.b="hh5XxhAN"
ARC-Seal: i=1; a=rsa-sha256; t=1781634628; cv=none; 
	d=zohomail.eu; s=zohoarc; 
	b=INsQMuaH03qg6w0nsSgRvM7IKjqYmB2OgBLtb55xuu0vGvgRLiw1XpiqYDp7ECtCfi3U7X3udjF4tM7fLQRHAN8umSsaQO1upAmCdKQD/9JLWo6mFDQfSor7FHP4a45givDZPExDO9/H2Y/BY93/9xp7StJ6Zgl2RssKEOAj84A=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
	t=1781634628; h=Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=e3M0BYPSTdgDLkWHJBCNI7FKNBWlduHVIRnKBaVQo0Y=; 
	b=WCm5xbhWt7OPS6niQcZIrbfxPK86mcf0kLCuAzYpdElkqrqdkzu0UcNAvskznEDEVCXpSmOwadbyfN4kPWhnR2GT0UUGqAvSCewUaTaGfplLXFSvX17FANOx35YDDG56uoCxw0LyGiMp8AaLTNWNP1sCRvdqTljJpP+HnTHbQQs=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
	dkim=pass  header.i=carlosgrillet.me;
	spf=pass  smtp.mailfrom=carlos@carlosgrillet.me;
	dmarc=pass header.from=<carlos@carlosgrillet.me>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1781634628;
	s=zmail; d=carlosgrillet.me; i=carlos@carlosgrillet.me;
	h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-ID:In-Reply-To:References:MIME-Version:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=e3M0BYPSTdgDLkWHJBCNI7FKNBWlduHVIRnKBaVQo0Y=;
	b=hh5XxhANC9/rkGZVoSEkvnwU/OijVKMS9ZMAn9ccUmP3AXLVfkAy5CqbY2OfBrGU
	UvhQWD4zMnywSHLCP3Q/bo1dmHXHhO/K+I1Nso6QNa26Q6JOj2WnvXuxt5DAP2gebEK
	G2oFaBVwpB4dlInhVAvw6MGgAn3wo4awlYcZIYS8=
Received: by mx.zoho.eu with SMTPS id 1781634626473581.2920691887233;
	Tue, 16 Jun 2026 20:30:26 +0200 (CEST)
From: Carlos Grillet <carlos@carlosgrillet.me>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	Phil Sutter <phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	linux-kernel@vger.kernel.org,
	netdev@vger.kernel.org
Subject: [PATCH nf-next v3 3/4] netfilter: nf_sockopt: replace u_int8_t with u8
Date: Tue, 16 Jun 2026 20:29:45 +0200
Message-ID: <20260616182948.96865-4-carlos@carlosgrillet.me>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616182948.96865-1-carlos@carlosgrillet.me>
References: <20260616182948.96865-1-carlos@carlosgrillet.me>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External

Replace POSIX u_int8_t with preferred kernel type u8, update prototype
and struct definition.

No functional changes.

Signed-off-by: Carlos Grillet <carlos@carlosgrillet.me>
---
 include/linux/netfilter.h  | 6 +++---
 net/netfilter/nf_sockopt.c | 8 ++++----
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/include/linux/netfilter.h b/include/linux/netfilter.h
index efbbfa770d66..91b68bdba3f5 100644
--- a/include/linux/netfilter.h
+++ b/include/linux/netfilter.h
@@ -181,7 +181,7 @@ static inline void nf_hook_state_init(struct nf_hook_state *p,
 struct nf_sockopt_ops {
 	struct list_head list;
 
-	u_int8_t pf;
+	u8 pf;
 
 	/* Non-inclusive ranges: use 0/0/NULL to never get called. */
 	int set_optmin;
@@ -357,9 +357,9 @@ NF_HOOK_LIST(uint8_t pf, unsigned int hook, struct net *net, struct sock *sk,
 }
 
 /* Call setsockopt() */
-int nf_setsockopt(struct sock *sk, u_int8_t pf, int optval, sockptr_t opt,
+int nf_setsockopt(struct sock *sk, u8 pf, int optval, sockptr_t opt,
 		  unsigned int len);
-int nf_getsockopt(struct sock *sk, u_int8_t pf, int optval, char __user *opt,
+int nf_getsockopt(struct sock *sk, u8 pf, int optval, char __user *opt,
 		  int *len);
 
 struct flowi;
diff --git a/net/netfilter/nf_sockopt.c b/net/netfilter/nf_sockopt.c
index 34afcd03b6f6..19a1d028158c 100644
--- a/net/netfilter/nf_sockopt.c
+++ b/net/netfilter/nf_sockopt.c
@@ -59,8 +59,8 @@ void nf_unregister_sockopt(struct nf_sockopt_ops *reg)
 }
 EXPORT_SYMBOL(nf_unregister_sockopt);
 
-static struct nf_sockopt_ops *nf_sockopt_find(struct sock *sk, u_int8_t pf,
-		int val, int get)
+static struct nf_sockopt_ops *nf_sockopt_find(struct sock *sk, u8 pf,
+					      int val, int get)
 {
 	struct nf_sockopt_ops *ops;
 
@@ -89,7 +89,7 @@ static struct nf_sockopt_ops *nf_sockopt_find(struct sock *sk, u_int8_t pf,
 	return ops;
 }
 
-int nf_setsockopt(struct sock *sk, u_int8_t pf, int val, sockptr_t opt,
+int nf_setsockopt(struct sock *sk, u8 pf, int val, sockptr_t opt,
 		  unsigned int len)
 {
 	struct nf_sockopt_ops *ops;
@@ -104,7 +104,7 @@ int nf_setsockopt(struct sock *sk, u_int8_t pf, int val, sockptr_t opt,
 }
 EXPORT_SYMBOL(nf_setsockopt);
 
-int nf_getsockopt(struct sock *sk, u_int8_t pf, int val, char __user *opt,
+int nf_getsockopt(struct sock *sk, u8 pf, int val, char __user *opt,
 		  int *len)
 {
 	struct nf_sockopt_ops *ops;
-- 
2.54.0

