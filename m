From: Krzysztof Oledzki <ole@ans.pl>
Subject: Re: [PATCH 2/2] Netfilter: Accounting rework: ct_extend + 64bit
 counters (v3)
Date: Wed, 2 Jul 2008 15:20:22 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0807021519330.4958@bizon.gios.gov.pl>
References: <485a3c49.C0A/tC0/U7AaZp3V%ole@ans.pl> <486114E9.9000809@trash.net>
 <Pine.LNX.4.64.0806241804340.24680@bizon.gios.gov.pl>
 <Pine.LNX.4.64.0807021358370.4958@bizon.gios.gov.pl> <486B7D9C.4070501@trash.net>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-187430788-1825209192-1215004822=:4958"
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bizon.gios.gov.pl ([212.244.124.8]:36848 "EHLO
	bizon.gios.gov.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753638AbYGBNU1 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 2 Jul 2008 09:20:27 -0400
In-Reply-To: <486B7D9C.4070501@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---187430788-1825209192-1215004822=:4958
Content-Type: TEXT/PLAIN; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE



On Wed, 2 Jul 2008, Patrick McHardy wrote:

> Krzysztof Oledzki wrote:
>>=20
>>=20
>> On Tue, 24 Jun 2008, Krzysztof Oledzki wrote:
>>=20
>> <CUT>
>>=20
>>>>> +static unsigned int nf_ct_acct __read_mostly =3D NF_CT_ACCT_DEFAULT;
>>>>=20
>>>> Perhaps this should be bool instead?
>>>=20
>>> Yep.
>>=20
>> It seems that it has to stay as unsigned int - if I change it to bool I=
=20
>> get:
>>  net/netfilter/nf_conntrack_acct.c: In function '__check_acct':
>>  net/netfilter/nf_conntrack_acct.c:27: warning: return from incompatible=
=20
>> pointer type
>
> You also need to use the proper module_param type.

Other than:
  module_param_named(acct, nf_ct_acct, bool, 0644);
?

Best regards,

 =09=09=09=09Krzysztof Ol=EAdzki
---187430788-1825209192-1215004822=:4958--
