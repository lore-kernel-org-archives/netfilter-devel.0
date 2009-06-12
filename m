From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] Reserve nfnetlink subsys ids.
Date: Fri, 12 Jun 2009 15:07:14 +0200
Message-ID: <4A325302.2000100@trash.net>
References: <alpine.DEB.2.00.0906111334090.28605@blackhole.kfki.hu> <4A310FF4.2070207@trash.net> <4A31142E.50707@netfilter.org> <4A31198F.7010004@trash.net> <alpine.DEB.2.00.0906112349380.30129@blackhole.kfki.hu> <4A324558.3020506@trash.net> <alpine.DEB.2.00.0906121413070.30679@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:44693 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764779AbZFLNHO (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 12 Jun 2009 09:07:14 -0400
In-Reply-To: <alpine.DEB.2.00.0906121413070.30679@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jozsef Kadlecsik wrote:
> On Fri, 12 Jun 2009, Patrick McHardy wrote:
> 
>> I didn't mean to finally say no, just wondering if there are special
>> circumstances which would justify an exception.
> 
> No need for an exception, there's a much nicer solution. 
> 
> What is my main problem actually? That currently there is no way for an 
> extension-specific error reporting from the kernel to iptables when 
> there's some problem with a rule. Therefore in order to catch the typical 
> mistakes, I have to check the existence of the set specified on the 
> iptables command line before the rules are sent to the kernel. It is done 
> by querying the kernel about the set, currently via *sockopt calls. But 
> when ipset is migrated to nfnetlink, it'd mean libnfnetlink dependecy, 
> just for the sake of the set match/target in iptables. That's a too high 
> price and I'm not willing to pay it.
> 
> So what I'm working on it is a protocol change in iptables itself (:-), 
> which is fully backward compatible.
> 
> - add a new sockopt option, IPT_SO_GET_REPLACE, which is used instead of
>   IPT_SO_SET_REPLACE (if supported by the kernel.  New iptables will 
>   use IPT_SO_SET_REPLACE with old kernels.)
> - new checkentry functions, which return the extension-specific error 
>   codes instead of a simple boolean value
> - if any error is detected by the checkentry funtions, IPT_SO_GET_REPLACE 
>   returns the corresponding full ipt_entry, with the offset stored in 
>   comefrom to the match/target which produced the error
> - the userspace match/targets, with their new error function, 
>   can translate the received error code to the appropriate error message 
>   and can insert any specific data into the text using the offset into the 
>   ipt_entry.
> 
> So we'll be able to report back exactly what is wrong with the given rule.
> No need anymore to print 'Run `dmesg' for more information.' :-).

That sounds pretty cool.

> And from the set match/target point of view, I won't have to query the 
> kernel at all :-)).
> 
> So far, working on the kernel part, surprisingly small modifications are 
> required.

I'm looking forward to finally have reasonable error reporting :)
