From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 0/8] ipset patches
Date: Tue, 17 Jan 2012 00:16:01 +0100
Message-ID: <20120116231601.GA18087@1984>
References: <1326559141-26783-1-git-send-email-kadlec@blackhole.kfki.hu>
 <20120116124559.GB13131@1984>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, Patrick McHardy <kaber@trash.net>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:45347 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751564Ab2APXQE (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 16 Jan 2012 18:16:04 -0500
Content-Disposition: inline
In-Reply-To: <20120116124559.GB13131@1984>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Looking at this again:

On Mon, Jan 16, 2012 at 01:45:59PM +0100, Pablo Neira Ayuso wrote:
> > Jan Engelhardt (3):
> >   netfilter: ipset: use NFPROTO_ constants
> >   netfilter: ipset: avoid use of kernel-only types
> >   netfilter: ipset: expose userspace-relevant parts in ip_set.h
> > 
> > Jozsef Kadlecsik (5):
> >   netfilter: ipset: Autoload set type modules safely
> >   netfilter: ipset: Dumping error triggered removing references twice
> >   netfilter: ipset: Log warning when a hash type of set gets full
> >   netfilter: ipset: Exceptions support added to hash:*net* types
> >   netfilter: ipset: hash:net,iface timeout bug fixed

If you tell me what patches are bugfixes, we can still pass them to
get them included into 3.3-rc.

Enhancements will have to go to net-next.
