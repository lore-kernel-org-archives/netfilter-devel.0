From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [RFC PATCH nft] src: add support for interface wildcard name
Date: Wed, 16 Oct 2013 12:39:49 +0200
Message-ID: <20131016103949.GA10032@localhost>
References: <1381846993-30093-1-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org,
	Anand Raj Manickam <anandrm@gmail.com>
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:58910 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760286Ab3JPKj7 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 16 Oct 2013 06:39:59 -0400
Content-Disposition: inline
In-Reply-To: <1381846993-30093-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Florian,

On Tue, Oct 15, 2013 at 04:23:13PM +0200, Florian Westphal wrote:
> Uses same syntax as iptables: itfname+.

Good you're bringing up this issue, we've been discussing this for a
while with recent Anand's patch.

> The '+' suffix is not stored on the kernel side; this approach
> is the same as the one used by iptables-nftables.

Hm, it seems current iptables-nftables seems broken by:

73ea1cc nft: convert rule into a command state structure

So let's have a look at the previous handling we had (which is the one
I guess you're refering to):

       ifname_ptr = nft_rule_expr_get(e, NFT_EXPR_CMP_DATA, &len);
       memcpy(ifname, ifname_ptr, len);
       ifname[len] = '\0';

       /* if this is zero, then assume this is a interface */
       if (if_nametoindex(ifname) == 0) {
               ifname[len] = '+';
               ifname[len+1] = '\0';
       }

That if_nametoindex handling was a bit of cheat: if the interface is
gone after adding the rule, it will attach the '+', which is wrong.

> +static void ifname_type_print(const struct expr *expr)
> +{
> +	unsigned int len = div_round_up(expr->len, BITS_PER_BYTE);
> +	char data[len];
> +
> +	mpz_export_data(data, expr->value, BYTEORDER_HOST_ENDIAN, len);
> +	printf("\"%.*s", len, data);
> +	if (len && data[len-1] != '\0')
> +		printf("+"); /* string without nul: interface wildcard match */
> +	printf("\"");
> +}

Your assumption regarding trailing nul looks similar to what I can see
in iptables, let's go that way in iptables-nftables.

> i.e. xtables-save understands 'nft .. meta oifname foo+' and vice versa.
> 
> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
>  Caveats:
>   - I am not convinced '+' is a good idea -- it is ambiguous since
>   'foo+' is a legal interface name.

I think we can remove the '+' in nft, so we match exactly what we
pass for the ifname case, eg. iifname "eth".

OK with this approach?

>   Maybe we should use 'foo/' (Linux forbids / in interface names) instead?
>   - added a new 'itfname' data type since I felt uncomfortable
>     with allowing 'non-nul-terminated' strings.
>   - removes a FIXME in netlink_delinearize.  What was that about? :-}

I don't remember the reason for that case, please try to dig it out
from the history. Thanks!
