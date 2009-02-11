From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: Netfilter API and libiptc
Date: Wed, 11 Feb 2009 17:02:00 +0100 (CET)
Message-ID: <alpine.LSU.2.00.0902111656400.22845@fbirervta.pbzchgretzou.qr>
References: <20090205141722.GB21417@qubit> <4990636B.9080900@trash.net> <20090209183941.GA1050@zenon.in.qult.net> <Pine.LNX.4.64.0902111408210.4822@ask.diku.dk> <4992E2B3.3030009@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Jesper Dangaard Brouer <hawk@diku.dk>, Ignacy Gawedzki <i@lri.fr>,
	Netfilter Developers <netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:54053 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755860AbZBKQCD (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 11 Feb 2009 11:02:03 -0500
In-Reply-To: <4992E2B3.3030009@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wednesday 2009-02-11 15:37, Patrick McHardy wrote:

> Jesper Dangaard Brouer wrote:
>> On Mon, 9 Feb 2009, Ignacy Gawedzki wrote:
>>> My question was not about how to prevent the machine from crashing, but
>>> rather
>>> how are we supposed to manipulate iptables, now that libiptc is not
>>> available.
>>> <cut>
>>
>> I would propose that we add libiptc again.
>>
>> Possibly as a shared library, like we have libxtables.so?
>>
>> Controlling API/ABI changes is going to be a lot harder when people starts to
>> incorporate the libiptc code into their own source distributions. (I'm also
>> guildy with the Perl IPTables::libiptc package...)
>>
>> Patrick, what do you say?
>
> Agreed on your reasoning. I don't have much of an opinion, we
> mainly tried to hide it because it was never suitable for anything
> else than a short "iptables ..." command because of memory leaks
> etc. I think we're a lot better with this nowadays, if we can
> get the worst remaining ones plugged and somewhat of a usable
> API we can certainly add it as a library.
>
I have the code ready, it is easily mergeable-and-revertible(*) too, but 
let's wait with that because it currently relies on a certain revision 
of Makefile.am (IOW: merge conflicts with nf).

(*) That is, changing it from 'lib_LTLIBRARIES' to 'noinst_LTLIBARIES' 
and it automatically becomes static wrt. the executables again. Oh I 
love automake :)

git://dev.medozas.de/iptables iptc

