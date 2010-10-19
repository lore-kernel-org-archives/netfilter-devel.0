From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 08/10] build: remove unneeded -dynamic -ldl -nostartfiles flags
Date: Tue, 19 Oct 2010 12:47:39 +0200
Message-ID: <1287485262-6562-9-git-send-email-jengelh@medozas.de>
References: <1287485262-6562-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:44410 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758262Ab0JSKrw (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 19 Oct 2010 06:47:52 -0400
In-Reply-To: <1287485262-6562-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Besides that -ldl should be in _LDADD (not _LDFLAGS), I do not see any
dlopen calls at all that would make the library a requirement.

I also see no reason to use -Wc,-nostartfiles.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 examples/genl/Makefile.am      |    1 -
 examples/netfilter/Makefile.am |    2 --
 examples/rtnl/Makefile.am      |    7 -------
 src/Makefile.am                |    2 +-
 4 files changed, 1 insertions(+), 11 deletions(-)

diff --git a/examples/genl/Makefile.am b/examples/genl/Makefile.am
index a2df116..deaf18d 100644
--- a/examples/genl/Makefile.am
+++ b/examples/genl/Makefile.am
@@ -4,4 +4,3 @@ check_PROGRAMS = genl-family-get
 
 genl_family_get_SOURCES = genl-family-get.c
 genl_family_get_LDADD = ../../src/libmnl.la
-genl_family_get_LDFLAGS = -dynamic -ldl
diff --git a/examples/netfilter/Makefile.am b/examples/netfilter/Makefile.am
index ef2f10c..927eb38 100644
--- a/examples/netfilter/Makefile.am
+++ b/examples/netfilter/Makefile.am
@@ -5,8 +5,6 @@ check_PROGRAMS = nf-queue \
 
 nf_queue_SOURCES = nf-queue.c
 nf_queue_LDADD = ../../src/libmnl.la
-nf_queue_LDFLAGS = -dynamic -ldl
 
 nfct_event_SOURCES = nfct-event.c
 nfct_event_LDADD = ../../src/libmnl.la
-nfct_event_LDFLAGS = -dynamic -ldl
diff --git a/examples/rtnl/Makefile.am b/examples/rtnl/Makefile.am
index 9f0600d..3cc8995 100644
--- a/examples/rtnl/Makefile.am
+++ b/examples/rtnl/Makefile.am
@@ -8,28 +8,21 @@ check_PROGRAMS = rtnl-link-dump rtnl-link-dump2 rtnl-link-dump3 \
 
 rtnl_link_dump_SOURCES = rtnl-link-dump.c
 rtnl_link_dump_LDADD = ../../src/libmnl.la
-rtnl_link_dump_LDFLAGS = -dynamic -ldl
 
 rtnl_link_dump2_SOURCES = rtnl-link-dump2.c
 rtnl_link_dump2_LDADD = ../../src/libmnl.la
-rtnl_link_dump2_LDFLAGS = -dynamic -ldl
 
 rtnl_link_dump3_SOURCES = rtnl-link-dump3.c
 rtnl_link_dump3_LDADD = ../../src/libmnl.la
-rtnl_link_dump3_LDFLAGS = -dynamic -ldl
 
 rtnl_route_add_SOURCES = rtnl-route-add.c
 rtnl_route_add_LDADD = ../../src/libmnl.la
-rtnl_route_add_LDFLAGS = -dynamic -ldl
 
 rtnl_link_event_SOURCES = rtnl-link-event.c
 rtnl_link_event_LDADD = ../../src/libmnl.la
-rtnl_link_event_LDFLAGS = -dynamic -ldl
 
 rtnl_link_set_SOURCES = rtnl-link-set.c
 rtnl_link_set_LDADD = ../../src/libmnl.la
-rtnl_link_set_LDFLAGS = -dynamic -ldl
 
 rtnl_route_dump_SOURCES = rtnl-route-dump.c
 rtnl_route_dump_LDADD = ../../src/libmnl.la
-rtnl_route_dump_LDFLAGS = -dynamic -ldl
diff --git a/src/Makefile.am b/src/Makefile.am
index 1e34c0f..064ccf5 100644
--- a/src/Makefile.am
+++ b/src/Makefile.am
@@ -2,5 +2,5 @@ include $(top_srcdir)/Make_global.am
 
 lib_LTLIBRARIES = libmnl.la
 
-libmnl_la_LDFLAGS = -Wc,-nostartfiles -version-info $(LIBVERSION)
+libmnl_la_LDFLAGS = -version-info $(LIBVERSION)
 libmnl_la_SOURCES = socket.c callback.c nlmsg.c attr.c
-- 
1.7.1

