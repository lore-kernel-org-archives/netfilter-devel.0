From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: conntrack segfault
Date: Wed, 24 Jun 2009 19:58:10 +0200
Message-ID: <4A426932.1030607@netfilter.org>
References: <h1q05h$o8h$1@ger.gmane.org> <h1q3tu$2vi$1@ger.gmane.org> <4A40F777.7010505@netfilter.org> <4A4108D6.901@birkenwald.de> <4A4159BE.7040807@birkenwald.de> <20090624105915.GA8675@schleppi.birkenwald.de> <alpine.LNX.1.10.0906241315240.2240@bizon.gios.gov.pl> <alpine.LSU.2.00.0906241353160.16864@fbirervta.pbzchgretzou.qr> <4A42226A.4040502@birkenwald.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Jan Engelhardt <jengelh@medozas.de>,
	Krzysztof Oledzki <ole@ans.pl>, netfilter-devel@vger.kernel.org
To: Bernhard Schmidt <berni@birkenwald.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:39279 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751311AbZFXSFF (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 24 Jun 2009 14:05:05 -0400
In-Reply-To: <4A42226A.4040502@birkenwald.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Bernhard Schmidt wrote:
> Hi,
> 
>>>>> Oh, and we're dumping conntrack -L every minute. Works fine during the
>>>>> day with 30k connections, but starts to frequently segfault with 60k
>>>>> connections in the evening. Also trying to get a coredump now.
>>>> sorry, this is slightly off-topic, but I can't decode the core dump :-(
>>>>
>>>> Jun 24 12:03:01 secomat2 kernel: conntrack[14117]: segfault at
>>>> 7fff1ce83f34 ip 00007fff1ce83f34 sp 00007fff1ce82f20 error 15
>>> I think you should rather try using valgrind. It is very hard to
>>> trace memory
>>> corruption problem with gdb.
>>
>> A number of libc functions do not seem to always keep the stack
>> pointers around, or when you are in a signal handler,
>> so gdb is confused until these functions are exited.
>>
>> I have seen such even with programs that otherwise behave normally
>> and which merely have been attached to with gdb. The solution there
>> would be to set a breakpoint at a well-known function and let it
>> continue, but in case of segfaults that barely works. Here, use
>> valgrind to determine the faulty spot, then maybe run gdb on it (no
>> attach, but direct run) and set a breakpoint before the spot is
>> hit to examine the variables.
> 
> The problem is, we currently run conntrack -L every minute. It segfaults
> about 20 times a day, usually during the period with the highest number
> of connections. Unless I can always run conntrack in valgrind/gdb
> automatically and get a usable dump when it fails I have a hard time to
> get any information from it.

Are you using latest version?
