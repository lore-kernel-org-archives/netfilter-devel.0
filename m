From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next v5 3/3] netfilter: bridge: nf queue verdict to
 use NFQA_VLAN and NFQA_L2HDR
Date: Tue, 22 Mar 2016 20:12:15 +0100
Message-ID: <20160322191215.GA7018@salvia>
References: <1458461206-4338-1-git-send-email-stephane.ml.bryant@gmail.com>
 <1458461206-4338-3-git-send-email-stephane.ml.bryant@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Stephane Bryant <stephane.ml.bryant@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:40928 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751939AbcCVTMa (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 22 Mar 2016 15:12:30 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id D8771C9EFC
	for <netfilter-devel@vger.kernel.org>; Tue, 22 Mar 2016 20:12:28 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id CC354DA386
	for <netfilter-devel@vger.kernel.org>; Tue, 22 Mar 2016 20:12:28 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id D697EDA380
	for <netfilter-devel@vger.kernel.org>; Tue, 22 Mar 2016 20:12:24 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <1458461206-4338-3-git-send-email-stephane.ml.bryant@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Stephane,

We're almost there, a bit more changes for this please.

On Sun, Mar 20, 2016 at 09:06:46AM +0100, Stephane Bryant wrote:
> This makes nf queues use NFQA_VLAN and NFQA_L2HDR in verdict to modify the
> original skb
> 
> Signed-off-by: Stephane Bryant <stephane.ml.bryant@gmail.com>
> ---
>  net/netfilter/nfnetlink_queue.c | 25 +++++++++++++++++++++++++
>  1 file changed, 25 insertions(+)
> 
> diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
> index 0da0276..aa526f0 100644
> --- a/net/netfilter/nfnetlink_queue.c
> +++ b/net/netfilter/nfnetlink_queue.c
> @@ -1126,6 +1126,31 @@ static int nfqnl_recv_verdict(struct net *net, struct sock *ctnl,
>  			ct = nfqnl_ct_parse(nfnl_ct, nlh, nfqa, entry, &ctinfo);
>  	}
>  
> +	if (nfqa[NFQA_VLAN]) {
> +		struct nlattr *vlan_tci =
> +			nla_find_nested(nfqa[NFQA_VLAN], NFQA_VLAN_TCI);
> +		struct nlattr *vlan_proto =
> +			nla_find_nested(nfqa[NFQA_VLAN], NFQA_VLAN_PROTO);
> +
> +		if (vlan_tci)
> +			entry->skb->vlan_tci = ntohs(nla_get_be16(vlan_tci));
> +
> +		if (vlan_proto)
> +			entry->skb->vlan_proto = nla_get_be16(vlan_proto);
> +	}

Could you replace this chunk above by something like...

        if (entry->state.pf == PF_BRIDGE) {
                err = nfqa_parse_bridge(nfqa);
                if (err < 0)
                        return err;
        }

Then, this nfqa_parse_bridge() should look like;

        if (nfqa[NFQA_VLAN]) {
                struct nlattr *tb[NFQA_VLAN_MAX + 1];

                err = nla_parse_nested(tb, NFQA_VLAN_MAX, nfqa[NFQA_VLAN],
                                       nfqa_vlan_policy);
                if (err < 0)
                        return err;

                if (!tb[NFQA_VLAN_TCI] ||
                    !tb[NFTA_VLAN_PROTO])
                        return -EINVAL;

                if (tb[NFQA_VLAN_TCI])
			entry->skb->vlan_tci =
                                ntohs(nla_get_be16(tb[NFQA_VLAN_TCI]));
                if (tb[NFAQ_VLAN_PROTO])
                        entry->skb->vlan_proto =
                                nla_get_be16(tb[NFQA_VLAN_PROTO]);
        }

        if (nfqa[NFQA_L2HDR]) {
                ...
        }

You will need the policy structure BTW:

static const struct nla_policy nfqa_verdict_policy[NFQA_VLAN_MAX + 1] = {
        [NFQA_VLAN_TCI]         = { .type = NLA_U16 },
        [NFQA_VLAN_PROTO]       = { .type = NLA_U16 },
};

And don't forget to update nfqa_verdict_policy to add the NFQA_VLAN
nested attribute there as:

        .type   = NLA_NESTED.

Thanks !
