From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] Fix handling of verdicts after NF_QUEUE
Date: Tue, 12 Dec 2017 01:23:18 +0100
Message-ID: <20171212002318.GA7681@salvia>
References: <20171211233024.18303-1-dbanerje@akamai.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "David S . Miller" <davem@davemloft.net>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, stable@vger.kernel.org
To: Debabrata Banerjee <dbanerje@akamai.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:50930 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751628AbdLLAXX (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 11 Dec 2017 19:23:23 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 23F86E8E8C
        for <netfilter-devel@vger.kernel.org>; Tue, 12 Dec 2017 01:23:21 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 10CFFDA812
        for <netfilter-devel@vger.kernel.org>; Tue, 12 Dec 2017 01:23:21 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20171211233024.18303-1-dbanerje@akamai.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

Thanks for catching up this, see below.

On Mon, Dec 11, 2017 at 06:30:24PM -0500, Debabrata Banerjee wrote:
> A verdict of NF_STOLEN after NF_QUEUE will cause an incorrect return value
> and a potential kernel panic via double free of skb's
> 
> This was broken by commit 7034b566a4e7 ("netfilter: fix nf_queue handling")
> and subsequently fixed in v4.10 by commit c63cbc460419 ("netfilter:
> use switch() to handle verdict cases from nf_hook_slow()"). However that
> commit cannot be cleanly cherry-picked to v4.9
> 
> Signed-off-by: Debabrata Banerjee <dbanerje@akamai.com>
> 
> ---
> 
> This fix is only needed for v4.9 stable since v4.10+ does not have the
> issue
> ---
>  net/netfilter/core.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/net/netfilter/core.c b/net/netfilter/core.c
> index 004af030ef1a..d869ea50623e 100644
> --- a/net/netfilter/core.c
> +++ b/net/netfilter/core.c
> @@ -364,6 +364,11 @@ int nf_hook_slow(struct sk_buff *skb, struct nf_hook_state *state)
>  		ret = nf_queue(skb, state, &entry, verdict);
>  		if (ret == 1 && entry)
>  			goto next_hook;
> +	} else {
> +		/* Implicit handling for NF_STOLEN, as well as any other
> +		 * non conventional verdicts.
> +		 */
> +		ret = 0;

Another possibility (more simple?) would be this:

int nf_hook_slow(struct sk_buff *skb, struct nf_hook_state *state)
{
        struct nf_hook_entry *entry;
        unsigned int verdict;
-       int ret = 0;
+       int ret;

        entry = rcu_dereference(state->hook_entries);
next_hook:
+       ret = 0;

Basically, make sure ret is set to zero when jumping to the next_hook
label.

Thanks!
