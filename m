Received: from sender-op-o11.zoho.eu (sender-op-o11.zoho.eu [136.143.169.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BC535172FF
	for <netfilter-devel@vger.kernel.org>; Fri,  2 Oct 2026 20:12:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.169.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790971929; cv=pass; b=Flg5ECQ7L6cCm4DqmK23CaoONmzNoP5R1jUMrDPD3ocYWGDR/tZMiXI9GPSQ/AERk9D9k+sZf7yJPGC4SbU2GGscuwaBz2A2wRv439s4f3Yp1zV8mrAWTeL/RSVCmcP2bvXRpGFGRCSDXRRAu7iweOlVaPJ5oQg+Cu+2YaUhbcU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790971929; c=relaxed/simple;
	bh=JXrnqN5b7b5VPl2cUpvt51GalgUDyhSMgLaVePYKUoM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=h1CgSUDKHYmB8FWOySvjNA61WDVduZtAuF0kCdBv0PdjfSXrbEHPGTUJyUi1RhHrVjtK7V1dlTPz3rjJwoqf7B3HNHxWSnH2WxgIyTv8zkcOpNs4Lz3ylFsLMNv4GyLU0hjMJTmF16J+HawXBNVMnqrqxUcoBbLBjfqpMyz7hLA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=carlosgrillet.me; spf=pass smtp.mailfrom=carlosgrillet.me; dkim=pass (1024-bit key) header.d=carlosgrillet.me header.i=carlos@carlosgrillet.me header.b=Lkv/BI5U; arc=pass smtp.client-ip=136.143.169.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=carlosgrillet.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=carlosgrillet.me
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=carlosgrillet.me header.i=carlos@carlosgrillet.me header.b="Lkv/BI5U"
ARC-Seal: i=1; a=rsa-sha256; t=1790971864; cv=none; 
	d=zohomail.eu; s=zohoarc; 
	b=Btv9wJug5hY0neMPmKB+asRaXkXSxcZ4KKYUjHsyncRpozQLqgyKAb4wI5Rt73kSt4HJu92pLQzzDheV9UGWhTADvpmsr9XThdTyBPgIQDIbuhf4RcD1JlCp6M6LzCqwdXko/v1I5/4i4KD9PZLmh1brhNNuADdO+LAf/Qkoyf4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
	t=1790971864; h=Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:MIME-Version:Message-ID:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=/4GO7aD7n+aCVqq1i3jpJpGmN5SXdv/c+vAs199Kl2E=; 
	b=eHuSGmTK5TmSdxa5/7NVVHCilSgSjbnwpSsMALqPLPlxVJjLul6/zVniF4Tdg7cMoA0AFB0C+tV1AEL1zC6dKTUPWuYYj3o41yW+IzfsIv/9PQfIEAcIvzB+JI4Pe7P9P/WBhtKMXU2mCQxohtx7Tf62Sbxr51DISTl9cmAv5O8=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
	dkim=pass  header.i=carlosgrillet.me;
	spf=pass  smtp.mailfrom=carlos@carlosgrillet.me;
	dmarc=pass header.from=<carlos@carlosgrillet.me>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1790971864;
	s=zmail; d=carlosgrillet.me; i=carlos@carlosgrillet.me;
	h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-ID:MIME-Version:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=/4GO7aD7n+aCVqq1i3jpJpGmN5SXdv/c+vAs199Kl2E=;
	b=Lkv/BI5Ugjc+j+59Ll+5Yyl4YGLIOCJepwNUngff+W0/5TCVAdlz8ctaQBd+ZfLP
	PVRrztkKdg7XFJy17i7iDyfB1Auq7Z1EmeFLhaKiDIZ20n184MTUTsHOtaF5iOMg5dD
	czb99BbnP1Yr4KH5ngclBEDfy1Wle/+Kz2WWM+7I=
Received: by smtp.zoho.eu with SMTPS id 1790971862347592.8629566628938;
	Fri, 2 Oct 2026 22:11:02 +0200 (CEST)
From: Carlos Grillet <carlos@carlosgrillet.me>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	Phil Sutter <phil@nwl.cc>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>
Cc: netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	linux-kernel@vger.kernel.org,
	netdev@vger.kernel.org
Subject: [PATCH nf-next] netfilter: nf_nat: replace u_int16_t with u16
Date: Fri,  2 Oct 2026 22:10:55 +0200
Message-ID: <20261002201057.132466-1-carlos@carlosgrillet.me>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External

Use the preferred kernel type u16 instead of the POSIX u_int16_t
variant across the NAT helpers.

No functional change.

Signed-off-by: Carlos Grillet <carlos@carlosgrillet.me>
---
This supersedes the nf_nat_amanda one-liner from batch 3, which was
dropped in favour of a larger changeset:

  https://lore.kernel.org/netfilter-devel/ak5lH1UnFth6oreP@strlen.de/

nf_nat is now converted in one patch, as suggested. The remaining
families (nfnetlink, nf_log, x_tables, ...) will follow the same way.

 include/linux/netfilter/nf_conntrack_sip.h |  2 +-
 net/ipv4/netfilter/nf_nat_h323.c           | 10 +++++-----
 net/ipv4/netfilter/nf_nat_pptp.c           |  4 ++--
 net/netfilter/nf_nat_amanda.c              |  2 +-
 net/netfilter/nf_nat_ftp.c                 |  2 +-
 net/netfilter/nf_nat_irc.c                 |  2 +-
 net/netfilter/nf_nat_sip.c                 |  6 +++---
 7 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/include/linux/netfilter/nf_conntrack_sip.h b/include/linux/netfilter/nf_conntrack_sip.h
index aafa0c04f917..3b66ec4b20c8 100644
--- a/include/linux/netfilter/nf_conntrack_sip.h
+++ b/include/linux/netfilter/nf_conntrack_sip.h
@@ -143,7 +143,7 @@ struct nf_nat_sip_hooks {
 				 unsigned int *datalen,
 				 unsigned int matchoff,
 				 unsigned int matchlen,
-				 u_int16_t port);
+				 u16 port);
 
 	unsigned int (*sdp_session)(struct sk_buff *skb,
 				    unsigned int protoff,
diff --git a/net/ipv4/netfilter/nf_nat_h323.c b/net/ipv4/netfilter/nf_nat_h323.c
index 6bcd6734769b..265c1ba5b348 100644
--- a/net/ipv4/netfilter/nf_nat_h323.c
+++ b/net/ipv4/netfilter/nf_nat_h323.c
@@ -186,7 +186,7 @@ static int nat_rtp_rtcp(struct sk_buff *skb, struct nf_conn *ct,
 	struct nf_ct_h323_master *info = nfct_help_data(ct);
 	int dir = CTINFO2DIR(ctinfo);
 	int i;
-	u_int16_t nated_port;
+	u16 nated_port;
 
 	if (!info)
 		return -1;
@@ -282,7 +282,7 @@ static int nat_t120(struct sk_buff *skb, struct nf_conn *ct,
 		    struct nf_conntrack_expect *exp)
 {
 	int dir = CTINFO2DIR(ctinfo);
-	u_int16_t nated_port = ntohs(port);
+	u16 nated_port = ntohs(port);
 
 	/* Set expectations for NAT */
 	exp->saved_proto.tcp.port = exp->tuple.dst.u.tcp.port;
@@ -321,7 +321,7 @@ static int nat_h245(struct sk_buff *skb, struct nf_conn *ct,
 {
 	struct nf_ct_h323_master *info = nfct_help_data(ct);
 	int dir = CTINFO2DIR(ctinfo);
-	u_int16_t nated_port = ntohs(port);
+	u16 nated_port = ntohs(port);
 
 	if (!info)
 		return -1;
@@ -402,7 +402,7 @@ static int nat_q931(struct sk_buff *skb, struct nf_conn *ct,
 {
 	struct nf_ct_h323_master *info = nfct_help_data(ct);
 	int dir = CTINFO2DIR(ctinfo);
-	u_int16_t nated_port = ntohs(port);
+	u16 nated_port = ntohs(port);
 	union nf_inet_addr addr;
 
 	if (!info)
@@ -488,7 +488,7 @@ static int nat_callforwarding(struct sk_buff *skb, struct nf_conn *ct,
 			      struct nf_conntrack_expect *exp)
 {
 	int dir = CTINFO2DIR(ctinfo);
-	u_int16_t nated_port;
+	u16 nated_port;
 
 	/* Set expectations for NAT */
 	exp->saved_addr = exp->tuple.dst.u3;
diff --git a/net/ipv4/netfilter/nf_nat_pptp.c b/net/ipv4/netfilter/nf_nat_pptp.c
index fed5249001a4..5387c288c348 100644
--- a/net/ipv4/netfilter/nf_nat_pptp.c
+++ b/net/ipv4/netfilter/nf_nat_pptp.c
@@ -130,7 +130,7 @@ pptp_outbound_pkt(struct sk_buff *skb,
 	struct nf_ct_pptp_master *ct_pptp_info;
 	struct nf_conn_nat *nat = nfct_nat(ct);
 	struct nf_nat_pptp *nat_pptp_info;
-	u_int16_t msg;
+	u16 msg;
 	__be16 new_callid;
 	unsigned int cid_off;
 
@@ -243,7 +243,7 @@ pptp_inbound_pkt(struct sk_buff *skb,
 {
 	const struct nf_nat_pptp *nat_pptp_info;
 	struct nf_conn_nat *nat = nfct_nat(ct);
-	u_int16_t msg;
+	u16 msg;
 	__be16 new_pcid;
 	unsigned int pcid_off;
 
diff --git a/net/netfilter/nf_nat_amanda.c b/net/netfilter/nf_nat_amanda.c
index 330415809425..17b0c1c8d4e1 100644
--- a/net/netfilter/nf_nat_amanda.c
+++ b/net/netfilter/nf_nat_amanda.c
@@ -34,7 +34,7 @@ static unsigned int help(struct sk_buff *skb,
 			 struct nf_conntrack_expect *exp)
 {
 	char buffer[sizeof("65535")];
-	u_int16_t port;
+	u16 port;
 
 	/* Connection comes from client. */
 	exp->saved_proto.tcp.port = exp->tuple.dst.u.tcp.port;
diff --git a/net/netfilter/nf_nat_ftp.c b/net/netfilter/nf_nat_ftp.c
index 25d20e2970ae..0c90165040e0 100644
--- a/net/netfilter/nf_nat_ftp.c
+++ b/net/netfilter/nf_nat_ftp.c
@@ -70,7 +70,7 @@ static unsigned int nf_nat_ftp(struct sk_buff *skb,
 			       struct nf_conntrack_expect *exp)
 {
 	union nf_inet_addr newaddr;
-	u_int16_t port;
+	u16 port;
 	int dir = CTINFO2DIR(ctinfo);
 	char buffer[sizeof("|1||65535|") + INET6_ADDRSTRLEN];
 	unsigned int buflen;
diff --git a/net/netfilter/nf_nat_irc.c b/net/netfilter/nf_nat_irc.c
index 89b31fe932ba..140b7d99a887 100644
--- a/net/netfilter/nf_nat_irc.c
+++ b/net/netfilter/nf_nat_irc.c
@@ -39,7 +39,7 @@ static unsigned int help(struct sk_buff *skb,
 {
 	char buffer[sizeof("4294967296 65635")];
 	union nf_inet_addr newaddr;
-	u_int16_t port;
+	u16 port;
 
 	/* Reply comes from server. */
 	newaddr = ct->tuplehash[IP_CT_DIR_REPLY].tuple.dst.u3;
diff --git a/net/netfilter/nf_nat_sip.c b/net/netfilter/nf_nat_sip.c
index 8c412bcf6cff..e27c9744054e 100644
--- a/net/netfilter/nf_nat_sip.c
+++ b/net/netfilter/nf_nat_sip.c
@@ -410,7 +410,7 @@ static unsigned int nf_nat_sip_expect(struct sk_buff *skb, unsigned int protoff,
 	enum ip_conntrack_dir dir = CTINFO2DIR(ctinfo);
 	struct nf_ct_sip_master *ct_sip_info = nfct_help_data(ct);
 	union nf_inet_addr newaddr;
-	u_int16_t port;
+	u16 port;
 	__be16 srcport;
 	char buffer[INET6_ADDRSTRLEN + sizeof("[]:nnnnn")];
 	unsigned int buflen;
@@ -536,7 +536,7 @@ static unsigned int nf_nat_sdp_port(struct sk_buff *skb, unsigned int protoff,
 				    const char **dptr, unsigned int *datalen,
 				    unsigned int matchoff,
 				    unsigned int matchlen,
-				    u_int16_t port)
+				    u16 port)
 {
 	char buffer[sizeof("nnnnn")];
 	unsigned int buflen;
@@ -601,7 +601,7 @@ static unsigned int nf_nat_sdp_media(struct sk_buff *skb, unsigned int protoff,
 	enum ip_conntrack_info ctinfo;
 	struct nf_conn *ct = nf_ct_get(skb, &ctinfo);
 	enum ip_conntrack_dir dir = CTINFO2DIR(ctinfo);
-	u_int16_t port;
+	u16 port;
 
 	/* Connection will come from reply */
 	if (nf_inet_addr_cmp(&ct->tuplehash[dir].tuple.src.u3,
-- 
2.55.0

