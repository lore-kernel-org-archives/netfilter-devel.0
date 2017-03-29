From: Arushi Singhal <arushisinghal19971997@gmail.com>
Subject: [PATCH] iptables: extensions: Remove assignment in if condition.
Date: Thu, 30 Mar 2017 05:04:59 +0530
Message-ID: <20170329233459.GA22682@arushi-HP-Pavilion-Notebook>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: outreachy-kernel@googlegroups.com
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pg0-f67.google.com ([74.125.83.67]:34210 "EHLO
        mail-pg0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932877AbdC2XfF (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 29 Mar 2017 19:35:05 -0400
Received: by mail-pg0-f67.google.com with SMTP id o123so5479849pga.1
        for <netfilter-devel@vger.kernel.org>; Wed, 29 Mar 2017 16:35:04 -0700 (PDT)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Remove assignments in if condition as reported by checkpatch.pl.

Signed-off-by: Arushi Singhal <arushisinghal19971997@gmail.com>
---
 extensions/libebt_ip.c          | 11 ++++++-----
 extensions/libip6t_ipv6header.c |  5 +++--
 2 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/extensions/libebt_ip.c b/extensions/libebt_ip.c
index 4ca63e9..deae6f4 100644
--- a/extensions/libebt_ip.c
+++ b/extensions/libebt_ip.c
@@ -68,9 +68,9 @@ parse_port_range(const char *protocol, const char *portstring, uint16_t *ports)
 {
 	char *buffer;
 	char *cp;
-
+	cp = strchr(buffer, ':');
 	buffer = strdup(portstring);
-	if ((cp = strchr(buffer, ':')) == NULL)
+	if (!cp)
 		ports[0] = ports[1] = xtables_parse_port(buffer, NULL);
 	else {
 		*cp = '\0';
@@ -97,8 +97,9 @@ static int undot_ip(char *ip, unsigned char *ip2)
 	strncpy(buf, ip, sizeof(buf) - 1);
 
 	p = buf;
+	q = strchr(p, '.')OA;
 	for (i = 0; i < 3; i++) {
-		if ((q = strchr(p, '.')) == NULL)
+		if (!q)
 			return -1;
 		*q = '\0';
 		onebyte = strtol(p, &end, 10);
@@ -141,9 +142,9 @@ static int ip_mask(char *mask, unsigned char *mask2)
 static void ebt_parse_ip_address(char *address, uint32_t *addr, uint32_t *msk)
 {
 	char *p;
-
+	p = strrchr(address, '/');
 	/* first the mask */
-	if ((p = strrchr(address, '/')) != NULL) {
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

