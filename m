From: Martin Kraus <martin.kraus@wujiman.net>
Subject: Re: conntrackd, internal cache keeps filling up
Date: Tue, 13 May 2014 16:57:40 +0200
Message-ID: <20140513145740.GC9209@finrod>
References: <20140505104058.GA30297@finrod>
 <20140509113129.GA8031@localhost>
 <20140510061743.GA32197@finrod>
 <20140512163538.GA13344@localhost>
 <20140513114535.GA9209@finrod>
 <20140513124044.GA3738@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bomba.12web.cz ([81.0.208.153]:33836 "EHLO fedecks.wujiman.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759834AbaEMPGc (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 13 May 2014 11:06:32 -0400
Content-Disposition: inline
In-Reply-To: <20140513124044.GA3738@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, May 13, 2014 at 02:40:44PM +0200, Pablo Neira Ayuso wrote:
> > it took about 30 minutes to trigger the problem.
> 
> Did you annotate the kernel oops backtrace? Without that information,
> this is pretty much like looking for the needle in the stack.

Unfortunately we don't have any other information. I could reboot to the old
kernel and trigger it again but I'll need to do that in the evening.

Is there a better way to get the oops backtrace than a redirect to the serial
console? 

mk
