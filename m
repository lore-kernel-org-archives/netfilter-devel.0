From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: [PATCH 27/34] netfilter: ipset: Check for comment netlink attribute length
Date: Sat,  2 May 2015 19:28:16 +0200
Message-ID: <1430587703-3387-28-git-send-email-kadlec@blackhole.kfki.hu>
References: <1430587703-3387-1-git-send-email-kadlec@blackhole.kfki.hu>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp0.kfki.hu ([148.6.0.25]:51384 "EHLO smtp0.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751644AbbEBR2I (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 2 May 2015 13:28:08 -0400
In-Reply-To: <1430587703-3387-1-git-send-email-kadlec@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Sergey Popovich <popovich_sergei@mail.ua>

Ensure userspace supplies string not longer than
IPSET_MAX_COMMENT_SIZE.

Signed-off-by: Sergey Popovich <popovich_sergei@mail.ua>
Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
---
 net/netfilter/ipset/ip_set_bitmap_ip.c       | 3 ++-
 net/netfilter/ipset/ip_set_bitmap_ipmac.c    | 3 ++-
 net/netfilter/ipset/ip_set_bitmap_port.c     | 3 ++-
 net/netfilter/ipset/ip_set_hash_ip.c         | 3 ++-
 net/netfilter/ipset/ip_set_hash_ipmark.c     | 3 ++-
 net/netfilter/ipset/ip_set_hash_ipport.c     | 3 ++-
 net/netfilter/ipset/ip_set_hash_ipportip.c   | 3 ++-
 net/netfilter/ipset/ip_set_hash_ipportnet.c  | 3 ++-
 net/netfilter/ipset/ip_set_hash_mac.c        | 3 ++-
 net/netfilter/ipset/ip_set_hash_net.c        | 3 ++-
 net/netfilter/ipset/ip_set_hash_netiface.c   | 3 ++-
 net/netfilter/ipset/ip_set_hash_netnet.c     | 3 ++-
 net/netfilter/ipset/ip_set_hash_netport.c    | 3 ++-
 net/netfilter/ipset/ip_set_hash_netportnet.c | 3 ++-
 net/netfilter/ipset/ip_set_list_set.c        | 3 ++-
 15 files changed, 30 insertions(+), 15 deletions(-)

diff --git a/net/netfilter/ipset/ip_set_bitmap_ip.c b/net/netfilter/ipset/ip_set_bitmap_ip.c
index 4ddde53..b8ce474 100644
--- a/net/netfilter/ipset/ip_set_bitmap_ip.c
+++ b/net/netfilter/ipset/ip_set_bitmap_ip.c
@@ -358,7 +358,8 @@ static struct ip_set_type bitmap_ip_type __read_mostly = {
 		[IPSET_ATTR_LINENO]	= { .type = NLA_U32 },
 		[IPSET_ATTR_BYTES]	= { .type = NLA_U64 },
 		[IPSET_ATTR_PACKETS]	= { .type = NLA_U64 },
-		[IPSET_ATTR_COMMENT]	= { .type = NLA_NUL_STRING },
+		[IPSET_ATTR_COMMENT]	= { .type = NLA_NUL_STRING,
+					    .len  = IPSET_MAX_COMMENT_SIZE },
 		[IPSET_ATTR_SKBMARK]	= { .type = NLA_U64 },
 		[IPSET_ATTR_SKBPRIO]	= { .type = NLA_U32 },
 		[IPSET_ATTR_SKBQUEUE]	= { .type = NLA_U16 },
diff --git a/net/netfilter/ipset/ip_set_bitmap_ipmac.c b/net/netfilter/ipset/ip_set_bitmap_ipmac.c
index e1899fe..fe00e87 100644
--- a/net/netfilter/ipset/ip_set_bitmap_ipmac.c
+++ b/net/netfilter/ipset/ip_set_bitmap_ipmac.c
@@ -403,7 +403,8 @@ static struct ip_set_type bitmap_ipmac_type = {
 		[IPSET_ATTR_LINENO]	= { .type = NLA_U32 },
 		[IPSET_ATTR_BYTES]	= { .type = NLA_U64 },
 		[IPSET_ATTR_PACKETS]	= { .type = NLA_U64 },
-		[IPSET_ATTR_COMMENT]	= { .type = NLA_NUL_STRING },
+		[IPSET_ATTR_COMMENT]	= { .type = NLA_NUL_STRING,
+					    .len  = IPSET_MAX_COMMENT_SIZE },
 		[IPSET_ATTR_SKBMARK]	= { .type = NLA_U64 },
 		[IPSET_ATTR_SKBPRIO]	= { .type = NLA_U32 },
 		[IPSET_ATTR_SKBQUEUE]	= { .type = NLA_U16 },
diff --git a/net/netfilter/ipset/ip_set_bitmap_port.c b/net/netfilter/ipset/ip_set_bitmap_port.c
index 4d79d84..2d360f9 100644
--- a/net/netfilter/ipset/ip_set_bitmap_port.c
+++ b/net/netfilter/ipset/ip_set_bitmap_port.c
@@ -288,7 +288,8 @@ static struct ip_set_type bitmap_port_type = {
 		[IPSET_ATTR_LINENO]	= { .type = NLA_U32 },
 		[IPSET_ATTR_BYTES]	= { .type = NLA_U64 },
 		[IPSET_ATTR_PACKETS]	= { .type = NLA_U64 },
-		[IPSET_ATTR_COMMENT]	= { .type = NLA_NUL_STRING },
+		[IPSET_ATTR_COMMENT]	= { .type = NLA_NUL_STRING,
+					    .len  = IPSET_MAX_COMMENT_SIZE },
 		[IPSET_ATTR_SKBMARK]	= { .type = NLA_U64 },
 		[IPSET_ATTR_SKBPRIO]	= { .type = NLA_U32 },
 		[IPSET_ATTR_SKBQUEUE]	= { .type = NLA_U16 },
diff --git a/net/netfilter/ipset/ip_set_hash_ip.c b/net/netfilter/ipset/ip_set_hash_ip.c
index 5eaf4aab..e2e2820 100644
--- a/net/netfilter/ipset/ip_set_hash_ip.c
+++ b/net/netfilter/ipset/ip_set_hash_ip.c
@@ -297,7 +297,8 @@ static struct ip_set_type hash_ip_type __read_mostly = {
 		[IPSET_ATTR_LINENO]	= { .type = NLA_U32 },
 		[IPSET_ATTR_BYTES]	= { .type = NLA_U64 },
 		[IPSET_ATTR_PACKETS]	= { .type = NLA_U64 },
-		[IPSET_ATTR_COMMENT]	= { .type = NLA_NUL_STRING },
+		[IPSET_ATTR_COMMENT]	= { .type = NLA_NUL_STRING,
+					    .len  = IPSET_MAX_COMMENT_SIZE },
 		[IPSET_ATTR_SKBMARK]	= { .type = NLA_U64 },
 		[IPSET_ATTR_SKBPRIO]	= { .type = NLA_U32 },
 		[IPSET_ATTR_SKBQUEUE]	= { .type = NLA_U16 },
diff --git a/net/netfilter/ipset/ip_set_hash_ipmark.c b/net/netfilter/ipset/ip_set_hash_ipmark.c
index 7da3638..da82cc8 100644
--- a/net/netfilter/ipset/ip_set_hash_ipmark.c
+++ b/net/netfilter/ipset/ip_set_hash_ipmark.c
@@ -303,7 +303,8 @@ static struct ip_set_type hash_ipmark_type __read_mostly = {
 		[IPSET_ATTR_LINENO]	= { .type = NLA_U32 },
 		[IPSET_ATTR_BYTES]	= { .type = NLA_U64 },
 		[IPSET_ATTR_PACKETS]	= { .type = NLA_U64 },
-		[IPSET_ATTR_COMMENT]	= { .type = NLA_NUL_STRING },
+		[IPSET_ATTR_COMMENT]	= { .type = NLA_NUL_STRING,
+					    .len  = IPSET_MAX_COMMENT_SIZE },
 		[IPSET_ATTR_SKBMARK]	= { .type = NLA_U64 },
 		[IPSET_ATTR_SKBPRIO]	= { .type = NLA_U32 },
 		[IPSET_ATTR_SKBQUEUE]	= { .type = NLA_U16 },
diff --git a/net/netfilter/ipset/ip_set_hash_ipport.c b/net/netfilter/ipset/ip_set_hash_ipport.c
index 3589cc3..650ab31 100644
--- a/net/netfilter/ipset/ip_set_hash_ipport.c
+++ b/net/netfilter/ipset/ip_set_hash_ipport.c
@@ -366,7 +366,8 @@ static struct ip_set_type hash_ipport_type __read_mostly = {
 		[IPSET_ATTR_LINENO]	= { .type = NLA_U32 },
 		[IPSET_ATTR_BYTES]	= { .type = NLA_U64 },
 		[IPSET_ATTR_PACKETS]	= { .type = NLA_U64 },
-		[IPSET_ATTR_COMMENT]	= { .type = NLA_NUL_STRING },
+		[IPSET_ATTR_COMMENT]	= { .type = NLA_NUL_STRING,
+					    .len  = IPSET_MAX_COMMENT_SIZE },
 		[IPSET_ATTR_SKBMARK]	= { .type = NLA_U64 },
 		[IPSET_ATTR_SKBPRIO]	= { .type = NLA_U32 },
 		[IPSET_ATTR_SKBQUEUE]	= { .type = NLA_U16 },
diff --git a/net/netfilter/ipset/ip_set_hash_ipportip.c b/net/netfilter/ipset/ip_set_hash_ipportip.c
index a424693..2d30bb0 100644
--- a/net/netfilter/ipset/ip_set_hash_ipportip.c
+++ b/net/netfilter/ipset/ip_set_hash_ipportip.c
@@ -378,7 +378,8 @@ static struct ip_set_type hash_ipportip_type __read_mostly = {
 		[IPSET_ATTR_LINENO]	= { .type = NLA_U32 },
 		[IPSET_ATTR_BYTES]	= { .type = NLA_U64 },
 		[IPSET_ATTR_PACKETS]	= { .type = NLA_U64 },
-		[IPSET_ATTR_COMMENT]	= { .type = NLA_NUL_STRING },
+		[IPSET_ATTR_COMMENT]	= { .type = NLA_NUL_STRING,
+					    .len  = IPSET_MAX_COMMENT_SIZE },
 		[IPSET_ATTR_SKBMARK]	= { .type = NLA_U64 },
 		[IPSET_ATTR_SKBPRIO]	= { .type = NLA_U32 },
 		[IPSET_ATTR_SKBQUEUE]	= { .type = NLA_U16 },
diff --git a/net/netfilter/ipset/ip_set_hash_ipportnet.c b/net/netfilter/ipset/ip_set_hash_ipportnet.c
index 14fb731..0252278 100644
--- a/net/netfilter/ipset/ip_set_hash_ipportnet.c
+++ b/net/netfilter/ipset/ip_set_hash_ipportnet.c
@@ -535,7 +535,8 @@ static struct ip_set_type hash_ipportnet_type __read_mostly = {
 		[IPSET_ATTR_LINENO]	= { .type = NLA_U32 },
 		[IPSET_ATTR_BYTES]	= { .type = NLA_U64 },
 		[IPSET_ATTR_PACKETS]	= { .type = NLA_U64 },
-		[IPSET_ATTR_COMMENT]	= { .type = NLA_NUL_STRING },
+		[IPSET_ATTR_COMMENT]	= { .type = NLA_NUL_STRING,
+					    .len  = IPSET_MAX_COMMENT_SIZE },
 		[IPSET_ATTR_SKBMARK]	= { .type = NLA_U64 },
 		[IPSET_ATTR_SKBPRIO]	= { .type = NLA_U32 },
 		[IPSET_ATTR_SKBQUEUE]	= { .type = NLA_U16 },
diff --git a/net/netfilter/ipset/ip_set_hash_mac.c b/net/netfilter/ipset/ip_set_hash_mac.c
index 829d70f..112aff3 100644
--- a/net/netfilter/ipset/ip_set_hash_mac.c
+++ b/net/netfilter/ipset/ip_set_hash_mac.c
@@ -147,7 +147,8 @@ static struct ip_set_type hash_mac_type __read_mostly = {
 		[IPSET_ATTR_LINENO]	= { .type = NLA_U32 },
 		[IPSET_ATTR_BYTES]	= { .type = NLA_U64 },
 		[IPSET_ATTR_PACKETS]	= { .type = NLA_U64 },
-		[IPSET_ATTR_COMMENT]	= { .type = NLA_NUL_STRING },
+		[IPSET_ATTR_COMMENT]	= { .type = NLA_NUL_STRING,
+					    .len  = IPSET_MAX_COMMENT_SIZE },
 		[IPSET_ATTR_SKBMARK]	= { .type = NLA_U64 },
 		[IPSET_ATTR_SKBPRIO]	= { .type = NLA_U32 },
 		[IPSET_ATTR_SKBQUEUE]	= { .type = NLA_U16 },
diff --git a/net/netfilter/ipset/ip_set_hash_net.c b/net/netfilter/ipset/ip_set_hash_net.c
index 9b163f8..e49b1d0 100644
--- a/net/netfilter/ipset/ip_set_hash_net.c
+++ b/net/netfilter/ipset/ip_set_hash_net.c
@@ -374,7 +374,8 @@ static struct ip_set_type hash_net_type __read_mostly = {
 		[IPSET_ATTR_CADT_FLAGS]	= { .type = NLA_U32 },
 		[IPSET_ATTR_BYTES]	= { .type = NLA_U64 },
 		[IPSET_ATTR_PACKETS]	= { .type = NLA_U64 },
-		[IPSET_ATTR_COMMENT]	= { .type = NLA_NUL_STRING },
+		[IPSET_ATTR_COMMENT]	= { .type = NLA_NUL_STRING,
+					    .len  = IPSET_MAX_COMMENT_SIZE },
 		[IPSET_ATTR_SKBMARK]	= { .type = NLA_U64 },
 		[IPSET_ATTR_SKBPRIO]	= { .type = NLA_U32 },
 		[IPSET_ATTR_SKBQUEUE]	= { .type = NLA_U16 },
diff --git a/net/netfilter/ipset/ip_set_hash_netiface.c b/net/netfilter/ipset/ip_set_hash_netiface.c
index 2dbb859..a480eca 100644
--- a/net/netfilter/ipset/ip_set_hash_netiface.c
+++ b/net/netfilter/ipset/ip_set_hash_netiface.c
@@ -485,7 +485,8 @@ static struct ip_set_type hash_netiface_type __read_mostly = {
 		[IPSET_ATTR_LINENO]	= { .type = NLA_U32 },
 		[IPSET_ATTR_BYTES]	= { .type = NLA_U64 },
 		[IPSET_ATTR_PACKETS]	= { .type = NLA_U64 },
-		[IPSET_ATTR_COMMENT]	= { .type = NLA_NUL_STRING },
+		[IPSET_ATTR_COMMENT]	= { .type = NLA_NUL_STRING,
+					    .len  = IPSET_MAX_COMMENT_SIZE },
 		[IPSET_ATTR_SKBMARK]	= { .type = NLA_U64 },
 		[IPSET_ATTR_SKBPRIO]	= { .type = NLA_U32 },
 		[IPSET_ATTR_SKBQUEUE]	= { .type = NLA_U16 },
diff --git a/net/netfilter/ipset/ip_set_hash_netnet.c b/net/netfilter/ipset/ip_set_hash_netnet.c
index 72aa08f..b5428be 100644
--- a/net/netfilter/ipset/ip_set_hash_netnet.c
+++ b/net/netfilter/ipset/ip_set_hash_netnet.c
@@ -462,7 +462,8 @@ static struct ip_set_type hash_netnet_type __read_mostly = {
 		[IPSET_ATTR_CADT_FLAGS]	= { .type = NLA_U32 },
 		[IPSET_ATTR_BYTES]	= { .type = NLA_U64 },
 		[IPSET_ATTR_PACKETS]	= { .type = NLA_U64 },
-		[IPSET_ATTR_COMMENT]	= { .type = NLA_NUL_STRING },
+		[IPSET_ATTR_COMMENT]	= { .type = NLA_NUL_STRING,
+					    .len  = IPSET_MAX_COMMENT_SIZE },
 		[IPSET_ATTR_SKBMARK]	= { .type = NLA_U64 },
 		[IPSET_ATTR_SKBPRIO]	= { .type = NLA_U32 },
 		[IPSET_ATTR_SKBQUEUE]	= { .type = NLA_U16 },
diff --git a/net/netfilter/ipset/ip_set_hash_netport.c b/net/netfilter/ipset/ip_set_hash_netport.c
index 23f0f20..27307d0 100644
--- a/net/netfilter/ipset/ip_set_hash_netport.c
+++ b/net/netfilter/ipset/ip_set_hash_netport.c
@@ -480,7 +480,8 @@ static struct ip_set_type hash_netport_type __read_mostly = {
 		[IPSET_ATTR_CADT_FLAGS]	= { .type = NLA_U32 },
 		[IPSET_ATTR_BYTES]	= { .type = NLA_U64 },
 		[IPSET_ATTR_PACKETS]	= { .type = NLA_U64 },
-		[IPSET_ATTR_COMMENT]	= { .type = NLA_NUL_STRING },
+		[IPSET_ATTR_COMMENT]	= { .type = NLA_NUL_STRING,
+					    .len  = IPSET_MAX_COMMENT_SIZE },
 		[IPSET_ATTR_SKBMARK]	= { .type = NLA_U64 },
 		[IPSET_ATTR_SKBPRIO]	= { .type = NLA_U32 },
 		[IPSET_ATTR_SKBQUEUE]	= { .type = NLA_U16 },
diff --git a/net/netfilter/ipset/ip_set_hash_netportnet.c b/net/netfilter/ipset/ip_set_hash_netportnet.c
index 2ab3c55..1e0e47a 100644
--- a/net/netfilter/ipset/ip_set_hash_netportnet.c
+++ b/net/netfilter/ipset/ip_set_hash_netportnet.c
@@ -563,7 +563,8 @@ static struct ip_set_type hash_netportnet_type __read_mostly = {
 		[IPSET_ATTR_LINENO]	= { .type = NLA_U32 },
 		[IPSET_ATTR_BYTES]	= { .type = NLA_U64 },
 		[IPSET_ATTR_PACKETS]	= { .type = NLA_U64 },
-		[IPSET_ATTR_COMMENT]	= { .type = NLA_NUL_STRING },
+		[IPSET_ATTR_COMMENT]	= { .type = NLA_NUL_STRING,
+					    .len  = IPSET_MAX_COMMENT_SIZE },
 		[IPSET_ATTR_SKBMARK]	= { .type = NLA_U64 },
 		[IPSET_ATTR_SKBPRIO]	= { .type = NLA_U32 },
 		[IPSET_ATTR_SKBQUEUE]	= { .type = NLA_U16 },
diff --git a/net/netfilter/ipset/ip_set_list_set.c b/net/netfilter/ipset/ip_set_list_set.c
index 8745995..507d1ab 100644
--- a/net/netfilter/ipset/ip_set_list_set.c
+++ b/net/netfilter/ipset/ip_set_list_set.c
@@ -646,7 +646,8 @@ static struct ip_set_type list_set_type __read_mostly = {
 		[IPSET_ATTR_CADT_FLAGS]	= { .type = NLA_U32 },
 		[IPSET_ATTR_BYTES]	= { .type = NLA_U64 },
 		[IPSET_ATTR_PACKETS]	= { .type = NLA_U64 },
-		[IPSET_ATTR_COMMENT]	= { .type = NLA_NUL_STRING },
+		[IPSET_ATTR_COMMENT]	= { .type = NLA_NUL_STRING,
+					    .len  = IPSET_MAX_COMMENT_SIZE },
 		[IPSET_ATTR_SKBMARK]	= { .type = NLA_U64 },
 		[IPSET_ATTR_SKBPRIO]	= { .type = NLA_U32 },
 		[IPSET_ATTR_SKBQUEUE]	= { .type = NLA_U16 },
-- 
1.8.5.1

