From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 19/38]: Update feature-removal-schedule.txt
Date: Tue, 15 Jan 2008 07:19:38 +0100 (MET)
Message-ID: <20080115061933.3184.26013.sendpatchset@localhost.localdomain>
References: <20080115061907.3184.39432.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:62211 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752384AbYAOGTj (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 15 Jan 2008 01:19:39 -0500
In-Reply-To: <20080115061907.3184.39432.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[NETFILTER]: Update feature-removal-schedule.txt

With all the newly introduced features, there is a lot to remove
later on after a compatibility grace period of 2 years.

Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 733218e65d16da88f06073a62c017e6f9864ea1a
tree 5f55577f77ed3690b77302699c78b056db173a4b
parent ba17e28b907c34daf0278e6c3c5d3413a3082649
author Jan Engelhardt <jengelh@computergmbh.de> Mon, 14 Jan 2008 06:51:44 +0100
committer Patrick McHardy <kaber@trash.net> Tue, 15 Jan 2008 06:53:23 +0100

 Documentation/feature-removal-schedule.txt |   32 ++++++++++++++++++++++++++++
 1 files changed, 32 insertions(+), 0 deletions(-)

diff --git a/Documentation/feature-removal-schedule.txt b/Documentation/feature-removal-schedule.txt
index bdf4d19..51913bd 100644
--- a/Documentation/feature-removal-schedule.txt
+++ b/Documentation/feature-removal-schedule.txt
@@ -340,3 +340,35 @@ Why:	This algorithm was provided for reference but always exhibited bad
 	responsiveness and performance and has some serious flaws. It has been
 	replaced by rc80211-pid.
 Who:	Stefano Brivio <stefano.brivio@polimi.it>
+
+---------------------------
+
+What (Why):
+	- include/linux/netfilter_ipv4/ipt_TOS.h ipt_tos.h header files
+	  (superseded by xt_TOS/xt_tos target & match)
+
+	- "forwarding" header files like ipt_mac.h in
+	  include/linux/netfilter_ipv4/ and include/linux/netfilter_ipv6/
+
+	- xt_CONNMARK match revision 0
+	  (superseded by xt_CONNMARK match revision 1)
+
+	- xt_MARK target revisions 0 and 1
+	  (superseded by xt_MARK match revision 2)
+
+	- xt_connmark match revision 0
+	  (superseded by xt_connmark match revision 1)
+
+	- xt_conntrack match revision 0
+	  (superseded by xt_conntrack match revision 1)
+
+	- xt_iprange match revision 0,
+	  include/linux/netfilter_ipv4/ipt_iprange.h
+	  (superseded by xt_iprange match revision 1)
+
+	- xt_mark match revision 0
+	  (superseded by xt_mark match revision 1)
+
+When:	January 2009 or Linux 2.7.0, whichever comes first
+Why:	Superseded by newer revisions or modules
+Who:	Jan Engelhardt <jengelh@computergmbh.de>
