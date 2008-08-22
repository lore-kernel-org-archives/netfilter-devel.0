From: WANG Cong <xiyou.wangcong@gmail.com>
Subject: [Patch] fix one typo
Date: Fri, 22 Aug 2008 17:32:40 +0100
Message-ID: <20080822163240.GH3053@hack.voiplan.pt>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ik-out-1112.google.com ([66.249.90.176]:11567 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750801AbYHVQeX (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 22 Aug 2008 12:34:23 -0400
Received: by ik-out-1112.google.com with SMTP id c28so371917ika.5
        for <netfilter-devel@vger.kernel.org>; Fri, 22 Aug 2008 09:34:22 -0700 (PDT)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


Fix a typo in a man page.

Signed-off-by: WANG Cong <wangcong@zeuux.org>

---
diff --git a/extensions/libxt_tcp.man b/extensions/libxt_tcp.man
index b087fc9..4b7b2d1 100644
--- a/extensions/libxt_tcp.man
+++ b/extensions/libxt_tcp.man
@@ -7,7 +7,7 @@ name or a port number. An inclusive range can also be specified,
 using the format \fIport\fP\fB:\fP\fIport\fP.
 If the first port is omitted, "0" is assumed; if the last is omitted,
 "65535" is assumed.
-If the second port greater then the first they will be swapped.
+If the second port greater than the first they will be swapped.
 The flag
 .B --sport
 is a convenient alias for this option.

