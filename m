From: Jan Engelhardt <jengelh@inai.de>
Subject: Xtables2 status for Dec 04
Date: Tue,  4 Dec 2012 02:00:41 +0100
Message-ID: <1354582849-26888-1-git-send-email-jengelh@inai.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares07.inai.de ([5.9.24.206]:49563 "EHLO ares07.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751722Ab2LDBA6 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 3 Dec 2012 20:00:58 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


(Previous sets: http://www.spinics.net/lists/netfilter-devel/msg24117.html
http://www.spinics.net/lists/netfilter-devel/msg23925.html , which have
been amended lightly to address bugs and cosmetics.)

This is the third set of patches in Xtables2, in particular,
extension load/unload and execution logic for matches, targets
and verdicts. So, a "yay" is in order.

	Mandatory URLs.
	kernel part: git://git.inai.de/linux xt2-20121204-0135
	user part:   git://git.inai.de/libnetfilter_xtables master

Some xt extensions are directly usable. The table-replace test program
will use xt_MARK and xt_comment:

	cd libnetfilter_xtables/src/
	# this adds some rules with (m)atches, (t)argets, (v)erdicts
	# all with a he(x)dump
	./xtnl-test table-replace -Pmtvx
	ip6tables -A INPUT -m mark --mark 0x66666666
	iptables  -A INPUT -m mark --mark 0x44444444

Watch counters with `ip6tables -nvL` (or ipv4). As you will notice,
xt1 can run as a sibling to xt2.

The Xtables2 high-level documentation that currently contains the
section Architectural Differences, was updated:

	http://inai.de/documents/Xtables2_Userdoc.pdf (or .txt, .lyx)


== git canned text: ==

The following changes since commit 026b9cc06de11b5f14509d6f64863c413bf3a42b:

  netfilter: xtables2: support nomination for chains (2012-12-03 04:09:41 +0100)

are available in the git repository at:

  git://git.inai.de/linux 

for you to fetch changes up to bc6b85e5300c13a9296837af1092d9febc78eb80:

  netfilter: xtables2: execute targets in live rule traversal (2012-12-04 01:33:06 +0100)

----------------------------------------------------------------
Jan Engelhardt (8):
      netfilter: xtables2: support for entering/dumping rule verdicts
      netfilter: xtables2: execute verdicts in live rule traversal
      netfilter: xtables2: store netns in table and rule blob
      netfilter: xtables2: iterator for obtain/drop references to actions
      netfilter: xtables2: support for entering/dumping match actions
      netfilter: xtables2: execute matches in live rule traversal
      netfilter: xtables2: support for entering/dumping target actions
      netfilter: xtables2: execute targets in live rule traversal

 include/net/netfilter/xt_core.h                  |   89 +++++
 include/uapi/linux/netfilter/nfnetlink_xtables.h |   21 ++
 net/netfilter/xt_core.c                          |  426 ++++++++++++++++++++--
 net/netfilter/xt_nfnetlink.c                     |  155 ++++++++
 4 files changed, 668 insertions(+), 23 deletions(-)

                Ohloh Line Count Summary [all ~30 commits]
Language  Files       Code    Comment  Comment %      Blank      Total
--------  -----  ---------  ---------  ---------  ---------  ---------
c             4       1885        639      25.3%        259       2783
cpp           1        157         76      32.6%         22        255
--------  -----  ---------  ---------  ---------  ---------  ---------
Total         5       2042        715      25.9%        281       3038
