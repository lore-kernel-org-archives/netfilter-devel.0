Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED2AD17578
	for <netfilter-devel@vger.kernel.org>; Wed, 13 Aug 2025 17:05:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755104760; cv=none; b=h1x9TlPnnanPE9Egxwx5RH6xgchk150MPxv5kO5CRbaAKndI4IRPKzNGkxHYrocpp+/wswwYSJbh/ioqQ7nakfQ08RhJVt2H+TW/L/TA4g3/+46u/VU2l66oJrE7ne3Pf7NYqBu0tRahFjQ4eETKocuILFpnlCmglBLl8/kjjQY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755104760; c=relaxed/simple;
	bh=MF3Bpeder4imiE0/Zx17uvgLmqnayu0+Jhu3/aNIhpo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=une1PcyUw+9JDmX+AjlVfkhpJlaIf8IXcMWdUT8p15eYjjYKf5EEiy6Xh19ADbVSkQNtmqzqQspMgYakk8aoQGdYq5pciI1gzVDH4dRf3ZtY1UWK0PZy3itiwcEZzBfZlX5DG089M08zZCoWB3lzoVf17wnjwEwKlR02Pz/pgrE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=CwPgZHpV; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="CwPgZHpV"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=619wgiTbrTR+O4qNqws/ml/yghQAmHh+fGw4UMF4JIQ=; b=CwPgZHpVGBcXZ2RvmKwNyNIH5F
	5oCoN1kjZPhEcyn1xnrLQLsgRwYX6vr9bTk2409XIP6RhXJmCIy1DfU1/znhxoqfZAWpXPVZ7UgYI
	7qhpQywPueADJrX484OBG6OxWgG1SO13rLdITtJZ07qM2kj53YxtKtMBH53P3vsfEZqfK0NGFHnYm
	yjuY/25OCrZGCSfZ6yKVee9pJXw4PV83YRNbfCY9jESgU0PUjHazMrsoqVpIpV1EMMip5mFd3jrxH
	Vq/iN6utaTGWcU4yHNARnvZTJ7I3gfVUSfpIxjbwoaTI1MJ7Csuy8E1NPZRx6XucKq/UoFXNlH0rb
	sKf+RRog==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1umEvD-000000003nU-4Aob;
	Wed, 13 Aug 2025 19:05:56 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: [nft PATCH 05/14] tests: py: Drop duplicate test from inet/gre.t
Date: Wed, 13 Aug 2025 19:05:40 +0200
Message-ID: <20250813170549.27880-6-phil@nwl.cc>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250813170549.27880-1-phil@nwl.cc>
References: <20250813170549.27880-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The test was duplicate since day 1. The duplicate JSON equivalent was
added later (semi-automated), remove it as well.

Fixes: c04ef8d104ec6 ("tests: py: add gre tests")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 tests/py/inet/gre.t      |  1 -
 tests/py/inet/gre.t.json | 17 -----------------
 2 files changed, 18 deletions(-)

diff --git a/tests/py/inet/gre.t b/tests/py/inet/gre.t
index a3e046a1aea5c..a21e67eab2fd1 100644
--- a/tests/py/inet/gre.t
+++ b/tests/py/inet/gre.t
@@ -16,7 +16,6 @@ gre icmp type echo-reply;ok
 gre ether saddr 62:87:4d:d6:19:05;fail
 gre vlan id 10;fail
 gre ip dscp 0x02;ok
-gre ip dscp 0x02;ok
 gre ip saddr . gre ip daddr { 1.2.3.4 . 4.3.2.1 };ok
 
 gre ip saddr set 1.2.3.4;fail
diff --git a/tests/py/inet/gre.t.json b/tests/py/inet/gre.t.json
index c4431764849f7..a354e6bd4d17c 100644
--- a/tests/py/inet/gre.t.json
+++ b/tests/py/inet/gre.t.json
@@ -121,23 +121,6 @@
     }
 ]
 
-# gre ip dscp 0x02
-[
-    {
-        "match": {
-            "left": {
-                "payload": {
-                    "field": "dscp",
-                    "protocol": "ip",
-                    "tunnel": "gre"
-                }
-            },
-            "op": "==",
-            "right": 2
-        }
-    }
-]
-
 # gre ip saddr . gre ip daddr { 1.2.3.4 . 4.3.2.1 }
 [
     {
-- 
2.49.0

