From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [Bug 1224] nft export json fails with successful return code
Date: Tue, 6 Feb 2018 13:49:57 +0100
Message-ID: <20180206124957.vrbfnr7tuh4tdgri@salvia>
References: <bug-1224-1689@https.bugzilla.netfilter.org/>
 <bug-1224-1689-5HSmtdM7gJ@https.bugzilla.netfilter.org/>
 <20180206124034.GU25722@orbyte.nwl.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Phil Sutter <phil@nwl.cc>, mayhs11saini@gmail.com,
        netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:42944 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752488AbeBFMuY (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 6 Feb 2018 07:50:24 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 1B0001EC2CA
        for <netfilter-devel@vger.kernel.org>; Tue,  6 Feb 2018 13:50:22 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 4BA1BA7E76
        for <netfilter-devel@vger.kernel.org>; Tue,  6 Feb 2018 13:50:18 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20180206124034.GU25722@orbyte.nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Feb 06, 2018 at 01:40:34PM +0100, Phil Sutter wrote:
> On Tue, Feb 06, 2018 at 02:44:06AM +0000, bugzilla-daemon@netfilter.org wrote:
> > https://bugzilla.netfilter.org/show_bug.cgi?id=1224
> [...]
> > --- Comment #1 from Shyam Saini <mayhs11saini@gmail.com> ---
> > Hi Anthony,
> > 
> > > I recently upgraded to nftables v0.8.2 and encountered a regression.
> > > 
> > > "nft export json" no longer works, it returns a success code (0), but
> > > doens't print any JSON data.
> > > 
> > > A git bisect determined this was introduced in commit
> > > 2fa54d8a49352bda44d3e25d1d7ba3531faf3303, and upon reading that commit, I
> > > noticed the introduction of "nft export vm json" which does work as expected.
> > 
> > Technically when we were exporting json by "nft export json" it was giving us 
> > low level virtual-machine(vm) pseudo code. So we renamed it as "vm json". 
> > As you have already mentioned that you are able achieve old behaviour by 
> > "nft export vm json", that is right behaviour.
> > 
> > Further, by this renaming it creates scope for high level json which
> > represents abstract syntax tree of nft grammar. This high level json
> > can be exported by "nft export json". 
> > But this feature is yet to come in mainline so we are doing "no operation" we
> > user executes "nft export json" and it returns 0.
> 
> This doesn't sound right to me. We break users' scripts and at the same
> time make it hard for them to notice. Imagine someone uses it in a cron
> job for backup purposes.
> 
> If it is really sensible to rename 'export json' to 'export vm json'
> (and I doubt that), there should be at least a grace period in which the
> old command returns an error and complains loudly.

We can restore 'nft export json'.

But fact is that we had no import command so far, many expressions are
still missing - specifically new extensions have no cover tests -, so
this low-level json support has been and it is still experimental.

And then, once your high level json representation is in place, we'll
provide a more user friendly - matching bitfield such as IP DSCP and
VLAN fields is tricky. So 'nft export json' will display a different
json layout at some point. But that probably we can just signal via
version field, although I tend to dislike them.

Let me know, thanks!
