From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: alignment problem with ebt_among on ppc
Date: Tue, 21 Feb 2012 13:32:19 +0100
Message-ID: <20120221123219.GA25271@1984>
References: <Pine.LNX.4.64.1202030819151.17732@brian.int.clnt.de>
 <4F341D0E.3020209@pandora.be>
 <Pine.LNX.4.64.1202101314380.17215@brian.int.clnt.de>
 <4F3AA867.7030108@pandora.be>
 <20120214195615.GE29165@1984>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Joerg Willmann <joe@clnt.de>, netfilter-devel@vger.kernel.org
To: Bart De Schuymer <bdschuym@pandora.be>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:50055 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753678Ab2BUMc1 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 21 Feb 2012 07:32:27 -0500
Content-Disposition: inline
In-Reply-To: <20120214195615.GE29165@1984>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Feb 14, 2012 at 08:56:15PM +0100, Pablo Neira Ayuso wrote:
> > This patch is fine by me... Please apply.
> > 
> > Signed-off by: Bart De Schuymer <bdschuym@pandora.be>
> 
> I'd appreciate if you can send me a well-formed patch that I can
> easily apply, it's composed of:
> 
> 1) title
> 
> 2) description
> 
> 3) signed-off-by section
> 
> 4) patch
> 
> Thank you!

OK, you don't seem to make my life easy :-(

I have enqueued the following patch for the net tree:

commit 88ba136d6635b262f77cc418d536115fb8e4d4ab
Author: Joerg Willmann <joe@clnt.de>
Date:   Tue Feb 21 13:26:14 2012 +0100

    netfilter: ebtables: fix alignment problem in ppc

http://1984.lsi.us.es/git/net/log/?h=nf

Please, rise your hand if you find any problem with it. I'll pass it
soon to davem.
