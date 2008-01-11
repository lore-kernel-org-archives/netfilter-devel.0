From: Patrick McHardy <kaber@trash.net>
Subject: Re: conntrack doesn't always work when a bridge is used
Date: Fri, 11 Jan 2008 18:33:52 +0100
Message-ID: <4787A880.4020405@trash.net>
References: <9a4a382a0712180648i7fc958edt6f0d9db83f574c77@mail.gmail.com>	 <476CC345.7050108@trash.net>	 <9a4a382a0712260154l5f0773fy1d2da6cc94a780c6@mail.gmail.com>	 <4777DB2F.4010307@trash.net>	 <9a4a382a0801020118n4166e505l5eb84a9f07f620be@mail.gmail.com>	 <9a4a382a0801110010h3b4ed334sb53392ab564c00b5@mail.gmail.com>	 <47876013.2040405@trash.net>	 <9a4a382a0801110453m66b42329w15c6ae3b68d37699@mail.gmail.com>	 <478767A7.9000807@trash.net> <47876E4A.2010608@trash.net> <9a4a382a0801110716g206f0719o9f067fd7d7baeda5@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-net@vger.kernel.org, netfilter-devel@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>
To: =?ISO-8859-15?Q?Damien_Th=E9bault?= <damien.thebault@gmail.com>
Return-path: <linux-net-owner@vger.kernel.org>
In-Reply-To: <9a4a382a0801110716g206f0719o9f067fd7d7baeda5@mail.gmail.com>
Sender: linux-net-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Damien Th=E9bault wrote:
>> diff --git a/net/bridge/br_netfilter.c b/net/bridge/br_netfilter.c
>> index c1757c7..362fe89 100644
>> --- a/net/bridge/br_netfilter.c
>> +++ b/net/bridge/br_netfilter.c
>> @@ -285,12 +285,17 @@ static int br_nf_pre_routing_finish_bridge(str=
uct sk_buff *skb)
>>         skb->nf_bridge->mask ^=3D BRNF_NF_BRIDGE_PREROUTING;
>>
>>         skb->dev =3D bridge_parent(skb->dev);
>> -       if (!skb->dev)
>> -               kfree_skb(skb);
>> -       else {
>> +       if (skb->dev) {
>> +               struct dst_entry *dst =3D skb->dst;
>> +
>>                 nf_bridge_pull_encap_header(skb);
>> -               skb->dst->output(skb);
>> +
>> +               if (dst->hh)
>> +                       return neigh_hh_output(dst->hh, skb);
>> +               else if (dst->neighbour)
>> +                       return dst->neighbour->output(skb);
>>         }
>> +       kfree_skb(skb);
>>         return 0;
>>  }
>>
>>
>>
>=20
> I confirm that this patch solves the problem with this setup, thanks!

Thanks a lot for testing and providing all the data.

> Does this mean that without this patch, DNAT doesn't work (correctly)
> on a bridge?

DNAT itself works, but the incorrect POSTROUTING hook invocation
can break other things like packet mangling by NAT helpers.
