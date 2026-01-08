Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0226446525D
	for <netfilter-devel@vger.kernel.org>; Thu,  8 Jan 2026 12:42:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767876157; cv=none; b=M+43gmYnwDJoZL+yYGSv5Jj/QwqimARoZsF0A5M3uus8BR40vzdRHoMsbzXoFHS1CTUT6InV2Hbk8AyvvP8MVCz+BhTj171Ay8S1MSOyDPX7+UFf7OHDyUOTthmWu7HRh2Tgt0lbXrULyLTINRbO7boROd+gVyUk+aHijmJoHeA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767876157; c=relaxed/simple;
	bh=H3tmlovnjM+llIHdacwn3VOg7pXgsDocfYYuFBYsJNM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=scH2BNi/Zr1NwyxGb3NkE94c3VAgONE8NLUBLh7M3UJd5wO6q2BZ2m5pLtif7te06kApAQOv/hnK07V611XAurtZbJnuH4u9XZkgWMb7jDt5bba4Vwemwo4UIxvLHvlnpygXuna6dfiOuGGuCjuGjsxRTS2Z6OJhL3LhdZXBQtI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 8CD6D6033F; Thu, 08 Jan 2026 13:42:26 +0100 (CET)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next] netfilter: nf_conntrack: enable icmp clash support
Date: Thu,  8 Jan 2026 13:42:11 +0100
Message-ID: <20260108124213.32143-1-fw@strlen.de>
X-Mailer: git-send-email 2.52.0
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

