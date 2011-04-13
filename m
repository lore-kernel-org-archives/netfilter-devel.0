From: Jan Engelhardt <jengelh@medozas.de>
Subject: guided option parser, run 3
Date: Wed, 13 Apr 2011 18:13:21 +0200
Message-ID: <1302711228-15947-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:42505 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932850Ab1DMQNu (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 13 Apr 2011 12:13:50 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


The following changes since commit 316ae9d2f1996caea4cf221201accb8c2087a154:

  Merge branch 'opts' of git://dev.medozas.de/iptables (2011-04-13 13:38:20 +0200)

are available in the git repository at:

  git://dev.medozas.de/iptables floating/opts

Jan Engelhardt (26):
      libxtables: XTTYPE_MARKMASK32 support
      libxt_MARK: use guided option parser
      libxt_CONNMARK: use guided option parser
      libxtables: XTTYPE_UINT64 support
      libxt_quota: use guided option parser
      libxtables: linked-list name<->id map
      libxt_devgroup: use guided option parser
      libipt_realm: use guided option parser
      libxtables: XTTYPE_UINT16RC support
      libxt_length: use guided option parser
      libxt_tcpmss: use guided option parser
      libxtables: XTTYPE_UINT8RC support
      libxtables: XTTYPE_UINT64RC support
      libxt_connbytes: use guided option parser
      libxtables: XTTYPE_UINT16 support
      libxt_CT: use guided option parser
      libxt_NFQUEUE: use guided option parser
      libxt_TCPMSS: use guided option parser
      libxtables: pass struct xt_entry_{match,target} to x6 parser
      libxt_string: use guided option parser
      libxtables: XTTYPE_SYSLOGLEVEL support
      libip[6]t_LOG: use guided option parser
      libxtables: XTTYPE_ONEHOST support
      libxtables: XTTYPE_PORT support
      libxt_TPROXY: use guided option parser
      libipt_ULOG: use guided option parser

 extensions/libip6t_LOG.c     |  174 +++++----------------
 extensions/libipt_LOG.c      |  174 +++++----------------
 extensions/libipt_ULOG.c     |  137 ++++------------
 extensions/libipt_realm.c    |  202 +++++-------------------
 extensions/libxt_CONNMARK.c  |  271 +++++++++++++-------------------
 extensions/libxt_CT.c        |   74 ++++------
 extensions/libxt_MARK.c      |  202 ++++++++++---------------
 extensions/libxt_NFQUEUE.c   |  139 ++++++-----------
 extensions/libxt_TCPMSS.c    |   96 ++++--------
 extensions/libxt_TPROXY.c    |  216 ++++++++------------------
 extensions/libxt_connbytes.c |  107 +++++--------
 extensions/libxt_connmark.c  |   98 +++---------
 extensions/libxt_devgroup.c  |  201 +++++-------------------
 extensions/libxt_length.c    |   92 ++---------
 extensions/libxt_mark.c      |   95 +++---------
 extensions/libxt_quota.c     |   67 ++------
 extensions/libxt_string.c    |  138 ++++++-----------
 extensions/libxt_tcpmss.c    |   92 +++---------
 include/xtables.h.in         |   42 +++++-
 xtoptions.c                  |  352 ++++++++++++++++++++++++++++++++++++++++-
 20 files changed, 1127 insertions(+), 1842 deletions(-)
