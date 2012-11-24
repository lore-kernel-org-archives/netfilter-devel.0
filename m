From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 1/2] netfilter: ipset: fix netiface set name overflow
Date: Sun, 25 Nov 2012 00:02:21 +0100
Message-ID: <20121124230221.GA15582@1984>
References: <1353583966-12402-1-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel <netfilter-devel@vger.kernel.org>,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:48103 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752577Ab2KXXC0 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 24 Nov 2012 18:02:26 -0500
Content-Disposition: inline
In-Reply-To: <1353583966-12402-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Nov 22, 2012 at 12:32:45PM +0100, Florian Westphal wrote:
> attribute is copied to IFNAMSIZ-size stack variable,
> but IFNAMSIZ is smaller than IPSET_MAXNAMELEN.
> 
> Fortunately nfnetlink needs CAP_NET_ADMIN.

Good. Applied, thanks Florian.
