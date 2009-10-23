From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: xt_ACCOUNT and big endian machines
Date: Fri, 23 Oct 2009 17:49:09 +0200 (CEST)
Message-ID: <alpine.LSU.2.00.0910231748460.12517@obet.zrqbmnf.qr>
References: <200910231623.42725.thomas.jarosch@intra2net.com> <alpine.LSU.2.00.0910231726400.12517@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Thomas Jarosch <thomas.jarosch@intra2net.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:35307 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752337AbZJWPtF (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 23 Oct 2009 11:49:05 -0400
In-Reply-To: <alpine.LSU.2.00.0910231726400.12517@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Friday 2009-10-23 17:48, Jan Engelhardt wrote:

>
>On Friday 2009-10-23 16:23, Thomas Jarosch wrote:
>
>>Hello Jan,
>>
>>a user of ipt_ACCOUNT recently sent me some patches regarding
>>big endian support in ipt_ACCOUNT/xt_ACCOUNT:
>>http://developer.intra2net.com/mailarchive/html/ipt_ACCOUNT/2009/msg00014.html
>>
>>I'm wondering if this is the best approach to support big endian machines
>>with all those #ifdefs?
>
>The second is ok, though I dunno why he did not chose to do the
>same in the first. Hence:

Though the iptaccount.c patch could have continued using the byte trick.
