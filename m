From: Arushi Singhal <arushisinghal19971997@gmail.com>
Subject: [PATCH v2] iptables: extensions: Remove assignments in if condition.
Date: Thu, 30 Mar 2017 19:13:27 +0530
Message-ID: <20170330134326.GA30578@arushi-HP-Pavilion-Notebook>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: outreachy-kernel@googlegroups.com
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pg0-f68.google.com ([74.125.83.68]:35581 "EHLO
        mail-pg0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933002AbdC3Nnd (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 30 Mar 2017 09:43:33 -0400
Received: by mail-pg0-f68.google.com with SMTP id g2so10178355pge.2
        for <netfilter-devel@vger.kernel.org>; Thu, 30 Mar 2017 06:43:32 -0700 (PDT)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Remove assignments in if condition as reported by checkpatch.pl.

Signed-off-by: Arushi Singhal <arushisinghal19971997@gmail.com>
---
change in v2
 *remove the error.

 extensions/libebt_ip.c          | 9 ++++++---
 extensions/libip6t_ipv6header.c | 5 +++--
 2 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/extensions/libebt_ip.c b/extensions/libebt_ip.c
index 4ca63e9..6b301e2 100644
--- a/extensions/libebt_ip.c
+++ b/extensions/libebt_ip.c
@@ -70,7 +70,8 @@ parse_port_range(const char *protocol, const char *portstring, uint16_t *ports)
 	char *cp;
 
 	buffer = strdup(portstring);
-	if ((cp = strchr(buffer, ':')) == NULL)
+	cp = strchr(buffer, ':');
+	if (!cp)
 		ports[0] = ports[1] = xtables_parse_port(buffer, NULL);
 	else {
 		*cp = '\0';
@@ -98,7 +99,8 @@ static int undot_ip(char *ip, unsigned char *ip2)
 
 	p = buf;
 	for (i = 0; i < 3; i++) {
-		if ((q = strchr(p, '.')) == NULL)
+		q = strchr(p, '.');
+		if (!q)
 			return -1;
 		*q = '\0';
 		onebyte = strtol(p, &end, 10);
@@ -143,7 +145,8 @@ static void ebt_parse_ip_address(char *address, uint32_t *addr, uint32_t *msk)
 	char *p;
 
 	/* first the mask */
-	if ((p = strrchr(address, '/')) != NULL) {
+	p = strrchr(address, '/');
+	if (p) {
 		*p = '\0';
 		if (ip_mask(p + 1, (unsigned char *)msk)) {
 			xtables_error(PARAMETER_PROBLEM,
diff --git a/extensions/libip6t_ipv6header.c b/extensions/libip6t_ipv6header.c
index 6f03087..887d225 100644
--- a/extensions/libip6t_ipv6header.c
+++ b/extensions/libip6t_ipv6header.c
@@ -85,8 +85,9 @@ name_to_proto(const char *s)
         unsigned int proto=0;
 	const struct protoent *pent;
 
-        if ((pent = getprotobyname(s)))
-        	proto = pent->p_proto;
+	pent = getprotobyname(s);
+        if (pent)
+		proto = pent->p_proto;
         else {
         	unsigned int i;
         	for (i = 0; i < ARRAY_SIZE(chain_protos); ++i)
-- 
2.11.0

