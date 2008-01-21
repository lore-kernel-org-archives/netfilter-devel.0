From: Max Kellermann <max@duempel.org>
Subject: [PATCH 0/4] fix SEGV, some run.c API stuff
Date: Mon, 21 Jan 2008 09:29:58 +0100
Message-ID: <20080121082752.27612.82519.stgit@rabbit.intern.cm-ag>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from duempel.org ([78.31.71.42]:36428 "HELO duempel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1759130AbYAUMCd (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 21 Jan 2008 07:02:33 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Pablo,

I found a segmentation fault in conntrackd, here is a possible patch.
Please verify that this is the "real" solution.  This patchset also
includes some patches which change the prototype of __run() to the one
I proposed last week.

Max

---

Max Kellermann (4):
      call __run() after do_alarm_run()
      __run() returns void
      don't ignore fd events when an alarm is due
      check nfct_get_attr()!=NULL


 include/alarm.h |    6 ++++--
 src/alarm.c     |   12 +++++++-----
 src/cache.c     |   46 ++++++++++++++++++++++++++++++++--------------
 src/run.c       |   45 +++++++++++++--------------------------------
 4 files changed, 56 insertions(+), 53 deletions(-)

