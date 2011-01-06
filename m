From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: Xtables-addons 1.32/ipset-GENL 5.2
Date: Thu, 06 Jan 2011 14:12:41 +0100
Message-ID: <4D25BFC9.9030807@netfilter.org>
References: <alpine.LNX.2.01.1101040456270.11091@obet.zrqbmnf.qr> <4D2524DB.8090408@netfilter.org> <alpine.DEB.2.00.1101061038080.26385@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Jan Engelhardt <jengelh@medozas.de>, netfilter@vger.kernel.org,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:37965 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751241Ab1AFNMv (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 6 Jan 2011 08:12:51 -0500
In-Reply-To: <alpine.DEB.2.00.1101061038080.26385@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 06/01/11 10:46, Jozsef Kadlecsik wrote:
> On Thu, 6 Jan 2011, Pablo Neira Ayuso wrote:
> 
>> On 04/01/11 05:14, Jan Engelhardt wrote:
>>> So a few people had been asking on whether ipset 5.x will be bundled 
>>> along with Xtables-addons. Naturally this is a difficult question 
>>> because ipset-5 wants a kernel patch. But yes, it is included as of Xt-a 
>>> 1.32 (just out).
>>>
>>> It has been augmented to not require the patch anymore, by moving it 
>>> over from nfnetlink (booo) to genetlink which does not depend on static 
>>> numbers, though you will need at least Linux 2.6.35 for this GENL 
>>> variant in both compilation and at runtime.
>>
>> Not depending of static numbers is a good thing to me because it makes
>> the whole user-space simpler since: a) you don't have to send a message
>> to perform the initial family ID lookup and b) you don't have to
>> subscribe to genl control events (which is required since the the
>> floating family number may change if the module is unloaded).
> 
> You mean "Depending on static numbers...", don't you?

yes, sorry for the confusion.

>>> (As such, ipset-5 is deactivated by default in Xt-a 1.32 and needs to be 
>>> turned on in mconfig.)
>>>
>>> Xt-a files at the usual place.
>>>
>>> The plain genl patch to ipset-5 can be found as a commit at 
>>> git://dev.medozas.de/ipset in the "genl" branch. It has received a run 
>>> through the testsuite (as far as it went until ospf), and I take that as 
>>> an indication that proxying the protocol onto genl was successful.
>>
>> This is going to confuse everyone. Since ipset-5 will be submitted into
>> mainline soon, some distributors may start packaging the user-space genl
>> binaries. Then, once we have it into the kernel, the distributed version
>> will not work with the one running upon nfnetlink.
> 
> Yes, that worries me too.
> 
>> I think it's way easier to submit a patch to reserve the subsystem ID
>> for ipset than adding this genl compatibility layer.
> 
> That was rejected some time ago. :-)

Indeed, I forgot that.

>> BTW, Jozsef, do you plan to submit ipset for the next linux kernel
>> release cycle?
> 
> Yes: ipset-5 depends on the jhash.h patch so as soon as it's in Patrick's 
> tree, I can submit the patches.

great.
