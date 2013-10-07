From: Gao feng <gaofeng@cn.fujitsu.com>
Subject: [PATCH] man: update the manpage for cluster match
Date: Mon, 7 Oct 2013 16:22:56 +0800
Message-ID: <1381134176-18168-1-git-send-email-gaofeng@cn.fujitsu.com>
Cc: Gao feng <gaofeng@cn.fujitsu.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:10882 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751604Ab3JGJAI (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 7 Oct 2013 05:00:08 -0400
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id r978LkfG018535
	for <netfilter-devel@vger.kernel.org>; Mon, 7 Oct 2013 16:21:50 +0800
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

--h-length,--mangle-mac-s,--mangle-mac-d,--destination-mac
are not supported by arptables now,and the chain name is IN/OUT.

Signed-off-by: Gao feng <gaofeng@cn.fujitsu.com>
---
 extensions/libxt_cluster.man | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/extensions/libxt_cluster.man b/extensions/libxt_cluster.man
index 62ad71c..808a4d7 100644
--- a/extensions/libxt_cluster.man
+++ b/extensions/libxt_cluster.man
@@ -41,19 +41,19 @@ ip maddr add 01:00:5e:00:01:01 dev eth1
 .IP
 ip maddr add 01:00:5e:00:01:02 dev eth2
 .IP
-arptables \-A OUTPUT \-o eth1 \-\-h\-length 6
-\-j mangle \-\-mangle-mac-s 01:00:5e:00:01:01
+arptables \-A OUT \-o eth1 \-arhln 6
+\-j mangle \-\-mangle-hw-s 01:00:5e:00:01:01
 .IP
-arptables \-A INPUT \-i eth1 \-\-h-length 6
-\-\-destination-mac 01:00:5e:00:01:01
-\-j mangle \-\-mangle\-mac\-d 00:zz:yy:xx:5a:27
+arptables \-A IN \-i eth1 \-arhln 6
+\-\-target-hw 01:00:5e:00:01:01
+\-j mangle \-\-mangle\-hw\-d 00:zz:yy:xx:5a:27
 .IP
-arptables \-A OUTPUT \-o eth2 \-\-h\-length 6
-\-j mangle \-\-mangle\-mac\-s 01:00:5e:00:01:02
+arptables \-A OUT \-o eth2 \-arhln 6
+\-j mangle \-\-mangle\-hw\-s 01:00:5e:00:01:02
 .IP
-arptables \-A INPUT \-i eth2 \-\-h\-length 6
-\-\-destination\-mac 01:00:5e:00:01:02
-\-j mangle \-\-mangle\-mac\-d 00:zz:yy:xx:5a:27
+arptables \-A IN \-i eth2 \-arhln 6
+\-\-target\-hw 01:00:5e:00:01:02
+\-j mangle \-\-mangle\-hw\-d 00:zz:yy:xx:5a:27
 .PP
 In the case of TCP connections, pickup facility has to be disabled
 to avoid marking TCP ACK packets coming in the reply direction as
-- 
1.8.3.1

