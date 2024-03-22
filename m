Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4661A59167
	for <netfilter-devel@vger.kernel.org>; Fri, 22 Mar 2024 16:06:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711123613; cv=none; b=Tlp+tlDjO98UbyRlAoHjL2XmQ8QA3qiamTFbp0vpIrcShpamZXaxiHNGIyzbSvoj87dnYxMu6tG+wuuALvvvehzZVIr29nIfjzxAosiURZCo/Kd7Dv8lw16FgpWPqqOFTAAGuRzr1jDnaNQrBfubVN3WwlR2NtueABe6tvtNFVI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711123613; c=relaxed/simple;
	bh=hDT6ciZs+3/UjlXjKu2PWiasOX5s5G5S9q0xHls25L8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kSry64HPaBV7b9H09fdsTFdzRH0V6G7s1wmqIU4z5YHLQPpz2BT9Df6F18VDbHIOBPm0dtF8cujEM3dQq5g2g90RCD7y4AzN6iqXJQS1FtPMGrxpNersM+iEzBV02cb19B3GH5Qyd1bOUQA4MVJiwiDTT9QQz5VINTnAstkKYbY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=RMjJVdt4; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="RMjJVdt4"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=JxIxSOKYGQrfI5KUySviGcD93TfufctUAFtjPcEEa0w=; b=RMjJVdt4cYW8V1GkWgvcebEE1H
	CBitUURn3PznNJAMgaG1Vd9Zky0Hvt6yNIJZ1ppaeX9kp40qRVBE3291lLeV9gJFdR/UyoBEJ6nMH
	wmkEQrZb+XfFHa6N8OJBB4VYEQeBTOO3B26iM+EL/DE1mSluLDBcQv7jVvgwatf06K9krCKOyeTSB
	gCQsAnKT14N9HoRrREEDvHX4ZOyHqsWkGeJZoPaVd3VAmxUdxumZo75rqGS3juBeEF2F4P7kARg9M
	jjzjeQ5trA+7tPvfmkC3gaeAXf76qJweKUyTi/9xfcYrmfXVRQSUBX2ytCtw+UXhI1TyDsxnW3pWu
	gg6tsV0w==;
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1rnhPt-000000000yO-3L6A;
	Fri, 22 Mar 2024 17:06:49 +0100
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: [nft PATCH v2 5/5] tests: py: Drop needless recorded JSON outputs
Date: Fri, 22 Mar 2024 17:06:45 +0100
Message-ID: <20240322160645.18331-6-phil@nwl.cc>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240322160645.18331-1-phil@nwl.cc>
References: <20240322160645.18331-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

These match the input already, no need to track them.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 tests/py/any/last.t.json.output   |   7 -
 tests/py/any/meta.t.json.output   | 180 --------------------
 tests/py/inet/tcp.t.json.output   | 265 ------------------------------
 tests/py/ip/numgen.t.json.output  |  30 ----
 tests/py/ip6/exthdr.t.json.output |  30 ----
 5 files changed, 512 deletions(-)

diff --git a/tests/py/any/last.t.json.output b/tests/py/any/last.t.json.output
index b8a977edfca7f..e8ec4f478a428 100644
--- a/tests/py/any/last.t.json.output
+++ b/tests/py/any/last.t.json.output
@@ -1,10 +1,3 @@
-# last
-[
-    {
-        "last": null
-    }
-]
-
 # last used 300s
 [
     {
diff --git a/tests/py/any/meta.t.json.output b/tests/py/any/meta.t.json.output
index 4e9e669fdbc3b..d46935dee513d 100644
--- a/tests/py/any/meta.t.json.output
+++ b/tests/py/any/meta.t.json.output
@@ -592,24 +592,6 @@
     }
 ]
 
-# meta time "1970-05-23 21:07:14" drop
-[
-    {
-        "match": {
-            "left": {
-                "meta": {
-                    "key": "time"
-                }
-            },
-            "op": "==",
-            "right": "1970-05-23 21:07:14"
-        }
-    },
-    {
-        "drop": null
-    }
-]
-
 # meta time 12341234 drop
 [
     {
@@ -628,96 +610,6 @@
     }
 ]
 
-# meta time "2019-06-21 17:00:00" drop
-[
-    {
-        "match": {
-            "left": {
-                "meta": {
-                    "key": "time"
-                }
-            },
-            "op": "==",
-            "right": "2019-06-21 17:00:00"
-        }
-    },
-    {
-        "drop": null
-    }
-]
-
-# meta time "2019-07-01 00:00:00" drop
-[
-    {
-        "match": {
-            "left": {
-                "meta": {
-                    "key": "time"
-                }
-            },
-            "op": "==",
-            "right": "2019-07-01 00:00:00"
-        }
-    },
-    {
-        "drop": null
-    }
-]
-
-# meta time "2019-07-01 00:01:00" drop
-[
-    {
-        "match": {
-            "left": {
-                "meta": {
-                    "key": "time"
-                }
-            },
-            "op": "==",
-            "right": "2019-07-01 00:01:00"
-        }
-    },
-    {
-        "drop": null
-    }
-]
-
-# meta time "2019-07-01 00:00:01" drop
-[
-    {
-        "match": {
-            "left": {
-                "meta": {
-                    "key": "time"
-                }
-            },
-            "op": "==",
-            "right": "2019-07-01 00:00:01"
-        }
-    },
-    {
-        "drop": null
-    }
-]
-
-# meta day "Saturday" drop
-[
-    {
-        "match": {
-            "left": {
-                "meta": {
-                    "key": "day"
-                }
-            },
-            "op": "==",
-            "right": "Saturday"
-        }
-    },
-    {
-        "drop": null
-    }
-]
-
 # meta day 6 drop
 [
     {
@@ -736,24 +628,6 @@
     }
 ]
 
-# meta hour "17:00" drop
-[
-    {
-        "match": {
-            "left": {
-                "meta": {
-                    "key": "hour"
-                }
-            },
-            "op": "==",
-            "right": "17:00"
-        }
-    },
-    {
-        "drop": null
-    }
-]
-
 # meta hour "17:00:00" drop
 [
     {
@@ -772,57 +646,3 @@
     }
 ]
 
-# meta hour "17:00:01" drop
-[
-    {
-        "match": {
-            "left": {
-                "meta": {
-                    "key": "hour"
-                }
-            },
-            "op": "==",
-            "right": "17:00:01"
-        }
-    },
-    {
-        "drop": null
-    }
-]
-
-# meta hour "00:00" drop
-[
-    {
-        "match": {
-            "left": {
-                "meta": {
-                    "key": "hour"
-                }
-            },
-            "op": "==",
-            "right": "00:00"
-        }
-    },
-    {
-        "drop": null
-    }
-]
-
-# meta hour "00:01" drop
-[
-    {
-        "match": {
-            "left": {
-                "meta": {
-                    "key": "hour"
-                }
-            },
-            "op": "==",
-            "right": "00:01"
-        }
-    },
-    {
-        "drop": null
-    }
-]
-
diff --git a/tests/py/inet/tcp.t.json.output b/tests/py/inet/tcp.t.json.output
index 3f03c0ddd1586..d487a8f1bfa09 100644
--- a/tests/py/inet/tcp.t.json.output
+++ b/tests/py/inet/tcp.t.json.output
@@ -115,32 +115,6 @@
     }
 ]
 
-# tcp flags { syn, syn | ack }
-[
-    {
-        "match": {
-            "left": {
-                "payload": {
-                    "field": "flags",
-                    "protocol": "tcp"
-                }
-            },
-            "op": "==",
-            "right": {
-                "set": [
-                    "syn",
-                    {
-                        "|": [
-                            "syn",
-                            "ack"
-                        ]
-                    }
-                ]
-            }
-        }
-    }
-]
-
 # tcp flags & (fin | syn | rst | psh | ack | urg) == { fin, ack, psh | ack, fin | psh | ack }
 [
     {
@@ -188,242 +162,3 @@
         }
     }
 ]
-
-# tcp flags fin,syn / fin,syn
-[
-    {
-        "match": {
-            "left": {
-                "&": [
-                    {
-                        "payload": {
-                            "field": "flags",
-                            "protocol": "tcp"
-                        }
-                    },
-                    {
-                        "|": [
-                            "fin",
-                            "syn"
-                        ]
-                    }
-                ]
-            },
-            "op": "==",
-            "right": {
-                "|": [
-                    "fin",
-                    "syn"
-                ]
-            }
-        }
-    }
-]
-
-# tcp flags != syn / fin,syn
-[
-    {
-        "match": {
-            "left": {
-                "&": [
-                    {
-                        "payload": {
-                            "field": "flags",
-                            "protocol": "tcp"
-                        }
-                    },
-                    {
-                        "|": [
-                            "fin",
-                            "syn"
-                        ]
-                    }
-                ]
-            },
-            "op": "!=",
-            "right": "syn"
-        }
-    }
-]
-
-# tcp flags & (fin | syn | rst | ack) syn
-[
-    {
-        "match": {
-            "left": {
-                "&": [
-                    {
-                        "payload": {
-                            "field": "flags",
-                            "protocol": "tcp"
-                        }
-                    },
-                    {
-                        "|": [
-                            "fin",
-                            "syn",
-                            "rst",
-                            "ack"
-                        ]
-                    }
-                ]
-            },
-            "op": "==",
-            "right": "syn"
-        }
-    }
-]
-
-# tcp flags & (fin | syn | rst | ack) == syn
-[
-    {
-        "match": {
-            "left": {
-                "&": [
-                    {
-                        "payload": {
-                            "field": "flags",
-                            "protocol": "tcp"
-                        }
-                    },
-                    {
-                        "|": [
-                            "fin",
-                            "syn",
-                            "rst",
-                            "ack"
-                        ]
-                    }
-                ]
-            },
-            "op": "==",
-            "right": "syn"
-        }
-    }
-]
-
-# tcp flags & (fin | syn | rst | ack) != syn
-[
-    {
-        "match": {
-            "left": {
-                "&": [
-                    {
-                        "payload": {
-                            "field": "flags",
-                            "protocol": "tcp"
-                        }
-                    },
-                    {
-                        "|": [
-                            "fin",
-                            "syn",
-                            "rst",
-                            "ack"
-                        ]
-                    }
-                ]
-            },
-            "op": "!=",
-            "right": "syn"
-        }
-    }
-]
-
-# tcp flags & (fin | syn | rst | ack) == syn | ack
-[
-    {
-        "match": {
-            "left": {
-                "&": [
-                    {
-                        "payload": {
-                            "field": "flags",
-                            "protocol": "tcp"
-                        }
-                    },
-                    {
-                        "|": [
-                            "fin",
-                            "syn",
-                            "rst",
-                            "ack"
-                        ]
-                    }
-                ]
-            },
-            "op": "==",
-            "right": {
-                "|": [
-                    "syn",
-                    "ack"
-                ]
-            }
-        }
-    }
-]
-
-# tcp flags & (fin | syn | rst | ack) != syn | ack
-[
-    {
-        "match": {
-            "left": {
-                "&": [
-                    {
-                        "payload": {
-                            "field": "flags",
-                            "protocol": "tcp"
-                        }
-                    },
-                    {
-                        "|": [
-                            "fin",
-                            "syn",
-                            "rst",
-                            "ack"
-                        ]
-                    }
-                ]
-            },
-            "op": "!=",
-            "right": {
-                "|": [
-                    "syn",
-                    "ack"
-                ]
-            }
-        }
-    }
-]
-
-# tcp flags & (syn | ack) == syn | ack
-[
-    {
-        "match": {
-            "left": {
-                "&": [
-                    {
-                        "payload": {
-                            "field": "flags",
-                            "protocol": "tcp"
-                        }
-                    },
-                    {
-                        "|": [
-                            "syn",
-                            "ack"
-                        ]
-                    }
-                ]
-            },
-            "op": "==",
-            "right": {
-                "|": [
-                    "syn",
-                    "ack"
-                ]
-            }
-        }
-    }
-]
-
diff --git a/tests/py/ip/numgen.t.json.output b/tests/py/ip/numgen.t.json.output
index 06ad1eccae5cf..b54121ca0f721 100644
--- a/tests/py/ip/numgen.t.json.output
+++ b/tests/py/ip/numgen.t.json.output
@@ -80,33 +80,3 @@
     }
 ]
 
-# dnat to numgen inc mod 7 offset 167772161
-[
-    {
-        "dnat": {
-            "addr": {
-                "numgen": {
-                    "mod": 7,
-                    "mode": "inc",
-                    "offset": 167772161
-                }
-            }
-        }
-    }
-]
-
-# dnat to numgen inc mod 255 offset 167772161
-[
-    {
-        "dnat": {
-            "addr": {
-                "numgen": {
-                    "mod": 255,
-                    "mode": "inc",
-                    "offset": 167772161
-                }
-            }
-        }
-    }
-]
-
diff --git a/tests/py/ip6/exthdr.t.json.output b/tests/py/ip6/exthdr.t.json.output
index c9f5b49b915c8..813402a26c7f4 100644
--- a/tests/py/ip6/exthdr.t.json.output
+++ b/tests/py/ip6/exthdr.t.json.output
@@ -1,33 +1,3 @@
-# exthdr hbh == exists
-[
-    {
-        "match": {
-            "left": {
-                "exthdr": {
-                    "name": "hbh"
-                }
-            },
-	    "op": "==",
-            "right": true
-        }
-    }
-]
-
-# exthdr hbh == missing
-[
-    {
-        "match": {
-            "left": {
-                "exthdr": {
-                    "name": "hbh"
-                }
-            },
-	    "op": "==",
-            "right": false
-        }
-    }
-]
-
 # exthdr hbh 1
 [
     {
-- 
2.43.0

