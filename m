From: Thomas Jacob <jacob@internet24.de>
Subject: [PATCH] Return true/false instead of ULOGD_IRET_OK/STOP
Date: Mon,  8 Dec 2008 19:27:06 +0100
Message-ID: <1228760826-12886-2-git-send-email-jacob@internet24.de>
References: <1228760826-12886-1-git-send-email-jacob@internet24.de>
Cc: netfilter-devel@vger.kernel.org, Thomas Jacob <jacob@internet24.de>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mailout01.ims-firmen.de ([213.174.32.96]:34965 "EHLO
	mailout01.ims-firmen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751501AbYLHSr1 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 8 Dec 2008 13:47:27 -0500
In-Reply-To: <1228760826-12886-1-git-send-email-jacob@internet24.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Thomas Jacob <jacob@internet24.de>
---
 filter/raw2packet/ulogd_raw2packet_BASE.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/filter/raw2packet/ulogd_raw2packet_BASE.c b/filter/raw2packet/ulogd_raw2packet_BASE.c
index e61d904..30822e8 100644
--- a/filter/raw2packet/ulogd_raw2packet_BASE.c
+++ b/filter/raw2packet/ulogd_raw2packet_BASE.c
@@ -751,9 +751,9 @@ static int ip6_ext_hdr(u_int8_t nexthdr)
 	case IPPROTO_ESP:
 	case IPPROTO_AH:
 	case IPPROTO_DSTOPTS:
-		return ULOGD_IRET_OK;
+		return 1;
 	default:
-		return ULOGD_IRET_STOP;
+		return 0;
 	}
 }
 
-- 
1.5.6.5

