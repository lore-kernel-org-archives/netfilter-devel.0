From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] netfilter: fix ->nfnl NULL oops
Date: Tue, 22 Nov 2011 00:42:30 +0100
Message-ID: <20111121234230.GA13996@1984>
References: <20111108221634.GA13261@p183.telecom.by>
 <20111109143423.GA24158@1984>
 <20111115095642.GA28944@1984>
 <61996646E807F2E67842E57F@nimrod.local>
 <20111121233942.GA13815@1984>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Alexey Dobriyan <adobriyan@gmail.com>, kaber@trash.net,
	netfilter-devel@vger.kernel.org
To: Alex Bligh <alex@alex.org.uk>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:45363 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752805Ab1KUXmg (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 21 Nov 2011 18:42:36 -0500
Content-Disposition: inline
In-Reply-To: <20111121233942.GA13815@1984>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Nov 22, 2011 at 12:39:42AM +0100, Pablo Neira Ayuso wrote:
> I've been testing the patch that I proposed with this recipe, now it
> works fine.
> 
> I'll pass my patch for 3.2-rc soon, in case you want to make further
> testing of it.

the patch is applied to my nf branch, btw:

http://1984.lsi.us.es/git/?p=net/.git;a=shortlog;h=refs/heads/nf
