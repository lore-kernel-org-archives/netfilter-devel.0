Return-Path: <SRS0=SDnU=YX=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=DKIM_ADSP_CUSTOM_MED,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3D6CCA9EC5
	for <netfilter-devel@archiver.kernel.org>; Wed, 30 Oct 2019 17:57:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C2B552087F
	for <netfilter-devel@archiver.kernel.org>; Wed, 30 Oct 2019 17:57:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727603AbfJ3R5Y (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 30 Oct 2019 13:57:24 -0400
Received: from 195-154-211-226.rev.poneytelecom.eu ([195.154.211.226]:52604
        "EHLO flash.glorub.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727012AbfJ3R5Y (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 30 Oct 2019 13:57:24 -0400
Received: from eric by flash.glorub.net with local (Exim 4.89)
        (envelope-from <ejallot@gmail.com>)
        id 1iPsDi-000CMb-M0; Wed, 30 Oct 2019 18:57:22 +0100
From:   Eric Jallot <ejallot@gmail.com>
To:     netfilter-devel@vger.kernel.org
Cc:     Eric Jallot <ejallot@gmail.com>
Subject: [PATCH nft] doc: fix missing family in plural forms list command.
Date:   Wed, 30 Oct 2019 18:19:17 +0100
Message-Id: <20191030171917.45942-1-ejallot@gmail.com>
X-Mailer: git-send-email 2.11.0
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Fixes: 067ac215e93f ("doc: update nft list plural form parameters")
Signed-off-by: Eric Jallot <ejallot@gmail.com>
---
 doc/nft.txt | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/doc/nft.txt b/doc/nft.txt
index 2c79009948a5..ed2157638032 100644
--- a/doc/nft.txt
+++ b/doc/nft.txt
@@ -264,7 +264,7 @@ TABLES
 [verse]
 {*add* | *create*} *table* ['family'] 'table' [*{ flags* 'flags' *; }*]
 {*delete* | *list* | *flush*} *table* ['family'] 'table'
-*list tables*
+*list tables* ['family']
 *delete table* ['family'] *handle* 'handle'
 
 Tables are containers for chains, sets and stateful objects. They are identified
@@ -317,7 +317,7 @@ CHAINS
 [verse]
 {*add* | *create*} *chain* ['family'] 'table' 'chain' [*{ type* 'type' *hook* 'hook' [*device* 'device'] *priority* 'priority' *;* [*policy* 'policy' *;*] *}*]
 {*delete* | *list* | *flush*} *chain* ['family'] 'table' 'chain'
-*list chains*
+*list chains* ['family']
 *delete chain* ['family'] 'table' *handle* 'handle'
 *rename chain* ['family'] 'table' 'chain' 'newname'
 
@@ -495,7 +495,7 @@ section describes nft set syntax in more detail.
 [verse]
 *add set* ['family'] 'table' 'set' *{ type* 'type' *;* [*flags* 'flags' *;*] [*timeout* 'timeout' *;*] [*gc-interval* 'gc-interval' *;*] [*elements = {* 'element'[*,* ...] *} ;*] [*size* 'size' *;*] [*policy* 'policy' *;*] [*auto-merge ;*] *}*
 {*delete* | *list* | *flush*} *set* ['family'] 'table' 'set'
-*list sets*
+*list sets* ['family']
 *delete set* ['family'] 'table' *handle* 'handle'
 {*add* | *delete*} *element* ['family'] 'table' 'set' *{* 'element'[*,* ...] *}*
 
@@ -547,7 +547,7 @@ MAPS
 [verse]
 *add map* ['family'] 'table' 'map' *{ type* 'type' [*flags* 'flags' *;*] [*elements = {* 'element'[*,* ...] *} ;*] [*size* 'size' *;*] [*policy* 'policy' *;*] *}*
 {*delete* | *list* | *flush*} *map* ['family'] 'table' 'map'
-*list maps*
+*list maps* ['family']
 {*add* | *delete*} *element* ['family'] 'table' 'map' *{ elements = {* 'element'[*,* ...] *} ; }*
 
 Maps store data based on some specific key used as input. They are uniquely identified by a user-defined name and attached to tables.
@@ -586,6 +586,7 @@ FLOWTABLES
 -----------
 [verse]
 {*add* | *create*} *flowtable* ['family'] 'table' 'flowtable' *{ hook* 'hook' *priority* 'priority' *; devices = {* 'device'[*,* ...] *} ; }*
+*list flowtables* ['family']
 {*delete* | *list*} *flowtable* ['family'] 'table' 'flowtable'
 
 Flowtables allow you to accelerate packet forwarding in software. Flowtables
@@ -617,8 +618,8 @@ STATEFUL OBJECTS
 [verse]
 {*add* | *delete* | *list* | *reset*} 'type' ['family'] 'table' 'object'
 *delete* 'type' ['family'] 'table' *handle* 'handle'
-*list counters*
-*list quotas*
+*list counters* ['family']
+*list quotas* ['family']
 
 Stateful objects are attached to tables and are identified by an unique name.
 They group stateful information from rules, to reference them in rules the
-- 
2.11.0

