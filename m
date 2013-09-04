From: valentina.giusti@bmw-carit.de
Subject: [PATCH 4/4] nfacct: Add man page section for the 'notify' commands
Date: Wed,  4 Sep 2013 14:05:33 +0200
Message-ID: <1378296333-19208-5-git-send-email-valentina.giusti@bmw-carit.de>
References: <1378296333-19208-1-git-send-email-valentina.giusti@bmw-carit.de>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Patrick McHardy <kaber@trash.net>,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
	"David S. Miller" <davem@davemloft.net>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.bmw-carit.de ([62.245.222.98]:49608 "EHLO
	linuxmail.bmw-carit.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757274Ab3IDMFg (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 4 Sep 2013 08:05:36 -0400
In-Reply-To: <1378296333-19208-1-git-send-email-valentina.giusti@bmw-carit.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Valentina Giusti <valentina.giusti@bmw-carit.de>

Signed-off-by: Valentina Giusti <valentina.giusti@bmw-carit.de>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Patrick McHardy <kaber@trash.net>
Cc: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Cc: "David S. Miller" <davem@davemloft.net>
---
 nfacct.8 |   59 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 59 insertions(+)

diff --git a/nfacct.8 b/nfacct.8
index 0c3249c..8cc79b7 100644
--- a/nfacct.8
+++ b/nfacct.8
@@ -30,6 +30,65 @@ Delete accounting object.
 .BI "get "
 Get existing accounting object.
 .TP
+.BI "notify "
+Get notifications for existing accounting object.
+Notifications can be sent either periodically, with the option "period", or
+based on the amount of accounted bytes or packets, with the options "bytes"
+and "packets", respectively.
+
+For example, a notification every 1024 bytes can be requested for the accounting
+object "http-traffic":
+.in +4n
+.nf
+
+.RB "$" "nfacct notify http-traffic bytes 1024"
+{ pkts = 00000000000000039225, bytes = 00000000000002361568 } = http-traffic;
+{ pkts = 00000000000000039245, bytes = 00000000000002362608 } = http-traffic;
+ ...
+.fi
+.in
+
+or every 100 packets:
+
+.in +4n
+.nf
+.RB "$" "nfacct notify http-traffic packets 100"
+{ pkts = 00000000000000008303, bytes = 00000000000000486469 } = http-traffic;
+{ pkts = 00000000000000008403, bytes = 00000000000000494581 } = http-traffic;
+ ...
+.fi
+.in
+
+or every 2 minutes:
+
+.in +4n
+.nf
+.RB "$" "nfacct notify http-traffic period 120"
+{ pkts = 00000000000000013133, bytes = 00000000000000796388 } = http-traffic;
+{ pkts = 00000000000000015459, bytes = 00000000000000952884 } = http-traffic;
+ ...
+.fi
+.in
+
+Notification requests can specify at the same time a traffic target (bytes or
+packets) and a time target (period). In this case, additional parameters are
+available, which allow to set a limit for the amount of notifications based on
+accounted packets or bytes to be sent during a single period:
+
+.in +4n
+.nf
+.RB "$" "nfacct notify http-traffic bytes 1024 bytes-ratelimit 4 period 5"
+{ pkts = 00000000000000010172, bytes = 00000000000000628714 } = http-traffic;
+{ pkts = 00000000000000010192, bytes = 00000000000000629754 } = http-traffic;
+{ pkts = 00000000000000010212, bytes = 00000000000000630794 } = http-traffic;
+{ pkts = 00000000000000010232, bytes = 00000000000000631834 } = http-traffic;
+{ pkts = 00000000000000010894, bytes = 00000000000000672343 } = http-traffic;
+ ...
+.fi
+.in
+
+.PP
+.TP
 .BI "flush "
 Delete all unused accounting objects.
 .TP
-- 
1.7.10.4

