From: Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
Subject: Re: [PATCH net-next v15 4/7] sch_cake: Add NAT awareness to packet classifier
Date: Tue, 22 May 2018 16:11:06 +0200
Message-ID: <87k1rvg4qt.fsf@toke.dk>
References: <152699741881.21931.11656377745581563912.stgit@alrua-kau> <152699745846.21931.4558451708304709296.stgit@alrua-kau> <20180522140759.2rl25eggaoaecw4m@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Cc: netdev@vger.kernel.org, cake@lists.bufferbloat.net,
        netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180522140759.2rl25eggaoaecw4m@salvia>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Pablo Neira Ayuso <pablo@netfilter.org> writes:

> Hi Toke,
>
> On Tue, May 22, 2018 at 03:57:38PM +0200, Toke H=C3=B8iland-J=C3=B8rgense=
n wrote:
>> When CAKE is deployed on a gateway that also performs NAT (which is a
>> common deployment mode), the host fairness mechanism cannot distinguish
>> internal hosts from each other, and so fails to work correctly.
>>=20
>> To fix this, we add an optional NAT awareness mode, which will query the
>> kernel conntrack mechanism to obtain the pre-NAT addresses for each pack=
et
>> and use that in the flow and host hashing.
>>=20
>> When the shaper is enabled and the host is already performing NAT, the c=
ost
>> of this lookup is negligible. However, in unlimited mode with no NAT bei=
ng
>> performed, there is a significant CPU cost at higher bandwidths. For this
>> reason, the feature is turned off by default.
>>=20
>> Cc: netfilter-devel@vger.kernel.org
>> Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@toke.dk>
>> ---
>>  net/sched/sch_cake.c |   79 +++++++++++++++++++++++++++++++++++++++++++=
+++++++
>>  1 file changed, 79 insertions(+)
>>=20
>> diff --git a/net/sched/sch_cake.c b/net/sched/sch_cake.c
>> index 68ac908470f1..6f7cae705c84 100644
>> --- a/net/sched/sch_cake.c
>> +++ b/net/sched/sch_cake.c
>> @@ -71,6 +71,12 @@
>>  #include <net/tcp.h>
>>  #include <net/flow_dissector.h>
>>=20=20
>> +#if IS_REACHABLE(CONFIG_NF_CONNTRACK)
>> +#include <net/netfilter/nf_conntrack_core.h>
>> +#include <net/netfilter/nf_conntrack_zones.h>
>> +#include <net/netfilter/nf_conntrack.h>
>> +#endif
>> +
>>  #define CAKE_SET_WAYS (8)
>>  #define CAKE_MAX_TINS (8)
>>  #define CAKE_QUEUES (1024)
>> @@ -516,6 +522,60 @@ static bool cobalt_should_drop(struct cobalt_vars *=
vars,
>>  	return drop;
>>  }
>>=20=20
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
>> +		tuple =3D nf_ct_tuple(ct, !hash->tuple.dst.dir);
>> +	}
>> +
>> +	keys->addrs.v4addrs.src =3D rev ? tuple->dst.u3.ip : tuple->src.u3.ip;
>> +	keys->addrs.v4addrs.dst =3D rev ? tuple->src.u3.ip : tuple->dst.u3.ip;
>> +
>> +	if (keys->ports.ports) {
>> +		keys->ports.src =3D rev ? tuple->dst.u.all : tuple->src.u.all;
>> +		keys->ports.dst =3D rev ? tuple->src.u.all : tuple->dst.u.all;
>> +	}
>> +	if (rev)
>> +		nf_ct_put(ct);
>> +}
>
> This is going to pull in the nf_conntrack module, even if you may not
> want it, as soon as cake is in place.

Yeah, we are aware of that; we get a moddep on nf_conntrack. Our main
deployment scenario has been home routers where conntrack is used
anyway, so this has not been much of an issue. However, if there is a
way to avoid this, and instead detect at runtime if conntrack is
available, that would certainly be useful. Is there? :)

-Toke
