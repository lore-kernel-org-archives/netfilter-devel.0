Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B75E25B093
	for <netfilter-devel@vger.kernel.org>; Tue, 14 Jul 2026 13:18:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784035135; cv=none; b=qH9vSeCOReX/PoGFiI2LDJaVk7cdbzgAgusI8VP2fYqDJr3VToKzzXtOL2GpwL5pkpqghts8hpHVOn+nIfxxJzhU9gCTl7OS5n7NhT/L3HFJQP36GedYCII6ZBrgbH66Xvgyr1C+prjFvbGRRzw0sc38sv3ujJsRnu8epLdJfH4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784035135; c=relaxed/simple;
	bh=3xfkJWsiyowoA48S2G18+lRRtB2j7W6bV8+apzPCYps=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gX2Yb1yypruGkYnjf0j0Ak553AYsVf/LAXX8MicEhauwY/N4MlQ9/NGtbGuv3Sv+km01JCRhDOZKfvnofCGw92KcRzpMA+aD9FrebeabaemFS3E6WA9cFFYbqbV4xaRUOPIc9RycnxhPygplCwp0vZ4IZPDYkycmVxcKhlgKo/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 5AA8F606E9; Tue, 14 Jul 2026 15:18:49 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: kadlec@netfilter.org,
	Florian Westphal <fw@strlen.de>
Subject: [PATCH RFC nf-next 02/12] netfilter: ipset: rework cidr bookkeeping fixups
Date: Tue, 14 Jul 2026 15:18:18 +0200
Message-ID: <20260714131828.10685-3-fw@strlen.de>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260714131828.10685-1-fw@strlen.de>
References: <20260714131828.10685-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

should be squash-committed, kept extra for transparency.

Assisted-by: Claude:claude-opus-4-6
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/ipset/ip_set_hash_gen.h | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/net/netfilter/ipset/ip_set_hash_gen.h b/net/netfilter/ipset/ip_set_hash_gen.h
index a6b282ad8c48..49b2d998117e 100644
--- a/net/netfilter/ipset/ip_set_hash_gen.h
+++ b/net/netfilter/ipset/ip_set_hash_gen.h
@@ -338,8 +338,11 @@ mtype_add_cidr(struct ip_set *set, struct htype *h, u8 cidr, u8 n)
 	len++;
 	tmp = kzalloc(sizeof(struct net_prefixes) +
 		      len * sizeof(struct net_prefix), GFP_ATOMIC);
-	if (!tmp)
-		return -ENOMEM;
+	if (!tmp) {
+		ret = -ENOMEM;
+		goto unlock;
+	}
+
 	tmp->len = len;
 	for (i = 0, j = 0; i < nets->len; i++) {
 		if (!nets->nets[i].count)
@@ -366,7 +369,8 @@ static void
 mtype_del_cidr(struct ip_set *set, struct htype *h, u8 cidr, u8 n)
 {
 	struct net_prefixes *nets, *tmp;
-	u8 i, j, found, len = 0;
+	u8 i, j, len = 0;
+	int found;
 
 	spin_lock_bh(&set->lock);
 	nets = __ipset_dereference(h->rnets[n]);
@@ -377,7 +381,8 @@ mtype_del_cidr(struct ip_set *set, struct htype *h, u8 cidr, u8 n)
 			found = i;
 	}
 	if (unlikely(found == -1))
-		return;
+		goto unlock;
+
 	nets->nets[found].count--;
 	if (nets->nets[found].count)
 		goto unlock;
@@ -386,7 +391,8 @@ mtype_del_cidr(struct ip_set *set, struct htype *h, u8 cidr, u8 n)
 		      len * sizeof(struct net_prefix), GFP_ATOMIC);
 	if (!tmp)
 		/* Leave a hole */
-		return;
+		goto unlock;
+
 	tmp->len = len;
 	for (i = 0, j = 0; i < nets->len; i++) {
 		if (!nets->nets[i].count || i == found)
-- 
2.54.0

