From: Jan Engelhardt <jengelh@medozas.de>
Subject: libmnl: misc code updates
Date: Sat, 23 Oct 2010 07:44:37 +0200
Message-ID: <1287812691-14470-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:55078 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751556Ab0JWFo6 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 23 Oct 2010 01:44:58 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


The following changes since commit a8956ff09c06869b6c5bc5f525944d8c228e64e9:

  doc: git tree update (now at netfilter.org) and fix listing in doxygen (2010-10-21 13:32:42 +0200)

are available in the git repository at:
  git://dev.medozas.de/libmnl master

Jan Engelhardt (13):
      build: fix disable_static functionality
      src: avoid using deprecated unspecified argument lists
      src: add const qualifiers
      src: remove redundant casts
      socket: remove statement with no effect
      doc: documentation updates
      include: consistent usage of "extern"
      attr: string functions should take char *
      callback: mnl_cb_run should use a void *
      socket: use more appropriate types for mnl_socket_bind
      include: add cplusplus guards for extern
      nlmsg: use bool return type for yes-no functions
      attr: rename str_null from NULL away

 README                          |   10 +++++-----
 configure.ac                    |    2 +-
 examples/genl/genl-family-get.c |    2 +-
 examples/netfilter/nfct-event.c |    2 +-
 examples/rtnl/rtnl-link-dump.c  |    2 +-
 examples/rtnl/rtnl-link-dump2.c |    2 +-
 examples/rtnl/rtnl-link-dump3.c |    2 +-
 examples/rtnl/rtnl-link-event.c |    2 +-
 examples/rtnl/rtnl-route-dump.c |    2 +-
 include/libmnl/libmnl.h         |   25 ++++++++++++++++++-------
 src/attr.c                      |   35 ++++++++++++++++++-----------------
 src/callback.c                  |    8 ++++----
 src/nlmsg.c                     |   24 ++++++++++++------------
 src/socket.c                    |   23 +++++++++++------------
 14 files changed, 76 insertions(+), 65 deletions(-)
