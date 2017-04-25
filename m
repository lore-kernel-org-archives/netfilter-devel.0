From: Florian Westphal <fw@strlen.de>
Subject: Re: [nft RFC PATCH] rule: introduce new option to print set elements
 per line
Date: Tue, 25 Apr 2017 11:44:10 +0200
Message-ID: <20170425094410.GA11322@breakpoint.cc>
References: <149277062417.14594.14270713486442491994.stgit@nfdev2.cica.es>
 <20170425092229.GA3577@salvia>
 <CAOkSjBiEXbX9dOgRYu6Zyqmijc1DCksr1Zm7d+bcL+tNHZuyEg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
        Netfilter Development Mailing list
        <netfilter-devel@vger.kernel.org>, Florian Westphal <fw@strlen.de>
To: Arturo Borrero Gonzalez <arturo@debian.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:47884 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1946227AbdDYJoW (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 25 Apr 2017 05:44:22 -0400
Content-Disposition: inline
In-Reply-To: <CAOkSjBiEXbX9dOgRYu6Zyqmijc1DCksr1Zm7d+bcL+tNHZuyEg@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Arturo Borrero Gonzalez <arturo@debian.org> wrote:
[ pretty printing for nft set/maps ]

> What about an intermediate way?
> 
> if integers, print 4 o 5 per line.
> if maps, contactenations, IPs or strings, print one per line

Sounds great to me, we can add the more complex versions later
if someone wants (to write) it.
