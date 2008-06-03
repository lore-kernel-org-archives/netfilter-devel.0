From: Krzysztof Oledzki <ole@ans.pl>
Subject: Re: [PATCH]  Accounting rework: ct_extend + 64bit counters
Date: Tue, 3 Jun 2008 18:35:53 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0806031830250.3438@bizon.gios.gov.pl>
References: <48442cd8.dD0hLVFRFjNruv6o%ole@ans.pl> <4845477B.8050400@trash.net>
 <Pine.LNX.4.64.0806031715240.3438@bizon.gios.gov.pl> <4845712F.7080003@trash.net>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-187430788-2083766669-1212510953=:3438"
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bizon.gios.gov.pl ([212.244.124.8]:53931 "EHLO
	bizon.gios.gov.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750920AbYFCQf7 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 3 Jun 2008 12:35:59 -0400
In-Reply-To: <4845712F.7080003@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---187430788-2083766669-1212510953=:3438
Content-Type: TEXT/PLAIN; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE



On Tue, 3 Jun 2008, Patrick McHardy wrote:

> Krzysztof Oledzki wrote:
>> On Tue, 3 Jun 2008, Patrick McHardy wrote:
>>
>>>>  +    nf_conntrack.acct=3D
>>>> +            [NETFILTER] Enable connection tracking flow accounting
>>>> +            0 to disable accounting (default)
>>>> +            1 to enable accounting
>>>=20
>>> Changing the default will probably result in surprises.
>>> How about we make a config option (CONFIG_NF_ACCT_COMPAT)
>>> that makes it default to 1 and print a warning that this
>>> option is going to be removed/the default changed. Then
>>> we add a target to manually enable accounting on a per-connection
>>> base and kill off the compat option after a couple of
>>> month.
>>=20
>> As far as I know there is now way to enable accounting on a per-connecti=
on=20
>> base with a target as it is not possible to ad ct_extend to confirmed=20
>> conntracks.
>
> You can add it to unconfirmed conntracks though.

With a target? How?

>> However, I think we may still use CONFIG_NF_CT_ACCT but only to set a=20
>> default value of this (nf_ct_acct) variable, is that acceptable?
>
> We should move towards getting rid of the default value,
> having this depend on a config option must only be a temporary
> solution.

Fine. So I add this together with an entry in=20
feature-removal-schedule.txt.

> So we'd still need a target to enable it manually

Do you mean an iptables target (-j ...)? IMHO a kernel/module option plus=
=20
a sysctl/sysfs interface should be enough.

> and some kind of warning.

Fine.

Best regards,

 =09=09=09=09Krzysztof Ol=EAdzki
---187430788-2083766669-1212510953=:3438--
