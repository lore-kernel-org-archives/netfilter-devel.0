From: Jan Engelhardt <jengelh@medozas.de>
Subject: subcommand consolidation and -C option
Date: Tue,  8 Mar 2011 23:20:57 +0100
Message-ID: <1299622860-32634-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:55702 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754008Ab1CHWVE (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 8 Mar 2011 17:21:04 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


The following changes since commit f96cb8094ceffb9ffe8e94b4ee6800aa581dd021:

  doc: add VERSION section to manpages (2011-03-01 15:43:49 +0100)

are available in the git repository at:
  git://dev.medozas.de/iptables master

Stefan Tomanek (2):
      ip(6)tables-multi: unify subcommand handling
      iptables: add -C to check for existing rules

 include/libiptc/libip6tc.h |    6 ++++
 include/libiptc/libiptc.h  |    6 ++++
 ip6tables-multi.c          |   46 +++++++++-------------------------
 ip6tables.8.in             |   10 ++++++-
 ip6tables.c                |   60 +++++++++++++++++++++++++++++++++++++++----
 iptables-multi.c           |   52 ++++++++++---------------------------
 iptables.8.in              |    9 ++++++-
 iptables.c                 |   60 +++++++++++++++++++++++++++++++++++++++----
 libiptc/libip4tc.c         |    1 +
 libiptc/libip6tc.c         |    1 +
 libiptc/libiptc.c          |   30 +++++++++++++++++----
 xshared.c                  |   36 ++++++++++++++++++++++++++
 xshared.h                  |   11 ++++++++
 13 files changed, 235 insertions(+), 93 deletions(-)
