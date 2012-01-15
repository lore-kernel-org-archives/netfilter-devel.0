From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: [PATCH 0/2] ulogd2 patches
Date: Sun, 15 Jan 2012 16:04:47 +0100
Message-ID: <1326639889-28836-1-git-send-email-kadlec@blackhole.kfki.hu>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	marty <martinbarrowcliff@gmail.com>,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.25]:39472 "EHLO smtp0.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753243Ab2AOPFA (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 15 Jan 2012 10:05:00 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Pablo,

Here follow two patches which address the MySQL support issues. The first
one adds the support of stored procedures (which then gives the ability
to use SQL transactions) and the second one introduces a new plugin to
provide IPv4 addresses in host order, also for MySQL tables.
Please consider applying them.

Best regards,
Jozsef

Jozsef Kadlecsik (2):
  Support stored mysql procedures besides stored functions
  A simple filter plugin called IP2HBIN added

 doc/ulogd.sgml                |    8 ++
 filter/Makefile.am            |    6 +-
 filter/ulogd_filter_IP2HBIN.c |  199 +++++++++++++++++++++++++++++++++++++++++
 ulogd.conf.in                 |    1 +
 util/db.c                     |    2 +
 5 files changed, 215 insertions(+), 1 deletions(-)
 create mode 100644 filter/ulogd_filter_IP2HBIN.c

