From: Max Kellermann <max@duempel.org>
Subject: [conntrack-tools PATCH r7363 0/5] rbtree alarm review
Date: Wed, 13 Feb 2008 18:13:27 +0100
Message-ID: <20080213171046.29912.41091.stgit@woodpecker.roonstrasse.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from duempel.org ([78.31.71.42]:47565 "EHLO swift.blarg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754316AbYBMRUZ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 13 Feb 2008 12:20:25 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Pablo,

I have finally been able to take a little time and review your rbtree
based alarm implementation.  I looks good, I haven't found major
showstoppers here.  Here is a small patch set which optimizes the code
a little.

Max

---

Max Kellermann (5):
      minor whitespace cleanup
      use list_for_each_entry()
      make alarm_run_queue a local variable
      use "for" loop instead of "while"
      eliminate duplicate initialization


 include/queue.h |    4 ++--
 src/alarm.c     |   21 +++++++++------------
 src/main.c      |    6 +++---
 src/netlink.c   |   14 +++++++-------
 src/run.c       |   12 ++++++------
 5 files changed, 27 insertions(+), 30 deletions(-)

