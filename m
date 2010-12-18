From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [ANNOUNCE] libmnl 1.0.0 release
Date: Sat, 18 Dec 2010 13:53:21 +0100
Message-ID: <4D0CAEC1.6000409@netfilter.org>
References: <4D0B71C3.7030806@netfilter.org> <1292649824.2371.14.camel@kushiel.sterenborg.info> <4D0CABC3.3090601@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org
To: "Rob Sterenborg (lists)" <lists@sterenborg.info>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:37193 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755789Ab0LRMxZ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 18 Dec 2010 07:53:25 -0500
In-Reply-To: <4D0CABC3.3090601@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 18/12/10 13:40, Pablo Neira Ayuso wrote:
> Hi Rob,
> 
> On 18/12/10 06:23, Rob Sterenborg (lists) wrote:
>> On Fri, 2010-12-17 at 15:20 +0100, Pablo Neira Ayuso wrote:
>>> Hi!
>>>
>>> The Netfilter project presents libmnl-1.0.0
>>
>> Hi,
>>
>> I have a CentOS 5.5 base with a 2.6.36.2 kernel installed. When
>> compiling libmnl I got these errors:
>>
>> nlmsg.c: In function 'mnl_nlmsg_fprintf_payload':
>> nlmsg.c:274: error: 'NLA_TYPE_MASK' undeclared (first use in this
>> function)
>> nlmsg.c:274: error: (Each undeclared identifier is reported only once
>> nlmsg.c:274: error: for each function it appears in.)
>> nlmsg.c:290: error: 'NLA_F_NESTED' undeclared (first use in this
>> function)
>> nlmsg.c:292: error: 'NLA_F_NET_BYTEORDER' undeclared (first use in this
>> function)
>> make: *** [nlmsg.lo] Error 1
>>
>> NLA_TYPE_MASK is used in nlmsg.c and attr.c. Searching I found that it
>> should be defined in linux/netlink.h but it's not there.
> 
> I'd appreciate if you can guess what version of the kernel header files
> you're using (CentOS uses a mutant Linux kernel 2.6.18, right?).
> 
> I can make a patch based on your idea to make libmnl compile cleanly
> with old Linux kernels.

I bet that examples will not compile either in old Linux kernels. Try
`make check'.
