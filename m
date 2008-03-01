From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: svn to git (Was: Re: Xtables, Xtables-addons 1.5.1)
Date: Sat, 01 Mar 2008 19:36:44 +0900 (JST)
Message-ID: <200803011036.m21Aajlr013309@toshiba.co.jp>
References: <47BEC691.8040905@trash.net>
	<200802221313.m1MDDEBV012684@toshiba.co.jp>
	<47BECB78.4060405@trash.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: yasuyuki.kozakai@toshiba.co.jp, jengelh@computergmbh.de,
	netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from imx9.toshiba.co.jp ([202.33.96.51]:46533 "EHLO
	imx9.toshiba.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752308AbYCAKox (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 1 Mar 2008 05:44:53 -0500
Received: from imx12.toshiba.co.jp (imx12 [61.202.160.132])
	by imx9.toshiba.co.jp  with ESMTP id m21AimN2010597
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <netfilter-devel@vger.kernel.org>; Sat, 1 Mar 2008 19:44:49 +0900 (JST)
Received: from arc11.toshiba.co.jp ([133.199.90.127])
	by imx12.toshiba.co.jp  with ESMTP id m21AakT7021210
	for <netfilter-devel@vger.kernel.org>; Sat, 1 Mar 2008 19:36:46 +0900 (JST)
Received: (from root@localhost)
	by arc11.toshiba.co.jp  id m21AakZN016585
	for netfilter-devel@vger.kernel.org; Sat, 1 Mar 2008 19:36:46 +0900 (JST)
Received: from mx2.toshiba.co.jp (localhost [127.0.0.1])
	by ovp11.toshiba.co.jp  with ESMTP id m21Aakhx000426
	for <netfilter-devel@vger.kernel.org>; Sat, 1 Mar 2008 19:36:46 +0900 (JST)
In-Reply-To: <47BECB78.4060405@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Patrick McHardy <kaber@trash.net>
Date: Fri, 22 Feb 2008 14:17:44 +0100

> Yasuyuki KOZAKAI wrote:
> > From: Patrick McHardy <kaber@trash.net>
> > Date: Fri, 22 Feb 2008 13:56:49 +0100
> > 
> >> Jan Engelhardt wrote:
> >>> What have become of the idea of gitifying the netfilter svn?
> >>
> >> I didn't find time for this so far. Unfortunately there seems to be
> >> something wrong with the netfilter SVN and a full import didn't work
> >> last time I tried, so we would have to throw away the history.
> > 
> > We can keep the history in git tree.
> > 
> > Actually I could do that (with some diffs of $Id lines) for almost
> > programs last year. But I did not update my git tree.
> > 
> > Unfortunately I have to concentrate with other work until next Monday.
> > If you want the recent git tree, I'll update and put them people.netfilter.org
> > next week.
> > 
> > (You can get the old git tree for iptables at
> > 	http://people.netfilter.org/yasuyuki/git/iptables.git/
> >  and the mapping of svn revision and git tag is available at
> > 	http://people.netfilter.org/yasuyuki/git/iptables.git/svn2git)
> > 
> > Sorry, but I couldn't find the way to synchronize svn tree from git tree.
> > So at least we have to 'switch' git tree from svn tree at once.
> 
> 
> That sounds good. I won't be able to look into this until the
> end of next week, but I'll look into it then. We'll also need
> to set up gitweb and a public git server somewhere.

I've updated them and created some more trees.

Now the recent trees are available at

	rsync://people.netfilter.org/users/yasuyuki/git/iptables.git
	rsync://people.netfilter.org/users/yasuyuki/git/conntrack-tools.git
	rsync://people.netfilter.org/users/yasuyuki/git/ipset.git
	rsync://people.netfilter.org/users/yasuyuki/git/iptables.git
	rsync://people.netfilter.org/users/yasuyuki/git/libnetfilter_conntrack.git
	rsync://people.netfilter.org/users/yasuyuki/git/libnetfilter_cthelper.git
	rsync://people.netfilter.org/users/yasuyuki/git/libnetfilter_log.git
	rsync://people.netfilter.org/users/yasuyuki/git/libnetfilter_queue.git
	rsync://people.netfilter.org/users/yasuyuki/git/libnfnetlink.git
	rsync://people.netfilter.org/users/yasuyuki/git/patch-o-matic-ng.git
	rsync://people.netfilter.org/users/yasuyuki/git/ulog.git

And the maps between git tag and svn revision created by git-svnimport are at
	http://people.netfilter.org/yasuyuki/git/<tree name>/svn2git

The tar archives of each trees are in

	http://people.netfilter.org/yasuyuki/archives/

If you want synchronize iptables.git with svn tree by yourself for example,
please download and extract the tar archive, and

	$ cd iptables.git
	$ git-svnimport -v -T trunk/iptables	\
			-b dummy_branches	\
			-t dummy_tags		\
			http://svn.netfilter.org/netfilter

# I did not try if I could update git tree on the cloned tree from above
# rsync path.

How about other trees ? If you want, please let me know.

Regards,

-- Yasuyuki Kozakai


