From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nftables] Git location for User space utilities
Date: Mon, 25 Mar 2013 16:54:46 +0100
Message-ID: <20130325155445.GA15956@localhost>
References: <CACd6PL04YMafbQb6uV6OKZJWrD_jJe3DZmin9oGmhBbdx6Wgcw@mail.gmail.com>
 <CACd6PL1G_ELCNe1EnF7jR9fVGVCjFcKb0Cwcx_y6oP5EVFf9Fg@mail.gmail.com>
 <514FF870.1010401@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Vidya Chowdary <vidya.chowdary@gmail.com>,
	netfilter-devel@vger.kernel.org
To: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:54055 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758527Ab3CYPyw (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 25 Mar 2013 11:54:52 -0400
Content-Disposition: inline
In-Reply-To: <514FF870.1010401@linux.intel.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Mar 25, 2013 at 09:10:40AM +0200, Tomasz Bursztyka wrote:
> Hi,
> 
> >  http://1984.lsi.us.es/git/nftables/
> >git://git.netfilter.org/libnl-nft.git
> >git://git.netfilter.org/nftables.git
> >
> >Please confirm if above location remains intact or should I fork from some
> >other git repository for user space and libnl enhancements.
> 
> These are the right one indeed.
> 
> There is also a repository for a backward compatible tool with
> iptables: http://1984.lsi.us.es/git/iptables-nftables/
> and the necessary library: http://1984.lsi.us.es/git/libnftables/

To extend this information, these two are now available through:

git clone git://git.netfilter.org/iptables-nftables/
git clone git://git.netfilter.org/libnftable/

Also through netfilter's cgit. I'll keep the 1984.lsi.us.es
repositories for a while, they are mirroring git.netfilter.org now.

Regards.
