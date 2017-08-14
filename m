From: Daniel Kahn Gillmor <dkg@fifthhorseman.net>
Subject: [PATCH] man: use https for wiki link
Date: Mon, 14 Aug 2017 13:27:11 -0400
Message-ID: <20170814172711.29880-1-dkg@fifthhorseman.net>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from che.mayfirst.org ([162.247.75.118]:49273 "EHLO che.mayfirst.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752328AbdHNRgV (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 14 Aug 2017 13:36:21 -0400
Received: from fifthhorseman.net (unknown [38.109.115.130])
        by che.mayfirst.org (Postfix) with ESMTPSA id 6B08AF99B
        for <netfilter-devel@vger.kernel.org>; Mon, 14 Aug 2017 13:27:20 -0400 (EDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

https works for the wiki, and users should prefer it by default,
whether they are logging in (to protect their credentials) or whether
they're reading data (to protect the integrity of the content).

Signed-off-by: Daniel Kahn Gillmor <dkg@fifthhorseman.net>
Acked-by: Arturo Borrero Gonzalez <arturo@netfilter.org>
---
 doc/nft.xml | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/doc/nft.xml b/doc/nft.xml
index 734f371..d7aae3f 100644
--- a/doc/nft.xml
+++ b/doc/nft.xml
@@ -5059,7 +5059,7 @@ filter output oif wlan0
 			</simplelist>
 		</para>
 		<para>
-			There is an official wiki at: http://wiki.nftables.org
+			There is an official wiki at: https://wiki.nftables.org
 		</para>
 	</refsect1>
 
-- 
2.13.2

