From: Krzysztof Oledzki <ole@ans.pl>
Subject: Re: [PATCH] netfilter: accounting rework: ct_extend + 64bit counters
 (v4)
Date: Wed, 9 Jul 2008 23:53:29 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0807092349490.1999@bizon.gios.gov.pl>
References: <48727680.0v5JqC/twBGv06/n%ole@ans.pl> <4874EFED.5080001@trash.net>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-187430788-1486936264-1215640409=:1999"
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bizon.gios.gov.pl ([212.244.124.8]:36234 "EHLO
	bizon.gios.gov.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751049AbYGIVxg (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 9 Jul 2008 17:53:36 -0400
In-Reply-To: <4874EFED.5080001@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---187430788-1486936264-1215640409=:1999
Content-Type: TEXT/PLAIN; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE



On Wed, 9 Jul 2008, Patrick McHardy wrote:

> Krzysztof Piotr Oledzki wrote:
>>> From 187703b8bfc30048c3a973fea6d3b3ce9bcbb49a Mon Sep 17 00:00:00 2001
>> From: Krzysztof Piotr Oledzki <ole@ans.pl>
>> Date: Mon, 7 Jul 2008 21:49:57 +0200
>> Subject: netfilter: accounting rework: ct_extend + 64bit counters (v4)
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
>>  - makes it possible to enable it at boot time (for=20
>> CONFIG_SYSCTL/CONFIG_SYSFS=3Dn),
>>  - makes it possible to enable/disable it at runtime by sysctl or sysfs,
>>  - extends counters from 32bit to 64bit,
>>  - renames ip_conntrack_counter -> nf_conn_counter,
>>  - enables accounting code unconditionally (no longer depends on=20
>> CONFIG_NF_CT_ACCT),
>>  - set initial accounting enable state based on CONFIG_NF_CT_ACCT
>>  - removes buggy IPCT_COUNTER_FILLING event handling.
>>=20
>> If accounting is enabled newly created connections get additional acct=
=20
>> extend.
>> Old connections are not changed as it is not possible to add a ct_extend=
=20
>> area
>> to confirmed conntrack. Accounting is performed for all connections with
>> acct extend regardless of a current state of=20
>> "net.netfilter.nf_conntrack_acct".
>
> Applied with the attached minor cleanups. Thanks Krzysztof!
>
> There is one things I think needs fixing however:
>
>>  =09=09=09if (NFNL_MSG_TYPE(cb->nlh->nlmsg_type) =3D=3D
>> -=09=09=09=09=09=09IPCTNL_MSG_CT_GET_CTRZERO)
>> -=09=09=09=09memset(&ct->counters, 0,=20
>> sizeof(ct->counters));
>> -#endif
>> +=09=09=09=09=09=09IPCTNL_MSG_CT_GET_CTRZERO) {
>> +=09=09=09=09struct nf_conn_counter *acct;
>> +
>> +=09=09=09=09acct =3D nf_conn_acct_find(ct);
>> +=09=09=09=09if (acct)
>> +=09=09=09=09=09memset(acct, 0, sizeof(struct=20
>> nf_conn_counter[IP_CT_DIR_MAX]));
>
> This needs locking.

Thanks, I'll look at it. Is it enough to place it between=20
spin_lock_bh/spin_unlock_bh, like this?

spin_lock_bh(&nf_conntrack_lock);

memset()

spin_unlock_bh(&nf_conntrack_lock);


Best regards,

 =09=09=09=09Krzysztof Ol=EAdzki
---187430788-1486936264-1215640409=:1999--
