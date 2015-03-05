From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 2/3] netfilter: nf_tables: check for overflow of rule
 dlen field
Date: Thu, 5 Mar 2015 17:31:27 +0100
Message-ID: <20150305163127.GA6878@salvia>
References: <1425413060-6187-1-git-send-email-kaber@trash.net>
 <1425413060-6187-3-git-send-email-kaber@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:49908 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751256AbbCEQ1s (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 5 Mar 2015 11:27:48 -0500
Content-Disposition: inline
In-Reply-To: <1425413060-6187-3-git-send-email-kaber@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Mar 03, 2015 at 08:04:19PM +0000, Patrick McHardy wrote:
> Check that the space required for the expressions doesn't exceed the
> size of the dlen field, which would lead to the iterators crashing.
> 
> Signed-off-by: Patrick McHardy <kaber@trash.net>
> ---
>  net/netfilter/nf_tables_api.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
> index 6fb532b..7baafd5 100644
> --- a/net/netfilter/nf_tables_api.c
> +++ b/net/netfilter/nf_tables_api.c
> @@ -1968,6 +1968,10 @@ static int nf_tables_newrule(struct sock *nlsk, struct sk_buff *skb,
>  			n++;
>  		}
>  	}
> +	/* Check for overflow of dlen field */
> +	err = -EFBIG;

Should we use -EOVERFLOW instead as we use in other nf_tables spots?

The error in userspace will be: "Value too large for defined data type".

> +	if (size >= 1 << 12)
> +		goto err1;
>  
>  	if (nla[NFTA_RULE_USERDATA])
>  		ulen = nla_len(nla[NFTA_RULE_USERDATA]);
> -- 
> 2.1.0
> 
