Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.70.190.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794789863;
	b=Pfb39RX0p7Gm93BEDhdzkeuQWu4zLSmH6+PSZCP/wx0i3dk5VyVa6oUK0kBD29vA9Gsa
	 SJT2B11iBCOXQygkFF2Oc+PMW9S8O3Rfs8JpHJr092otutkyGdseQSsFMzsd5xiv0qgTx
	 1YXF37021jwc/Z4XRtqz0Xu8NkexCdOLN0nSx2Igg9w8wijMqBqTag73lWtK+h/cNWiq+
	 txIuBoz4iIuqEVTWQHEXn5FmkgNxBYCpIgLHsw4oY6Zx/E1IQQ9I6xOS3blvn4GkP3sae
	 9qKx0z7KGQWMvoKBqodk8Jv5XsV9NxGkv1Pdy5y6pF4i34wGsi6Q4Z6ws/JV14Kih2w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794789863;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-Spam-Status:X-Spam-Checker-Version;
	bh=n0B+sKvpe2H3MCp7hBtPgz4Tu1xCOpB3YNEStZ8qVTI=;
	b=zEJMPQu34flNx2zKSXCC499+CCyaW67XRg/EP510JmNR1Zr2UoCpOW1qlsuLbMlUZ06k
	 1BII0JDbFViUz313BeHv8tJHVt3Q6VGmH8V6L+Fi4O7cqwBqS2mXCYaZhPhGVX4vb7HC0
	 xqo670qpooa+IWH0Wb9QGpkEZxgPglSUfVuOq1W1hsJYZfuBCZ/td/pF3JSZdph+tsTBS
	 ciluQy/x02g6wcrzeto+cyo2X03eXn19sczoq2tCjvkjhVcd+BSkjicMlEyiROXhiwnY4
	 92mRSJx1dAcTwKOTUVMCzwrrnY44+/f0ryiILYTQpQSh1nU6WcN/nVEzfaabE7gyDSQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	dkim=pass header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=n4z651hY;
	arc=none smtp.remote-ip=217.70.190.124
Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7398C60A2604;
	Mon, 16 Nov 2026 00:44:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7398C60A2604
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=n4z651hY
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1794789860;
	bh=n0B+sKvpe2H3MCp7hBtPgz4Tu1xCOpB3YNEStZ8qVTI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n4z651hY4quveujHnB7OI97vbkhgHiLVEZpmUdaGSxj8wOpZHeWOROy8uX/KXpu+6
	 e2wVQd82PZIvn5466C8uxH0c95Q6oCiZlD913nLXWMFbUXNPT/YjTss2XBzBE426eb
	 iH/XcH9vxJ009Kly/yBdDYukcO5dgz0i4zv3DbUayIprOTid0JDIUB7uWEfYgezKwr
	 TF5cOZwwbNgjQzy/qPNmshsYKiuZpOgjdEWn5/cBGYQDxPS0GOJMBYZd9apofD5MBS
	 +U0croOYGp3IWAvpf93N7vRCBlJPVOHaM5IbPoMXvkQFGyXC/cmm1+ZifawGFs9YSp
	 bdLFDhXRc/NeA==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id F26F66005B;
	Mon, 16 Nov 2026 01:44:19 +0100 (CET)
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@kernel.org,
	horms@kernel.org,
	fw@strlen.de,
	ja@ssi.bg
Subject: [PATCH net 06/11] ipvs: read flags and seqs in master atomically
Date: Mon, 16 Nov 2026 01:43:59 +0100
Message-ID: <20261116004404.2821183-7-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261116004404.2821183-1-pablo@netfilter.org>
References: <20261116004404.2821183-1-pablo@netfilter.org>
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Julian Anastasov <ja@ssi.bg>

After we fixed the double read of cp->flags in the master with
commit 3e3fe49e8678 ("ipvs: fix buffer overflow when sending sync messages")
Sashiko reports that we should also read the cp->flags and the seqs
atomically. So if the SEQ_MASK is set, re-read the flags and the
seqs under cp->lock to provide a snapshot when sending the sync
message.

Fixes: 3e3fe49e8678 ("ipvs: fix buffer overflow when sending sync messages")
Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Link: https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20260927220816.268206-1-pablo%40netfilter.org
Signed-off-by: Julian Anastasov <ja@ssi.bg>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/ipvs/ip_vs_sync.c | 23 ++++++++++++++++++++---
 1 file changed, 20 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/ipvs/ip_vs_sync.c b/net/netfilter/ipvs/ip_vs_sync.c
index ba2fa1f9d08e..f11c59eca553 100644
--- a/net/netfilter/ipvs/ip_vs_sync.c
+++ b/net/netfilter/ipvs/ip_vs_sync.c
@@ -539,6 +539,7 @@ static int ip_vs_sync_conn_needed(struct netns_ipvs *ipvs,
 static void ip_vs_sync_conn_v0(struct netns_ipvs *ipvs, struct ip_vs_conn *cp,
 			       int pkts)
 {
+	struct ip_vs_sync_conn_options opts;
 	struct ip_vs_sync_mesg_v0 *m;
 	struct ip_vs_sync_conn_v0 *s;
 	struct ip_vs_sync_buff *buff;
@@ -557,6 +558,14 @@ static void ip_vs_sync_conn_v0(struct netns_ipvs *ipvs, struct ip_vs_conn *cp,
 	if (!ip_vs_sync_conn_needed(ipvs, cp, pkts))
 		return;
 
+	if (flags & IP_VS_CONN_F_SEQ_MASK) {
+		/* Take atomic snapshot of flags and seqs */
+		spin_lock_bh(&cp->lock);
+		flags = cp->flags;
+		memcpy(&opts, &cp->sync_conn_opt, sizeof(opts));
+		spin_unlock_bh(&cp->lock);
+	}
+
 	spin_lock_bh(&ipvs->sync_buff_lock);
 	if (!(ipvs->sync_state & IP_VS_STATE_MASTER)) {
 		spin_unlock_bh(&ipvs->sync_buff_lock);
@@ -604,7 +613,7 @@ static void ip_vs_sync_conn_v0(struct netns_ipvs *ipvs, struct ip_vs_conn *cp,
 	if (seq_mask) {
 		struct ip_vs_sync_conn_options *opt =
 			(struct ip_vs_sync_conn_options *)&s[1];
-		memcpy(opt, &cp->sync_conn_opt, sizeof(*opt));
+		memcpy(opt, &opts, sizeof(*opt));
 	}
 
 	m->nr_conns++;
@@ -630,6 +639,7 @@ static void ip_vs_sync_conn_v0(struct netns_ipvs *ipvs, struct ip_vs_conn *cp,
  */
 void ip_vs_sync_conn(struct netns_ipvs *ipvs, struct ip_vs_conn *cp, int pkts)
 {
+	struct ip_vs_sync_conn_options opts;
 	struct ip_vs_sync_mesg *m;
 	union ip_vs_sync_conn *s;
 	struct ip_vs_sync_buff *buff;
@@ -651,6 +661,13 @@ void ip_vs_sync_conn(struct netns_ipvs *ipvs, struct ip_vs_conn *cp, int pkts)
 	if (!ip_vs_sync_conn_needed(ipvs, cp, pkts))
 		goto control;
 	flags = READ_ONCE(cp->flags);
+	if (flags & IP_VS_CONN_F_SEQ_MASK) {
+		/* Take atomic snapshot of flags and seqs */
+		spin_lock_bh(&cp->lock);
+		flags = cp->flags;
+		memcpy(&opts, &cp->sync_conn_opt, sizeof(opts));
+		spin_unlock_bh(&cp->lock);
+	}
 
 	/* Sanity checks */
 	pe_name_len = 0;
@@ -752,9 +769,9 @@ void ip_vs_sync_conn(struct netns_ipvs *ipvs, struct ip_vs_conn *cp, int pkts)
 	if (seq_mask) {
 		*(p++) = IPVS_OPT_SEQ_DATA;
 		*(p++) = sizeof(struct ip_vs_sync_conn_options);
-		hton_seq(&cp->in_seq, (struct ip_vs_seq *)p);
+		hton_seq(&opts.in_seq, (struct ip_vs_seq *)p);
 		p += sizeof(struct ip_vs_seq);
-		hton_seq(&cp->out_seq, (struct ip_vs_seq *)p);
+		hton_seq(&opts.out_seq, (struct ip_vs_seq *)p);
 		p += sizeof(struct ip_vs_seq);
 	}
 	/* Handle pe data */
-- 
2.47.3

