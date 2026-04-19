Received: from fhigh-a6-smtp.messagingengine.com (fhigh-a6-smtp.messagingengine.com [103.168.172.157])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F8EF40DFC6
	for <netfilter-devel@vger.kernel.org>; Sun, 19 Apr 2026 15:57:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.157
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776614276; cv=none; b=oCqpIAAIei3Qab1yawgmkbq6Xcmm/gHm4I8nuEkZVrI9j4VEcbR8wpBLTaIc3TpfDPXVJc9H0m+1IxzB970SFmehDTh2AbtGUE9nKBZa2ueyJ5J0eTy4y2e8JrRPQiliT64bsB1CH7gzXGyDguHcbPnfqJoPnf245leOCyezmto=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776614276; c=relaxed/simple;
	bh=Ubb3KTyQooudbu1epEsMEo2qVzAae/4EhZO577wV9wU=;
	h=MIME-Version:Date:From:To:Message-Id:Subject:Content-Type; b=XNYJg1JYFhWH8snpcz3CFs3naQPzuEiJOANbtliGKPKEXQvuAVO1km4N/lEIZNLbtHgv4swJy0e7kAdGGl4BhGHJDICKPRnOAsVCUYm9CXaN1A6RpZofKO1j+M8btZmq7Q+mx24KFiF/OC2Y0tJ37yb01CFWsZCx4pcKf8EQndI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=backscattering.de; spf=pass smtp.mailfrom=backscattering.de; dkim=pass (2048-bit key) header.d=backscattering.de header.i=@backscattering.de header.b=AVH1b8B9; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=aEwFqN+K; arc=none smtp.client-ip=103.168.172.157
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=backscattering.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=backscattering.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=backscattering.de header.i=@backscattering.de header.b="AVH1b8B9";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="aEwFqN+K"
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailfhigh.phl.internal (Postfix) with ESMTP id 23997140007C
	for <netfilter-devel@vger.kernel.org>; Sun, 19 Apr 2026 11:57:51 -0400 (EDT)
Received: from phl-imap-17 ([10.202.2.105])
  by phl-compute-02.internal (MEProxy); Sun, 19 Apr 2026 11:57:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	backscattering.de; h=cc:content-transfer-encoding:content-type
	:content-type:date:date:from:from:in-reply-to:message-id
	:mime-version:reply-to:subject:subject:to:to; s=fm3; t=
	1776614271; x=1776700671; bh=UtVnYOYrzASVX/2V9mmdosmGwe3eh9s9kmS
	B1L4sm9Y=; b=AVH1b8B9RNx7L35cOEE2sQ/SvSmsva2DPps4S8WeVWkkfFnxsWK
	jB9lt51LU/lI4CX2aS6B3kZCiF2BA/mmh/DkoIt15Ks8yYcnUwEwHq0X+obc/7N2
	fy/KDDFWRmyvcXa/6U6UW2OMKZdwslxhoHBgXgyc+yHdKyead/7gz6JK/yxB/ECE
	tlIAi3Pr5nFZoLzFWJimZLphH0AlDs5XWncqeOAVIsAgjDyeJIV+fuOrfm9gsFAp
	9bv7uQLOmxbQI5/D07Fs+gdlmSYoNWSD9qjcnbhLwehy44bCWLOQDjn7/JDnM6ap
	IUz7ELB+vydNTR0213++rPsICGImteib2RQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:content-transfer-encoding:content-type
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:message-id:mime-version:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=
	1776614271; x=1776700671; bh=UtVnYOYrzASVX/2V9mmdosmGwe3eh9s9kmS
	B1L4sm9Y=; b=aEwFqN+KiKXq/ZOhRKTavJn/q3nOETteNFCB+fu0XnsOn843qHq
	TxCSn/vuW2Rl0bLXg81YWwMr7rhyx0dM3HRe0aFXzYbQwljucrJB33m9ZsTIG14Z
	5R33+RpKxIbsdqon9MaCajjs2H5oxe+JuNugNgIVIpgjbjFQI9guqv1Qyr7xJ4Va
	HH+StC+9YTRAS0pVF/WhLwP3bRHdi9MVDjwTUs312vC/P2392Y5513PkaOs/MdrJ
	RpArptyTS09yqk3BLPpVaC9TS3DCHs9wjxEiXQLPGHSGt3T8S2urCQHABuv3VP+h
	Ztal136rp04pjpODe35W4RLLFCHPVfH+dVA==
X-ME-Sender: <xms:fvvkaRqtDx2aAxn41_OoIO5atpOSj4HsJXXOgXi6aJuEM-yNmeR_vg>
    <xme:fvvkaefjuHB1AsfPGRklDCo58wjVEqKm-vjNQN-ZEkpAskH4SAAmodja7aIxKqN94
    EEsWkRsjfKwYnPaW0N9ThI8tv9hmJXv8AQuO6qJs0XT1BRGLwwZvRU>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefhedrtddtgdehiedtiecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecunecujfgurhepofggfffhvffkufgtgfesthejredtredttd
    enucfhrhhomhepfdfpihhklhgrshcuhfhivghkrghsfdcuoehnihhklhgrshdrfhhivghk
    rghssegsrggtkhhstggrthhtvghrihhnghdruggvqeenucggtffrrghtthgvrhhnpeette
    effedtjeetteegudehfeetgfdvfeevheegiedvgfelhfdthedvveeigeekheenucevlhhu
    shhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehnihhklhgrshdrfh
    hivghkrghssegsrggtkhhstggrthhtvghrihhnghdruggvpdhnsggprhgtphhtthhopedu
    pdhmohguvgepshhmthhpohhuthdprhgtphhtthhopehnvghtfhhilhhtvghrqdguvghvvg
    hlsehvghgvrhdrkhgvrhhnvghlrdhorhhg
X-ME-Proxy: <xmx:fvvkab4vsE4s-D0_ZnBs9wbivtq41GAUxv5RVUetLkK0JLXOVnSZKA>
    <xmx:fvvkaQ2JhvvpPD2Bn2eLxBR3tBPGTqFaLhR-ggLORHwXhtAsbuJTvA>
    <xmx:fvvkafX9ijb4h_ITmYst84e6dYDxy80npbsJ_GwTZ5RLJnKnD3NABw>
    <xmx:fvvkaT4s326wfVSYX09MtEktB_aJO8qmegJzkhlxgVn5o6GoSN2vpA>
    <xmx:f_vkaWMdwTsGYdLkOP4BmzqhavIFHzgH5VJkzgBlC_r-pYkxVRP5pUQi>
Feedback-ID: iabb64814:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id D7E23C40071; Sun, 19 Apr 2026 11:57:50 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Sun, 19 Apr 2026 17:57:30 +0200
From: "Niklas Fiekas" <niklas.fiekas@backscattering.de>
To: netfilter-devel@vger.kernel.org
Message-Id: <ad31ed84-1ce4-4ec9-b970-6d09f8d69152@app.fastmail.com>
Subject: [PATCH nft] json: output set/map element count
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Useful with --terse, when dumping all elements is too expensive.

Mirrors non-json dumps, which already include "... # count 12345".

Signed-off-by: Niklas Fiekas <niklas.fiekas@backscattering.de>
---
 doc/libnftables-json.adoc                                     | 4 ++++
 src/json.c                                                    | 4 ++++
 .../testcases/rule_management/dumps/0011reset_0.json-nft      | 1 +
 tests/shell/testcases/sets/dumps/0016element_leak_0.json-nft  | 1 +
 .../shell/testcases/sets/dumps/0017add_after_flush_0.json-nft | 1 +
 .../shell/testcases/sets/dumps/0018set_check_size_1.json-nft  | 1 +
 .../shell/testcases/sets/dumps/0019set_check_size_0.json-nft  | 1 +
 .../testcases/sets/dumps/0045concat_ipv4_service.json-nft     | 1 +
 .../testcases/sets/dumps/0057set_create_fails_0.json-nft      | 1 +
 tests/shell/testcases/sets/dumps/0060set_multistmt_1.json-nft | 1 +
 tests/shell/testcases/sets/dumps/interval_size.json-nft       | 2 ++
 11 files changed, 18 insertions(+)

diff --git a/doc/libnftables-json.adoc b/doc/libnftables-json.adoc
index 23a928df..697fdfa4 100644
--- a/doc/libnftables-json.adoc
+++ b/doc/libnftables-json.adoc
@@ -346,6 +346,7 @@ ____
 	"timeout":* 'NUMBER'*,
 	"gc-interval":* 'NUMBER'*,
 	"size":* 'NUMBER'*,
+	"count":* 'NUMBER'*,
 	"auto-merge":* 'BOOLEAN'
 *}}*
 
@@ -362,6 +363,7 @@ ____
 	"timeout":* 'NUMBER'*,
 	"gc-interval":* 'NUMBER'*,
 	"size":* 'NUMBER'*,
+	"count":* 'NUMBER'*,
 	"auto-merge":* 'BOOLEAN'
 *}}*
 
@@ -402,6 +404,8 @@ that they translate a unique key to a value.
 	Garbage collector interval in seconds.
 *size*::
 	Maximum number of elements supported.
+*count*::
+	Current number of elements. Not used in input.
 *auto-merge*::
 	Automatic merging of adjacent/overlapping set elements in interval sets.
 
diff --git a/src/json.c b/src/json.c
index 7312215d..dd1bdb04 100644
--- a/src/json.c
+++ b/src/json.c
@@ -203,6 +203,10 @@ static json_t *set_print_json(struct output_ctx *octx, const struct set *set)
 		if (set->desc.size) {
 			tmp = nft_json_pack("i", set->desc.size);
 			json_object_set_new(root, "size", tmp);
+			if (set->count) {
+				tmp = nft_json_pack("i", set->count);
+				json_object_set_new(root, "count", tmp);
+			}
 		}
 	}
 
diff --git a/tests/shell/testcases/rule_management/dumps/0011reset_0.json-nft b/tests/shell/testcases/rule_management/dumps/0011reset_0.json-nft
index bc242467..ebeec1d3 100644
--- a/tests/shell/testcases/rule_management/dumps/0011reset_0.json-nft
+++ b/tests/shell/testcases/rule_management/dumps/0011reset_0.json-nft
@@ -38,6 +38,7 @@
         "type": "ipv4_addr",
         "handle": 0,
         "size": 65535,
+        "count": 1,
         "flags": [
           "dynamic"
         ],
diff --git a/tests/shell/testcases/sets/dumps/0016element_leak_0.json-nft b/tests/shell/testcases/sets/dumps/0016element_leak_0.json-nft
index 96b9714a..bf09eada 100644
--- a/tests/shell/testcases/sets/dumps/0016element_leak_0.json-nft
+++ b/tests/shell/testcases/sets/dumps/0016element_leak_0.json-nft
@@ -22,6 +22,7 @@
         "type": "ipv4_addr",
         "handle": 0,
         "size": 2,
+        "count": 1,
         "elem": [
           "1.1.1.1"
         ]
diff --git a/tests/shell/testcases/sets/dumps/0017add_after_flush_0.json-nft b/tests/shell/testcases/sets/dumps/0017add_after_flush_0.json-nft
index 96b9714a..bf09eada 100644
--- a/tests/shell/testcases/sets/dumps/0017add_after_flush_0.json-nft
+++ b/tests/shell/testcases/sets/dumps/0017add_after_flush_0.json-nft
@@ -22,6 +22,7 @@
         "type": "ipv4_addr",
         "handle": 0,
         "size": 2,
+        "count": 1,
         "elem": [
           "1.1.1.1"
         ]
diff --git a/tests/shell/testcases/sets/dumps/0018set_check_size_1.json-nft b/tests/shell/testcases/sets/dumps/0018set_check_size_1.json-nft
index d226811c..e16c7b4b 100644
--- a/tests/shell/testcases/sets/dumps/0018set_check_size_1.json-nft
+++ b/tests/shell/testcases/sets/dumps/0018set_check_size_1.json-nft
@@ -22,6 +22,7 @@
         "type": "ipv4_addr",
         "handle": 0,
         "size": 2,
+        "count": 2,
         "elem": [
           "1.1.1.1",
           "1.1.1.2"
diff --git a/tests/shell/testcases/sets/dumps/0019set_check_size_0.json-nft b/tests/shell/testcases/sets/dumps/0019set_check_size_0.json-nft
index d226811c..e16c7b4b 100644
--- a/tests/shell/testcases/sets/dumps/0019set_check_size_0.json-nft
+++ b/tests/shell/testcases/sets/dumps/0019set_check_size_0.json-nft
@@ -22,6 +22,7 @@
         "type": "ipv4_addr",
         "handle": 0,
         "size": 2,
+        "count": 2,
         "elem": [
           "1.1.1.1",
           "1.1.1.2"
diff --git a/tests/shell/testcases/sets/dumps/0045concat_ipv4_service.json-nft b/tests/shell/testcases/sets/dumps/0045concat_ipv4_service.json-nft
index 8473c333..39343478 100644
--- a/tests/shell/testcases/sets/dumps/0045concat_ipv4_service.json-nft
+++ b/tests/shell/testcases/sets/dumps/0045concat_ipv4_service.json-nft
@@ -33,6 +33,7 @@
         ],
         "handle": 0,
         "size": 65536,
+        "count": 1,
         "flags": [
           "timeout",
           "dynamic"
diff --git a/tests/shell/testcases/sets/dumps/0057set_create_fails_0.json-nft b/tests/shell/testcases/sets/dumps/0057set_create_fails_0.json-nft
index 79d7257e..9d43ce1b 100644
--- a/tests/shell/testcases/sets/dumps/0057set_create_fails_0.json-nft
+++ b/tests/shell/testcases/sets/dumps/0057set_create_fails_0.json-nft
@@ -22,6 +22,7 @@
         "type": "ipv4_addr",
         "handle": 0,
         "size": 65535,
+        "count": 1,
         "elem": [
           "1.1.1.1"
         ]
diff --git a/tests/shell/testcases/sets/dumps/0060set_multistmt_1.json-nft b/tests/shell/testcases/sets/dumps/0060set_multistmt_1.json-nft
index aea0fe49..7ba55f5f 100644
--- a/tests/shell/testcases/sets/dumps/0060set_multistmt_1.json-nft
+++ b/tests/shell/testcases/sets/dumps/0060set_multistmt_1.json-nft
@@ -34,6 +34,7 @@
         "type": "ipv4_addr",
         "handle": 0,
         "size": 65535,
+        "count": 3,
         "flags": [
           "dynamic"
         ],
diff --git a/tests/shell/testcases/sets/dumps/interval_size.json-nft b/tests/shell/testcases/sets/dumps/interval_size.json-nft
index 3ae54e08..d8551406 100644
--- a/tests/shell/testcases/sets/dumps/interval_size.json-nft
+++ b/tests/shell/testcases/sets/dumps/interval_size.json-nft
@@ -29,6 +29,7 @@
         },
         "handle": 0,
         "size": 1,
+        "count": 1,
         "flags": [
           "interval"
         ],
@@ -58,6 +59,7 @@
         },
         "handle": 0,
         "size": 1,
+        "count": 1,
         "flags": [
           "interval"
         ],
-- 
2.53.0

