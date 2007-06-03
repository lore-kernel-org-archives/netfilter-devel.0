From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 1/2] xt_u32 (kernel) - match arbitrary bits and bytes
 of a packet
Date: Sun, 03 Jun 2007 19:23:20 +0200
Message-ID: <4662F908.4090401@trash.net>
References: <Pine.LNX.4.61.0706022322340.28357@yvahk01.tjqt.qr>
	<Pine.LNX.4.61.0706022346490.10578@yvahk01.tjqt.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable
Cc: Netfilter Developer Mailing List <netfilter-devel@lists.netfilter.org>
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <Pine.LNX.4.61.0706022346490.10578@yvahk01.tjqt.qr>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

[Please don't flood unrelated mailinglists with netfilter patches,
 this includes the netfilter user list]

Jan Engelhardt wrote:
>     *	added ipv6 support since that seemed dead simple, given u32's
> 	task. I would have even liked to unlock u32 for _all_ protocols,
> 	but .family =3D AF_UNSPEC does not do the right thing right now, =20
> 	but that's not so much a showstopper.
>=20
> 	And arptables seems miles away from using iptables modules. So
> 	AF_INET and AF_INET6 it is for now.


arp_tables doesn't support matches at all.

>=20
>     *	Reduced the buffer size to 17 KB. I think that is quite ok since
> 	I added an overflow check,  SHOULD THERE BE ANY device with an =20
> 	MTU larger than our loopback masterpiece (16436 bytes).
>=20
> 	Are there such devices that support Megasuperjumboframes?
> 	The previous buffer size of 64 KB was probably the cutting edge,
> 	as a single IPv4 fragment/packet does not support more than that
> 	anyway.

Think of TSO.

>=20
>=20
> Signed-off-by: Jan Engelhardt <jengelh@gmx.de>
>=20
> ---
>  include/linux/netfilter/xt_u32.h |   37 ++++++
>  net/netfilter/Kconfig            |   13 ++
>  net/netfilter/Makefile           |    1=20
>  net/netfilter/xt_u32.c           |  234 ++++++++++++++++++++++++++++++=
+++++++++
>  4 files changed, 285 insertions(+)
>=20
> Index: linux-2.6.22-rc3-git6/include/linux/netfilter/xt_u32.h
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- /dev/null
> +++ linux-2.6.22-rc3-git6/include/linux/netfilter/xt_u32.h
> +struct xt_u32_value_element {
> +	uint32_t min, max;

We use u_int32_t in all netfilter files. Also

	u_int32_t min;
	u_int32_t max;

please (and everywhere else of course).

> +#endif /* _XT_U32_H */
> Index: linux-2.6.22-rc3-git6/net/netfilter/Kconfig
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux-2.6.22-rc3-git6.orig/net/netfilter/Kconfig
> +++ linux-2.6.22-rc3-git6/net/netfilter/Kconfig
> @@ -644,6 +644,19 @@ config NETFILTER_XT_MATCH_TCPMSS
> =20
>  	  To compile it as a module, choose M here.  If unsure, say N.
> =20
> +config NETFILTER_XT_MATCH_U32
> +	tristate '"u32" match support'
> +	depends on NETFILTER_XTABLES
> +	---help---
> +	  u32 allows you to extract quantities of up to 4 bytes from a packet=
,
> +	  AND them with specified masks, shift them by specified amounts and
> +	  test whether the results are in any of a set of specified ranges.
> +	  The specification of what to extract is general enough to skip over
> +	  headers with lengths stored in the packet, as in IP or TCP header
> +	  lengths.
> +
> +	  Details and examples are in the kernel module source.

Details and examples belong in the manpage.

> +++ linux-2.6.22-rc3-git6/net/netfilter/xt_u32.c
> @@ -0,0 +1,234 @@
> +/*
> + *	xt_u32 - kernel module to match u32 packet content
> + *
> + *	Original author: Don Cohen <don@isis.cs3-inc.com>
> + *	=A9 Jan Engelhardt <jengelh@gmx.de>, 2007
> + */
> +
> +/*
> +U32 tests whether quantities of up to 4 bytes extracted from a packet
> +have specified values.  The specification of what to extract is genera=
l
> +enough to find data at given offsets from tcp headers or payloads.
> +
> + --u32 tests
> + The argument amounts to a program in a small language described below=
.
> + tests :=3D location =3D value |  tests && location =3D value
> + value :=3D range | value , range
> + range :=3D number | number : number
> +  a single number, n, is interpreted the same as n:n
> +  n:m is interpreted as the range of numbers >=3Dn and <=3Dm
> + location :=3D number | location operator number
> + operator :=3D & | << | >> | @
> +
> + The operators &, <<, >>, && mean the same as in c.  The =3D is really=
 a set
> + membership operator and the value syntax describes a set.  The @ oper=
ator
> + is what allows moving to the next header and is described further bel=
ow.
> +
> + *** Until I can find out how to avoid it, there are some artificial l=
imits
> + on the size of the tests:
> + - no more than 10 =3D's (and 9 &&'s) in the u32 argument
> + - no more than 10 ranges (and 9 commas) per value
> + - no more than 10 numbers (and 9 operators) per location
> +
> + To describe the meaning of location, imagine the following machine th=
at
> + interprets it.  There are three registers:
> +  A is of type char*, initially the address of the IP header
> +  B and C are unsigned 32 bit integers, initially zero
> +
> +  The instructions are:
> +   number	B =3D number;
> +                C =3D (*(A+B)<<24)+(*(A+B+1)<<16)+(*(A+B+2)<<8)+*(A+B+=
3)
> +   &number	C =3D C&number
> +   <<number	C =3D C<<number
> +   >>number	C =3D C>>number
> +   @number	A =3D A+C; then do the instruction number
> +  Any access of memory outside [skb->head,skb->end] causes the match t=
o fail.
> +  Otherwise the result of the computation is the final value of C.
> +
> + Whitespace is allowed but not required in the tests.
> + However the characters that do occur there are likely to require
> + shell quoting, so it's a good idea to enclose the arguments in quotes=
.
> +
> +Example:
> + match IP packets with total length >=3D 256
> + The IP header contains a total length field in bytes 2-3.
> + --u32 "0&0xFFFF=3D0x100:0xFFFF"
> + read bytes 0-3
> + AND that with FFFF (giving bytes 2-3),
> + and test whether that's in the range [0x100:0xFFFF]
> +
> +Example: (more realistic, hence more complicated)
> + match icmp packets with icmp type 0
> + First test that it's an icmp packet, true iff byte 9 (protocol) =3D 1
> + --u32 "6&0xFF=3D1 && ...
> + read bytes 6-9, use & to throw away bytes 6-8 and compare the result =
to 1
> + Next test that it's not a fragment.
> +  (If so it might be part of such a packet but we can't always tell.)
> +  n.b. This test is generally needed if you want to match anything
> +  beyond the IP header.
> + The last 6 bits of byte 6 and all of byte 7 are 0 iff this is a compl=
ete
> + packet (not a fragment).  Alternatively, you can allow first fragment=
s
> + by only testing the last 5 bits of byte 6.
> + ... 4&0x3FFF=3D0 && ...
> + Last test: the first byte past the IP header (the type) is 0
> + This is where we have to use the @syntax.  The length of the IP heade=
r
> + (IHL) in 32 bit words is stored in the right half of byte 0 of the
> + IP header itself.
> + ... 0>>22&0x3C@0>>24=3D0"
> + The first 0 means read bytes 0-3,
> + >>22 means shift that 22 bits to the right.  Shifting 24 bits would g=
ive
> +   the first byte, so only 22 bits is four times that plus a few more =
bits.
> + &3C then eliminates the two extra bits on the right and the first fou=
r
> + bits of the first byte.
> + For instance, if IHL=3D5 then the IP header is 20 (4 x 5) bytes long.
> + In this case bytes 0-1 are (in binary) xxxx0101 yyzzzzzz,
> + >>22 gives the 10 bit value xxxx0101yy and &3C gives 010100.
> + @ means to use this number as a new offset into the packet, and read
> + four bytes starting from there.  This is the first 4 bytes of the icm=
p
> + payload, of which byte 0 is the icmp type.  Therefore we simply shift
> + the value 24 to the right to throw out all but the first byte and com=
pare
> + the result with 0.
> +
> +Example:
> + tcp payload bytes 8-12 is any of 1, 2, 5 or 8
> + First we test that the packet is a tcp packet (similar to icmp).
> + --u32 "6&0xFF=3D6 && ...
> + Next, test that it's not a fragment (same as above).
> + ... 0>>22&0x3C@12>>26&0x3C@8=3D1,2,5,8"
> + 0>>22&3C as above computes the number of bytes in the IP header.
> + @ makes this the new offset into the packet, which is the start of th=
e
> + tcp header.  The length of the tcp header (again in 32 bit words) is
> + the left half of byte 12 of the tcp header.  The 12>>26&3C
> + computes this length in bytes (similar to the IP header before).
> + @ makes this the new offset, which is the start of the tcp payload.
> + Finally 8 reads bytes 8-12 of the payload and =3D checks whether the
> + result is any of 1, 2, 5 or 8
> +*/

Remove all the above up to the copyright please.

> +
> +#include <linux/module.h>
> +#include <linux/spinlock.h>
> +#include <linux/skbuff.h>
> +#include <linux/types.h>
> +#include <linux/netfilter/x_tables.h>
> +#include <linux/netfilter/xt_u32.h>
> +
> +/* This is slow, but it's simple. --RR */
> +
> +/*
> + * I think 17KB should suffice. The largest MTU I have
> + * seen so far is lo's, being 16436. -jengelh
> + */
> +static char xt_u32_buffer[17*1024];


64k and please allocate this.

> +static DEFINE_SPINLOCK(xt_u32_lock);
> +
> +static int xt_u32_match(const struct sk_buff *skb, const struct net_de=
vice *in,
> +			const struct net_device *out,
> +			const struct xt_match *match, const void *matchinfo,
> +			int offset, unsigned int protoff, int *hotdrop)
> +{
> +	const struct xt_u32 *data =3D matchinfo;
> +	const struct xt_u32_test *ct;
> +	const unsigned char *base, *head;
> +	int i, nnums, nvals, testind;
> +	uint32_t pos, val, at;
> +
> +	spin_lock_bh(&xt_u32_lock);
> +
> +	head =3D skb_header_pointer(skb, 0, min(skb->len,
> +	       sizeof(xt_u32_buffer)), xt_u32_buffer);

min can go with 64k buffer.

> +	if (head =3D=3D NULL) {
> +		*hotdrop =3D 1;
> +		return false;
> +	}

might as well BUG_ON since a copy of size <=3D skb->len cant fail.

> +
> +	base =3D head;
> +	for (testind =3D 0; testind < data->ntests; ++testind) {
> +		ct =3D &data->tests[testind];
> +
> +		at  =3D 0;
> +		pos =3D ct->location[0].number;
> +		if (at + pos + 3 > skb->len || at + pos < 0) {
> +			spin_unlock_bh(&xt_u32_lock);
> +			return false;

what about inversion? Matches return int, so please use 0/1
(or send me a patch to convert all of them to boolean first).

> +		}
> +
> +		val =3D (base[pos] << 24) | (base[pos+1] << 16) |
> +		      (base[pos+2] << 8) | base[pos+3];
> +		nnums =3D ct->nnums;
> +
> +		for (i =3D 1; i < nnums; ++i) {
> +			uint32_t number =3D ct->location[i].number;
> +			switch (ct->location[i].nextop) {
> +			case XT_U32_AND:
> +				val &=3D number;
> +				break;
> +			case XT_U32_LEFTSH:
> +				val <<=3D number;
> +				break;
> +			case XT_U32_RIGHTSH:
> +				val >>=3D number;
> +				break;
> +			case XT_U32_AT:
> +				at +=3D val;
> +				pos =3D number;
> +				if (at + pos + 3 > skb->len || at + pos < 0) {
> +					spin_unlock_bh(&xt_u32_lock);
> +					return 0;
> +				}
> +
> +				val =3D (base[at+pos] << 24) |
> +				      (base[at+pos+1] << 16) |
> +				      (base[at+pos+2] << 8) | base[at+pos+3];
> +				break;
> +			}
> +		}
> +
> +		nvals =3D ct->nvalues;
> +		for (i =3D 0; i < nvals; ++i)
> +			if (ct->value[i].min <=3D val && val <=3D ct->value[i].max)
> +				break;
> +
> +		if (i >=3D ct->nvalues) {
> +			spin_unlock_bh(&xt_u32_lock);
> +			return false;
> +		}
> +	}
> +
> +	spin_unlock_bh(&xt_u32_lock);
> +	return 1;
> +}
> +
> +static struct xt_match xt_u32_reg[] =3D {
> +	{
> +		.name       =3D "u32",
> +		.family     =3D AF_INET,
> +		.match      =3D xt_u32_match,
> +		.matchsize  =3D sizeof(struct xt_u32),
> +		.me         =3D THIS_MODULE,
> +	},
> +	{
> +		.name       =3D "u32",
> +		.family     =3D AF_INET6,
> +		.match      =3D xt_u32_match,
> +		.matchsize  =3D sizeof(struct xt_u32),
> +		.me         =3D THIS_MODULE,
> +	},
> +};
> +
> +static int __init xt_u32_init(void)
> +{
> +	return xt_register_matches(xt_u32_reg, ARRAY_SIZE(xt_u32_reg));
> +}
> +
> +static void __exit xt_u32_exit(void)
> +{
> +	xt_unregister_matches(xt_u32_reg, ARRAY_SIZE(xt_u32_reg));
> +	return;
> +}
> +
> +module_init(xt_u32_init);
> +module_exit(xt_u32_exit);
> +MODULE_AUTHOR("Don Cohen <don@isis.cs3-inc.com>");
> +MODULE_DESCRIPTION("netfilter u32 match module");
> +MODULE_LICENSE("GPL");
> +MODULE_ALIAS("ipt_u32");
>=20
