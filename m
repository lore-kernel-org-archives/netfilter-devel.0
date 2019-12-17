Return-Path: <SRS0=i/iJ=2H=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8FAD9C43603
	for <netfilter-devel@archiver.kernel.org>; Tue, 17 Dec 2019 11:28:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 643B62082E
	for <netfilter-devel@archiver.kernel.org>; Tue, 17 Dec 2019 11:28:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727580AbfLQL2A (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 17 Dec 2019 06:28:00 -0500
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:57364 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726858AbfLQL17 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 17 Dec 2019 06:27:59 -0500
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1ihB1B-0006mY-Ks; Tue, 17 Dec 2019 12:27:57 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nft v3 09/10] doc: mention 'typeof' as alternative to 'type' keyword
Date:   Tue, 17 Dec 2019 12:27:12 +0100
Message-Id: <20191217112713.6017-10-fw@strlen.de>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191217112713.6017-1-fw@strlen.de>
References: <20191217112713.6017-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 doc/nft.txt | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/doc/nft.txt b/doc/nft.txt
index abb9260d3f2f..45350253ccbf 100644
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
@@ -517,6 +517,9 @@ be tuned with the flags that can be specified at set creation time.
 |type |
 data type of set elements |
 string: ipv4_addr, ipv6_addr, ether_addr, inet_proto, inet_service, mark
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
+string: ipv4_addr, ipv6_addr, ether_addr, inet_proto, inet_service, mark, counter, quota. Counter and quota can't be used as keys
+|typeof |
+data type of set element |
+expression to derive the data type from
 |flags |
 map flags |
 string: constant, interval
-- 
2.24.1

