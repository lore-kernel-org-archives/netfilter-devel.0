From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [ulogd2 PATCH] Fix bracket imbalance if IPPROTO_SCTP is defined
Date: Mon, 6 Aug 2012 12:05:25 +0200
Message-ID: <20120806100525.GA29824@1984>
References: <4E552746.4020000@intra2net.com>
 <alpine.LNX.2.01.1208032034020.29800@frira.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Thomas Jarosch <thomas.jarosch@intra2net.com>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@inai.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:49985 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755602Ab2HFKFc (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 6 Aug 2012 06:05:32 -0400
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.01.1208032034020.29800@frira.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Aug 03, 2012 at 08:34:22PM +0200, Jan Engelhardt wrote:
> On Wednesday 2011-08-24 18:31, Thomas Jarosch wrote:
> 
> >Detected by cppcheck.
> 
> This is still applicable.

Applied, thanks.

Still, the ipfix plugin needs one spin. The current snapshot doesn't
work, that's why it's kept out of the compilation.

It shouldn't be hard to fix it. If anyone interested in contributing
to Netfilter projects, this should be a good one to start with.

If not, I'll find the time to get it working.
