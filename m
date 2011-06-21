From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 2/7] libipt_LOG: fix ignoring all but last flags
Date: Tue, 21 Jun 2011 17:53:29 +0200
Message-ID: <1308671615-17505-3-git-send-email-jengelh@medozas.de>
References: <1308671615-17505-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:40642 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756701Ab1FUPxj (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 21 Jun 2011 11:53:39 -0400
In-Reply-To: <1308671615-17505-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 extensions/libip6t_LOG.c |   10 +++++-----
 extensions/libipt_LOG.c  |   10 +++++-----
 tests/options-most.rules |    2 ++
 3 files changed, 12 insertions(+), 10 deletions(-)

diff --git a/extensions/libip6t_LOG.c b/extensions/libip6t_LOG.c
index a419ec9..2b1ae28 100644
--- a/extensions/libip6t_LOG.c
+++ b/extensions/libip6t_LOG.c
@@ -87,19 +87,19 @@ static void LOG_parse(struct xt_option_call *cb)
 				   "Newlines not allowed in --log-prefix");
 		break;
 	case O_LOG_TCPSEQ:
-		info->logflags = IP6T_LOG_TCPSEQ;
+		info->logflags |= IP6T_LOG_TCPSEQ;
 		break;
 	case O_LOG_TCPOPTS:
-		info->logflags = IP6T_LOG_TCPOPT;
+		info->logflags |= IP6T_LOG_TCPOPT;
 		break;
 	case O_LOG_IPOPTS:
-		info->logflags = IP6T_LOG_IPOPT;
+		info->logflags |= IP6T_LOG_IPOPT;
 		break;
 	case O_LOG_UID:
-		info->logflags = IP6T_LOG_UID;
+		info->logflags |= IP6T_LOG_UID;
 		break;
 	case O_LOG_MAC:
-		info->logflags = IP6T_LOG_MACDECODE;
+		info->logflags |= IP6T_LOG_MACDECODE;
 		break;
 	}
 }
diff --git a/extensions/libipt_LOG.c b/extensions/libipt_LOG.c
index b270bcf..77f16d1 100644
--- a/extensions/libipt_LOG.c
+++ b/extensions/libipt_LOG.c
@@ -87,19 +87,19 @@ static void LOG_parse(struct xt_option_call *cb)
 				   "Newlines not allowed in --log-prefix");
 		break;
 	case O_LOG_TCPSEQ:
-		info->logflags = IPT_LOG_TCPSEQ;
+		info->logflags |= IPT_LOG_TCPSEQ;
 		break;
 	case O_LOG_TCPOPTS:
-		info->logflags = IPT_LOG_TCPOPT;
+		info->logflags |= IPT_LOG_TCPOPT;
 		break;
 	case O_LOG_IPOPTS:
-		info->logflags = IPT_LOG_IPOPT;
+		info->logflags |= IPT_LOG_IPOPT;
 		break;
 	case O_LOG_UID:
-		info->logflags = IPT_LOG_UID;
+		info->logflags |= IPT_LOG_UID;
 		break;
 	case O_LOG_MAC:
-		info->logflags = IPT_LOG_MACDECODE;
+		info->logflags |= IPT_LOG_MACDECODE;
 		break;
 	}
 }
diff --git a/tests/options-most.rules b/tests/options-most.rules
index 6c4a831..13ee987 100644
--- a/tests/options-most.rules
+++ b/tests/options-most.rules
@@ -146,6 +146,8 @@
 -A matches
 -A matches -m rt --rt-segsleft 5:4294967295
 -A matches
+-A ntarg -j LOG --log-tcp-sequence --log-tcp-options --log-ip-options
+-A ntarg
 -A ntarg -j NFQUEUE --queue-num 1
 -A ntarg
 -A ntarg -j NFQUEUE --queue-balance 8:99
-- 
1.7.3.4

