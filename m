Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C4D43321C2
	for <netfilter-devel@vger.kernel.org>; Thu, 12 Mar 2026 17:57:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773338230; cv=none; b=Ba8r0AFcrOnthHnGdp68/4LooJOSWzrddh7EICqC/SvbG1QKyMeuRdK8uVRH83FNy9xF56FHGZWgYRWN78PhXxPG3fXyl5AdP2Dh293e9t4MoufXHGXJO4blPHx1vYAALxlvIs0K9XJbjesDxjuIySfga1lQnata7X3WiKvPOmc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773338230; c=relaxed/simple;
	bh=gaNvlIAE4MFRxiYMObkqcJ1x6oMrrBMapFx1Ry4VTo4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=OrZh/EAUwFvZPby5xucm3QJvJHJ8ATneai/erUq/wBnnCGFG91hjxn5mui7434WoaFAmnQPEMe9H62SlWi1V8fvYWC9xJ9eqyeGlxtWcdFrn2j7y4wRE72ukX8eCOeTTnWe63vxPfvDWPjI83K1bXTCCx2U6VvZHLn/bjQuOEf0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 945CF60345; Thu, 12 Mar 2026 18:57:07 +0100 (CET)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next] netfilter: nf_conntrack_sip: remove net variable shadowing
Date: Thu, 12 Mar 2026 18:56:59 +0100
Message-ID: <20260312175702.28603-1-fw@strlen.de>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

net is already set, derived from nf_conn.
I don't see how the device could be living in a different netns
than the conntrack entry.

Remove the extra variable and re-use existing one.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nf_conntrack_sip.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/netfilter/nf_conntrack_sip.c b/net/netfilter/nf_conntrack_sip.c
index ca748f8dbff1..2a60a425880d 100644
--- a/net/netfilter/nf_conntrack_sip.c
+++ b/net/netfilter/nf_conntrack_sip.c
@@ -869,9 +869,8 @@ static int set_expected_rtp_rtcp(struct sk_buff *skb, unsigned int protoff,
 		saddr = &ct->tuplehash[!dir].tuple.src.u3;
 	} else if (sip_external_media) {
 		struct net_device *dev = skb_dst(skb)->dev;
-		struct net *net = dev_net(dev);
-		struct flowi fl;
 		struct dst_entry *dst = NULL;
+		struct flowi fl;
 
 		memset(&fl, 0, sizeof(fl));
 
-- 
2.52.0

