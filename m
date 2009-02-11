From: Patrick McHardy <kaber@trash.net>
Subject: Re: Netfilter API and libiptc
Date: Wed, 11 Feb 2009 15:37:39 +0100
Message-ID: <4992E2B3.3030009@trash.net>
References: <20090205141722.GB21417@qubit> <4990636B.9080900@trash.net> <20090209183941.GA1050@zenon.in.qult.net> <Pine.LNX.4.64.0902111408210.4822@ask.diku.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Ignacy Gawedzki <i@lri.fr>,
	Netfilter Developers <netfilter-devel@vger.kernel.org>,
	Jan Engelhardt <jengelh@medozas.de>
To: Jesper Dangaard Brouer <hawk@diku.dk>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:51920 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755457AbZBKOhn (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 11 Feb 2009 09:37:43 -0500
In-Reply-To: <Pine.LNX.4.64.0902111408210.4822@ask.diku.dk>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jesper Dangaard Brouer wrote:
> On Mon, 9 Feb 2009, Ignacy Gawedzki wrote:
>> My question was not about how to prevent the machine from crashing, 
>> but rather
>> how are we supposed to manipulate iptables, now that libiptc is not 
>> available.
>> <cut>
> 
> I would propose that we add libiptc again.
> 
> Possibly as a shared library, like we have libxtables.so?
> 
> Controlling API/ABI changes is going to be a lot harder when people 
> starts to incorporate the libiptc code into their own source 
> distributions. (I'm also guildy with the Perl IPTables::libiptc package...)
> 
> Patrick, what do you say?

Agreed on your reasoning. I don't have much of an opinion, we
mainly tried to hide it because it was never suitable for anything
else than a short "iptables ..." command because of memory leaks
etc. I think we're a lot better with this nowadays, if we can
get the worst remaining ones plugged and somewhat of a usable
API we can certainly add it as a library.
