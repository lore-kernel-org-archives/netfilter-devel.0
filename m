From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH iptables] extensions: libxt_cluster: add note on arptables-jf
Date: Mon,  4 Nov 2013 11:53:59 +0100
Message-ID: <1383562439-12113-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:45608 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750789Ab3KDKyJ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 4 Nov 2013 05:54:09 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Gao feng reported problems while getting the cluster match working with
arptables. This patch adds a note in the manpage to warn about the arptables-jf
syntax, which is different from mainstream arptables.

Reported-by: Gao feng <gaofeng@cn.fujitsu.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 extensions/libxt_cluster.man |    5 +++++
 1 file changed, 5 insertions(+)

diff --git a/extensions/libxt_cluster.man b/extensions/libxt_cluster.man
index 62ad71c..94b4b20 100644
--- a/extensions/libxt_cluster.man
+++ b/extensions/libxt_cluster.man
@@ -55,6 +55,11 @@ arptables \-A INPUT \-i eth2 \-\-h\-length 6
 \-\-destination\-mac 01:00:5e:00:01:02
 \-j mangle \-\-mangle\-mac\-d 00:zz:yy:xx:5a:27
 .PP
+\fBNOTE\fP: the arptables commands above use mainstream syntax. If you
+are using arptables-jf included in some RedHat, CentOS and Fedora
+versions, you will hit syntax errors. Therefore, you'll have to adapt
+these to the arptables-jf syntax to get them working.
+.PP
 In the case of TCP connections, pickup facility has to be disabled
 to avoid marking TCP ACK packets coming in the reply direction as
 valid.
-- 
1.7.10.4

