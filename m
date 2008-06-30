From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 2/2] Netfilter: Accounting rework: ct_extend + 64bit counters
 (v3)
Date: Mon, 30 Jun 2008 17:59:34 +0200
Message-ID: <486902E6.2020701@trash.net>
References: <485a3c49.C0A/tC0/U7AaZp3V%ole@ans.pl> <486114E9.9000809@trash.net> <Pine.LNX.4.64.0806241804340.24680@bizon.gios.gov.pl> <486124C0.5070104@trash.net> <alpine.LNX.1.10.0806241849200.31898@fbirervta.pbzchgretzou.qr> <Pine.LNX.4.64.0806241910120.24680@bizon.gios.gov.pl> <alpine.LNX.1.10.0806281109160.12725@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Krzysztof Oledzki <ole@ans.pl>, netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:39869 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752912AbYF3P7g (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 30 Jun 2008 11:59:36 -0400
In-Reply-To: <alpine.LNX.1.10.0806281109160.12725@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> On Tuesday 2008-06-24 19:13, Krzysztof Oledzki wrote:
>>> On Tuesday 2008-06-24 18:45, Patrick McHardy wrote:
>>>> sysctls using the sysctl() syscall are deprecated if I'm
>>>> not mistaken. sysfs also allows to change module parameters
>>>> at runtime, but sure, keep it, it will be gone soon enough.
>>> The entire sysctl(2) mechanism is deprecated.
>> That's why I used CTL_UNNUMBERED here.
>>
>> http://www.kernel.org/doc/Documentation/sysctl/ctl_unnumbered.txt
> 
> But still, if a module_param suffices, I do not see a need for
> providing an additional user-visible api via sysctl.


Well, its a bit easier/more flexible to use, especially when not
using modules, and its more in line with the remaining netfilter
controls. So I'm OK with the sysctl.


