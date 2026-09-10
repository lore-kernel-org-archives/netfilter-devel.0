Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB5104A9D51;
	Thu, 10 Sep 2026 14:50:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789051858; cv=none; b=huf4hDWXLXPcEnjP6C9+GvZdQQ9MLA07v72huFt5Ws5n9VWTKBgSvHYi3i+uqoQvR4tsExqZLoLkzHwd3VWZZkLm0FSKHEG/69doOBvZ1flOcBFQJfLPUC137DzxsObl+5USlmBKnnx7pRvm8+V6/z/+Tb9ByXlzs70jPyzPk8I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789051858; c=relaxed/simple;
	bh=VgDQLjEmfqYzWvhIfjC4vevmBx4bVHhtcESKUjhlB0s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PMP/3H1LpE+9EEOR3cxpsQWqzon+DH37odotUzmAHBGrTrbbdcraTQ/a3A2vRv92rVoonK6gps7/BupaJQxTLpWXEc8d0hkPzWvrH5mcB4H2q+5FV4JeCKPIozl9EBLF019ys7IkMzVTJFVBvxb38b0Tl55XSD283fz6ZZ7HBcQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id C7AE91FE01;
	Thu, 10 Sep 2026 14:50:54 +0000 (UTC)
Authentication-Results: smtp-out2.suse.de;
	none
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id EB854137FD;
	Thu, 10 Sep 2026 14:50:53 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id oFa5Ns3DomogZwAAD6G6ig
	(envelope-from <fmancera@suse.de>); Thu, 10 Sep 2026 14:50:53 +0000
From: Fernando Fernandez Mancera <fmancera@suse.de>
To: netdev@vger.kernel.org
Cc: horms@kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	davem@davemloft.net,
	Fernando Fernandez Mancera <fmancera@suse.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	Phil Sutter <phil@nwl.cc>,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 11/13 net-next] netfilter: ipv4: guard ip_route_me_harder() with CONFIG_IPV4
Date: Thu, 10 Sep 2026 16:48:36 +0200
Message-ID: <20260910144914.8025-12-fmancera@suse.de>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260910144914.8025-1-fmancera@suse.de>
References: <20260910144914.8025-1-fmancera@suse.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Spam-Level: 
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Queue-Id: C7AE91FE01
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Spamd-Result: default: False [-4.00 / 50.00];
	REPLY(-4.00)[]
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Score: -4.00

To enable compiling the network stack without IPv4, IPv4 specific packet
rerouting logic inside netfilter must be bypassed. Therefore, guard
ip_route_me_harder() with IS_ENABLED(CONFIG_IPV4) so it returns
-EPROTONOSUPPORT when IPv4 is disabled.

Signed-off-by: Fernando Fernandez Mancera <fmancera@suse.de>
---
 net/ipv4/netfilter.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/ipv4/netfilter.c b/net/ipv4/netfilter.c
index ce9e1bfa4259..9576d91bb6a6 100644
--- a/net/ipv4/netfilter.c
+++ b/net/ipv4/netfilter.c
@@ -21,6 +21,7 @@
 /* route_me_harder function, used by iptable_nat, iptable_mangle + ip_queue */
 int ip_route_me_harder(struct net *net, struct sock *sk, struct sk_buff *skb, unsigned int addr_type)
 {
+#if IS_ENABLED(CONFIG_IPV4)
 	struct net_device *dev = skb_dst_dev(skb);
 	const struct iphdr *iph = ip_hdr(skb);
 	struct rtable *rt;
@@ -85,6 +86,9 @@ int ip_route_me_harder(struct net *net, struct sock *sk, struct sk_buff *skb, un
 		return -ENOMEM;
 
 	return 0;
+#else
+	return -EPROTONOSUPPORT;
+#endif
 }
 EXPORT_SYMBOL(ip_route_me_harder);
 
-- 
2.55.0

