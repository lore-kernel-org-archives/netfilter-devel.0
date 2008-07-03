From: Jesper Dangaard Brouer <hawk@diku.dk>
Subject: Re: Patches solving the same issue!?
Date: Thu, 3 Jul 2008 12:53:07 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0807031224330.3656@tyr.diku.dk>
References: <1215021635-28691-1-git-send-email-jacob@internet24.de>
 <1215021635-28691-2-git-send-email-jacob@internet24.de>
 <1215032251.9467.11.camel@localhost.localdomain> <20080702214736.GA13134@internet24.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: Jesper Dangaard Brouer <jdb@comx.dk>,
	Netfilter Developers <netfilter-devel@vger.kernel.org>,
	Patrick McHardy <kaber@trash.net>
To: Thomas Jacob <jacob@internet24.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mgw2.diku.dk ([130.225.96.92]:45196 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751069AbYGCLxx (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 3 Jul 2008 07:53:53 -0400
In-Reply-To: <20080702214736.GA13134@internet24.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Wed, 2 Jul 2008, Thomas Jacob wrote:

> I am not familiar enough with the iptables code to decide
> whether or not chains are always sorted by name in the kernel,
> and thus will be sorted if you read them back, but if that's
> the case, of course your method is better, as long as that's
> always the case...

It _is_ always the case that chains are sorted by name in the kernel, as 
libiptc puts them in sorted.

Thats also what the chain_index code depends upon (although I have build 
in a safe guard that sorts them if they are not).  There is also a safe 
guard for the offset binary search, but that simply reverts to the old 
(_slow_) search scheme.

If Patrick might want to change this in the future, he should consider 
your solution over mine.


> To be honest, I didn't really understand the chain_index code ;)

It actually some what resembels your idea, with arrays of chain_head 
pointers.  That points to the original chain list.  I don't build "chunks" 
as I don't want to find an exact match, just a place in the chain list to 
start the list search. This is choosen because I need to support chains 
deletes and creates.

Its more complicated because it needs to support chain deletes and 
creates.  And needs to scale, when many chains are added, which requires 
rebuilding the chain_index, but not too often...


BTW, I like your coding style, although it more compact that I would 
choose to write it...

Hilsen
   Jesper Brouer

--
-------------------------------------------------------------------
MSc. Master of Computer Science
Dept. of Computer Science, University of Copenhagen
Author of http://www.adsl-optimizer.dk
-------------------------------------------------------------------
