From: Duncan Roe <duncan_roe@optusnet.com.au>
Subject: [PATCH] doc: nft.8 document use of -f option to start nft scripts
Date: Sun, 19 Nov 2017 20:51:50 +1100
Message-ID: <20171119095150.6697-1-duncan_roe@optusnet.com.au>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail108.syd.optusnet.com.au ([211.29.132.59]:37351 "EHLO
        mail108.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750788AbdKSJwN (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 19 Nov 2017 04:52:13 -0500
Received: from dimstar.local.net (c220-239-53-24.eburwd6.vic.optusnet.com.au [220.239.53.24])
        by mail108.syd.optusnet.com.au (Postfix) with SMTP id 770C81AA1E6
        for <netfilter-devel@vger.kernel.org>; Sun, 19 Nov 2017 20:51:52 +1100 (AEDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The man page didn't document nft scripts at all before, so putting that with the
-f option seemed as good a place as any. It does work to start scripts
#!/usr/sbin/nft --file but I didn't think this was worth documenting. The wiki
is also updated.

Signed-off-by: Duncan Roe <duncan_roe@optusnet.com.au>
---
 doc/nft.xml | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/doc/nft.xml b/doc/nft.xml
index 2dec0aa..432f1c4 100644
--- a/doc/nft.xml
+++ b/doc/nft.xml
@@ -168,6 +168,9 @@ vi:ts=4 sw=4
 					<para>
 						Read input from <replaceable>filename</replaceable>.
 					</para>
+					<para>
+						nft scripts must start <command>#!/usr/sbin/nft -f</command>
+					</para>
 				</listitem>
 			</varlistentry>
 			<varlistentry>
-- 
2.9.0

