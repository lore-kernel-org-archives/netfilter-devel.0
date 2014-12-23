From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] netfilter: conntrack: adjust nf_conntrack_buckets
 default value
Date: Tue, 23 Dec 2014 14:16:54 +0100
Message-ID: <20141223131654.GA5353@salvia>
References: <7537ac022aea771d7af0aef2bd3bb30e5fa0a008.1417634768.git.mleitner@redhat.com>
 <20141204142613.1558e172@brouer.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Marcelo Ricardo Leitner <mleitner@redhat.com>,
	netfilter-devel@vger.kernel.org
To: Jesper Dangaard Brouer <netdev@brouer.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:59494 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754858AbaLWNOV (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 23 Dec 2014 08:14:21 -0500
Content-Disposition: inline
In-Reply-To: <20141204142613.1558e172@brouer.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Dec 04, 2014 at 02:26:13PM +0100, Jesper Dangaard Brouer wrote:
> On Wed,  3 Dec 2014 17:30:19 -0200
> Marcelo Ricardo Leitner <mleitner@redhat.com> wrote:
> 
> > Manually bumping either nf_conntrack_buckets or nf_conntrack_max has
> > become a common task as our Linux servers tend to serve more and more
> > clients/applications, so let's adjust nf_conntrack_buckets this to a
> > more updated value.
> > 
> > Now for systems with more than 4GB of memory, nf_conntrack_buckets
> > becomes 65536 instead of 16384, resulting in nf_conntrack_max=256k
> > entries.
> > 
> > Signed-off-by: Marcelo Ricardo Leitner <mleitner@redhat.com>
> > ---
> 
> It have been needed for a long time that we bumped this, e.g. TCP hash
> is bigger than our current ceil.
> 
> Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>

Applied to nf-next, thanks.
