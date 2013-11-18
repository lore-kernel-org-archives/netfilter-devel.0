From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH iptables v2] utils: nfsynproxy: fix error while compiling the BPF filter
Date: Mon, 18 Nov 2013 19:33:07 +0100
Message-ID: <1384799587-16902-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net, Jesper Dangaard Brouer <brouer@redhat.com>,
	Martin Topholm <mph@one.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:59568 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751300Ab3KRSdS (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 18 Nov 2013 13:33:18 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Fix the following error while running nfsynproxy here:

 pcap_compile: not-yet-activated pcap_t passed to pcap_compile

According to what I have read, we have to compile the filter
once it has been activated.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v2: fix incorrect error path in v1

 utils/nfsynproxy.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/utils/nfsynproxy.c b/utils/nfsynproxy.c
index 9b6de93..baedc92 100644
--- a/utils/nfsynproxy.c
+++ b/utils/nfsynproxy.c
@@ -109,20 +109,20 @@ static void probe_host(const char *host)
 		goto err2;
 	}
 
-	if (pcap_compile(ph, &fp, "src host 127.0.0.1 and tcp and src port 80",
-			 1, PCAP_NETMASK_UNKNOWN) == -1) {
-		pcap_perror(ph, "pcap_compile");
-		goto err2;
-	}
-
 	if (pcap_setfilter(ph, &fp) == -1) {
 		pcap_perror(ph, "pcap_setfilter");
-		goto err3;
+		goto err2;
 	}
 
 	if (pcap_activate(ph) != 0) {
 		pcap_perror(ph, "pcap_activate");
-		goto err3;
+		goto err2;
+	}
+
+	if (pcap_compile(ph, &fp, "src host 127.0.0.1 and tcp and src port 80",
+			 1, PCAP_NETMASK_UNKNOWN) == -1) {
+		pcap_perror(ph, "pcap_compile");
+		goto err2;
 	}
 
 	fd = socket(AF_INET, SOCK_STREAM, 0);
-- 
1.7.10.4

