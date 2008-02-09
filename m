From: Eric Leblond <eric@inl.fr>
Subject: [ULOGD PATCH 5/5] Add UID display to PRINTPKT filter.
Date: Sat,  9 Feb 2008 13:36:35 +0100
Message-ID: <12025605963558-git-send-email-eric@inl.fr>
References: <12025605952271-git-send-email-eric@inl.fr>
Cc: Eric Leblond <eric@inl.fr>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bayen.regit.org ([81.57.69.189]:54974 "EHLO localhost"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754017AbYBIMgi (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 9 Feb 2008 07:36:38 -0500
In-Reply-To: <12025605952271-git-send-email-eric@inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


Signed-off-by: Eric Leblond <eric@inl.fr>
---
:100644 100644 ae56946... b524fc2... M	include/ulogd/printpkt.h
:100644 100644 35d8080... 93d506a... M	util/printpkt.c
 include/ulogd/printpkt.h |    1 +
 util/printpkt.c          |    7 +++++++
 2 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/include/ulogd/printpkt.h b/include/ulogd/printpkt.h
index ae56946..b524fc2 100644
--- a/include/ulogd/printpkt.h
+++ b/include/ulogd/printpkt.h
@@ -7,6 +7,7 @@ enum pkt_keys {
 	KEY_OOB_PREFIX,
 	KEY_OOB_IN,
 	KEY_OOB_OUT,
+	KEY_OOB_UID,
 	KEY_RAW_MAC,
 	KEY_RAW_MACLEN,
 	KEY_IP_SADDR,
diff --git a/util/printpkt.c b/util/printpkt.c
index 35d8080..93d506a 100644
--- a/util/printpkt.c
+++ b/util/printpkt.c
@@ -43,6 +43,9 @@ struct ulogd_key printpkt_keys[] = {
 	[KEY_OOB_PREFIX]	= { .name = "oob.prefix", },
 	[KEY_OOB_IN]		= { .name = "oob.in", },
 	[KEY_OOB_OUT]		= { .name = "oob.out", },
+	[KEY_OOB_UID]		= { .name = "oob.uid",
+				    .flags = ULOGD_KEYF_OPTIONAL
+				  },
 	[KEY_RAW_MAC]		= { .name = "raw.mac", },
 	[KEY_RAW_MACLEN]	= { .name = "raw.mac_len", },
 	[KEY_IP_SADDR]		= { .name = "ip.saddr.str", },
@@ -365,6 +368,10 @@ int printpkt_print(struct ulogd_key *res, char *buf)
 		break;
 	}
 
+	if (pp_is_valid(res, KEY_OOB_UID))
+		buf_cur += sprintf(buf_cur, "UID=%d",
+				   GET_VALUE(res, KEY_OOB_UID).ui32);
+
 	strcat(buf_cur, "\n");
 
 	return 0;
-- 
1.5.2.5

