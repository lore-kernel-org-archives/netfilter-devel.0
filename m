From: =?ISO-8859-1?Q?Toke_H=F8iland-J=F8rgensen?= <toke@toke.dk>
Subject: Re: [Cake] [PATCH net-next v14 4/7] sch_cake: Add NAT awareness to packet classifier
Date: Tue, 22 May 2018 10:45:25 +0200
Message-ID: <4333845A-07E7-43C9-9D94-5B050C8599AB@toke.dk>
References: <152693459693.32668.4272129427997495747.stgit@alrua-kau> <152693495866.32668.5164616056948127124.stgit@alrua-kau> <20180521233406.GG26212@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
Cc: netdev@vger.kernel.org, cake@lists.bufferbloat.net,
        netfilter-devel@vger.kernel.org
To: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180521233406.GG26212@localhost.localdomain>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org



On 22 May 2018 01:34:06 CEST, Marcelo Ricardo Leitner <marcelo=2Eleitner@g=
mail=2Ecom> wrote:
>[Cc'ing netfilter-devel@ for awareness]

Thanks! I'll add a Cc in the next version=2E

>On Mon, May 21, 2018 at 10:35:58PM +0200, Toke H=C3=B8iland-J=C3=B8rgense=
n wrote:
>> When CAKE is deployed on a gateway that also performs NAT (which is a
>> common deployment mode), the host fairness mechanism cannot
>distinguish
>> internal hosts from each other, and so fails to work correctly=2E
>>=20
>> To fix this, we add an optional NAT awareness mode, which will query
>the
>> kernel conntrack mechanism to obtain the pre-NAT addresses for each
>packet
>> and use that in the flow and host hashing=2E
>>=20
>> When the shaper is enabled and the host is already performing NAT,
>the cost
>> of this lookup is negligible=2E However, in unlimited mode with no NAT
>being
>> performed, there is a significant CPU cost at higher bandwidths=2E For
>this
>> reason, the feature is turned off by default=2E
>>=20
>> Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@toke=2Edk>
>> ---
>>  net/sched/sch_cake=2Ec |   79
>++++++++++++++++++++++++++++++++++++++++++++++++++
>>  1 file changed, 79 insertions(+)
>>=20
>> diff --git a/net/sched/sch_cake=2Ec b/net/sched/sch_cake=2Ec
>> index 92623160d43e=2E=2E04364993ce19 100644
>> --- a/net/sched/sch_cake=2Ec
>> +++ b/net/sched/sch_cake=2Ec
>> @@ -71,6 +71,12 @@
>>  #include <net/tcp=2Eh>
>>  #include <net/flow_dissector=2Eh>
>> =20
>> +#if IS_REACHABLE(CONFIG_NF_CONNTRACK)
>> +#include <net/netfilter/nf_conntrack_core=2Eh>
>> +#include <net/netfilter/nf_conntrack_zones=2Eh>
>> +#include <net/netfilter/nf_conntrack=2Eh>
>> +#endif
>> +
>>  #define CAKE_SET_WAYS (8)
>>  #define CAKE_MAX_TINS (8)
>>  #define CAKE_QUEUES (1024)
>> @@ -516,6 +522,60 @@ static bool cobalt_should_drop(struct
>cobalt_vars *vars,
>>  	return drop;
>>  }
>> =20
>> +#if IS_REACHABLE(CONFIG_NF_CONNTRACK)
>> +
>> +static void cake_update_flowkeys(struct flow_keys *keys,
>> +				 const struct sk_buff *skb)
>> +{
>> +	const struct nf_conntrack_tuple *tuple;
>> +	enum ip_conntrack_info ctinfo;
>> +	struct nf_conn *ct;
>> +	bool rev =3D false;
>> +
>> +	if (tc_skb_protocol(skb) !=3D htons(ETH_P_IP))
>> +		return;
>> +
>> +	ct =3D nf_ct_get(skb, &ctinfo);
>> +	if (ct) {
>> +		tuple =3D nf_ct_tuple(ct, CTINFO2DIR(ctinfo));
>> +	} else {
>> +		const struct nf_conntrack_tuple_hash *hash;
>> +		struct nf_conntrack_tuple srctuple;
>> +
>> +		if (!nf_ct_get_tuplepr(skb, skb_network_offset(skb),
>> +				       NFPROTO_IPV4, dev_net(skb->dev),
>> +				       &srctuple))
>> +			return;
>> +
>> +		hash =3D nf_conntrack_find_get(dev_net(skb->dev),
>> +					     &nf_ct_zone_dflt,
>> +					     &srctuple);
>> +		if (!hash)
>> +			return;
>> +
>> +		rev =3D true;
>> +		ct =3D nf_ct_tuplehash_to_ctrack(hash);
>> +		tuple =3D nf_ct_tuple(ct, !hash->tuple=2Edst=2Edir);
>> +	}
>> +
>> +	keys->addrs=2Ev4addrs=2Esrc =3D rev ? tuple->dst=2Eu3=2Eip :
>tuple->src=2Eu3=2Eip;
>> +	keys->addrs=2Ev4addrs=2Edst =3D rev ? tuple->src=2Eu3=2Eip :
>tuple->dst=2Eu3=2Eip;
>> +
>> +	if (keys->ports=2Eports) {
>> +		keys->ports=2Esrc =3D rev ? tuple->dst=2Eu=2Eall : tuple->src=2Eu=2E=
all;
>> +		keys->ports=2Edst =3D rev ? tuple->src=2Eu=2Eall : tuple->dst=2Eu=2E=
all;
>> +	}
>> +	if (rev)
>> +		nf_ct_put(ct);
>> +}
>> +#else
>> +static void cake_update_flowkeys(struct flow_keys *keys,
>> +				 const struct sk_buff *skb)
>> +{
>> +	/* There is nothing we can do here without CONNTRACK */
>> +}
>> +#endif
>> +
>>  /* Cake has several subtle multiple bit settings=2E In these cases you
>>   *  would be matching triple isolate mode as well=2E
>>   */
>> @@ -543,6 +603,9 @@ static u32 cake_hash(struct cake_tin_data *q,
>const struct sk_buff *skb,
>>  	skb_flow_dissect_flow_keys(skb, &keys,
>>  				   FLOW_DISSECTOR_F_STOP_AT_FLOW_LABEL);
>> =20
>> +	if (flow_mode & CAKE_FLOW_NAT_FLAG)
>> +		cake_update_flowkeys(&keys, skb);
>> +
>>  	/* flow_hash_from_keys() sorts the addresses by value, so we have
>>  	 * to preserve their order in a separate data structure to treat
>>  	 * src and dst host addresses as independently selectable=2E
>> @@ -1894,6 +1957,18 @@ static int cake_change(struct Qdisc *sch,
>struct nlattr *opt,
>>  	if (err < 0)
>>  		return err;
>> =20
>> +	if (tb[TCA_CAKE_NAT]) {
>> +#if IS_REACHABLE(CONFIG_NF_CONNTRACK)
>> +		q->flow_mode &=3D ~CAKE_FLOW_NAT_FLAG;
>> +		q->flow_mode |=3D CAKE_FLOW_NAT_FLAG *
>> +			!!nla_get_u32(tb[TCA_CAKE_NAT]);
>> +#else
>> +		NL_SET_ERR_MSG_ATTR(extack, "No conntrack support in kernel",
>> +				    tb[TCA_CAKE_NAT]);
>> +		return -EOPNOTSUPP;
>> +#endif
>> +	}
>> +
>>  	if (tb[TCA_CAKE_BASE_RATE64])
>>  		q->rate_bps =3D nla_get_u64(tb[TCA_CAKE_BASE_RATE64]);
>> =20
>> @@ -2066,6 +2141,10 @@ static int cake_dump(struct Qdisc *sch, struct
>sk_buff *skb)
>>  	if (nla_put_u32(skb, TCA_CAKE_ACK_FILTER, q->ack_filter))
>>  		goto nla_put_failure;
>> =20
>> +	if (nla_put_u32(skb, TCA_CAKE_NAT,
>> +			!!(q->flow_mode & CAKE_FLOW_NAT_FLAG)))
>> +		goto nla_put_failure;
>> +
>>  	return nla_nest_end(skb, opts);
>> =20
>>  nla_put_failure:
>>=20
>> _______________________________________________
>> Cake mailing list
>> Cake@lists=2Ebufferbloat=2Enet
>> https://lists=2Ebufferbloat=2Enet/listinfo/cake
