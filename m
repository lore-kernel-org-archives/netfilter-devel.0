From: Harsha Sharma <harshasharmaiitr@gmail.com>
Subject: [PATCH] exthdr: Add support for reserved header and address
Date: Mon,  2 Oct 2017 02:07:00 +0530
Message-ID: <1506890220-12226-1-git-send-email-harshasharmaiitr@gmail.com>
Cc: netfilter-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        outreachy-kernel@googlegroups.com,
        Harsha Sharma <harshasharmaiitr@gmail.com>
To: pablo@netfilter.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Add support for IPV6 type 0 routing header reserved field and address
unable to test it with nft-test.py

Signed-off-by: Harsha Sharma <harshasharmaiitr@gmail.com>
---
 include/exthdr.h  | 2 ++
 src/exthdr.c      | 7 +------
 tests/py/ip6/rt.t | 2 ++
 3 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/include/exthdr.h b/include/exthdr.h
index 97ccc38..ad09f27 100644
--- a/include/exthdr.h
+++ b/include/exthdr.h
@@ -14,6 +14,8 @@
 struct exthdr_desc {
 	const char			*name;
 	uint8_t				type;
+	unsigned int			protocol_key;
+	const struct exthdr_desc	*protocols[3];
 	struct proto_hdr_template	templates[10];
 };
 
diff --git a/src/exthdr.c b/src/exthdr.c
index 4add3da..87c09da 100644
--- a/src/exthdr.c
+++ b/src/exthdr.c
@@ -263,13 +263,8 @@ const struct exthdr_desc exthdr_rt0 = {
 const struct exthdr_desc exthdr_rt = {
 	.name		= "rt",
 	.type		= IPPROTO_ROUTING,
-#if 0
 	.protocol_key	= RTHDR_TYPE,
-	.protocols	= {
-		[0]	= &exthdr_rt0,
-		[2]	= &exthdr_rt2,
-	},
-#endif
+	.protocols	= {&exthdr_rt0, NULL, &exthdr_rt2},
 	.templates	= {
 		[RTHDR_NEXTHDR]		= RT_FIELD("nexthdr", ip6r_nxt, &inet_protocol_type),
 		[RTHDR_HDRLENGTH]	= RT_FIELD("hdrlength", ip6r_len, &integer_type),
diff --git a/tests/py/ip6/rt.t b/tests/py/ip6/rt.t
index 2d044c3..1eb198d 100644
--- a/tests/py/ip6/rt.t
+++ b/tests/py/ip6/rt.t
@@ -44,3 +44,5 @@ rt seg-left { 33, 55, 67, 88};ok
 rt seg-left != { 33, 55, 67, 88};ok
 rt seg-left { 33-55};ok
 rt seg-left != { 33-55};ok
+
+rt type 0 reserved 2;ok
-- 
1.9.1
