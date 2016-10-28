From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: reject statement - "crazy" parse error?
Date: Fri, 28 Oct 2016 11:11:20 +0200
Message-ID: <20161028091120.GA3374@salvia>
References: <aea0c58c-dd68-bffb-859c-81f77ebe8dfd@nurealm.net>
 <CAOkSjBjd6CwTcMv_G1p1KmWnQukHUn6f4oCoaeZHmXEyJDiW4g@mail.gmail.com>
 <5a8da546-8694-40b8-b514-1f80bff71a44@nurealm.net>
 <CAOkSjBgd0UJzg3Xp-ub4twebDmHdVJ25e5GkWEw5h2XUmQxKxQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: James Feeney <james@nurealm.net>,
        Netfilter Development Mailing list
        <netfilter-devel@vger.kernel.org>
To: Arturo Borrero Gonzalez <arturo@debian.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:38934 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1757842AbcJ1JLZ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 28 Oct 2016 05:11:25 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id E452326E08
        for <netfilter-devel@vger.kernel.org>; Fri, 28 Oct 2016 11:11:23 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id BDE1AB7FFF
        for <netfilter-devel@vger.kernel.org>; Fri, 28 Oct 2016 11:11:23 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 76398B7FFF
        for <netfilter-devel@vger.kernel.org>; Fri, 28 Oct 2016 11:11:21 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <CAOkSjBgd0UJzg3Xp-ub4twebDmHdVJ25e5GkWEw5h2XUmQxKxQ@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Oct 28, 2016 at 11:07:24AM +0200, Arturo Borrero Gonzalez wrote:
> On 26 October 2016 at 20:50, James Feeney <james@nurealm.net> wrote:
[...]
> > Well, that's not good, because something changed, from "No such file or
> > directory" to "Operation not supported", but it is still not right.  Of course,
> > in both cases, the error messages are "useless", not saying *what* file, and not
> > saying *what* operation.
> >
> 
> Yes, the error reporting in the 'nft -f' situation is something to improve,
> specially with kernel reported errors.
> This is even worse in the case of nested includes.

Just for the record: I have a patch to solve this. We need to augment
the netlink error reporting infrastructure, if I add this into the
netlink core (which is where this improved error reporting
infrastructure belongs) it may take a little while though, and a bit
of code in userspace.
