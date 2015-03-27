From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nft PATCH 2/3] src: add xt compat support
Date: Fri, 27 Mar 2015 13:31:39 +0100
Message-ID: <20150327123139.GA10614@salvia>
References: <20150325191556.13491.88761.stgit@nfdev2.cica.es>
 <20150325191602.13491.63370.stgit@nfdev2.cica.es>
 <20150325194441.GA26737@salvia>
 <CAOkSjBivwzs8X+y1PRqG8-hg4b-0QQ_NXfJ38YoT9V05vt7Bag@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>,
	Patrick McHardy <kaber@trash.net>
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:60730 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932066AbbC0M1o (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 27 Mar 2015 08:27:44 -0400
Content-Disposition: inline
In-Reply-To: <CAOkSjBivwzs8X+y1PRqG8-hg4b-0QQ_NXfJ38YoT9V05vt7Bag@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Mar 27, 2015 at 01:00:37PM +0100, Arturo Borrero Gonzalez wrote:
> On 25 March 2015 at 20:44, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > On Wed, Mar 25, 2015 at 08:16:02PM +0100, Arturo Borrero Gonzalez wrote:
> >> diff --git a/include/xt.h b/include/xt.h
> >> new file mode 100644
> >> index 0000000..414f3d1
> >> --- /dev/null
> >> +++ b/include/xt.h
> >> @@ -0,0 +1,100 @@
> >> +#ifndef _NFT_XT_H_
> >> +#define _NFT_XT_H_
> >> +
> >> +#include <arpa/inet.h>
> >> +#include <netinet/in.h>
> >> +#include <limits.h>
> >> +#include <net/if.h>
> >> +#include <net/ethernet.h>
> >> +
> >> +struct netlink_linearize_ctx;
> >> +struct netlink_parse_ctx;
> >> +struct nft_rule_expr;
> >> +struct rule_pp_ctx;
> >> +struct rule;
> >> +
> >> +#ifdef HAVE_LIBXTABLES
> >> +
> >> +#include <linux/netfilter_ipv4/ip_tables.h>
> >> +#include <linux/netfilter_ipv6/ip6_tables.h>
> >> +#include <linux/netfilter_arp/arp_tables.h>
> >> +
> >> +/* Fake ebt_entry */
> >> +struct ebt_entry {
> >
> > I think you can avoid this if you:
> >
> > #include <linux/netfilter_bridge/ebtables.h>
> >
> 
> Can't include <linux/netfilter_bridge/ebtables.h> because it includes
> <linux/if.h> and clash with <net/if.h>

There must be a clean way to fix this without embedding the ebt_entry
structure.

> I will put a comment in the code.
> 
> >
> >> +                                    struct stmt *stmt, struct rule *rule) {}
> >> +
> >> +#endif /* HAVE_LIBXTABLES */
> >> +
> >> +#endif /* _NFT_XT_H_ */
> >> +xt_opts                      :       /* empty */     { $$ = NULL; }
> >> +                     |       XTOPTS          { $$ = $1; }
> >> +                     ;
> >> +
> >> +xt_name                      :       STRING          { $$ = $1; }
> >> +                     |       STATE           { $$ = xstrdup("state"); }
> >> +                     |       COMMENT         { $$ = xstrdup("comment"); }
> >> +                     |       AH              { $$ = xstrdup("ah"); }
> >> +                     |       ESP             { $$ = xstrdup("esp"); }
> >> +                     |       TCP             { $$ = xstrdup("tcp"); }
> >> +                     |       UDP             { $$ = xstrdup("udp"); }
> >> +                     |       UDPLITE         { $$ = xstrdup("udplite"); }
> >> +                     |       SCTP            { $$ = xstrdup("sctp"); }
> >> +                     |       ICMP            { $$ = xstrdup("icmp"); }
> >> +                     |       IP              { $$ = xstrdup("ip"); }
> >> +                     |       VLAN            { $$ = xstrdup("vlan"); }
> >> +                     |       LOG             { $$ = xstrdup("log"); }
> >> +                     |       _802_3          { $$ = xstrdup("802_3"); }
> >
> > This _802_3 should not be clashing with anything else, the problem is
> > somewhere else.
> >
> 
> % sudo nft add rule bridge filter FORWARD xt match 802_3 [--802_3-sap 0x01  ]
> <cmdline>:1:41-43: Error: syntax error, unexpected number
> add rule bridge filter FORWARD xt match 802_3 [--802_3-sap 0x01 ]
>                                         ^^^
> 
> I have to admit I don't know where to look. Do you have any hint?

I know see the problem, the scanner doesn't consider that a string can
start by a number, we have a similar problem with the expiration time.
Well, I would keep it there until we find a better solution. Please,
check if we have more extensions with this pattern.

Thanks Arturo.
