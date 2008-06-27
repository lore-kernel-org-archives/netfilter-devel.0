From: Eric Leblond <eric@inl.fr>
Subject: [ULOGD PATCH 1/6] Specify that NFLOG only return mac saddr.
Date: Sat, 28 Jun 2008 01:02:55 +0200
Message-ID: <1214607780-31389-2-git-send-email-eric@inl.fr>
References: <485FB66A.1090601@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, Eric Leblond <eric@inl.fr>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bayen.regit.org ([81.57.69.189]:56480 "EHLO ice-age"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1764353AbYF0W5t (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 27 Jun 2008 18:57:49 -0400
In-Reply-To: <485FB66A.1090601@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The following patch modifies NFLOG to return a key raw.mac.saddr as NFLOG
kernel module only returns this field.

Signed-off-by: Eric Leblond <eric@inl.fr>
---
 input/packet/ulogd_inppkt_NFLOG.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/input/packet/ulogd_inppkt_NFLOG.c b/input/packet/ulogd_inppkt_NFLOG.c
index 728b410..f239e42 100644
--- a/input/packet/ulogd_inppkt_NFLOG.c
+++ b/input/packet/ulogd_inppkt_NFLOG.c
@@ -114,7 +114,7 @@ static struct config_keyset libulog_kset = {
 #define nlsockbufmaxsize_ce(x) (x->ces[9])
 
 enum nflog_keys {
-	NFLOG_KEY_RAW_MAC = 0,
+	NFLOG_KEY_RAW_MAC_SADDR = 0,
 	NFLOG_KEY_RAW_PCKT,
 	NFLOG_KEY_RAW_PCKTLEN,
 	NFLOG_KEY_RAW_PCKTCOUNT,
@@ -136,10 +136,10 @@ enum nflog_keys {
 };
 
 static struct ulogd_key output_keys[] = {
-	[NFLOG_KEY_RAW_MAC] = {
+	[NFLOG_KEY_RAW_MAC_SADDR] = {
 		.type = ULOGD_RET_RAW,
 		.flags = ULOGD_RETF_NONE,
-		.name = "raw.mac",
+		.name = "raw.mac.saddr",
 		.ipfix = {
 			.vendor = IPFIX_VENDOR_IETF,
 			.field_id = IPFIX_sourceMacAddress,
@@ -319,8 +319,8 @@ interp_packet(struct ulogd_pluginstance *upi, struct nflog_data *ldata)
 	}
 
 	if (hw) {
-		ret[NFLOG_KEY_RAW_MAC].u.value.ptr = hw->hw_addr;
-		ret[NFLOG_KEY_RAW_MAC].flags |= ULOGD_RETF_VALID;
+		ret[NFLOG_KEY_RAW_MAC_SADDR].u.value.ptr = hw->hw_addr;
+		ret[NFLOG_KEY_RAW_MAC_SADDR].flags |= ULOGD_RETF_VALID;
 		ret[NFLOG_KEY_RAW_MAC_LEN].u.value.ui16 = ntohs(hw->hw_addrlen);
 		ret[NFLOG_KEY_RAW_MAC_LEN].flags |= ULOGD_RETF_VALID;
 	}
-- 
1.5.4.3

