From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 1/2] tests: shell: Add test for incomplete set add set
 command
Date: Mon, 26 Jun 2017 19:37:25 +0200
Message-ID: <20170626173725.GA12032@salvia>
References: <1498219556-25179-1-git-send-email-mayhs11saini@gmail.com>
 <20170626165942.GA8489@salvia>
 <CAOfkYf7jSLBq65ALTjdi0JK=ajPkg_db0sSYPkv7tFrLA2u1gg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Netfilter Development Mailing list
        <netfilter-devel@vger.kernel.org>
To: Shyam Saini <mayhs11saini@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:51804 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751410AbdFZRhg (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 26 Jun 2017 13:37:36 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 6BF73E7B83
        for <netfilter-devel@vger.kernel.org>; Mon, 26 Jun 2017 19:37:19 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 5C2A31B4042
        for <netfilter-devel@vger.kernel.org>; Mon, 26 Jun 2017 19:37:19 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 49E601B4052
        for <netfilter-devel@vger.kernel.org>; Mon, 26 Jun 2017 19:37:17 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <CAOfkYf7jSLBq65ALTjdi0JK=ajPkg_db0sSYPkv7tFrLA2u1gg@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Jun 26, 2017 at 11:02:34PM +0530, Shyam Saini wrote:
> On Mon, Jun 26, 2017 at 10:29 PM, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > On Fri, Jun 23, 2017 at 05:35:55PM +0530, Shyam Saini wrote:
> >> Before the [Test] commit if we run nft with incomplete "add set"
> >> command it caused segmentation fault and exit with error code 139 and
> >> further it didn't throw any error message.
> >>
> >>   For example:
> >>     $ sudo nft add set t s
> >>
> >> But after the [Test] commit it throws syntax error message and exits with
> >> return value 1.
> >>
> >>   For example:
> >>     $ sudo nft add set t s
> >>     <cmdline>:1:12-12: Error: syntax error, unexpected newline, expecting '{'
> >>     add set t s
> >>                ^
> >>
> >> This commit tests changes made in the [Test] commit.
> >
> > Applied, thanks.
> >
> > I have reworked a bit your commit message, it looks a bit convoluted.
> 
> Thanks a lot :)
> 
> > No worries, have a look at what I pushed out for reference.
> 
> Shouldn't we follow conventions mentioned in "scripts/checkpatch.pl" ?

Interesting.

So the [test] thing is something that checkpatch.pl suggests, right?

I would like to know more about that new thing, do you have
documentation about this?

I just tend to like that commit message are human-readable. I
understand this structure makes it easier for robots, more simple to
parse.

So don't take checkpatch too seriously, probably too much engineering
is going on there ;-)
