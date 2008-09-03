From: Eric Leblond <eric@inl.fr>
Subject: [ULOGD2 4/4] Author and ML modification.
Date: Wed,  3 Sep 2008 22:19:03 +0200
Message-ID: <1220473143-17957-5-git-send-email-eric@inl.fr>
References: <>
 <1220473143-17957-1-git-send-email-eric@inl.fr>
 <1220473143-17957-2-git-send-email-eric@inl.fr>
 <1220473143-17957-3-git-send-email-eric@inl.fr>
 <1220473143-17957-4-git-send-email-eric@inl.fr>
Cc: Eric Leblond <eric@inl.fr>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bayen.regit.org ([81.57.69.189]:46785 "EHLO ice-age"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752626AbYICUso (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 3 Sep 2008 16:48:44 -0400
In-Reply-To: <1220473143-17957-4-git-send-email-eric@inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch adds me to the list of author (for the doc) and
suppress a reference to the ulogd ML which is a dead list.

Signed-off-by: Eric Leblond <eric@inl.fr>
---
 doc/ulogd.sgml |    6 +-----
 1 files changed, 1 insertions(+), 5 deletions(-)

diff --git a/doc/ulogd.sgml b/doc/ulogd.sgml
index af327a2..a98c053 100644
--- a/doc/ulogd.sgml
+++ b/doc/ulogd.sgml
@@ -5,7 +5,7 @@
 <article>
 
 <title>ULOGD 2.x - the Netfilter Userspace Logging Daemon</title>
-<author>Harald Welte &lt;laforge@netfilter.org&gt</author>
+<author>Harald Welte &lt;laforge@netfilter.org&gt, Eric Leblond &lt;eric@inl.fr&gt</author>
 <date>Revision 2008/09/03</date>
 
 <abstract>
@@ -601,10 +601,6 @@ The syslog level (LOG_EMERG, LOG_ALERT, LOG_CRIT, LOG_ERR, LOG_WARNING, LOG_NOTI
 All comments / questions / ... are appreciated.
 <p>
 Just drop a note to netfilter-devel@vger.kernel.org.
-<p>
-Please note also that there is now a mailinglist, ulogd@lists.gnumonks.org. 
-You can subscribe at
-<URL URL="http://lists.gnumonks.org/mailman/listinfo/ulogd/">.
 <p> 
 The preferred method for reporting bugs is the netfilter bugzilla system,
 available at <URL URL="http://bugzilla.netfilter.org/">.
-- 
1.5.4.3

