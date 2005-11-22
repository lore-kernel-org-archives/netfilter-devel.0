From: Krzysztof Oledzki <olenf@ans.pl>
Subject: Re: [PATCH] CTA_PROTO_NUM is u_int8_t not u_int16_t (was Re:
 CTA_PROTO_NUM u_int8_t or u_int16_t)
Date: Tue, 22 Nov 2005 21:29:51 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0511222103050.9114@bizon.gios.gov.pl>
References: <Pine.LNX.4.64.0511211534580.30476@bizon.gios.gov.pl>
	<4381DF77.2030704@eurodev.net> <4381FDF8.6030508@trash.net>
	<43820874.2050708@eurodev.net> <4382A19D.9090201@trash.net>
	<43836BAF.2050501@eurodev.net>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-187430788-568877046-1132691391=:9114"
Cc: Harald Welte <laforge@netfilter.org>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Pablo Neira <pablo@eurodev.net>
In-Reply-To: <43836BAF.2050501@eurodev.net>
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

---187430788-568877046-1132691391=:9114
Content-Type: TEXT/PLAIN; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE



On Tue, 22 Nov 2005, Pablo Neira wrote:

> Patrick McHardy wrote:
>> Pablo Neira wrote:
>>
>>> Patrick McHardy wrote:
>>>
>>>> If you have to break compatibility, please do it before 2.6.15 is
>>>> released. But the easiest solution looks like keeping it a u_int16_t
>>>> and adjusting the NFA_PUT.
>>>
>>> I think that I can fix it in nf_conntrack_netlink. ip_conntrack_netlink
>>> will go sooner or later.
>>
>> I'm not sure that will be an avantage to breaking it immediately.
>> People should be able to use ctnetlink application with nfctnetlink,
>> so it will still break, but at that point the interface will already
>> be more established. We could just leave it a u_int16_t, but it won't
>> be in network byte order as the other attributes, which IMO needs to
>> be fixed if we ever want to use ctnetlink over the network without
>> adding lots of code in userspace just to fix up this single field.
>
> Better to fix it, break backward compatibility now and forget about this
> issue.

Isn't it possible to add kernel version checking into=20
libnetfilter_conntrack and send CTA_PROTO_NUM as u_int16_t under 2.6.14=20
and as u_int8_t under 2.6.15+? The protonum is alredy defined as u_int8_t=
=20
in struct nfct_tuple (libnetfilter_conntrack.h).

> Patch attached. Thanks for the feedback Patrick.

What about ip_conntrack_old_tuple struct from=20
include/linux/netfilter_ipv4/ipt_conntrack.h:

/* This is exposed to userspace, so remains frozen in time. */
struct ip_conntrack_old_tuple
{
         struct {
                 __u32 ip;
                 union {
                         __u16 all;
                 } u;
         } src;

         struct {
                 __u32 ip;
                 union {
                         __u16 all;
                 } u;

                 /* The protocol. */
                 u16 protonum;
         } dst;
};


Best regards,

 =09=09=09Krzysztof Ol=EAdzki
---187430788-568877046-1132691391=:9114--
