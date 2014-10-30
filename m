From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [ebtables-compat PATCH 1/2] nft-shared: rework inversion of
 matches
Date: Thu, 30 Oct 2014 18:07:31 +0100
Message-ID: <20141030170731.GA16844@salvia>
References: <20141028183259.3948.15098.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, giuseppelng@gmail.com
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:41210 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758867AbaJ3RF6 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 30 Oct 2014 13:05:58 -0400
Content-Disposition: inline
In-Reply-To: <20141028183259.3948.15098.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Oct 28, 2014 at 07:32:59PM +0100, Arturo Borrero Gonzalez wrote:
> Previous to this patch, inversion of matches didn't work in ebtables-compat.
>
> A way to solve this is to refactor the logic to calculate the proper NFT_CMP_*
> operation, and let ebtables-compat to use this new logic.
>
> With this patch, rules like this are correctly sent to the kernel:
> ebtables-compat -A FORWARD -p ! 0x0800 -j ACCEPT
>
> Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
> ---
>  iptables/nft-bridge.c |   21 ++++++---------------
>  iptables/nft-shared.c |   44 ++++++++++++++++++--------------------------
>  iptables/nft-shared.h |    1 +
>  3 files changed, 25 insertions(+), 41 deletions(-)
>
[...]
> diff --git a/iptables/nft-shared.c b/iptables/nft-shared.c
> index d6f838c..2e6bf74 100644
> --- a/iptables/nft-shared.c
> +++ b/iptables/nft-shared.c
> @@ -34,6 +34,20 @@ extern struct nft_family_ops nft_family_ops_ipv6;
>  extern struct nft_family_ops nft_family_ops_arp;
>  extern struct nft_family_ops nft_family_ops_bridge;
>
> +uint16_t invflags2cmp_op(uint16_t invflags)
> +{
> +	if ((invflags & XT_INV_PROTO)
> +	    || (invflags & IPT_INV_PROTO)
> +	    || (invflags & IPT_INV_VIA_IN)
> +	    || (invflags & IPT_INV_VIA_OUT)
> +	    || (invflags & IPT_INV_SRCIP)
> +	    || (invflags & IPT_INV_DSTIP)
> +	    || (invflags & IPT_INV_FRAG))

Coding style nitpick:

        if (a ||
            b ||
            c)
                ...

I know iptables doesn't fulfill this in many cases, fixing coding
style there is not worth, but new code should at least try to do it
right.


> +		return NFT_CMP_NEQ;
> +
> +	return NFT_CMP_EQ;
> +}
> +
>  void add_meta(struct nft_rule *r, uint32_t key)
>  {
>  	struct nft_rule_expr *expr;
> @@ -134,15 +148,10 @@ void add_cmp_u32(struct nft_rule *r, uint32_t val, uint32_t op)
>  void add_iniface(struct nft_rule *r, char *iface, int invflags)
>  {
>  	int iface_len;
> -	uint32_t op;
> +	uint32_t op = invflags2cmp_op(invflags);

add_iniface() is used from all families, but note one important thing.
Let's have a look at the inv flag in all families.

In IPv4:

#define IPT_INV_VIA_IN          0x01    /* Invert the sense of IN IFACE. */
#define IPT_INV_VIA_OUT         0x02    /* Invert the sense of OUT IFACE */
#define IPT_INV_TOS             0x04    /* Invert the sense of TOS. */
#define IPT_INV_SRCIP           0x08    /* Invert the sense of SRC IP. */
#define IPT_INV_DSTIP           0x10    /* Invert the sense of DST OP. */
#define IPT_INV_FRAG            0x20    /* Invert the sense of FRAG. */
#define IPT_INV_PROTO           XT_INV_PROTO
#define IPT_INV_MASK            0x7F    /* All possible flag bits mask. */

In IPv6:

#define IP6T_INV_VIA_IN         0x01    /* Invert the sense of IN IFACE. */
#define IP6T_INV_VIA_OUT        0x02    /* Invert the sense of OUT IFACE */
#define IP6T_INV_TOS            0x04    /* Invert the sense of TOS. */
#define IP6T_INV_SRCIP          0x08    /* Invert the sense of SRC IP.*/
#define IP6T_INV_DSTIP          0x10    /* Invert the sense of DST OP.*/
#define IP6T_INV_FRAG           0x20    /* Invert the sense of FRAG.*/
#define IP6T_INV_PROTO          XT_INV_PROTO
#define IP6T_INV_MASK           0x7F    /* All possible flag bits mask. */


OK, the definitions match, good.

Now arp:

#define ARPT_INV_VIA_IN         0x0001  /* Invert the sense of IN IFACE. */
#define ARPT_INV_VIA_OUT        0x0002  /* Invert the sense of OUT IFACE */
#define ARPT_INV_SRCIP          0x0004  /* Invert the sense of SRC IP. */
#define ARPT_INV_TGTIP          0x0008  /* Invert the sense of TGT IP. */
#define ARPT_INV_SRCDEVADDR     0x0010  /* Invert the sense of SRC DEV ADDR. */
#define ARPT_INV_TGTDEVADDR     0x0020  /* Invert the sense of TGT DEV ADDR. */
#define ARPT_INV_ARPOP          0x0040  /* Invert the sense of ARP OP. */
#define ARPT_INV_ARPHRD         0x0080  /* Invert the sense of ARP HRD. */
#define ARPT_INV_ARPPRO         0x0100  /* Invert the sense of ARP PRO. */
#define ARPT_INV_ARPHLN         0x0200  /* Invert the sense of ARP HLN. */
#define ARPT_INV_MASK           0x03FF  /* All possible flag bits mask. */

Now, these don't match with ipv4 and ipv6.

Similar thing with ebtables.

I'm telling this because add_iniface() needs to be generalized to
something like:

void add_iniface(struct nft_rule *r, char *iface, bool neg)
                                                  ^------^

So we check for the specific flag from the nft-FAMILY.c class to
interpret the flags that we received from the parser and then we can
this with neg true or false depending on what we need.

So it's almost this patch, but your invflags2cmp_op() should be
specific for each family. Well, IPv4 and IPv6 overlap, so you can
probably put that function in nft-shared.

Remember that the idea was to keep common IPv4 and IPv6 code in
nft-shared.c

nft.c contains the functions that should be global to all supported
compat families.

Thanks.
