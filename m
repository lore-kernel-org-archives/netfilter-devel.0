From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [conntrack-tools PATCH 4/4] conntrackd: introduce RequestResync
 option
Date: Mon, 1 May 2017 11:13:19 +0200
Message-ID: <20170501091319.GA2925@salvia>
References: <149270928083.1751.9498250834672625764.stgit@nfdev2.cica.es>
 <149270929676.1751.18425946182083865800.stgit@nfdev2.cica.es>
 <20170425113732.GB5355@salvia>
 <CAOkSjBiYGg76HichZbLkmyHyHTV3OPu3H7BqSE1ZJki0gh7pxA@mail.gmail.com>
 <20170425131843.GB1050@salvia>
 <CAOkSjBj3wqnCVMAfMek3NKbgbo35EjMQ842gOzgOpmH=qBu=6g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Netfilter Development Mailing list
        <netfilter-devel@vger.kernel.org>
To: Arturo Borrero Gonzalez <arturo@debian.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:52758 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1426069AbdEAJNc (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 1 May 2017 05:13:32 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id B68331F4B7F
        for <netfilter-devel@vger.kernel.org>; Mon,  1 May 2017 11:13:25 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 9A929DA90B
        for <netfilter-devel@vger.kernel.org>; Mon,  1 May 2017 11:13:25 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 87AFFA6D6
        for <netfilter-devel@vger.kernel.org>; Mon,  1 May 2017 11:13:23 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <CAOkSjBj3wqnCVMAfMek3NKbgbo35EjMQ842gOzgOpmH=qBu=6g@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Apr 26, 2017 at 01:32:38PM +0200, Arturo Borrero Gonzalez wrote:
> On 25 April 2017 at 15:18, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> >>
> >> Yes. The timer based approach is... timer based (async).
> >>
> >> It doesn't fit in an environment where you need to sync events as soon
> >> as they happen.
> >
> > IIRC the timer based works like this:
> >
> > 1) If event occurs, sync message is send.
> > 2) After some time, we send a message to tell the other peer the entry
> >    is still there.
> > 3) If no message is received, then the entry expires.
> >
> 
> the ALARM mode requires to commit the external cache instead of the
> conns being directly injected into the kernel.

You may want to disable the external cache with the alarm mode. The
alarm mode only needs the internal cache though, but that shouldn't be
much of a problem.

With the alarm mode, you will skip spikes in CPU consumption since
resync is expensive.  With a very large table, this results in some
sort of lazy busy polling.

> I think the new RequestResync method (or whatever other alternative)
> provides a good tradeoff between methods and increases general
> usefulness of conntrackd.

I'm trying to help here if I can give something better ;-)

Look, you should at least combine this new RequestResync with
CommitTimeout. Even if you don't explicitly request a commit command,
this sets the timeout for the entries that are pushed into the kernel.

So, if you set:

        RequestResync 30
        CommitTimeout 180

connections we don't get any information from for 180 seconds will
expire.

BTW, how are you measuring this improvement? Is that you get less logs
error messages that you reported before or so?

Thanks!
