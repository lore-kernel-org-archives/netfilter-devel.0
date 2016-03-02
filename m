From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 1/2] iptables: utils: Add bash completion
Date: Wed, 2 Mar 2016 13:54:45 +0100
Message-ID: <20160302125445.GA5129@salvia>
References: <1456412814-4580-1-git-send-email-mart.frauenlob@chello.at>
 <1456412814-4580-2-git-send-email-mart.frauenlob@chello.at>
 <20160302113411.GA2068@salvia>
 <56D6DB61.7070203@chello.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org,
	Giuseppe Longo <giuseppelng@gmail.com>,
	Eric Leblond <eric@regit.org>
To: Mart Frauenlob <mart.frauenlob@chello.at>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:48012 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753334AbcCBMyv (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 2 Mar 2016 07:54:51 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 5394213C0E7
	for <netfilter-devel@vger.kernel.org>; Wed,  2 Mar 2016 13:54:48 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 4185CDA8F8
	for <netfilter-devel@vger.kernel.org>; Wed,  2 Mar 2016 13:54:48 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 33820DA38B
	for <netfilter-devel@vger.kernel.org>; Wed,  2 Mar 2016 13:54:46 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <56D6DB61.7070203@chello.at>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Mar 02, 2016 at 01:24:01PM +0100, Mart Frauenlob wrote:
> On 02.03.2016 12:34, Pablo Neira Ayuso wrote:
> >On Thu, Feb 25, 2016 at 04:06:53PM +0100, Mart Frauenlob wrote:
> >>  utils/iptables_bash_completion/README.md |  290 ++++
> >>  utils/iptables_bash_completion/iptables  | 2426 ++++++++++++++++++++++++++++++
> >
> >This is fair good amount of work, but this is also quite a bit of
> >new shell code to be maintained in our trees.
> >
> >Moreover, I was told that, in the specific case of debian, there is a
> >package (bash-completion) where you place this.
> >
> >So sorry, I'm not applying this.
> 
> Hello Pablo,
> 
> what a pitty! :-/
> Before writing this patch, I've asked the developers of bash completion for
> inclusion.
> For them it's fair to big and specific to maintain.
> They were worried about iptables becoming deprecated and them having dead
> code in their package.
> The only chance for inclusion, and that's not granted too, is to
> additionally write a test suite with tools I don't have any knowledge about
> yet - and to sign up as maintainer there.
> So they recommended me to request inclusion in iptables.

I see.

> I think this is a good piece of work, probably the best featured bash
> completion ever, and I'd wish to get it distributed.
> My abilities in that matter are limited.
> 
> Of course I'd keep fixing bugs and add new iptables features (though I think
> there are not many to expect in the future, right?).
> If someone submits a bug report, I'll take care of it if anyhow possible.
> Just need to be notified by CC or so.

Then, my suggestion is to simplify this script in order to reduce the
maintainance burden.

One idea is to push into iptables some infrastructure so the script
can inquire iptables on available options. This would be simple C code
to be places on every extension to print the options. Then, add a tool
like iptables-completion that you can use to inquire what is possible
to get as options. Thus, we get a generic script that inquires
iptables, instead of having them all hardcoded into the script.

Would you explore this? I know Giuseppe Longo and Eric Leblond are
looking into this for nft following a similar approach.
