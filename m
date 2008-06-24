From: Krzysztof Oledzki <ole@ans.pl>
Subject: Re: [PATCH 2/2] Netfilter: Accounting rework: ct_extend + 64bit
 counters (v3)
Date: Tue, 24 Jun 2008 18:37:21 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0806241804340.24680@bizon.gios.gov.pl>
References: <485a3c49.C0A/tC0/U7AaZp3V%ole@ans.pl> <486114E9.9000809@trash.net>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-187430788-43077954-1214325441=:24680"
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bizon.gios.gov.pl ([212.244.124.8]:53137 "EHLO
	bizon.gios.gov.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751132AbYFXQiH (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 24 Jun 2008 12:38:07 -0400
In-Reply-To: <486114E9.9000809@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---187430788-43077954-1214325441=:24680
Content-Type: TEXT/PLAIN; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE



On Tue, 24 Jun 2008, Patrick McHardy wrote:

> A few minor nits - a patch on top to fix them is fine, I'll
> just fold them together.

I prefer to send a new patch if that is OK for you.

<CUT>

>> +int nf_conntrack_acct_init(void);
>> +void nf_conntrack_acct_fini(void);
>
> extern for function declarations please.

Ack.

>> +static inline
>> +struct ip_conntrack_counter *nf_conn_acct_find(const struct nf_conn *ct=
)
>> +{
>> +=09return nf_ct_ext_find(ct, NF_CT_EXT_ACCT);
>> +}
>> +
>> +struct ip_conntrack_counter *nf_ct_acct_ext_add(struct nf_conn *ct, gfp=
_t gfp);
>> +
> Also using ip_conntrack in the
> struct name doesn't make much sense, please use nf_conntrack as prefix.
> Or maybe for consistency with the other extensions, nf_conn.

Fine, I'll rename it to nf_conn_counter. Please note that the=20
ip_conntrack_counter comes from nf_conntrack_common.h and is already used=
=20
in several places. Isn't it a pointless rename?

>> +static unsigned int nf_ct_acct __read_mostly =3D NF_CT_ACCT_DEFAULT;
>
> Perhaps this should be bool instead?

Yep.

>> +struct ip_conntrack_counter *nf_ct_acct_ext_add(struct nf_conn *ct, gfp=
_t=20
>> gfp)
>> +{
>> +=09struct ip_conntrack_counter *acct;
>> +
>> +=09if (!nf_ct_acct)
>> +=09=09return NULL;
>> +
>> +=09acct =3D nf_ct_ext_add(ct, NF_CT_EXT_ACCT, gfp);
>> +=09if (!acct)
>> +=09=09pr_debug("failed to add accounting extension area");
>> +
>> +=09return acct;
>> +};
>
> Missing EXPORT_SYMBOL_GPL for ctnetlink:
>
> ERROR: "nf_ct_acct_ext_add" [net/netfilter/nf_conntrack_netlink.ko]=20
> undefined!
>
> Perhaps this should be inlined or at least the nf_ct_acct
> check so we can avoid the unnecessary function call for
> disabled accounting?

Indeed, this function is quite short, I'll inline it.

>> +#ifdef CONFIG_NF_CT_ACCT
>> +=09printk(KERN_WARNING "CONFIG_NF_CT_ACCT is deprecated and will be=20
>> removed soon. Plase use\n");
>> +=09printk(KERN_WARNING "nf_conntrack.acct=3D1 kernel paramater, acct=3D=
1=20
>> nf_conntrack module option or\n");
>> +=09printk(KERN_WARNING "sysctl net.netfilter.nf_conntrack_acct=3D1 to=
=20
>> enable it.\n");
>
> Since sysctls are deprecated (or are they still?), better to just
> mention the kernel and module options.

No, sysctls are not deprecated and allow to enable/disable accouting=20
at runtime - kernel/module options allow to enable/disable accouting at=20
boot time. We only deprecate CONFIG_NF_CT_ACCT.

>> diff --git a/net/netfilter/nf_conntrack_netlink.c=20
>> b/net/netfilter/nf_conntrack_netlink.c
>> index ab655f6..165e7f3 100644
>> --- a/net/netfilter/nf_conntrack_netlink.c
>> +++ b/net/netfilter/nf_conntrack_netlink.c
>> @@ -229,9 +234,6 @@ ctnetlink_dump_counters(struct sk_buff *skb, const=
=20
>> struct nf_conn *ct,
>>  nla_put_failure:
>>  =09return -1;
>>  }
>> -#else
>> -#define ctnetlink_dump_counters(a, b, c) (0)
>> -#endif
>>   #ifdef CONFIG_NF_CONNTRACK_MARK
>>  static inline int
>> @@ -389,8 +391,8 @@ ctnetlink_fill_info(struct sk_buff *skb, u32 pid, u3=
2=20
>> seq,
>>   =09if (ctnetlink_dump_status(skb, ct) < 0 ||
>>  =09    ctnetlink_dump_timeout(skb, ct) < 0 ||
>> -=09    ctnetlink_dump_counters(skb, ct, IP_CT_DIR_ORIGINAL) < 0 ||
>> -=09    ctnetlink_dump_counters(skb, ct, IP_CT_DIR_REPLY) < 0 ||
>> +=09    ctnetlink_dump_acct(skb, ct, IP_CT_DIR_ORIGINAL) < 0 ||
>> +=09    ctnetlink_dump_acct(skb, ct, IP_CT_DIR_REPLY) < 0 ||
>
> This rename seems pointless. I also like the old name better.

Fine.

Best regards,

 =09=09=09=09Krzysztof Ol=EAdzki
---187430788-43077954-1214325441=:24680--
