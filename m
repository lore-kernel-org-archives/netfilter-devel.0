From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [kernel PATCH] uapi: ebtables: don't include linux/if.h
Date: Mon, 13 Apr 2015 20:10:00 +0200
Message-ID: <20150413181000.GA3461@salvia>
References: <20150408174140.25208.67942.stgit@nfdev2.cica.es>
 <20150408175940.GA5358@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, kaber@trash.net
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:57356 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751084AbbDMSFn (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 13 Apr 2015 14:05:43 -0400
Content-Disposition: inline
In-Reply-To: <20150408175940.GA5358@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Apr 08, 2015 at 07:59:40PM +0200, Pablo Neira Ayuso wrote:
> On Wed, Apr 08, 2015 at 07:41:40PM +0200, Arturo Borrero Gonzalez wrote:
> > From: Pablo Neira Ayuso <pablo@netfilter.org>
> > 
> > linux/if.h creates conflicts in userspace with net/if.h
> > 
> > By using it here we force userspace to use linux/if.h while
> > net/if.h may be needed.
> 
> I'm going to add here that:
> 
> include/linux/netfilter_ipv4/ip_tables.h and
> include/linux/netfilter_ipv6/ip6_tables.h
> 
> don't include linux/if.h and they also refer to IFNAMSIZ, so they are
> expecting userspace to include use net/if.h from the client program.

Applied, thanks Arturo.
