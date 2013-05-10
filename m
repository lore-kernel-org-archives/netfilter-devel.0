From: Eric Leblond <eric@regit.org>
Subject: [PATCH RFC 0/11] ulogd2 db rework
Date: Fri, 10 May 2013 08:48:47 +0200
Message-ID: <1368168538-29780-1-git-send-email-eric@regit.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ks28632.kimsufi.com ([91.121.96.152]:51446 "EHLO
	ks28632.kimsufi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750824Ab3EJGtS (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 10 May 2013 02:49:18 -0400
Received: from bayen.regit.org ([81.57.69.189] helo=ice-age.regit.org)
	by ks28632.kimsufi.com with esmtpsa (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.72)
	(envelope-from <eric@regit.org>)
	id 1Uah8j-0007YZ-FC
	for netfilter-devel@vger.kernel.org; Fri, 10 May 2013 08:49:15 +0200
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


Hello,

Here's a patchset for ulogd which is aiming at improving the way
databases are handled. It features two different parts:
 - a backlog system (patch 06) which allow queries to be store in
 memory when the database is not available. Data loss is prevented
 in this case (in the limit of the defined memcap)
 - a multithreaded ulogd db output (patch 09) with one thread getting
 messages from kernel and an other one dedicated to the SQL queries
 execution.

The backlog system prevent data loss and only cost memory when the
database is down. The multithreaded db output uses a ring buffer
(which cost memory) for communication between the two threads.

The idea behind the multithreaded db output is to almost fix the time
needed to read a kernel message. Doing this, ulogd should be more
resistant to burst of kernel messages as kernel-user buffer will not
be filled due to the high treatment time needed to execute SQL query.

Both features are modifying the generic db system inside ulogd. So the
modification is available in pgsql, mysql and dbi output. It has for
now only been tested on pgsql.

Comments, feedbacks and test results are more than welcome on both
these features.

Patchset statistics:

 configure.ac                          |   32 ++-
 include/ulogd/db.h                    |   67 +++++-
 output/mysql/ulogd_output_MYSQL.c     |    4 +-
 output/pgsql/ulogd_output_PGSQL.c     |    4 +-
 output/sqlite3/ulogd_output_SQLITE3.c |    2 +
 src/Makefile.am                       |    2 +-
 src/ulogd.c                           |    2 +-
 ulogd.conf.in                         |   13 ++
 util/db.c                             |  371 +++++++++++++++++++++++++++------
 9 files changed, 417 insertions(+), 80 deletions(-)

BR,
--
Eric Leblond <eric@regit.org>
