Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3FE0431E5F
	for <netfilter-devel@vger.kernel.org>; Thu,  2 Jul 2026 12:36:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782995805; cv=none; b=lrhNag0U/YnnSoW6m9U3/lAi7pLsVvbgssSxx/bt5vPhSNZkERb1qmfzx1WBqtSpV/E54MvoVZirJqStjbwUuG70Caf3ZzmSpmt/OauXVcYIXbVJzQh/Y8rGODpHXVcrjNeQPnvqaSD9+vzmClRID9UDWe6jcc5+Od6zX3iLOUM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782995805; c=relaxed/simple;
	bh=9jSFSI/an4J7nGnYCW+x4lB4VFbm73aMA/cPmYXvzb4=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TsU0TC9GQUquLc9TANSyIi3kurTqiPRxNBo58qTI4G49DsFuDXBqpEVd9P+ka34KaFIl6HwDkdSIF3sutqoHQFOWyPW80nBf8pUZWRb6HVh9WquU+ama8PjCMhL9uBbWjaIaaCV/VqCQ64Jv3zwuaVwTCzsmGzkRZLGty3UggqA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=vvusGG7D; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="vvusGG7D"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 97851605AC
	for <netfilter-devel@vger.kernel.org>; Thu,  2 Jul 2026 14:36:41 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1782995802;
	bh=sbFR7YMHUByXryoPT+a/EGKBLhhbEEkGmg/8w/6g13U=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=vvusGG7DxxDeBPCzsYyw3hvLzaDtJyMtchJUVRQet5yPMrPKQcx8vRgY7jMEy8EkX
	 au2W5KDUVbDq3CnRyLse2atktzVQX3KWpj4Tu74PCdBzciwpW7ieB9s7aNgbwL8Z1W
	 kSKBzjLEmoquC0CLhl34+Bxt5rvTyy1fru6C46sbY4VLqU8o8gl5fOC8z2arxnVKku
	 aiz3x0KQLV3LCBBSHm+24AWX2FsZxyKK4W+pwPK8Ez6IQAujgndjGMQhVwED5OaSoZ
	 2Nd4yCo9V1N5ASqQNguI3htMKepr8p/+FNSJ2lDyohmA7Y0BAfvVp8+AQD5i/vVZjD
	 tHsEPV5gaRuGg==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nft 2/2] tests: shell: expand get command test with open intervals
Date: Thu,  2 Jul 2026 14:36:34 +0200
Message-ID: <20260702123634.349861-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260702123634.349861-1-pablo@netfilter.org>
References: <20260702123634.349861-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Extend the existing test to cover get commands with open internals.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 tests/shell/testcases/sets/0034get_element_0         | 12 +++++++++++-
 .../testcases/sets/dumps/0034get_element_0.json-nft  |  6 ++++++
 .../shell/testcases/sets/dumps/0034get_element_0.nft |  2 +-
 3 files changed, 18 insertions(+), 2 deletions(-)

diff --git a/tests/shell/testcases/sets/0034get_element_0 b/tests/shell/testcases/sets/0034get_element_0
index 32375b9f50c2..a25769604685 100755
--- a/tests/shell/testcases/sets/0034get_element_0
+++ b/tests/shell/testcases/sets/0034get_element_0
@@ -16,7 +16,7 @@ check() { # (set, elems, expected)
 
 RULESET="add table ip t
 add set ip t s { type inet_service; flags interval; }
-add element ip t s { 10, 20-30, 40, 50-60 }
+add element ip t s { 10, 20-30, 40, 50-60, 60000-65535 }
 add set ip t ips { type ipv4_addr; flags interval; }
 add element ip t ips { 10.0.0.1, 10.0.0.5-10.0.0.8 }
 add element ip t ips { 10.0.0.128/25, 10.0.1.0/24, 10.0.2.3-10.0.2.12 }
@@ -36,6 +36,16 @@ check s 15-18 ""
 # multiple single elements, ranges smaller than present
 check s "10, 40" "10, 40"
 check s "22-24, 26-28" "20-30, 20-30"
+check s "60000-65535" "60000-65535"
+check s "60000-65534" "60000-65535"
+check s "60001-65535" "60000-65535"
+check s "60001-65534" "60000-65535"
+check s "22-24, 60000-65535" "20-30, 60000-65535"
+check s "22-24, 60000-65534" "20-30, 60000-65535"
+check s "22-24, 60001-65535" "20-30, 60000-65535"
+check s "22-24, 60001-65534" "20-30, 60000-65535"
+check s "60001-65534, 10" "60000-65535, 10"
+check s "20, 60001-65535, 10" "20-30, 60000-65535, 10"
 check s 21-29 20-30
 
 # mixed single elements and ranges
diff --git a/tests/shell/testcases/sets/dumps/0034get_element_0.json-nft b/tests/shell/testcases/sets/dumps/0034get_element_0.json-nft
index bfc0e4a0f588..64c7dc0c6555 100644
--- a/tests/shell/testcases/sets/dumps/0034get_element_0.json-nft
+++ b/tests/shell/testcases/sets/dumps/0034get_element_0.json-nft
@@ -38,6 +38,12 @@
               50,
               60
             ]
+          },
+          {
+            "range": [
+              60000,
+              65535
+            ]
           }
         ]
       }
diff --git a/tests/shell/testcases/sets/dumps/0034get_element_0.nft b/tests/shell/testcases/sets/dumps/0034get_element_0.nft
index 1c1dd9779a8a..889640389cd9 100644
--- a/tests/shell/testcases/sets/dumps/0034get_element_0.nft
+++ b/tests/shell/testcases/sets/dumps/0034get_element_0.nft
@@ -2,7 +2,7 @@ table ip t {
 	set s {
 		type inet_service
 		flags interval
-		elements = { 10, 20-30, 40, 50-60 }
+		elements = { 10, 20-30, 40, 50-60, 60000-65535 }
 	}
 
 	set ips {
-- 
2.47.3

