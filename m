Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF40D72623
	for <netfilter-devel@vger.kernel.org>; Sat, 18 Apr 2026 10:06:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776506817; cv=none; b=XYuPMJnUA2vaCElr63/CHCAhtyTKD7soKUnkvzvuUHOCRM5EmR79GT+0SGgckIHAbsrCNv3Juw6DGXykNma+1hj2zeIJG7pgdbmDw8SARNBjxVMY3k1YYI8KUD8PD8w/7G6+308UnQUwEUfTwh6fys6OcK3P4SCX1QWiHIkxTS4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776506817; c=relaxed/simple;
	bh=VdnmGSCh5z8bjiqo+v+CDQMa8rl0+1bUVIbATHTA0Pg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=e5KAGsTnm56ROq57F3adXJTf5xhB69X92egApwRUwlOrnA3cX8cTaUfCM6vDLn8SUBU3eWHmc21rWsV8/+khK624kLHKBjOvuSq5cXClBvoU5WLqglPNafZ4G46Gbrv8Oycwh4xQ+iA5yYcbVLSPCJvrQ1nyGKTFpufASMf+Nnw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 9499C606C8; Sat, 18 Apr 2026 12:06:53 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf v2] netfilter: arp_tables: fix IEEE1394 ARP payload mangling
Date: Sat, 18 Apr 2026 12:06:33 +0200
Message-ID: <20260418100641.60660-1-fw@strlen.de>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

sashiko.dev noticed that similar bug pattern exists in arpt_mangle:
  "IEEE1394 ARP payloads omit the target hardware address, advancing
  arpptr by hln after the source IP address skips over the actual target
  IP address."

Apply similar fix: If we're asked to mangle what doesn't exist, drop the packet.

Fixes: 6752c8db8e0c ("firewire net, ipv4 arp: Extend hardware address and remove driver-level packet inspection.")
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 v2: Just check ar_hrd. I do not know why the arp_tables.c change
 used dev->type instead.  Also NOONE uses this feature and we could
 even completely ignore it, there is no crash and users can already
 use arptables to skip such frames.  IOW, from a certain POV the report
 *IS* bullshit.  I propose we keep these patches back to focus on real
 bugs instead, theer are plenty enough as-is.

 net/ipv4/netfilter/arpt_mangle.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/net/ipv4/netfilter/arpt_mangle.c b/net/ipv4/netfilter/arpt_mangle.c
index a4e07e5e9c11..476369567231 100644
--- a/net/ipv4/netfilter/arpt_mangle.c
+++ b/net/ipv4/netfilter/arpt_mangle.c
@@ -13,6 +13,7 @@ static unsigned int
 target(struct sk_buff *skb, const struct xt_action_param *par)
 {
 	const struct arpt_mangle *mangle = par->targinfo;
+	bool has_tgt_devaddr = true;
 	const struct arphdr *arp;
 	unsigned char *arpptr;
 	int pln, hln;
@@ -39,13 +40,22 @@ target(struct sk_buff *skb, const struct xt_action_param *par)
 		memcpy(arpptr, &mangle->u_s.src_ip, pln);
 	}
 	arpptr += pln;
+
+	if (arp->ar_hrd == htons(ARPHRD_IEEE1394))
+		has_tgt_devaddr = false;
+
 	if (mangle->flags & ARPT_MANGLE_TDEV) {
+		if (!has_tgt_devaddr)
+			return NF_DROP;
+
 		if (ARPT_DEV_ADDR_LEN_MAX < hln ||
 		   (arpptr + hln > skb_tail_pointer(skb)))
 			return NF_DROP;
 		memcpy(arpptr, mangle->tgt_devaddr, hln);
 	}
-	arpptr += hln;
+	if (has_tgt_devaddr)
+		arpptr += hln;
+
 	if (mangle->flags & ARPT_MANGLE_TIP) {
 		if (ARPT_MANGLE_ADDR_LEN_MAX < pln ||
 		   (arpptr + pln > skb_tail_pointer(skb)))
-- 
2.53.0

