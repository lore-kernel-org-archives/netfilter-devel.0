From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 1/5] build: resolve automake warning
Date: Fri,  5 Nov 2010 18:56:49 +0100
Message-ID: <1288979814-18512-2-git-send-email-jengelh@medozas.de>
References: <1288979814-18512-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:55372 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753332Ab0KER45 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 5 Nov 2010 13:56:57 -0400
In-Reply-To: <1288979814-18512-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

src/Makefile.am:24: whitespace following trailing backslash

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 src/Makefile.am |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/src/Makefile.am b/src/Makefile.am
index a85a56f..10b3467 100644
--- a/src/Makefile.am
+++ b/src/Makefile.am
@@ -21,7 +21,7 @@ conntrackd_SOURCES = alarm.c main.c run.c hash.c queue.c rbtree.c \
 		    channel.c multichannel.c channel_mcast.c channel_udp.c \
 		    tcp.c channel_tcp.c \
 		    external_cache.c external_inject.c \
-		    internal_cache.c internal_bypass.c \ 
+		    internal_cache.c internal_bypass.c \
 		    read_config_yy.y read_config_lex.l
 
 # yacc and lex generate dirty code
-- 
1.7.1

