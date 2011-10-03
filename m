From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] netfilter: nf_conntrack_proto_gre: only create ct
 assured event once
Date: Mon, 3 Oct 2011 12:47:57 +0200
Message-ID: <20111003104757.GA16052@1984>
References: <1317393509-11078-1-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, denys@visp.net.lb
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:55283 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752515Ab1JCKsG (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 3 Oct 2011 06:48:06 -0400
Content-Disposition: inline
In-Reply-To: <1317393509-11078-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Sep 30, 2011 at 04:38:29PM +0200, Florian Westphal wrote:
> GRE connections cause ctnetlink event flood due to ASSURED event
> being created for every packet received.
> 
> Reported-and-tested-by: Denys Fedoryshchenko <denys@visp.net.lb>
> Signed-off-by: Florian Westphal <fw@strlen.de>

http://1984.lsi.us.es/git/?p=net/.git;a=shortlog;h=refs/heads/nf

Applied to my nf branch, thanks.
