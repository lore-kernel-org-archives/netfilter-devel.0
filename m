From: Krzysztof Oledzki <ole@ans.pl>
Subject: Re: [PATCH 2/2] Netfilter: Accounting rework: ct_extend + 64bit
 counters (v3)
Date: Tue, 24 Jun 2008 19:13:53 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0806241910120.24680@bizon.gios.gov.pl>
References: <485a3c49.C0A/tC0/U7AaZp3V%ole@ans.pl> <486114E9.9000809@trash.net>
 <Pine.LNX.4.64.0806241804340.24680@bizon.gios.gov.pl> <486124C0.5070104@trash.net>
 <alpine.LNX.1.10.0806241849200.31898@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-187430788-2076618532-1214327633=:24680"
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bizon.gios.gov.pl ([212.244.124.8]:39894 "EHLO
	bizon.gios.gov.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754640AbYFXROA (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 24 Jun 2008 13:14:00 -0400
In-Reply-To: <alpine.LNX.1.10.0806241849200.31898@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---187430788-2076618532-1214327633=:24680
Content-Type: TEXT/PLAIN; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE



On Tue, 24 Jun 2008, Jan Engelhardt wrote:

>
> On Tuesday 2008-06-24 18:45, Patrick McHardy wrote:
>>
>> sysctls using the sysctl() syscall are deprecated if I'm
>> not mistaken. sysfs also allows to change module parameters
>> at runtime, but sure, keep it, it will be gone soon enough.
>
> The entire sysctl(2) mechanism is deprecated.

That's why I used CTL_UNNUMBERED here.

http://www.kernel.org/doc/Documentation/sysctl/ctl_unnumbered.txt

Best regards,

 =09=09=09=09Krzysztof Ol=EAdzki
---187430788-2076618532-1214327633=:24680--
