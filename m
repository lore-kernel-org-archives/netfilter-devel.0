From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 3/3] iptables: refer to dmesg when we hit error
Date: Wed, 19 Nov 2008 00:44:00 +0100
Message-ID: <20081118234400.15750.20296.stgit@Decadence>
References: <20081118234311.15750.80335.stgit@Decadence>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:50500 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751617AbYKRXoK (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 18 Nov 2008 18:44:10 -0500
In-Reply-To: <20081118234311.15750.80335.stgit@Decadence>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This does not make any better, but at least refer to
dmesg which is the common source of information to diagnose
kernel-side problems. This is helpful for newbie users.

# iptables -I INPUT -j CLUSTERIP
iptables: Invalid argument. Run `dmesg' for more information.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---

 ip6tables-standalone.c |    3 ++-
 iptables-standalone.c  |    3 ++-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/ip6tables-standalone.c b/ip6tables-standalone.c
index 5bdcd4f..6c20bd8 100644
--- a/ip6tables-standalone.c
+++ b/ip6tables-standalone.c
@@ -70,7 +70,8 @@ main(int argc, char *argv[])
 		ret = ip6tc_commit(&handle);
 
 	if (!ret)
-		fprintf(stderr, "ip6tables: %s\n",
+		fprintf(stderr, "ip6tables: %s. "
+				"Run `dmesg' for more information.\n",
 			ip6tc_strerror(errno));
 
 	exit(!ret);
diff --git a/iptables-standalone.c b/iptables-standalone.c
index 55d9bbe..630c586 100644
--- a/iptables-standalone.c
+++ b/iptables-standalone.c
@@ -71,7 +71,8 @@ main(int argc, char *argv[])
 		ret = iptc_commit(&handle);
 
 	if (!ret) {
-		fprintf(stderr, "iptables: %s\n",
+		fprintf(stderr, "iptables: %s. "
+				"Run `dmesg' for more information.\n",
 			iptc_strerror(errno));
 		if (errno == EAGAIN) {
 			exit(RESOURCE_PROBLEM);

