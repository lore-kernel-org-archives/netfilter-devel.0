From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 04/53] netfilter: nf_ct_sip: correct allowed characters in Call-ID SIP header
Date: Mon, 26 Sep 2016 01:06:14 +0200
Message-ID: <1474844823-2026-5-git-send-email-pablo@netfilter.org>
References: <1474844823-2026-1-git-send-email-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:54534 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S941139AbcIYXHX (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 25 Sep 2016 19:07:23 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 18D51B6C74
        for <netfilter-devel@vger.kernel.org>; Mon, 26 Sep 2016 01:07:22 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 0539EDA7F6
        for <netfilter-devel@vger.kernel.org>; Mon, 26 Sep 2016 01:07:22 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 11C24DA81F
        for <netfilter-devel@vger.kernel.org>; Mon, 26 Sep 2016 01:07:20 +0200 (CEST)
In-Reply-To: <1474844823-2026-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Marco Angaroni <marcoangaroni@gmail.com>

Current parsing methods for SIP header Call-ID do not check correctly all
characters allowed by RFC 3261. In particular "," character is allowed
instead of "'" character. As a result Call-ID headers like the following
are discarded by IPVS SIP persistence engine.

Call-ID: -.!%*_+`'~()<>:\"/[]?{}

Above example is composed using all non-alphanumeric characters listed
in RFC 3261 for Call-ID header syntax.

Proposed fix is in nf_conntrack_sip module; function iswordc() checks this
range: (c >= '(' && c <= '/') which includes these characters: ()*+,-./
They are all allowed except ",". Instead "'" is not included in the list.

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
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_conntrack_sip.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_conntrack_sip.c b/net/netfilter/nf_conntrack_sip.c
index 251a9a44d189..d8035351aff5 100644
--- a/net/netfilter/nf_conntrack_sip.c
+++ b/net/netfilter/nf_conntrack_sip.c
@@ -83,9 +83,10 @@ static int digits_len(const struct nf_conn *ct, const char *dptr,
 static int iswordc(const char c)
 {
 	if (isalnum(c) || c == '!' || c == '"' || c == '%' ||
-	    (c >= '(' && c <= '/') || c == ':' || c == '<' || c == '>' ||
+	    (c >= '(' && c <= '+') || c == ':' || c == '<' || c == '>' ||
 	    c == '?' || (c >= '[' && c <= ']') || c == '_' || c == '`' ||
-	    c == '{' || c == '}' || c == '~')
+	    c == '{' || c == '}' || c == '~' || (c >= '-' && c <= '/') ||
+	    c == '\'')
 		return 1;
 	return 0;
 }
-- 
2.1.4

