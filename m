Return-Path: <SRS0=cCuT=32=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18252C35247
	for <netfilter-devel@archiver.kernel.org>; Thu,  6 Feb 2020 16:03:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ECE0520838
	for <netfilter-devel@archiver.kernel.org>; Thu,  6 Feb 2020 16:03:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727379AbgBFQDm (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 6 Feb 2020 11:03:42 -0500
Received: from orbyte.nwl.cc ([151.80.46.58]:49318 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726925AbgBFQDm (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 6 Feb 2020 11:03:42 -0500
Received: from localhost ([::1]:34176 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1izjcz-0000iV-7x; Thu, 06 Feb 2020 17:03:41 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [nft PATCH] doc: nft.8: Describe element commands in their own section
Date:   Thu,  6 Feb 2020 17:03:40 +0100
Message-Id: <20200206160340.2472-1-phil@nwl.cc>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This unifies the redundant information in sets and maps sections and
also covers 'get' command.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 doc/nft.txt | 40 +++++++++++++++++++++++++++++++++++++---
 1 file changed, 37 insertions(+), 3 deletions(-)

diff --git a/doc/nft.txt b/doc/nft.txt
index 45350253ccbfe..ba0c8c0bef445 100644
--- a/doc/nft.txt
+++ b/doc/nft.txt
@@ -507,8 +507,6 @@ be tuned with the flags that can be specified at set creation time.
 *delete*:: Delete the specified set.
 *list*:: Display the elements in the specified set.
 *flush*:: Remove all elements from the specified set.
-*add element*:: Comma-separated list of elements to add into the specified set.
-*delete element*:: Comma-separated list of elements to delete from the specified set.
 
 .Set specifications
 [options="header"]
@@ -550,7 +548,6 @@ MAPS
 *add map* ['family'] 'table' 'map' *{ type* 'type' | *typeof* 'expression' [*flags* 'flags' *;*] [*elements = {* 'element'[*,* ...] *} ;*] [*size* 'size' *;*] [*policy* 'policy' *;*] *}*
 {*delete* | *list* | *flush*} *map* ['family'] 'table' 'map'
 *list maps* ['family']
-{*add* | *delete*} *element* ['family'] 'table' 'map' *{ elements = {* 'element'[*,* ...] *} ; }*
 
 Maps store data based on some specific key used as input. They are uniquely identified by a user-defined name and attached to tables.
 
@@ -587,6 +584,43 @@ string: performance [default], memory
 |=================
 
 
+ELEMENTS
+--------
+[verse]
+____
+{*add* | *create* | *delete* | *get* } *element* ['family'] 'table' 'set' *{* 'ELEMENT'[*,* ...] *}*
+
+'ELEMENT' := 'key_expression' 'OPTIONS' [*:* 'value_expression']
+'OPTIONS' := [*timeout* 'TIMESPEC'] [*expires* 'TIMESPEC'] [*comment* 'string']
+'TIMESPEC' := ['num'*d*]['num'*h*]['num'*m*]['num'[*s*]]
+____
+Element-related commands allow to change contents of named sets and maps.
+'key_expression' is typically a value matching the set type.
+'value_expression' is not allowed in sets but mandatory when adding to maps, where it
+matches the data part in it's type definition. When deleting from maps, it may
+be specified but is optional as 'key_expression' uniquely identifies the
+element.
+
+*create* command is similar to *add* with the exception that none of the
+listed elements may already exist.
+
+*get* command is useful to check if an element is contained in a set which may
+be non-trivial in very large and/or interval sets. In the latter case, the
+containing interval is returned instead of just the element itself.
+
+.Element options
+[options="header"]
+|=================
+|Option | Description
+|timeout |
+timeout value for sets/maps with flag *timeout*
+|expires |
+the time until given element expires, useful for ruleset replication only
+|comment |
+per element comment field
+|=================
+
+
 FLOWTABLES
 -----------
 [verse]
-- 
2.24.1

