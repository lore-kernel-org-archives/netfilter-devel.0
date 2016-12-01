From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [RFC nft PATCH] tests: shell: add a basic scapy test
Date: Thu, 1 Dec 2016 17:52:59 +0100
Message-ID: <20161201165259.GA30607@salvia>
References: <148049874652.26121.17744801893432354214.stgit@nfdev2.cica.es>
 <20161130182704.GA7892@salvia>
 <20161130182801.GB7892@salvia>
 <CAOkSjBibmjB6Uo2z9Wx1+tfkpO=eY1vY2_79qXN+TEB_tvPcEA@mail.gmail.com>
 <20161201104535.GA13152@salvia>
 <CAOkSjBjnKTk14-32+5faKsJG3CMARrywZ2814o1L2cC5Mj2TOQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Netfilter Development Mailing list
        <netfilter-devel@vger.kernel.org>,
        Shivani Bhardwaj <shivanib134@gmail.com>
To: Arturo Borrero Gonzalez <arturo@debian.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:42642 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751364AbcLAQxE (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 1 Dec 2016 11:53:04 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id F1D478CD8F
        for <netfilter-devel@vger.kernel.org>; Thu,  1 Dec 2016 17:53:02 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id E41D0A0FD8
        for <netfilter-devel@vger.kernel.org>; Thu,  1 Dec 2016 17:53:02 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id C73ADA0FC4
        for <netfilter-devel@vger.kernel.org>; Thu,  1 Dec 2016 17:53:00 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <CAOkSjBjnKTk14-32+5faKsJG3CMARrywZ2814o1L2cC5Mj2TOQ@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Dec 01, 2016 at 04:05:07PM +0100, Arturo Borrero Gonzalez wrote:
> On 1 December 2016 at 11:45, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > I mean, it would be good if you place as much common code as possible
> > in the runner script, so individual unit tests don't result in too
> > much copy and paste.
> >
> 
> Ok, I understand.
> 
> Actually, as you know I'm just experimenting with this.
>
> Anyway the problem I see is that we could end losing a lot of flexibility.
> The current py testsuite is only able to perform one kind of tests
> because of this approach.
> In the other hand, the shell testsuite is able to perform almost any
> kind of tests because it only executes arbitrary binaries.

Flexibility is good indeed. Regarding the comments on the existing
testsuites, I think both complement each other, so they are both
useful.

> So perhaps we could take an intermediate approach:
>  * scapy tests are executed by the shell testsuite runner (they are
> standalone scripts)
>  * we develop a common lib of functions inside
> tests/shell/testcases/scapy/ (for example common.py)
>  * then, each scapy test load that common lib which includes most of
> the factorised code

That's good, I like this balance. Look, my only concern is
maintainability: If we end up using the copy & paste pattern too much
on these scripts, we will have to patch them all if we find a bug on
them.

But don't worry too much on trying to generalize things upfront given
there's experimentation on this going on. We can introduce
abstractions incrementally, as we start seeing that code duplicates.

> Common functions would be something like this:
> 
> * configure(): we do the scapy configuration, network config, or whatever
> * load_ruleset): we pass a nft ruleset (a string) and load it using nft -f
> * check_result(): we grep the ruleset counters, or whatever
> 
> I'm thinking of some tests we could have using this approach:
> 
> * atomic replacement of ruleset during a network transfer
> * conntrack modifications (using the conntrack-tools binaries)
> * packet mangling, NAT, etc
> 
> In any case, I think we should retain the ability to load nft rules,
> send/recv scapy packets and check for nft counters at any time during
> the execution.

Sure, go ahead.

Thanks Arturo.
