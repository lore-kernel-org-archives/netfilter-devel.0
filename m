From: Zhang Chunyu <zhangcy@cn.fujitsu.com>
Subject: [PATCH V2 3/4] Update the manpage for MARK target
Date: Tue, 24 Mar 2015 21:57:35 -0400
Message-ID: <1427248656-8851-4-git-send-email-zhangcy@cn.fujitsu.com>
References: <1427248656-8851-1-git-send-email-zhangcy@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Zhang Chunyu <zhangcy@cn.fujitsu.com>,
	Gao feng <gaofeng@cn.fujitsu.com>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:22186 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752761AbbCYCLm (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 24 Mar 2015 22:11:42 -0400
In-Reply-To: <1427248656-8851-1-git-send-email-zhangcy@cn.fujitsu.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Gao feng <gaofeng@cn.fujitsu.com>
Signed-off-by: Zhang Chunyu <zhangcy@cn.fujitsu.com>
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
1.7.12.4

