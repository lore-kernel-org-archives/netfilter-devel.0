From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next] netfilter: xt_cpu: no need to check the validity
 of invert flag
Date: Thu, 23 Jun 2016 13:11:18 +0200
Message-ID: <20160623111118.GA2695@salvia>
References: <1465388607-26771-1-git-send-email-zlpnobody@163.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org,
	Liping Zhang <liping.zhang@spreadtrum.com>
To: Liping Zhang <zlpnobody@163.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:56999 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751788AbcFWLL0 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 23 Jun 2016 07:11:26 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id EDAAE1682E9
	for <netfilter-devel@vger.kernel.org>; Thu, 23 Jun 2016 13:11:24 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id D7E0AA86A
	for <netfilter-devel@vger.kernel.org>; Thu, 23 Jun 2016 13:11:24 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 2E06BFAB55
	for <netfilter-devel@vger.kernel.org>; Thu, 23 Jun 2016 13:11:22 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1465388607-26771-1-git-send-email-zlpnobody@163.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Jun 08, 2016 at 08:23:27PM +0800, Liping Zhang wrote:
> From: Liping Zhang <liping.zhang@spreadtrum.com>
> 
> Instead, we can convert invert flag and ensure it is 1 or 0.
> 
> Signed-off-by: Liping Zhang <liping.zhang@spreadtrum.com>
> ---
>  net/netfilter/xt_cpu.c | 12 +-----------
>  1 file changed, 1 insertion(+), 11 deletions(-)
> 
> diff --git a/net/netfilter/xt_cpu.c b/net/netfilter/xt_cpu.c
> index c7a2e54..ca1eaaf 100644
> --- a/net/netfilter/xt_cpu.c
> +++ b/net/netfilter/xt_cpu.c
> @@ -25,27 +25,17 @@ MODULE_DESCRIPTION("Xtables: CPU match");
>  MODULE_ALIAS("ipt_cpu");
>  MODULE_ALIAS("ip6t_cpu");
>  
> -static int cpu_mt_check(const struct xt_mtchk_param *par)
> -{
> -	const struct xt_cpu_info *info = par->matchinfo;
> -
> -	if (info->invert & ~1)
> -		return -EINVAL;
> -	return 0;
> -}

This trick is there so we can convert info->invert to info->flags in
the future without a new revision (given the binary interface did not
change). I'm not convinced there is much of benefit from getting rid
of this little extra _check() code that runs from the control plane
path.

>  static bool cpu_mt(const struct sk_buff *skb, struct xt_action_param *par)
>  {
>  	const struct xt_cpu_info *info = par->matchinfo;
>  
> -	return (info->cpu == smp_processor_id()) ^ info->invert;
> +	return (info->cpu == smp_processor_id()) ^ !!info->invert;
>  }
>  
>  static struct xt_match cpu_mt_reg __read_mostly = {
>  	.name       = "cpu",
>  	.revision   = 0,
>  	.family     = NFPROTO_UNSPEC,
> -	.checkentry = cpu_mt_check,
>  	.match      = cpu_mt,
>  	.matchsize  = sizeof(struct xt_cpu_info),
>  	.me         = THIS_MODULE,
> -- 
> 2.5.5
> 
> 
