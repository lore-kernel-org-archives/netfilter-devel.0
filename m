From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: DROP still returns -EPERM to userspace in OUTPUT chain
Date: Sat, 23 May 2009 17:02:35 +0200
Message-ID: <4A18100B.1080803@netfilter.org>
References: <alpine.LSU.2.00.0905211707050.23519@fbirervta.pbzchgretzou.qr> <4A17D45C.6040909@netfilter.org> <alpine.LSU.2.00.0905231309250.361@fbirervta.pbzchgretzou.qr> <4A17E14B.5040701@netfilter.org> <alpine.LSU.2.00.0905231517400.4949@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>, wintre <mikeacar@gmail.com>,
	Patrick McHardy <kaber@trash.net>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:48461 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753191AbZEWPCn (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 23 May 2009 11:02:43 -0400
In-Reply-To: <alpine.LSU.2.00.0905231517400.4949@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> On Saturday 2009-05-23 13:43, Pablo Neira Ayuso wrote:
>>>> Returning
>>>> -EPERM seems to me quite sane to note that the kernel is explicit (via
>>>> iptables, for example) not allowing permission to send().
>>> Yeah but DROP is perceived by users to be "silently ignore it",
>>> while the "you don't have permission" is REJECT's job.
>> But the DROP and REJECT behaviours refer to the packet logic, ie. with
>> DROP nothing is done, with REJECT we send some explicit packet (like an
>> ICMP administratively prohibited). That still applies to user-space.
> 
> -EPERM is an "administrative prohibited" for userspace, just like a
> returned ICMP packet. Here, functions overlap.

Indeed, I forgot about that case.

>> Reporting -EPERM seems to me a good practise to report user-space
>> applications that the kernel is explicit dropping the packet. Otherwise,
>> while diagnosing problems, people cannot be sure where the packet has
>> been lost.
> 
> Then again, people might be using -m limit -j DROP to simulate actual
> packet loss, for whatever scientific interests they currently have.

For scientific purposes, like packet omission emulation, better to use
netem [1].

> So just wanting to know - are people supposed to use xt_STEAL instead
> if they really want it silently dropped?

Well, I still would like to know any application that can benefit from
this, apart from broken applications.

[1] http://www.linuxfoundation.org/en/Net:Netem

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
