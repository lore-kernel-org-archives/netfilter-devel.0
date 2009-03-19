From: Patrick McHardy <kaber@trash.net>
Subject: Re: next iptables release
Date: Thu, 19 Mar 2009 14:55:19 +0100
Message-ID: <49C24EC7.3020402@trash.net>
References: <49C202EA.40006@trash.net> <49C23FD6.6010503@netfilter.org> <49C240DA.2070006@trash.net> <alpine.LSU.2.00.0903191444090.27642@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:35910 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751834AbZCSNz0 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 19 Mar 2009 09:55:26 -0400
In-Reply-To: <alpine.LSU.2.00.0903191444090.27642@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> On Thursday 2009-03-19 13:55, Patrick McHardy wrote:
>> Besides potentially confusing people (why doesn't it work despite me
>> doing everything the manpage says), what are the advantages of including
>> the manpage before the actual implementation?
>>     
>
> It does not confuse people as much as you think, I would say.
> Since iptables runs with kernels so old the dust could kill,
> the scenarios where iptables has an .so file for a kernel piece
> that did not exist yet back then are numerous.
>   

Object files are a completely different questions. We've had tons of crap
in there for unmerged patches that we did later merge and had to change
the API, which caused "breakage" for people.

So that is out of the question anyways. And a manpage for something that
isn't even present will either not get noticed or confuse people. Its not
useful.

