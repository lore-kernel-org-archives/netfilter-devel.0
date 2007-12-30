From: Krzysztof Oledzki <ole@ans.pl>
Subject: Re: Quota on SMP AGAIN
Date: Sun, 30 Dec 2007 22:31:12 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0712302228490.15993@bizon.gios.gov.pl>
References: <4773C13D.1040106@simm.ru> <477515BB.1060303@trash.net>
 <Pine.LNX.4.64.0712281647320.29013@fbirervta.pbzchgretzou.qr>
 <477520C3.8040501@trash.net> <Pine.LNX.4.64.0712281716350.29013@fbirervta.pbzchgretzou.qr>
 <47752958.3010601@trash.net>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-187430788-262730531-1199050272=:15993"
Cc: Jan Engelhardt <jengelh@computergmbh.de>, gpf <gpf@simm.ru>,
	netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bizon.gios.gov.pl ([212.244.124.8]:41504 "EHLO
	bizon.gios.gov.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753571AbXL3Vbe (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 30 Dec 2007 16:31:34 -0500
In-Reply-To: <47752958.3010601@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---187430788-262730531-1199050272=:15993
Content-Type: TEXT/PLAIN; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE



On Fri, 28 Dec 2007, Patrick McHardy wrote:
<CUT>
>> And my bigtime question would be: where is the other counter actually?=
=20
>> struct xt_quota_info only has one counter! Does netfilter secretly alloc=
ate=20
>> matchinfos per-cpu?
>>=20
>
> Not secretly, but yes, the entire ruleset exists once per CPU. That
> also seems to be the problem, at the time the master idea was thought
> of we always dumped entries from CPU 0, today its from the current
> CPU, but the only one that actually has correct counters is CPU 0.

What happens when CPU#0 is disabled (CPU hotplug)?

Best regards,

 =09=09=09=09Krzysztof Ol=EAdzki
---187430788-262730531-1199050272=:15993--
