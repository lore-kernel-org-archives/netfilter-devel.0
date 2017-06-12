From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [conntrack-tools PATCH 2/4] conntrackd: make the daemon run in
 RT mode by default
Date: Mon, 12 Jun 2017 10:15:52 +0200
Message-ID: <20170612081552.GA2723@salvia>
References: <149674670719.18546.7841033150308352826.stgit@nfdev2.cica.es>
 <149674671245.18546.17167682826049346258.stgit@nfdev2.cica.es>
 <20170606111040.GA1839@salvia>
 <CAOkSjBiav4tXaBVt5X5zQHkv_pX=Fyv8EjhHxfit+1vSskS2=Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Netfilter Development Mailing list
        <netfilter-devel@vger.kernel.org>
To: Arturo Borrero Gonzalez <arturo@debian.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ganesha.gnumonks.org ([213.95.27.120]:56368 "EHLO
        ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751930AbdFLIP4 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 12 Jun 2017 04:15:56 -0400
Content-Disposition: inline
In-Reply-To: <CAOkSjBiav4tXaBVt5X5zQHkv_pX=Fyv8EjhHxfit+1vSskS2=Q@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Jun 07, 2017 at 10:53:53PM +0200, Arturo Borrero Gonzalez wrote:
> On 6 June 2017 at 13:10, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> >
> > But I think we should keep the Nice and Scheduler clauses. Just in
> > case anyone wants to do this fine grain tunning.
> >
> 
> The nice value can be changed at runtime externally: using the
> nice/renice commands
> Perhaps is a bit redundant to have it included in the conntrackd code.
> Also, nice values are somehow overridden by either SCHED_RR (our
> default) or SCHED_FIFO.
> Not sure if it makes sense to run in RT and then lower priority by
> means of nice.
> 
> I'm tempted to just remove the nice thing in v2, what do you think?

Nice and Sched overlap, yes.

So we can just deprecate Nice and still keep Sched around.

Fine with this?
