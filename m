From: Jan Engelhardt <jengelh@medozas.de>
Subject: libnetfilter_conntrack: misc annotations
Date: Sat, 18 Dec 2010 21:16:07 +0100
Message-ID: <1292703371-15946-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:47374 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932156Ab0LRUQM (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 18 Dec 2010 15:16:12 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


The following changes since commit a729bb44a14f78f12edb09ae76ce04dbc171c266:

  expect: export already implement low-level functions (2010-11-09 00:42:27 +0100)

are available in the git repository at:
  git://dev.medozas.de/libnetfilter_conntrack master

Jan Engelhardt (3):
      src: remove redundant casts
      src: declare non-modified data as const
      utils: use sizeof(buf) over hardcoded number

 include/internal/extern.h     |   28 ++++++++++++++--------------
 qa/test_filter.c              |    2 +-
 src/conntrack/api.c           |    4 ++--
 src/conntrack/bsf.c           |    2 +-
 src/conntrack/copy.c          |    2 +-
 src/conntrack/filter.c        |    2 +-
 src/conntrack/getter.c        |    2 +-
 src/conntrack/grp.c           |    2 +-
 src/conntrack/grp_getter.c    |    2 +-
 src/conntrack/grp_setter.c    |    4 ++--
 src/conntrack/setter.c        |    4 ++--
 src/conntrack/snprintf.c      |   10 +++++-----
 src/expect/getter.c           |    2 +-
 src/expect/setter.c           |    2 +-
 src/expect/snprintf_default.c |    2 +-
 src/main.c                    |    2 +-
 utils/conntrack_dump.c        |    2 +-
 utils/conntrack_events.c      |    2 +-
 utils/conntrack_filter.c      |    2 +-
 utils/conntrack_get.c         |    2 +-
 utils/ctexp_events.c          |    2 +-
 21 files changed, 41 insertions(+), 41 deletions(-)
