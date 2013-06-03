From: Zang MingJie <zealot0630@gmail.com>
Subject: [PATCH 1/1] netfilter: nf_ct_tcp: extend CLOSE_WAIT timeout
Date: Mon,  3 Jun 2013 11:42:09 -0400
Message-ID: <1370274129-15425-1-git-send-email-zealot0630@gmail.com>
Cc: Zang MingJie <zealot0630@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pb0-f49.google.com ([209.85.160.49]:61160 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756694Ab3FCPmx (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 3 Jun 2013 11:42:53 -0400
Received: by mail-pb0-f49.google.com with SMTP id jt11so1755788pbb.36
        for <netfilter-devel@vger.kernel.org>; Mon, 03 Jun 2013 08:42:53 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

According to TCP RFC, there is no timer of CLOSING or CLOSE_WAIT
state, and the half closed connection is still stable, so the
timeout value of CLOSE_WAIT state should equal to ESTABLISHED state.

Signed-off-by: Zang MingJie <zealot0630@gmail.com>
---
 net/netfilter/nf_conntrack_proto_tcp.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nf_conntrack_proto_tcp.c b/net/netfilter/nf_conntrack_proto_tcp.c
index 4d4d8f1..f9dd393 100644
--- a/net/netfilter/nf_conntrack_proto_tcp.c
+++ b/net/netfilter/nf_conntrack_proto_tcp.c
@@ -71,7 +71,7 @@ static unsigned int tcp_timeouts[TCP_CONNTRACK_TIMEOUT_MAX] __read_mostly = {
 	[TCP_CONNTRACK_SYN_RECV]	= 60 SECS,
 	[TCP_CONNTRACK_ESTABLISHED]	= 5 DAYS,
 	[TCP_CONNTRACK_FIN_WAIT]	= 2 MINS,
-	[TCP_CONNTRACK_CLOSE_WAIT]	= 60 SECS,
+	[TCP_CONNTRACK_CLOSE_WAIT]	= 5 DAYS,
 	[TCP_CONNTRACK_LAST_ACK]	= 30 SECS,
 	[TCP_CONNTRACK_TIME_WAIT]	= 2 MINS,
 	[TCP_CONNTRACK_CLOSE]		= 10 SECS,
-- 
1.7.10.4

