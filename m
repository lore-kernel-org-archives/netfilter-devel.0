Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADFB43EF0D6;
	Tue, 20 Jan 2026 19:18:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768936708; cv=none; b=RqYdx1sqbOA3yK3MhlgSRDN4JcPdk0mINAhqokrSOsNATHCeuGRY2JfsyCBiy46yFQPEkrqrUbqaXUOTiAcmPyVfJtWkjiwCMGaN75uIpoYmVQlVE1ZeIYaOFUquhjuY02YCdn784Q+9DG6kCiWZBgqKmLhuoay5JsqSS8JN+x0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768936708; c=relaxed/simple;
	bh=H3tmlovnjM+llIHdacwn3VOg7pXgsDocfYYuFBYsJNM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JSjaF1lhpHOEaRRBrYi9Figxli5spImCyxvoYBix5cM1UnECh6SHtueqyVKLPwrWaxvjxJX+cbaMgLa2i3pDseuoninuWKnK138e130NBFhCvkkq3VSvm3itrGvL7oBz2fLL4FpQvSJYfq4xpotX4YRT1zul60k7l6ZOFh40M2Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 99A15602AB; Tue, 20 Jan 2026 20:18:24 +0100 (CET)
From: Florian Westphal <fw@strlen.de>
To: <netdev@vger.kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	<netfilter-devel@vger.kernel.org>,
	pablo@netfilter.org
Subject: [PATCH net-next 04/10] netfilter: nf_conntrack: enable icmp clash support
Date: Tue, 20 Jan 2026 20:17:57 +0100
Message-ID: <20260120191803.22208-5-fw@strlen.de>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260120191803.22208-1-fw@strlen.de>
References: <20260120191803.22208-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Not strictly required, but should not be harmful either:
This isn't a stateful protocol, hence clash resolution should work fine.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nf_conntrack_proto_icmp.c   | 1 +
 net/netfilter/nf_conntrack_proto_icmpv6.c | 1 +
 2 files changed, 2 insertions(+)

diff --git a/net/netfilter/nf_conntrack_proto_icmp.c b/net/netfilter/nf_conntrack_proto_icmp.c
index b38b7164acd5..32148a3a8509 100644
--- a/net/netfilter/nf_conntrack_proto_icmp.c
+++ b/net/netfilter/nf_conntrack_proto_icmp.c
@@ -365,6 +365,7 @@ void nf_conntrack_icmp_init_net(struct net *net)
 const struct nf_conntrack_l4proto nf_conntrack_l4proto_icmp =
 {
 	.l4proto		= IPPROTO_ICMP,
+	.allow_clash		= true,
 #if IS_ENABLED(CONFIG_NF_CT_NETLINK)
 	.tuple_to_nlattr	= icmp_tuple_to_nlattr,
 	.nlattr_tuple_size	= icmp_nlattr_tuple_size,
diff --git a/net/netfilter/nf_conntrack_proto_icmpv6.c b/net/netfilter/nf_conntrack_proto_icmpv6.c
index 327b8059025d..e508b3aa370a 100644
--- a/net/netfilter/nf_conntrack_proto_icmpv6.c
+++ b/net/netfilter/nf_conntrack_proto_icmpv6.c
@@ -343,6 +343,7 @@ void nf_conntrack_icmpv6_init_net(struct net *net)
 const struct nf_conntrack_l4proto nf_conntrack_l4proto_icmpv6 =
 {
 	.l4proto		= IPPROTO_ICMPV6,
+	.allow_clash		= true,
 #if IS_ENABLED(CONFIG_NF_CT_NETLINK)
 	.tuple_to_nlattr	= icmpv6_tuple_to_nlattr,
 	.nlattr_tuple_size	= icmpv6_nlattr_tuple_size,
-- 
2.52.0

