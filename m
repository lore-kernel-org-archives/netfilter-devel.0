From: Jesper Dangaard Brouer <hawk@diku.dk>
Subject: Re: iptables release
Date: Tue, 27 Nov 2007 22:58:02 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0711272245390.9483@ask.diku.dk>
References: <474C4B67.3000200@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: Netfilter Core Team <coreteam@netfilter.org>,
	Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mgw2.diku.dk ([130.225.96.92]:43593 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755652AbXK0V6J (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 27 Nov 2007 16:58:09 -0500
In-Reply-To: <474C4B67.3000200@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Tue, 27 Nov 2007, Patrick McHardy wrote:

> I have a large number of pending patches for iptables for new
> matches and targets. I'm not going apply patches for new things
> unless they are at least in a -rc kernel, so we have a chance to
> fix mistakes. So my question is whether we're ready to release
> the current iptables -rc anytime soon (before/when 2.6.24 is
> released) or whether we're more likely going to need until 2.6.25,
> in which case I would apply them now.

What about my performance/scalability patches, do I need to wait another 
kernel cycle to see them released?

I think that, at least patch 1/2 should be applied, as its a obvious fix.

For at patch 2/2, I would like some comments on the type casting, e.g. if 
it will work on all platforms e.g. 64-bit.

I'm also working on a faster chain list search (because listing all rules 
still takes 17 sec on production server with patches applied).  That patch 
should, settle a bit in SVN before released.

Note, right now I have some spare time to work on iptables, in a week I 
don't.  Please give me some feedback on the patches.

Hilsen
   Jesper Brouer

--
-------------------------------------------------------------------
MSc. Master of Computer Science
Dept. of Computer Science, University of Copenhagen
Author of http://www.adsl-optimizer.dk
-------------------------------------------------------------------
