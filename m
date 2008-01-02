From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: [PATCH 27/27] Update feature-removal-schedule.txt
Date: Wed, 2 Jan 2008 21:34:44 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0801022134290.14900@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0801022037090.14900@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:45553 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752891AbYABUep (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 2 Jan 2008 15:34:45 -0500
In-Reply-To: <Pine.LNX.4.64.0801022037090.14900@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

commit ff4d6f3afa5c8edb602a50abafb0ae7a2bb6132d
Author: Jan Engelhardt <jengelh@computergmbh.de>
Date:   Wed Jan 2 20:35:25 2008 +0100

    [NETFILTER]: Update feature-removal-schedule.txt
    
    With all the newly introduced features, there is a lot to remove
    later on after a compatibility grace period of 2 years.
    
    Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>

 Documentation/feature-removal-schedule.txt |   44 ++++++++++++++++++++
 1 files changed, 44 insertions(+), 0 deletions(-)

diff --git a/Documentation/feature-removal-schedule.txt b/Documentation/feature-removal-schedule.txt
index bdf4d19..3b89124 100644
--- a/Documentation/feature-removal-schedule.txt
+++ b/Documentation/feature-removal-schedule.txt
@@ -340,3 +340,47 @@ Why:	This algorithm was provided for reference but always exhibited bad
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
+	- xt_hashlimit match revision 0
+	  (superseded by xt_hashlimit match revision 1)
+
+	- xt_helper match revision 0
+	  (superseded by xt_helper match revision 1)
+
+	- xt_iprange match revision 0,
+	  include/linux/netfilter_ipv4/ipt_iprange.h
+	  (superseded by xt_iprange match revision 1)
+
+	- xt_length match revision 0
+	  (superseded by xt_length match revision 1)
+
+	- xt_mark match revision 0
+	  (superseded by xt_mark match revision 1)
+
+	- xt_state match revision 0
+	  (obsoleted by xt_conntrack match revision 1)
+
+When:	January 2009 or Linux 2.7.0, whichever comes first
+Why:	Superseded by newer revisions or modules
+Who:	Jan Engelhardt <jengelh@computergmbh.de>
