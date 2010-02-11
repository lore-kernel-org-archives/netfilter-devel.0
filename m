From: Patrick McHardy <kaber@trash.net>
Subject: netfilter 03/08: nf_conntrack_sip: fix ct_sip_parse_request() REGISTER request parsing
Date: Thu, 11 Feb 2010 08:39:39 +0100 (MET)
Message-ID: <20100211073936.7894.13904.sendpatchset@x2.localnet>
References: <20100211073932.7894.23544.sendpatchset@x2.localnet>
Cc: Patrick McHardy <kaber@trash.net>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:35444 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751890Ab0BKHjl (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 11 Feb 2010 02:39:41 -0500
In-Reply-To: <20100211073932.7894.23544.sendpatchset@x2.localnet>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

commit b595ec74123dc71c56401feec6c35c822a8fc310
Author: Patrick McHardy <kaber@trash.net>
Date:   Thu Feb 11 07:40:30 2010 +0100

    netfilter: nf_conntrack_sip: fix ct_sip_parse_request() REGISTER request parsing
    
    When requests are parsed, the "sip:" part of the SIP URI should be skipped.
    
    Usually this doesn't matter because address parsing skips forward until after
    the username part, but in case REGISTER requests it doesn't contain a username
    and the address can not be parsed.
    
    Signed-off-by: Patrick McHardy <kaber@trash.net>

diff --git a/net/netfilter/nf_conntrack_sip.c b/net/netfilter/nf_conntrack_sip.c
index 419c5ca..0ca2f2b 100644
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
