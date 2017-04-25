From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nft RFC PATCH] rule: introduce new option to print set elements
 per line
Date: Tue, 25 Apr 2017 12:15:33 +0200
Message-ID: <20170425101533.GB4535@salvia>
References: <149277062417.14594.14270713486442491994.stgit@nfdev2.cica.es>
 <20170425092229.GA3577@salvia>
 <CAOkSjBiEXbX9dOgRYu6Zyqmijc1DCksr1Zm7d+bcL+tNHZuyEg@mail.gmail.com>
 <20170425094410.GA11322@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Arturo Borrero Gonzalez <arturo@debian.org>,
        Netfilter Development Mailing list
        <netfilter-devel@vger.kernel.org>
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:33312 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1429371AbdDYKPm (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 25 Apr 2017 06:15:42 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 97B20BA6FB
        for <netfilter-devel@vger.kernel.org>; Tue, 25 Apr 2017 12:15:36 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 8805DDA725
        for <netfilter-devel@vger.kernel.org>; Tue, 25 Apr 2017 12:15:36 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 13949FF2D9
        for <netfilter-devel@vger.kernel.org>; Tue, 25 Apr 2017 12:15:34 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20170425094410.GA11322@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Apr 25, 2017 at 11:44:10AM +0200, Florian Westphal wrote:
> Arturo Borrero Gonzalez <arturo@debian.org> wrote:
> [ pretty printing for nft set/maps ]
> 
> > What about an intermediate way?
> > 
> > if integers, print 4 o 5 per line.
> > if maps, contactenations, IPs or strings, print one per line
> 
> Sounds great to me, we can add the more complex versions later
> if someone wants (to write) it.

Agreed.
