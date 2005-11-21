From: Krzysztof Oledzki <olenf@ans.pl>
Subject: Re: CTA_PROTO_NUM u_int8_t or u_int16_t
Date: Mon, 21 Nov 2005 22:26:43 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0511212224270.13610@bizon.gios.gov.pl>
References: <Pine.LNX.4.64.0511211534580.30476@bizon.gios.gov.pl>
	<4381DF77.2030704@eurodev.net> <4381FDF8.6030508@trash.net>
	<43820874.2050708@eurodev.net>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED;
	BOUNDARY="-187430788-1501828360-1132608403=:13610"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Pablo Neira <pablo@eurodev.net>
In-Reply-To: <43820874.2050708@eurodev.net>
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

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---187430788-1501828360-1132608403=:13610
Content-Type: TEXT/PLAIN; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE



On Mon, 21 Nov 2005, Pablo Neira wrote:

> Patrick McHardy wrote:
>> Pablo Neira wrote:
>>
>>> Krzysztof Oledzki wrote:
>>>
>>>> AFAIK ip proto is u8 but I found that it is represented as u16 and use=
d
>>>> both as u_int16_t and u_int8_t:
>>>>
>>>> include/linux/netfilter_ipv4/ipt_conntrack.h:           u16 protonum;
>>>>
>>>> net/ipv4/netfilter/ip_conntrack_netlink.c:      NFA_PUT(skb,
>>>> CTA_PROTO_NUM, sizeof(u_int8_t), &tuple->dst.protonum);
>>>> net/ipv4/netfilter/ip_conntrack_netlink.c:
>>>> [CTA_PROTO_NUM-1]      =3D sizeof(u_int16_t),
>>>> net/ipv4/netfilter/ip_conntrack_netlink.c:      tuple->dst.protonum =
=3D
>>>> *(u_int16_t *)NFA_DATA(tb[CTA_PROTO_NUM-1]);
>>>>
>>>> Was this intentionally?
>>>
>>>
>>> No :(, it has slipped through at some stage. I was aware of that, I
>>> found it some days ago. The problem is that if we fix that we could
>>> break backward compatibility for 2.6.14, so I'm still thinking about ho=
w
>>> to fix it.
>>
>> If you have to break compatibility, please do it before 2.6.15 is
>> released. But the easiest solution looks like keeping it a u_int16_t
>> and adjusting the NFA_PUT.
>
> I think that I can fix it in nf_conntrack_netlink. ip_conntrack_netlink
> will go sooner or later.

Fair enough. But what if we find similar problem later, this time in=20
nf_conntrack_netlink? ;)

Best regards,

 =09=09=09=09Krzysztof Ol=EAdzki
---187430788-1501828360-1132608403=:13610--
