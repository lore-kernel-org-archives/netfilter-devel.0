From: Nikolay Borisov <kernel@kyup.com>
Subject: Re: [PATCH] netfilter: ipv4: fix NULL dereference
Date: Thu, 24 Mar 2016 10:45:24 +0200
Message-ID: <56F3A924.2000100@kyup.com>
References: <1458743250-4003-1-git-send-email-zlpwmdx@163.com>
 <56F39E82.4090902@kyup.com>
 <54382a12.8a92.153a7ba19ff.Coremail.zlpwmdx@163.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=gbk
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org, pablo@netfilter.org,
	kaber@trash.net, davem@davemloft.net,
	Liping Zhang <liping.zhang@spreadtrum.com>
To: =?UTF-8?B?5byg5p2O5bmz?= <zlpwmdx@163.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f47.google.com ([74.125.82.47]:35607 "EHLO
	mail-wm0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752843AbcCXIp2 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 24 Mar 2016 04:45:28 -0400
Received: by mail-wm0-f47.google.com with SMTP id l68so227449986wml.0
        for <netfilter-devel@vger.kernel.org>; Thu, 24 Mar 2016 01:45:26 -0700 (PDT)
In-Reply-To: <54382a12.8a92.153a7ba19ff.Coremail.zlpwmdx@163.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>



On 03/24/2016 10:25 AM, =D5=C5=C0=EE=C6=BD wrote:
> At 2016-03-24 16:00:02, "Nikolay Borisov" <kernel@kyup.com> wrote:
>> I've been running production kernels in production with those change=
s
>> and so far I haven't observed a single crash resulting from this.
>=20
> Did you run the test with the CONFIG_NET_NS config enabled?

Of course, why else would I author the patches :)

>=20
>=20
>> Furthermore, I  believe that all the call sites of synproxy_build_ip
>> should have the skb associated with a valid tcp socket, which must h=
ave
>=20
>> originated from a particular namespace.
>=20
>=20
> Actually, the sk_buff passed to synproxy_build_ip() are all alloced b=
y
> alloc_skb, and was not associated with a specific tcp socket, so skb-=
>sk=20
> is always NULL. Further more, SYNPROXY target can be used to proxy
> the tcp connections which are not local, i.e. tcp sockets was located=
 on
> other hosts.=20

Admittedly I'm not using the synproxy module so that might explain why =
I
haven't seen crashes.

In any case you can add my:

Reviewed-by: Nikolay Borisov <kernel@kyup.com>

>=20
>=20
>>
>> On 03/23/2016 04:27 PM, Liping Zhang wrote:
>>> From: Liping Zhang <liping.zhang@spreadtrum.com>
>>>
>>> Commit fa50d974d104 ("ipv4: Namespaceify ip_default_ttl sysctl knob=
")
>>> introduce the namespaceify ip_default_ttl, but sk_buff->sk maybe NU=
LL,
>>> so sock_net(skb->sk) will dereference the NULL pointer and oops wil=
l
>>> happen.
>>>
>>> Signed-off-by: Liping Zhang <liping.zhang@spreadtrum.com>
>>> ---
>>>  net/bridge/netfilter/nft_reject_bridge.c |   20 ++++++++++--------=
--
>>>  net/ipv4/netfilter/ipt_SYNPROXY.c        |   16 ++++++++++------
>>>  2 files changed, 20 insertions(+), 16 deletions(-)
>>>
>>> diff --git a/net/bridge/netfilter/nft_reject_bridge.c b/net/bridge/=
netfilter/nft_reject_bridge.c
>>> index adc8d72..77f7e7a 100644
>>> --- a/net/bridge/netfilter/nft_reject_bridge.c
>>> +++ b/net/bridge/netfilter/nft_reject_bridge.c
>>> @@ -40,7 +40,8 @@ static void nft_reject_br_push_etherhdr(struct sk=
_buff *oldskb,
>>>  /* We cannot use oldskb->dev, it can be either bridge device (NF_B=
RIDGE INPUT)
>>>   * or the bridge port (NF_BRIDGE PREROUTING).
>>>   */
>>> -static void nft_reject_br_send_v4_tcp_reset(struct sk_buff *oldskb=
,
>>> +static void nft_reject_br_send_v4_tcp_reset(struct net *net,
>>> +					    struct sk_buff *oldskb,
>>>  					    const struct net_device *dev,
>>>  					    int hook)
>>>  {
>>> @@ -48,7 +49,6 @@ static void nft_reject_br_send_v4_tcp_reset(struc=
t sk_buff *oldskb,
>>>  	struct iphdr *niph;
>>>  	const struct tcphdr *oth;
>>>  	struct tcphdr _oth;
>>> -	struct net *net =3D sock_net(oldskb->sk);
>>> =20
>>>  	if (!nft_bridge_iphdr_validate(oldskb))
>>>  		return;
>>> @@ -75,7 +75,8 @@ static void nft_reject_br_send_v4_tcp_reset(struc=
t sk_buff *oldskb,
>>>  	br_deliver(br_port_get_rcu(dev), nskb);
>>>  }
>>> =20
>>> -static void nft_reject_br_send_v4_unreach(struct sk_buff *oldskb,
>>> +static void nft_reject_br_send_v4_unreach(struct net *net,
>>> +					  struct sk_buff *oldskb,
>>>  					  const struct net_device *dev,
>>>  					  int hook, u8 code)
>>>  {
>>> @@ -86,7 +87,6 @@ static void nft_reject_br_send_v4_unreach(struct =
sk_buff *oldskb,
>>>  	void *payload;
>>>  	__wsum csum;
>>>  	u8 proto;
>>> -	struct net *net =3D sock_net(oldskb->sk);
>>> =20
>>>  	if (oldskb->csum_bad || !nft_bridge_iphdr_validate(oldskb))
>>>  		return;
>>> @@ -273,17 +273,17 @@ static void nft_reject_bridge_eval(const stru=
ct nft_expr *expr,
>>>  	case htons(ETH_P_IP):
>>>  		switch (priv->type) {
>>>  		case NFT_REJECT_ICMP_UNREACH:
>>> -			nft_reject_br_send_v4_unreach(pkt->skb, pkt->in,
>>> -						      pkt->hook,
>>> +			nft_reject_br_send_v4_unreach(pkt->net, pkt->skb,
>>> +						      pkt->in, pkt->hook,
>>>  						      priv->icmp_code);
>>>  			break;
>>>  		case NFT_REJECT_TCP_RST:
>>> -			nft_reject_br_send_v4_tcp_reset(pkt->skb, pkt->in,
>>> -							pkt->hook);
>>> +			nft_reject_br_send_v4_tcp_reset(pkt->net, pkt->skb,
>>> +							pkt->in, pkt->hook);
>>>  			break;
>>>  		case NFT_REJECT_ICMPX_UNREACH:
>>> -			nft_reject_br_send_v4_unreach(pkt->skb, pkt->in,
>>> -						      pkt->hook,
>>> +			nft_reject_br_send_v4_unreach(pkt->net, pkt->skb,
>>> +						      pkt->in, pkt->hook,
>>>  						      nft_reject_icmp_code(priv->icmp_code));
>>>  			break;
>>>  		}
>>> diff --git a/net/ipv4/netfilter/ipt_SYNPROXY.c b/net/ipv4/netfilter=
/ipt_SYNPROXY.c
>>> index 7b8fbb3..6b4f501 100644
>>> --- a/net/ipv4/netfilter/ipt_SYNPROXY.c
>>> +++ b/net/ipv4/netfilter/ipt_SYNPROXY.c
>>> @@ -18,10 +18,10 @@
>>>  #include <net/netfilter/nf_conntrack_synproxy.h>
>>> =20
>>>  static struct iphdr *
>>> -synproxy_build_ip(struct sk_buff *skb, __be32 saddr, __be32 daddr)
>>> +synproxy_build_ip(struct net *net, struct sk_buff *skb, __be32 sad=
dr,
>>> +		  __be32 daddr)
>>>  {
>>>  	struct iphdr *iph;
>>> -	struct net *net =3D sock_net(skb->sk);
>>> =20
>>>  	skb_reset_network_header(skb);
>>>  	iph =3D (struct iphdr *)skb_put(skb, sizeof(*iph));
>>> @@ -91,7 +91,8 @@ synproxy_send_client_synack(const struct synproxy=
_net *snet,
>>>  		return;
>>>  	skb_reserve(nskb, MAX_TCP_HEADER);
>>> =20
>>> -	niph =3D synproxy_build_ip(nskb, iph->daddr, iph->saddr);
>>> +	niph =3D synproxy_build_ip(nf_ct_net(snet->tmpl), nskb, iph->dadd=
r,
>>> +				 iph->saddr);
>>> =20
>>>  	skb_reset_transport_header(nskb);
>>>  	nth =3D (struct tcphdr *)skb_put(nskb, tcp_hdr_size);
>>> @@ -132,7 +133,8 @@ synproxy_send_server_syn(const struct synproxy_=
net *snet,
>>>  		return;
>>>  	skb_reserve(nskb, MAX_TCP_HEADER);
>>> =20
>>> -	niph =3D synproxy_build_ip(nskb, iph->saddr, iph->daddr);
>>> +	niph =3D synproxy_build_ip(nf_ct_net(snet->tmpl), nskb, iph->sadd=
r,
>>> +				 iph->daddr);
>>> =20
>>>  	skb_reset_transport_header(nskb);
>>>  	nth =3D (struct tcphdr *)skb_put(nskb, tcp_hdr_size);
>>> @@ -177,7 +179,8 @@ synproxy_send_server_ack(const struct synproxy_=
net *snet,
>>>  		return;
>>>  	skb_reserve(nskb, MAX_TCP_HEADER);
>>> =20
>>> -	niph =3D synproxy_build_ip(nskb, iph->daddr, iph->saddr);
>>> +	niph =3D synproxy_build_ip(nf_ct_net(snet->tmpl), nskb, iph->dadd=
r,
>>> +				 iph->saddr);
>>> =20
>>>  	skb_reset_transport_header(nskb);
>>>  	nth =3D (struct tcphdr *)skb_put(nskb, tcp_hdr_size);
>>> @@ -215,7 +218,8 @@ synproxy_send_client_ack(const struct synproxy_=
net *snet,
>>>  		return;
>>>  	skb_reserve(nskb, MAX_TCP_HEADER);
>>> =20
>>> -	niph =3D synproxy_build_ip(nskb, iph->saddr, iph->daddr);
>>> +	niph =3D synproxy_build_ip(nf_ct_net(snet->tmpl), nskb, iph->sadd=
r,
>>> +				 iph->daddr);
>>> =20
>>>  	skb_reset_transport_header(nskb);
>>>  	nth =3D (struct tcphdr *)skb_put(nskb, tcp_hdr_size);
>>>
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
