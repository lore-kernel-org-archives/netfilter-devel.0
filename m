From: Ulrich Weber <ulrich.weber@sophos.com>
Subject: [PATCH v2] iptables: allow IPv6 port NAT without address NAT
Date: Thu, 3 Jan 2013 11:39:58 +0100
Message-ID: <20130103103958.GA9315@uweber-WS>
References: <20130102155244.GB5133@uweber-WS>
 <20130103001306.GB27394@1984>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Cc: <netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx2.sophos.com ([145.253.124.138]:59391 "EHLO mx2.sophos.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752981Ab3ACKkG (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 3 Jan 2013 05:40:06 -0500
Content-Disposition: inline
In-Reply-To: <20130103001306.GB27394@1984>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

correct parsing of IPv6 port NAT without address NAT,
assume one colon as port information.

Allows:
* address only:
 -j DNAT --to affe::1
 -j DNAT --to [affe::1]

* port only
 -j DNAT --to :80
 -j DNAT --to :80-110
 -j DNAT --to []:80
 -j DNAT --to []:80-110

* address and port
 -j DNAT --to [affe::1]:80
 -j DNAT --to [affe::1]:80-110

Signed-off-by: Ulrich Weber <ulrich.weber@sophos.com>
---
 extensions/libip6t_DNAT.c | 11 ++++++++---
 extensions/libip6t_SNAT.c | 11 ++++++++---
 2 files changed, 16 insertions(+), 6 deletions(-)

diff --git a/extensions/libip6t_DNAT.c b/extensions/libip6t_DNAT.c
index a5969c3..1bba37e 100644
--- a/extensions/libip6t_DNAT.c
+++ b/extensions/libip6t_DNAT.c
@@ -54,8 +54,13 @@ parse_to(const char *orig_arg, int portok, struct nf_nat_range *range)
 		xtables_error(RESOURCE_PROBLEM, "strdup");
 
 	start = strchr(arg, '[');
-	if (start == NULL)
+	if (start == NULL) {
 		start = arg;
+		/* Lets assume one colon is port information. Otherwise its an IPv6 address */
+		colon = strchr(arg, ':');
+		if (colon && strchr(colon+1, ':'))
+			colon = NULL;
+	}
 	else {
 		start++;
 		end = strchr(start, ']');
@@ -105,8 +110,8 @@ parse_to(const char *orig_arg, int portok, struct nf_nat_range *range)
 			range->min_proto.tcp.port = htons(port);
 			range->max_proto.tcp.port = htons(maxport);
 		}
-		/* Starts with a colon? No IP info...*/
-		if (colon == arg) {
+		/* Starts with colon or [] colon? No IP info...*/
+		if (colon == arg || colon == arg+2) {
 			free(arg);
 			return;
 		}
diff --git a/extensions/libip6t_SNAT.c b/extensions/libip6t_SNAT.c
index 307be70..7382ad0 100644
--- a/extensions/libip6t_SNAT.c
+++ b/extensions/libip6t_SNAT.c
@@ -54,8 +54,13 @@ parse_to(const char *orig_arg, int portok, struct nf_nat_range *range)
 		xtables_error(RESOURCE_PROBLEM, "strdup");
 
 	start = strchr(arg, '[');
-	if (start == NULL)
+	if (start == NULL) {
 		start = arg;
+		/* Lets assume one colon is port information. Otherwise its an IPv6 address */
+		colon = strchr(arg, ':');
+		if (colon && strchr(colon+1, ':'))
+			colon = NULL;
+	}
 	else {
 		start++;
 		end = strchr(start, ']');
@@ -105,8 +110,8 @@ parse_to(const char *orig_arg, int portok, struct nf_nat_range *range)
 			range->min_proto.tcp.port = htons(port);
 			range->max_proto.tcp.port = htons(maxport);
 		}
-		/* Starts with a colon? No IP info...*/
-		if (colon == arg) {
+		/* Starts with colon or [] colon? No IP info...*/
+		if (colon == arg || colon == arg+2) {
 			free(arg);
 			return;
 		}
-- 
1.8.0.2

