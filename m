Received: from sender-op-o17.zoho.eu (sender-op-o17.zoho.eu [136.143.169.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A5033DE457
	for <netfilter-devel@vger.kernel.org>; Fri, 12 Jun 2026 12:42:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.169.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781268155; cv=pass; b=XT6dSKJ7+CuKnkJcY9sQZ6zO95uX+lA1xKr/adOZKHozcFp3ultT+Jy9dCzTZTnCVwZIcxoZchQFO791vtIoyGr1+McO27Iegnq/Ee4r26yYpBp6NUrLScuPrgWMDclQrDvVLfZf5/X00AEM8Hda6hxNlxt73x4fr0/DPJiuVIc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781268155; c=relaxed/simple;
	bh=TaNWalm3ueLUHjtjzR2p09USmeki+oTeGC1XV1PxysQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=hEa6yfOPA2nGzGIvorGsa/7gMfJZmSm08QwpNKLvGCDu7kGjgmI70U9NVvMSR4OfRMGDG5qm69R0HefgqbhesvPiZdFFfF/kH4ldCwagjk7duAlRbcdZWWvISI+vsqewXSh81bUyaDWk5ww+jcKrExllpMmoTrkANtHQqllBoJw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=carlosgrillet.me; spf=pass smtp.mailfrom=carlosgrillet.me; dkim=pass (1024-bit key) header.d=carlosgrillet.me header.i=carlos@carlosgrillet.me header.b=ZCY6zBxq; arc=pass smtp.client-ip=136.143.169.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=carlosgrillet.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=carlosgrillet.me
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=carlosgrillet.me header.i=carlos@carlosgrillet.me header.b="ZCY6zBxq"
ARC-Seal: i=1; a=rsa-sha256; t=1781268131; cv=none; 
	d=zohomail.eu; s=zohoarc; 
	b=hN7Jzcq4cdUR6LNBnICnOk5YUmat3Im5vjFut5p940nstbYWu/XvWw15x3QJSTjHE34Xu/0vAECt1d3mSPR2/fj7WJa2kbcOBel4+qMU4PWpNMMGckD7QAZnIotztnXzPaEY6EHoXKIVm0cpnCdkEYJ+XmRpy/XhpuX3DGFud70=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
	t=1781268131; h=Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:MIME-Version:Message-ID:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=2amGp+Uqp40v4+D/UhRTPE8frH0rHY1aE5A+EOt0im4=; 
	b=CGF9hmApeRKHKo2Gg9MfQbnKJ9nVa1dRxb7RD0aAosg89VFq46IP8ucwKQt+hiLOSyMv9SwYX/uXHX/x8EFMqygq9tdcXn/Bv0j/LCy4GGw0Z6uTiv6Cb78YhYGqYSuZ1MMgRZWvYFbj5wmb3kAqI+D5uFLXosKTU9hehwF2FSI=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
	dkim=pass  header.i=carlosgrillet.me;
	spf=pass  smtp.mailfrom=carlos@carlosgrillet.me;
	dmarc=pass header.from=<carlos@carlosgrillet.me>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1781268131;
	s=zmail; d=carlosgrillet.me; i=carlos@carlosgrillet.me;
	h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-ID:MIME-Version:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=2amGp+Uqp40v4+D/UhRTPE8frH0rHY1aE5A+EOt0im4=;
	b=ZCY6zBxqzDim737ykvLTtgnwqiE0APQaoeRMHXDwq23JLn7bc5/ELMBYS4NpQQK7
	BfFPe/dRexIsDb5sUHgNlvSsL6mva+qGQ2vPJTZvPkRstrhF+eSi+oak3ujdZKKW2DL
	CKxCmQqj7/YVdEuYk+WRA11Nn71XWsGNRoxRmF7E=
Received: by mx.zoho.eu with SMTPS id 178126812929010.282870073268896;
	Fri, 12 Jun 2026 14:42:09 +0200 (CEST)
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
Subject: [PATCH nf-next 4/6] netfilter: xt_DSCP: replace u_int8_t with u8
Date: Fri, 12 Jun 2026 14:40:24 +0200
Message-ID: <20260612124027.71673-5-carlos@carlosgrillet.me>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External

Replace POSIX u_int8_t with preferred kernel type u8

No functional changes.

Signed-off-by: Carlos Grillet <carlos@carlosgrillet.me>
---
 net/netfilter/xt_DSCP.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/xt_DSCP.c b/net/netfilter/xt_DSCP.c
index cfa44515ab72..76231e1dc5b5 100644
--- a/net/netfilter/xt_DSCP.c
+++ b/net/netfilter/xt_DSCP.c
@@ -30,7 +30,7 @@ static unsigned int
 dscp_tg(struct sk_buff *skb, const struct xt_action_param *par)
 {
 	const struct xt_DSCP_info *dinfo = par->targinfo;
-	u_int8_t dscp = ipv4_get_dsfield(ip_hdr(skb)) >> XT_DSCP_SHIFT;
+	u8 dscp = ipv4_get_dsfield(ip_hdr(skb)) >> XT_DSCP_SHIFT;
 
 	if (dscp != dinfo->dscp) {
 		if (skb_ensure_writable(skb, sizeof(struct iphdr)))
@@ -47,7 +47,7 @@ static unsigned int
 dscp_tg6(struct sk_buff *skb, const struct xt_action_param *par)
 {
 	const struct xt_DSCP_info *dinfo = par->targinfo;
-	u_int8_t dscp = ipv6_get_dsfield(ipv6_hdr(skb)) >> XT_DSCP_SHIFT;
+	u8 dscp = ipv6_get_dsfield(ipv6_hdr(skb)) >> XT_DSCP_SHIFT;
 
 	if (dscp != dinfo->dscp) {
 		if (skb_ensure_writable(skb, sizeof(struct ipv6hdr)))
@@ -73,7 +73,7 @@ tos_tg(struct sk_buff *skb, const struct xt_action_param *par)
 {
 	const struct xt_tos_target_info *info = par->targinfo;
 	struct iphdr *iph = ip_hdr(skb);
-	u_int8_t orig, nv;
+	u8 orig, nv;
 
 	orig = ipv4_get_dsfield(iph);
 	nv   = (orig & ~info->tos_mask) ^ info->tos_value;
@@ -93,7 +93,7 @@ tos_tg6(struct sk_buff *skb, const struct xt_action_param *par)
 {
 	const struct xt_tos_target_info *info = par->targinfo;
 	struct ipv6hdr *iph = ipv6_hdr(skb);
-	u_int8_t orig, nv;
+	u8 orig, nv;
 
 	orig = ipv6_get_dsfield(iph);
 	nv   = (orig & ~info->tos_mask) ^ info->tos_value;
-- 
2.54.0

