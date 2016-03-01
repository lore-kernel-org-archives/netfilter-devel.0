From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [Outreachy kernel] [PATCH] extensions: libxt_statistic: Add
 translation to nft
Date: Tue, 1 Mar 2016 11:13:31 +0100
Message-ID: <20160301101331.GA2714@salvia>
References: <20160229212216.GA29706@sonyv>
 <CAKHNQQH2sE3A_jV0kuwBaTQZS1Z90RwuRoL+dvhPyCOV=Ev=9w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Laura Garcia Liebana <nevola@gmail.com>,
	Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>, Florian Westphal <fw@strlen.de>,
	outreachy-kernel <outreachy-kernel@googlegroups.com>
To: Shivani Bhardwaj <shivanib134@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:37989 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751984AbcCAKNl (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 1 Mar 2016 05:13:41 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id D2C0E1F1908
	for <netfilter-devel@vger.kernel.org>; Tue,  1 Mar 2016 11:13:39 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id C07A6DA3A6
	for <netfilter-devel@vger.kernel.org>; Tue,  1 Mar 2016 11:13:39 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 318F0DA38F
	for <netfilter-devel@vger.kernel.org>; Tue,  1 Mar 2016 11:13:37 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <CAKHNQQH2sE3A_jV0kuwBaTQZS1Z90RwuRoL+dvhPyCOV=Ev=9w@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Mar 01, 2016 at 03:21:24PM +0530, Shivani Bhardwaj wrote:
> On Tue, Mar 1, 2016 at 2:52 AM, Laura Garcia Liebana <nevola@gmail.com> wrote:
> 
> Hi Laura,
> 
> > Add translation for random to nftables.
> >
> Here, you are providing translation for module statistic, random is
> just a mode for matching the rule. Please make sure to use correct
> module name in the commit message next time.
> 
> > Examples:
> >
> > $ iptables-translate -A INPUT -m statistic --mode random --probability
> > 0.1 -j ACCEPT
> > nft add rule ip filter INPUT meta random 0.10000000009 counter accept
> >
> > $ iptables-translate -A INPUT -m statistic --mode random ! --probability
> > 0.1 -j ACCEPT
> > nft add rule ip filter INPUT meta random != 0.10000000009 counter accept
> >
> 
> The match statistic is not yet supported in nftables, so these
> translations are not going to work. You can track the supported
> extensions here:
> http://wiki.nftables.org/wiki-nftables/index.php/Supported_features_compared_to_xtables,
> you can edit any discrepancies you find on this page.

I'm seeing here that there are partial translations that are not in
the tree.

I would like to have them merged upstream, no need to wait to fully
support every extension, we can document these limitations in the wiki
and the commit log.

IIRC, if the .xlate indirection returns 0, then it means no
translation is available. We can use that for things that we don't
support yet.

