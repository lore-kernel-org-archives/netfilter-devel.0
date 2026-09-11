Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F20D45D902;
	Fri, 11 Sep 2026 08:44:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789116295; cv=none; b=VkXzSxiguLuA5JNpJYhriF7ieq0fLmZls0oomieJLTgqUbuAcaqadMmZWgoWeecdBSkMineKWjmAvQgKh8iefk3kkHiLjFjGVPlQE8SnklviGVL6fx/t8kYO8J1PcKJX2ITNWAgZtDLEBijV+UyyxHqw+7lTCvi+xrgd9j4A8KE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789116295; c=relaxed/simple;
	bh=iaKa92tJ1z2xwfKI8PAnqVaungGZ0RI6glzrIr+0TKQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZoI7Pns254G5LmZ59gn+brWU7sqlC/4RqG2G94wI3x5KphYbj8qyEzhg3DS9L9LjKUatjwrV7+pexOb68kY2BzS4PBaKOgAnT6lnytO6TrcvTsSvUZbedSStkM2nVaSbEjYl7nTG5DINlaVvWj2aG/9v0wB75J7U93YM/ZemYXM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=NpRvegHH; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="NpRvegHH"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1789116286;
	bh=DMc20cCMqrrl+ymi9jTXrzoyjnygZO75pGdS4OwoytY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NpRvegHHdo2KsmMHBRE/RVZdVPvVnmxlM2SjrsOsE9/C0H3HT7JfANS7Ra8ka6gaB
	 9IBjjYFjjuG/SXgINmL6fLA2Njfd4DfpQPzinloFP4lmO13J3FW13j7IvnwHFrwNXH
	 2aJP51TugWgQbA0QisVL6h4+HEGTJ2ZKZGWGshu9dDBEU6dz+chGw44GeoXXdXKSfN
	 PWZmZVREr0NP7egzSOmL60OEMbsCbxkVxfi1D9FGOzCMwbhzLUZplgmTyREEztIrTI
	 VRDWOByjxEk4WOaF19Zv4R+KFg1GxkcwLwvRueNMHp/KX2+EN4C5DIWn6iT/0bdr7M
	 4nJ5SzcEgvT/Q==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 79072603DE;
	Fri, 11 Sep 2026 10:44:45 +0200 (CEST)
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	horms@kernel.org,
	fw@strlen.de,
	ja@ssi.bg
Subject: [PATCH net-next 1/8] netfilter: seqadj: do not take ct lock if seqadj is NULL
Date: Fri, 11 Sep 2026 10:44:30 +0200
Message-ID: <20260911084437.1838161-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260911084437.1838161-1-pablo@netfilter.org>
References: <20260911084437.1838161-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Fernando Fernandez Mancera <fmancera@suse.de>

This is a small optimization, only take ct lock if seqadj is present. In
the unlikely case seqadj isn't present we can return immediately. This
is consistent with the behavior of other functions that checks seqadj.

Signed-off-by: Fernando Fernandez Mancera <fmancera@suse.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_conntrack_seqadj.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/net/netfilter/nf_conntrack_seqadj.c b/net/netfilter/nf_conntrack_seqadj.c
index 220216a4edc5..d75e8dafb189 100644
--- a/net/netfilter/nf_conntrack_seqadj.c
+++ b/net/netfilter/nf_conntrack_seqadj.c
@@ -10,20 +10,19 @@
 int nf_ct_seqadj_init(struct nf_conn *ct, enum ip_conntrack_info ctinfo,
 		      s32 off)
 {
+	struct nf_conn_seqadj *seqadj = nfct_seqadj(ct);
 	enum ip_conntrack_dir dir = CTINFO2DIR(ctinfo);
-	struct nf_conn_seqadj *seqadj;
 	struct nf_ct_seqadj *this_way;
 
 	if (off == 0)
 		return 0;
 
-	spin_lock_bh(&ct->lock);
-	seqadj = nfct_seqadj(ct);
-	if (!seqadj) {
-		spin_unlock_bh(&ct->lock);
+	if (unlikely(!seqadj))
 		return 0;
-	}
+
 	set_bit(IPS_SEQ_ADJUST_BIT, &ct->status);
+
+	spin_lock_bh(&ct->lock);
 	this_way = &seqadj->seq[dir];
 	this_way->offset_before	 = off;
 	this_way->offset_after	 = off;
-- 
2.47.3

