Return-Path: <SRS0=a9hH=2D=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C366C751C4
	for <netfilter-devel@archiver.kernel.org>; Fri, 13 Dec 2019 20:38:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3C31724728
	for <netfilter-devel@archiver.kernel.org>; Fri, 13 Dec 2019 20:38:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728015AbfLMQER (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 13 Dec 2019 11:04:17 -0500
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:40368 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727990AbfLMQER (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 13 Dec 2019 11:04:17 -0500
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1ifnQN-0004EP-IF; Fri, 13 Dec 2019 17:04:15 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nft v2 10/11] doc: mention 'typeof' as alternative to 'type' keyword
Date:   Fri, 13 Dec 2019 17:03:44 +0100
Message-Id: <20191213160345.30057-11-fw@strlen.de>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191213160345.30057-1-fw@strlen.de>
References: <20191213160345.30057-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 doc/nft.txt | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/doc/nft.txt b/doc/nft.txt
index abb9260d3f2f..a5586b74f370 100644
--- a/doc/nft.txt
+++ b/doc/nft.txt
@@ -492,7 +492,7 @@ The sets allowed_hosts and allowed_ports need to be created first. The next
 section describes nft set syntax in more detail.
 
 [verse]
-*add set* ['family'] 'table' 'set' *{ type* 'type' *;* [*flags* 'flags' *;*] [*timeout* 'timeout' *;*] [*gc-interval* 'gc-interval' *;*] [*elements = {* 'element'[*,* ...] *} ;*] [*size* 'size' *;*] [*policy* 'policy' *;*] [*auto-merge ;*] *}*
+*add set* ['family'] 'table' 'set' *{ type* 'type' | *typeof* 'expression' *;* [*flags* 'flags' *;*] [*timeout* 'timeout' *;*] [*gc-interval* 'gc-interval' *;*] [*elements = {* 'element'[*,* ...] *} ;*] [*size* 'size' *;*] [*policy* 'policy' *;*] [*auto-merge ;*] *}*
 {*delete* | *list* | *flush*} *set* ['family'] 'table' 'set'
 *list sets* ['family']
 *delete set* ['family'] 'table' *handle* 'handle'
@@ -516,7 +516,10 @@ be tuned with the flags that can be specified at set creation time.
 |Keyword | Description | Type
 |type |
 data type of set elements |
-string: ipv4_addr, ipv6_addr, ether_addr, inet_proto, inet_service, mark
+string: ipv4_addr, ipv6_addr, ether_addr, inet_proto, inet_service, mark, string, integer
+|typeof |
+data type of set element |
+expression to derive the data type from
 |flags |
 set flags |
 string: constant, dynamic, interval, timeout
@@ -544,7 +547,7 @@ automatic merge of adjacent/overlapping set elements (only for interval sets) |
 MAPS
 -----
 [verse]
-*add map* ['family'] 'table' 'map' *{ type* 'type' [*flags* 'flags' *;*] [*elements = {* 'element'[*,* ...] *} ;*] [*size* 'size' *;*] [*policy* 'policy' *;*] *}*
+*add map* ['family'] 'table' 'map' *{ type* 'type' | *typeof* 'expression' [*flags* 'flags' *;*] [*elements = {* 'element'[*,* ...] *} ;*] [*size* 'size' *;*] [*policy* 'policy' *;*] *}*
 {*delete* | *list* | *flush*} *map* ['family'] 'table' 'map'
 *list maps* ['family']
 {*add* | *delete*} *element* ['family'] 'table' 'map' *{ elements = {* 'element'[*,* ...] *} ; }*
@@ -565,7 +568,10 @@ Maps store data based on some specific key used as input. They are uniquely iden
 |Keyword | Description | Type
 |type |
 data type of map elements |
-string `:' string: ipv4_addr, ipv6_addr, ether_addr, inet_proto, inet_service, mark, counter, quota. Counter and quota can't be used as keys
+string: ipv4_addr, ipv6_addr, ether_addr, inet_proto, inet_service, mark, string, integer, counter, quota. Counter and quota can't be used as keys
+|typeof |
+data type of set element |
+expression to derive the data type from
 |flags |
 map flags |
 string: constant, interval
-- 
2.23.0

