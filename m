From: Eric Leblond <eric@regit.org>
Subject: [Ulogd PATCH 0/4] Implement event loss prevention for db output
Date: Mon, 18 Mar 2013 01:01:20 +0100
Message-ID: <1363564884-5957-1-git-send-email-eric@regit.org>
Cc: eric@regit.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ks28632.kimsufi.com ([91.121.96.152]:44631 "EHLO
	ks28632.kimsufi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932587Ab3CRABp (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 17 Mar 2013 20:01:45 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


Hello,

The first three patches are cleaning that could be necessary to avoid
issue with the fourth one who does the real job.

The idea is to store the queries in memory if the database goes down and
to proceed to the insertion when it gets back up. To do so, a chained list
of queries is attached to the database instance and queries are added to
it till a memory cap is not reached. When the database came back, the
queries are played in order so it should not cause any issue for any
potential triggers.

This new feature is inactive by default and can be activated by setting
"backlog_memcap" to a non null value in the database instance configuration.

To avoid to cause overun on the event capture by inserting too many things
at once at recovery (and thus blocking capture for a certain time), a maximum
of "backlog_oneshot_requests" " are inserted at a time.

Patchset statistics:
 include/ulogd/db.h                    |   34 ++++++++++--
 output/mysql/ulogd_output_MYSQL.c     |    4 +-
 output/pgsql/ulogd_output_PGSQL.c     |    4 +-
 output/sqlite3/ulogd_output_SQLITE3.c |    2 +
 ulogd.conf.in                         |    9 +++
 util/db.c                             |  170 +++++++++++++++++++++++++++++++++++++++++++++++----------
 6 files changed, 188 insertions(+), 35 deletions(-)

BR,
--
Eric Leblond <eric@regit.org>
