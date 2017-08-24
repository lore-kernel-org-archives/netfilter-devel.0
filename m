From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [patch nf] netfilter: nf_tables: Fix nft limit burst handling
Date: Thu, 24 Aug 2017 16:23:07 +0200
Message-ID: <20170824142307.GA3591@salvia>
References: <1503344333-9953-1-git-send-email-azhou@ovn.org>
 <CAPWQB7E1wLt4vuWUt8i8aqu4myxtZ81yEd7-7NVhhgiaCreKrA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andy Zhou <azhou@ovn.org>, netfilter-devel@vger.kernel.org
To: Joe Stringer <joe@ovn.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ganesha.gnumonks.org ([213.95.27.120]:57659 "EHLO
        ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753203AbdHXOXc (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 24 Aug 2017 10:23:32 -0400
Content-Disposition: inline
In-Reply-To: <CAPWQB7E1wLt4vuWUt8i8aqu4myxtZ81yEd7-7NVhhgiaCreKrA@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Aug 21, 2017 at 02:29:13PM -0700, Joe Stringer wrote:
> On 21 August 2017 at 12:38, Andy Zhou <azhou@ovn.org> wrote:
> > Fixes: 96518518cc41 ("netfilter: add nftables")
> >
> > Current implementation treats the burst configuration the same as
> > rate configuration. This can cause the per packet cost to be lower
> > than configured. In effect, this bug causes the token bucket to be
> > refilled at a higher rate than what user has specified.
> >
> > This patch changes the implementation so that the token bucket size
> > is controlled by "rate + burst", while maintain the token bucket
> > refill rate the same as user specified.
> >
> > Signed-off-by: Andy Zhou <azhou@ovn.org>
> 
> Usually "Fixes" tag appears immediately above the signoff lines.
> 
> This is the bug that we brought up during NFWS this year in Faro, how
> the burst was not acting as a burst but rather it just added to the
> rate.
> 
> Acked-by: Joe Stringer <joe@ovn.org>

Applied, thanks a lot for this fix.
