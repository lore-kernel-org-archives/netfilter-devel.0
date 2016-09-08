From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: Snooping expected connections in a user CT helper
Date: Fri, 9 Sep 2016 00:18:24 +0200
Message-ID: <20160908221824.GA28289@salvia>
References: <CAJzqFtacjKi+zQT3nS_0UJAr=LD8RWumM5+jeo8bbi-OVZR0Jg@mail.gmail.com>
 <20160818011214.GA1463@salvia>
 <CAJzqFtaj3V2viTtNjhoG5zPsz0XkPXi9XULRwz1PGOe3imq_XA@mail.gmail.com>
 <20160823153610.GA10746@salvia>
 <CAJzqFtaRHOLUG=Fma+A_0gOe3E3AUzheK4x7_t-2e+eebrpZtg@mail.gmail.com>
 <CAJzqFtZ0TGb3HtFLRzWxrjN7Un0zz_ioWPEQx1SzVZF2urgEig@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Kevin Cernekee <cernekee@chromium.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:55028 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1757385AbcIHWSe (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 8 Sep 2016 18:18:34 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 8B2AB23166D
        for <netfilter-devel@vger.kernel.org>; Fri,  9 Sep 2016 00:18:31 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 77147100A6B
        for <netfilter-devel@vger.kernel.org>; Fri,  9 Sep 2016 00:18:31 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 63873100A57
        for <netfilter-devel@vger.kernel.org>; Fri,  9 Sep 2016 00:18:29 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <CAJzqFtZ0TGb3HtFLRzWxrjN7Un0zz_ioWPEQx1SzVZF2urgEig@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Kevin,

On Thu, Sep 08, 2016 at 03:02:13PM -0700, Kevin Cernekee wrote:
> On Thu, Sep 1, 2016 at 4:47 PM, Kevin Cernekee <cernekee@chromium.org> wrote:
> > The patch that I sent out last night is able to handle scenarios in
> > which the event occurs shortly after the subscription is established.
> > But in my testing I am noticing two other problems:
> >
> > 1) Approximately two minutes after the subscription is set up, the
> > expectation abruptly disappears.  This even happens if I set the
> > timeout to 3600; it shows up in `conntrack -L expect` until the time
> > column drops to ~3480, then it is gone.  This may be caused by the
> > master conntrack expiring.  Is there a way to set up the expectation
> > so that it persists for the entire timeout period?

Yes, the expectation goes away if the master is gone. You can set a
larger timeout for the master using -j CT --timeout timeout-policy and
the cttimeout infrastructure.

You have to set the helper and the timeout in one go, ie.

        -j CT --helper ssdp --timeout xyz

> > 2) The timeout is not extended when there is activity on the
> > expectation.  It would be good if it was extended any time there is
> > new activity, in order to support long-lived subscriptions.

Actually, I thought permanent expectation has no timeout, but looking
at the code it seems they do. I think it makes sense to refresh it or
to keep it fixed, given that this depends on the master, it will just
go away once the master is not there anymore.

> Friendly ping...
> 
> Do you think I'm on the right track with this approach, and if so,
> what is the best way to establish long-lived expectations for UPnP?

Yes, although I didn't look your code in deep, but I think you're on
the right track.

BTW, you may also want to explore enabling zero-copy in conntrackd
userspace helper (Eric Dumazet made a patch for nfqueue in 2013).

And you may need to cherry-pick b18bcb0019c to resolve an embarrasing
leak. Fell free to submit this to -stable and keep me on Cc.

Thanks!
