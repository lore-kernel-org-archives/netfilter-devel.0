From: Michael Zintakis <michael.zintakis@googlemail.com>
Subject: [PATCH v3 0/29] nfacct changes and additions
Date: Wed, 10 Jul 2013 19:24:58 +0100
Message-ID: <1373480727-11254-1-git-send-email-michael.zintakis@googlemail.com>
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-la0-f49.google.com ([209.85.215.49]:53056 "EHLO
	mail-la0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753834Ab3GJSZf (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 10 Jul 2013 14:25:35 -0400
Received: by mail-la0-f49.google.com with SMTP id ea20so5944691lab.22
        for <netfilter-devel@vger.kernel.org>; Wed, 10 Jul 2013 11:25:34 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The following patch set fixes bugs and introduces a variety of new features
to the 3 nfacct components: kernel, libnetfilter_acct and nfacct executable.

All of the patches need to be applied in the order specified in this patch
set (1-29) as they are interdependent. The full list of bugfixes and
features added for each component are:


Michael Zintakis (29):

* kernel:
  bugfix: pkts/bytes need to be specified simultaneously
  bugfix: restore pkts/bytes counters in NLM_F_REPLACE
  add permanent byte/packet format capability to nfacct
  add byte threshold capability to nfacct
  add packets and bytes mark capability to nfacct

 include/uapi/linux/netfilter/nfnetlink_acct.h |  16 +++
 net/netfilter/nfnetlink_acct.c                | 138 +++++++++++++++++++++++++-
 2 files changed, 150 insertions(+), 4 deletions(-)


* libnetfilter_acct:
  bugfix: correct xml name parsing
  bugfix: correct (plain) name parsing
  add *_SAVE template allowing save/restore
  add *_BONLY template to show bytes-only
  add variable width and on-the-fly formatting
  add *permanent* number formatting support
  add byte threshold capability support
  add *_EXTENDED template support
  add packets/bytes mark capability support
  add *_MONLY template support

 configure.ac                                  |    2 +-
 include/libnetfilter_acct/libnetfilter_acct.h |  100 +++
 include/linux/netfilter/nfnetlink_acct.h      |   16 +
 src/libnetfilter_acct.c                       | 1055 ++++++++++++++++++++++++-
 src/libnetfilter_acct.map                     |   13 +
 5 files changed, 1158 insertions(+), 28 deletions(-)


* nfacct:
  bugfix: prevent 0-sized parameter being accepted
  bugfix: prevent 0-sized nfacct name being accepted
  code-refactoring changes to the "command menu"
  add 2 new options: "replace" and "flush"
  add variable width and on-the-fly number formatting
  add new "save" and correct existing "restore" commands
  add sort option to the "list" command
  add "show bytes" option to "list" and "get" commands
  add permanent number formatting to nfacct objects
  add byte threshold capabilities to nfacct objects
  add "show extended" option to "list" and "get" commands
  add setmark and clrmark to "get" and "list" commands
  add "show marks" option to "list" and "get" commands
  change man page to describe all new features

 include/linux/netfilter/nfnetlink_acct.h |   17 +
 nfacct.8                                 |  551 +++++++++++++++-
 src/Makefile.am                          |    2 +-
 src/nfacct.c                             | 1026 ++++++++++++++++++++++++------
 src/nfacct_list.c                        |  149 +++++
 src/nfacct_list.h                        |   95 +++
 src/nfacct_utils.c                       |  333 ++++++++++
 src/nfacct_utils.h                       |   33 +
 8 files changed, 1983 insertions(+), 223 deletions(-)
 create mode 100644 src/nfacct_list.c
 create mode 100644 src/nfacct_list.h
 create mode 100644 src/nfacct_utils.c
 create mode 100644 src/nfacct_utils.h

-- 
1.8.3.1

