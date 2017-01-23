From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH v3 nf-next 5/7] netfilter: add and use nf_ct_set helper
Date: Mon, 23 Jan 2017 13:54:03 +0100
Message-ID: <20170123125403.GA1962@salvia>
References: <1485174530-7678-1-git-send-email-fw@strlen.de>
 <1485174530-7678-6-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:37820 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750761AbdAWMyN (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 23 Jan 2017 07:54:13 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 64D3715AEA7
        for <netfilter-devel@vger.kernel.org>; Mon, 23 Jan 2017 13:54:11 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 5633D1B30BD
        for <netfilter-devel@vger.kernel.org>; Mon, 23 Jan 2017 13:54:11 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 5B37C1B2F18
        for <netfilter-devel@vger.kernel.org>; Mon, 23 Jan 2017 13:54:08 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <1485174530-7678-6-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Jan 23, 2017 at 01:28:48PM +0100, Florian Westphal wrote:
> diff --git a/net/netfilter/core.c b/net/netfilter/core.c
> index 0c629fdf90e1..ce6adfae521a 100644
> --- a/net/netfilter/core.c
> +++ b/net/netfilter/core.c
> @@ -375,7 +375,7 @@ void nf_ct_attach(struct sk_buff *new, const struct sk_buff *skb)
>  {
>  	void (*attach)(struct sk_buff *, const struct sk_buff *);
>  
> -	if (skb_nfct(skb)) {
> +	if (skb->nfct) {

I guess this slipped through accidentally. No need to resent, I can
amend it here.

>  		rcu_read_lock();
>  		attach = rcu_dereference(ip_ct_attach);
>  		if (attach)

