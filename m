Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BE5F3E9584;
	Sun, 27 Sep 2026 22:34:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790548485; cv=none; b=p15maEHKCbTxMLvmWhd+t92z0TpKLJHElzsnP3hkmyEA+nSQf9SUusN8lgQntRs77fQ42I7TuGNOMZLCU5VaJ0dtEYEfZMIn1mjfnhioLgv62VytE2+xZruo7gOHYmLxehicFp2ey9tQPSArr0vXS8A3jnFBqoOU6QBqoxFk7wA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790548485; c=relaxed/simple;
	bh=+cNmuMQX38XQG2vWSDZhlcVpRz0sj9K/CiwCbvUQV00=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FtO0My3TafvInL9kSarpFIr0XB5T9ep6G/myHKoUD5rAHP18+aYegt/JwBZJc9tNxmOfD7wrdT94XoA1Rda0I07WYKNJxs7Jks2jK853pQjr6yYiJaqoTFdNuyVW/0+XTufJpc8+51XiDWEyfYSjF+pzk3R+mBGkFhLqy7UU014=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=oId1zdU9; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="oId1zdU9"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1790548482;
	bh=ep8wGD1dmjgwsfRZ8zCpLSqSvbg9EiCBnb14yHD2XjQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oId1zdU9SGcvlxw+pPQHEKAR2ne2RX1n8+A04JR2+wmrYeks88D1m5YwpydVe00KO
	 VtwJT9FDkGwdabTPnnhxAPIOkOJoy0jyI4PGbFVFcKoEjKhGYQK8xLsTxQzQKJlF4R
	 sZZt5T269uFWy7dcNP7FAffvxF1eggwSHY6Ib8cTIbSjZbR+0JSZ/zNqxYgVwJPtd0
	 LKJMuENei5bnhw7apMttRdmkBK5BE3XN+9YQ2dqtOrxSW32WEpLw4oNC1i71TffeIV
	 XBS+epBTtUDAfIm7MEBO1Z/kZapmEi4gA9F3fFyMH3fans0ctHzN2PrQAwNnzksBqg
	 qcBjHO/eHlVLQ==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 8785960081;
	Mon, 28 Sep 2026 00:34:41 +0200 (CEST)
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
Subject: [PATCH net-next 01/11] netfilter: synproxy: fix reset of ct seqadj when reopening a connection
Date: Mon, 28 Sep 2026 00:34:26 +0200
Message-ID: <20260927223436.269024-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260927223436.269024-1-pablo@netfilter.org>
References: <20260927223436.269024-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Fernando Fernandez Mancera <fmancera@suse.de>

SYNPROXY is resetting conntrack seqadj when a closed connection is
re-opened, but it was using nf_ct_seqadj_init() which is a no-op for a
zero offset.

This patch introduces nf_ct_seqadj_reset() which sets the offset values
directly to zero and avoid setting IPS_SEQ_ADJUST_BIT flag, it changes
SYNPROXY code to use it when needed.

Fixes: 48b1de4c110a ("netfilter: add SYNPROXY core/target")
Signed-off-by: Fernando Fernandez Mancera <fmancera@suse.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_conntrack_seqadj.h |  1 +
 net/netfilter/nf_conntrack_seqadj.c         | 17 +++++++++++++++++
 net/netfilter/nf_synproxy_core.c            |  4 ++--
 3 files changed, 20 insertions(+), 2 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack_seqadj.h b/include/net/netfilter/nf_conntrack_seqadj.h
index 883c414b768e..0f5bbb14a25a 100644
--- a/include/net/netfilter/nf_conntrack_seqadj.h
+++ b/include/net/netfilter/nf_conntrack_seqadj.h
@@ -33,6 +33,7 @@ static inline struct nf_conn_seqadj *nfct_seqadj_ext_add(struct nf_conn *ct)
 
 int nf_ct_seqadj_init(struct nf_conn *ct, enum ip_conntrack_info ctinfo,
 		      s32 off);
+void nf_ct_seqadj_reset(struct nf_conn *ct, enum ip_conntrack_info ctinfo);
 int nf_ct_seqadj_set(struct nf_conn *ct, enum ip_conntrack_info ctinfo,
 		     __be32 seq, s32 off);
 void nf_ct_tcp_seqadj_set(struct sk_buff *skb, struct nf_conn *ct,
diff --git a/net/netfilter/nf_conntrack_seqadj.c b/net/netfilter/nf_conntrack_seqadj.c
index d75e8dafb189..b7b166a8ad58 100644
--- a/net/netfilter/nf_conntrack_seqadj.c
+++ b/net/netfilter/nf_conntrack_seqadj.c
@@ -31,6 +31,23 @@ int nf_ct_seqadj_init(struct nf_conn *ct, enum ip_conntrack_info ctinfo,
 }
 EXPORT_SYMBOL_GPL(nf_ct_seqadj_init);
 
+void nf_ct_seqadj_reset(struct nf_conn *ct, enum ip_conntrack_info ctinfo)
+{
+	struct nf_conn_seqadj *seqadj = nfct_seqadj(ct);
+	enum ip_conntrack_dir dir = CTINFO2DIR(ctinfo);
+	struct nf_ct_seqadj *this_way;
+
+	if (unlikely(!seqadj))
+		return;
+
+	spin_lock_bh(&ct->lock);
+	this_way = &seqadj->seq[dir];
+	this_way->offset_before	 = 0;
+	this_way->offset_after	 = 0;
+	spin_unlock_bh(&ct->lock);
+}
+EXPORT_SYMBOL_GPL(nf_ct_seqadj_reset);
+
 int nf_ct_seqadj_set(struct nf_conn *ct, enum ip_conntrack_info ctinfo,
 		     __be32 seq, s32 off)
 {
diff --git a/net/netfilter/nf_synproxy_core.c b/net/netfilter/nf_synproxy_core.c
index 9fc959ba2030..401ce5a13f3f 100644
--- a/net/netfilter/nf_synproxy_core.c
+++ b/net/netfilter/nf_synproxy_core.c
@@ -686,7 +686,7 @@ ipv4_synproxy_hook(void *priv, struct sk_buff *skb,
 		 * adjustments, they will get initialized once the connection is
 		 * reestablished.
 		 */
-		nf_ct_seqadj_init(ct, ctinfo, 0);
+		nf_ct_seqadj_reset(ct, ctinfo);
 		synproxy->tsoff = 0;
 		this_cpu_inc(snet->stats->conn_reopened);
 		fallthrough;
@@ -1116,7 +1116,7 @@ ipv6_synproxy_hook(void *priv, struct sk_buff *skb,
 		 * adjustments, they will get initialized once the connection is
 		 * reestablished.
 		 */
-		nf_ct_seqadj_init(ct, ctinfo, 0);
+		nf_ct_seqadj_reset(ct, ctinfo);
 		synproxy->tsoff = 0;
 		this_cpu_inc(snet->stats->conn_reopened);
 		fallthrough;
-- 
2.47.3

