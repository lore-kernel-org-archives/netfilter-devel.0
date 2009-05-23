From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: DROP still returns -EPERM to userspace in OUTPUT chain
Date: Sat, 23 May 2009 15:20:08 +0200 (CEST)
Message-ID: <alpine.LSU.2.00.0905231517400.4949@fbirervta.pbzchgretzou.qr>
References: <alpine.LSU.2.00.0905211707050.23519@fbirervta.pbzchgretzou.qr> <4A17D45C.6040909@netfilter.org> <alpine.LSU.2.00.0905231309250.361@fbirervta.pbzchgretzou.qr> <4A17E14B.5040701@netfilter.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>, wintre <mikeacar@gmail.com>,
	Patrick McHardy <kaber@trash.net>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:46802 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751810AbZEWNUI (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 23 May 2009 09:20:08 -0400
In-Reply-To: <4A17E14B.5040701@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Saturday 2009-05-23 13:43, Pablo Neira Ayuso wrote:
>>> Returning
>>> -EPERM seems to me quite sane to note that the kernel is explicit (via
>>> iptables, for example) not allowing permission to send().
>> 
>> Yeah but DROP is perceived by users to be "silently ignore it",
>> while the "you don't have permission" is REJECT's job.
>
>But the DROP and REJECT behaviours refer to the packet logic, ie. with
>DROP nothing is done, with REJECT we send some explicit packet (like an
>ICMP administratively prohibited). That still applies to user-space.

-EPERM is an "administrative prohibited" for userspace, just like a
returned ICMP packet. Here, functions overlap.

>Reporting -EPERM seems to me a good practise to report user-space
>applications that the kernel is explicit dropping the packet. Otherwise,
>while diagnosing problems, people cannot be sure where the packet has
>been lost.

Then again, people might be using -m limit -j DROP to simulate actual
packet loss, for whatever scientific interests they currently have.
So just wanting to know - are people supposed to use xt_STEAL instead
if they really want it silently dropped?

>I'm more like in favour of forcing people to fix their applications,
>they are doing a broken error handling.

Think UDP :)
