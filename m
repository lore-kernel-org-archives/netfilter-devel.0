From: Jan Engelhardt <jengelh@medozas.de>
Subject: libiptc: remove unused iptc_get_raw_socket and iptc_check_packet
Date: Thu, 6 Nov 2008 09:35:11 +0100 (CET)
Message-ID: <alpine.LNX.1.10.0811060935020.26551@fbirervta.pbzchgretzou.qr>
References: <alpine.LNX.1.10.0811060933060.26551@fbirervta.pbzchgretzou.qr> <alpine.LNX.1.10.0811060934380.26551@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:52641 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753146AbYKFIfM (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 6 Nov 2008 03:35:12 -0500
In-Reply-To: <alpine.LNX.1.10.0811060934380.26551@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

commit 1c0300bfbffdeb05d3688e4c9fa9bd87bd222883
Author: Jan Engelhardt <jengelh@medozas.de>
Date:   Thu Nov 6 09:23:05 2008 +0100

libiptc: remove unused iptc_get_raw_socket and iptc_check_packet

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 libiptc/libip4tc.c |    1 -
 libiptc/libip6tc.c |    1 -
 libiptc/libiptc.c  |   24 ------------------------
 3 files changed, 0 insertions(+), 26 deletions(-)

diff --git a/libiptc/libip4tc.c b/libiptc/libip4tc.c
index e8aaf6a..1f33f1c 100644
--- a/libiptc/libip4tc.c
+++ b/libiptc/libip4tc.c
@@ -78,7 +78,6 @@ typedef unsigned int socklen_t;
 #define TC_APPEND_ENTRY		iptc_append_entry
 #define TC_DELETE_ENTRY		iptc_delete_entry
 #define TC_DELETE_NUM_ENTRY	iptc_delete_num_entry
-#define TC_CHECK_PACKET		iptc_check_packet
 #define TC_FLUSH_ENTRIES	iptc_flush_entries
 #define TC_ZERO_ENTRIES		iptc_zero_entries
 #define TC_READ_COUNTER		iptc_read_counter
diff --git a/libiptc/libip6tc.c b/libiptc/libip6tc.c
index 221a9f3..5966841 100644
--- a/libiptc/libip6tc.c
+++ b/libiptc/libip6tc.c
@@ -73,7 +73,6 @@ typedef unsigned int socklen_t;
 #define TC_APPEND_ENTRY		ip6tc_append_entry
 #define TC_DELETE_ENTRY		ip6tc_delete_entry
 #define TC_DELETE_NUM_ENTRY	ip6tc_delete_num_entry
-#define TC_CHECK_PACKET		ip6tc_check_packet
 #define TC_FLUSH_ENTRIES	ip6tc_flush_entries
 #define TC_ZERO_ENTRIES		ip6tc_zero_entries
 #define TC_ZERO_COUNTER		ip6tc_zero_counter
diff --git a/libiptc/libiptc.c b/libiptc/libiptc.c
index 9de50ad..17c2f49 100644
--- a/libiptc/libiptc.c
+++ b/libiptc/libiptc.c
@@ -2113,18 +2113,6 @@ TC_DELETE_NUM_ENTRY(const IPT_CHAINLABEL chain,
 	return 1;
 }
 
-/* Check the packet `fw' on chain `chain'.  Returns the verdict, or
-   NULL and sets errno. */
-const char *
-TC_CHECK_PACKET(const IPT_CHAINLABEL chain,
-		STRUCT_ENTRY *entry,
-		struct xtc_handle *handle)
-{
-	iptc_fn = TC_CHECK_PACKET;
-	errno = ENOSYS;
-	return NULL;
-}
-
 /* Flushes the entries in the given chain (ie. empties chain). */
 int
 TC_FLUSH_ENTRIES(const IPT_CHAINLABEL chain, struct xtc_handle *handle)
@@ -2724,13 +2712,6 @@ out_zero:
 	return 0;
 }
 
-/* Get raw socket. */
-int
-TC_GET_RAW_SOCKET(void)
-{
-	return sockfd;
-}
-
 /* Translates errno numbers into more human-readable form than strerror. */
 const char *
 TC_STRERROR(int err)
@@ -2757,11 +2738,6 @@ TC_STRERROR(int err)
 	    { TC_ZERO_COUNTER, E2BIG, "Index of counter too big" },
 	    { TC_INSERT_ENTRY, ELOOP, "Loop found in table" },
 	    { TC_INSERT_ENTRY, EINVAL, "Target problem" },
-	    /* EINVAL for CHECK probably means bad interface. */
-	    { TC_CHECK_PACKET, EINVAL,
-	      "Bad arguments (does that interface exist?)" },
-	    { TC_CHECK_PACKET, ENOSYS,
-	      "Checking will most likely never get implemented" },
 	    /* ENOENT for DELETE probably means no matching rule */
 	    { TC_DELETE_ENTRY, ENOENT,
 	      "Bad rule (does a matching rule exist in that chain?)" },
