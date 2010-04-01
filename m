From: Patrick McHardy <kaber@trash.net>
Subject: Re: NetFlow / sFlow / IPFIX network probe proposal
Date: Thu, 01 Apr 2010 16:55:09 +0200
Message-ID: <4BB4B3CD.3010604@trash.net>
References: <faefb3f11003300706x16b73a2coefe5079284583db2@mail.gmail.com> <alpine.LSU.2.01.1003301647320.19967@obet.zrqbmnf.qr> <4BB22952.2050305@trash.net> <n2yfaefb3f11003310647uef53fd2k518c4c8f0367adc5@mail.gmail.com> <4BB473CB.5030300@trash.net> <20100401120536.GF19153@mail.eitzenberger.org> <4BB4ADB6.4080206@netfilter.org> <4BB4AEA6.5000102@trash.net> <20100401144617.GG19153@mail.eitzenberger.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: Patrick McHardy <kaber@trash.net>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Roman Tsisyk <roman@tsisyk.com>,
	Stig Thormodsrud <stig@vyatta.com>,
	netfilter-devel@vger.kernel.org, netf
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:54058 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754455Ab0DAOzN (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 1 Apr 2010 10:55:13 -0400
In-Reply-To: <20100401144617.GG19153@mail.eitzenberger.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Holger Eitzenberger wrote:
> On Thu, Apr 01, 2010 at 04:33:10PM +0200, Patrick McHardy wrote:
>
>   
>>>> Some bits and pieces may be missing on the kernel side if you need to
>>>> classify your flows though.  E. g. some IPFIX Aggregrators require the
>>>> DSCP value for that.
>>>>         
>> Adding DSCP doesn't work since we don't distinguish connections
>> by that.
>>     
>
> That patch would be easy, but I was unsure at that time whether DSCP was a
> "flow characteristic" enough, especially as you have something like the
> Netfilter DSCP target to modify it, and that possibly be done not from
> the very start of a flow.
>   
We certainly can't add it to the conntrack tuple, so I'm not sure
how that patch would work. But I'll gladly review it in case someone
takes a stab at this :)
