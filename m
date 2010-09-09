From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [ANNOUNCE] libnetfilter_conntrack 0.9.0 release
Date: Thu, 09 Sep 2010 20:15:28 +0200
Message-ID: <4C892440.7070907@netfilter.org>
References: <4C875A2A.6030206@netfilter.org> <alpine.LNX.2.01.1009082016280.22870@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:42941 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753437Ab0IISPc (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 9 Sep 2010 14:15:32 -0400
In-Reply-To: <alpine.LNX.2.01.1009082016280.22870@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 08/09/10 20:17, Jan Engelhardt wrote:
> On Wednesday 2010-09-08 11:40, Pablo Neira Ayuso wrote:
> 
>> Hi!
>>
>> The Netfilter project presents libnetfilter_conntrack-0.9.0
>>
>> libnetfilter_conntrack is a userspace library providing a programming
>> interface (API) to the in-kernel connection tracking state table. This
>> library requires a linux kernel >= 2.6.18.
>>
>> This release includes two fixes and the infrastructure to generate API
>> documentation in doxygen format. ChangeLog is also attached for more
>> details.
>>
>> Pablo Neira Ayuso (5):                                                          
>>      ct: fix regression with helpers for Linux kernel >= 2.6.34
>>      build: add libtool m4 support
>>      src: convert documentation from kerneldoc to doxygen format
> 
> Did you not like the doxygen filter that allows to use kdoc in the .c 
> files?

I liked it indeed, actually I used it to transform the current doc to
doxygen. I decided to switch to doxygen for consistency with other
libnetfilter_* libraries.

P.S: I'll check your libnetfilter_conntrack patches tomorrow, thanks!

