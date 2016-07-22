From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 2/2] netfilter: connlabels: move set helper to
 xt_connlabel
Date: Fri, 22 Jul 2016 17:09:27 +0200
Message-ID: <20160722150926.GA21470@salvia>
References: <1469098277-1227-1-git-send-email-fw@strlen.de>
 <1469098277-1227-3-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:59239 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751058AbcGVPJp (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 22 Jul 2016 11:09:45 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 523951DF891
	for <netfilter-devel@vger.kernel.org>; Fri, 22 Jul 2016 17:09:43 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 42279266747
	for <netfilter-devel@vger.kernel.org>; Fri, 22 Jul 2016 17:09:43 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 7BA94266733
	for <netfilter-devel@vger.kernel.org>; Fri, 22 Jul 2016 17:09:38 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1469098277-1227-3-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Jul 21, 2016 at 12:51:17PM +0200, Florian Westphal wrote:
> xt_connlabel is the only user so move it.
> 
> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
>  include/net/netfilter/nf_conntrack_labels.h |  2 --
>  net/netfilter/nf_conntrack_labels.c         | 17 -----------------
>  net/netfilter/xt_connlabel.c                | 29 ++++++++++++++++-------------
>  3 files changed, 16 insertions(+), 32 deletions(-)
>
[...]
> @@ -40,10 +32,21 @@ connlabel_mt(const struct sk_buff *skb, struct xt_action_param *par)
>  	if (ct == NULL || nf_ct_is_untracked(ct))
>  		return invert;
>  
> -	if (info->options & XT_CONNLABEL_OP_SET)
> -		return (nf_connlabel_set(ct, info->bit) == 0) ^ invert;
> +	labels = nf_ct_labels_find(ct);
> +	if (!labels)
> +		return invert;
> +
> +	if (test_bit(info->bit, labels->bits))
> +		return !invert;
> +
> +	if (info->options & XT_CONNLABEL_OP_SET) {
> +		if (!test_and_set_bit(info->bit, labels->bits))
> +			nf_conntrack_event_cache(IPCT_LABEL, ct);
> +
> +		return !invert;
> +	}

This patch inverts the existing logic, right? So this is first testing
for the bit, then setting it.

Before this patch, I remember because of what we discussed wrt. the
translation to nftables, was actually the opposite.
