From: Jan Engelhardt <jengelh@inai.de>
Subject: RFC on xt2 code 20121102
Date: Fri,  2 Nov 2012 04:38:32 +0100
Message-ID: <1351827523-10629-1-git-send-email-jengelh@inai.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares07.inai.de ([5.9.24.206]:42667 "EHLO ares07.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762643Ab2KBDkG (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 1 Nov 2012 23:40:06 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


In the preceding week (7d), I have worked off the git stash and
reintegrated loose code snippets from 2011. I would like to elicit
comments on the selected subset of 11 commits. These in themselves
only build the basic table, but do so with the things (like netns,
RCU) in mind that I would do from the start. Recognizing that readers
want small chunks, I picked only these 11 commits to show. Therefore,
rule entry logic will not be found in tonight's mail thread.



The following changes since commit 198c5e907589835d9c9ad8c8fde661ad4d1796ee:

  netfilter: make nf_hook_ops.priv available to hooks (2012-11-01 15:34:03 +0100)

are available in the git repository at:

  git://git.inai.de/linux xt2-20121102-0400

to be looked at up to 3581c20:

  netfilter: xtables2: table dump support

----------------------------------------------------------------
Jan Engelhardt (11):
      netfilter: xtables2: initial table skeletal functions
      netfilter: xtables2: initial Netlink interface
      netfilter: xtables2: chain creation and deletion
      netfilter: xtables2: chain renaming support
      netfilter: xtables2: transaction commit operation
      netfilter: xtables2: (atomic) table replace support
      netfilter: xtables2: transaction abort support
      netfilter: xtables2: redirect writes into transaction buffer
      netfilter: xtables2: supply a revision number
      netfilter: xtables2: chain dump support
      netfilter: xtables2: table dump support

 include/net/netfilter/xt_core.h                  |   53 ++
 include/uapi/linux/netfilter/Kbuild              |    1 +
 include/uapi/linux/netfilter/nfnetlink.h         |    3 +-
 include/uapi/linux/netfilter/nfnetlink_xtables.h |   72 +++
 net/netfilter/Kconfig                            |    8 +-
 net/netfilter/Makefile                           |    2 +
 net/netfilter/xt_core.c                          |  233 ++++++++
 net/netfilter/xt_nfnetlink.c                     |  921 ++++++++++++++++++++++++++++++++
 net/netfilter/xt_nfnetlink.h                     |    7 +
 9 files changed, 1298 insertions(+), 2 deletions(-)

The userspace utility "xtnl-test" is, like before, available from
  git://git.inai.de/libnetfilter_xtables master [ID 349243e]
Hint: Use `export LIBNFXT_DEBUG=1` to enable hexdumps of all message exchanges
made by xtnl-test.
