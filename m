From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [Outreachy kernel] [PATCH] extensions: libxt_statistic: Add
 translation to nft
Date: Tue, 1 Mar 2016 20:20:54 +0100
Message-ID: <20160301192054.GA2297@salvia>
References: <20160229212216.GA29706@sonyv>
 <CAKHNQQH2sE3A_jV0kuwBaTQZS1Z90RwuRoL+dvhPyCOV=Ev=9w@mail.gmail.com>
 <20160301154935.GA3838@sonyv>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Shivani Bhardwaj <shivanib134@gmail.com>,
	Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>, Florian Westphal <fw@strlen.de>,
	outreachy-kernel <outreachy-kernel@googlegroups.com>
To: Laura Garcia <nevola@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:40373 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752263AbcCATVA (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 1 Mar 2016 14:21:00 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 585A5E666D
	for <netfilter-devel@vger.kernel.org>; Tue,  1 Mar 2016 20:20:59 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 3D5CCDA8FA
	for <netfilter-devel@vger.kernel.org>; Tue,  1 Mar 2016 20:20:59 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 5C5F4DA385
	for <netfilter-devel@vger.kernel.org>; Tue,  1 Mar 2016 20:20:55 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20160301154935.GA3838@sonyv>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Mar 01, 2016 at 04:49:36PM +0100, Laura Garcia wrote:
> On Tue, Mar 01, 2016 at 03:21:24PM +0530, Shivani Bhardwaj wrote:
> > On Tue, Mar 1, 2016 at 2:52 AM, Laura Garcia Liebana <nevola@gmail.com> wrote:
> > 
> > Hi Laura,
> > 
> > > Add translation for random to nftables.
> > >
> > Here, you are providing translation for module statistic, random is
> > just a mode for matching the rule. Please make sure to use correct
> > module name in the commit message next time.
> > 
> 
> Hi Shivani,
> 
> The translation is only for random due to the mode nth is not implemented in nft yet.
> 
> 
> > > Examples:
> > >
> > > $ iptables-translate -A INPUT -m statistic --mode random --probability
> > > 0.1 -j ACCEPT
> > > nft add rule ip filter INPUT meta random 0.10000000009 counter accept
> > >
> > > $ iptables-translate -A INPUT -m statistic --mode random ! --probability
> > > 0.1 -j ACCEPT
> > > nft add rule ip filter INPUT meta random != 0.10000000009 counter accept
> > >
> > 
> > The match statistic is not yet supported in nftables, so these
> > translations are not going to work. You can track the supported
> > extensions here:
> > http://wiki.nftables.org/wiki-nftables/index.php/Supported_features_compared_to_xtables,
> > you can edit any discrepancies you find on this page.
> > 
> 
> The nf-next branch includes the random feature and it's working
> perfectly for me. Should I have to update something in the wiki?

The nf-next tree is OK for this. The sooner we get a translation, the
better.

Yes please, update the wiki page once this hits the master branch.

Thanks.
