From: Thomas Jacob <jacob@internet24.de>
Subject: Re: Plans for future iptables versions / jumpset feature
Date: Thu, 22 May 2008 22:14:19 +0200
Message-ID: <20080522201419.GA28832@internet24.de>
References: <1211482843.28066.40.camel@enterprise.ims-firmen.de> <4835C6F0.5080604@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mailout02.ims-firmen.de ([213.174.32.97]:59349 "EHLO
	mailout02.ims-firmen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753769AbYEVUOV (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 22 May 2008 16:14:21 -0400
Content-Disposition: inline
In-Reply-To: <4835C6F0.5080604@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

> Thats one of the things I also want to add (halfway finished yet).
> Jumps are regular verdicts in my new design and verdicts can be
> gathered though lookups in sets, hashes etc. So you could do:
>
> unnamed ... -j { 192.168.0.1:chain_1, 192.168.0.2:chain_2, ...}

Great news, that's more or less what I'm looking to do.

Would those plans also include some way to incrementally
manipulate these verdict sets, maybe like:

unnamed ... -j dstset:targets

settool --name targets --add 192.168.0.10:chain_10

?

> It would be great to have this in shape by next year, but I won't
> promise anything. Should be doable though.

Looking forward to be an avid beta tester then ;-)
