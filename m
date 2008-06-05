From: Patrick McHardy <kaber@trash.net>
Subject: Re: manpages: consistent syntax
Date: Thu, 05 Jun 2008 16:51:36 +0200
Message-ID: <4847FD78.5020906@trash.net>
References: <20080528150425.20290.58521.stgit@woodpecker.roonstrasse.net> <alpine.LNX.1.10.0805281841380.16560@fbirervta.pbzchgretzou.qr> <alpine.LNX.1.10.0805281844480.16560@fbirervta.pbzchgretzou.qr> <4843D047.40103@trash.net> <alpine.LNX.1.10.0806051647590.29055@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Max Kellermann <max@duempel.org>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:45214 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753330AbYFEOvi (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 5 Jun 2008 10:51:38 -0400
In-Reply-To: <alpine.LNX.1.10.0806051647590.29055@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> On Monday 2008-06-02 12:49, Patrick McHardy wrote:
>> Jan Engelhardt wrote:
>>> commit 314cc5f0dd48c047e660f45aaaf4e86675ab5d74
>>> Author: Jan Engelhardt <jengelh@medozas.de>
>>> Date:   Tue May 6 19:47:33 2008 +0200
>>>
>>>     manpages: consistent syntax
>>>     
>>>     In the manpages, bold is used to denote characters the user has to
>>>     enter verbatim, italic denotes placeholders and non-highlighted
>>>     pieces are used as a structure: "[]" specifying an optional part,
>>>     "{}" a mandatory part, with "|" used for alternations. The "!" for
>>>     negation is better supported before the option than after it, too.
>>>     The patch makes a few files consistent with this style already used
>>>     in manpages.
>> Applied, thanks. Please remember to sign off iptables patches in the
>> future.
> 
> I guess that's why it says Author: Patrick McHardy for this one in git.. :-)

Probably. I usually use a correct authorname anyway, but seems
I forgot this time.

