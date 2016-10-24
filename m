From: Ulrich Weber <ulrich.weber@riverbed.com>
Subject: [PATCH v2] nf_conntrack_sip: extend request line validation
Date: Mon, 24 Oct 2016 18:07:23 +0200
Message-ID: <20161024160723.GA30272@gir>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: kaber@trash.net, marcoangaroni@gmail.com, pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp1.riverbed.com ([208.70.196.45]:64924 "EHLO
        smtp1.riverbed.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932255AbcJXQHc (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 24 Oct 2016 12:07:32 -0400
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

on SIP requests, so a fragmented TCP SIP packet from an allow header starting with
 INVITE,NOTIFY,OPTIONS,REFER,REGISTER,UPDATE,SUBSCRIBE
 Content-Length: 0

will not bet interpreted as an INVITE request. Also Request-URI must start with an alphabetic character.

Confirm with RFC 3261
 Request-Line   =  Method SP Request-URI SP SIP-Version CRLF

Signed-off-by: Ulrich Weber <ulrich.weber@riverbed.com>
---
 net/netfilter/nf_conntrack_sip.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nf_conntrack_sip.c b/net/netfilter/nf_conntrack_sip.c
index 7700556..df773d6 100644
--- a/net/netfilter/nf_conntrack_sip.c
+++ b/net/netfilter/nf_conntrack_sip.c
@@ -1436,9 +1436,12 @@ static int process_sip_request(struct sk_buff *skb, unsigned int protoff,
 		handler = &sip_handlers[i];
 		if (handler->request == NULL)
 			continue;
-		if (*datalen < handler->len ||
+		if (*datalen < handler->len + 2 ||
 		    strncasecmp(*dptr, handler->method, handler->len))
 			continue;
+		if ((*dptr)[handler->len] != ' ' ||
+		    !isalpha((*dptr)[handler->len+1]))
+			continue;
 
 		if (ct_sip_get_header(ct, *dptr, 0, *datalen, SIP_HDR_CSEQ,
 				      &matchoff, &matchlen) <= 0) {
-- 
2.7.4

