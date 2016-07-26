From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH iptables 2/2] xtables-translate: fix issue with quotes
Date: Tue, 26 Jul 2016 18:27:41 +0200
Message-ID: <20160726162741.GB22174@salvia>
References: <20160722154834.1802-1-pablombg@gmail.com>
 <20160722154834.1802-2-pablombg@gmail.com>
 <20160725153134.GA11209@salvia>
 <CAAaDf4trupvsudo1-_4b+iafgXRoBBs+3LBBjT21OxvABMxriQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: "Pablo M. Bermudo Garay" <pablombg@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:50762 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756936AbcGZQ1r (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 26 Jul 2016 12:27:47 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id CD1C81B7F99
	for <netfilter-devel@vger.kernel.org>; Tue, 26 Jul 2016 18:27:44 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id BD50EFAB57
	for <netfilter-devel@vger.kernel.org>; Tue, 26 Jul 2016 18:27:44 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 72E7BFF134
	for <netfilter-devel@vger.kernel.org>; Tue, 26 Jul 2016 18:27:42 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <CAAaDf4trupvsudo1-_4b+iafgXRoBBs+3LBBjT21OxvABMxriQ@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Jul 26, 2016 at 06:22:49PM +0200, Pablo M. Bermudo Garay wrote:
> 2016-07-25 17:31 GMT+02:00 Pablo Neira Ayuso <pablo@netfilter.org>:
> > On Fri, Jul 22, 2016 at 05:48:34PM +0200, Pablo M. Bermudo Garay wrote:
> >> Some translations included escaped quotes when they were called from
> >> nft:
> >>
> >> $ sudo nft list ruleset
> >> table ip mangle {
> >>     chain FORWARD {
> >>         type filter hook forward priority -150; policy accept;
> >>         ct helper \"ftp\" counter packets 0 bytes 0
> >>                   ^^   ^^
> >>     }
> >> }
> >>
> >> This behavior is only correct when xlate functions are called from a
> >> xtables-translate command. This patch solves that issue if nft revision
> >> is using the field added to the xt_xlate struct with "xtables-translate:
> >> add new field to identify the caller" commit.
> >
> > Please, rebase this change on top of:
> >
> > http://git.netfilter.org/iptables/commit/?id=7a0992da44cfb6cab0ccd1beadcf326df8773552
> >
> > I'd suggest you add a new parameter for this, something like:
> >
> >         bool escape_quotes;
> >
> > Or is there use for this nft_compat field you propose out of this.
> 
> For the moment, the quotes issue is the only use I have found for the
> nft_compat field. So the escape_quotes boolean seems a good idea.

Great, I prefer then escape_quotes. We can rename this later on if it
turns out that we need this for something else.
