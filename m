From: Marco Angaroni <marcoangaroni@gmail.com>
Subject: [PATCH 0/2] netfilter: allow tab character in SIP headers
Date: Tue, 30 Aug 2016 18:52:22 +0200
Message-ID: <20160830165222.pAgDVdNXQ%marcoangaroni@gmail.com>
To: lvs-devel@vger.kernel.org, netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:36389 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756306AbcH3Qw0 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 30 Aug 2016 12:52:26 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Current parsing methods for SIP headers do not allow the presence of
tab characters between header name and header value. As a result Call-ID
SIP headers like the following are discarded by IPVS SIP persistence
engine:

"Call-ID\t: mycallid@abcde"
"Call-ID:\tmycallid@abcde"

In above examples Call-IDs are represented as strings in C language.
Obviously in real message we have byte "09" before/after colon (":").

Proposed fix is in nf_conntrack_sip module.
Function sip_skip_whitespace() should skip tabs in addition to spaces,
since in SIP grammar whitespace (WSP) corresponds to space or tab.

Below is an extract of relevant SIP ABNF syntax.

Call-ID  =  ( "Call-ID" / "i" ) HCOLON callid
callid   =  word [ "@" word ]

HCOLON  =  *( SP / HTAB ) ":" SWS
SWS     =  [LWS] ; sep whitespace
LWS     =  [*WSP CRLF] 1*WSP ; linear whitespace
WSP     =  SP / HTAB
word    =  1*(alphanum / "-" / "." / "!" / "%" / "*" /
           "_" / "+" / "`" / "'" / "~" /
           "(" / ")" / "<" / ">" /
           ":" / "\" / DQUOTE /
           "/" / "[" / "]" / "?" /
           "{" / "}" )

Signed-off-by: Marco Angaroni <marcoangaroni@gmail.com>
---
 net/netfilter/nf_conntrack_sip.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nf_conntrack_sip.c b/net/netfilter/nf_conntrack_sip.c
index f72ba55..4acd60e 100644
--- a/net/netfilter/nf_conntrack_sip.c
+++ b/net/netfilter/nf_conntrack_sip.c
@@ -329,7 +329,7 @@ static const char *sip_follow_continuation(const char *dptr, const char *limit)
 static const char *sip_skip_whitespace(const char *dptr, const char *limit)
 {
 	for (; dptr < limit; dptr++) {
-		if (*dptr == ' ')
+		if (*dptr == ' ' || *dptr == '\t')
 			continue;
 		if (*dptr != '\r' && *dptr != '\n')
 			break;
-- 
1.8.3.1

