From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [ulogd2 PATCH] ulogd: use a RT scheduler by default
Date: Wed, 20 Sep 2017 10:54:04 +0200
Message-ID: <20170920085404.GB8896@salvia>
References: <150478421358.15825.13845813307098453243.stgit@nfdev2.cica.es>
 <CAOkSjBgKX2vzJeO90K8dsTJQOXiBf41Ti3r9wat9dyULs-eQgg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Netfilter Development Mailing list
        <netfilter-devel@vger.kernel.org>
To: Arturo Borrero Gonzalez <arturo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ganesha.gnumonks.org ([213.95.27.120]:53895 "EHLO
        ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751228AbdITIyI (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 20 Sep 2017 04:54:08 -0400
Content-Disposition: inline
In-Reply-To: <CAOkSjBgKX2vzJeO90K8dsTJQOXiBf41Ti3r9wat9dyULs-eQgg@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Sep 19, 2017 at 05:59:44PM +0200, Arturo Borrero Gonzalez wrote:
> On 7 September 2017 at 13:36, Arturo Borrero Gonzalez
> <arturo@netfilter.org> wrote:
> > Is common that ulogd runs in scenarios where a lot of packets are to be logged.
> > If there are more packets than ulogd can handle, users can start seing log
> > messages like this:
> >
> >  ulogd[556]: We are losing events. Please, consider using the clauses \
> >  `netlink_socket_buffer_size' and `netlink_socket_buffer_maxsize'
> >
> > Which means that Netlink buffer overrun have happened.
> > There are several approaches to prevent this situation:
> >
> >  * in the ruleset, limit the amount of packet queued for log
> >  * in the ruleset, instruct the kernel to use a queue-threshold
> >  * from userspace, increment Netlink buffer sizes
> >  * from userspace, configure ulogd to run as high priority process
> >
> > The first 3 method can be configured by users at runtime.
> > This patch deals with the last method. SCHED_RR is configured by default,
> > with no associated configuration parameter for users, since I believe
> > this is common enough, and should produce no harm.
> >
> > A similar approach is used in the conntrackd daemon.
> >
> > Signed-off-by: Arturo Borrero Gonzalez <arturo@netfilter.org>
> > ---
> >  src/ulogd.c |   15 +++++++++++++++
> >  1 file changed, 15 insertions(+)
> >
> 
> Eric did ACK this via IRC, please someone push the patch.

Just pushed it out, thanks.
