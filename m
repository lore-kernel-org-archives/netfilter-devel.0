From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] extensions: libxt_devgroup: Add translation to nft
Date: Tue, 22 Dec 2015 18:29:08 +0100
Message-ID: <20151222172908.GA21240@salvia>
References: <20151220120336.GA27589@gmail.com>
 <20151222170012.GA20795@salvia>
 <CAKHNQQHYwBq-uaiFfT8cv6bWfEf17AM0y650VKJ8Rpg7B2pUmA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Shivani Bhardwaj <shivanib134@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:40013 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933393AbbLVR3Y (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 22 Dec 2015 12:29:24 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 0546D23CF71
	for <netfilter-devel@vger.kernel.org>; Tue, 22 Dec 2015 18:29:21 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id E21C0DA8EB
	for <netfilter-devel@vger.kernel.org>; Tue, 22 Dec 2015 18:29:20 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id DA1FADA80B
	for <netfilter-devel@vger.kernel.org>; Tue, 22 Dec 2015 18:29:13 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <CAKHNQQHYwBq-uaiFfT8cv6bWfEf17AM0y650VKJ8Rpg7B2pUmA@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Dec 22, 2015 at 10:50:34PM +0530, Shivani Bhardwaj wrote:
> On Tue, Dec 22, 2015 at 10:30 PM, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > On Sun, Dec 20, 2015 at 05:33:37PM +0530, Shivani Bhardwaj wrote:
> >> Add translation of device group to nftables.
> >
> > git am /tmp/extensions-libxt_devgroup-Add-translation-to-nft.patch -s
> > Applying: extensions: libxt_devgroup: Add translation to nft
> > error: patch failed: extensions/libxt_devgroup.c:37
> > error: extensions/libxt_devgroup.c: patch does not apply
> > Patch failed at 0001 extensions: libxt_devgroup: Add translation to nft
> > The copy of the patch that failed is found in:
> >    /home/pablo/devel/scm/git-netfilter/iptables/.git/rebase-apply/patch
> > When you have resolved this problem, run "git am --continue".
> > If you prefer to skip this patch, run "git am --skip" instead.
> > To restore the original branch and stop patching, run "git am --abort".
> >
> > This one doesn't apply for some reason.
> 
> Should I be sending this one again then?

Of course. If you can't see a patch here:

http://git.netfilter.org/iptables/log/?h=xlate3

Then it needs to be submitted again.
