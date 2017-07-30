From: Varsha Rao <rvarsha016@gmail.com>
Subject: [PATCH nft] man: Document nft monitor ruleset.
Date: Mon, 31 Jul 2017 00:26:02 +0530
Message-ID: <597e2bc6.c667620a.541bd.838b@mx.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: pablo@netfilter.org, netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pf0-f195.google.com ([209.85.192.195]:38108 "EHLO
        mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754194AbdG3S4H (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 30 Jul 2017 14:56:07 -0400
Received: by mail-pf0-f195.google.com with SMTP id e3so6828620pfc.5
        for <netfilter-devel@vger.kernel.org>; Sun, 30 Jul 2017 11:56:07 -0700 (PDT)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Add documentation for nft monitor ruleset command.

Signed-off-by: Varsha Rao <rvarsha016@gmail.com>
---
 doc/nft.xml | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/doc/nft.xml b/doc/nft.xml
index 9c9192c..4d03a3d 100644
--- a/doc/nft.xml
+++ b/doc/nft.xml
@@ -4385,7 +4385,7 @@ add rule nat prerouting tcp dport 22 redirect to :2222
 				XML, JSON or native nft format.
 			</para>
 			<para>
-				To filter events related to a concrete object, use one of the keywords 'tables', 'chains', 'sets', 'rules', 'elements'.
+				To filter events related to a concrete object, use one of the keywords 'tables', 'chains', 'sets', 'rules', 'elements'				      , 'ruleset'.
 			</para>
 			<para>
 				To filter events related to a concrete action, use keyword 'new' or 'destroy'.
@@ -4417,6 +4417,12 @@ add rule nat prerouting tcp dport 22 redirect to :2222
 % nft monitor chains
 				</programlisting>
 			</example>
+			<example>
+				<title>Listen to ruleset events such as table, chain, rule, set, counters and quotas, in native nft format</title>
+				<programlisting>
+% nft monitor ruleset
+				</programlisting>
+			</example>
 		</refsect2>
 	</refsect1>
 
-- 
2.9.4

