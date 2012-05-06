From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] netfilter: nf_ct_expect: partially implement
 ctnetlink_change_expect
Date: Mon, 7 May 2012 01:09:15 +0200
Message-ID: <20120506230915.GA23306@1984>
References: <1336005564-23171-1-git-send-email-kelvie@ieee.org>
 <1336005564-23171-3-git-send-email-kelvie@ieee.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Kelvie Wong <kelvie@ieee.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:49438 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754828Ab2EFXJU (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 6 May 2012 19:09:20 -0400
Content-Disposition: inline
In-Reply-To: <1336005564-23171-3-git-send-email-kelvie@ieee.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Kelvie,

On Wed, May 02, 2012 at 05:39:24PM -0700, Kelvie Wong wrote:
> This refreshes the "timeout" attribute in existing expectations if one is
> given.
> 
> The use case for this would be for userspace helpers to extend the lifetime
> of the expectation when requested, as this is not possible right now
> without deleting/recreating the expectation.
> 
> I use this specifically for forwarding DCERPC traffic through:
> 
> DCERPC has a port mapper daemon that chooses a (seemingly) random port for
> future traffic to go to. We expect this traffic (with a reasonable
> timeout), but sometimes the port mapper will tell the client to continue
> using the same port. This allows us to extend the expectation accordingly.
> 
> Signed-off-by: Kelvie Wong <kelvie@ieee.org>
> ---
>  net/netfilter/nf_conntrack_netlink.c |   10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
> index ca7e835..87a9682 100644
> --- a/net/netfilter/nf_conntrack_netlink.c
> +++ b/net/netfilter/nf_conntrack_netlink.c
> @@ -2065,6 +2065,16 @@ static int
>  ctnetlink_change_expect(struct nf_conntrack_expect *x,
>  			const struct nlattr * const cda[])
>  {
> +	/* Refresh the timeout */
> +	if (cda[CTA_EXPECT_TIMEOUT]) {
> +		if (!del_timer(&x->timeout))
> +			return -ETIME;
> +
> +		x->timeout.expires = jiffies +
> +			ntohl(nla_get_be32(cda[CTA_EXPECT_TIMEOUT])) * HZ;
> +		add_timer(&x->timeout);
> +		return 0;
> +	}

You have to protect this with nf_conntrack_lock spinlock. See
net/netfilter/nf_conntrack_expect.c for expectation handling.

>  	return -EOPNOTSUPP;

Now that we support expectation changing, this should be return 0.

We have two choices for this:

a) rework the patch with the suggestion that I made.
b) add some NF_CT_EXPECT_FIXED_TIMEOUT flag like we have in the
   connection tracking. Thus, the expectation will not ever expire.

I'd need to know more about how you're using this. Depending on that,
we can select a) or b).

BTW, I'm working on finishing some user-space framework for developing
helper in user-space. My question is: would you be interested in
integrating your DCERPC helper into it?

I expect to post some code soon, still working on it.
