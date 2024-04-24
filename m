Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34D6D1581F4
	for <netfilter-devel@vger.kernel.org>; Wed, 24 Apr 2024 21:59:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713995997; cv=none; b=k6wSPSKVsBBIm6OnHald80D8qA3Fhnd9nFQldDrEO8lKKoCjff2ZgVh2fdycTWy0V6YwMoeF30FqucxuHxioW3LjBKmv6Gc00VcT2TIhKBPbTAQF0HN8tU01eRBV+jqB0bk9RS30KMJmNPBVIM5PxU1wFfFqTFzxI10DAjUb1IQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713995997; c=relaxed/simple;
	bh=8PW/WaVDrQSNt1WBXAnCnsY0xFlIZoJI73tC55sOivo=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=ELr/EJCwkyR2u7YJ3DgsN7LIjXw4LwM8QcE1ibMhTmyduQDKuVGwEhvfq2Ho7gs01gpCaKZ8W/haGfEiZ5E52vm7YP4akZUKj1ptcyrVMhvfNIyXOHMXTBlBjeeRYM/SVQov0UJwDN7CMz5MmeEcBDR0wyxBjXal4pNdSOvNYls=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=G+dU9gKT; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="G+dU9gKT"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
	To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=0W6gXT+xHNw1b7cNjm3GtzQkgKd6udgZYh5d/j6zfU0=; b=G+dU9gKTF4HQOXy4KkMueKW8RN
	pBeqHMGcHTA+GwU2hnihtebcWcObRgiMTr02kW4UEco3/J3MxTHOr2c8EbCD4/rHV+v03njQeqlHb
	2pqgaZHY0WF3hgvQ0ApNOzHn2lRUwuHtI5OrW5UYKxOJ+g6NBV/VV5nmNN78VCpXAgbDox1NNxb5u
	yTzEDXbCXQVpV/5OfI4sLLpsy8SbYXBl8i1mU4bvsKanEyg3noEfX7W/cXfHPIUgEyPL3JRpPGpNY
	EbA9Y8bJ8pjjYseHAGSAK5b9Tc/I9oeCdtnTgyPs758vMYnuEwyJuuxOrM6mbt17AQmY9vLK55vnm
	wsUGhNbw==;
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1rzkef-000000003p8-0foV
	for netfilter-devel@vger.kernel.org;
	Wed, 24 Apr 2024 23:59:53 +0200
From: Phil Sutter <phil@nwl.cc>
To: netfilter-devel@vger.kernel.org
Subject: [nft PATCH] tests: shell: Fix for maps/typeof_maps_add_delete with ASAN
Date: Wed, 24 Apr 2024 23:59:52 +0200
Message-ID: <20240424215952.19589-1-phil@nwl.cc>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

With both KASAN and ASAN enabled, my VM is too slow so the ping-induced
set entry times out before the test checks its existence. Increase its
timeout to 2s, seems to do the trick.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 .../testcases/maps/dumps/typeof_maps_add_delete.json-nft      | 2 +-
 tests/shell/testcases/maps/dumps/typeof_maps_add_delete.nft   | 2 +-
 tests/shell/testcases/maps/typeof_maps_add_delete             | 4 ++--
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/tests/shell/testcases/maps/dumps/typeof_maps_add_delete.json-nft b/tests/shell/testcases/maps/dumps/typeof_maps_add_delete.json-nft
index 8130c46c154cd..b3204a283d0ad 100644
--- a/tests/shell/testcases/maps/dumps/typeof_maps_add_delete.json-nft
+++ b/tests/shell/testcases/maps/dumps/typeof_maps_add_delete.json-nft
@@ -231,7 +231,7 @@
               "elem": {
                 "elem": {
                   "val": "10.2.3.4",
-                  "timeout": 1
+                  "timeout": 2
                 }
               },
               "data": 2,
diff --git a/tests/shell/testcases/maps/dumps/typeof_maps_add_delete.nft b/tests/shell/testcases/maps/dumps/typeof_maps_add_delete.nft
index 9134673cf48a1..e80366b8bf2a4 100644
--- a/tests/shell/testcases/maps/dumps/typeof_maps_add_delete.nft
+++ b/tests/shell/testcases/maps/dumps/typeof_maps_add_delete.nft
@@ -16,7 +16,7 @@ table ip dynset {
 
 	chain input {
 		type filter hook input priority filter; policy accept;
-		add @dynmark { 10.2.3.4 timeout 1s : 0x00000002 } comment "also check timeout-gc"
+		add @dynmark { 10.2.3.4 timeout 2s : 0x00000002 } comment "also check timeout-gc"
 		meta l4proto icmp ip daddr 127.0.0.42 jump test_ping
 	}
 }
diff --git a/tests/shell/testcases/maps/typeof_maps_add_delete b/tests/shell/testcases/maps/typeof_maps_add_delete
index d2ac9f1ce8c92..2d718c5fecbf3 100755
--- a/tests/shell/testcases/maps/typeof_maps_add_delete
+++ b/tests/shell/testcases/maps/typeof_maps_add_delete
@@ -30,7 +30,7 @@ EXPECTED="table ip dynset {
 	chain input {
 		type filter hook input priority 0; policy accept;
 
-		add @dynmark { 10.2.3.4 timeout 1s : 0x2 } comment \"also check timeout-gc\"
+		add @dynmark { 10.2.3.4 timeout 2s : 0x2 } comment \"also check timeout-gc\"
 		meta l4proto icmp ip daddr 127.0.0.42 jump test_ping
 	}
 }"
@@ -45,7 +45,7 @@ ping -c 1 127.0.0.42
 $NFT get element ip dynset dynmark { 10.2.3.4 }
 
 # wait so that 10.2.3.4 times out.
-sleep 2
+sleep 3
 
 set +e
 $NFT get element ip dynset dynmark { 10.2.3.4 } && exit 1
-- 
2.43.0

