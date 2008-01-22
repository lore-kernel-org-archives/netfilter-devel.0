From: Max Kellermann <max@duempel.org>
Subject: [conntrack-utils PATCH r7285 00/11] conntrackd with libevent
Date: Tue, 22 Jan 2008 15:10:51 +0100
Message-ID: <20080122141034.30077.12083.stgit@rabbit.intern.cm-ag>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from duempel.org ([78.31.71.42]:50924 "HELO duempel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753660AbYAVOHH (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 22 Jan 2008 09:07:07 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Pablo,

another patch series, some smaller fixes, and the big part is
conntrackd with libevent.  While looking for a nice solutions for the
"huge sorted list of alarms" scaling problem, I thought about storing
alarms in some sort of tree.  After a quick look at libevent, I saw
they did it exactly this way.  Let's benchmark libevent against the
existing alarm library.  I don't think it's worth it to continue work
on alarm.c, when well-tested code is already available in libevent.

I did not update configure.ac yet to check for libevent, I am waiting
for your benchmark results.

Max

---

Max Kellermann (11):
      remove the alarm library
      use libevent
      added handler callback to mcast_sock
      check if the received packet is large enough
      use size_t
      remove obsolete prototypes
      added missing ntohs()
      added alarm_pending()
      moved process function pointer to struct local_server
      added struct local_server
      -1 means error, not 0


 include/Makefile.am  |    2 -
 include/alarm.h      |   33 ---------
 include/conntrackd.h |    6 +-
 include/local.h      |   20 ++++-
 include/mcast.h      |   16 +++-
 include/network.h    |    8 +-
 src/Makefile.am      |    4 +
 src/alarm.c          |  191 --------------------------------------------------
 src/build.c          |    2 -
 src/cache_timer.c    |   39 +++++++---
 src/local.c          |   42 +++++++----
 src/main.c           |   12 +++
 src/mcast.c          |   75 ++++++++++++++++++--
 src/network.c        |   22 +++---
 src/run.c            |  177 ++++++++++++++++++----------------------------
 src/stats-mode.c     |    1 
 src/sync-alarm.c     |   58 ++++++++++-----
 src/sync-ftfw.c      |   27 +++++--
 src/sync-mode.c      |   60 ++++------------
 19 files changed, 329 insertions(+), 466 deletions(-)
 delete mode 100644 include/alarm.h
 delete mode 100644 src/alarm.c

