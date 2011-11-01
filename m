From: pablo@netfilter.org
Subject: [PATCH 01/14] ipvs: Expose ip_vs_ftp module parameters via sysfs.
Date: Tue,  1 Nov 2011 10:11:23 +0100
Message-ID: <1320138696-28048-2-git-send-email-pablo@netfilter.org>
References: <1320138696-28048-1-git-send-email-pablo@netfilter.org>
Cc: davem@davemloft.net,
	Krzysztof Wilczynski <krzysztof.wilczynski@linux.com>,
	Simon Horman <horms@verge.net.au>,
	Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:37212 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752744Ab1KAJL7 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 1 Nov 2011 05:11:59 -0400
In-Reply-To: <1320138696-28048-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Krzysztof Wilczynski <krzysztof.wilczynski@linux.com>

This is to expose "ports" parameter via sysfs so it can be read
at any time in order to determine what port or ports were passed
to the module at the point when it was loaded.

Signed-off-by: Krzysztof Wilczynski <krzysztof.wilczynski@linux.com>
Signed-off-by: Simon Horman <horms@verge.net.au>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/ipvs/ip_vs_ftp.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/ipvs/ip_vs_ftp.c b/net/netfilter/ipvs/ip_vs_ftp.c
index 4490a32..538d74e 100644
--- a/net/netfilter/ipvs/ip_vs_ftp.c
+++ b/net/netfilter/ipvs/ip_vs_ftp.c
@@ -52,8 +52,9 @@
  * List of ports (up to IP_VS_APP_MAX_PORTS) to be handled by helper
  * First port is set to the default port.
  */
+static unsigned int ports_count = 1;
 static unsigned short ports[IP_VS_APP_MAX_PORTS] = {21, 0};
-module_param_array(ports, ushort, NULL, 0);
+module_param_array(ports, ushort, &ports_count, 0444);
 MODULE_PARM_DESC(ports, "Ports to monitor for FTP control commands");
 
 
@@ -449,7 +450,7 @@ static int __net_init __ip_vs_ftp_init(struct net *net)
 	if (ret)
 		goto err_exit;
 
-	for (i=0; i<IP_VS_APP_MAX_PORTS; i++) {
+	for (i = 0; i < ports_count; i++) {
 		if (!ports[i])
 			continue;
 		ret = register_ip_vs_app_inc(net, app, app->protocol, ports[i]);
-- 
1.7.2.5

