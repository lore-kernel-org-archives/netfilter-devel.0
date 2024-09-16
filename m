Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A2D8A158527
	for <netfilter-devel@vger.kernel.org>; Mon, 16 Sep 2024 21:39:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726522803; cv=none; b=lq52LoinmIleUD7/lBuN/9uUfCn4PF0r403hW06AdKKQJvGF5jRCsiUR3io4uSAm1+AI6CeNymmLtJj6o0THMgacRjYhnCAtx+RUzJn6QR5LB1zqmgmJg0518y2XwGDpq0W31bCXCDW0ZPuBLPgOVNhfcjeEhEA9hYFVHupIxww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726522803; c=relaxed/simple;
	bh=ybP1uCYn8DW3LJ6XSxH8WWcrxyTUnmUlb0oEOO/3tZk=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=BxIYjqU9fyVOkf76c7sogoQoZfqZ9N2m7yM6vPyg3Cx1HZaZFK6EcPnohgaQzJqR2JKOhtxkxSnjaKJVO6i89kp6hCZeU/LQmVolpov7NmaMS5/L3Jw35qC8RlRiuVn5t2+F5LHkU+ajPS71g75jaFMOzB02TelO1aKp72YGUoQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: fw@strlen.de,
	phil@nwl.cc,
	antonio.ojea.garcia@gmail.com
Subject: [PATCH nft,v3] doc: tproxy is non-terminal in nftables
Date: Mon, 16 Sep 2024 23:39:54 +0200
Message-Id: <20240916213954.647509-1-pablo@netfilter.org>
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
v3: small update to this example:

+.Example ruleset for tproxy statement with logging and meta mark
+-------------------------------------
+table inet x {
+    chain y {
+        type filter hook prerouting priority mangle; policy accept;
+        udp dport 9999 goto {
+            tproxy to :1234 log prefix "packet tproxied: " meta mark set 1 accept
+            log prefix "no socket on port 1234 or not transparent?: " drop
+        }
+    }
+}

 doc/statements.txt | 45 ++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 38 insertions(+), 7 deletions(-)

diff --git a/doc/statements.txt b/doc/statements.txt
index 5becf0cbdbcf..74af1d1a54e9 100644
--- a/doc/statements.txt
+++ b/doc/statements.txt
@@ -583,27 +583,58 @@ this case the rule will match for both families.
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
+table inet x {
+    chain y {
+        type filter hook prerouting priority mangle; policy accept;
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

