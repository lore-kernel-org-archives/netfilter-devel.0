From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH net-next v4 8/8] openvswitch: Interface with NAT.
Date: Thu, 10 Dec 2015 20:10:08 +0100
Message-ID: <20151210191008.GA20440@salvia>
References: <1449622870-48944-1-git-send-email-jarno@ovn.org>
 <1449622870-48944-9-git-send-email-jarno@ovn.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
	dev@openvswitch.org
To: Jarno Rajahalme <jarno@ovn.org>
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1449622870-48944-9-git-send-email-jarno@ovn.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Tue, Dec 08, 2015 at 05:01:10PM -0800, Jarno Rajahalme wrote:
> -	/* Call the helper right after nf_conntrack_in() for confirmed
> -	 * connections, but only when commiting for unconfirmed connections.
> -	 */
>  	ct = nf_ct_get(skb, &ctinfo);
> -	if (ct && (nf_ct_is_confirmed(ct) ? !cached : info->commit)
> -	    && ovs_ct_helper(skb, info->family) != NF_ACCEPT) {
> -		WARN_ONCE(1, "helper rejected packet");
> -		return -EINVAL;
> +	if (ct) {
> +#ifdef CONFIG_NF_NAT_NEEDED
> +		/* Packets starting a new connection must be NATted before the
> +		 * helper, so that the helper knows about the NAT.  We enforce
> +		 * this by delaying both NAT and helper calls for unconfirmed
> +		 * connections until the commiting CT action.  For later
> +		 * packets NAT and Helper may be called in either order.
> +		 *
> +		 * NAT will be done only if the CT action has NAT, and only
> +		 * once per packet (per zone), as guarded by the NAT bits in
> +		 * the key->ct.state.
> +		 */
> +		if (info->nat && !(key->ct.state & OVS_CS_F_NAT_MASK) &&
> +		    (nf_ct_is_confirmed(ct) || info->commit) &&
> +		    ovs_ct_nat(net, key, info, skb, ct, ctinfo) != NF_ACCEPT) {
> +			WARN_ONCE(1, "NAT rejected packet");

NAT can drop packets, so this warn_on I don't think you need it.

> +			return -EINVAL;
> +		}
> +#endif
> +		/* Call the helper whenever nf_conntrack_in() was called for
> +		 * confirmed connections, but only when commiting for
> +		 * unconfirmed connections.
> +		 */
> +		if ((nf_ct_is_confirmed(ct) ? !cached : info->commit)
> +		    && ovs_ct_helper(skb, info->family) != NF_ACCEPT) {
> +			WARN_ONCE(1, "helper rejected packet");

Same thing may happen with helpers.
