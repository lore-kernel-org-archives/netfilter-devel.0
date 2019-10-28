Return-Path: <SRS0=tJiL=YV=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A181CA9EC0
	for <netfilter-devel@archiver.kernel.org>; Mon, 28 Oct 2019 15:49:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7673220830
	for <netfilter-devel@archiver.kernel.org>; Mon, 28 Oct 2019 15:49:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390050AbfJ1PtK (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 28 Oct 2019 11:49:10 -0400
Received: from orbyte.nwl.cc ([151.80.46.58]:40146 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390007AbfJ1PtK (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 28 Oct 2019 11:49:10 -0400
Received: from localhost ([::1]:53236 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1iP7GX-00027d-2K; Mon, 28 Oct 2019 16:49:09 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH v2 06/10] Replace TRUE/FALSE with true/false
Date:   Mon, 28 Oct 2019 16:48:14 +0100
Message-Id: <20191028154818.31257-7-phil@nwl.cc>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191028154818.31257-1-phil@nwl.cc>
References: <20191028154818.31257-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

And drop the conditional defines.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/ip6tables.c   | 14 +++-----------
 iptables/iptables.c    | 12 ++----------
 iptables/xtables-arp.c | 17 +++++------------
 iptables/xtables.c     | 11 ++---------
 4 files changed, 12 insertions(+), 42 deletions(-)

diff --git a/iptables/ip6tables.c b/iptables/ip6tables.c
index e48fdeb1248bd..576c2cf8b0d9f 100644
--- a/iptables/ip6tables.c
+++ b/iptables/ip6tables.c
@@ -45,14 +45,6 @@
 #include "ip6tables-multi.h"
 #include "xshared.h"
 
-#ifndef TRUE
-#define TRUE 1
-#endif
-#ifndef FALSE
-#define FALSE 0
-#endif
-
-
 #define NUMBER_OF_OPT	ARRAY_SIZE(optflags)
 static const char optflags[]
 = { 'n', 's', 'd', 'p', 'j', 'v', 'x', 'i', 'o', '0', 'c'};
@@ -1525,7 +1517,7 @@ int do_command6(int argc, char *argv[], char **table,
 					xtables_error(PARAMETER_PROBLEM,
 						   "multiple consecutive ! not"
 						   " allowed");
-				cs.invert = TRUE;
+				cs.invert = true;
 				optarg[0] = '\0';
 				continue;
 			}
@@ -1537,12 +1529,12 @@ int do_command6(int argc, char *argv[], char **table,
 				/*
 				 * If new options were loaded, we must retry
 				 * getopt immediately and not allow
-				 * cs.invert=FALSE to be executed.
+				 * cs.invert=false to be executed.
 				 */
 				continue;
 			break;
 		}
-		cs.invert = FALSE;
+		cs.invert = false;
 	}
 
 	if (!wait && wait_interval_set)
diff --git a/iptables/iptables.c b/iptables/iptables.c
index 255b61b11ec89..88ef6cf666d4b 100644
--- a/iptables/iptables.c
+++ b/iptables/iptables.c
@@ -41,14 +41,6 @@
 #include <fcntl.h>
 #include "xshared.h"
 
-#ifndef TRUE
-#define TRUE 1
-#endif
-#ifndef FALSE
-#define FALSE 0
-#endif
-
-
 #define OPT_FRAGMENT    0x00800U
 #define NUMBER_OF_OPT	ARRAY_SIZE(optflags)
 static const char optflags[]
@@ -1518,7 +1510,7 @@ int do_command4(int argc, char *argv[], char **table,
 					xtables_error(PARAMETER_PROBLEM,
 						   "multiple consecutive ! not"
 						   " allowed");
-				cs.invert = TRUE;
+				cs.invert = true;
 				optarg[0] = '\0';
 				continue;
 			}
@@ -1531,7 +1523,7 @@ int do_command4(int argc, char *argv[], char **table,
 				continue;
 			break;
 		}
-		cs.invert = FALSE;
+		cs.invert = false;
 	}
 
 	if (!wait && wait_interval_set)
diff --git a/iptables/xtables-arp.c b/iptables/xtables-arp.c
index ae69baf2a9346..4949ddd3d486c 100644
--- a/iptables/xtables-arp.c
+++ b/iptables/xtables-arp.c
@@ -55,13 +55,6 @@
 
 typedef char arpt_chainlabel[32];
 
-#ifndef TRUE
-#define TRUE 1
-#endif
-#ifndef FALSE
-#define FALSE 0
-#endif
-
 #define OPTION_OFFSET 256
 
 #define OPT_NONE	0x00000U
@@ -383,7 +376,7 @@ check_inverse(const char option[], int *invert, int *optidx, int argc)
 		if (*invert)
 			xtables_error(PARAMETER_PROBLEM,
 				      "Multiple `!' flags not allowed");
-		*invert = TRUE;
+		*invert = true;
 		if (optidx) {
 			*optidx = *optidx+1;
 			if (argc && *optidx > argc)
@@ -391,9 +384,9 @@ check_inverse(const char option[], int *invert, int *optidx, int argc)
 					      "no argument following `!'");
 		}
 
-		return TRUE;
+		return true;
 	}
-	return FALSE;
+	return false;
 }
 
 static void
@@ -942,7 +935,7 @@ int do_commandarp(struct nft_handle *h, int argc, char *argv[], char **table,
 					xtables_error(PARAMETER_PROBLEM,
 						      "multiple consecutive ! not"
 						      " allowed");
-				invert = TRUE;
+				invert = true;
 				optarg[0] = '\0';
 				continue;
 			}
@@ -956,7 +949,7 @@ int do_commandarp(struct nft_handle *h, int argc, char *argv[], char **table,
 			}
 			break;
 		}
-		invert = FALSE;
+		invert = false;
 	}
 
 	if (cs.target)
diff --git a/iptables/xtables.c b/iptables/xtables.c
index 805bd801fb060..8f9dc628d0029 100644
--- a/iptables/xtables.c
+++ b/iptables/xtables.c
@@ -43,13 +43,6 @@
 #include "nft-shared.h"
 #include "nft.h"
 
-#ifndef TRUE
-#define TRUE 1
-#endif
-#ifndef FALSE
-#define FALSE 0
-#endif
-
 #define OPT_FRAGMENT	0x00800U
 #define NUMBER_OF_OPT	ARRAY_SIZE(optflags)
 static const char optflags[]
@@ -952,7 +945,7 @@ void do_parse(struct nft_handle *h, int argc, char *argv[],
 					xtables_error(PARAMETER_PROBLEM,
 						   "multiple consecutive ! not"
 						   " allowed");
-				cs->invert = TRUE;
+				cs->invert = true;
 				optarg[0] = '\0';
 				continue;
 			}
@@ -965,7 +958,7 @@ void do_parse(struct nft_handle *h, int argc, char *argv[],
 				continue;
 			break;
 		}
-		cs->invert = FALSE;
+		cs->invert = false;
 	}
 
 	if (strcmp(p->table, "nat") == 0 &&
-- 
2.23.0

