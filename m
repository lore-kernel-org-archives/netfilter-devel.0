From: Jan Engelhardt <jengelh@medozas.de>
Subject: libnetfilter_log: misc annotations
Date: Sat, 18 Dec 2010 21:17:29 +0100
Message-ID: <1292703453-16324-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:47410 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932156Ab0LRURe (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 18 Dec 2010 15:17:34 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


The following changes since commit f4def3676c707e119c26457c4df176dbf54cedab:

  Merge branch 'master' of git://dev.medozas.de/libnetfilter_log (2010-11-07 20:50:05 +0100)

are available in the git repository at:

  git://dev.medozas.de/libnetfilter_log master

Jan Engelhardt (3):
      libipulog: rebuild required header file inclusion
      src: remove redundant casts
      src: declare non-modified data as const

 include/libnetfilter_log/libipulog.h |   11 +++++++----
 src/libipulog_compat.c               |    9 +++++----
 utils/ulog_test.c                    |    2 +-
 3 files changed, 13 insertions(+), 9 deletions(-)
