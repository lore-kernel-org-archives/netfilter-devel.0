From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next v6 3/3] netfilter: bridge: nf queue verdict to
 use NFQA_VLAN and NFQA_L2HDR
Date: Tue, 29 Mar 2016 13:04:17 +0200
Message-ID: <20160329110417.GC10650@salvia>
References: <1458978132-8006-1-git-send-email-stephane.ml.bryant@gmail.com>
 <1458978132-8006-3-git-send-email-stephane.ml.bryant@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Stephane Bryant <stephane.ml.bryant@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:35843 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751538AbcC2LE0 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 29 Mar 2016 07:04:26 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 451288425
	for <netfilter-devel@vger.kernel.org>; Tue, 29 Mar 2016 13:04:24 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 00E29DA394
	for <netfilter-devel@vger.kernel.org>; Tue, 29 Mar 2016 13:04:25 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 21FD1DA39E
	for <netfilter-devel@vger.kernel.org>; Tue, 29 Mar 2016 13:04:19 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1458978132-8006-3-git-send-email-stephane.ml.bryant@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, Mar 26, 2016 at 08:42:12AM +0100, Stephane Bryant wrote:
> This makes nf queues use NFQA_VLAN and NFQA_L2HDR in verdict to modify the
> original skb

Applied this too, thanks. Just one minor glitch.

> Signed-off-by: Stephane Bryant <stephane.ml.bryant@gmail.com>
> ---
>  net/netfilter/nfnetlink_queue.c | 45 +++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 45 insertions(+)
> 
> diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
> index 6451f5d..a7ad25a 100644
> --- a/net/netfilter/nfnetlink_queue.c
> +++ b/net/netfilter/nfnetlink_queue.c
> @@ -967,12 +967,18 @@ static struct notifier_block nfqnl_rtnl_notifier = {
>  	.notifier_call	= nfqnl_rcv_nl_event,
>  };
>  
> +static const struct nla_policy nfqa_vlan_policy[NFQA_VLAN_MAX + 1] = {
> +	[NFQA_VLAN_TCI]		= { .type = NLA_U16},
> +	[NFQA_VLAN_PROTO]	= { .type = NLA_U16},
> +};
> +
>  static const struct nla_policy nfqa_verdict_policy[NFQA_MAX+1] = {
>  	[NFQA_VERDICT_HDR]	= { .len = sizeof(struct nfqnl_msg_verdict_hdr) },
>  	[NFQA_MARK]		= { .type = NLA_U32 },
>  	[NFQA_PAYLOAD]		= { .type = NLA_UNSPEC },
>  	[NFQA_CT]		= { .type = NLA_UNSPEC },
>  	[NFQA_EXP]		= { .type = NLA_UNSPEC },
> +	[NFQA_VLAN]		= { .type = NLA_NESTED },
>  };
>  
>  static const struct nla_policy nfqa_verdict_batch_policy[NFQA_MAX+1] = {
> @@ -1086,6 +1092,40 @@ static struct nf_conn *nfqnl_ct_parse(struct nfnl_ct_hook *nfnl_ct,
>  	return ct;
>  }
>  
> +static int nfqa_parse_bridge(struct nf_queue_entry *entry,
> +			     const struct nlattr * const nfqa[])
> +{
> +	if (nfqa[NFQA_VLAN]) {
> +		int err;
> +		struct nlattr *tb[NFQA_VLAN_MAX + 1];
> +
> +		err = nla_parse_nested(tb, NFQA_VLAN_MAX, nfqa[NFQA_VLAN],
> +				       nfqa_vlan_policy);
> +		if (err < 0)
> +			return err;
> +
> +		if (!tb[NFQA_VLAN_TCI] || !tb[NFQA_VLAN_PROTO])
> +			return -EINVAL;
> +
> +		entry->skb->vlan_tci = ntohs(nla_get_be16(tb[NFQA_VLAN_TCI]));
> +		entry->skb->vlan_proto = nla_get_be16(tb[NFQA_VLAN_PROTO]);
> +	}
> +
> +	if (nfqa[NFQA_L2HDR]) {
> +		int mac_header_len = entry->skb->network_header -
> +			entry->skb->mac_header;
> +
> +		if (mac_header_len != nla_len(nfqa[NFQA_L2HDR]))
> +			return -EINVAL;
> +		else if (mac_header_len > 0)
> +			memcpy(skb_mac_header(entry->skb),
> +			       nla_data(nfqa[NFQA_L2HDR]),
> +			       mac_header_len);
> +	}
> +
> +	return 0;
> +}
> +
>  static int nfqnl_recv_verdict(struct net *net, struct sock *ctnl,
>  			      struct sk_buff *skb,
>  			      const struct nlmsghdr *nlh,
> @@ -1127,6 +1167,11 @@ static int nfqnl_recv_verdict(struct net *net, struct sock *ctnl,
>  			ct = nfqnl_ct_parse(nfnl_ct, nlh, nfqa, entry, &ctinfo);
>  	}
>  
> +	if (entry->state.pf == PF_BRIDGE) {
> +		if (nfqa_parse_bridge(entry, nfqa) < 0)
> +			verdict = NF_DROP;

I have changed this to return -EINVAL instead, so userspace knows that
what it is doing is wrong.
