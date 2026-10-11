Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B828C400DF9;
	Sun, 11 Oct 2026 22:00:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791756019; cv=none; b=OeA6MT9RVDCzQF2ZI34OkSeqn0B6EIPI3tyaQbBhd9BQoT1dTuBSeR4ANaLbs+hl8hDclbSgGN3Q8q92pASG+CdZvxU08ayhY28JcPnHEm3EXq1buaIusUHtGRskPywjG3c8FmOLa9Yl5S5rXRcT5x0rMYD3DEc5xHSkruFj8wc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791756019; c=relaxed/simple;
	bh=PkYdfAeieyND1oiCFWmIRGRXaPHN0x9JZcboXTMeHkU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rz7jPaS3bLk/cxfAYZIQrpnqZ3uVXrzMC0lxmg+XcR6gd5M+Fq+cTwmeu8d8E+CQ97QB6PGWflr3SyWR9YjjAnrvm+di0CtificVIekl8d/GbTUT6eL1bbOAdwE/kxVfYyPo9/TrG8VX3ssI5dBSAKOHJnbb6xOiu0WGT/0flmY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=X1gwyMkY; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="X1gwyMkY"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1791756015;
	bh=oNJEiVtDOaSdSF9/U/1mAdNahJZcuvY5rELNIlH2Zpg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X1gwyMkYgeBel3MocZlUUa7nWLq4GTfwiK8GxnOAem98tkyI7yVdlnjqTkHcDEcer
	 EXKqaXYBtlS3FjtE238tWqkU4qs79YkTrYB3P2sCvND5aaPYhXAU5RXgDHKzaeMsvA
	 +9eScpaD7iljisVNRL1pbcIOsBtlUrcUVg9/k0SPBzLI4hxFNfFcY7XE7pAdgPBRpM
	 iDXcRiV+XCqwGcVpYfy3p6Wzu8FJRpJHMkKpqPNES7/U1FEdrnW4JT/rJLi8FKmdZK
	 oJNeyODr6DyXvRypuejNbfGpU67mN1mDnutOM0mhIUriKF9gw68M6HtSIhQfDPID7U
	 TaM+8vYIYMbDA==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id AA3CB60085;
	Mon, 12 Oct 2026 00:00:14 +0200 (CEST)
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
Subject: [PATCH net-next 09/15] ipvs: fix buffer overflow when sending sync messages
Date: Sun, 11 Oct 2026 23:59:47 +0200
Message-ID: <20261011215953.1334630-10-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261011215953.1334630-1-pablo@netfilter.org>
References: <20261011215953.1334630-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Julian Anastasov <ja@ssi.bg>

Sashiko reports for possible heap buffer overflow when
generating sync message for the v0 and v1 message formats.
We should read the cp->flags only once because another
CPU can concurrently set the SEQ_MASK between the two
reads.

Note that IPVS does not set the SEQ_MASK anymore for the
ip_vs_ftp.c helper starting from commit 7f1c40757951
("IPVS: make FTP work with full NAT support") (2.6.36+),
so the problem should not be reproducible.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Link: https://sashiko.dev/#/patchset/20260903004149.1037028-1-pablo%40netfilter.org
Link: https://sashiko.dev/#/patchset/20260909111338.44357-1-ja%40ssi.bg
Signed-off-by: Julian Anastasov <ja@ssi.bg>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/ipvs/ip_vs_sync.c | 23 ++++++++++++++---------
 1 file changed, 14 insertions(+), 9 deletions(-)

diff --git a/net/netfilter/ipvs/ip_vs_sync.c b/net/netfilter/ipvs/ip_vs_sync.c
index 45655cff078c..157f5c8361ab 100644
--- a/net/netfilter/ipvs/ip_vs_sync.c
+++ b/net/netfilter/ipvs/ip_vs_sync.c
@@ -543,13 +543,15 @@ static void ip_vs_sync_conn_v0(struct netns_ipvs *ipvs, struct ip_vs_conn *cp,
 	struct ip_vs_sync_conn_v0 *s;
 	struct ip_vs_sync_buff *buff;
 	struct ipvs_master_sync_state *ms;
-	int id;
+	u32 flags, seq_mask;
 	unsigned int len;
+	int id;
 
 	if (unlikely(cp->af != AF_INET))
 		return;
+	flags = READ_ONCE(cp->flags);
 	/* Do not sync ONE PACKET */
-	if (cp->flags & IP_VS_CONN_F_ONE_PACKET)
+	if (flags & IP_VS_CONN_F_ONE_PACKET)
 		return;
 
 	if (!ip_vs_sync_conn_needed(ipvs, cp, pkts))
@@ -564,8 +566,8 @@ static void ip_vs_sync_conn_v0(struct netns_ipvs *ipvs, struct ip_vs_conn *cp,
 	id = select_master_thread_id(ipvs, cp);
 	ms = &ipvs->ms[id];
 	buff = ms->sync_buff;
-	len = (cp->flags & IP_VS_CONN_F_SEQ_MASK) ? FULL_CONN_SIZE :
-		SIMPLE_CONN_SIZE;
+	seq_mask = flags & IP_VS_CONN_F_SEQ_MASK;
+	len = seq_mask ? FULL_CONN_SIZE : SIMPLE_CONN_SIZE;
 	if (buff) {
 		m = (struct ip_vs_sync_mesg_v0 *) buff->mesg;
 		/* Send buffer if it is for v1 */
@@ -597,9 +599,9 @@ static void ip_vs_sync_conn_v0(struct netns_ipvs *ipvs, struct ip_vs_conn *cp,
 	s->caddr = cp->caddr.ip;
 	s->vaddr = cp->vaddr.ip;
 	s->daddr = cp->daddr.ip;
-	s->flags = htons(cp->flags & ~IP_VS_CONN_F_HASHED);
+	s->flags = htons(flags & ~IP_VS_CONN_F_HASHED);
 	s->state = htons(cp->state);
-	if (cp->flags & IP_VS_CONN_F_SEQ_MASK) {
+	if (seq_mask) {
 		struct ip_vs_sync_conn_options *opt =
 			(struct ip_vs_sync_conn_options *)&s[1];
 		memcpy(opt, &cp->sync_conn_opt, sizeof(*opt));
@@ -635,6 +637,7 @@ void ip_vs_sync_conn(struct netns_ipvs *ipvs, struct ip_vs_conn *cp, int pkts)
 	int id;
 	__u8 *p;
 	unsigned int len, pe_name_len, pad;
+	u32 flags, seq_mask;
 
 	/* Handle old version of the protocol */
 	if (sysctl_sync_ver(ipvs) == 0) {
@@ -647,6 +650,7 @@ void ip_vs_sync_conn(struct netns_ipvs *ipvs, struct ip_vs_conn *cp, int pkts)
 sloop:
 	if (!ip_vs_sync_conn_needed(ipvs, cp, pkts))
 		goto control;
+	flags = READ_ONCE(cp->flags);
 
 	/* Sanity checks */
 	pe_name_len = 0;
@@ -674,7 +678,8 @@ void ip_vs_sync_conn(struct netns_ipvs *ipvs, struct ip_vs_conn *cp, int pkts)
 #endif
 		len = sizeof(struct ip_vs_sync_v4);
 
-	if (cp->flags & IP_VS_CONN_F_SEQ_MASK)
+	seq_mask = flags & IP_VS_CONN_F_SEQ_MASK;
+	if (seq_mask)
 		len += sizeof(struct ip_vs_sync_conn_options) + 2;
 
 	if (cp->pe_data_len)
@@ -720,7 +725,7 @@ void ip_vs_sync_conn(struct netns_ipvs *ipvs, struct ip_vs_conn *cp, int pkts)
 	/* Set message type  & copy members */
 	s->v4.type = (cp->af == AF_INET6 ? STYPE_F_INET6 : 0);
 	s->v4.ver_size = htons(len & SVER_MASK);	/* Version 0 */
-	s->v4.flags = htonl(cp->flags & ~IP_VS_CONN_F_HASHED);
+	s->v4.flags = htonl(flags & ~IP_VS_CONN_F_HASHED);
 	s->v4.state = htons(cp->state);
 	s->v4.protocol = cp->protocol;
 	s->v4.cport = cp->cport;
@@ -744,7 +749,7 @@ void ip_vs_sync_conn(struct netns_ipvs *ipvs, struct ip_vs_conn *cp, int pkts)
 		s->v4.vaddr = cp->vaddr.ip;
 		s->v4.daddr = cp->daddr.ip;
 	}
-	if (cp->flags & IP_VS_CONN_F_SEQ_MASK) {
+	if (seq_mask) {
 		*(p++) = IPVS_OPT_SEQ_DATA;
 		*(p++) = sizeof(struct ip_vs_sync_conn_options);
 		hton_seq(&cp->in_seq, (struct ip_vs_seq *)p);
-- 
2.47.3

