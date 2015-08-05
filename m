From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next v3 1/3] netfilter: nf_conntrack: push zone object
 into functions
Date: Wed, 5 Aug 2015 12:51:26 +0200
Message-ID: <20150805105126.GA3996@salvia>
References: <cover.1437561897.git.daniel@iogearbox.net>
 <2f95183cf2520b93d8443be935372fbef3499b96.1437561897.git.daniel@iogearbox.net>
 <20150730160744.GA15008@salvia>
 <55BA5228.6050908@iogearbox.net>
 <20150803155909.GA17212@salvia>
 <55BF9023.3050505@iogearbox.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tgraf@suug.ch, challa@noironetworks.com,
	netfilter-devel@vger.kernel.org
To: Daniel Borkmann <daniel@iogearbox.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:39533 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751834AbbHEKpX (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 5 Aug 2015 06:45:23 -0400
Content-Disposition: inline
In-Reply-To: <55BF9023.3050505@iogearbox.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Aug 03, 2015 at 06:00:35PM +0200, Daniel Borkmann wrote:
> On 08/03/2015 05:59 PM, Pablo Neira Ayuso wrote:
> >On Thu, Jul 30, 2015 at 06:34:48PM +0200, Daniel Borkmann wrote:
> >>CTA_ZONE_DIR seems better, sure. I don't have any other extensions at
> >>the moment, but it seems it makes sense to make this nested at this
> >>point in time, so we have CTA_ZONE and CTA_ZONE_INFO as a container
> >>for CTA_ZONE_DIR and whatever future might bring. I will look into it.
> >
> >thinking it well, this is part of the tuple, so I'd suggest you add
> >CTA_TUPLE_ZONE to enum ctattr_tuple. We will probably need later to
> >place each tuple in different zones.
> 
> That's fine with me, will do after your tree rebase.

Just pushed out a fresh copy with net-next into nf-next.

Daniel, a minor change that I came up with. With your patchset, the
configurations that we accept look like:

        zone original=Value     reply=0
        zone original=0         reply=Value

But thinking on Thomas' requirements to limit the number of conntracks
per zone, I think another valid configuration (and more generic) can
be:

        zone original=ValueX    reply=ValueY

So we don't assume that the original or reply zone is always zero.

The zone extension are that look like this:

struct nf_conntrack_zone {
        u16     id[IP_CT_DIR_MAX];
};

And we don't need to store the direction. To keep backward
compatibility we can set the id in both directions to the same value.

Can you see any problem with this approach? I think it should require
just a little adjustment to you patchset. Thanks.
