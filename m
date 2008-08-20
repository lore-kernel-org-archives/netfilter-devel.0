From: Jan Engelhardt <jengelh@medozas.de>
Subject: libxt_recent: do allow --rttl for --update
Date: Wed, 20 Aug 2008 13:49:49 -0400 (EDT)
Message-ID: <alpine.LNX.1.10.0808201343340.26080@fbirervta.pbzchgretzou.qr>
References: <alpine.LNX.1.10.0808031503320.6502@fbirervta.pbzchgretzou.qr> <48AC5002.2070401@iblink.com.cn>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>, iptables@iblink.com.cn
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:51329 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751811AbYHTRtx (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 20 Aug 2008 13:49:53 -0400
In-Reply-To: <48AC5002.2070401@iblink.com.cn>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

commit 5c395d782e97ce7218acebc8c8bb950808adde97
Author: Jan Engelhardt <jengelh@medozas.de>
Date:   Wed Aug 20 13:36:45 2008 -0400

libxt_recent: do allow --rttl for --update

Tony Ho noticed a too-strict check in xt_recent, so here is a fix.

Reported-by: Tony Ho <iptables@iblink.com.cn>
Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 extensions/libipt_recent.c   |    2 +-
 extensions/libipt_recent.man |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/extensions/libipt_recent.c b/extensions/libipt_recent.c
index 94f246a..7281fe5 100644
--- a/extensions/libipt_recent.c
+++ b/extensions/libipt_recent.c
@@ -165,7 +165,7 @@ static void recent_check(unsigned int flags)
 			"recent: you must specify one of `--set', `--rcheck' "
 			"`--update' or `--remove'");
 	if ((flags & IPT_RECENT_TTL) &&
-	    (flags & (IPT_RECENT_SET | IPT_RECENT_REMOVE | IPT_RECENT_UPDATE)))
+	    (flags & (IPT_RECENT_SET | IPT_RECENT_REMOVE)))
 		exit_error(PARAMETER_PROBLEM,
 		           "recent: --rttl may only be used with --rcheck or "
 		           "--update");
diff --git a/extensions/libipt_recent.man b/extensions/libipt_recent.man
index 02432ba..d5bdaa0 100644
--- a/extensions/libipt_recent.man
+++ b/extensions/libipt_recent.man
@@ -50,7 +50,7 @@ than or equal to the given value. This option may be used along with
 number of hits within a specific time frame.
 .TP
 \fB--rttl\fR
-This option must be used in conjunction with one of \fB--rcheck\fR or
+This option may only be used in conjunction with one of \fB--rcheck\fR or
 \fB--update\fR. When used, this will narrow the match to only happen
 when the address is in the list and the TTL of the current packet
 matches that of the packet which hit the \fB--set\fR rule. This may be
