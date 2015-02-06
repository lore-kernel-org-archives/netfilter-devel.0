From: Gao feng <gaofeng@cn.fujitsu.com>
Subject: [PATCH 3/3] Update the manpage for MARK target
Date: Fri, 6 Feb 2015 15:26:30 +0800
Message-ID: <1423207590-13423-3-git-send-email-gaofeng@cn.fujitsu.com>
References: <1423207590-13423-1-git-send-email-gaofeng@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <pablo@netfilter.org>, Gao feng <gaofeng@cn.fujitsu.com>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:27225 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751226AbbBFH0y (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 6 Feb 2015 02:26:54 -0500
In-Reply-To: <1423207590-13423-1-git-send-email-gaofeng@cn.fujitsu.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Gao feng <gaofeng@cn.fujitsu.com>
---
 arptables.8 | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/arptables.8 b/arptables.8
index 78b2c60..a0ada83 100644
--- a/arptables.8
+++ b/arptables.8
@@ -315,6 +315,16 @@ sify the packet into a specific CBQ class).
 Set the major and minor  class  value.  The  values  are  always
 interpreted as hexadecimal even if no 0x prefix is given.
 
+.SS MARK
+This  module  allows you to set the skb->mark value (and thus classify
+the packet by the mark in u32)
+
+.TP
+.BR "--set-mark mark"
+
+Set the mark value.  The  values  are  always
+interpreted as hexadecimal even if no 0x prefix is given.
+
 .SH MAILINGLISTS
 .BR "" "See " http://netfilter.org/mailinglists.html
 .SH SEE ALSO
-- 
2.1.0

