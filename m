From: Philip Craig <philipc@snapgear.com>
Subject: Re: [NETFILTER 42/69]: nf_conntrack: optimize hash_conntrack()
Date: Mon, 28 Apr 2008 18:24:50 +1000
Message-ID: <481589D2.2050901@snapgear.com>
References: <20080130201650.29874.7456.sendpatchset@localhost.localdomain> <20080130201757.29874.54202.sendpatchset@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: davem@davemloft.net, netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from rex.securecomputing.com ([203.24.151.4]:41389 "EHLO
	cyberguard.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754544AbYD1Iwm (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 28 Apr 2008 04:52:42 -0400
In-Reply-To: <20080130201757.29874.54202.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Patrick McHardy wrote:
> [NETFILTER]: nf_conntrack: optimize hash_conntrack()
> 
> Avoid calling jhash three times and hash the entire tuple in one go.

This has broken conntrack on a big endian ARM platform.  'conntrack -L'
shows many unreplied connections all with the same addresses/ports,
instead of just one connection.

It seems the problem is that we are now hashing the padding in struct
nf_conntrack_tuple, which we previously didn't, and this padding isn't
always zeroed, so the hash gives garbage.

Changing NF_CT_TUPLE_U_BLANK() to memset the whole tuple fixes it.

Adding __attribute__ ((packed)) everywhere to remove the padding
didn't seem to fix it, but I don't understand why... maybe I did
something wrong still.  This probably isn't a solution anyway since
these structs are used in userspace?

I'm not sure what's special about big-endian or ARM to only affect
this platform.  Any ideas?

I can work on this more tomorrow.

Here's the pahole output:

struct nf_conntrack_man {
	union nf_inet_addr         u3;                   /*     0    16 */
	union nf_conntrack_man_proto u;                  /*    16     4 */
	u_int16_t                  l3num;                /*    20     2 */

	/* size: 24, cachelines: 1 */
	/* padding: 2 */
	/* last cacheline: 24 bytes */
};	/* definitions: 1 */

struct nf_conntrack_tuple {
	struct nf_conntrack_man    src;                  /*     0    24 */

	/* XXX last struct has 2 bytes of padding */

	struct {
		union nf_inet_addr u3;                   /*    24    16 */
		union {
			__be16     all;                  /*           2 */
			struct {
				__be16 port;             /*    40     2 */
			} tcp;                           /*           4 */
			struct {
				__be16 port;             /*    40     2 */
			} udp;                           /*           4 */
			struct {
				u_int8_t type;           /*    40     1 */
				u_int8_t code;           /*    41     1 */
			} icmp;                          /*           4 */
			struct {
				__be16 port;             /*    40     2 */
			} sctp;                          /*           4 */
			struct {
				__be16 key;              /*    40     2 */
			} gre;                           /*           4 */
		} u;                                     /*    40     4 */
		u_int8_t           protonum;             /*    44     1 */
		u_int8_t           dir;                  /*    45     1 */
	} dst;                                           /*    24    24 */

	/* XXX last struct has 2 bytes of padding */

	/* size: 48, cachelines: 1 */
	/* paddings: 2, sum paddings: 4 */
	/* last cacheline: 48 bytes */
};	/* definitions: 1 */

> 
>   __hash_conntrack | -485 # 760 -> 275, # inlines: 3 -> 1, size inlines: 717 -> 252
>  1 function changed, 485 bytes removed
> 
> Signed-off-by: Patrick McHardy <kaber@trash.net>
> 
> ---
> commit 2f75544ea729329074f86020b4524179cc82c219
> tree e4dc132f189625ad5bd28e043e348f0deb825c47
> parent 18fd2bf273954b4fa527e5d630049f40acc29fca
> author Patrick McHardy <kaber@trash.net> Tue, 29 Jan 2008 16:22:15 +0100
> committer Patrick McHardy <kaber@trash.net> Wed, 30 Jan 2008 21:03:08 +0100
> 
>  net/netfilter/nf_conntrack_core.c |   18 +++++++++++-------
>  1 files changed, 11 insertions(+), 7 deletions(-)
> 
> diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
> index ce4c4ba..24a0863 100644
> --- a/net/netfilter/nf_conntrack_core.c
> +++ b/net/netfilter/nf_conntrack_core.c
> @@ -73,15 +73,19 @@ static unsigned int nf_conntrack_hash_rnd;
>  static u_int32_t __hash_conntrack(const struct nf_conntrack_tuple *tuple,
>  				  unsigned int size, unsigned int rnd)
>  {
> -	unsigned int a, b;
> +	unsigned int n;
> +	u_int32_t h;
>  
> -	a = jhash2(tuple->src.u3.all, ARRAY_SIZE(tuple->src.u3.all),
> -		   (tuple->src.l3num << 16) | tuple->dst.protonum);
> -	b = jhash2(tuple->dst.u3.all, ARRAY_SIZE(tuple->dst.u3.all),
> -		   ((__force __u16)tuple->src.u.all << 16) |
> -		    (__force __u16)tuple->dst.u.all);
> +	/* The direction must be ignored, so we hash everything up to the
> +	 * destination ports (which is a multiple of 4) and treat the last
> +	 * three bytes manually.
> +	 */
> +	n = (sizeof(tuple->src) + sizeof(tuple->dst.u3)) / sizeof(u32);
> +	h = jhash2((u32 *)tuple, n,
> +		   rnd ^ (((__force __u16)tuple->dst.u.all << 16) |
> +		   	  tuple->dst.protonum));
>  
> -	return ((u64)jhash_2words(a, b, rnd) * size) >> 32;
> +	return ((u64)h * size) >> 32;
>  }
>  
>  static inline u_int32_t hash_conntrack(const struct nf_conntrack_tuple *tuple)
