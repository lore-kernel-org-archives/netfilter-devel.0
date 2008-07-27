From: Eric Leblond <eric@inl.fr>
Subject: [ULOGD2 PATCH 0/11] Big warning hunting.
Date: Sun, 27 Jul 2008 15:51:15 +0200
Message-ID: <1217166686-28508-1-git-send-email-eric@inl.fr>
References: <20080723162746.GB31572@bayen.regit.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bayen.regit.org ([81.57.69.189]:43790 "EHLO ice-age"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751355AbYG0Nv2 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 27 Jul 2008 09:51:28 -0400
Received: from eric by ice-age with local (Exim 4.69)
	(envelope-from <eric@bayen.regit.org>)
	id 1KN6ek-0007Rs-IN
	for netfilter-devel@vger.kernel.org; Sun, 27 Jul 2008 15:51:26 +0200
In-Reply-To: <20080723162746.GB31572@bayen.regit.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello,

As promised, here's the patchset resulting in hunting the cause of gcc warning.

Only a few mistakes and problems were found but the warning hunt was
necessary.
Main issues are fixed in the patch:
 * Cleanly stop SYSLOG module: close log function was not called.
 * Suppress twice defined key: printpkt was defining twice the same key.
 * Fix some initialisation: ulogd.c had some problem with initialisation.

I've added the option "-Wno-unused-parameter" to CFLAGS to avoid some unfixable
warnings.

If we omit IPFIX that I did not touch, the code is warning free.

Pathset statistics:
 configure.in                              |    2 +-
 filter/raw2packet/ulogd_raw2packet_BASE.c |    5 +----
 filter/ulogd_filter_IFINDEX.c             |    2 +-
 filter/ulogd_filter_IP2BIN.c              |    4 ++--
 filter/ulogd_filter_MARK.c                |    4 ++--
 filter/ulogd_filter_PWSNIFF.c             |    4 ++--
 include/libipulog/libipulog.h             |    2 +-
 input/packet/ulogd_inppkt_ULOG.c          |    2 +-
 libipulog/libipulog.c                     |    4 ++--
 libipulog/ulog_test.c                     |    2 +-
 output/mysql/ulogd_output_MYSQL.c         |    4 +---
 output/pgsql/ulogd_output_PGSQL.c         |    5 ++---
 output/ulogd_output_LOGEMU.c              |    2 +-
 output/ulogd_output_NACCT.c               |    8 ++++----
 output/ulogd_output_SYSLOG.c              |    8 ++++++--
 src/conffile.c                            |    4 ++--
 src/ulogd.c                               |   16 +++++++---------
 util/db.c                                 |   16 +++++++---------
 util/printflow.c                          |    8 ++++----
 util/printpkt.c                           |   15 ++++++---------
 20 files changed, 54 insertions(+), 63 deletions(-)

BR,
--
Eric Leblond
INL: http://www.inl.fr/
NuFW: http://www.nufw.org/
