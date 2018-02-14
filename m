From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nft] parser_bison: restore nft {import,export} ruleset
Date: Wed, 14 Feb 2018 20:27:12 +0100
Message-ID: <20180214192712.2veqolrbrgq3n255@salvia>
References: <20180214183244.16184-1-pablo@netfilter.org>
 <CAOfkYf4aYq8bkzC5i+mrxrxO0EgzxzL46yphGKfUZettW4LspA@mail.gmail.com>
 <20180214191652.ao7ethqbt3qwvvqz@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Netfilter Development Mailing list
        <netfilter-devel@vger.kernel.org>, anthonyryan1@gmail.com,
        Phil Sutter <phil@nwl.cc>
To: Shyam Saini <mayhs11saini@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:56244 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1162787AbeBNT1R (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 14 Feb 2018 14:27:17 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 612E4FA5F1
        for <netfilter-devel@vger.kernel.org>; Wed, 14 Feb 2018 20:27:15 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 52528DA7F7
        for <netfilter-devel@vger.kernel.org>; Wed, 14 Feb 2018 20:27:15 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20180214191652.ao7ethqbt3qwvvqz@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Feb 14, 2018 at 08:16:52PM +0100, Pablo Neira Ayuso wrote:
> On Thu, Feb 15, 2018 at 12:34:31AM +0530, Shyam Saini wrote:
> > Hi Pablo,
> > 
> > On Thu, Feb 15, 2018 at 12:02 AM, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > > Restore original syntax for the yet experimental VM low-level json
> > > representation.
> > >
> > > Closes: https://bugzilla.netfilter.org/show_bug.cgi?id=1224
> > > Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> > > ---
> > > I asked for this change to make room for the high-level json
> > > representation, but we can use -j options for this instead.  Given there
> > > are more users for the json representation that I expected, I'm fixing
> > > it myself by restoring the former behaviour.
> > 
> > Why would one use "nft export"  without "nft import".
> > if someone exports rules in json then they can't use those rules
> > given the fact that "nft import" was not available earlier.
> > 
> > Am i missing something?
> 
> With this patch nft import and nft export works as expected, ie.
> 
>         nft export ruleset json > file.json
>         nft import ruleset json < file.json
> 
> I'm just restoring 'nft export ruleset json' with this patch, it seems
> there are more users of this than I expected, so let's restore this
> before 0.8.3 is released, that's my proposal.

Oh, probably you got confused because the patch title refers to nft
import when it should only refer to nft export ruleset json?
