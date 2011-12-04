From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 1/1] netfilter: conntrack: make call to nf_log_packet
 due to helper rejection conditional on LOG_INVALID (resubmit)
Date: Sun, 4 Dec 2011 23:49:46 +0100
Message-ID: <20111204224946.GC28125@1984>
References: <CANtneHLYOANXQ432me_htXrMcQkv-WVpNYTrwmxAjc2gV68iPA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Pete Holland <pholland27@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:46169 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754742Ab1LDWuH (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 4 Dec 2011 17:50:07 -0500
Content-Disposition: inline
In-Reply-To: <CANtneHLYOANXQ432me_htXrMcQkv-WVpNYTrwmxAjc2gV68iPA@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Peter,

On Fri, Dec 02, 2011 at 09:37:04AM -0800, Pete Holland wrote:
> From: Peter Holland <pholland27@gmail.com>
> 
> Make the logging of dropped packets due to ct helper rejection
> conditional on LOG_INVALID.
> This is consistent with the other uses of nf_log_packet.
> Use protocol from conntrack tuple (original direction).
> Without this check, there is a possible DoS based on traffic induced
> log generation.
> (specifically this was noted in the wild by an attacker against the SIP helper)
> 
> Signed-off-by: Peter Holland <pholland27@gmail.com>
> ---
> --- net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c.orig	2011-11-29
> 11:34:36.683717278 -0800
> +++ net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c	2011-12-02
> 09:32:00.727064563 -0800
> @@ -116,8 +116,10 @@ static unsigned int ipv4_confirm(unsigne
>  	ret = helper->help(skb, skb_network_offset(skb) + ip_hdrlen(skb),
>  			   ct, ctinfo);
>  	if (ret != NF_ACCEPT) {
> -		nf_log_packet(NFPROTO_IPV4, hooknum, skb, in, out, NULL,
> -			      "nf_ct_%s: dropping packet", helper->name);
> +		if (LOG_INVALID(nf_ct_net(ct),
> +				ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.dst.protonum))

You can use nf_ct_protonum here.

> +			nf_log_packet(NFPROTO_IPV4, hooknum, skb, in, out, NULL,
> +				      "nf_ct_%s: dropping packet", helper->name);
>  		return ret;
>  	}

Below you can find:

/* adjust seqs for loopback traffic only in outgoing direction */
if (test_bit(IPS_SEQ_ADJUST_BIT, &ct->status) &&
    !nf_is_loopback_packet(skb)) {
        typeof(nf_nat_seq_adjust_hook) seq_adjust;

        seq_adjust = rcu_dereference(nf_nat_seq_adjust_hook);
        if (!seq_adjust || !seq_adjust(skb, ct, ctinfo)) {
                NF_CT_STAT_INC_ATOMIC(nf_ct_net(ct), drop);
                                      ^^^^^^^^^^^^

Please, declare in ipv4_confirm:

struct net *net = nf_ct_net(ct);

And use the net pointer in that function.

Same thing for the IPv6 side.

Thank you.
