From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nf_tables PATCH v4 1/5] netfilter: nft_nat: include a flag
 attribute
Date: Tue, 9 Sep 2014 13:08:12 +0200
Message-ID: <20140909110812.GA13907@salvia>
References: <20140904120518.5971.77791.stgit@nfdev.cica.es>
 <20140909095003.GA9128@salvia>
 <CAOkSjBj3e+MFFhtvMOD7cSWHekk_E7s-tJa0SJ80ARWN7EcnGA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>,
	Patrick McHardy <kaber@trash.net>
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:59281 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752466AbaIILHS (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 9 Sep 2014 07:07:18 -0400
Content-Disposition: inline
In-Reply-To: <CAOkSjBj3e+MFFhtvMOD7cSWHekk_E7s-tJa0SJ80ARWN7EcnGA@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Sep 09, 2014 at 12:14:25PM +0200, Arturo Borrero Gonzalez wrote:
> On 9 September 2014 11:50, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > On Thu, Sep 04, 2014 at 02:06:14PM +0200, Arturo Borrero Gonzalez wrote:
> >> Both SNAT and DNAT (and the upcoming masquerade) can have additional
> >> configuration parameters, such as port randomization or NAT addressing
> >> persistence.
> >> We can cover these scenarios by simply adding a flag attribute for
> >> userspace to fill when needed.
> >>
> >> The flags to use are defined in include/uapi/linux/netfilter/nf_nat.h,
> >>  NF_NAT_RANGE_MAP_IPS
> >>  NF_NAT_RANGE_PROTO_SPECIFIED
> >>  NF_NAT_RANGE_PROTO_RANDOM
> >>  NF_NAT_RANGE_PERSISTENT
> >>  NF_NAT_RANGE_PROTO_RANDOM_FULLY
> >>  NF_NAT_RANGE_PROTO_RANDOM_ALL
> >>
> >> The caller must take care of not messing up with the flags, as they are
> >> added unconditionally to the final resulting nf_nat_range.
> >
> > Not sure this comment is relevant. Of course, userspace should select
> > the flags accordingly :-). Let me know if the intention was other than
> > insisting on the fact that the flags alter the way the NAT is done.
> >
> 
> Yes, I meant that no additional check is done to know if the flags
> combination makes sense.

I see. iptables does exactly the same thing at this moment. At quick
glance I think random flag combinations should not puzzle
nf_nat_setup_info(), but it would be good to give it a closer look.

