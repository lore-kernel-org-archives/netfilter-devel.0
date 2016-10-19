From: Ulrich Weber <ulrich.weber@riverbed.com>
Subject: [PATCH] nf_conntrack_sip: check for trailing spaces
Date: Wed, 19 Oct 2016 10:24:02 +0200
Message-ID: <20161019082402.GA4575@gir>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from eng.riverbed.com ([208.70.196.45]:32413 "EHLO
        smtp1.riverbed.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S943001AbcJSPuv (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 19 Oct 2016 11:50:51 -0400
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

on SIP requests, so a fragmented TCP SIP packet starting with
 INVITE,NOTIFY,OPTIONS,REFER,REGISTER,UPDATE,SUBSCRIBE
 Content-Length: 0

will not bet interpreted as an INVITE request.

Confirm with RFC 3261
 Request-Line   =  Method SP Request-URI SP SIP-Version CRLF

Signed-off-by: Ulrich Weber <ulrich.weber@riverbed.com>
---
 net/netfilter/nf_conntrack_sip.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nf_conntrack_sip.c b/net/netfilter/nf_conntrack_sip.c
index 7700556..e37f8da 100644
--- a/net/netfilter/nf_conntrack_sip.c
+++ b/net/netfilter/nf_conntrack_sip.c
@@ -1436,9 +1436,11 @@ static int process_sip_request(struct sk_buff *skb, unsigned int protoff,
 		handler = &sip_handlers[i];
 		if (handler->request == NULL)
 			continue;
-		if (*datalen < handler->len ||
+		if (*datalen < handler->len + 1 ||
 		    strncasecmp(*dptr, handler->method, handler->len))
 			continue;
+		if ((*dptr)[handler->len] != ' ')
+			continue;
 
 		if (ct_sip_get_header(ct, *dptr, 0, *datalen, SIP_HDR_CSEQ,
 				      &matchoff, &matchlen) <= 0) {
-- 
2.7.4

