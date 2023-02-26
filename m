Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C7BEC64ED6
	for <netfilter-devel@archiver.kernel.org>; Sun, 26 Feb 2023 10:16:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229530AbjBZKQQ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 26 Feb 2023 05:16:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbjBZKQP (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 26 Feb 2023 05:16:15 -0500
Received: from EUR02-DB5-obe.outbound.protection.outlook.com (mail-db5eur02on2127.outbound.protection.outlook.com [40.107.249.127])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B1C45FC4
        for <netfilter-devel@vger.kernel.org>; Sun, 26 Feb 2023 02:16:14 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=S1KwEU9sCpg0oRtNKxNrEgTX2d40nZ31s7jR8RM24EcAQzon6qS/ZzOf4ovnTCPQLMoBhMkEbtfKgbV/qNgoBlsorN6GXdLLYk3W1EgA7Ci+KB42Rhh46k34PKO9RSKGVheA5+pYSHvfCL3BfU+3FD2iMlnLmeq2CpZfWm1bugzadKln4+cnNEt4ZM03hLX+DsowDU42uWb1u414AqoCPGY9Godtz5l9ii7F8XzrGaHYg2ZSHXFEf8cI0vU2fehy/QHUrPNdpx9Ow3B1Mr3fx12uFaS3hEJUVBsM8kBELwY2DofXGNOKV8PwKB+753skxRu8E0WQBO8ARpobWGF7FA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lhsp3czFZsml3S+RFiFJGgT14imUnw3yRMHo7OXdf4c=;
 b=ncGr3StyVyUtwbousIpf9uPJEWX7nMTKSxhPyJcALcol4tFLEeJl4H7sndkG0CsRZFNq7VwALMUgvTEQCd56Rw0SuKs/N/2jUxxiJ4Zl9GpeI56TZxFLjq/ZbrFTqgD4JhcorXhcXKKl49mHDk5Gvba5gK/elh35EVJ7o1XfcPbKtcznWCW2OhHTIx49jtg5kJJz3VWfq+S7sKN3wR0rp5KnifIV/yOmL+OpgemuoaSn5VN66wUi4qUBH2DffxgeatIwGtxoTZl/USYJD4yuORy8zs3XdEgbxp12dGnB0pIUTas9ykOh/f8NvAux2z3edgqyZsgVk4lzZZfdI9yJDw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=est.tech; dmarc=pass action=none header.from=est.tech;
 dkim=pass header.d=est.tech; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=estab.onmicrosoft.com;
 s=selector2-estab-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lhsp3czFZsml3S+RFiFJGgT14imUnw3yRMHo7OXdf4c=;
 b=VtgMxtaQVoW/Zl5Nbwc7ZJQwivAImdiel/bbvehmAxohYvlrD6mowjQFcbelnZ/8wzseD8VSfBJVOCyRK7V8EjQjg8y9IBwX/vuoANGLSRda4jXXUPsPPxf6gO/nZU/VXPqg6PtbWD8VmHWRff3ej54eNsb+ojAwq5xF74Ndbx0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=est.tech;
Received: from DBBP189MB1433.EURP189.PROD.OUTLOOK.COM (2603:10a6:10:1e7::15)
 by AM7P189MB0791.EURP189.PROD.OUTLOOK.COM (2603:10a6:20b:11d::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.26; Sun, 26 Feb
 2023 10:16:11 +0000
Received: from DBBP189MB1433.EURP189.PROD.OUTLOOK.COM
 ([fe80::13ad:a312:15c6:91dc]) by DBBP189MB1433.EURP189.PROD.OUTLOOK.COM
 ([fe80::13ad:a312:15c6:91dc%9]) with mapi id 15.20.6134.026; Sun, 26 Feb 2023
 10:16:11 +0000
From:   Sriram Yagnaraman <sriram.yagnaraman@est.tech>
To:     netfilter-devel@vger.kernel.org
Cc:     Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sriram Yagnaraman <sriram.yagnaraman@est.tech>
Subject: [PATCH nft v3] meta: introduce broute expression
Date:   Sun, 26 Feb 2023 10:52:04 +0100
Message-Id: <20230226095204.12211-1-sriram.yagnaraman@est.tech>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: GV3P280CA0025.SWEP280.PROD.OUTLOOK.COM
 (2603:10a6:150:b::21) To DBBP189MB1433.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:10:1e7::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DBBP189MB1433:EE_|AM7P189MB0791:EE_
X-MS-Office365-Filtering-Correlation-Id: 0f2d5d06-f74f-4f27-cbb6-08db17e27c1a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rJCPS/AzGfh/NsKQoUKj9ydAbu51DFDTyotJIF7ygnffv1Kq7fmdRJ/fNjfArrCVCwVIhBm+t2ZyJaXXGVfk9RVxAnATsH56hanK0KV4kXw/Ae0qxYbRNVsbitHbCEXOQ8T9jjvCj1Twak8nSAcXMqd+ddwUtVIaSsPqjVWMfYip3ze4RSDZFHk8GwU/ef2NldujKNjoedtP2+TzTKB9f7lELcgAQDGydBiqibCbbjPAkozBe6bbrWOxku3XlQ7VwYYf3Y9mpp7/6cO6cMQqs5YqmgvRau5ZAwvwOCWyxeJNC98G4kTziyAhZ5mNmu7dRAU9/Anjfp5gJN8NhFzI0KBnQxNeQLPbQB7G9Ua5WSVxg3REqzWfK2exyjEKMaIeWLg0Ur7klWSsgs8qCGNiUOcjYEGB3EHuefXxZvZlJhc58tRAbTXeHHp7XcgCBGtOiJBjquJtiOENJWDtPFS2lUS2h9shQXYH4gHsq8dkHHJ8cr+DUDOD4EKZK/yIhcc8Bc5uuMt5M82Zj6QDiia1OJGAbIKhbSP1Rs4kqROdQC/mhumqqgSgKJbKlGj9URrrIAwyllauwH4uJLB24WMm3oZgzNShSFZRMWEStCMAD99ekjcYJ7R8bUJ9LYfjONP1/vvQ+1fKrfTetPqqewvco4dVOWfXXJEmvXhxYdiZlSDhq/yFBPrU1d1J+csSswVW
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DBBP189MB1433.EURP189.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230025)(346002)(39830400003)(136003)(396003)(376002)(451199018)(6486002)(966005)(316002)(83380400001)(36756003)(86362001)(54906003)(2906002)(44832011)(5660300002)(66946007)(66556008)(66476007)(4326008)(8936002)(6916009)(8676002)(70586007)(41300700001)(6512007)(1076003)(6506007)(478600001)(2616005)(6666004)(186003)(26005)(38100700002)(37730700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?gnvgDCSWOnu5jfe9Zik9zhMw4f1gXAMkqy99fQbAyNaA1tYdDlHP7HlaH/b0?=
 =?us-ascii?Q?Oq3eCe6rt1KtHFbHqKq9HLGWvkk8BgcPzDz20Mo7AZkz5u3Y6KmQFIDj7Ney?=
 =?us-ascii?Q?V9OBhnLer88qtP0tfXHbC53ZGIM3yOvVGJQmvAPzKXAjF+cJ5ihG38ro2GG0?=
 =?us-ascii?Q?Wsq2RRfmf5SA9atBWdjHdbbYKfQpW9ggg2Bu6eYBhYRh61BmPltn4k5igtdY?=
 =?us-ascii?Q?cMzrtZs1GPlAnU2pRgekzrArSHUeOg09aoS2nGE1+3mzKPTZVdS1H5FJT0q+?=
 =?us-ascii?Q?f4VVUaNKOuIV58Qs8M4wsoZqpwPy7WxNddGyMiAuLBPMbxu0K/7CNkmnGQJk?=
 =?us-ascii?Q?0/Ks0L7pYsEEz42mkYGkmi08RjDKOULH0lxJEFDGb5HzldrMdRPJYiRD/JrT?=
 =?us-ascii?Q?U0fuKW8tWO1XypvTSuk3B7p8SQIzrkdANOqVkARhmX9dVjQShVObbFF3ffWL?=
 =?us-ascii?Q?UqCclj3EliygY/J2/h70ldU7L6c3FShIeX5brikQs8wbRAjSIdUT2mNk9vwL?=
 =?us-ascii?Q?KfMlt5sVuX7RT+gaYi/JBMRAAoGw42GpoZid05yieMl/F9W7jqqgzd5D3Hzu?=
 =?us-ascii?Q?LLnECCWTiim7fScRNLeuDB2Bv/eC7HHOdacoSL9WQxhdnkN+ivWZKuPNjqo1?=
 =?us-ascii?Q?Cs3rpMfo3rzsptpcFOnuQK9hYd5Q/2bTvfeBT57uJXg0mHJzfeWzvlrfI1Vn?=
 =?us-ascii?Q?6n8wo3ci8vWFjr2eyy5woRia/zHieJzIt52EPQWDgoS6TgRwf6U2h8u4lftF?=
 =?us-ascii?Q?LMVhP/Gf66+BwpkPSQN8JIRbdciDkP8SrWe3iSNMqbwVNMwEFvkbFth8b4QC?=
 =?us-ascii?Q?Lzeej7GPwtydLzYm25Ys+y+Fx9siBWzPw0NnYvxBCc1FGrcP5iVybzSZgO4i?=
 =?us-ascii?Q?WcUJS4nsSvGHtbpoFzJDDFJjzhk22llec84NIzDK9REbFmskyJ/e6ow1zDSh?=
 =?us-ascii?Q?DVKKl2x6eAH8I4xN/xlWNrvvjwgr6AipPpwIurkjRdb1EK8bcCFrZQfGjBLq?=
 =?us-ascii?Q?sHwT3qXdnP3oqoT9E98X1NysZXWi9ZV151xRddswkF0NYFKEL+sRp+5oqT6V?=
 =?us-ascii?Q?/2xxJnE3s4VslS/hHrPRcbot38XzUthudUIRefghT9l9HRJtHGSrdX63Zi7/?=
 =?us-ascii?Q?6/zKKwTCAMdWF8fGbO/vHEaZds0jkQJD+ebnLhEo3Kfor7k6UJJV+Nm9sWU+?=
 =?us-ascii?Q?qzNAay7m8XxrGqIZmzq6m2QPPtT+hxTcLuQ+kGZoiB5n2XI1227MrlEv3ZLo?=
 =?us-ascii?Q?k6HqE68LO2JzcuNYe9JByifE+QOPkNSyc6Uo/HU7wYIH8ANRIgpp8RFfZaj2?=
 =?us-ascii?Q?uN97B3uk5iekPc7QzlQAOIbd8Iz6ITR7gzEZ3v7lfcEmJbbmJ6G8rFMnVsoG?=
 =?us-ascii?Q?MhWGRnuM8SjASPLrbe24E+plZhYx2lb6c89Eql69wsufZcYELTMt2v98JDoZ?=
 =?us-ascii?Q?iH0VZvfBU5EwgNI0B8l0ocSMJ67UJSXHjbHi1UP9rH/Yh2IqoSqH/hT8SGuk?=
 =?us-ascii?Q?VxSiF+leCttIIeoJVeX/IxrBxysQQjBf/wCcKlj7YunwsmVJc8WxvAuw7guJ?=
 =?us-ascii?Q?4s3M5Wk3FVT9S4f+EPLMhHxB2md2069Lo3f76jSd1xyxr/Ym1ZJPICRwZX6l?=
 =?us-ascii?Q?AQ=3D=3D?=
X-OriginatorOrg: est.tech
X-MS-Exchange-CrossTenant-Network-Message-Id: 0f2d5d06-f74f-4f27-cbb6-08db17e27c1a
X-MS-Exchange-CrossTenant-AuthSource: DBBP189MB1433.EURP189.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Feb 2023 10:16:11.6329
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: d2585e63-66b9-44b6-a76e-4f4b217d97fd
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: j2rC3Q9TT3rNBI7sXAhg1jVjtRdMllMCbebtNwwnDm/Z0koiXs0y4Y/TX7E62X5JmxurSrn5iaFGQymFBGpeIAe4U+Oo0ZcbV6+YAJPB5BA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM7P189MB0791
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

nftables userspace tool support for broute meta statement introduced in [1].

[1]: https://patchwork.ozlabs.org/project/netfilter-devel/patch/20230224095251.11249-1-sriram.yagnaraman@est.tech/

Signed-off-by: Sriram Yagnaraman <sriram.yagnaraman@est.tech>
---
 doc/statements.txt                  |  5 ++++-
 include/linux/netfilter/nf_tables.h |  2 ++
 src/meta.c                          |  2 ++
 tests/py/bridge/meta.t              |  2 ++
 tests/py/bridge/meta.t.payload      |  5 +++++
 tests/py/bridge/redirect.t          |  5 +++++
 tests/py/bridge/redirect.t.json     | 12 ++++++++++++
 tests/py/bridge/redirect.t.payload  |  4 ++++
 8 files changed, 36 insertions(+), 1 deletion(-)
 create mode 100644 tests/py/bridge/redirect.t
 create mode 100644 tests/py/bridge/redirect.t.json
 create mode 100644 tests/py/bridge/redirect.t.payload

diff --git a/doc/statements.txt b/doc/statements.txt
index 0532b2b1..4e7e2654 100644
--- a/doc/statements.txt
+++ b/doc/statements.txt
@@ -296,7 +296,7 @@ A meta statement sets the value of a meta expression. The existing meta fields
 are: priority, mark, pkttype, nftrace. +
 
 [verse]
-*meta* {*mark* | *priority* | *pkttype* | *nftrace*} *set* 'value'
+*meta* {*mark* | *priority* | *pkttype* | *nftrace* | *broute*} *set* 'value'
 
 A meta statement sets meta data associated with a packet. +
 
@@ -316,6 +316,9 @@ pkt_type
 |nftrace |
 ruleset packet tracing on/off. Use *monitor trace* command to watch traces|
 0, 1
+|broute |
+broute on/off. packets are routed instead of being bridged|
+0, 1
 |==========================
 
 LIMIT STATEMENT
diff --git a/include/linux/netfilter/nf_tables.h b/include/linux/netfilter/nf_tables.h
index ff677f3a..9c6f02c2 100644
--- a/include/linux/netfilter/nf_tables.h
+++ b/include/linux/netfilter/nf_tables.h
@@ -931,6 +931,7 @@ enum nft_exthdr_attributes {
  * @NFT_META_TIME_HOUR: hour of day (in seconds)
  * @NFT_META_SDIF: slave device interface index
  * @NFT_META_SDIFNAME: slave device interface name
+ * @NFT_META_BRI_BROUTE: packet br_netfilter_broute bit
  */
 enum nft_meta_keys {
 	NFT_META_LEN,
@@ -969,6 +970,7 @@ enum nft_meta_keys {
 	NFT_META_TIME_HOUR,
 	NFT_META_SDIF,
 	NFT_META_SDIFNAME,
+	NFT_META_BRI_BROUTE,
 	__NFT_META_IIFTYPE,
 };
 
diff --git a/src/meta.c b/src/meta.c
index 013e8cba..6f9ed06b 100644
--- a/src/meta.c
+++ b/src/meta.c
@@ -698,6 +698,8 @@ const struct meta_template meta_templates[] = {
 	[NFT_META_SDIFNAME]	= META_TEMPLATE("sdifname", &ifname_type,
 						IFNAMSIZ * BITS_PER_BYTE,
 						BYTEORDER_HOST_ENDIAN),
+	[NFT_META_BRI_BROUTE]	= META_TEMPLATE("broute",   &integer_type,
+						1    , BYTEORDER_HOST_ENDIAN),
 };
 
 static bool meta_key_is_unqualified(enum nft_meta_keys key)
diff --git a/tests/py/bridge/meta.t b/tests/py/bridge/meta.t
index d77ebd89..171aa610 100644
--- a/tests/py/bridge/meta.t
+++ b/tests/py/bridge/meta.t
@@ -9,3 +9,5 @@ meta ibrpvid 100;ok
 
 meta protocol ip udp dport 67;ok
 meta protocol ip6 udp dport 67;ok
+
+meta broute set 1;fail
diff --git a/tests/py/bridge/meta.t.payload b/tests/py/bridge/meta.t.payload
index 0a39842a..72588e3d 100644
--- a/tests/py/bridge/meta.t.payload
+++ b/tests/py/bridge/meta.t.payload
@@ -35,3 +35,8 @@ bridge test-bridge input
   [ cmp eq reg 1 0x00000011 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ cmp eq reg 1 0x00004300 ]
+
+# meta broute set 1
+bridge test-bridge input
+  [ immediate reg 1 0x00000001 ]
+  [ meta set broute with reg 1 ]
diff --git a/tests/py/bridge/redirect.t b/tests/py/bridge/redirect.t
new file mode 100644
index 00000000..5181e799
--- /dev/null
+++ b/tests/py/bridge/redirect.t
@@ -0,0 +1,5 @@
+:prerouting;type filter hook prerouting priority 0
+
+*bridge;test-bridge;prerouting
+
+meta broute set 1;ok
diff --git a/tests/py/bridge/redirect.t.json b/tests/py/bridge/redirect.t.json
new file mode 100644
index 00000000..7e32b329
--- /dev/null
+++ b/tests/py/bridge/redirect.t.json
@@ -0,0 +1,12 @@
+# meta broute set 1
+[
+    {
+        "mangle": {
+            "key": {
+                "meta": { "key": "broute" }
+            },
+            "value": 1
+        }
+    }
+]
+
diff --git a/tests/py/bridge/redirect.t.payload b/tests/py/bridge/redirect.t.payload
new file mode 100644
index 00000000..1fcfa5f1
--- /dev/null
+++ b/tests/py/bridge/redirect.t.payload
@@ -0,0 +1,4 @@
+# meta broute set 1
+bridge test-bridge prerouting
+  [ immediate reg 1 0x00000001 ]
+  [ meta set broute with reg 1 ]
-- 
2.34.1

