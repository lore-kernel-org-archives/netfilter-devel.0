From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [ANNOUNCE] libnetfilter_conntrack 0.9.0 release
Date: Thu, 9 Sep 2010 22:59:53 +0200 (CEST)
Message-ID: <alpine.LNX.2.01.1009092256350.16634@obet.zrqbmnf.qr>
References: <4C875A2A.6030206@netfilter.org> <alpine.LNX.2.01.1009082016280.22870@obet.zrqbmnf.qr> <4C892440.7070907@netfilter.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:47684 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753487Ab0IIU7y (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 9 Sep 2010 16:59:54 -0400
In-Reply-To: <4C892440.7070907@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Thursday 2010-09-09 20:15, Pablo Neira Ayuso wrote:
>>> documentation in doxygen format. ChangeLog is also attached for more
>>> details.
>>>      src: convert documentation from kerneldoc to doxygen format
>> 
>> Did you not like the doxygen filter that allows to use kdoc in the .c 
>> files?
>
>I liked it indeed, actually I used it to transform the current doc to
>doxygen. I decided to switch to doxygen for consistency with other
>libnetfilter_* libraries.

Hm that certainly wasn't the intended purpose of the filter :-D

It was to proliferate kdoc, because frankly, doxygen with all its
\param, \brief, clutters the actual text flow and starts to look as ugly
as a TeX/HTML document. I guess that is because the formatting codes
actually use plaintext rather than punctuation (just @ and %) only. 
kdoc is simple because it does not try to offer all possible
formatting capabilities.
