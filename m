From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH iptables] utils: nfsynproxy: fix error while compiling the BPF filter
Date: Mon, 18 Nov 2013 19:12:48 +0100
Message-ID: <1384798368-16133-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net, Jesper Dangaard Brouer <brouer@redhat.com>,
	Martin Topholm <mph@one.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:55832 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751420Ab3KRSNA (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 18 Nov 2013 13:13:00 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Fix the following error while running nfsynproxy here:

 pcap_compile: not-yet-activated pcap_t passed to pcap_compile

According to what I have read, we have to compile the filter
once it has been activated.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 utils/nfsynproxy.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/utils/nfsynproxy.c b/utils/nfsynproxy.c
index 9b6de93..51ab720 100644
--- a/utils/nfsynproxy.c
+++ b/utils/nfsynproxy.c
@@ -109,12 +109,6 @@ static void probe_host(const char *host)
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
 		goto err3;
@@ -125,6 +119,12 @@ static void probe_host(const char *host)
 		goto err3;
 	}
 
+	if (pcap_compile(ph, &fp, "src host 127.0.0.1 and tcp and src port 80",
+			 1, PCAP_NETMASK_UNKNOWN) == -1) {
+		pcap_perror(ph, "pcap_compile");
+		goto err2;
+	}
+
 	fd = socket(AF_INET, SOCK_STREAM, 0);
 	if (fd < 0) {
 		perror("socket");
-- 
1.7.10.4

