From: Patrick McHardy <kaber@trash.net>
Subject: Re: xt_u32 20070605 (kernel)
Date: Tue, 05 Jun 2007 13:40:32 +0200
Message-ID: <46654BB0.4060201@trash.net>
References: <Pine.LNX.4.61.0706051311220.20829@yvahk01.tjqt.qr>
	<Pine.LNX.4.61.0706051312370.20829@yvahk01.tjqt.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable
Cc: Netfilter Developer Mailing List <netfilter-devel@lists.netfilter.org>
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <Pine.LNX.4.61.0706051312370.20829@yvahk01.tjqt.qr>
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

Jan Engelhardt wrote:
> Subject: Add the U32 match from POM-NG
>=20
> Along comes... xt_u32, a revamped ipt_u32 from POM-NG,
> Plus:
>=20
>     *	2007-06-02: added ipv6 support
>=20
>     *	2007-06-05: uses kmalloc for the big buffer
>=20
>     *   2007-06-05: added inversion

Mosty fine, but:

> +struct xt_u32_location_element {
> +	uint32_t number;
> +	uint8_t nextop;
> +};

u_intXX_t

> +
> +struct xt_u32_value_element {
> +	uint32_t min, max;

u_int32_t min
u_int32_t max

> +};
> +
> +/*
> + * Any way to allow for an arbitrary number of elements?
> + * For now, I settle with a limit of 10 each.
> + */
> +#define XT_U32_MAXSIZE 10
> +
> +struct xt_u32_test {
> +	struct xt_u32_location_element location[XT_U32_MAXSIZE+1];
> +	struct xt_u32_value_element value[XT_U32_MAXSIZE+1];
> +	uint8_t nnums, nvalues;

same here .. and everywhere else

> +};
> +
> +struct xt_u32 {
> +	struct xt_u32_test tests[XT_U32_MAXSIZE+1];
> +	uint8_t ntests, invert;
> +};
> +
> +#endif /* _XT_U32_H */

> +++ linux-2.6.22-rc4/net/netfilter/xt_u32.c
> @@ -0,0 +1,151 @@
> +/*
> + *	xt_u32 - kernel module to match u32 packet content
> + *
> + *	Original author: Don Cohen <don@isis.cs3-inc.com>
> + *	=A9 Jan Engelhardt <jengelh@gmx.de>, 2007
> + */
> +
> +#include <linux/module.h>
> +#include <linux/moduleparam.h>
> +#include <linux/spinlock.h>
> +#include <linux/skbuff.h>
> +#include <linux/types.h>
> +#include <linux/netfilter/x_tables.h>
> +#include <linux/netfilter/xt_u32.h>
> +
> +/* This is slow, but it's simple. --RR */
> +
> +static DEFINE_SPINLOCK(xt_u32_lock);
> +static unsigned int xt_u32_buffer_size =3D 64 * 1024;

#define maybe

> +static char *xt_u32_buffer;
> +
> +static bool xt_u32_match_it(const struct xt_u32 *data,
> +			    const struct sk_buff *skb)
> +{
> +	const struct xt_u32_test *ct;
> +	const unsigned char *base;
> +	const unsigned char *head;
> +	unsigned int testind;
> +	unsigned int nnums;
> +	unsigned int nvals;
> +	unsigned int i;
> +	u_int32_t pos;
> +	u_int32_t val;
> +	u_int32_t at;
> +
> +	base =3D head =3D skb_header_pointer(skb, 0, skb->len, xt_u32_buffer)=
;
> +	BUG_ON(head =3D=3D NULL);
> +
> +	/*
> +	 * Small example: "0 >> 28 =3D=3D 4 && 8 & 0xFF0000 >> 16 =3D 6, 17"
> +	 * (=3DIPv4 and (TCP or UDP)). Outer loop runs over the "&&" operands=
.
> +	 */
> +	for (testind =3D 0; testind < data->ntests; ++testind) {
> +		ct  =3D &data->tests[testind];
> +		at  =3D 0;
> +		pos =3D ct->location[0].number;
> +
> +		if (at + pos + 3 > skb->len || at + pos < 0)
> +			return false;

inversion?

> +
> +		val =3D (base[pos] << 24) | (base[pos+1] << 16) |
> +		      (base[pos+2] << 8) | base[pos+3];
> +		nnums =3D ct->nnums;
> +
> +		/* Inner loop runs over "&", "<<", ">>" and "@" operands */
> +		for (i =3D 1; i < nnums; ++i) {
> +			u_int32_t number =3D ct->location[i].number;
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
> +				if (at + pos + 3 > skb->len || at + pos < 0)
> +					return false;
> +
> +				val =3D (base[at+pos] << 24) |
> +				      (base[at+pos+1] << 16) |
> +				      (base[at+pos+2] << 8) | base[at+pos+3];
> +				break;
> +			}
> +		}
> +
> +		/* Run over the "," and ":" operands */
> +		nvals =3D ct->nvalues;
> +		for (i =3D 0; i < nvals; ++i)
> +			if (ct->value[i].min <=3D val && val <=3D ct->value[i].max)
> +				break;

inversion?

> +
> +		if (i >=3D ct->nvalues)
> +			return false;
> +	}
> +
> +	return true;
> +}
> +
> +static bool xt_u32_match(const struct sk_buff *skb,
> +			 const struct net_device *in,
> +			 const struct net_device *out,
> +			 const struct xt_match *match, const void *matchinfo,
> +			 int offset, unsigned int protoff, bool *hotdrop)
> +{
> +	const struct xt_u32 *data =3D matchinfo;
> +	bool ret;
> +
> +	spin_lock_bh(&xt_u32_lock);
> +	ret =3D xt_u32_match_it(data, skb);

Do we really need this wrapper?

> +	spin_unlock_bh(&xt_u32_lock);
> +
> +	return ret ^ data->invert;
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
> +	xt_u32_buffer =3D kmalloc(xt_u32_buffer_size, GFP_KERNEL);
> +	if (xt_u32_buffer =3D=3D NULL)
> +		return -ENOMEM;
> +	return xt_register_matches(xt_u32_reg, ARRAY_SIZE(xt_u32_reg));
> +}
> +
> +static void __exit xt_u32_exit(void)
> +{
> +	xt_unregister_matches(xt_u32_reg, ARRAY_SIZE(xt_u32_reg));
> +	kfree(xt_u32_buffer);
> +	return;

return not needed

> +}
> +
> +module_init(xt_u32_init);
> +module_exit(xt_u32_exit);
> +module_param_named(buffer_size, xt_u32_buffer_size, uint, S_IRUGO);
> +MODULE_PARM_DESC(buffer_size, "Buffer size to hold a packet "
> +	"(default: 65536 bytes)");

No parameter for this. We need 64k.

> +MODULE_AUTHOR("Don Cohen <don@isis.cs3-inc.com>");
> +MODULE_DESCRIPTION("netfilter u32 match module");
> +MODULE_LICENSE("GPL");
> +MODULE_ALIAS("ipt_u32");
> +MODULE_ALIAS("ip6t_u32");
>=20
