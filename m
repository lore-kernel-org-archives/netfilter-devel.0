From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH v4] netfilter: introduce l2tp match extension
Date: Thu, 2 Jan 2014 21:57:13 +0100
Message-ID: <20140102205713.GA3758@localhost>
References: <1386857622-17389-1-git-send-email-jchapman@katalix.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: James Chapman <jchapman@katalix.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:42248 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750782AbaABU5V (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 2 Jan 2014 15:57:21 -0500
Content-Disposition: inline
In-Reply-To: <1386857622-17389-1-git-send-email-jchapman@katalix.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

On Thu, Dec 12, 2013 at 02:13:42PM +0000, James Chapman wrote:
> Introduce an xtables add-on for matching L2TP packets. Supports L2TPv2
> and L2TPv3 over IPv4 and IPv6. As well as filtering on L2TP tunnel-id
> and session-id, the filtering decision can also include the L2TP
> packet type (control or data), protocol version (2 or 3) and
> encapsulation type (UDP or IP).
> 
> The most common use for this will likely be to filter L2TP data
> packets of individual L2TP tunnels or sessions. While a u32 match can
> be used, the L2TP protocol headers are such that field offsets differ
> depending on bits set in the header, making rules for matching generic
> L2TP connections cumbersome. This match extension takes care of all
> that.
>
> An iptables patch will be submitted separately.

I'm testing this with the last userspace iptables patch that you
posted [1]. I'm using the example in the manpage:

# iptables -A INPUT -s 1.2.3.4 -m l2tp --tid 42
iptables: Invalid argument. Run `dmesg' for more information.
# dmesg
...
[  490.827569] xt_l2tp: missing encapsulation

The error message is added by the patch I made on top of your last
kernel patch (find it attached, feel free to merge it to your next v5).

> diff --git a/net/netfilter/xt_l2tp.c b/net/netfilter/xt_l2tp.c
> new file mode 100644
> index 0000000..d4ec208
> --- /dev/null
> +++ b/net/netfilter/xt_l2tp.c
[...]
> +static int l2tp_mt_check(const struct xt_mtchk_param *par)
> +{
> +	struct xt_l2tp_info *info = par->matchinfo;
> +
> +	/* Check for invalid flags */
> +	if (info->flags & ~(XT_L2TP_TID | XT_L2TP_SID | XT_L2TP_VERSION |
> +			    XT_L2TP_ENCAP | XT_L2TP_TYPE))
> +		return -EINVAL;
> +
> +	/* At least one of tid, sid or type=control must be specified */
> +	if ((!(info->flags & XT_L2TP_TID)) &&
> +	    (!(info->flags & XT_L2TP_SID)) &&
> +	    ((!(info->flags & XT_L2TP_TYPE)) ||
> +	     (info->type != XT_L2TP_TYPE_CONTROL)))
> +		return -EINVAL;
> +
> +	/* If version 2 is specified, check that incompatible params
> +	 * are not supplied
> +	 */
> +	if (info->flags & XT_L2TP_VERSION) {
> +		if ((info->version < 2) || (info->version > 3))
> +			return -EINVAL;
> +
> +		if (info->version == 2) {
> +			if ((info->flags & XT_L2TP_TID) &&
> +			    (info->tid > 0xffff))
> +				return -EINVAL;
> +			if ((info->flags & XT_L2TP_SID) &&
> +			    (info->sid > 0xffff))
> +				return -EINVAL;
> +			if ((info->flags & XT_L2TP_ENCAP) &&
> +			    (info->encap == XT_L2TP_ENCAP_IP))
> +				return -EINVAL;
> +
> +			/* Force UDP encap */
> +			info->encap = XT_L2TP_ENCAP_UDP;
> +			info->flags |= XT_L2TP_ENCAP;

Note that changing the info data area from the kernel side is
problematic in iptables, eg.

# iptables -A INPUT -s 1.2.3.4/32 -m l2tp --tid 42 --pversion 2
# iptables -D INPUT -s 1.2.3.4/32 -m l2tp --tid 42 --pversion 2
iptables: Bad rule (does a matching rule exist in that chain?).

Userspace needs to get exactly what it passes, no changes are allowed.
I think you need explicit option passing to indicate the behaviour you
want.

> +		}
> +	}
> +
> +	/* Encap must be specified */
> +	if (!(info->flags & XT_L2TP_ENCAP))
> +		return -EINVAL;
> +
> +	return 0;
> +}

Please, review this logic in the _check() function and send me a v5,
including a refreshed iptables version.

It would be great if you can include a list of iptables commands using
your l2tp match that you have used to validate this in the next round.
Thanks.

[1] http://patchwork.ozlabs.org/patch/288411/
