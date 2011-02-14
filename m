From: Max Kellermann <max@duempel.org>
Subject: [PATCH] xtables: use strspn() to check if string needs to be quoted
Date: Mon, 14 Feb 2011 07:54:45 +0100
Message-ID: <20110214065445.30608.81511.stgit@woodpecker.blarg.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from cc-smtpout2.netcologne.de ([89.1.8.212]:47659 "EHLO
	cc-smtpout2.netcologne.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751707Ab1BNHEV (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 14 Feb 2011 02:04:21 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Problem: the call xtables_save_string("'") prints just a single quote,
not enclosed in double quoted and not escaped.

Steps to reproduce:

 $ iptables -A foo -m comment --comment "'" -j ACCEPT
 $ iptables-multi save|grep foo
 -A foo -m comment --comment ' -j ACCEPT

The cause was the use of strcspn() to locate the first character which
justified quoting the string in double quotes.  That however was
wrong, because the way strcspn() was called, it returned a pointer to
the first character that was not to be escaped, which did the right
thing most of the time, but not for strings consisting only of quote
characters.  This patch changes strcspn() to strspn().
---
 xtables.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/xtables.c b/xtables.c
index fc59f75..57d5d13 100644
--- a/xtables.c
+++ b/xtables.c
@@ -1638,7 +1638,7 @@ void xtables_save_string(const char *value)
 	size_t length;
 	const char *p;
 
-	length = strcspn(value, no_quote_chars);
+	length = strspn(value, no_quote_chars);
 	if (length > 0 && value[length] == 0) {
 		/* no quoting required */
 		putchar(' ');

