From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf 1/7] netfilter: x_tables: remove pr_info where possible
Date: Wed, 7 Feb 2018 18:03:04 +0100
Message-ID: <20180207170304.sqohdymzifoujlre@salvia>
References: <20180207134828.18691-1-fw@strlen.de>
 <20180207134828.18691-2-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:59776 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754392AbeBGRDT (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 7 Feb 2018 12:03:19 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id B242C3066A8
        for <netfilter-devel@vger.kernel.org>; Wed,  7 Feb 2018 18:03:17 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 7CD23BAAB7
        for <netfilter-devel@vger.kernel.org>; Wed,  7 Feb 2018 18:03:17 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20180207134828.18691-2-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Feb 07, 2018 at 02:48:22PM +0100, Florian Westphal wrote:
> remove several pr_info messages that cannot be triggered with iptables.
> 
> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
>  net/ipv4/netfilter/ipt_ECN.c | 10 ++++------
>  net/netfilter/xt_HL.c        | 13 +++----------
>  net/netfilter/xt_LED.c       |  4 +---
>  net/netfilter/xt_cgroup.c    |  4 +---
>  4 files changed, 9 insertions(+), 22 deletions(-)
> 
> diff --git a/net/ipv4/netfilter/ipt_ECN.c b/net/ipv4/netfilter/ipt_ECN.c
> index 270765236f5e..39ff167e6d86 100644
> --- a/net/ipv4/netfilter/ipt_ECN.c
> +++ b/net/ipv4/netfilter/ipt_ECN.c
> @@ -98,14 +98,12 @@ static int ecn_tg_check(const struct xt_tgchk_param *par)
>  	const struct ipt_ECN_info *einfo = par->targinfo;
>  	const struct ipt_entry *e = par->entryinfo;
>  
> -	if (einfo->operation & IPT_ECN_OP_MASK) {
> -		pr_info("unsupported ECN operation %x\n", einfo->operation);
> +	if (einfo->operation & IPT_ECN_OP_MASK)

According to patch 2/7, these should be pr_debug(), or probably I'm
misunderstanding something :-).
