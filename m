From: Alexander Holler <holler@ahsoftware.de>
Subject: Re: nft parser and names for constants (was [PATCH v2] parser: add
 kludges for "param-problem" and "redirect")
Date: Fri, 10 Apr 2015 07:38:49 +0200
Message-ID: <552761E9.7000701@ahsoftware.de>
References: <20150405121104.GD23433@acer.localdomain> <552187FB.60904@ahsoftware.de> <20150406015128.GA20515@acer.localdomain> <55224776.4040108@ahsoftware.de> <55224B70.1070309@ahsoftware.de> <55224E82.3010206@ahsoftware.de> <20150406112543.GB24191@acer.localdomain> <552659D6.8090902@ahsoftware.de> <20150409110745.GI12203@acer.localdomain> <5526BBD4.2000107@ahsoftware.de> <20150409191530.GA7548@acer.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org,
	Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>,
	Eric Leblond <eric@regit.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from h1446028.stratoserver.net ([85.214.92.142]:35497 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751536AbbDJFi6 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 10 Apr 2015 01:38:58 -0400
Received: from wandq.ahsoftware (p4FC375A2.dip0.t-ipconnect.de [79.195.117.162])
	(using TLSv1 with cipher ADH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mail.ahsoftware.de (Postfix) with ESMTPSA id 576B82C9C1C0
	for <netfilter-devel@vger.kernel.org>; Fri, 10 Apr 2015 07:38:56 +0200 (CEST)
In-Reply-To: <20150409191530.GA7548@acer.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Am 09.04.2015 um 21:15 schrieb Patrick McHardy:
> On 09.04, Alexander Holler wrote:
>> Am 09.04.2015 um 13:07 schrieb Patrick McHardy:
>>>> 3. I don't see why admins have to use another set of names for constants
>>>> than developers. Inventing a new set of names for a list of constants for
>>>> which there already exist a very widely used set of names just leads to more
>>>> confusion. And if it's ok to invent new names, why does nft use
>>>> "param-problem" and not "parameter-problem"? Of course, I would suggest to
>>>> use the existing name icmp_parameterprob (like it's used in every
>>>> c/c++-source).
>>>
>>> In case of ICMP we use the same names that iptables used, so this actually
>>> spares admins from getting used to new constants. We're not going to use
>>> source code identifiers, there's no benefit at all, especially if you
>>> consider that Linux headers use different identifiers than the BSD headers.
>>
>> nft isn't in use on BSD and if you think taking BSD out of a corner makes
>> sense, I wonder how compatible the names, nft uses, are, with what is used
>> by ipf or one of the other BSD firewall packages. As the answer is the names
>> are incompatible, arguing with BSD is nonsense here.
>
> This is starting to annoy me. If you suggest to use names from headers, at
> least do your homework. The BSD headers is what most of userspace uses, and
> this is where ICMP_PARAMPROB originates. Linux uses ICMP_PARAMETERPROB.

I aggree that this discussion, which never really has begun, finally 
ended in the mud. Feel free to throw out more accusations as I won't try 
to discuss with you anymore.
