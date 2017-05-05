From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nft PATCH] List handles of added rules if requested
Date: Fri, 5 May 2017 12:49:54 +0200
Message-ID: <20170505104954.GA1676@salvia>
References: <20170504123421.22147-1-phil@nwl.cc>
 <20170504133626.GC5607@salvia>
 <20170504134419.GG13320@breakpoint.cc>
 <20170504140042.GA6436@salvia>
 <20170504222612.GD20805@orbyte.nwl.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Phil Sutter <phil@nwl.cc>, Florian Westphal <fw@strlen.de>,
        netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:43934 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752603AbdEEKuL (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 5 May 2017 06:50:11 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 77ACB2D160E
        for <netfilter-devel@vger.kernel.org>; Fri,  5 May 2017 12:50:03 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 6728D18FCF6
        for <netfilter-devel@vger.kernel.org>; Fri,  5 May 2017 12:50:03 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 1BB881BA104
        for <netfilter-devel@vger.kernel.org>; Fri,  5 May 2017 12:49:54 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20170504222612.GD20805@orbyte.nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, May 05, 2017 at 12:26:12AM +0200, Phil Sutter wrote:
> On Thu, May 04, 2017 at 04:00:42PM +0200, Pablo Neira Ayuso wrote:
> > On Thu, May 04, 2017 at 03:44:19PM +0200, Florian Westphal wrote:
> > > Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > > > On Thu, May 04, 2017 at 02:34:21PM +0200, Phil Sutter wrote:
> > > > > Being able to retrieve an added rule's handle atomically is a crucial
> > > > > feature for scripts invoking nft command: Without it, there is no way to
> > > > > be sure a handle extracted from 'nft list ruleset' command actually
> > > > > refers to the rule one has added before or that of another process which
> > > > > ran in between.
> > > > > 
> > > > > Extracting an added rule's handle itself is not an easy task already,
> > > > > since there is a chance that a given rule is printed differently than
> > > > > when it was added before. A simple example is port number vs. service
> > > > > name:
> > > > > 
> > > > > | nft add rule ip t c tcp dport { ssh, 80 } accept
> > > > > 
> > > > > There is no way to make 'nft list ruleset' return the rule just like
> > > > > this as depending on whether '-nn' was given or not, it either prints
> > > > > the set as '{ ssh, http }' or '{ 22, 80 }' but never in the mixed form
> > > > > that was used when adding it.
> > > > > 
> > > > > This patch prints an identifying string for each added rule which may be
> > > > > used as single parameter to a later 'nft delete rule' command. So a
> > > > > simple scripting example looks like this:
> > > > > 
> > > > > | handle=$(nft add rule ip t c counter)
> > > > 
> > > > This is a hack.
> > > > 
> > > > We should follow the rule description path.
> > > 
> > > You mean delete-by-name?
> > > 
> > > Its just as ugly, just a different kind of ugly.
> > 
> > Ugly?
> > 
> > This kernel patch is seriouly broken. It's sending a message to
> > userspace from the preparation phase of the commit protocol, where
> > things are not even confirmed at all...
> 
> Oh, I indeed ignored the transactional behaviour at all. But looking at
> the code, if I use NLM_F_ECHO that should be fine, right?
> 
> > > Will you delete the first match?  The last one?  All of them?
> > 
> > I already explained this Florian. Please, look at the mail archive.
> 
> While I think it's not a bad idea to allow users experienced with
> iptables to apply their muscle memory to nftables as well, I don't quite
> get what should hold us back from leveraging this feature nftables
> provides over iptables. The existence of a unique identifier is a big
> plus in my point of view, it's just not really useful yet since users
> have no safe way to get that handle for the rule they added.
>
> Are you OK with providing both alternatives in parallel? If not, why?

This does not integrate at all into the scripting features we have in
nftables. We don't want people to use bash (or like) shell scripts
anymore, they are bad, they break atomicity for us. We should extend
native nftables scripting capabilities to support what user need,
natively. Look, this will not work with nft -i either...

And this also will not work for robots using incremental updates via
nft -f. And we very much want to support such transaction like scheme,
ie. place a bunch of incremental updates in one single file and apply
that in one single transaction.

This is just covering one very specific usecase, that is, users have a
quick way to delete the rule that just added. And we have better ways
to achieve this, and that will work from all the scenarios that I
described above.
