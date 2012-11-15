From: Florian Westphal <fw@strlen.de>
Subject: [PATCH 0/3] libnetfilter_conntrack: add connlabel support
Date: Thu, 15 Nov 2012 16:50:08 +0100
Message-ID: <1352994611-3707-1-git-send-email-fw@strlen.de>
To: netfilter-devel <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:41025 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S2993118Ab2KOPsP (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 15 Nov 2012 10:48:15 -0500
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.72)
	(envelope-from <fw@breakpoint.cc>)
	id 1TZ1fq-0008TU-I1
	for netfilter-devel@vger.kernel.org; Thu, 15 Nov 2012 16:48:14 +0100
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The following three patches add support for the planned
connlabel extension to libnetfilter_conntrack.

I've tried to add Pablos feedback/ideas, thus:
- a new nfct_bitmask object is added, plus
  interfaces to test/set such bits
- 2nd patch adds functions to create/inspect a
  name <-> bit mapping table
- setting/retrieving the connlabels is done
  with the existing nfct_get/set_attr interface, so
  no new interface for that.

Caveats:
- I only wired CTA_LABELS up with the libmnl-based API
- I only made a very brief test of this code (using
  the example programs).

Please let me know if there are any remaining issues
with the chosen approach.

summary of changes:
examples/Makefile.am                                       |   10 
examples/nfct-mnl-dump-labels.c                            |  103 +++++
examples/nfct-mnl-set-label.c                              |  170 +++++++++
include/internal/bitops.h                                  |    2 
include/internal/object.h                                  |   12 
include/internal/prototypes.h                              |    9 
include/libnetfilter_conntrack/libnetfilter_conntrack.h    |   20 +
include/libnetfilter_conntrack/linux_nfnetlink_conntrack.h |    1 
src/conntrack/Makefile.am                                  |    1 
src/conntrack/api.c                                        |  164 ++++++++
src/conntrack/build_mnl.c                                  |   12 
src/conntrack/getter.c                                     |    6 
src/conntrack/labels.c                                     |  239 +++++++++++++
src/conntrack/parse.c                                      |    1 
src/conntrack/parse_mnl.c                                  |   25 +
src/conntrack/setter.c                                     |   12 
16 files changed, 787 insertions(+)
