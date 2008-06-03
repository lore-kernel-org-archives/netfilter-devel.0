From: Krzysztof Oledzki <ole@ans.pl>
Subject: Re: [PATCH]  Accounting rework: ct_extend + 64bit counters
Date: Tue, 3 Jun 2008 18:23:32 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0806031715240.3438@bizon.gios.gov.pl>
References: <48442cd8.dD0hLVFRFjNruv6o%ole@ans.pl> <4845477B.8050400@trash.net>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-187430788-348177274-1212510212=:3438"
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bizon.gios.gov.pl ([212.244.124.8]:36004 "EHLO
	bizon.gios.gov.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750987AbYFCQXj (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 3 Jun 2008 12:23:39 -0400
In-Reply-To: <4845477B.8050400@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---187430788-348177274-1212510212=:3438
Content-Type: TEXT/PLAIN; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE



On Tue, 3 Jun 2008, Patrick McHardy wrote:

> Krzysztof Oledzki wrote:
>> [NETFILTER] Accounting rework: ct_extend + 64bit counters
>>=20
>> Initially netfilter has had 64bit counters for conntrack-based accountin=
g,=20
>> but
>> it was changed in 2.6.14 to save memory. Unfortunately in-kernel 64bit=
=20
>> counters are
>> still required, for example for "connbytes" extension. However, 64bit=20
>> counters
>> waste a lot of memory and it was not possible to enable/disable it runti=
me.
>>=20
>> This patch:
>>  - reimplements accounting with respect to the extension infrastructure,
>>  - makes one global version of seq_print_acct() instead of two=20
>> seq_print_counters(),
>>  - makes it possible to enable it at boot time (for SYSFS=3Dn),
>>  - makes it possible to enable/disable it at runtime by sysctl or sysfs,
>>  - extents counters from 32bit to 64bit,
>>  - enables accounting code unconditionally (no more CONFIG_NF_CT_ACCT),
>>  - keeps accounting disabled by default,
>>  - removes buggy IPCT_COUNTER_FILLING event handling.
>>=20
>> If accounting is enabled newly created connections get additional acct=
=20
>> extent.
>> Old connections are not changed as it is not possible to add a ct_extend=
=20
>> area
>> to confirmed conntrack. Accounting is performed for all connections with
>> acct extent regardless of a current state of=20
>> net.netfilter.nf_conntrack_acct.
>>=20
>> Patch against 2.6.26-rc4, it would be nice if it can be included
>> in 2.6.27.
>
> Thanks for working on this. Some minor comments below:
Thanks,

>> Signed-off-by: Krzysztof Piotr Oledzki <ole@ans.pl>
>>=20
>> diff -Nur linux-2.6.26-rc4-net/Documentation/kernel-parameters.txt=20
>> linux-2.6.26-rc4-64bitc/Documentation/kernel-parameters.txt
>> --- linux-2.6.26-rc4-net/Documentation/kernel-parameters.txt=092008-05-2=
6=20
>> 20:08:11.000000000 +0200
>> +++ linux-2.6.26-rc4-64bitc/Documentation/kernel-parameters.txt=20
>> 2008-06-02 18:28:30.000000000 +0200
>> @@ -1234,6 +1234,11 @@
>>  =09=09=09This usage is only documented in each driver source
>>  =09=09=09file if at all.
>>  +=09nf_conntrack.acct=3D
>> +=09=09=09[NETFILTER] Enable connection tracking flow=20
>> accounting
>> +=09=09=090 to disable accounting (default)
>> +=09=09=091 to enable accounting
>
> Changing the default will probably result in surprises.
> How about we make a config option (CONFIG_NF_ACCT_COMPAT)
> that makes it default to 1 and print a warning that this
> option is going to be removed/the default changed. Then
> we add a target to manually enable accounting on a per-connection
> base and kill off the compat option after a couple of
> month.

As far as I know there is now way to enable accounting on a per-connection=
=20
base with a target as it is not possible to ad ct_extend to confirmed=20
conntracks. However, I think we may still use CONFIG_NF_CT_ACCT but only=20
to set a default value of this (nf_ct_acct) variable, is that acceptable?

>> diff -Nur=20
>> linux-2.6.26-rc4-net/include/linux/netfilter/nf_conntrack_common.h=20
>> linux-2.6.26-rc4-64bitc/include/linux/netfilter/nf_conntrack_common.h
>> --- linux-2.6.26-rc4-net/include/linux/netfilter/nf_conntrack_common.h=
=20
>> 2008-05-26 20:08:11.000000000 +0200
>> +++ linux-2.6.26-rc4-64bitc/include/linux/netfilter/nf_conntrack_common.=
h=20
>> 2008-06-02 17:19:05.000000000 +0200
>> @@ -122,10 +122,6 @@
>>  =09IPCT_NATINFO_BIT =3D 10,
>>  =09IPCT_NATINFO =3D (1 << IPCT_NATINFO_BIT),
>>  -=09/* Counter highest bit has been set */
>> -=09IPCT_COUNTER_FILLING_BIT =3D 11,
>> -=09IPCT_COUNTER_FILLING =3D (1 << IPCT_COUNTER_FILLING_BIT),
>> -
>
>
> This is exposed to userspace and needs to stay to avoid breaking
> compilation.

OK.

>> +unsigned int
>> +seq_print_acct(struct seq_file *s, const struct nf_conn *ct, int dir)
>> +{
>> +=09struct nf_conn_acct *acct;
>> +
>> +=09acct =3D nf_conn_acct_find(ct);
>> +=09if (!acct)
>> +=09=09return 0;
>> +
>> +=09return seq_printf(s, "packets=3D%llu bytes=3D%llu ",
>> +=09=09=09  acct->packets[dir],
>> +=09=09=09  acct->bytes[dir]);
>
> Will probably cause warnings on 64bit.

OK, so we need here something like "(unsigned long long)", right?

Best regards,

 =09=09=09=09Krzysztof Ol=EAdzki
---187430788-348177274-1212510212=:3438--
