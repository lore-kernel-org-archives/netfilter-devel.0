Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9CFA6F9DA
	for <netfilter-devel@vger.kernel.org>; Mon, 16 Sep 2024 21:21:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726521703; cv=none; b=Y1yOZGTG5z6px9FygeV+LfC61nMoiu8Ed+5z8rf+bLMBv2i0mKpWE6yb7NNca+4cXJwehmsDARrXjPcoe3jSabXLtnzjx4ZOzlkQ03iAlzIFQmhc3MbSXMvwovd67z+tqVIBN1CPyNML7FGoWU2TnISWYWr8VzTUcLL9y1oh6dY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726521703; c=relaxed/simple;
	bh=2SQUqHcdW9ivFuiBMRiiQLcBceI99TteCLtlvZ4cG1U=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=igBIWJHPMoD/aotCQF5QS5Z2EGLihvhNANVlM/sP+VkttNwZvKIUZJRSYgUOlgstQ0PX7xEgryWliQ7F7mefupxkLGPSP2UGAm6zdMOsK5d2RmUp+Y5HwFwu+Dadvx7yRR/WCqCQya+zd30ApBnW+v/n1wkNwSNJb4qhBgxqwME=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: fw@strlen.de,
	phil@nwl.cc,
	antonio.ojea.garcia@gmail.com
Subject: [PATCH nft,v2] doc: tproxy is non-terminal in nftables
Date: Mon, 16 Sep 2024 23:21:32 +0200
Message-Id: <20240916212132.646493-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

iptables TPROXY issues NF_ACCEPT while nftables tproxy allows for
post-processing. Update examples. For more info, see:

https://lore.kernel.org/netfilter-devel/ZuSh_Io3Yt8LkyUh@orbyte.nwl.cc/T/

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 doc/statements.txt | 44 +++++++++++++++++++++++++++++++++++++-------
 1 file changed, 37 insertions(+), 7 deletions(-)

diff --git a/doc/statements.txt b/doc/statements.txt
index 5becf0cbdbcf..7d4e8b34bef0 100644
--- a/doc/statements.txt
+++ b/doc/statements.txt
@@ -583,27 +583,57 @@ this case the rule will match for both families.
 table ip x {
     chain y {
         type filter hook prerouting priority mangle; policy accept;
-        tcp dport ntp tproxy to 1.1.1.1
-        udp dport ssh tproxy to :2222
+        tcp dport ntp tproxy to 1.1.1.1 accept
+        udp dport ssh tproxy to :2222 accept
     }
 }
 table ip6 x {
     chain y {
        type filter hook prerouting priority mangle; policy accept;
-       tcp dport ntp tproxy to [dead::beef]
-       udp dport ssh tproxy to :2222
+       tcp dport ntp tproxy to [dead::beef] accept
+       udp dport ssh tproxy to :2222 accept
     }
 }
 table inet x {
     chain y {
         type filter hook prerouting priority mangle; policy accept;
-        tcp dport 321 tproxy to :ssh
-        tcp dport 99 tproxy ip to 1.1.1.1:999
-        udp dport 155 tproxy ip6 to [dead::beef]:smux
+        tcp dport 321 tproxy to :22 accept
+        tcp dport 99 tproxy ip to 1.1.1.1:999 accept
+        udp dport 155 tproxy ip6 to [dead::beef]:smux accept
     }
 }
 -------------------------------------
 
+Note that the tproxy statement is non-terminal to allow post-processing of
+packets. This allows packets to be logged for debugging as well as updating the
+mark to ensure that packets are delivered locally through policy routing rules.
+
+.Example ruleset for tproxy statement with logging and meta mark
+-------------------------------------
+table t {
+    chain c {
+        udp dport 9999 goto {
+            tproxy to :1234 log prefix "packet tproxied: " meta mark set 1 accept
+            log prefix "no socket on port 1234 or not transparent?: " drop
+        }
+    }
+}
+-------------------------------------
+
+As packet headers are unchanged, packets might be forwarded instead of delivered
+locally. As mentioned above, this can be avoided by adding policy routing rules
+and the packet mark.
+
+.Example policy routing rules for local redirection
+----------------------------------------------------
+ip rule add fwmark 1 lookup 100
+ip route add local 0.0.0.0/0 dev lo table 100
+----------------------------------------------------
+
+This is a change in behavior compared to the legacy iptables TPROXY target
+which is terminal. To terminate the packet processing after the tproxy
+statement, remember to issue a verdict as in the example above.
+
 SYNPROXY STATEMENT
 ~~~~~~~~~~~~~~~~~~
 This statement will process TCP three-way-handshake parallel in netfilter
-- 
2.30.2

