From: Thomas Graf <tgraf@suug.ch>
Subject: Re: [PATCH nf-next] netfilter: conntrack: add support for flextuples
Date: Mon, 4 May 2015 15:47:33 +0200
Message-ID: <20150504134733.GB1405@pox.localdomain>
References: <776b8819c85c83088478b933a35691133055347a.1430733932.git.daniel@iogearbox.net>
 <20150504103451.GA12200@salvia>
 <55475F13.1000304@iogearbox.net>
 <20150504130828.GA3607@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Daniel Borkmann <daniel@iogearbox.net>,
	netfilter-devel@vger.kernel.org,
	Madhu Challa <challa@noironetworks.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wi0-f173.google.com ([209.85.212.173]:35037 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751252AbbEDNrh (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 4 May 2015 09:47:37 -0400
Received: by widdi4 with SMTP id di4so122163893wid.0
        for <netfilter-devel@vger.kernel.org>; Mon, 04 May 2015 06:47:35 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20150504130828.GA3607@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 05/04/15 at 03:08pm, Pablo Neira Ayuso wrote:
> On Mon, May 04, 2015 at 01:59:15PM +0200, Daniel Borkmann wrote:
> > On 05/04/2015 12:34 PM, Pablo Neira Ayuso wrote:
> > >So, it's the skb->mark that survives between the containers.  I'm not
> > >sure it makes sense to keep a zone 0 from the container that performs
> > >SNAT. Instead, we can probably restore the zone based on the
> > >skb->mark. The problem is that the existing zone is u16. In nftables,
> > >Patrick already mentioned about supporting casting so we can do
> > >something like:
> > >
> > >         ct zone set (u16)meta mark
> > >
> > >So you can reserve a part of the skb->mark to map it to the zone. I'm
> > >not very convinced about this.
> > 
> > Thanks for the feedback! I'm not yet sure though, I understood the
> > above suggestion to the described problem fully so far, i.e. how
> > would replies on the SNAT find the correct zone again?
> 
> From the original direction, you can set the zone based on the mark:
> 
>         -m mark --mark 1 -j CT --zone 1
> 
> Then, from the reply direction, you can restore it:
> 
>         -m conntrack --ctzone 1 -j MARK --set-mark 1
>         ...
> 
> --ctzone is not supported though, it would need a new revision for the
> conntrack match.

Given that the multiple source zones which talk to a common
destination zone may have conflicting IPs, the SNAT must either
occur in the source zone where the source address is still unique
or the CT tuple must be made unique with a source zone identifier
so that the SNAT can occur in the destination zone.

Doing the SNAT in the source zone requires to use a unique IP pool
to map to for each source zone as otherwise IP sources may clash again
in the destination zone. We obviously can't do --SNAT -to 10.1.1.1 in
two namespaces and then just route into a third namespace. This
approach is not scalable in a container environment with 100s or even
1000s of containers each in its own network namespace.

What we want to do instead is to do the SNAT in the destination zone
where we can have a single SNAT rule which overs all source zones.
This allows inter namespace communication in a /31 with minimal waste
of addresses.
