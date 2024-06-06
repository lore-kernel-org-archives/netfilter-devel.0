Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 636F0194AF8
	for <netfilter-devel@vger.kernel.org>; Thu,  6 Jun 2024 10:28:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717669705; cv=none; b=aZsoliwcp/YNXSybnjrEgB5IUPf0XNOsh52zC0kfxTZnE38Xd1kph+P/pEN/M4A8bpJrLuqGGTMeUyJfIFIOELYGOQyw93Infyx+rhKyQO5XdwuOtXP21URu7oyn+8wDezUDtJeBP8y1/7U+Ao0DL+VH2M0+/xj9VUPlwCIiAro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717669705; c=relaxed/simple;
	bh=0q6MbzKEDFacagMIJhTI+Ch3/tghzUJ7ZcTt8RBUJBo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=mQZd+eeW39x9v9QWOKY3qvG1uRzwCCvwX90guhT38fjdLa+Stx1Q7OcsfC+gnu7TRiXBeDvtCsCFv7awP5MKU+idrhEz9mbUhp/kxGrY9bKAdhm/xnGkXhA+yfUoFCetgoOpPpz0/uQmhZs4U2cK/17EThkzXJ6e8Pl/1ub3jRc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1sFALx-0002Gb-DW; Thu, 06 Jun 2024 12:28:17 +0200
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>,
	Yi Chen <yiche@redhat.com>
Subject: [PATCH nf] netfilter: Use flowlabel flow key when re-routing mangled packets
Date: Thu,  6 Jun 2024 12:23:31 +0200
Message-ID: <20240606102334.5521-1-fw@strlen.de>
X-Mailer: git-send-email 2.44.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

'ip6 dscp set $v' in an nftables outpute route chain has no effect.
While nftables does detect the dscp change and calls the reroute hook.
But ip6_route_me_harder never sets the dscp/flowlabel:
flowlabel/dsfield routing rules are ignored and no reroute takes place.

Thanks to Yi Chen for an excellent reproducer script that I used
to validate this change.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Reported-by: Yi Chen <yiche@redhat.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/ipv6/netfilter.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/ipv6/netfilter.c b/net/ipv6/netfilter.c
index 53d255838e6a..5d989d803009 100644
--- a/net/ipv6/netfilter.c
+++ b/net/ipv6/netfilter.c
@@ -36,6 +36,7 @@ int ip6_route_me_harder(struct net *net, struct sock *sk_partial, struct sk_buff
 		.flowi6_uid = sock_net_uid(net, sk),
 		.daddr = iph->daddr,
 		.saddr = iph->saddr,
+		.flowlabel = ip6_flowinfo(iph),
 	};
 	int err;
 
-- 
2.44.2

