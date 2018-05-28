From: Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
Subject: Re: [PATCH net-next v16 5/8] sch_cake: Add NAT awareness to packet classifier
Date: Tue, 29 May 2018 00:19:18 +0200
Message-ID: <878t83tod5.fsf@toke.dk>
References: <152751762093.30935.15398977119837536494.stgit@alrua-kau> <152751766690.30935.18178441475189968162.stgit@alrua-kau> <20180528195101.7mceghxngz5jhawa@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Cc: netdev@vger.kernel.org, cake@lists.bufferbloat.net,
        netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180528195101.7mceghxngz5jhawa@salvia>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Pablo Neira Ayuso <pablo@netfilter.org> writes:

> On Mon, May 28, 2018 at 04:27:46PM +0200, Toke H=C3=B8iland-J=C3=B8rgense=
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
>>  net/sched/sch_cake.c |   46 +++++++++++++++++++++++++++++++++++++++++++=
+++
>>  1 file changed, 46 insertions(+)
>>=20
>> diff --git a/net/sched/sch_cake.c b/net/sched/sch_cake.c
>> index 68ac908470f1..fecd9caac0cc 100644
>> --- a/net/sched/sch_cake.c
>> +++ b/net/sched/sch_cake.c
>> @@ -71,6 +71,10 @@
>>  #include <net/tcp.h>
>>  #include <net/flow_dissector.h>
>>=20=20
>> +#if IS_ENABLED(CONFIG_NF_CONNTRACK)
>> +#include <net/netfilter/nf_conntrack_core.h>
>> +#endif
>> +
>>  #define CAKE_SET_WAYS (8)
>>  #define CAKE_MAX_TINS (8)
>>  #define CAKE_QUEUES (1024)
>> @@ -516,6 +520,29 @@ static bool cobalt_should_drop(struct cobalt_vars *=
vars,
>>  	return drop;
>>  }
>>=20=20
>> +static void cake_update_flowkeys(struct flow_keys *keys,
>> +				 const struct sk_buff *skb)
>> +{
>> +#if IS_ENABLED(CONFIG_NF_CONNTRACK)
>
> I would remove the ifdef, not really needed, it will simplify things.
>
> But I leave it to you to decide, this is not I deal breaker.

If I remove it I get a bunch of 'incomplete type' errors when compiling.
Besides, we use it to report an error to userspace when conntrack is
disabled anyway, so might as well keep the whole thing ifdef'ed.

-Toke
