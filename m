From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nft PATCH 2/3] src: add xt compat support
Date: Fri, 27 Mar 2015 14:13:54 +0100
Message-ID: <20150327131354.GA11617@salvia>
References: <20150325191556.13491.88761.stgit@nfdev2.cica.es>
 <20150325191602.13491.63370.stgit@nfdev2.cica.es>
 <20150325194441.GA26737@salvia>
 <CAOkSjBivwzs8X+y1PRqG8-hg4b-0QQ_NXfJ38YoT9V05vt7Bag@mail.gmail.com>
 <20150327123139.GA10614@salvia>
 <CAOkSjBivXDdt7S4=iPVJT0cubNFML2UeBgRQjecSr_XucDYDAg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>,
	Patrick McHardy <kaber@trash.net>
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:46361 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752310AbbC0NJ4 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 27 Mar 2015 09:09:56 -0400
Content-Disposition: inline
In-Reply-To: <CAOkSjBivXDdt7S4=iPVJT0cubNFML2UeBgRQjecSr_XucDYDAg@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Mar 27, 2015 at 01:59:31PM +0100, Arturo Borrero Gonzalez wrote:
> On 27 March 2015 at 13:31, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > On Fri, Mar 27, 2015 at 01:00:37PM +0100, Arturo Borrero Gonzalez wrote:
> >> On 25 March 2015 at 20:44, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> >> > On Wed, Mar 25, 2015 at 08:16:02PM +0100, Arturo Borrero Gonzalez wrote:
> >> >> diff --git a/include/xt.h b/include/xt.h
> >> >> new file mode 100644
> >> >> index 0000000..414f3d1
> >> >> --- /dev/null
> >> >> +++ b/include/xt.h
> >> >> @@ -0,0 +1,100 @@
> >> >> +#ifndef _NFT_XT_H_
> >> >> +#define _NFT_XT_H_
> >> >> +
> >> >> +#include <arpa/inet.h>
> >> >> +#include <netinet/in.h>
> >> >> +#include <limits.h>
> >> >> +#include <net/if.h>
> >> >> +#include <net/ethernet.h>
> >> >> +
> >> >> +struct netlink_linearize_ctx;
> >> >> +struct netlink_parse_ctx;
> >> >> +struct nft_rule_expr;
> >> >> +struct rule_pp_ctx;
> >> >> +struct rule;
> >> >> +
> >> >> +#ifdef HAVE_LIBXTABLES
> >> >> +
> >> >> +#include <linux/netfilter_ipv4/ip_tables.h>
> >> >> +#include <linux/netfilter_ipv6/ip6_tables.h>
> >> >> +#include <linux/netfilter_arp/arp_tables.h>
> >> >> +
> >> >> +/* Fake ebt_entry */
> >> >> +struct ebt_entry {
> >> >
> >> > I think you can avoid this if you:
> >> >
> >> > #include <linux/netfilter_bridge/ebtables.h>
> >> >
> >>
> >> Can't include <linux/netfilter_bridge/ebtables.h> because it includes
> >> <linux/if.h> and clash with <net/if.h>
> >
> > There must be a clean way to fix this without embedding the ebt_entry
> > structure.
> >
> 
> We seem to have the same problem in ebtables-compat:
> 
> http://git.netfilter.org/iptables/tree/iptables/nft-bridge.h#n32

Try to find a way to fix it there too ;-)
