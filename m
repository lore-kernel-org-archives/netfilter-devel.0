From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nft PATCH 2/2] masquerade: Complain if no prerouting chain
 exists
Date: Fri, 28 Apr 2017 16:58:01 +0200
Message-ID: <20170428145801.GA10616@salvia>
References: <20170427132439.9443-1-phil@nwl.cc>
 <20170427132439.9443-2-phil@nwl.cc>
 <CAOkSjBjdnywsFENgBLQfQr2aXMTDpU9ztXm_Y4V1==E61hH05g@mail.gmail.com>
 <20170428080523.GI20805@orbyte.nwl.cc>
 <CAOkSjBjtJ0_xymJ_iMuKwxtqArEh_dHs=Tgjo271PnLy4K84ng@mail.gmail.com>
 <20170428082824.GJ20805@orbyte.nwl.cc>
 <CAOkSjBi=oYsB2wDxq0-1ejaUrwrt+vRcAjCKO8f4RXv2=cqq=Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Phil Sutter <phil@nwl.cc>,
        Netfilter Development Mailing list
        <netfilter-devel@vger.kernel.org>
To: Arturo Borrero Gonzalez <arturo@debian.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:52496 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751249AbdD1O6G (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 28 Apr 2017 10:58:06 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 16545210564
        for <netfilter-devel@vger.kernel.org>; Fri, 28 Apr 2017 16:58:00 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 081B11850C
        for <netfilter-devel@vger.kernel.org>; Fri, 28 Apr 2017 16:58:00 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id E70F6FF2F1
        for <netfilter-devel@vger.kernel.org>; Fri, 28 Apr 2017 16:57:57 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <CAOkSjBi=oYsB2wDxq0-1ejaUrwrt+vRcAjCKO8f4RXv2=cqq=Q@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Apr 28, 2017 at 11:02:53AM +0200, Arturo Borrero Gonzalez wrote:
> On 28 April 2017 at 10:28, Phil Sutter <phil@nwl.cc> wrote:
[...]
> > Ah, thanks for the pointer! I tend to ignore anything that's not in the
> > man page. :)
> 
> Well, I guess adding more info to the man page won't hurt.
> 
> Things I would add:
>  * some bits about NAT chains configuration (this issue)
>  * info about base chains priorities
>  * some bits about atomic operations

Either we update the existing documentation (manpage and wiki) as
Arturo suggest or we add some sort of transparent automatic NAT chain
registration in the kernel.
