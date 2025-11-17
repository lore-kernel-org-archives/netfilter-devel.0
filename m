Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 539832FC893
	for <netfilter-devel@vger.kernel.org>; Mon, 17 Nov 2025 21:55:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763416552; cv=none; b=aQw++B2vQ7w+M5QGHs8Gpg82ljZajoD4RpJHjZ8pDb22nB7EY8v1LLiG2lTgsJhaEuD7afRwvcgLdsoG5AeZICcwZ9u/dYROfhUef+p+vrKOLnAa4VVCJWAD+uj62t2dqqHDFSwiluYZtjr9wo7eBDxDqEJL/DlH070y+DO1TQc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763416552; c=relaxed/simple;
	bh=6FufSCqnF0Sq7bvV8jjUoQJ1JPAegODQ9BBgMvrpz4o=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=XZHPUGx6/YmPs1RODzqoCYRSPuJurlfK+rPZ7PW+E5z//M6lmRYm5GtSB+EkwVvSY6uAJahbFfM6NmAHnmRMnKDf53E92Dj/yxzwIwIl5Rg5RXFkk/dT5TsgWHKpah9fdmnUJ4BmwqUJMqwT5h2kGIcf8XndjBASdB9kj/2kFeQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=dfDSu8xi; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="dfDSu8xi"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 83A5C60283
	for <netfilter-devel@vger.kernel.org>; Mon, 17 Nov 2025 22:55:49 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1763416549;
	bh=H5MXtUejK8EVCV5DBGSd/g7kUURm/k1aeTU8hqMmC48=;
	h=From:To:Subject:Date:From;
	b=dfDSu8xi/VUHj85dba7DLUb9rX54jFV6fxHs8HWtSBR/3Bll86o6mRf+uac2Ruf6U
	 53Wiz+UT6U3BeAFr8HHMPn7ujD7lX+MUx3Hd7rZdNkb9Sp5btx8Y+3mqW9eLzKUZ1k
	 Ie3OEf781V6/ICJ18Bf1+zoovBkK2qxI0XMai7GgSwkeOA5xGbJWtAbA+U8n3IM4mH
	 JMpsJNVZOWowk2Qf3dDOQS2Orfwpb/HMw2BMjEnSuKkEe+U07DYMLTSWsLWeIhlFPK
	 gGfVlXuR5vQeRxe4CBp1/OulSGLh5nJUTzVj2LSH3GnKYUkdBQSKHXPhBwBVHMpiUL
	 DKj/+utY6CmhA==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nft 1/2] tests: shell: add device to sets/0075tunnel_0 to support older kernels
Date: Mon, 17 Nov 2025 21:55:44 +0000
Message-ID: <20251117215545.859808-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Older kernels do not support netdev basechain without device, add it so
this works.

Alternative is to skip it by adding:

 # NFT_TEST_REQUIRES(NFT_TEST_HAVE_netdev_chain_without_device)

but it seems easier to support it.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 tests/shell/testcases/sets/0075tunnel_0                | 2 +-
 tests/shell/testcases/sets/dumps/0075tunnel_0.json-nft | 1 +
 tests/shell/testcases/sets/dumps/0075tunnel_0.nft      | 2 +-
 3 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/tests/shell/testcases/sets/0075tunnel_0 b/tests/shell/testcases/sets/0075tunnel_0
index f8a8cf00530a..127a4ae91829 100755
--- a/tests/shell/testcases/sets/0075tunnel_0
+++ b/tests/shell/testcases/sets/0075tunnel_0
@@ -65,7 +65,7 @@ table netdev x {
 	}
 
 	chain x {
-		type filter hook ingress priority 0; policy accept;
+		type filter hook ingress device lo priority 0; policy accept;
 		tunnel name ip saddr map { 10.141.10.123 : "geneve-t", 10.141.10.124 : "vxlan-t", 10.141.10.125 : "erspan-tv1", 10.141.10.126 : "erspan-tv2" } counter
 	}
 }
diff --git a/tests/shell/testcases/sets/dumps/0075tunnel_0.json-nft b/tests/shell/testcases/sets/dumps/0075tunnel_0.json-nft
index 7cd582683955..9c3e9ca0a331 100644
--- a/tests/shell/testcases/sets/dumps/0075tunnel_0.json-nft
+++ b/tests/shell/testcases/sets/dumps/0075tunnel_0.json-nft
@@ -20,6 +20,7 @@
         "table": "x",
         "name": "x",
         "handle": 0,
+        "dev": "lo",
         "type": "filter",
         "hook": "ingress",
         "prio": 0,
diff --git a/tests/shell/testcases/sets/dumps/0075tunnel_0.nft b/tests/shell/testcases/sets/dumps/0075tunnel_0.nft
index 9969124d1a58..d167323f41c7 100644
--- a/tests/shell/testcases/sets/dumps/0075tunnel_0.nft
+++ b/tests/shell/testcases/sets/dumps/0075tunnel_0.nft
@@ -57,7 +57,7 @@ table netdev x {
 	}
 
 	chain x {
-		type filter hook ingress priority filter; policy accept;
+		type filter hook ingress device "lo" priority filter; policy accept;
 		tunnel name ip saddr map { 10.141.10.123 : "geneve-t", 10.141.10.124 : "vxlan-t", 10.141.10.125 : "erspan-tv1", 10.141.10.126 : "erspan-tv2" } counter packets 0 bytes 0
 	}
 }
-- 
2.47.3

