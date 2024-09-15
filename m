Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 56B4E49620
	for <netfilter-devel@vger.kernel.org>; Sun, 15 Sep 2024 22:45:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726440342; cv=none; b=lQ6+HUqhhrbWA3B9Th3dg4QdDNBz7jBA1vBxv0Yrd6Bk9acBZUnkgbhzUW3hrhichOukVBvC2Kg6JhWc03UTnevBrcBKIHmmXBPU2evzFfjBh+mkW0w2R0N/jpE7+qCKB+6djKspliHVJGrkCg7qd3BL2ebYF7uBzwHA9EdEZg8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726440342; c=relaxed/simple;
	bh=kFTnH7QtczKiIZ1izlo+Jmaa6wpTo0JFE3Hs1AopnWs=;
	h=From:To:Subject:Date:Message-Id:MIME-Version; b=icfnH833WkQnhrZ2jHnFNLjiTAkuBiIotHcgsFiS/n9XL7MPde0q0poBqoT5+QbxRFO19ku3Zn649D7ctpS8YYzxBjBZGQkfmJrAjDafKsfxjwmm/WAuTdnqUOEAjRToNkJ1omRCYuAoV6A0xMZ9nsakMsVua5Oes9B1I6PiutU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nft] doc: tproxy is non-terminal in nftables
Date: Mon, 16 Sep 2024 00:45:28 +0200
Message-Id: <20240915224528.158198-1-pablo@netfilter.org>
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

Acked-by: Phil Sutter <phil@nwl.cc>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 doc/statements.txt | 32 +++++++++++++++++++++++++-------
 1 file changed, 25 insertions(+), 7 deletions(-)

diff --git a/doc/statements.txt b/doc/statements.txt
index 5becf0cbdbcf..386505481d3a 100644
--- a/doc/statements.txt
+++ b/doc/statements.txt
@@ -583,27 +583,45 @@ this case the rule will match for both families.
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
+        tcp dport 321 tproxy to :ssh accept
+        tcp dport 99 tproxy ip to 1.1.1.1:999 accept
+        udp dport 155 tproxy ip6 to [dead::beef]:smux accept
     }
 }
 -------------------------------------
 
+Note that the tproxy statement is non-terminal to allow post-processing of
+packets, such logging the packet for debugging.
+
+.Example ruleset for tproxy statement with logging
+-------------------------------------
+table t {
+    chain c {
+        type filter hook prerouting priority mangle; policy accept;
+        udp dport 9999 tproxy to :1234 log prefix "packet tproxied: " accept
+        log prefix "no socket on port 1234 or not transparent?: " drop
+    }
+}
+-------------------------------------
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

