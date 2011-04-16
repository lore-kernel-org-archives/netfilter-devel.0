From: Andrew Beverley <andy@andybev.com>
Subject: [PATCH] libnetfilter_conntrack: Add nfct_destroy() to all examples in utils
Date: Sat, 16 Apr 2011 21:08:26 +0100
Message-ID: <1302984506-14506-1-git-send-email-andy@andybev.com>
Cc: Andrew Beverley <andy@andybev.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from earth.simplelists.com ([89.16.184.171]:34081 "EHLO
	earth.simplelists.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752361Ab1DPUSG (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 16 Apr 2011 16:18:06 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

For libnetfilter_conntrack:
This patch adds nfct_destroy() to all the examples in the utils folder.
Although this may be obvious to some, when I wrote my first code using
libnetfilter_conntract, I used the examples but subsequently missed out
all the calls to nfct_destroy().

Signed-off-by: Andrew Beverley <andy@andybev.com>
---
 utils/conntrack_create.c        |    3 +++
 utils/conntrack_create_nat.c    |    3 +++
 utils/conntrack_delete.c        |    3 +++
 utils/conntrack_get.c           |    3 +++
 utils/conntrack_grp_create.c    |    3 +++
 utils/conntrack_master.c        |    5 +++++
 utils/conntrack_update.c        |    3 +++
 utils/expect_create.c           |    6 ++++++
 utils/expect_create_userspace.c |    7 +++++++
 utils/expect_delete.c           |    6 ++++++
 utils/expect_get.c              |    4 ++++
 11 files changed, 46 insertions(+), 0 deletions(-)

diff --git a/utils/conntrack_create.c b/utils/conntrack_create.c
index 7140b97..1a81100 100644
--- a/utils/conntrack_create.c
+++ b/utils/conntrack_create.c
@@ -35,6 +35,7 @@ int main(void)
 	h = nfct_open(CONNTRACK, 0);
 	if (!h) {
 		perror("nfct_open");
+		nfct_destroy(ct);
 		return -1;
 	}
 
@@ -48,5 +49,7 @@ int main(void)
 
 	nfct_close(h);
 
+	nfct_destroy(ct);
+
 	ret == -1 ? exit(EXIT_FAILURE) : exit(EXIT_SUCCESS);
 }
diff --git a/utils/conntrack_create_nat.c b/utils/conntrack_create_nat.c
index f7426ee..b8eb78d 100644
--- a/utils/conntrack_create_nat.c
+++ b/utils/conntrack_create_nat.c
@@ -37,6 +37,7 @@ int main(void)
 	h = nfct_open(CONNTRACK, 0);
 	if (!h) {
 		perror("nfct_open");
+		nfct_destroy(ct);
 		return -1;
 	}
 
@@ -50,5 +51,7 @@ int main(void)
 
 	nfct_close(h);
 
+	nfct_destroy(ct);
+
 	ret == -1 ? exit(EXIT_FAILURE) : exit(EXIT_SUCCESS);
 }
diff --git a/utils/conntrack_delete.c b/utils/conntrack_delete.c
index b3204dd..ae2fc35 100644
--- a/utils/conntrack_delete.c
+++ b/utils/conntrack_delete.c
@@ -30,6 +30,7 @@ int main(void)
 	h = nfct_open(CONNTRACK, 0);
 	if (!h) {
 		perror("nfct_open");
+		nfct_destroy(ct);
 		return -1;
 	}
 
@@ -43,5 +44,7 @@ int main(void)
 
 	nfct_close(h);
 
+	nfct_destroy(ct);
+
 	ret == -1 ? exit(EXIT_FAILURE) : exit(EXIT_SUCCESS);
 }
diff --git a/utils/conntrack_get.c b/utils/conntrack_get.c
index 7d7badd..6ddecaf 100644
--- a/utils/conntrack_get.c
+++ b/utils/conntrack_get.c
@@ -42,6 +42,7 @@ int main(void)
 	h = nfct_open(CONNTRACK, 0);
 	if (!h) {
 		perror("nfct_open");
+		nfct_destroy(ct);
 		return -1;
 	}
 
@@ -57,5 +58,7 @@ int main(void)
 
 	nfct_close(h);
 
+	nfct_destroy(ct);
+
 	ret == -1 ? exit(EXIT_FAILURE) : exit(EXIT_SUCCESS);
 }
diff --git a/utils/conntrack_grp_create.c b/utils/conntrack_grp_create.c
index b47d09a..7ad2f0d 100644
--- a/utils/conntrack_grp_create.c
+++ b/utils/conntrack_grp_create.c
@@ -41,6 +41,7 @@ int main(void)
 	h = nfct_open(CONNTRACK, 0);
 	if (!h) {
 		perror("nfct_open");
+		nfct_destroy(ct);
 		return -1;
 	}
 
@@ -54,5 +55,7 @@ int main(void)
 
 	nfct_close(h);
 
+	nfct_destroy(ct);
+
 	ret == -1 ? exit(EXIT_FAILURE) : exit(EXIT_SUCCESS);
 }
diff --git a/utils/conntrack_master.c b/utils/conntrack_master.c
index d08219a..a7c7bca 100644
--- a/utils/conntrack_master.c
+++ b/utils/conntrack_master.c
@@ -36,6 +36,7 @@ int main(void)
 	h = nfct_open(CONNTRACK, 0);
 	if (!h) {
 		perror("nfct_open");
+		nfct_destroy(ct);
 		return -1;
 	}
 
@@ -47,6 +48,8 @@ int main(void)
 	else
 		printf("(OK)\n");
 
+	nfct_destroy(ct);
+
 	if (ret == -1)
 		exit(EXIT_FAILURE);
 
@@ -91,5 +94,7 @@ int main(void)
 
 	nfct_close(h);
 
+	nfct_destroy(expected);
+
 	ret == -1 ? exit(EXIT_FAILURE) : exit(EXIT_SUCCESS);
 }
diff --git a/utils/conntrack_update.c b/utils/conntrack_update.c
index 24545ca..9459a90 100644
--- a/utils/conntrack_update.c
+++ b/utils/conntrack_update.c
@@ -35,6 +35,7 @@ int main(void)
 	h = nfct_open(CONNTRACK, 0);
 	if (!h) {
 		perror("nfct_open");
+		nfct_destroy(ct);
 		return -1;
 	}
 
@@ -48,5 +49,7 @@ int main(void)
 
 	nfct_close(h);
 
+	nfct_destroy(ct);
+
 	ret == -1 ? exit(EXIT_FAILURE) : exit(EXIT_SUCCESS);
 }
diff --git a/utils/expect_create.c b/utils/expect_create.c
index 912ab8e..cf379e9 100644
--- a/utils/expect_create.c
+++ b/utils/expect_create.c
@@ -46,6 +46,7 @@ int main(void)
 	h = nfct_open(CONNTRACK, 0);
 	if (!h) {
 		perror("nfct_open");
+		nfct_destroy(master);
 		return -1;
 	}
 
@@ -76,6 +77,8 @@ int main(void)
 	mask = nfct_new();
 	if (!mask) {
 		perror("nfct_new");
+		nfct_destroy(master);
+		nfct_destroy(expected);
 		exit(EXIT_FAILURE);
 	}
 
@@ -94,6 +97,9 @@ int main(void)
 	exp = nfexp_new();
 	if (!exp) {
 		perror("nfexp_new");
+		nfct_destroy(master);
+		nfct_destroy(expected);
+		nfct_destroy(mask);
 		exit(EXIT_FAILURE);
 	}
 
diff --git a/utils/expect_create_userspace.c b/utils/expect_create_userspace.c
index 0e910e6..8f55a9f 100644
--- a/utils/expect_create_userspace.c
+++ b/utils/expect_create_userspace.c
@@ -45,6 +45,7 @@ int main(void)
 	h = nfct_open(CONNTRACK, 0);
 	if (!h) {
 		perror("nfct_open");
+		nfct_destroy(master);
 		return -1;
 	}
 
@@ -66,6 +67,7 @@ int main(void)
 	expected = nfct_new();
 	if (!expected) {
 		perror("nfct_new");
+		nfct_destroy(master);
 		exit(EXIT_FAILURE);
 	}
 
@@ -80,6 +82,8 @@ int main(void)
 	mask = nfct_new();
 	if (!mask) {
 		perror("nfct_new");
+		nfct_destroy(master);
+		nfct_destroy(expected);
 		exit(EXIT_FAILURE);
 	}
 
@@ -98,6 +102,9 @@ int main(void)
 	exp = nfexp_new();
 	if (!exp) {
 		perror("nfexp_new");
+		nfct_destroy(master);
+		nfct_destroy(expected);
+		nfct_destroy(mask);
 		exit(EXIT_FAILURE);
 	}
 
diff --git a/utils/expect_delete.c b/utils/expect_delete.c
index 18f4a79..21e4a03 100644
--- a/utils/expect_delete.c
+++ b/utils/expect_delete.c
@@ -30,6 +30,7 @@ int main(void)
 	exp = nfexp_new();
 	if (!exp) {
 		perror("nfexp_new");
+		nfct_destroy(expected);
 		exit(EXIT_FAILURE);
 	}
 
@@ -38,6 +39,7 @@ int main(void)
 	h = nfct_open(EXPECT, 0);
 	if (!h) {
 		perror("nfct_open");
+		nfct_destroy(expected);
 		return -1;
 	}
 
@@ -49,5 +51,9 @@ int main(void)
 	else
 		printf("(OK)\n");
 
+	nfct_close(h);
+
+	nfct_destroy(expected);
+
 	ret == -1 ? exit(EXIT_FAILURE) : exit(EXIT_SUCCESS);
 }
diff --git a/utils/expect_get.c b/utils/expect_get.c
index fc7e116..e42c845 100644
--- a/utils/expect_get.c
+++ b/utils/expect_get.c
@@ -42,6 +42,7 @@ int main(void)
 	exp = nfexp_new();
 	if (!exp) {
 		perror("nfexp_new");
+		nfct_destroy(master);
 		exit(EXIT_FAILURE);
 	}
 
@@ -50,6 +51,7 @@ int main(void)
 	h = nfct_open(EXPECT, 0);
 	if (!h) {
 		perror("nfct_open");
+		nfct_destroy(master);
 		return -1;
 	}
 
@@ -64,5 +66,7 @@ int main(void)
 
 	nfct_close(h);
 
+	nfct_destroy(master);
+
 	ret == -1 ? exit(EXIT_FAILURE) : exit(EXIT_SUCCESS);
 }
-- 
1.7.1

