From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 2/8] doc: fix misspelling of "field"
Date: Sat, 19 Feb 2011 20:04:12 +0100
Message-ID: <1298142259-11213-3-git-send-email-jengelh@medozas.de>
References: <1298142259-11213-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:42359 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755385Ab1BSTEg (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 19 Feb 2011 14:04:36 -0500
In-Reply-To: <1298142259-11213-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 extensions/libip6t_ah.c   |    2 +-
 extensions/libip6t_frag.c |    2 +-
 extensions/libip6t_rt.c   |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/extensions/libip6t_ah.c b/extensions/libip6t_ah.c
index 693a4f8..5fa0d2d 100644
--- a/extensions/libip6t_ah.c
+++ b/extensions/libip6t_ah.c
@@ -15,7 +15,7 @@ static void ah_help(void)
 "ah match options:\n"
 "[!] --ahspi spi[:spi]          match spi (range)\n"
 "[!] --ahlen length             total length of this header\n"
-" --ahres                       check the reserved filed, too\n");
+" --ahres                       check the reserved field too\n");
 }
 
 static const struct option ah_opts[] = {
diff --git a/extensions/libip6t_frag.c b/extensions/libip6t_frag.c
index ed13c1f..ac9bd2e 100644
--- a/extensions/libip6t_frag.c
+++ b/extensions/libip6t_frag.c
@@ -15,7 +15,7 @@ static void frag_help(void)
 "frag match options:\n"
 "[!] --fragid id[:id]           match the id (range)\n"
 "[!] --fraglen length           total length of this header\n"
-" --fragres                     check the reserved filed, too\n"
+" --fragres                     check the reserved field too\n"
 " --fragfirst                   matches on the first fragment\n"
 " [--fragmore|--fraglast]       there are more fragments or this\n"
 "                               is the last one\n");
diff --git a/extensions/libip6t_rt.c b/extensions/libip6t_rt.c
index bd2da59..ec492c1 100644
--- a/extensions/libip6t_rt.c
+++ b/extensions/libip6t_rt.c
@@ -22,7 +22,7 @@ static void rt_help(void)
 "[!] --rt-type type             match the type\n"
 "[!] --rt-segsleft num[:num]    match the Segments Left field (range)\n"
 "[!] --rt-len length            total length of this header\n"
-" --rt-0-res                    check the reserved filed, too (type 0)\n"
+" --rt-0-res                    check the reserved field too (type 0)\n"
 " --rt-0-addrs ADDR[,ADDR...]   Type=0 addresses (list, max: %d)\n"
 " --rt-0-not-strict             List of Type=0 addresses not a strict list\n",
 IP6T_RT_HOPS);
-- 
1.7.1

