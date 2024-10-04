Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EF89157495
	for <netfilter-devel@vger.kernel.org>; Fri,  4 Oct 2024 10:29:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728037763; cv=none; b=KSqPRHnIiVsrnLudwO5GQSuUrJm+14MFJz4glgjOzUZv9dY7hQB8DwBvb1huTTmwTjhICPR8bspdHMoOMTMgqPfpJxrxbxw6/OLZ3M6mzcn73wjkt3ZWu1m79L+ZM6jMyntcpYqIBCSjE3E06EJROrQMlOvDW8St6LrKHbKWPis=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728037763; c=relaxed/simple;
	bh=ZxpLLobVQdgT7fmZZkqwU5LmjB+DtfJc46pG0E0XqTA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PQun47O7FbE3s3uck/G3FDXQAwVBTLKcew1ib5eGIR9LfAey1sy4LQGxWzPc4uG49h7iEtYwJ0sRGE7OZripQ4xGunPIaLvuL9Q3DkQHdPxrYO9oDuTJHSZ9JOQ0y6AIg5a10w6cCoiYIyS6LhGKKLMZE6utGCH+pwoAaxL3zZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.37.63] (port=53962 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1swfYY-00F7Kq-FX; Fri, 04 Oct 2024 12:29:08 +0200
Date: Fri, 4 Oct 2024 12:29:05 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org, syzkaller-bugs@googlegroups.com,
	syzbot+256c348558aa5cf611a9@syzkaller.appspotmail.com
Subject: Re: [PATCH nf] netfilter: xt_cluster: restrict to ip/ip6tables
Message-ID: <Zv_DcbtD7ey60qxR@calendula>
References: <20241003183053.8555-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="36DCZ6QFpek0yfVi"
Content-Disposition: inline
In-Reply-To: <20241003183053.8555-1-fw@strlen.de>
X-Spam-Score: -1.7 (-)


--36DCZ6QFpek0yfVi
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

On Thu, Oct 03, 2024 at 08:30:46PM +0200, Florian Westphal wrote:
> Restrict this match to iptables/ip6tables.
> syzbot managed to call it via ebtables:
> 
>  WARNING: CPU: 0 PID: 11 at net/netfilter/xt_cluster.c:72 xt_cluster_mt+0x196/0x780
>  [..]
>  ebt_do_table+0x174b/0x2a40
> 
> Module registers to NFPROTO_UNSPEC, but it assumes ipv4/ipv6 packet
> processing.  As this is only useful to restrict locally terminating
> TCP/UDP traffic, reject non-ip families at rule load time.

Fine with me. I had a similar patch looking like this.

This was never intented to be used by ebtables.

> Reported-by: syzbot+256c348558aa5cf611a9@syzkaller.appspotmail.com
> Tested-by: syzbot+256c348558aa5cf611a9@syzkaller.appspotmail.com
> Fixes: 0269ea493734 ("netfilter: xtables: add cluster match")
> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
>  net/netfilter/xt_cluster.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/net/netfilter/xt_cluster.c b/net/netfilter/xt_cluster.c
> index a047a545371e..fa45af1c48a9 100644
> --- a/net/netfilter/xt_cluster.c
> +++ b/net/netfilter/xt_cluster.c
> @@ -124,6 +124,14 @@ static int xt_cluster_mt_checkentry(const struct xt_mtchk_param *par)
>  	struct xt_cluster_match_info *info = par->matchinfo;
>  	int ret;
>  
> +	switch (par->family) {
> +	case NFPROTO_IPV4:
> +	case NFPROTO_IPV6:
> +		break;
> +	default:
> +		return -EAFNOSUPPORT;
> +	}
> +
>  	if (info->total_nodes > XT_CLUSTER_NODES_MAX) {
>  		pr_info_ratelimited("you have exceeded the maximum number of cluster nodes (%u > %u)\n",
>  				    info->total_nodes, XT_CLUSTER_NODES_MAX);
> -- 
> 2.45.2
> 
> 

--36DCZ6QFpek0yfVi
Content-Type: text/x-diff; charset=utf-8
Content-Disposition: attachment;
	filename="0001-netfilter-xt_cluster-restrict-it-to-NFPROTO_IPV4-and.patch"

From b41722e5a41b953702cf378f184f191049dba790 Mon Sep 17 00:00:00 2001
From: Pablo Neira Ayuso <pablo@netfilter.org>
Date: Fri, 4 Oct 2024 10:34:10 +0200
Subject: [PATCH] netfilter: xt_cluster: restrict it to NFPROTO_IPV4 and
 NFPROTO_IPV6

This match was designed to run on iptables and ip6tables only.

------------[ cut here ]------------
WARNING: CPU: 0 PID: 11 at net/netfilter/xt_cluster.c:72 xt_cluster_is_multicast_addr net/netfilter/xt_cluster.c:72 [inline]
WARNING: CPU: 0 PID: 11 at net/netfilter/xt_cluster.c:72 xt_cluster_mt+0x196/0x780 net/netfilter/xt_cluster.c:104
Modules linked in:
CPU: 0 UID: 0 PID: 11 Comm: kworker/u8:0 Not tainted 6.11.0-rc7-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 08/06/2024
Workqueue: ipv6_addrconf addrconf_dad_work
RIP: 0010:xt_cluster_is_multicast_addr net/netfilter/xt_cluster.c:72 [inline]
RIP: 0010:xt_cluster_mt+0x196/0x780 net/netfilter/xt_cluster.c:104
Code: f0 00 00 00 23 2b bf e0 00 00 00 89 ee e8 32 ee a1 f7 81 fd e0 00 00 00 75 1c e8 e5 e9 a1 f7 e9 83 00 00 00 e8 db e9 a1 f7 90 <0f>
+0b 90 eb 0c e8 d0 e9 a1 f7 eb 05 e8 c9 e9 a1 f7 4d 8d af 80 00
RSP: 0018:ffffc90000006c88 EFLAGS: 00010246
RAX: ffffffff89f1a2d5 RBX: 0000000000000007 RCX: ffff88801ced3c00
RDX: 0000000000000100 RSI: ffffffff8fd2a440 RDI: 0000000000000007
RBP: ffffc90000006e68 R08: 0000000000000001 R09: ffffffff89f1a1c4
R10: 0000000000000002 R11: ffff88801ced3c00 R12: dffffc0000000000
R13: 1ffff92000159c18 R14: ffffc90000ace140 R15: ffff8880251bf280
FS:  0000000000000000(0000) GS:ffff8880b8800000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007efc6d6b6440 CR3: 000000000e734000 CR4: 00000000003506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <IRQ>
 ebt_do_match net/bridge/netfilter/ebtables.c:109 [inline]
 ebt_do_table+0x174b/0x2a40 net/bridge/netfilter/ebtables.c:230
 nf_hook_entry_hookfn include/linux/netfilter.h:154 [inline]
 nf_hook_slow+0xc3/0x220 net/netfilter/core.c:626
 nf_hook include/linux/netfilter.h:269 [inline]
 NF_HOOK+0x2a7/0x460 include/linux/netfilter.h:312

Fixes: 0269ea493734 ("netfilter: xtables: add cluster match")
Reported-by: syzbot+256c348558aa5cf611a9@syzkaller.appspotmail.com
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/xt_cluster.c | 33 +++++++++++++++++++++++----------
 1 file changed, 23 insertions(+), 10 deletions(-)

diff --git a/net/netfilter/xt_cluster.c b/net/netfilter/xt_cluster.c
index a047a545371e..908fd5f2c3c8 100644
--- a/net/netfilter/xt_cluster.c
+++ b/net/netfilter/xt_cluster.c
@@ -146,24 +146,37 @@ static void xt_cluster_mt_destroy(const struct xt_mtdtor_param *par)
 	nf_ct_netns_put(par->net, par->family);
 }
 
-static struct xt_match xt_cluster_match __read_mostly = {
-	.name		= "cluster",
-	.family		= NFPROTO_UNSPEC,
-	.match		= xt_cluster_mt,
-	.checkentry	= xt_cluster_mt_checkentry,
-	.matchsize	= sizeof(struct xt_cluster_match_info),
-	.destroy	= xt_cluster_mt_destroy,
-	.me		= THIS_MODULE,
+static struct xt_match xt_cluster_match[] __read_mostly = {
+	{
+		.name		= "cluster",
+		.family		= NFPROTO_IPV4,
+		.match		= xt_cluster_mt,
+		.checkentry	= xt_cluster_mt_checkentry,
+		.matchsize	= sizeof(struct xt_cluster_match_info),
+		.destroy	= xt_cluster_mt_destroy,
+		.me		= THIS_MODULE,
+	},
+#if IS_ENABLED(CONFIG_IP6_NF_IPTABLES)
+	{
+		.name		= "cluster",
+		.family		= NFPROTO_IPV6,
+		.match		= xt_cluster_mt,
+		.checkentry	= xt_cluster_mt_checkentry,
+		.matchsize	= sizeof(struct xt_cluster_match_info),
+		.destroy	= xt_cluster_mt_destroy,
+		.me		= THIS_MODULE,
+	},
+#endif
 };
 
 static int __init xt_cluster_mt_init(void)
 {
-	return xt_register_match(&xt_cluster_match);
+	return xt_register_matches(xt_cluster_match, ARRAY_SIZE(xt_cluster_match));
 }
 
 static void __exit xt_cluster_mt_fini(void)
 {
-	xt_unregister_match(&xt_cluster_match);
+	xt_unregister_matches(xt_cluster_match, ARRAY_SIZE(xt_cluster_match));
 }
 
 MODULE_AUTHOR("Pablo Neira Ayuso <pablo@netfilter.org>");
-- 
2.30.2


--36DCZ6QFpek0yfVi--
