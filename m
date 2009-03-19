From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: next iptables release
Date: Thu, 19 Mar 2009 14:45:39 +0100 (CET)
Message-ID: <alpine.LSU.2.00.0903191444090.27642@fbirervta.pbzchgretzou.qr>
References: <49C202EA.40006@trash.net> <49C23FD6.6010503@netfilter.org> <49C240DA.2070006@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:45489 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752311AbZCSNpn (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 19 Mar 2009 09:45:43 -0400
In-Reply-To: <49C240DA.2070006@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Thursday 2009-03-19 13:55, Patrick McHardy wrote:
> Pablo Neira Ayuso wrote:
>> Patrick McHardy wrote:
>>> I've planned to release the next iptables version sometime (late)
>>> this weekend. We've had quite a lot of changes since the last
>>> version, please test the latest version from git and report any
>>> issues.
>>>
>>> Thanks!
>>
>> Great :). BTW, I'm finishing the cluster match manpage, I'll be done
>> tonight, I'd like to see it in this iptables release (even if the
>> feature is expected to appear in 2.6.30).
>
> I have to ask .. why? :)
>
> Besides potentially confusing people (why doesn't it work despite me
> doing everything the manpage says), what are the advantages of including
> the manpage before the actual implementation?

It does not confuse people as much as you think, I would say.
Since iptables runs with kernels so old the dust could kill,
the scenarios where iptables has an .so file for a kernel piece
that did not exist yet back then are numerous.
