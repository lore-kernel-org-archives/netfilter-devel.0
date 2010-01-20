From: Patrick McHardy <kaber@trash.net>
Subject: netfilter: nf_conntrack_sip: fix ct_sip_parse_request() REGISTER request parsing
Date: Wed, 20 Jan 2010 20:18:29 +0100 (MET)
Message-ID: <20100120191827.25922.10679.sendpatchset@x2.localnet>
References: <20100120191824.25922.36663.sendpatchset@x2.localnet>
Cc: flo@degnet.de, Patrick McHardy <kaber@trash.net>,
	madduck@debian.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:43281 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752273Ab0ATTSa (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 20 Jan 2010 14:18:30 -0500
In-Reply-To: <20100120191824.25922.36663.sendpatchset@x2.localnet>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

commit 854e013100d88995a6e25896bd426c303c888682
Author: Patrick McHardy <kaber@trash.net>
Date:   Wed Jan 20 18:23:05 2010 +0100

    netfilter: nf_conntrack_sip: fix ct_sip_parse_request() REGISTER request parsing
    
    When requests are parsed, the "sip:" part of the SIP URI should be skipped.
    
    Usually this doesn't matter because address parsing skips forward until after
    the username part, but in case REGISTER requests it doesn't contain a username
    and the address can not be parsed.
    
    Signed-off-by: Patrick McHardy <kaber@trash.net>

diff --git a/net/netfilter/nf_conntrack_sip.c b/net/netfilter/nf_conntrack_sip.c
index 5b1c24e..ac71fa8 100644
--- a/net/netfilter/nf_conntrack_sip.c
+++ b/net/netfilter/nf_conntrack_sip.c
@@ -236,12 +236,13 @@ int ct_sip_parse_request(const struct nf_conn *ct,
 		return 0;
 
 	/* Find SIP URI */
-	limit -= strlen("sip:");
-	for (; dptr < limit; dptr++) {
+	for (; dptr < limit - strlen("sip:"); dptr++) {
 		if (*dptr == '\r' || *dptr == '\n')
 			return -1;
-		if (strnicmp(dptr, "sip:", strlen("sip:")) == 0)
+		if (strnicmp(dptr, "sip:", strlen("sip:")) == 0) {
+			dptr += strlen("sip:");
 			break;
+		}
 	}
 	if (!skp_epaddr_len(ct, dptr, limit, &shift))
 		return 0;
