From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [ANNOUNCE] libmnl 1.0.0 release
Date: Sat, 18 Dec 2010 16:35:21 +0100 (CET)
Message-ID: <alpine.LNX.2.01.1012181633390.13544@obet.zrqbmnf.qr>
References: <4D0B71C3.7030806@netfilter.org> <1292649824.2371.14.camel@kushiel.sterenborg.info> <4D0CABC3.3090601@netfilter.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: "Rob Sterenborg (lists)" <lists@sterenborg.info>,
	netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-owner@vger.kernel.org>
In-Reply-To: <4D0CABC3.3090601@netfilter.org>
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org


On Saturday 2010-12-18 13:40, Pablo Neira Ayuso wrote:
>On 18/12/10 06:23, Rob Sterenborg (lists) wrote:
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
>I'd appreciate if you can guess what version of the kernel header files
>you're using (CentOS uses a mutant Linux kernel 2.6.18, right?).

NLA_F_NESTED et al are available starting with 2.6.24.
