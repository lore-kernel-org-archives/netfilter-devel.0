From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 1/2 nf] Revert "netfilter: conntrack: fix race in
 __nf_conntrack_confirm against get_next_corpse"
Date: Tue, 25 Nov 2014 19:59:35 +0100
Message-ID: <20141125185935.GA8800@salvia>
References: <1416870887-5285-1-git-send-email-pablo@netfilter.org>
 <20141125132629.28448018@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, dborkman@redhat.com,
	jp.pozzi@izzop.net, programme110@gmail.com
To: Jesper Dangaard Brouer <brouer@redhat.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:60859 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750780AbaKYS50 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 25 Nov 2014 13:57:26 -0500
Content-Disposition: inline
In-Reply-To: <20141125132629.28448018@redhat.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Nov 25, 2014 at 01:26:29PM +0100, Jesper Dangaard Brouer wrote:
> On Tue, 25 Nov 2014 00:14:46 +0100
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> 
> > This reverts commit 5195c14c8b27cc0b18220ddbf0e5ad3328a04187.
> > 
> > If the conntrack clashes with an existing one, it is left out of
> > the unconfirmed, thus, crashing when dropping the packet and
> > releasing the conntrack.
> > 
> > Reported-by: Daniel Borkmann <dborkman@redhat.com>
> > Fixes: https://bugzilla.kernel.org/show_bug.cgi?id=88841
> > Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> > ---
> > I prefer to revert the original fix and replace it by the follow up to
> > pass one single patch to -stable.
> 
> I'm fine with the revert.

No problem.

It would be great if I can get some feedback on the alternative I'm
proposing to resolve this (see patch 2/2 in this series).

Thanks.
