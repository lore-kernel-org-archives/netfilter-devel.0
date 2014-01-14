From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 1/3] scanner: replace binary characters '&' '|' and '!' by their names
Date: Tue, 14 Jan 2014 12:30:28 +0100
Message-ID: <1389699030-6301-2-git-send-email-pablo@netfilter.org>
References: <1389699030-6301-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:51912 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751503AbaANLan (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 14 Jan 2014 06:30:43 -0500
In-Reply-To: <1389699030-6301-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

These symbol need to be escaped in bash and can lead to confusion,
so let's use their names instead which are still short, eg.

 nft add rule filter output meta mark and 0x3 == 0x1

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/scanner.l |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/src/scanner.l b/src/scanner.l
index cee6aa6..2d7ac88 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -200,9 +200,9 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 "<<"			{ return LSHIFT; }
 ">>"			{ return RSHIFT; }
 "^"			{ return CARET; }
-"&"			{ return AMPERSAND; }
-"|"			{ return '|'; }
-"!"			{ return NOT; }
+"and"			{ return AMPERSAND; }
+"or"			{ return '|'; }
+"not"			{ return NOT; }
 "/"			{ return SLASH; }
 "-"			{ return DASH; }
 "*"			{ return ASTERISK; }
-- 
1.7.10.4

