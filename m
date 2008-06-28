From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH 2/2] Netfilter: Accounting rework: ct_extend + 64bit
 counters (v3)
Date: Sat, 28 Jun 2008 11:09:46 +0200 (CEST)
Message-ID: <alpine.LNX.1.10.0806281109160.12725@fbirervta.pbzchgretzou.qr>
References: <485a3c49.C0A/tC0/U7AaZp3V%ole@ans.pl> <486114E9.9000809@trash.net> <Pine.LNX.4.64.0806241804340.24680@bizon.gios.gov.pl> <486124C0.5070104@trash.net> <alpine.LNX.1.10.0806241849200.31898@fbirervta.pbzchgretzou.qr>
 <Pine.LNX.4.64.0806241910120.24680@bizon.gios.gov.pl>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: Krzysztof Oledzki <ole@ans.pl>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:35495 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751289AbYF1JJs (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 28 Jun 2008 05:09:48 -0400
In-Reply-To: <Pine.LNX.4.64.0806241910120.24680@bizon.gios.gov.pl>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Tuesday 2008-06-24 19:13, Krzysztof Oledzki wrote:
>> On Tuesday 2008-06-24 18:45, Patrick McHardy wrote:
>> >
>> > sysctls using the sysctl() syscall are deprecated if I'm
>> > not mistaken. sysfs also allows to change module parameters
>> > at runtime, but sure, keep it, it will be gone soon enough.
>>
>> The entire sysctl(2) mechanism is deprecated.
>
> That's why I used CTL_UNNUMBERED here.
>
> http://www.kernel.org/doc/Documentation/sysctl/ctl_unnumbered.txt

But still, if a module_param suffices, I do not see a need for
providing an additional user-visible api via sysctl.
