From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: next iptables release
Date: Thu, 19 Mar 2009 15:02:43 +0100 (CET)
Message-ID: <alpine.LSU.2.00.0903191456190.27642@fbirervta.pbzchgretzou.qr>
References: <49C202EA.40006@trash.net> <49C23FD6.6010503@netfilter.org> <49C240DA.2070006@trash.net> <alpine.LSU.2.00.0903191444090.27642@fbirervta.pbzchgretzou.qr> <49C24EC7.3020402@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:43243 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754318AbZCSOCp (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 19 Mar 2009 10:02:45 -0400
In-Reply-To: <49C24EC7.3020402@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Thursday 2009-03-19 14:55, Patrick McHardy wrote:
>Jan Engelhardt wrote:
>> On Thursday 2009-03-19 13:55, Patrick McHardy wrote:
>>> Besides potentially confusing people (why doesn't it work despite me
>>> doing everything the manpage says), what are the advantages of including
>>> the manpage before the actual implementation?
>>
>> It does not confuse people as much as you think, I would say.
>> Since iptables runs with kernels so old the dust could kill,
>> the scenarios where iptables has an .so file for a kernel piece
>> that did not exist yet back then are numerous.
>
>[...]a manpage for something that
>isn't even present will either not get noticed or confuse people. Its not
>useful.

I agree with that. Manpages for non-existant .so files seems
cloven/incomplete [zerhackt].

>Object files are a completely different questions. We've had tons of crap
>in there for unmerged patches that we did later merge and had to change
>the API, which caused "breakage" for people.

Yes, but we can, and specifically I do, expect Pablo to fabricate
something better, more consistent, and which has been reviewed with
regard to the 'guideline checklist' than the unreviewed rotting
bits that used to be in the past POM tree.
