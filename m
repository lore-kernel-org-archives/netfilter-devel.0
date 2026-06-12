Received: from sender-op-o17.zoho.eu (sender-op-o17.zoho.eu [136.143.169.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A705B23EA83
	for <netfilter-devel@vger.kernel.org>; Fri, 12 Jun 2026 12:42:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.169.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781268152; cv=pass; b=GGsSEbrEZs7i9s2z8xgC88hyWiIN6v+NxNhwVFO7XTPhVAfaF9EKqdTDXSX+NTG/HJfhnTLiwyeBYWTeAollNSfZMyBRKXYUnveQXZaftqmj2MAFCFIjI3TwUOfdPdu/inT/n+32HC92qGTHnr6+FLkNKSu07NVWnJ0WMhQMuag=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781268152; c=relaxed/simple;
	bh=ngt+z5NZNP2bLxE1iGJFOZGpI8x5OafjofmlhPbgNfQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=cRnF8F5J/rxRDU6LhccQtLZVRYCYDZO1c5N9f89oLwkL0CQi8xJLe5kDXmHrvdZeSNwWALVAVJdOvgnt03akUA8sz+JpToRr8IA72hLaDGXNGSGL3vGbbVHUrFcQSPUYZAvL/dzePRkADEskdnqkA1ubdyua3pkGz8vJ1qABSF4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=carlosgrillet.me; spf=pass smtp.mailfrom=carlosgrillet.me; dkim=pass (1024-bit key) header.d=carlosgrillet.me header.i=carlos@carlosgrillet.me header.b=Mv2lNupw; arc=pass smtp.client-ip=136.143.169.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=carlosgrillet.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=carlosgrillet.me
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=carlosgrillet.me header.i=carlos@carlosgrillet.me header.b="Mv2lNupw"
ARC-Seal: i=1; a=rsa-sha256; t=1781268137; cv=none; 
	d=zohomail.eu; s=zohoarc; 
	b=Ih6aNhdo2cEG8E3Cfgp1c+Q82WzXFmvVbMCDcPS5CFeUvlZvZ0GweLcpzkI1GfPmkUGue7QZTYAFYlXve/0Ivx7Fs8bv23Usf4zwwKRUC37/bGlJ6E1WoKmmQiqLlh91RKBfQrjcG6DoEKmNeCWksnhmgifkEPp5J3wf3UPNb7A=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
	t=1781268137; h=Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:MIME-Version:Message-ID:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=JPDMg/1vcqRmkkaVbSyViyubTh4oMaFo0jk8Xx+5uoQ=; 
	b=DW6Gl6LfNUG3EceJovnKVLV3IZAp0dxMG3veXBBpwBy79M3qc3+rgMxX8eF81cPTCc0Pbsy4fdiX6kSNEQPLuaDZHGY1QC6hr4Dektn631b1ry2dpJxUXm1uKunuwPyeinpAuKEPX0cZ+VxmOFbL0UqRbiS+FSgvDUqbV+gx2SQ=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
	dkim=pass  header.i=carlosgrillet.me;
	spf=pass  smtp.mailfrom=carlos@carlosgrillet.me;
	dmarc=pass header.from=<carlos@carlosgrillet.me>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1781268137;
	s=zmail; d=carlosgrillet.me; i=carlos@carlosgrillet.me;
	h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-ID:MIME-Version:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=JPDMg/1vcqRmkkaVbSyViyubTh4oMaFo0jk8Xx+5uoQ=;
	b=Mv2lNupwxMNtIpYPlujRU2pN5U1Nxv39ibnhv0R+2y/Yp6jX0dJ2B2GeFBeGlSE/
	ZDzAk5gXcZ/ITGofudER7KwbZ2IY+RE8/ORiU+0ktWF752S6ClT4ygsPRzj01FX9Ekn
	N2yXBd/nsw3/CN6ClFji2aFREkIFwk4DJlRVEk6Q=
Received: by mx.zoho.eu with SMTPS id 1781268135355851.5949726788033;
	Fri, 12 Jun 2026 14:42:15 +0200 (CEST)
From: Carlos Grillet <carlos@carlosgrillet.me>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	Phil Sutter <phil@nwl.cc>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	netfilter-devel@vger.kernel.org (open list:NETFILTER),
	coreteam@netfilter.org (open list:NETFILTER),
	netdev@vger.kernel.org (open list:NETWORKING [GENERAL]),
	linux-kernel@vger.kernel.org (open list)
Cc: Carlos Grillet <carlos@carlosgrillet.me>
Subject: [PATCH nf-next 5/6] netfilter: xt_TCPOPTSTRIP: replace u_int8_t and u_int16_t with u8 and u16
Date: Fri, 12 Jun 2026 14:40:25 +0200
Message-ID: <20260612124027.71673-6-carlos@carlosgrillet.me>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External

Replace POSIX u_int8_t/u_int16_t with preferred kernel types u8/u16

No functional changes.

Signed-off-by: Carlos Grillet <carlos@carlosgrillet.me>
---
 net/netfilter/xt_TCPOPTSTRIP.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/xt_TCPOPTSTRIP.c b/net/netfilter/xt_TCPOPTSTRIP.c
index 93f064306901..265d21697847 100644
--- a/net/netfilter/xt_TCPOPTSTRIP.c
+++ b/net/netfilter/xt_TCPOPTSTRIP.c
@@ -16,7 +16,7 @@
 #include <linux/netfilter/x_tables.h>
 #include <linux/netfilter/xt_TCPOPTSTRIP.h>
 
-static inline unsigned int optlen(const u_int8_t *opt, unsigned int offset)
+static inline unsigned int optlen(const u8 *opt, unsigned int offset)
 {
 	/* Beware zero-length options: make finite progress */
 	if (opt[offset] <= TCPOPT_NOP || opt[offset+1] == 0)
@@ -33,8 +33,8 @@ tcpoptstrip_mangle_packet(struct sk_buff *skb,
 	const struct xt_tcpoptstrip_target_info *info = par->targinfo;
 	struct tcphdr *tcph, _th;
 	unsigned int optl, i, j;
-	u_int16_t n, o;
-	u_int8_t *opt;
+	u16 n, o;
+	u8 *opt;
 	int tcp_hdrlen;
 
 	/* This is a fragment, no TCP header is available */
@@ -97,7 +97,7 @@ tcpoptstrip_tg6(struct sk_buff *skb, const struct xt_action_param *par)
 {
 	struct ipv6hdr *ipv6h = ipv6_hdr(skb);
 	int tcphoff;
-	u_int8_t nexthdr;
+	u8 nexthdr;
 	__be16 frag_off;
 
 	nexthdr = ipv6h->nexthdr;
-- 
2.54.0

