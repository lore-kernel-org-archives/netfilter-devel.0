From: Krzysztof Oledzki <ole@ans.pl>
Subject: Re: Quota on SMP AGAIN
Date: Sat, 29 Dec 2007 19:54:22 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0712291952430.8994@bizon.gios.gov.pl>
References: <4773C13D.1040106@simm.ru> <477515BB.1060303@trash.net>
 <Pine.LNX.4.64.0712281647320.29013@fbirervta.pbzchgretzou.qr>
 <477520C3.8040501@trash.net> <Pine.LNX.4.64.0712281716350.29013@fbirervta.pbzchgretzou.qr>
 <47752958.3010601@trash.net> <Pine.LNX.4.64.0712281756580.29013@fbirervta.pbzchgretzou.qr>
 <47767699.2020302@trash.net>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-187430788-810786745-1198954462=:8994"
Cc: Jan Engelhardt <jengelh@computergmbh.de>, gpf <gpf@simm.ru>,
	netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bizon.gios.gov.pl ([212.244.124.8]:44358 "EHLO
	bizon.gios.gov.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754645AbXL2Syh (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 29 Dec 2007 13:54:37 -0500
In-Reply-To: <47767699.2020302@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---187430788-810786745-1198954462=:8994
Content-Type: TEXT/PLAIN; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE



On Sat, 29 Dec 2007, Patrick McHardy wrote:

> Jan Engelhardt wrote:
>> On Dec 28 2007 17:50, Patrick McHardy wrote:
>>=20
>>>> And my bigtime question would be: where is the other counter
>>>> actually? struct xt_quota_info only has one counter! Does
>>>> netfilter secretly allocate matchinfos per-cpu?
>>>>=20
>>> Not secretly, but yes, the entire ruleset exists once per CPU. That
>>> also seems to be the problem, at the time the master idea was thought
>>> of we always dumped entries from CPU 0, today its from the current
>>> CPU, but the only one that actually has correct counters is CPU 0.
>>>=20
>>> The easy fix would be to revert to that behaviour, but maybe someone
>>> can come up with a better idea that doesn't involve walking over the
>>> entire ruleset and resycing things or adding dump callbacks to
>>> matches.
>>>
>>>=20
>> Well, the short term fix would be to turn
>>
>> =09q->master =3D q
>>=20
>> into
>>
>> =09q->master =3D percpu_get(0, q)
>>=20
>> or whatever is appropriate.
>>=20
>
> That doesn't help, the problem is that we keep only the counters on
> CPU0 up to date, but the data copied to userspace during iptables -L
> is chosen by the CPU the iptables command is running on.

As a short-term workaround one can use taskset to force running iptables=20
on CPU#0.


Best regards,

 =09=09=09=09=09Krzysztof Ol=EAdzki
---187430788-810786745-1198954462=:8994--
