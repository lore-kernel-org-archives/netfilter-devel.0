Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94B8A3D902E;
	Mon, 10 Aug 2026 13:01:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786366880; cv=none; b=u2ajAgo7cVuy4ZelMB5AB68VmGhL5UEjVsEAMV9pXXju+GXSog++p4V8x37h20WGtmUSLkkAeQso1qGMCZMP/EmMi9GFO6H6luvNJzeHmgk9sGvuV54r1MZ8lInAH8wiCdaCYPJjvVtUCwC4ApOGVonkHLlqEaqa9XHK4WcpvAo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786366880; c=relaxed/simple;
	bh=cmAvZ19cBxKvDIXFYQDyg2kQK+OVtNvKHnf3LRawjkw=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=nUjj3y9OuQHKX/rlsZxxkXO2Yl+MquboN8+BI946r6YDYFYEeLupBiGWjzhf9mX5rxUXFBW5u19SefKFlEO3EnfVdhffLPN0a1KuzyeABWsOxA1DGYwnhZGpxUvzSr8/rCtPfKt5pax0be5rg6wX2T+FQS2HJzCd+lcsHDNpsjI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Tb7xI907; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Tb7xI907"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 47ED4C2BCF7;
	Mon, 10 Aug 2026 13:01:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1786366880;
	bh=cmAvZ19cBxKvDIXFYQDyg2kQK+OVtNvKHnf3LRawjkw=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=Tb7xI907Og/rWIv9VCdy8kpJnF25F5zvB4qwCuB/iDkxLY7i1hKd7MA29hLIMG8xj
	 7rvbe+fubFSf1QyRt9PsI8za/Y/4enuxb6x9uoHTk3rujmoEo10HHzkSQ6qTf+u8Tm
	 lmSmHz1zfMu3/LHCrg5hRP0Rr1SnW++ityIgP4G5HcAbc+RuRRZh38DUz5K8AgYej3
	 RX9AFlOeSHo7fCpdzAQUutL0quRTvEAcd4tMZuHd1ljnZGre6at8+wCgh3hz1wKsTC
	 0eSr1vOfsrKhHyX6/RiWVmKPntnlGpXrS9VlgYzi6rG9aBtShCcIITZ86mvy6VJEmD
	 RWfEEI3Pg7xuA==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2FD8EC5AD7B;
	Mon, 10 Aug 2026 13:01:20 +0000 (UTC)
From: Joel Granados <joel.granados@kernel.org>
Date: Mon, 10 Aug 2026 15:01:03 +0200
Subject: [PATCH v4 2/3] net: Const qualify ctl_tables that kmemdup
 unconditionally
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260810-jag-net_const_qualify-v4-2-77e888237c69@kernel.org>
References: <20260810-jag-net_const_qualify-v4-0-77e888237c69@kernel.org>
In-Reply-To: <20260810-jag-net_const_qualify-v4-0-77e888237c69@kernel.org>
To: "David S. Miller" <davem@davemloft.net>, 
 Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, 
 Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, 
 David Ahern <dsahern@kernel.org>, Ido Schimmel <idosch@nvidia.com>, 
 Pablo Neira Ayuso <pablo@netfilter.org>, Florian Westphal <fw@strlen.de>, 
 Phil Sutter <phil@nwl.cc>, 
 Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, 
 Xin Long <lucien.xin@gmail.com>, 
 Steffen Klassert <steffen.klassert@secunet.com>, 
 Herbert Xu <herbert@gondor.apana.org.au>, 
 "D. Wythe" <alibuda@linux.alibaba.com>, Dust Li <dust.li@linux.alibaba.com>, 
 Sidraya Jayagond <sidraya@linux.ibm.com>, 
 Wenjia Zhang <wenjia@linux.ibm.com>, 
 Mahanta Jambigi <mjambigi@linux.ibm.com>, 
 Tony Lu <tonylu@linux.alibaba.com>, Wen Gu <guwen@linux.alibaba.com>, 
 Kuniyuki Iwashima <kuniyu@google.com>, 
 Stefano Garzarella <sgarzare@redhat.com>
Cc: chia-yu.chang@nokia-bell-labs.com, netdev@vger.kernel.org, 
 linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org, 
 coreteam@netfilter.org, linux-sctp@vger.kernel.org, 
 linux-rdma@vger.kernel.org, linux-s390@vger.kernel.org, 
 virtualization@lists.linux.dev, Joel Granados <joel.granados@kernel.org>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=4380;
 i=joel.granados@kernel.org; h=from:subject:message-id;
 bh=cmAvZ19cBxKvDIXFYQDyg2kQK+OVtNvKHnf3LRawjkw=;
 b=owJ4nAHtARL+kA0DAAoBupfNUreWQU8ByyZiAGp5y51liGHWq2D4loETsdzKtPejkgiQOjCxG
 aB/wwwIKZFLDokBswQAAQoAHRYhBK5HCVcl5jElzssnkLqXzVK3lkFPBQJqecudAAoJELqXzVK3
 lkFPyegMAIj5M8HS2/tVsKpWcof6V5mm7X7hEMc9qsvcL/r2bRiHAQTEHv2Kz49MiEbqcIlIuyS
 sQqC3BVGxOpjL6kmp9KUIYPNJwxZaIZNSRaJ8WdRfzLIS0wtCMzqzNmirJuGyEhpXHl3yw+6Gd5
 tSaZb2J67uX+Q0giMWG6VQq7E5vsXFHrknwRkA5hp2jzrjBgLsGuYl2L9lsesuKVGdJIWqqFvyp
 6OqANRHjrBx2IZn2wuRNrmz/Z8kzlvFSGSN/D5iQ3Zb2xxJqNleuLKQfK7FI/+FYA7D4kgFRUt/
 VF4kkqEluH49lpwU+IVBy0bt5NbEwLp1OXCwnONe98BJ3MI+dZPJVwuHK9OQJAmW010uxuwQG5e
 ZAmRb8fCqo6kGR/Cuvkduo9amnKD2dF/hx440d3OzpoUp+yMKpNG0+OSYv5lfrvzXRRoJxJ2Z4g
 12Utv+67BjPZYGbVR8qHh6ZYcDpP9KlP96CBpEDUu3vlKSiW0fv0z9KcK5NsU9eDoUgENupTdj8
 Ag=
X-Developer-Key: i=joel.granados@kernel.org; a=openpgp;
 fpr=F1F8E46D30F0F6C4A45FF4465895FAAC338C6E77
X-Endpoint-Received: by B4 Relay for joel.granados@kernel.org/default with
 auth_id=239

Const qualify clt_table arrays in the net directory that always pass a
memory duplicate to sysctl register. The template would then be in
.rodata and the kmemdup'ed array would be outside.

Signed-off-by: Joel Granados <joel.granados@kernel.org>
---
 net/ipv4/devinet.c                      | 2 +-
 net/ipv6/icmp.c                         | 2 +-
 net/ipv6/route.c                        | 2 +-
 net/ipv6/sysctl_net_ipv6.c              | 2 +-
 net/netfilter/nf_conntrack_standalone.c | 2 +-
 net/sctp/sysctl.c                       | 2 +-
 net/xfrm/xfrm_sysctl.c                  | 2 +-
 7 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/net/ipv4/devinet.c b/net/ipv4/devinet.c
index 47ded0f607d4bd502350f678c91b0054e3856427..a90be57c63be1565b2dff51e8264668fd71b9e58 100644
--- a/net/ipv4/devinet.c
+++ b/net/ipv4/devinet.c
@@ -2796,7 +2796,7 @@ static void devinet_sysctl_unregister(struct in_device *idev)
 	neigh_sysctl_unregister(idev->arp_parms);
 }
 
-static struct ctl_table ctl_forward_entry[] = {
+static const struct ctl_table ctl_forward_entry[] = {
 	{
 		.procname	= "ip_forward",
 		.data		= &ipv4_devconf.data[
diff --git a/net/ipv6/icmp.c b/net/ipv6/icmp.c
index efb23807a0262e8d68aa1afc8d96ee94eab89d50..a95b0351824f3237815e43bf8448110070955884 100644
--- a/net/ipv6/icmp.c
+++ b/net/ipv6/icmp.c
@@ -1374,7 +1374,7 @@ EXPORT_SYMBOL(icmpv6_err_convert);
 static u32 icmpv6_errors_extension_mask_all =
 	GENMASK_U8(ICMP_ERR_EXT_COUNT - 1, 0);
 
-static struct ctl_table ipv6_icmp_table_template[] = {
+static const struct ctl_table ipv6_icmp_table_template[] = {
 	{
 		.procname	= "ratelimit",
 		.data		= &init_net.ipv6.sysctl.icmpv6_time,
diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index 5968ce5ad15082949ec4551458a1e2115ae803ac..b833a6400c944da6cdbf2b4cfa87a5730ac2e06b 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -6555,7 +6555,7 @@ static int ipv6_sysctl_rtcache_flush(const struct ctl_table *ctl, int write,
 	return 0;
 }
 
-static struct ctl_table ipv6_route_table_template[] = {
+static const struct ctl_table ipv6_route_table_template[] = {
 	{
 		.procname	=	"max_size",
 		.data		=	&init_net.ipv6.sysctl.ip6_rt_max_size,
diff --git a/net/ipv6/sysctl_net_ipv6.c b/net/ipv6/sysctl_net_ipv6.c
index d2cd33e2698d5c88df4718c9622dba2d574fa309..1a0a36dcdabc1be961d0ab69e5c93b05c53f46a8 100644
--- a/net/ipv6/sysctl_net_ipv6.c
+++ b/net/ipv6/sysctl_net_ipv6.c
@@ -61,7 +61,7 @@ proc_rt6_multipath_hash_fields(const struct ctl_table *table, int write, void *b
 	return ret;
 }
 
-static struct ctl_table ipv6_table_template[] = {
+static const struct ctl_table ipv6_table_template[] = {
 	{
 		.procname	= "bindv6only",
 		.data		= &init_net.ipv6.sysctl.bindv6only,
diff --git a/net/netfilter/nf_conntrack_standalone.c b/net/netfilter/nf_conntrack_standalone.c
index be2953c7d702e92031d4bcf7e707741abed0f49c..f4f2d82192d54ed9831b9677743f1139820e5a2e 100644
--- a/net/netfilter/nf_conntrack_standalone.c
+++ b/net/netfilter/nf_conntrack_standalone.c
@@ -639,7 +639,7 @@ enum nf_ct_sysctl_index {
 	NF_SYSCTL_CT_LAST_SYSCTL,
 };
 
-static struct ctl_table nf_ct_sysctl_table[] = {
+static const struct ctl_table nf_ct_sysctl_table[] = {
 	[NF_SYSCTL_CT_MAX] = {
 		.procname	= "nf_conntrack_max",
 		.data		= &nf_conntrack_max,
diff --git a/net/sctp/sysctl.c b/net/sctp/sysctl.c
index fca840484ebf77853316704fa2ce7cc619524573..2b94c211427de7b2e9aa374033eac26ddd874e14 100644
--- a/net/sctp/sysctl.c
+++ b/net/sctp/sysctl.c
@@ -92,7 +92,7 @@ static struct ctl_table sctp_table[] = {
 #define SCTP_PF_RETRANS_IDX    2
 #define SCTP_PS_RETRANS_IDX    3
 
-static struct ctl_table sctp_net_table[] = {
+static const struct ctl_table sctp_net_table[] = {
 	[SCTP_RTO_MIN_IDX] = {
 		.procname	= "rto_min",
 		.data		= &init_net.sctp.rto_min,
diff --git a/net/xfrm/xfrm_sysctl.c b/net/xfrm/xfrm_sysctl.c
index ca003e8a03760cd8dbb9e9f7cd5a9738eeeb7e71..357152a50faf10e5c33468c034dd1777e0bed079 100644
--- a/net/xfrm/xfrm_sysctl.c
+++ b/net/xfrm/xfrm_sysctl.c
@@ -13,7 +13,7 @@ static void __net_init __xfrm_sysctl_init(struct net *net)
 }
 
 #ifdef CONFIG_SYSCTL
-static struct ctl_table xfrm_table[] = {
+static const struct ctl_table xfrm_table[] = {
 	{
 		.procname	= "xfrm_aevent_etime",
 		.maxlen		= sizeof(u32),

-- 
2.50.1


