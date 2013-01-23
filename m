From: Florian Westphal <fw@strlen.de>
Subject: [PATCH 0/4] libnetfilter_conntrack: connlabel support
Date: Wed, 23 Jan 2013 23:38:17 +0100
Message-ID: <1358980701-3747-1-git-send-email-fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:34225 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752217Ab3AWWmq (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 23 Jan 2013 17:42:46 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The following four patches add support for the connlabel extension to
libnetfilter_conntrack, i.e. support for accessing/changing labels
via ctnetlink from userspace.

If there are no objections I'll push these changes soon.

I only wired CTA_LABELS up with the (newer) libmnl-based API.

Please let me know if there are any remaining issues.

summary of changes:

Florian Westphal (4):
      api: add nfct_bitmask object
      api: add connlabel api and attribute
      examples: add connlabel dump/set/clear demo programs
      api: add CTA_LABEL_MASK attribute handling

 examples/Makefile.am                               |   10 +
 examples/nfct-mnl-dump-labels.c                    |  103 +++++++++
 examples/nfct-mnl-set-label.c                      |  190 +++++++++++++++
 include/internal/bitops.h                          |    2 +
 include/internal/object.h                          |   13 +
 include/internal/prototypes.h                      |    9 +
 .../libnetfilter_conntrack.h                       |   22 ++
 .../linux_nfnetlink_conntrack.h                    |    2 +
 qa/Makefile.am                                     |    5 +-
 qa/qa-connlabel.conf                               |   11 +
 qa/test_api.c                                      |   74 ++++++-
 qa/test_connlabel.c                                |   70 ++++++
 src/conntrack/Makefile.am                          |    1 +
 src/conntrack/api.c                                |  184 +++++++++++++++
 src/conntrack/build_mnl.c                          |   18 ++
 src/conntrack/copy.c                               |   32 +++-
 src/conntrack/getter.c                             |   12 +
 src/conntrack/labels.c                             |  243 ++++++++++++++++++++
 src/conntrack/parse.c                              |    1 +
 src/conntrack/parse_mnl.c                          |   26 ++
 src/conntrack/setter.c                             |   23 ++
 21 files changed, 1046 insertions(+), 5 deletions(-)
 create mode 100644 examples/nfct-mnl-dump-labels.c
 create mode 100644 examples/nfct-mnl-set-label.c
 create mode 100644 qa/qa-connlabel.conf
 create mode 100644 qa/test_connlabel.c
 create mode 100644 src/conntrack/labels.c
