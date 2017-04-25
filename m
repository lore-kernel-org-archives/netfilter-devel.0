From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nft RFC PATCH] rule: introduce new option to print set elements
 per line
Date: Tue, 25 Apr 2017 12:15:19 +0200
Message-ID: <20170425101519.GA4535@salvia>
References: <149277062417.14594.14270713486442491994.stgit@nfdev2.cica.es>
 <20170425092229.GA3577@salvia>
 <CAOkSjBiEXbX9dOgRYu6Zyqmijc1DCksr1Zm7d+bcL+tNHZuyEg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Netfilter Development Mailing list
        <netfilter-devel@vger.kernel.org>, Florian Westphal <fw@strlen.de>
To: Arturo Borrero Gonzalez <arturo@debian.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:33136 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1429378AbdDYKPZ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 25 Apr 2017 06:15:25 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 2F7BABA6E2
        for <netfilter-devel@vger.kernel.org>; Tue, 25 Apr 2017 12:15:19 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 1FC87FF2D1
        for <netfilter-devel@vger.kernel.org>; Tue, 25 Apr 2017 12:15:19 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 0FD8DDA870
        for <netfilter-devel@vger.kernel.org>; Tue, 25 Apr 2017 12:15:16 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <CAOkSjBiEXbX9dOgRYu6Zyqmijc1DCksr1Zm7d+bcL+tNHZuyEg@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Apr 25, 2017 at 11:35:24AM +0200, Arturo Borrero Gonzalez wrote:
> On 25 April 2017 at 11:22, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > Hi Arturo,
> >
> > On Fri, Apr 21, 2017 at 12:30:24PM +0200, Arturo Borrero Gonzalez wrote:
> >> Add a new option to nft to print set elements per line instead
> >> of all in a single line.
> >> This is useful when printing a ruleset with very big sets.
> >>
> >> The new option is -t/--elements.
> >>
> >> Annonymous sets/maps/concats are not affected by this. The default
> >> behaviour is not changed.
> >>
> >> Example:
> >>
> >> % nft list ruleset -t -nn
> >> table ip t {
> >>       set s {
> >>               type inet_service
> >>               elements = { 1,
> >>                               2,
> >>                               3,
> >>                               4,
> >>                               12345 }
> >
> > Can we do a more intelligent folding? Via TIOCGWINSZ we can obtain the
> > number of columns so we can try to fit as many elements as possible
> > without wrapping around. Instead of one element per line? I know what
> > I'm asking is harder, but I would like that we explore this path
> > before adding this.
> >
> > And I think we should do this by default, no need for an option.
> > Unless you are a robot, you want an output that you can actually read
> > without lots of lines wrapping around, eg. a very large sets with
> > thousands of elements.
> 
> Ok, by default then.
> 
> Regarding a more intelligent output, the complexity increases quickly,
> since it would require to 'parse' the set before printing it (you
> know, knowing the element printed length, the terminal window size, et
> all). I guess that doing this right may slow down the output a lot,
> similar to what happens in math programs outputs (gnu octave).
> 
> What about an intermediate way?
> 
> if integers, print 4 o 5 per line.
> if maps, contactenations, IPs or strings, print one per line

Give a shot a let's see how this looks like.
