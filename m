Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB60A17578
	for <netfilter-devel@vger.kernel.org>; Wed, 13 Aug 2025 17:06:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755104762; cv=none; b=Vi0vwOfFRb7JCg/8zTR24y88WpHC3qwmLKwwzOK4+5wMuf4FZrclYFsPU0m6QR3wHUd3iKFw2ngP9et9qHd4pRXml9gCDox75lfgm9BDhRqv3XdbTlQk8QRru2voQPKqVFTy5mUFiAwW62HemKu5bYg8/dNITR+k5XF9mSCt7wg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755104762; c=relaxed/simple;
	bh=2/tfCqYAgbhzM46Z1BEBu/GlzaTb754OSP8FvySqePQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Pph5QRPY4Y4mapar12e1pzXDb30p0SKm5X51SiTYzc88lhFKvO8qZ0UVqzWomSSpmLEErqHAUedX/Pyavd0wULO75x9MHmrgHH1NxFy02XRvQWB+9xXLCNV2/lkAw7ab33eFEL/qtcB14cEt44+dBVSx3BdIZ3ej7yfXhvoN+8A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=mMVDUuVZ; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="mMVDUuVZ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=au6ikA0gED0gySJ7Ne5K0yU5BvwQVAcYnMDFQbsInY4=; b=mMVDUuVZYe5HwD9TViU6gZDhAZ
	XX4U9kDoKZIUeHd8r/3qgpXz5I2SmDXOPYqoyL3UNkgRy/S078j0eqCMf5bVIvc+2IL7ATzL/CJeJ
	0sblvNxzr6v/cTm1iyKX9D8RdHiNQ1LbsuEls3iDm4w18F9f9ccDwA2q34FPaJIyND3osPT8s5Zhs
	pfqIvMyu5atLCdWyVR5HcIPt5z3OZf+PLvJz7ayFvuXnzFfmorV7oiEnvJKW8nU0qTBlODKzA3nxR
	8kRpvZptcoV5lh+21BjA+LFETFNTp333JewShz1qvrbzKGd+iTOw0Ser/C5mv4uqExlw2tnte8WGn
	NGePMCIQ==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1umEvG-000000003nz-48c1;
	Wed, 13 Aug 2025 19:05:59 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: [nft PATCH 11/14] tests: py: Drop stale entries from ip6/{ct,meta}.t.json
Date: Wed, 13 Aug 2025 19:05:46 +0200
Message-ID: <20250813170549.27880-12-phil@nwl.cc>
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

Looks like these were added by accident, fixed commit did not add these
test cases.

Fixes: 8221d86e616bd ("tests: py: add test-cases for ct and packet mark payload expressions")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 tests/py/ip6/ct.t.json   | 164 ---------------------------------------
 tests/py/ip6/meta.t.json |  58 --------------
 2 files changed, 222 deletions(-)

diff --git a/tests/py/ip6/ct.t.json b/tests/py/ip6/ct.t.json
index 2633c2b9433c0..6c1cf33e2dd69 100644
--- a/tests/py/ip6/ct.t.json
+++ b/tests/py/ip6/ct.t.json
@@ -1,167 +1,3 @@
-# ct mark set ip6 dscp lshift 2 or 0x10
-[
-    {
-        "mangle": {
-            "key": {
-                "ct": {
-                    "key": "mark"
-                }
-            },
-            "value": {
-                "|": [
-                    {
-                        "<<": [
-                            {
-                                "payload": {
-                                    "field": "dscp",
-                                    "protocol": "ip6"
-                                }
-                            },
-                            2
-                        ]
-                    },
-                    16
-                ]
-            }
-        }
-    }
-]
-
-# ct mark set ip6 dscp lshift 26 or 0x10
-[
-    {
-        "mangle": {
-            "key": {
-                "ct": {
-                    "key": "mark"
-                }
-            },
-            "value": {
-                "|": [
-                    {
-                        "<<": [
-                            {
-                                "payload": {
-                                    "field": "dscp",
-                                    "protocol": "ip6"
-                                }
-                            },
-                            26
-                        ]
-                    },
-                    16
-                ]
-            }
-        }
-    }
-]
-
-# ct mark set ip6 dscp << 2 | 0x10
-[
-    {
-        "mangle": {
-            "key": {
-                "ct": {
-                    "key": "mark"
-                }
-            },
-            "value": {
-                "|": [
-                    {
-                        "<<": [
-                            {
-                                "payload": {
-                                    "field": "dscp",
-                                    "protocol": "ip6"
-                                }
-                            },
-                            2
-                        ]
-                    },
-                    16
-                ]
-            }
-        }
-    }
-]
-
-# ct mark set ip6 dscp << 26 | 0x10
-[
-    {
-        "mangle": {
-            "key": {
-                "ct": {
-                    "key": "mark"
-                }
-            },
-            "value": {
-                "|": [
-                    {
-                        "<<": [
-                            {
-                                "payload": {
-                                    "field": "dscp",
-                                    "protocol": "ip6"
-                                }
-                            },
-                            26
-                        ]
-                    },
-                    16
-                ]
-            }
-        }
-    }
-]
-
-# ct mark set ip6 dscp | 0x04
-[
-    {
-        "mangle": {
-            "key": {
-                "ct": {
-                    "key": "mark"
-                }
-            },
-            "value": {
-                "|": [
-                    {
-                        "payload": {
-                            "field": "dscp",
-                            "protocol": "ip6"
-                        }
-                    },
-                    4
-                ]
-            }
-        }
-    }
-]
-
-# ct mark set ip6 dscp | 0xff000000
-[
-    {
-        "mangle": {
-            "key": {
-                "ct": {
-                    "key": "mark"
-                }
-            },
-            "value": {
-                "|": [
-                    {
-                        "payload": {
-                            "field": "dscp",
-                            "protocol": "ip6"
-                        }
-                    },
-                    4278190080
-                ]
-            }
-        }
-    }
-]
-
 # ct mark set ip6 dscp << 2 | 0x10
 [
     {
diff --git a/tests/py/ip6/meta.t.json b/tests/py/ip6/meta.t.json
index 1a2394d84ecda..87251f0a61a9d 100644
--- a/tests/py/ip6/meta.t.json
+++ b/tests/py/ip6/meta.t.json
@@ -195,64 +195,6 @@
     }
 ]
 
-# meta mark set ip6 dscp lshift 2 or 0x10
-[
-    {
-        "mangle": {
-            "key": {
-                "meta": {
-                    "key": "mark"
-                }
-            },
-            "value": {
-                "|": [
-                    {
-                        "<<": [
-                            {
-                                "payload": {
-                                    "field": "dscp",
-                                    "protocol": "ip6"
-                                }
-                            },
-                            2
-                        ]
-                    },
-                    16
-                ]
-            }
-        }
-    }
-]
-
-# meta mark set ip6 dscp lshift 26 or 0x10
-[
-    {
-        "mangle": {
-            "key": {
-                "meta": {
-                    "key": "mark"
-                }
-            },
-            "value": {
-                "|": [
-                    {
-                        "<<": [
-                            {
-                                "payload": {
-                                    "field": "dscp",
-                                    "protocol": "ip6"
-                                }
-                            },
-                            26
-                        ]
-                    },
-                    16
-                ]
-            }
-        }
-    }
-]
-
 # meta mark set ip6 dscp << 2 | 0x10
 [
     {
-- 
2.49.0

