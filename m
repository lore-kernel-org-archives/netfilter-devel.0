From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: Snooping expected connections in a user CT helper
Date: Fri, 9 Sep 2016 12:47:55 +0200
Message-ID: <20160909104755.GA9943@salvia>
References: <CAJzqFtacjKi+zQT3nS_0UJAr=LD8RWumM5+jeo8bbi-OVZR0Jg@mail.gmail.com>
 <20160818011214.GA1463@salvia>
 <CAJzqFtaj3V2viTtNjhoG5zPsz0XkPXi9XULRwz1PGOe3imq_XA@mail.gmail.com>
 <20160823153610.GA10746@salvia>
 <CAJzqFtaRHOLUG=Fma+A_0gOe3E3AUzheK4x7_t-2e+eebrpZtg@mail.gmail.com>
 <CAJzqFtZ0TGb3HtFLRzWxrjN7Un0zz_ioWPEQx1SzVZF2urgEig@mail.gmail.com>
 <20160908221824.GA28289@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Kevin Cernekee <cernekee@chromium.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:56798 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751685AbcIIKr6 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 9 Sep 2016 06:47:58 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 49ED62EFEB6
        for <netfilter-devel@vger.kernel.org>; Fri,  9 Sep 2016 12:47:56 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 3BB891150AF
        for <netfilter-devel@vger.kernel.org>; Fri,  9 Sep 2016 12:47:56 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 2B303114D73
        for <netfilter-devel@vger.kernel.org>; Fri,  9 Sep 2016 12:47:54 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20160908221824.GA28289@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Sep 09, 2016 at 12:18:24AM +0200, Pablo Neira Ayuso wrote:
[...]
> > > 2) The timeout is not extended when there is activity on the
> > > expectation.  It would be good if it was extended any time there is
> > > new activity, in order to support long-lived subscriptions.
> 
> Actually, I thought permanent expectation has no timeout, but looking
> at the code it seems they do. I think it makes sense to refresh it or
> to keep it fixed, given that this depends on the master, it will just
> go away once the master is not there anymore.

Revisiting this: Actually, you are in control of the expectation time
too, so you can set a larger one given this is bound by the master
conntrack if you don't want to cook a patch to update this.

The question here is what are the reasonable timeouts to set, I guess
you can extract this from this application protocol behaviour or any
standard that document it.
