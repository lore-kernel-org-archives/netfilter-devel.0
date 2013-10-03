From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [iptables-nftables PATCH 0/3] NFPROTO_ARP and arp mangle target
 support (+ one minor fix)
Date: Thu, 3 Oct 2013 11:23:59 +0200
Message-ID: <20131003092359.GA14246@localhost>
References: <1378453910-17954-1-git-send-email-tomasz.bursztyka@linux.intel.com>
 <524D2A2B.1010507@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:47227 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752347Ab3JCJYG (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 3 Oct 2013 05:24:06 -0400
Content-Disposition: inline
In-Reply-To: <524D2A2B.1010507@linux.intel.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Oct 03, 2013 at 11:26:19AM +0300, Tomasz Bursztyka wrote:
> Hi,
> 
> @Pablo: I understand that patch 2 is not necessary, but what about
> patch 3? This one is relevant to get xtables-arp being able to
> handle mangle target.
> Or is there any issue with it?

Please, rename it to libxt_mangle.c and restrict its usage to the
NFPROTO_ARP family. With this change, I think we can skip patch 2, I'm
reticent to bloat our build system to support libarp_ prefix, it's
just one single extension after all.

Let me know if you have any issue, thanks.

> >This patchset prepares for arptables-nftables to be included so it will use libxtables for its target.
> >
> >Tomasz Bursztyka (3):
> >   nft: Fix a minor compilation warning
> >   libxtables: Add NFPROTO_ARP support for libarpt_* prefixed extensions
> >   libxtables: Port libarptc mangle target into libxtables
> >
> >  configure.ac                              |   5 +
> >  extensions/GNUmakefile.in                 |  52 +++-
> >  extensions/libarpt_mangle.c               | 388 ++++++++++++++++++++++++++++++
> >  include/linux/netfilter_arp.h             |  19 ++
> >  include/linux/netfilter_arp/arp_tables.h  | 204 ++++++++++++++++
> >  include/linux/netfilter_arp/arpt_mangle.h |  26 ++
> >  iptables/nft-shared.c                     |   2 +-
> >  libxtables/xtables.c                      |  14 ++
> >  8 files changed, 701 insertions(+), 9 deletions(-)
> >  create mode 100644 extensions/libarpt_mangle.c
> >  create mode 100644 include/linux/netfilter_arp.h
> >  create mode 100644 include/linux/netfilter_arp/arp_tables.h
> >  create mode 100644 include/linux/netfilter_arp/arpt_mangle.h
> >
> 
