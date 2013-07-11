From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH v3 kernel 24/29] add packets and bytes mark capability to
 nfacct
Date: Thu, 11 Jul 2013 03:14:46 +0200
Message-ID: <20130711011446.GA7065@localhost>
References: <1373480727-11254-1-git-send-email-michael.zintakis@googlemail.com>
 <1373480727-11254-25-git-send-email-michael.zintakis@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Michael Zintakis <michael.zintakis@googlemail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:36866 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754177Ab3GKBPD (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 10 Jul 2013 21:15:03 -0400
Content-Disposition: inline
In-Reply-To: <1373480727-11254-25-git-send-email-michael.zintakis@googlemail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Jul 10, 2013 at 07:25:22PM +0100, Michael Zintakis wrote:
> * add two variables to each nfacct object - 'pmark' and 'bmark', allowing
> short-term traffic accounting to be implemented by placing a "mark" against
> that object.
> 
> This enables counting of traffic (both bytes and packets) since that mark has
> been enabled/set, in addition to the main packet and byte counters.
> 
> Signed-off-by: Michael Zintakis <michael.zintakis@googlemail.com>
> ---
>  include/uapi/linux/netfilter/nfnetlink_acct.h |  8 +++-
>  net/netfilter/nfnetlink_acct.c                | 56 +++++++++++++++++++++++++++
>  2 files changed, 63 insertions(+), 1 deletion(-)
> 
> diff --git a/net/netfilter/nfnetlink_acct.c b/net/netfilter/nfnetlink_acct.c
> index 18cd28e..809fa35 100644
> --- a/net/netfilter/nfnetlink_acct.c
> +++ b/net/netfilter/nfnetlink_acct.c
> @@ -33,6 +33,8 @@ struct nf_acct {
>  	atomic64_t		pkts;
>  	atomic64_t		bytes;
>  	u64			bthr;
> +	u64			pmark;
> +	u64			bmark;
>  	u16			fmt;
>  	u16			flags;
>  	struct list_head	head;

Oh my...

You insist on your idea of using the kernel as a database to simplify
your user-space program. All these fields are set/unset from
userspace, they are not altered by packets at all. This does not
belong here.

> @@ -61,6 +63,10 @@ nfnl_acct_new(struct sock *nfnl, struct sk_buff *skb,
>  		cmd = be16_to_cpu(nla_get_be16(tb[NFACCT_CMD]));
>  		flags = be16_to_cpu(nla_get_be16(tb[NFACCT_FLAGS]));
>  
> +		if (!(cmd & NFACCT_FLAG_MARK) &&
> +		     (tb[NFACCT_PMARK] || tb[NFACCT_BMARK]))
> +			return -EINVAL;
> +
>  		if (cmd & NFACCT_FLAG_BTHR &&
>  		    ((flags & NFACCT_FLAG_BTHR && !tb[NFACCT_BTHR]) ||
>  		     (!(flags & NFACCT_FLAG_BTHR) && tb[NFACCT_BTHR])))
> @@ -114,6 +120,25 @@ nfnl_acct_new(struct sock *nfnl, struct sk_buff *skb,
>  				matching->fmt =
>  				be16_to_cpu(nla_get_be16(tb[NFACCT_FMT]));
>  			}
> +			/* ...then set the mark flag... */
> +			if (cmd & NFACCT_FLAG_MARK) {
> +				if (flags & NFACCT_FLAG_MARK) {
> +					matching->pmark = tb[NFACCT_PMARK] ?
> +					be64_to_cpu(
> +					  nla_get_be64(tb[NFACCT_PMARK])) :
> +					atomic64_read(&matching->pkts);
> +
> +					matching->bmark = tb[NFACCT_BMARK] ?
> +					be64_to_cpu(
> +					  nla_get_be64(tb[NFACCT_BMARK])) :
> +					atomic64_read(&matching->bytes);
> +					matching->flags |= NFACCT_FLAG_MARK;
> +				} else {
> +					matching->pmark = 0;
> +					matching->bmark = 0;
> +					matching->flags &= ~NFACCT_FLAG_MARK;
> +				}
> +			}
>  			/* ... and finally set the bytes threshold */
>  			if (cmd & NFACCT_FLAG_BTHR) {
>  				if (flags & NFACCT_FLAG_BTHR) {
> @@ -147,6 +172,16 @@ nfnl_acct_new(struct sock *nfnl, struct sk_buff *skb,
>  	if (tb[NFACCT_FMT]) {
>  		nfacct->fmt = be16_to_cpu(nla_get_be16(tb[NFACCT_FMT]));
>  	}
> +	if (cmd & NFACCT_FLAG_MARK && flags & NFACCT_FLAG_MARK) {
> +		if (tb[NFACCT_PMARK])
> +			nfacct->pmark = be64_to_cpu(
> +				nla_get_be64(tb[NFACCT_PMARK]));
> +		if (tb[NFACCT_BMARK])
> +			nfacct->bmark = be64_to_cpu(
> +				nla_get_be64(tb[NFACCT_BMARK]));
> +
> +		nfacct->flags |= NFACCT_FLAG_MARK;
> +	}
>  	if (cmd & NFACCT_FLAG_BTHR && flags & NFACCT_FLAG_BTHR) {
>  		if (tb[NFACCT_BTHR])
>  			nfacct->bthr = be64_to_cpu(
> @@ -184,15 +219,28 @@ nfnl_acct_fill_info(struct sk_buff *skb, u32 portid, u32 seq, u32 type,
>  	if (type == NFNL_MSG_ACCT_GET_CTRZERO) {
>  		pkts = atomic64_xchg(&acct->pkts, 0);
>  		bytes = atomic64_xchg(&acct->bytes, 0);
> +		acct->pmark = 0;
> +		acct->bmark = 0;
>  	} else {
>  		pkts = atomic64_read(&acct->pkts);
>  		bytes = atomic64_read(&acct->bytes);
> +		if (type == NFNL_MSG_ACCT_GET_SETMARK) {
> +			acct->pmark = pkts;
> +			acct->bmark = bytes;
> +			acct->flags |= NFACCT_FLAG_MARK;
> +		} else if (type == NFNL_MSG_ACCT_GET_CLRMARK) {
> +			acct->pmark = 0;
> +			acct->bmark = 0;
> +			acct->flags &= ~NFACCT_FLAG_MARK;
> +		}
>  	}
>  	if (nla_put_be64(skb, NFACCT_PKTS, cpu_to_be64(pkts)) ||
>  	    nla_put_be64(skb, NFACCT_BYTES, cpu_to_be64(bytes)) ||
>  	    nla_put_be64(skb, NFACCT_BTHR, cpu_to_be64(acct->bthr)) ||
>  	    nla_put_be16(skb, NFACCT_FMT, htons(acct->fmt)) ||
>  	    nla_put_be16(skb, NFACCT_FLAGS, htons(acct->flags)) ||
> +	    nla_put_be64(skb, NFACCT_PMARK, cpu_to_be64(acct->pmark)) ||
> +	    nla_put_be64(skb, NFACCT_BMARK, cpu_to_be64(acct->bmark)) ||
>  	    nla_put_be32(skb, NFACCT_USE, htonl(atomic_read(&acct->refcnt))))
>  		goto nla_put_failure;
>  
> @@ -344,6 +392,8 @@ static const struct nla_policy nfnl_acct_policy[NFACCT_MAX+1] = {
>  	[NFACCT_FMT] = { .type = NLA_U16 },
>  	[NFACCT_FLAGS] = { .type = NLA_U16 },
>  	[NFACCT_CMD] = { .type = NLA_U16 },
> +	[NFACCT_PMARK] = { .type = NLA_U64 },
> +	[NFACCT_BMARK] = { .type = NLA_U64 },
>  };
>  
>  static const struct nfnl_callback nfnl_acct_cb[NFNL_MSG_ACCT_MAX] = {
> @@ -359,6 +409,12 @@ static const struct nfnl_callback nfnl_acct_cb[NFNL_MSG_ACCT_MAX] = {
>  	[NFNL_MSG_ACCT_DEL]		= { .call = nfnl_acct_del,
>  					    .attr_count = NFACCT_MAX,
>  					    .policy = nfnl_acct_policy },
> +	[NFNL_MSG_ACCT_GET_SETMARK] 	= { .call = nfnl_acct_get,
> +					    .attr_count = NFACCT_MAX,
> +					    .policy = nfnl_acct_policy },
> +	[NFNL_MSG_ACCT_GET_CLRMARK] 	= { .call = nfnl_acct_get,
> +					    .attr_count = NFACCT_MAX,
> +					    .policy = nfnl_acct_policy },
>  };
>  
>  static const struct nfnetlink_subsystem nfnl_acct_subsys = {
> -- 
> 1.8.3.1
> 
