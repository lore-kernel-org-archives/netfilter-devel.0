Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B456823BD10
	for <netfilter-devel@vger.kernel.org>; Thu,  6 Mar 2025 18:28:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741285707; cv=none; b=idatUGmSpOCirEaSetwP3rcH/eCrmgLPgOMRkLv8p9s8FbkcdSO362kV/f/L9z4o55uB+firqJhv9gSi12KXfnxmpwmqdvHor7SXog9AQTfJFqjO8uKwIbZKzvFfUaatdlBLm4cgtS99U8XDdwcf18zCWBEUFepbKJbDqnSZg7I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741285707; c=relaxed/simple;
	bh=QFZ4V2Ld+m6xBwtHmJyS3eu/4j12FTfy4MlvBlfSt24=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Yz8bvG/XxIyQQR/5zOUwX1bzigasX+S8vTsSmGwfLO2Wv8ntN/uAh84JnOEi+TGOBGLpcgYdVdK8QMNeQcHF0dhDlOh5jhCdTP+P2wNu+y6h6YKcaIsS23GDRoROzhTuSS1SF9XFVXlX5JaNL8XGBgx+IG4NezDcf8bLO4jRJv0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=nOOQtRGz; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=Uz/pMjiw; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="nOOQtRGz";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="Uz/pMjiw"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 01FD160293; Thu,  6 Mar 2025 19:28:23 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1741285704;
	bh=5c/4lXADSu59Z18MaRflqQFpkKtfEUAFZUtVY2zv0IM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nOOQtRGz3MjzXaLUie4AkBzi9Dfj643M5a/1iYOxSBktegqnalR8B78O2dz+wHPVG
	 OHZ3mH0R/IaOvr1X0zq3CiCFGBQc5iN9Kpfn5Y3rypLrzaWx/HFS2aibN0b4pcO/FK
	 ofeBmVhnDoX4IA8VPw1Ym8ofkHShZkSy1m9KGUpW7cI/vkPPVSoDexCa+bB+GwTBsO
	 HR9bc/87MP0X+2EAFfXE/xUqFBe2+9FGjmZxvSgCq216LROuyiUuSO6utiTZkPRCsB
	 ul0rSGc7Smv8ebO8DayaLhXx04ofDb7avS4FD9QpG2PuAaUIn6FxqPfST0G3huL1WR
	 9Foe/mYpte8IA==
X-Spam-Level: 
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 38E2C60293;
	Thu,  6 Mar 2025 19:28:23 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1741285703;
	bh=5c/4lXADSu59Z18MaRflqQFpkKtfEUAFZUtVY2zv0IM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Uz/pMjiwQYRnOpjbgzrtGzwapnTYhSvyU+krjpKJZA3pUOYjPZey5YhUXFgyatxoE
	 ttSozn6sss96JB9sZQFLnuEs7gH5llpy369jiLq9nFw70Yg4LZjMtwfHC1mlw81iQo
	 4JsjbAMWhcnlEP+pimkyGfZn3kyItejNvdG/+hjndWhNSkWWS+HvN0yVPsUXXtG4Zn
	 P0xnVSFNe7Vzby1dFoZg8BD7CiYN44H1n6/nb2p7Ih9twgTgx7CZ3Xjl6+6AWX+wfJ
	 krled3OaJ3f7kkzxTCPpMIF70hbIG8o0dIvYd5Ck5Wi0W3T9Bhco+ZTZClUsh6vAzh
	 4Ju6lduzAYKnQ==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: fw@strlen.de
Subject: [PATCH nft,v2 3/3] tests: extend reset test case to cover interval set and map type
Date: Thu,  6 Mar 2025 19:28:12 +0100
Message-Id: <20250306182812.330871-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20250306182812.330871-1-pablo@netfilter.org>
References: <20250306182812.330871-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Florian Westphal <fw@strlen.de>

Make sure segtree processing doesn't drop associated stateful elements.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v2: add map tests.

 tests/shell/testcases/sets/reset_command_0 | 70 ++++++++++++++++++----
 1 file changed, 60 insertions(+), 10 deletions(-)

diff --git a/tests/shell/testcases/sets/reset_command_0 b/tests/shell/testcases/sets/reset_command_0
index d38ddb3ffeeb..c59cc56d20b8 100755
--- a/tests/shell/testcases/sets/reset_command_0
+++ b/tests/shell/testcases/sets/reset_command_0
@@ -17,6 +17,19 @@ RULESET="table t {
 			2.0.0.2 . tcp . 22 counter packets 10 bytes 100 timeout 15m expires 10m
 		}
 	}
+
+	set s2 {
+		type ipv4_addr
+		flags interval, timeout
+		counter
+		timeout 30m
+		elements = {
+			1.0.0.1 counter packets 5 bytes 30 expires 20m,
+			1.0.1.1-1.0.1.10 counter packets 5 bytes 30 expires 20m,
+			2.0.0.2 counter packets 10 bytes 100 timeout 15m expires 10m
+		}
+	}
+
 	map m {
 		type ipv4_addr : ipv4_addr
 		quota 50 bytes
@@ -25,6 +38,27 @@ RULESET="table t {
 			5.6.7.8 quota 100 bytes used 50 bytes : 50.6.7.8
 		}
 	}
+
+	map m1 {
+		type ipv4_addr : ipv4_addr
+		counter
+		timeout 30m
+		elements = {
+			1.2.3.4 counter packets 5 bytes 30 expires 20m : 10.2.3.4,
+			5.6.7.8 counter packets 10 bytes 100 timeout 15m expires 10m : 50.6.7.8
+		}
+	}
+
+	map m2 {
+		type ipv4_addr : ipv4_addr
+		flags interval, timeout
+		counter
+		timeout 30m
+		elements = {
+			1.2.3.4-1.2.3.10 counter packets 5 bytes 30 expires 20m : 10.2.3.4,
+			5.6.7.8-5.6.7.10 counter packets 10 bytes 100 timeout 15m expires 10m : 50.6.7.8
+		}
+	}
 }"
 
 echo -n "applying test ruleset: "
@@ -38,17 +72,33 @@ expires_minutes() {
 	sed -n 's/.*expires \([0-9]*\)m.*/\1/p'
 }
 
-echo -n "get set elem matches reset set elem: "
-elem='element t s { 1.0.0.1 . udp . 53 }'
-[[ $($NFT "get $elem ; reset $elem" | \
-	grep 'elements = ' | drop_seconds | uniq | wc -l) == 1 ]]
-echo OK
+get_and_reset()
+{
+	local setname="$1"
+	local key="$2"
 
-echo -n "counters are reset, expiry left alone: "
-NEW=$($NFT "get $elem")
-grep -q 'counter packets 0 bytes 0' <<< "$NEW"
-[[ $(expires_minutes <<< "$NEW") -lt 20 ]]
-echo OK
+	echo -n "get set elem matches reset set elem in set $setname: "
+
+	elem="element t $setname { $key }"
+	echo $NFT get $elem
+	$NFT get $elem
+	[[ $($NFT "get $elem ; reset $elem" | \
+		grep 'elements = ' | drop_seconds | uniq | wc -l) == 1 ]]
+	echo OK
+
+	echo -n "counters are reset, expiry left alone in set $setname: "
+	NEW=$($NFT "get $elem")
+	echo NEW $NEW
+	grep -q 'counter packets 0 bytes 0' <<< "$NEW"
+	[[ $(expires_minutes <<< "$NEW") -lt 20 ]]
+	echo OK
+}
+
+get_and_reset "s" "1.0.0.1 . udp . 53"
+get_and_reset "s2" "1.0.0.1"
+get_and_reset "s2" "1.0.1.1-1.0.1.10"
+get_and_reset "m1" "1.2.3.4"
+get_and_reset "m2" "1.2.3.4-1.2.3.10"
 
 echo -n "get map elem matches reset map elem: "
 elem='element t m { 1.2.3.4 }'
-- 
2.30.2

