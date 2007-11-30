From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: Re: iptables release
Date: Sat, 01 Dec 2007 02:37:32 +0900 (JST)
Message-ID: <200711301737.lAUHbXM9016950@toshiba.co.jp>
References: <474F2670.8080509@trash.net>
	<Pine.LNX.4.64.0711292205040.3089@fbirervta.pbzchgretzou.qr>
	<474F312B.5060103@trash.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: jengelh@computergmbh.de, hawk@diku.dk,
	netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from imx12.toshiba.co.jp ([61.202.160.132]:44736 "EHLO
	imx12.toshiba.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753120AbXK3Rhg (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 30 Nov 2007 12:37:36 -0500
Received: from arc11.toshiba.co.jp ([133.199.90.127])
	by imx12.toshiba.co.jp  with ESMTP id lAUHbYtJ021217
	for <netfilter-devel@vger.kernel.org>; Sat, 1 Dec 2007 02:37:34 +0900 (JST)
Received: (from root@localhost)
	by arc11.toshiba.co.jp  id lAUHbYrM024387
	for netfilter-devel@vger.kernel.org; Sat, 1 Dec 2007 02:37:34 +0900 (JST)
Received: from mx11.toshiba.co.jp (localhost [127.0.0.1])
	by ovp11.toshiba.co.jp  with ESMTP id lAUHbXbY025475
	for <netfilter-devel@vger.kernel.org>; Sat, 1 Dec 2007 02:37:33 +0900 (JST)
In-Reply-To: <474F312B.5060103@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org


Hi,

I'm not sure that I could get all changeset of iptables, but anyway
I put iptables.git at
	rsync://people.netfilter.org/users/yasuyuki/git/iptables.git

Please note that many released iptables which can be downloaded from
http://www.netfilter.org/projects/iptables/downloads.html are not
identical to each svn tags. So please don't mind even if no git commit
matches the archives.

I didn't import svn branches and tags by git-svnimport,
because sometimes doing that broke 'origin' git branch, and I saw that
some svn tags were not identical to any revision of svn turnk.
I can create git branches to keep svn tags and released iptables
sources, if people want.

The followings are logs of many troubles...

** Notable history of iptables svn tree

By the revision 702, svn.netfilter.org/netfilter/iptables/trunk was created.
branches and tags were at
	svn.netfilter.org/netfilter/iptables/branches
	svn.netfilter.org/netfilter/iptables/tags
respectively.

By 3071, the trunk of iptables was moved to
	svn.netfilter.org/netfilter/trunk/iptables

By 3109, the 'branches' of iptables was moved to
	svn.netfilter.org/netfilter/branches/iptables

The revsions 5092 - 5223 are not usual changes. 'svn log' says as follows.
Sorry, I don't know what happend at that time.

$ svn log -r5092 -v http://svn.netfilter.org/netfilter
------------------------------------------------------------------------
r5092 | (no author) | 2004-10-11 22:40:52 +0900 (Mon, 11 Oct 2004) | 1 line

This is an empty revision for padding.
------------------------------------------------------------------------

** What I did to create iptables git tree

I did
	$ git-svnimport -v -s 702 -l 3070 -T iptables/trunk	\
		http://svn.netfilter.org/netfilter 

I thought that such argument to -T was not expected by the author of
git-svnimport, but it seemd to work. ;) I did not use -b and -t for
branches and tags. Because I found that some commits on 'origin' were
broken by them.

Sometimes the TCP connection to SVN server was disconnected while importing.
In that case, I reset 'origin' and 'master' branch so that they refered
the last suceeded commit, removed .git/SVN2GIT_HEAD and .git/ORIG_HEAD,
and excecuted git-svnimport without '-s' again.

git-svnimport failed to import revision 1375. I don't know the reason.
I suspect that subversion or something on my environment could not manage
the charactor including '~' above 'a' of ISO-8859-1 encoding.
After all, I manually downloaded the changeset, creates a git patch,
applied it to 'origin' branch of git tree, and executed git-svnimport
without '-s'.

Next, I did
	$ git-svnimport -v -s 3109 -l 5091 -T trunk/iptables	\
		-b dummy_branches -t dummy_tags			\
		http://svn.netfilter.org/netfilter

It failed at 5091, so I reset 'origin' and 'master' branch so that
they refered the last commit (which was for revision 4552) and I did

	$ git-svnimport -v -s 5224 -T trunk/iptables	\
		-b dummy_branches -t dummy_tags		\
		http://svn.netfilter.org/netfilter

** A Comment
Well, I don't want to do this again :)

-- Yasuyuki Kozakai
