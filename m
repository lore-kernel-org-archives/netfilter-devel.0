From: Phil Sutter <phil@nwl.cc>
Subject: [nft PATCH 4/6] nft.8: Add note about supported hooks for bridge family
Date: Thu, 10 Aug 2017 19:29:18 +0200
Message-ID: <20170810172920.14893-5-phil@nwl.cc>
References: <20170810172920.14893-1-phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:32869 "EHLO mail.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752629AbdHJR3c (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 10 Aug 2017 13:29:32 -0400
In-Reply-To: <20170810172920.14893-1-phil@nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

It is the only address family which lacks a table describing supported
hooks. Since that would be identical to the one for ip/ip6/inet
families, just point there.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 doc/nft.xml | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/doc/nft.xml b/doc/nft.xml
index bc6b6fb72b6a7..00095ddafcdad 100644
--- a/doc/nft.xml
+++ b/doc/nft.xml
@@ -429,6 +429,9 @@ filter input iif $int_ifs accept
 			<para>
 				The bridge address family handles ethernet packets traversing bridge devices.
 			</para>
+			<para>
+				The list of supported hooks is identical to IPv4/IPv6/Inet address families above.
+			</para>
 		</refsect2>
 		<refsect2>
 			<title>Netdev address family</title>
-- 
2.13.1

