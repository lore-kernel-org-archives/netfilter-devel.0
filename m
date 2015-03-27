From: Patrick McHardy <kaber@trash.net>
Subject: Re: [nft PATCH 2/3] src: add xt compat support
Date: Fri, 27 Mar 2015 13:14:11 +0000
Message-ID: <20150327131411.GA3001@acer.localdomain>
References: <20150325191556.13491.88761.stgit@nfdev2.cica.es>
 <20150325191602.13491.63370.stgit@nfdev2.cica.es>
 <20150325194441.GA26737@salvia>
 <CAOkSjBivwzs8X+y1PRqG8-hg4b-0QQ_NXfJ38YoT9V05vt7Bag@mail.gmail.com>
 <20150327123139.GA10614@salvia>
 <CAOkSjBivXDdt7S4=iPVJT0cubNFML2UeBgRQjecSr_XucDYDAg@mail.gmail.com>
 <20150327131354.GA11617@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>,
	Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:35077 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752214AbbC0NOQ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 27 Mar 2015 09:14:16 -0400
Content-Disposition: inline
In-Reply-To: <20150327131354.GA11617@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 27.03, Pablo Neira Ayuso wrote:
> On Fri, Mar 27, 2015 at 01:59:31PM +0100, Arturo Borrero Gonzalez wrote:
> > >> >> index 0000000..414f3d1
> > >> >> --- /dev/null
> > >> >> +++ b/include/xt.h
> > >> >> @@ -0,0 +1,100 @@
> > >> >> +#ifndef _NFT_XT_H_
> > >> >> +#define _NFT_XT_H_
> > >> >> +
> > >> >> +#include <net/if.h>
> > >> >> +
> > >> >> +/* Fake ebt_entry */
> > >> >> +struct ebt_entry {
> > >> >
> > >> > I think you can avoid this if you:
> > >> >
> > >> > #include <linux/netfilter_bridge/ebtables.h>
> > >>
> > >> Can't include <linux/netfilter_bridge/ebtables.h> because it includes
> > >> <linux/if.h> and clash with <net/if.h>
> > >
> > > There must be a clean way to fix this without embedding the ebt_entry
> > > structure.
> > 
> > We seem to have the same problem in ebtables-compat:
> > 
> > http://git.netfilter.org/iptables/tree/iptables/nft-bridge.h#n32
> 
> Try to find a way to fix it there too ;-)

Can't we switch to the linux includes? We're Linux only anyways :)
