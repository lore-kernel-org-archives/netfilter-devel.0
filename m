From: Krzysztof Oledzki <ole@ans.pl>
Subject: Re: connbytes & 64bit counters
Date: Mon, 30 Oct 2006 21:01:32 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0610302055060.3941@bizon.gios.gov.pl>
References: <Pine.LNX.4.64.0610250035100.23937@bizon.gios.gov.pl>
	<453FE325.1040502@trash.net>
	<Pine.LNX.4.64.0610281716090.19053@bizon.gios.gov.pl>
	<45462043.5010207@trash.net>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-187430788-695786028-1162238492=:3941"
Cc: netfilter-devel@lists.netfilter.org, Krzysztof Oledzki <olenf@ans.pl>,
	Pablo Neira Ayuso <pablo@netfilter.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <45462043.5010207@trash.net>
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
Content-Type: TEXT/PLAIN; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE



On Mon, 30 Oct 2006, Patrick McHardy wrote:

> Krzysztof Oledzki wrote:
>> [NETFILTER] Reimplementation of 64bit counters for bytes/packets account=
ing
>>
>> Initially netfilter has had 64bit counters for conntrack-based
>> accounting, but
>> it was changed in 2.6.14 to save memory. Unfortunately in-kernel 64bit
>> counters are
>> still required, for example for "connbytes" extension. Add possibility
>> to choose
>> between 32 and 64bits but keep default 32bit counters.
>>
>> Signed-off-by: Krzysztof Piotr Oledzki <ole@ans.pl>
>>
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
>
>
> We can't make the API depend on config options
But this does not change the API imho, and this situation is perfectly=20
handled by libnetfilter_conntrack:

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

> For now I would suggest to keep the ctnetlink interface as it is and use=
=20
> 64 bit counters either unconditionally or only when the connbytes match=
=20
> is enabled.

What is wrong in sending 64 bit counters to userspace if we already have=20
64 bit counters in kernel?

Best regards,

 =09=09=09=09Krzysztof Ol=EAdzki
---187430788-695786028-1162238492=:3941--
