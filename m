From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 1/3 nfnetlink_acct] numerous changes and improvements to
 the kernel code
Date: Sat, 23 Mar 2013 16:12:13 +0100
Message-ID: <20130323151213.GA4925@localhost>
References: <514D9D45.6090804@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Michael Zintakis <michael.zintakis@googlemail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:54588 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751115Ab3CWPMU (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 23 Mar 2013 11:12:20 -0400
Content-Disposition: inline
In-Reply-To: <514D9D45.6090804@googlemail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Michael,

On Sat, Mar 23, 2013 at 12:17:09PM +0000, Michael Zintakis wrote:
> The following is a first patch of a series of 3 patches dealing with the
> following kernel changes to nfnetlink_acct:
> 
> * fmt and bthr (format and bytes threshold) properties have been added to
>   the nfacct object.
> 
> * ability to change all nfacct object properties (with the exception of
>   name) has been added.
> 
> * as a result of the above, a full save/restore is now possible, even if
>   the accounting object is in use by iptables.
> 
> Signed-off-by: Michael Zintakis <michael.zintakis@googlemail.com>
> ---
>  include/uapi/linux/netfilter/nfnetlink_acct.h |    2 +
>  net/netfilter/nfnetlink_acct.c                |   63 ++++++++++++++++++++++++-
>  2 files changed, 64 insertions(+), 1 deletion(-)
> 
> diff --git a/include/uapi/linux/netfilter/nfnetlink_acct.h b/include/uapi/linux/netfilter/nfnetlink_acct.h
> index c7b6269..f07e825 100644
> --- a/include/uapi/linux/netfilter/nfnetlink_acct.h
> +++ b/include/uapi/linux/netfilter/nfnetlink_acct.h
> @@ -18,6 +18,8 @@ enum nfnl_acct_type {
>  	NFACCT_NAME,
>  	NFACCT_PKTS,
>  	NFACCT_BYTES,
> +	NFACCT_BTHR,
> +	NFACCT_FMT,
>  	NFACCT_USE,
>  	__NFACCT_MAX
>  };
> diff --git a/net/netfilter/nfnetlink_acct.c b/net/netfilter/nfnetlink_acct.c
> index 589d686..bcd4ae8 100644
> --- a/net/netfilter/nfnetlink_acct.c
> +++ b/net/netfilter/nfnetlink_acct.c
> @@ -32,6 +32,8 @@ static LIST_HEAD(nfnl_acct_list);
>  struct nf_acct {
>  	atomic64_t		pkts;
>  	atomic64_t		bytes;
> +	atomic64_t		bthr;
> +	atomic_t		fmt;

These two new fields are meaningless to the kernel and they consume
extra memory for other people that may not want to use these new
features.

Instead of this, you can have a /etc/nfacct.conf file that contains
the formats and thresholds:

name "ALL 27 net" {
        pkts GiB
        bytes TiB
        threshold 6TiB
}

name "ALL misc" {
        bytes GiB
}

...

and so on. You can add new options for the `nfacct add' command so
this formats and thresholds are automatically appended to the
configuration file.

I can help you by making a little parser to read the file and put that
formatting information into a list or hashtable. Thus, you can edit
the format and thresholds by modifying the configuration file, without
the need for interactions with the kernel.

BTW, atomic is not required for those two fields, this is protected by
the nfnl_lock.

>  	struct list_head	head;
>  	atomic_t		refcnt;
>  	char			name[NFACCT_NAME_MAX];
> @@ -63,9 +65,55 @@ nfnl_acct_new(struct sock *nfnl, struct sk_buff *skb,
>  
>  	if (matching) {
>  		if (nlh->nlmsg_flags & NLM_F_REPLACE) {
> -			/* reset counters if you request a replacement. */
> +			/* reset counters if you request a replacement */
> +			if (!tb[NFACCT_PKTS]) {
> +				/*
> +				 * Prevent resetting the packets counter if
> +				 * either fmt or bthr are specified.
> +				 *
> +				 * This is done for backward compatibility,
> +				 * otherwise resetting these counters should
> +				 * only be allowed when tb[NFACCT_PKTS] is
> +				 * explicitly specified and == 0.
> +				 *
> +				 */
> +				if (!tb[NFACCT_FMT] &&
> +				    !tb[NFACCT_BTHR]) {
>  			atomic64_set(&matching->pkts, 0);
> +				}
> +			} else {
> +				atomic64_set(&matching->pkts,
> +				be64_to_cpu(nla_get_be64(tb[NFACCT_PKTS])));

The replacement operation is not so easy. Note that you may hit
inconsistencies if while replacing the packet counter, the kernel
updates the byte counter, and then you replace the byte counter. You
would be leaking bytes and packets.
