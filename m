From: Patrick McHardy <kaber@trash.net>
Subject: Re: iptables not working with monolithic 2.6.26.5 kernel on ARM
Date: Sun, 05 Oct 2008 16:05:55 +0200
Message-ID: <48E8C9C3.8080303@trash.net>
References: <18661.41641.113458.932029@martins.ozlabs.org> <48E6166F.40607@trash.net> <alpine.LNX.1.10.0810031006260.3893@fbirervta.pbzchgretzou.qr> <18662.61266.69230.675687@martins.ozlabs.org> <alpine.LNX.1.10.0810040724110.19954@fbirervta.pbzchgretzou.qr> <48E8C027.6040209@trash.net> <alpine.LNX.1.10.0810050955560.21891@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Martin Schwenke <martin@meltin.net>,
	netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:45521 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753903AbYJEOGA (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 5 Oct 2008 10:06:00 -0400
In-Reply-To: <alpine.LNX.1.10.0810050955560.21891@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> On Sunday 2008-10-05 09:24, Patrick McHardy wrote:
>> Jan Engelhardt wrote:
>>> You can change the XT_ALIGN macro in the
>>> kernel/include/linux/netfilter/x_tables.h and
>>> iptables/include/linux/netfilter/x_tables.h to read
>>>
>>>  #ifndef roundup
>>>  #define roundup(x, y) ((((x) + ((y) - 1)) / (y)) * (y))
>>>  #endif
>>>  #define XT_ALIGN(s) roundup(s, sizeof(uint64_t))
>>>
>>> and try again. There might be more alignment issues hiding, so
>>> don't expect it to fix it all in a magic whizz.
>> An idea to avoid these problems in the future would be to change
>> the kernel so it accepts stricter alignment than what we currently
>> use and after a grace period (maybe 1-2 years) change XT_ALIGN in
>> userspace so it starts using u64 or simply 8 byte alignment
>> everywhere.
> 
> I'd rather be interested in what architectures actually have
> alignof(uint64_t) == 4, besides the native ARM gcc that's used here.

CRIS isn't requiring any alignment AFAIK, so everything is just
byte aligned. I don't know about any other architectures not
using 8 byte alignment.
