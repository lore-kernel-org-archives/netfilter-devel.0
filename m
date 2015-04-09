From: Alexander Holler <holler@ahsoftware.de>
Subject: Re: nft parser and names for constants (was [PATCH v2] parser: add
 kludges for "param-problem" and "redirect")
Date: Thu, 09 Apr 2015 19:50:12 +0200
Message-ID: <5526BBD4.2000107@ahsoftware.de>
References: <20150404115550.GA5832@salvia> <20150405113214.GA23433@acer.localdomain> <20150405121104.GD23433@acer.localdomain> <552187FB.60904@ahsoftware.de> <20150406015128.GA20515@acer.localdomain> <55224776.4040108@ahsoftware.de> <55224B70.1070309@ahsoftware.de> <55224E82.3010206@ahsoftware.de> <20150406112543.GB24191@acer.localdomain> <552659D6.8090902@ahsoftware.de> <20150409110745.GI12203@acer.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org,
	Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>,
	Eric Leblond <eric@regit.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from h1446028.stratoserver.net ([85.214.92.142]:50903 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752459AbbDIRuX (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 9 Apr 2015 13:50:23 -0400
Received: from wandq.ahsoftware (p4FC379E9.dip0.t-ipconnect.de [79.195.121.233])
	(using TLSv1 with cipher ADH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mail.ahsoftware.de (Postfix) with ESMTPSA id C0F472C9C1C7
	for <netfilter-devel@vger.kernel.org>; Thu,  9 Apr 2015 19:50:20 +0200 (CEST)
In-Reply-To: <20150409110745.GI12203@acer.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Am 09.04.2015 um 13:07 schrieb Patrick McHardy:
> On 09.04, Alexander Holler wrote:
>>>> E.g. the ICMPv6 parameter-problem is good example. In the linux headers it
>>>> is called ICMPV6_PARAMPROB, nft named it param-problem and in documentations
>>>> it is often named as parameter-problem.
>>>>
>>>> So if nft would use icmpv6_paramprob, the documentation could just refer to
>>>> the c-headers.
>>>
>>> No, an icmpv6_ prefix is redundant and I don't see any benefit in doing
>>> that. "Documentations", whatever that is, don't matter, what matters is
>>> our documentation. And whether we point people to that or some header
>>> file really doesn't matter, except that we don't expect people to read
>>> header files to use nft. Its a tool for admins, not programmers.
>>
>> Even some admins can code.
>>
>> Because nft is just at 0.4 and not widely used (or usable), I decided it's
>> worse to write another follow up in order to try to fix things before they
>> can't be fixed anymore.
>>
>> 1. I don't think that a brutforce-approach like "if error try something
>> else" is the right way to fix a problem in the parser.
>
> Its perfectly fine in this case since the error is only caught in spots
> where we expect symbolic constants. So basically its treating the next
> keyword as symbolic constant no matter what.

I wonder how the error routine in that patch knowns that a symbolic 
constant is expected. Where does it get that information from? And if 
so, why is in such a case error called anyways? And how are problems in 
the grammar identified in which a token or string might match? Of 
course, my bison knowledge got very rusty as I haven't fiddled with it 
for a long time, but I still think it's brute-force or trial-and-error 
approach.

>> 2. "icmpv6_paramprob" (or even something like "icmpv6_parameter-problem")
>> doesn't have something redundant. It's a name for constant and e.g.
>> "icmp_redirect" is a much more descriptive name than just "redirect" because
>> "icmp_redirect" describes the context too and thus the name is much more
>> verbose and readable (besides that it would fix the problem the parser
>> currently has).
>
> It is redundant since it can only occur in the context of ICMP expressions.
> icmp type icmp_redirect is obviously redundant.

It's just a name as such it can't be redundant if you want to allow 
names. Of course, there might be people which are unaware that "icmp_" 
in "icmp_redirect" is just part of the name for a constant, but those 
people shouldn't write firewall rules anyway.


>> 3. I don't see why admins have to use another set of names for constants
>> than developers. Inventing a new set of names for a list of constants for
>> which there already exist a very widely used set of names just leads to more
>> confusion. And if it's ok to invent new names, why does nft use
>> "param-problem" and not "parameter-problem"? Of course, I would suggest to
>> use the existing name icmp_parameterprob (like it's used in every
>> c/c++-source).
>
> In case of ICMP we use the same names that iptables used, so this actually
> spares admins from getting used to new constants. We're not going to use
> source code identifiers, there's no benefit at all, especially if you
> consider that Linux headers use different identifiers than the BSD headers.

nft isn't in use on BSD and if you think taking BSD out of a corner 
makes sense, I wonder how compatible the names, nft uses, are, with what 
is used by ipf or one of the other BSD firewall packages. As the answer 
is the names are incompatible, arguing with BSD is nonsense here.

>
> But I agree, ICMPv6 shouldn't use param-problem but parameter-problem for
> consistency with both ICMP and ip6tables.

Anyway, I've tried it a second time. Can't do more. So I will now 
entering the popcorn-state.

Alexander Holler
