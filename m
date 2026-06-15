Received: from sender-op-o17.zoho.eu (sender-op-o17.zoho.eu [136.143.169.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 749893F20FA;
	Mon, 15 Jun 2026 13:39:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.169.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781530776; cv=pass; b=Y+rkWkDFmnzgEaiW33a7ZaC0GwMopQX/uMcUyghjr6+LkzNiBujXe5UKD3W4Yzy3jlbIRWaeYp8Htd2vgey8shr2/G4LBTKl/QovnBJMZJ6XG3zhtaCRfjiZWfR+NBN6HPApVrtNCEWPBqIuwYNLk5Brym0yZH0svufsUWghVjU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781530776; c=relaxed/simple;
	bh=REH0d3wYoIYM1ZfwUz5WWrrGIOX6hD42sKYZ0MI/c68=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZVOTaS9x5PrnivQYi+llVxU0ndqiryQ/J5TUgnzdR3ckuXedsyOosYmJ3aE2JWclNKwB39kTxb/V8FX+PFhCy+2kc/DujfA/Zn7pA8nH64TN6qDI0pHC4nwe/ooAOEmnvrfYi+vffR5gAapR/X1EAf3dvwaPN+TZGrWiRWXS2ro=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=carlosgrillet.me; spf=pass smtp.mailfrom=carlosgrillet.me; dkim=pass (1024-bit key) header.d=carlosgrillet.me header.i=carlos@carlosgrillet.me header.b=ixnlaDcA; arc=pass smtp.client-ip=136.143.169.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=carlosgrillet.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=carlosgrillet.me
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=carlosgrillet.me header.i=carlos@carlosgrillet.me header.b="ixnlaDcA"
ARC-Seal: i=1; a=rsa-sha256; t=1781530746; cv=none; 
	d=zohomail.eu; s=zohoarc; 
	b=RYQkKzZgu8SMCQsV2aEEhFdaUW5GpyR6qDZUJOebmf7El18MhZVYsDE+IsaHp9oNwAwF8p3G6OfF8W7jaUbGk2K294gsfyXOd9pz5dEx8EzASooWgJNPzryTT4DVl5w6jCUYCJoz0W+X63a52+a5f8M4gyae17H3n1O58KA/dP8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
	t=1781530746; h=Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=0KL/XF/Vvi8vAhmaVj+NFnFKfoqpckK1aQ0xkfQQy4E=; 
	b=DNlWILKVp/I0z0z8cvu9ZWU1qGVt0PUDWI1MH+CpHarXEIvadpeVT7rM+leKCziClwwQ7YxVVcKx4A82yrdrBxri1++n75iCdT6z29MVYqRT8LSj4HpkRE4pSKIaNYhwLwDV/XOoSLnU+ikC9PY6z0Ie/+r6vYmmocWZpCttc8o=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
	dkim=pass  header.i=carlosgrillet.me;
	spf=pass  smtp.mailfrom=carlos@carlosgrillet.me;
	dmarc=pass header.from=<carlos@carlosgrillet.me>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1781530746;
	s=zmail; d=carlosgrillet.me; i=carlos@carlosgrillet.me;
	h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-ID:In-Reply-To:References:MIME-Version:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=0KL/XF/Vvi8vAhmaVj+NFnFKfoqpckK1aQ0xkfQQy4E=;
	b=ixnlaDcA9I/skteiPL31TXlkd2Ll2XLGih+vUaZMdXO9vSJv73nRkB0Cy2re2Fcv
	w6WxNNz4b9q/YNa8Z4dVEWwW1uiJlogIWOlbO4zubW9QgZeeIujqED1rPS3d173Jj7N
	59Bdj+cHF2p0QQ15bZg37UmmVtJji70xHVWAkiGM=
Received: by mx.zoho.eu with SMTPS id 1781530744489219.34624245425812;
	Mon, 15 Jun 2026 15:39:04 +0200 (CEST)
From: Carlos Grillet <carlos@carlosgrillet.me>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	Phil Sutter <phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH nf-next v2 2/6] netfilter: nf_nat_irc: replace u_int16_t with u16
Date: Mon, 15 Jun 2026 15:38:27 +0200
Message-ID: <20260615133835.51273-3-carlos@carlosgrillet.me>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260615133835.51273-1-carlos@carlosgrillet.me>
References: <20260615133835.51273-1-carlos@carlosgrillet.me>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External

Replace POSIX u_int16_t with preferred kernel type u16

No functional changes.

Signed-off-by: Carlos Grillet <carlos@carlosgrillet.me>
---
 net/netfilter/nf_nat_irc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nf_nat_irc.c b/net/netfilter/nf_nat_irc.c
index 19c4fcc60c50..14b79cb0171b 100644
--- a/net/netfilter/nf_nat_irc.c
+++ b/net/netfilter/nf_nat_irc.c
@@ -39,7 +39,7 @@ static unsigned int help(struct sk_buff *skb,
 	char buffer[sizeof("4294967296 65635")];
 	struct nf_conn *ct = exp->master;
 	union nf_inet_addr newaddr;
-	u_int16_t port;
+	u16 port;
 
 	/* Reply comes from server. */
 	newaddr = ct->tuplehash[IP_CT_DIR_REPLY].tuple.dst.u3;
-- 
2.54.0

