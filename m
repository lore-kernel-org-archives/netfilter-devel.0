From: Krzysztof Oledzki <ole@ans.pl>
Subject: Re: [PATCH]  Accounting rework: ct_extend + 64bit counters (ver. 2)
Date: Fri, 6 Jun 2008 19:13:55 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0806061848340.12641@bizon.gios.gov.pl>
References: <48459c0c.4MdiVlMLZBmNAw6M%olel@ans.pl> <484916E2.3090200@trash.net>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-187430788-1821549387-1212772435=:12641"
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bizon.gios.gov.pl ([212.244.124.8]:45461 "EHLO
	bizon.gios.gov.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751356AbYFFROM (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 6 Jun 2008 13:14:12 -0400
In-Reply-To: <484916E2.3090200@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---187430788-1821549387-1212772435=:12641
Content-Type: TEXT/PLAIN; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE



On Fri, 6 Jun 2008, Patrick McHardy wrote:

> Looks pretty good, just one or two minor things below. What would
> be nice though is to reduce patch size a bit, two suggestions for
> this are:
>
> - move seq_print_acct() changes to seperate cleanup patch

But those are not only cleanup changes but changes mainly required by=20
ct_extend implementation. The only cleanup change is that there is now one=
=20
function instead of two identical. Should I first change both=20
seq_print_counters into seq_print_acct and then merge them in an=20
additional post-patch?

> - keep counters as packets/bytes struct to reduce rename
>  noise in connlimit
I thought "struct nf_ct_ext_type" requires to pass a FQ struct in=20
=2Elen/.align. OK, will check.

> - maybe (hardly worth it) pull out the netlink.h change

No problem, I can add it in an additional pre-patch if you like.

> Krzysztof Oledzki wrote:
>> +int nf_conntrack_acct_init(void)
>> +{
>> +=09int ret;
>> +
>> +#ifdef CONFIG_NF_CT_ACCT
>> +=09printk(KERN_ERR "CONFIG_NF_CT_ACCT is deprecated and will be removed=
=20
>> soon.\n");
>> +#endif
>
> This should point out what people are supposed to do
> (use the new runtime option). KERN_WARN or NOTICE
> seems more appropriate.

Ack.

>> +
>> +=09ret =3D nf_ct_extend_register(&acct_extend);
>> +=09if (ret < 0) {
>> +=09=09printk(KERN_ERR "nf_conntrack_acct: Unable to register=20
>> extension\n");
>> +=09=09return ret;
>> +=09}
>> +
>> +#ifdef CONFIG_SYSCTL
>> +=09acct_sysctl_header =3D=20
>> register_sysctl_paths(nf_net_netfilter_sysctl_path, acct_sysctl_table);
>> +#endif
>
> Please stay under the 80 character limit.
Ack.

> Also should check whether registration succeeded.
Ack.

>>  struct hlist_head *nf_ct_alloc_hashtable(unsigned int *sizep, int=20
>> *vmalloced)
>> @@ -1165,6 +1174,10 @@ int __init nf_conntrack_init(void)
>>  =09if (ret < 0)
>>  =09=09goto out_fini_expect;
>>  +=09ret =3D nf_conntrack_acct_init();
>> +=09if (ret < 0)
>> +=09=09goto out_fini_acct;
>> +
>>  =09/* For use by REJECT target */
>>  =09rcu_assign_pointer(ip_ct_attach, nf_conntrack_attach);
>>  =09rcu_assign_pointer(nf_ct_destroy, destroy_conntrack);
>> @@ -1177,6 +1190,7 @@ int __init nf_conntrack_init(void)
>>   =09return ret;
>>  +out_fini_acct:
>
> nf_conntrack_helper_fini(); ?

Hm... "helper"? You mean "acct"? There is no nf_conntrack_acct_fini as it=
=20
seems to be currently unnecessary. So, this empty out_fini_acct seems to=20
be redundant here but I decided that adding it is cleaner than calling=20
"goto out_fini_*expect*" from the nf_conntrack_*acct*_init error-path.

Thanks.

Best regards,

 =09=09=09=09Krzysztof Ol=EAdzki
---187430788-1821549387-1212772435=:12641--
