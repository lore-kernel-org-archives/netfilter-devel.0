From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [RFC nftables PATCH] nft: add bash completion script
Date: Tue, 16 Feb 2016 17:26:34 +0100
Message-ID: <20160216162634.GB3504@salvia>
References: <1454691182-6573-1-git-send-email-giuseppelng@gmail.com>
 <20160215195601.GA8938@salvia>
 <CAFpD06Q_eVk6xPeQH6GVrsHVNQCdXKvuCh-5T3Wi_sHK3tmQrQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
To: Giuseppe Longo <giuseppelng@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:45814 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751284AbcBPQ0k (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 16 Feb 2016 11:26:40 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 9514F6DFE0
	for <netfilter-devel@vger.kernel.org>; Tue, 16 Feb 2016 17:26:37 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 839301B327B
	for <netfilter-devel@vger.kernel.org>; Tue, 16 Feb 2016 17:26:37 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 951E81B3344
	for <netfilter-devel@vger.kernel.org>; Tue, 16 Feb 2016 17:26:35 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <CAFpD06Q_eVk6xPeQH6GVrsHVNQCdXKvuCh-5T3Wi_sHK3tmQrQ@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Feb 16, 2016 at 02:00:17PM +0100, Giuseppe Longo wrote:
> Hi Pablo,
> 
> 2016-02-15 20:56 GMT+01:00 Pablo Neira Ayuso <pablo@netfilter.org>:
> > Hi Giuseppe,
> >
> > On Fri, Feb 05, 2016 at 05:53:02PM +0100, Giuseppe Longo wrote:
> >> The following patch adds a bash completion script
> >> which permits to complete nft commands.
> >>
> >> To install it:
> >> - cp files/nft-completion /etc/bash_completion.d/
> >> - . /etc/bash_completion.d/nft-completion
> >>
> >> The following commands are supported:
> >> - nft add table <family> <name>
> >> - nft list table <family> <name>
> >> - nft list tables
> >> - nft list sets
> >> - nft list chains
> >> - nft list ruleset
> >> - nft list set <table> <name>
> >> - nft add set <table> <name>
> >> - nft add element <table> <set>
> >> - nft add map <table>
> >> - nft flush table <family> <table>
> >>
> >> Most probably this won't work with sudo, since there
> >> are some nft commands into the script.
> >>
> >> A second patch to add completion in interactive mode
> >> will come.
> >>
> >> This is only a draft,
> >> any feedback is appreciated.
> >
> > Could you explore adding code to inquire the parser on the next
> > possible tokens ahead? That would greatly simplify the shell script
> > for bash autocompletion. We should be able to reuse this from
> > libreadline too.
> >
> > I know what I'm asking is a bit more difficult, but it would help us
> > reduce the amount of code duplication and will reduce the maintainance
> > burden.
> >
> > Let us know, thanks!
> 
> Sure, I've looked quickly at bison doc and thought the following idea:
> We can add a new nft command like "nft complete" to inquire the parser,
> which will print all the possible word since we have a parse tree.

Sounds reasonable. Let me see if I can come up with a better command
name, but this naming detail should not stop you at this stage.

> in that way, the bash script will be able to complete the command.
> 
> Also, do you confirm that we will skip objects like tables name, chain
> name, and so on?

Yes, let's focus on keyword autocompletion by now.

Thanks.
