Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD2C1231832
	for <netfilter-devel@vger.kernel.org>; Thu, 23 Oct 2025 16:15:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761236104; cv=none; b=bdu/iAiF3CznsNivVMvRJBagj095VYF6+Nk/ODNLzUDXg6/Y9PLBw6H1PzXacvgMEo5+AI5mX49cYc40wJgXkjvVM+QSX7YYE42wNGYi5opwDZBtrk01QVN8wq8OHTZwtDHmVoGe/FS5oWWVS5G8rZdEJlUpKHOfuzpi136u0Yg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761236104; c=relaxed/simple;
	bh=0e5aV9gTDEeNJo+qBdmt52YPh1MUkqwC1FWBnzRZDnY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iJy0rFN7XahmmfSYXdqxLO4LUVfMpYfg5iLG0mnRQNBf5JJDXZ6HecPmblFqzy8YQdn50WyuUprB+I4cCTbCb5ENjyIHCuVGPkYBgBsVfVMIuKSI2zH65toUdGOje4ybTJtOP3mzj/zJlR8gQNimBbcfJYYqRAJxaGt23JQqrz0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=Rx3rbNnJ; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="Rx3rbNnJ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=e9hbTIBz2ZuqIPfpsVQuudqon0jaKCAT6xdiJjev+AE=; b=Rx3rbNnJ87pfihk3bNlEa92A1y
	J7pw3FnYFgOXpj0AsOvCeRHBlH1EyH7w2cVn791EC62ARso4TwzeSnLJ5VT9a9Aqn3UwD2JHXwoaP
	i/8NGCSTVNn+W4EXj/eR4zxZ2p72CqFD6ZFeV7yyTfhX1w1QcgTXTPg0jXxJJEWFS37WOzxXrgZh4
	0NEAjZxREnezWlrb8gdneF4wW3d18vXFA/L8klkuEOesiHU1dtmrE//xkr6igCTHZ0XJMFVW5VDdN
	6/rJ9Mb0c29Peyt+zszUBvCCOPH5k6qZ+00oilZf+iyCnoWQYHt/Z8HNlG3BODp1uChCC/FpTfO7f
	/Fw71Shw==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1vBxxs-00000000095-47f7;
	Thu, 23 Oct 2025 18:15:01 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: [nft PATCH 03/28] tests: py: any/tcpopt.t.json: Fix JSON equivalent
Date: Thu, 23 Oct 2025 18:13:52 +0200
Message-ID: <20251023161417.13228-4-phil@nwl.cc>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251023161417.13228-1-phil@nwl.cc>
References: <20251023161417.13228-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Set element ordering differed from the rule in standard syntax.

Fixes: d199cca92f9eb ("expression: expr_build_udata_recurse should recurse")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 tests/py/any/tcpopt.t.json        | 24 +++++-----
 tests/py/any/tcpopt.t.json.output | 76 +++++++++++++++++++++++++++++++
 2 files changed, 88 insertions(+), 12 deletions(-)

diff --git a/tests/py/any/tcpopt.t.json b/tests/py/any/tcpopt.t.json
index e712a5e0ed56f..65fa1de50eea0 100644
--- a/tests/py/any/tcpopt.t.json
+++ b/tests/py/any/tcpopt.t.json
@@ -622,20 +622,20 @@
                     },
                     {
                         "concat": [
-                            "remove-addr",
-                            300
+                            "mp-join",
+                            100
                         ]
                     },
                     {
                         "concat": [
-                            "mp-fastclose",
-                            600
+                            "add-addr",
+                            200
                         ]
                     },
                     {
                         "concat": [
-                            "mp-join",
-                            100
+                            "remove-addr",
+                            300
                         ]
                     },
                     {
@@ -646,20 +646,20 @@
                     },
                     {
                         "concat": [
-                            "mp-tcprst",
-                            700
+                            "mp-fail",
+                            500
                         ]
                     },
                     {
                         "concat": [
-                            "add-addr",
-                            200
+                            "mp-fastclose",
+                            600
                         ]
                     },
                     {
                         "concat": [
-                            "mp-fail",
-                            500
+                            "mp-tcprst",
+                            700
                         ]
                     }
                 ]
diff --git a/tests/py/any/tcpopt.t.json.output b/tests/py/any/tcpopt.t.json.output
index ad0d25f4d56c6..ae979e7747762 100644
--- a/tests/py/any/tcpopt.t.json.output
+++ b/tests/py/any/tcpopt.t.json.output
@@ -30,3 +30,79 @@
     }
 ]
 
+# tcp option mptcp subtype . tcp dport { mp-capable . 10, mp-join . 100, add-addr . 200, remove-addr . 300, mp-prio . 400, mp-fail . 500, mp-fastclose . 600, mp-tcprst . 700 }
+[
+    {
+        "match": {
+            "left": {
+                "concat": [
+                    {
+                        "tcp option": {
+                            "field": "subtype",
+                            "name": "mptcp"
+                        }
+                    },
+                    {
+                        "payload": {
+                            "field": "dport",
+                            "protocol": "tcp"
+                        }
+                    }
+                ]
+            },
+            "op": "==",
+            "right": {
+                "set": [
+                    {
+                        "concat": [
+                            "mp-capable",
+                            10
+                        ]
+                    },
+                    {
+                        "concat": [
+                            "remove-addr",
+                            300
+                        ]
+                    },
+                    {
+                        "concat": [
+                            "mp-fastclose",
+                            600
+                        ]
+                    },
+                    {
+                        "concat": [
+                            "mp-join",
+                            100
+                        ]
+                    },
+                    {
+                        "concat": [
+                            "mp-prio",
+                            400
+                        ]
+                    },
+                    {
+                        "concat": [
+                            "mp-tcprst",
+                            700
+                        ]
+                    },
+                    {
+                        "concat": [
+                            "add-addr",
+                            200
+                        ]
+                    },
+                    {
+                        "concat": [
+                            "mp-fail",
+                            500
+                        ]
+                    }
+                ]
+            }
+        }
+    }
+]
-- 
2.51.0

