From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: conntrack segfault (was: Re: null-pointer deref in ulogd2)
Date: Wed, 24 Jun 2009 13:57:14 +0200 (CEST)
Message-ID: <alpine.LSU.2.00.0906241353160.16864@fbirervta.pbzchgretzou.qr>
References: <h1q05h$o8h$1@ger.gmane.org> <h1q3tu$2vi$1@ger.gmane.org> <4A40F777.7010505@netfilter.org> <4A4108D6.901@birkenwald.de> <4A4159BE.7040807@birkenwald.de> <20090624105915.GA8675@schleppi.birkenwald.de>
 <alpine.LNX.1.10.0906241315240.2240@bizon.gios.gov.pl>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Bernhard Schmidt <berni@birkenwald.de>,
	netfilter-devel@vger.kernel.org
To: Krzysztof Oledzki <ole@ans.pl>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:44902 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751131AbZFXL5M (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 24 Jun 2009 07:57:12 -0400
In-Reply-To: <alpine.LNX.1.10.0906241315240.2240@bizon.gios.gov.pl>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Wednesday 2009-06-24 13:17, Krzysztof Oledzki wrote:
> On Wed, 24 Jun 2009, Bernhard Schmidt wrote:
>> On Wed, Jun 24, 2009 at 12:39:58AM +0200, Bernhard Schmidt wrote:
>>
>> Hi,
>>
>>> Oh, and we're dumping conntrack -L every minute. Works fine during the
>>> day with 30k connections, but starts to frequently segfault with 60k
>>> connections in the evening. Also trying to get a coredump now.
>>
>> sorry, this is slightly off-topic, but I can't decode the core dump :-(
>>
>> Jun 24 12:03:01 secomat2 kernel: conntrack[14117]: segfault at
>> 7fff1ce83f34 ip 00007fff1ce83f34 sp 00007fff1ce82f20 error 15
>
> I think you should rather try using valgrind. It is very hard to trace memory
> corruption problem with gdb.

A number of libc functions do not seem to always keep the stack
pointers around, or when you are in a signal handler,
so gdb is confused until these functions are exited.

I have seen such even with programs that otherwise behave normally
and which merely have been attached to with gdb. The solution there
would be to set a breakpoint at a well-known function and let it
continue, but in case of segfaults that barely works. Here, use
valgrind to determine the faulty spot, then maybe run gdb on it (no
attach, but direct run) and set a breakpoint before the spot is
hit to examine the variables.
