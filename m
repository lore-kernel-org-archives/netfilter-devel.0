From: Krzysztof Oledzki <ole@ans.pl>
Subject: Re: [PATCH]  Accounting rework: ct_extend + 64bit counters
Date: Tue, 3 Jun 2008 19:19:15 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0806031915250.23234@bizon.gios.gov.pl>
References: <48442cd8.dD0hLVFRFjNruv6o%ole@ans.pl> <4845477B.8050400@trash.net>
 <Pine.LNX.4.64.0806031715240.3438@bizon.gios.gov.pl> <4845712F.7080003@trash.net>
 <Pine.LNX.4.64.0806031830250.3438@bizon.gios.gov.pl> <48457414.4050509@trash.net>
 <Pine.LNX.4.64.0806031841410.3438@bizon.gios.gov.pl> <48457BE0.6000604@trash.net>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-187430788-19690406-1212513555=:23234"
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bizon.gios.gov.pl ([212.244.124.8]:51924 "EHLO
	bizon.gios.gov.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752844AbYFCRTU (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 3 Jun 2008 13:19:20 -0400
In-Reply-To: <48457BE0.6000604@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---187430788-19690406-1212513555=:23234
Content-Type: TEXT/PLAIN; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE



On Tue, 3 Jun 2008, Patrick McHardy wrote:

> Krzysztof Oledzki wrote:
>>> Mhh good point :) I was thinking of calling it from the raw table,
>>> but of course we don't have a conntrack at that point. So the
>>> information would have to be propagated from the raw table somehow.
>>> Maybe something like the untracked conntrack? IIRC someone posted
>>> a patch for something similar (propagation of parameters to helpers)
>>> some time ago.
>>=20
>> OK, I'll look at this. Can we push the current version (plus discussed=
=20
>> changes) now and tag if for 2.6.27 and try to solve above problem later=
=20
>> (2.6.28)?
>
> I would prefer to see a final solution before pushing
> it upstream. Having it only implemented half-way forces
> an additional allocation on everyone (even those not
> even compiling the feature in now) for now gain.

Not really as my patch makes possible do disable accounting, I even=20
initially proposed to disable it by default. If accounting is disabled=20
then there is no additional allocation.

>>>> Do you mean an iptables target (-j ...)? IMHO a kernel/module option p=
lus=20
>>>> a sysctl/sysfs interface should be enough.
>>>=20
>>> Having it controlled through an iptables target would be preferrable
>>> because you can then do selective accounting.
>>=20
>> OK, but this will make everything slower and may be often unnecessary, s=
o I=20
>> still think that setting a default mode should be possible. It is someth=
ing=20
>> like "iptables -P", BTW.
>
> I'm guessing the allocation is where the real cost is,
> but I'm not opposed to a default (that will get changed
> to off after some period).

Fine.

Best regards,

 =09=09=09=09Krzysztof Ol=EAdzki
---187430788-19690406-1212513555=:23234--
