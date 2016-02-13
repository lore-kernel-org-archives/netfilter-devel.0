From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH nf-next v2 2/2] netfilter: bridge: pass L2 header and
 VLAN as netlink attributes in queues to userspace
Date: Sun, 14 Feb 2016 00:42:07 +0100
Message-ID: <20160213234207.GC10352@breakpoint.cc>
References: <1455202396-5334-1-git-send-email-stephane.ml.bryant@gmail.com>
 <1455202396-5334-3-git-send-email-stephane.ml.bryant@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: pablo@netfilter.org, netfilter-devel@vger.kernel.org
To: stephane.ml.bryant@gmail.com
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:34337 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751105AbcBMXmP (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 13 Feb 2016 18:42:15 -0500
Content-Disposition: inline
In-Reply-To: <1455202396-5334-3-git-send-email-stephane.ml.bryant@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

stephane.ml.bryant@gmail.com <stephane.ml.bryant@gmail.com> wrote:
> From: stephane <stephane.ml.bryant@gmail.com>
> 
> -this creates 2 netlink attribute NLQA_VLAN and NLQA_L2HDR
> -these are filled up for the PF_BRIDGE family on the way to userspace, and
>  used on the way back to modify the original skb accordingly

Looks good, some comments below.

> @@ -295,6 +295,59 @@ static u32 nfqnl_get_sk_secctx(struct sk_buff *skb, char **secdata)
>  	return seclen;
>  }
>  
> +static u32 nfqnl_get_bridge_nla_len(struct nf_queue_entry *entry)
> +{
> +	u32 nlalen = 0;
> +
> +	struct sk_buff *entskb = entry->skb;
> +
> +	if (skb_vlan_tag_present(entskb))
> +		nlalen += nla_total_size(sizeof(struct nfqnl_msg_vlan));
> +
> +	if (entry->state.in && entskb->dev &&

I don't think the state.in and entskb->dev tests are needed.

> +static int nfqnl_put_bridge_nla(struct nf_queue_entry *entry,
> +				struct sk_buff *skb)
> +{
> +	struct sk_buff *entskb = entry->skb;
> +

> +	if (entry->state.in && entskb->dev &&
> +	    (entskb->mac_header < entskb->network_header)) {

I'd suggest:

if (!skb_mac_header_was_set(entskb))
	return 0;

Another idea is to move the if (entry->state.pf == PF_BRIDGE) check
to this function to avoid increasing nfqnl_build_packet_message() size
too much.

> +		int len = (int)(entskb->network_header - entskb->mac_header);

> +		if (skb_tailroom(skb) <
> +		    NLA_ALIGN((sizeof(struct nlattr) + len)))
> +			goto nla_put_failure;
[..]

I'd suggest

return nla_put(skb, NFQA_L2HDR, len, skb_mac_header(entskb), len);

>  	if (nfqa[NFQA_PAYLOAD]) {
> -		u16 payload_len = nla_len(nfqa[NFQA_PAYLOAD]);
> -		int diff = payload_len - entry->skb->len;
> +		int payload_len = nla_len(nfqa[NFQA_PAYLOAD]);
> +		unsigned char *payload = nla_data(nfqa[NFQA_PAYLOAD]);
> +		int mac_header_len = 0;
> +		int diff = 0;
> +
> +		if (entry->state.pf == PF_BRIDGE)
> +			mac_header_len = nfqnl_push_l2hdr(&payload,
> +							  &payload_len,
> +							  entry, nfqa);
> 

Is there a reason why NFQA_L2HDR depends on NFQA_PAYLOAD presence?
I'd handle NFQA_L2HDR independently, after NFQA_PAYLOAD.

The replace procedure could look like this:

mac_header_len = entskb->mac_header - entskb->network_header;

if (mac_header_len != nla_len(nfqa[NFQA_L2HDR]))
	/* err */

memcpy(entskb->mac_header, nla_data(nfqa[NFQA_L2HDR], mac_header_len);

Yes, this doesn't allow increase/change of l2 header.
But I think we should not allow it for the time being.

We can always be more permissive later, possibly while adding
checks that there is a valid l2 eth header and that nothing will go wrong
with e.g. segmentation or fragmentation of skb on tx side.

You also might want to split this patch into two, one that adds the
'passive' features to make nfqueue work for logging, another one to add
the NFQA_L2HDR and VLAN manipulation.
