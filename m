Return-Path: <SRS0=sMKv=DS=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF133C43457
	for <netfilter-devel@archiver.kernel.org>; Sun, 11 Oct 2020 19:23:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 683BC21655
	for <netfilter-devel@archiver.kernel.org>; Sun, 11 Oct 2020 19:23:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="myfcUNtw"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728793AbgJKTXr (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 11 Oct 2020 15:23:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726333AbgJKTXq (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 11 Oct 2020 15:23:46 -0400
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C0B6C0613D2
        for <netfilter-devel@vger.kernel.org>; Sun, 11 Oct 2020 12:23:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
         s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=fvkpm/nVD8qQCU5sfvfMMmraFi5tKzNNtDW55oY+3X0=; b=myfcUNtwqF9DdZP8vq5QhDbJqE
        YNeSf3rBRTQcucL6urxReUwNcx64CitG2nXvPqDh7/cdnrgyb9D/6z6kO5Gz2+8AVHBZ4RcM7KdNq
        xNuwIpvWaHMfgOvvIynszFhaMkwXEd/OGdPcZm2Bngspkux7CdAP5T4SCaYBhgh3OxaLYih2pDQBH
        b5k9Nw6cXidArNlaKIqTcEOfPU/u/r7gjd7e3UfcCezcLQCASNHWJGvgyZoRWRLy6clZLqWYQewIa
        EtH6UK3jJVpaNcV0qDsK+Ii5DMmGKhRdAOjApCEqH+CgMAmheZor9H3l9pbSVHOD3Tni1sXQJO5B5
        Nejamdcw==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtp (Exim 4.92)
        (envelope-from <jeremy@azazel.net>)
        id 1kRgwX-00016N-WD; Sun, 11 Oct 2020 20:23:42 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH nft 3/3] tests: py: add missing test JSON output for TCP flag tests.
Date:   Sun, 11 Oct 2020 20:23:24 +0100
Message-Id: <20201011192324.209237-4-jeremy@azazel.net>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201011192324.209237-1-jeremy@azazel.net>
References: <20201011192324.209237-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Fixes: 3926a3369bb5 ("mergesort: unbreak listing with binops")
Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 tests/py/inet/tcp.t.json        | 93 +++++++++++++++++++++++++++++++++
 tests/py/inet/tcp.t.json.output | 93 +++++++++++++++++++++++++++++++++
 2 files changed, 186 insertions(+)

diff --git a/tests/py/inet/tcp.t.json b/tests/py/inet/tcp.t.json
index babe59208925..702251828360 100644
--- a/tests/py/inet/tcp.t.json
+++ b/tests/py/inet/tcp.t.json
@@ -1637,3 +1637,96 @@
     }
 ]
 
+# tcp flags { syn, syn | ack }
+[
+    {
+        "match": {
+            "left": {
+                "payload": {
+                    "field": "flags",
+                    "protocol": "tcp"
+                }
+            },
+            "op": "==",
+            "right": {
+                "set": [
+                    {
+                        "|": [
+                            "syn",
+                            "ack"
+                        ]
+                    },
+                    "syn"
+                ]
+            }
+        }
+    }
+]
+
+# tcp flags & (fin | syn | rst | psh | ack | urg) == { fin, ack, psh | ack, fin | psh | ack }
+[
+    {
+        "match": {
+            "left": {
+                "&": [
+                    {
+                        "payload": {
+                            "field": "flags",
+                            "protocol": "tcp"
+                        }
+                    },
+                    {
+                        "|": [
+                            {
+                                "|": [
+                                    {
+                                        "|": [
+                                            {
+                                                "|": [
+                                                    {
+                                                        "|": [
+                                                            "fin",
+                                                            "syn"
+                                                        ]
+                                                    },
+                                                    "rst"
+                                                ]
+                                            },
+                                            "psh"
+                                        ]
+                                    },
+                                    "ack"
+                                ]
+                            },
+                            "urg"
+                        ]
+                    }
+                ]
+            },
+            "op": "==",
+            "right": {
+                "set": [
+                    {
+                        "|": [
+                            {
+                                "|": [
+                                    "fin",
+                                    "psh"
+                                ]
+                            },
+                            "ack"
+                        ]
+                    },
+                    "fin",
+                    {
+                        "|": [
+                            "psh",
+                            "ack"
+                        ]
+                    },
+                    "ack"
+                ]
+            }
+        }
+    }
+]
diff --git a/tests/py/inet/tcp.t.json.output b/tests/py/inet/tcp.t.json.output
index 0f7a593b788c..c471e8d8dcef 100644
--- a/tests/py/inet/tcp.t.json.output
+++ b/tests/py/inet/tcp.t.json.output
@@ -115,3 +115,96 @@
     }
 ]
 
+# tcp flags { syn, syn | ack }
+[
+    {
+        "match": {
+            "left": {
+                "payload": {
+                    "field": "flags",
+                    "protocol": "tcp"
+                }
+            },
+            "op": "==",
+            "right": {
+                "set": [
+                    "syn",
+                    {
+                        "|": [
+                            "syn",
+                            "ack"
+                        ]
+                    }
+                ]
+            }
+        }
+    }
+]
+
+# tcp flags & (fin | syn | rst | psh | ack | urg) == { fin, ack, psh | ack, fin | psh | ack }
+[
+    {
+        "match": {
+            "left": {
+                "&": [
+                    {
+                        "payload": {
+                            "field": "flags",
+                            "protocol": "tcp"
+                        }
+                    },
+                    {
+                        "|": [
+                            {
+                                "|": [
+                                    {
+                                        "|": [
+                                            {
+                                                "|": [
+                                                    {
+                                                        "|": [
+                                                            "fin",
+                                                            "syn"
+                                                        ]
+                                                    },
+                                                    "rst"
+                                                ]
+                                            },
+                                            "psh"
+                                        ]
+                                    },
+                                    "ack"
+                                ]
+                            },
+                            "urg"
+                        ]
+                    }
+                ]
+            },
+            "op": "==",
+            "right": {
+                "set": [
+                    "fin",
+                    {
+                        "|": [
+                            {
+                                "|": [
+                                    "fin",
+                                    "psh"
+                                ]
+                            },
+                            "ack"
+                        ]
+                    },
+                    {
+                        "|": [
+                            "psh",
+                            "ack"
+                        ]
+                    },
+                    "ack"
+                ]
+            }
+        }
+    }
+]
-- 
2.28.0

