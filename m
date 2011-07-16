From: Adam Roach <adam@nostrum.com>
Subject: Re: NAT66 : A first implementation
Date: Fri, 15 Jul 2011 22:08:33 -0500
Message-ID: <4E2100B1.60202@nostrum.com>
References: <alpine.LNX.2.01.1107141818500.10490@frira.zrqbmnf.qr><4E1F1902.9020605@student.ulg.ac.be><alpine.LNX.2.01.1107141915580.10781@frira.zrqbmnf.qr> <20110714.161717.1387261665409519132.davem@davemloft.net> <6F5DE7538AFCDA45A114F5E7510424A7028D1BBE@hq-exchange01.bytemobile.com> <4E1FA5F9.3040006@nostrum.com> <6F5DE7538AFCDA45A114F5E7510424A7028D1CDC@hq-exchange01.bytemobile.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: David Miller <davem@davemloft.net>, jengelh@medozas.de,
	T.Moes@student.ulg.ac.be, netfilter-devel@vger.kernel.org
To: Jeff Haran <jharan@bytemobile.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from shaman.nostrum.com ([72.232.179.90]:49403 "EHLO nostrum.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751259Ab1GPDIo (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 15 Jul 2011 23:08:44 -0400
In-Reply-To: <6F5DE7538AFCDA45A114F5E7510424A7028D1CDC@hq-exchange01.bytemobile.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 7/15/11 17:12, Jul 15, Jeff Haran wrote:
>> I was unaware of the RFC. Thanks for the reference, however I have to
>> point out the following quote from its introduction:
>>
>> "For reasons discussed in [RFC2993] and Section 5, the IETF does not
>> recommend the use of Network Address Translation technology for IPv6."

That statement is simple IETF politics. A substantial portion of RFC 
2993 doesn't apply to the RFC 6296 mechanism. For example, of the seven 
problems enumerated in section 7, only two -- 7.2 and 7.5 -- remain 
applicable. And, to be fair, those two issues are very minor compared to 
the other five.

>> I'm not saying nobody is going to use IPv6 NAT nor that the Linux world
>> should somehow make it hard on them to do so. There may be a few cases
>> where it makes sense.
>>

Exactly. Even the most recent IAB statement on IPv6 NATs (RFC 5902) 
concedes: "[I]n smaller managed networks that cannot get 
provider-independent IP address blocks, renumbering remains a serious 
issue.  Regional Internet Registries (RIRs) constantly receive requests 
for PI address blocks; one main reason that they hesitate in assigning 
PI address blocks to all users is the concern about the PI addresses' 
impact on the routing system scalability."

So, yes, IPv6 NAT remains inadvisable for most residential applications 
(which can simply propagate their ISP's assigned prefix down to 
devices), and some very large enterprise deployments (which can get PI 
address blocks). But it does solve a very real problem for small to 
medium (and even large, depending on where you want to draw the line) 
enterprises -- basically, "everyone else."

It seems a little silly to refuse _consideration_ of NAT technologies 
when (1) a preponderance of the problems historically present in IPv4 
NATs have been addressed, and (2) a small but nontrivial portion of 
networks that will be using IPv6 soon will desire this technology for 
operational cost reasons.

What I'm saying is that this age-old policy statement: 
<http://lists.netfilter.org/pipermail/netfilter/2005-March/059463.html> 
needs to be revisited. The facts on the ground have changed. Adhering to 
beliefs in the face of contrary evidence isn't principle -- it's 
religion. And imposing religion on others doesn't help anyone.

/a
