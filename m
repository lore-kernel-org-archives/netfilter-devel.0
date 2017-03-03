From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf 1/1] netfilter: nat_masquerade: Check oom when invoke
 nfct_nat
Date: Fri, 3 Mar 2017 10:30:41 +0100
Message-ID: <20170303093041.GA1461@salvia>
References: <1488506332-21265-1-git-send-email-fgao@ikuai8.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, gfree.wind@gmail.com
To: fgao@ikuai8.com
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:54838 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751449AbdCCKYp (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 3 Mar 2017 05:24:45 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id E86C22D15F0
        for <netfilter-devel@vger.kernel.org>; Fri,  3 Mar 2017 10:30:52 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id D9872DA816
        for <netfilter-devel@vger.kernel.org>; Fri,  3 Mar 2017 10:30:52 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 27367DA81F
        for <netfilter-devel@vger.kernel.org>; Fri,  3 Mar 2017 10:30:46 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <1488506332-21265-1-git-send-email-fgao@ikuai8.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Mar 03, 2017 at 09:58:52AM +0800, fgao@ikuai8.com wrote:
> From: Gao Feng <fgao@ikuai8.com>
> 
> When memory is exhausted, nf_ct_nat_ext_add may return NULL. Then
> nf_nat_ipv4_fn and nf_nat_ipv6_fn would return NF_ACCEPT in this
> case.
> So we need add the NULL check when invoke nfct_nat in these two
> functions.
> 
> Signed-off-by: Gao Feng <fgao@ikuai8.com>
> ---
>  net/ipv4/netfilter/nf_nat_masquerade_ipv4.c | 2 ++
>  net/ipv6/netfilter/nf_nat_masquerade_ipv6.c | 6 +++++-
>  2 files changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/net/ipv4/netfilter/nf_nat_masquerade_ipv4.c b/net/ipv4/netfilter/nf_nat_masquerade_ipv4.c
> index ea91058..353ca0c 100644
> --- a/net/ipv4/netfilter/nf_nat_masquerade_ipv4.c
> +++ b/net/ipv4/netfilter/nf_nat_masquerade_ipv4.c
> @@ -38,6 +38,8 @@
>  
>  	ct = nf_ct_get(skb, &ctinfo);
>  	nat = nfct_nat(ct);
> +	if (!nat)
> +		return NF_ACCEPT;

The masquerade target is only called from the nat table. If you look
at nf_nat_ipv4_fn(), that is called whenever the packet enters a nat
table, you can indeed check that nfct_nat() must be already there by
when we call masquerade.

So this is entirely unnecessary.
