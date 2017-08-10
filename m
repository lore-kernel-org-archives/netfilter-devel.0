From: Phil Sutter <phil@nwl.cc>
Subject: [nft PATCH 6/6] nft.8: Complete short description of arp family
Date: Thu, 10 Aug 2017 19:29:20 +0200
Message-ID: <20170810172920.14893-7-phil@nwl.cc>
References: <20170810172920.14893-1-phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:51387 "EHLO mail.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752629AbdHJR3i (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 10 Aug 2017 13:29:38 -0400
In-Reply-To: <20170810172920.14893-1-phil@nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Although not very informational, still better than ending mid-sentence.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 doc/nft.xml | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/doc/nft.xml b/doc/nft.xml
index 73ef4d18f462f..39630ace32b16 100644
--- a/doc/nft.xml
+++ b/doc/nft.xml
@@ -304,7 +304,7 @@ filter input iif $int_ifs accept
 					<term><option>arp</option></term>
 					<listitem>
 						<para>
-							ARP address family, handling packets vi 
+							ARP address family, handling IPv4 ARP packets.
 						</para>
 					</listitem>
 				</varlistentry>
-- 
2.13.1

