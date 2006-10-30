From: Krzysztof Oledzki <olenf@ans.pl>
Subject: Re: connbytes & 64bit counters (fwd)
Date: Mon, 30 Oct 2006 22:00:33 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0610302159360.7151@bizon.gios.gov.pl>
Mime-Version: 1.0
Content-Type: MULTIPART/Mixed; BOUNDARY="-187430788-695786028-1162238492=:3941"
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-ID: <Pine.LNX.4.64.0610302159361.7151@bizon.gios.gov.pl>
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

---187430788-695786028-1162238492=:3941
Content-Type: TEXT/PLAIN; CHARSET=ISO-8859-2; FORMAT=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Content-ID: <Pine.LNX.4.64.0610302159362.7151@bizon.gios.gov.pl>


Sorry, I used wrong from addres :(

---------- Forwarded message ----------
Date: Mon, 30 Oct 2006 21:01:32 +0100 (CET)
From: Krzysztof Oledzki <ole@ans.pl>
To: Patrick McHardy <kaber@trash.net>
Cc: Krzysztof Oledzki <olenf@ans.pl>, netfilter-devel@lists.netfilter.org,
     Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: connbytes & 64bit counters



On Mon, 30 Oct 2006, Patrick McHardy wrote:

> Krzysztof Oledzki wrote:
>> [NETFILTER] Reimplementation of 64bit counters for bytes/packets account=
ing
>>=20
>> Initially netfilter has had 64bit counters for conntrack-based
>> accounting, but
>> it was changed in 2.6.14 to save memory. Unfortunately in-kernel 64bit
>> counters are
>> still required, for example for "connbytes" extension. Add possibility
>> to choose
>> between 32 and 64bits but keep default 32bit counters.
>>=20
>> Signed-off-by: Krzysztof Piotr Oledzki <ole@ans.pl>
>>=20
>> +++ linux-2.6.19-rc3/net/netfilter/nf_conntrack_netlink.c    2006-10-28
>> 18:24:12.000000000 +0200
>> @@ -194,13 +194,23 @@
>>  {
>>      enum ctattr_type type =3D dir ? CTA_COUNTERS_REPLY: CTA_COUNTERS_OR=
IG;
>>      struct nfattr *nest_count =3D NFA_NEST(skb, type);
>> -    u_int32_t tmp;
>> +#ifdef CONFIG_NF_CT_ACCT_64BIT_COUNTERS
>> +    __be64 tmp;
>> +
>> +    tmp =3D cpu_to_be64(ct->counters[dir].packets);
>> +    NFA_PUT(skb, CTA_COUNTERS_PACKETS, sizeof(__be64), &tmp);
>> +
>> +    tmp =3D cpu_to_be64(ct->counters[dir].bytes);
>> +    NFA_PUT(skb, CTA_COUNTERS_BYTES, sizeof(__be64), &tmp);
>> +#else
>=20
>=20
> We can't make the API depend on config options
But this does not change the API imho, and this situation is perfectly hand=
led=20
by libnetfilter_conntrack:

static void nfct_parse_counters(struct nfattr *attr,
                                         struct nfct_conntrack *ct,
                                         enum ctattr_type parent)
{
(...)
         if (tb[CTA_COUNTERS_PACKETS-1])
                 ct->counters[dir].packets
                         =3D __be64_to_cpu(*(u_int64_t *)
                                         NFA_DATA(tb[CTA_COUNTERS_PACKETS-1=
]));
         if (tb[CTA_COUNTERS_BYTES-1])
                 ct->counters[dir].bytes
                         =3D __be64_to_cpu(*(u_int64_t *)
                                         NFA_DATA(tb[CTA_COUNTERS_BYTES-1])=
);
         if (tb[CTA_COUNTERS32_PACKETS-1])
                 ct->counters[dir].packets
                         =3D htonl(*(u_int32_t *)
                                 NFA_DATA(tb[CTA_COUNTERS32_PACKETS-1]));
         if (tb[CTA_COUNTERS32_BYTES-1])
                 ct->counters[dir].bytes
                         =3D htonl(*(u_int32_t *)
                                 NFA_DATA(tb[CTA_COUNTERS32_BYTES-1]));
(...)

> (and I don't like all those ifdefs).
Why?

> For now I would suggest to keep the ctnetlink interface as it is and use =
64=20
> bit counters either unconditionally or only when the connbytes match is=
=20
> enabled.

What is wrong in sending 64 bit counters to userspace if we already have 64=
 bit=20
counters in kernel?

Best regards,

 =09=09=09=09Krzysztof Ol=EAdzki
---187430788-695786028-1162238492=:3941--
