From: Patrick McHardy <kaber@trash.net>
Subject: Re: Patches solving the same issue!?
Date: Thu, 03 Jul 2008 14:42:25 +0200
Message-ID: <486CC931.2010703@trash.net>
References: <> <1215021635-28691-1-git-send-email-jacob@internet24.de>	 <1215021635-28691-2-git-send-email-jacob@internet24.de> <1215032251.9467.11.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Thomas Jacob <jacob@internet24.de>, netfilter-devel@vger.kernel.org
To: jdb@comx.dk
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:35892 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760022AbYGCMm2 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 3 Jul 2008 08:42:28 -0400
In-Reply-To: <1215032251.9467.11.camel@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jesper Dangaard Brouer wrote:
> I can see from the list that Thomas Jacob <jacob@internet24.de>, and I
> have just posted patches solving the same issue.
> 
> I promised Patrick that I would work on this issue, and I did.

Sorry, I'm forgetful sometimes :)

> Its running on our production servers, and I planned to release the
> patch today as it has proven stable on production.  I guess Thomas was
> just slightly faster than me ;-)
> 
> It was actually already released in the CPAN module IPTables::libiptc
> (ver.0.08 released 2008-06-16).
> 
> 
> We both use binary search, but with two slightly different approaches.
> 
> - My patch uses the existing data structure, and the existing
>   algorithm for binary searching.
> 
> - Thomas builds a new data structure and implements a new binary
>   search algorithm.
> 
> I must give Thomas that this binary search algo (taken from wikipedia)
> is much more compact than the existing one.
> 
> Guess I cannot judge what patch is the best, as I'm biased...

Me neither since you guys did all the work :)

Please work this out among yourselves. I think we should just pick
the faster one since both don't look very intrusive.
