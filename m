From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] Add a configure flag to link libc statically
Date: Mon, 16 Jan 2017 18:09:57 +0100
Message-ID: <20170116170957.GA12470@salvia>
References: <20161230054426.GA9694@juliacomputing.com>
 <20170116125759.GA25857@salvia>
 <CABV8kRwNRwGcREYxiD4Z1n2ki6p-2Ke1x0Xm9i4DQtSyE+1pxw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Keno Fischer <keno@juliacomputing.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:54304 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750866AbdAPRKI (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 16 Jan 2017 12:10:08 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 9AABA9B7E0
        for <netfilter-devel@vger.kernel.org>; Mon, 16 Jan 2017 18:10:06 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 8480AA7BF1
        for <netfilter-devel@vger.kernel.org>; Mon, 16 Jan 2017 18:10:06 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id A3017A7E99
        for <netfilter-devel@vger.kernel.org>; Mon, 16 Jan 2017 18:10:02 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <CABV8kRwNRwGcREYxiD4Z1n2ki6p-2Ke1x0Xm9i4DQtSyE+1pxw@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Jan 16, 2017 at 11:39:45AM -0500, Keno Fischer wrote:
[...]
> >> However, for my usage of iptables, I have never actually run into
> >> this situation, and even if I did, I'd rather switch libcs (though I
> >> may be in the minority there). Nevertheless, I think it would be
> >> useful to have this option available for those wanting a statically
> >> linked iptables.
> >
> > I'm trying to understand why you need this. Thanks.
> 
> I'm running docker in a stripped down security-enhanced context where
> everything is statically linked. Docker calls out to iptables to set
> up some firewall rules. So far I have not encountered it needing any
> of the code paths in iptables that would require the shared libraries
> from glibc at runtime. I'm also not the only person in this exact
> situation, e.g.:
> 
> https://github.com/vallinux/base/issues/14

Thanks for explaining.

It would be good if you can extend iptables building system to catch
up with glibc case by rejecting it. Another thing would be to add some
small documentation file on the tree that explains how to use this
with musl/ulibc.

My only concern about this new option is that people may believe this
works out of the box, and so far my impression is that this needs some
trickery.

I also wonder if everything is going to work fine with alternative
libc libraries, it would be good to run iptables tests (see
iptables-test.py) on this binary, you can edit the variable on that
script that points to the iptables binary to be tested.

Another alternative if the resulting patch is simple, probably we can
allow the override directive so you can easily append -all-static to
LDFLAGS at your own risk?

https://www.gnu.org/software/make/manual/make.html#Override-Directive
