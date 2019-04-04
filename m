Return-Path: <SRS0=UjrQ=SG=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4423C10F0E
	for <netfilter-devel@archiver.kernel.org>; Thu,  4 Apr 2019 11:42:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 815AC206C0
	for <netfilter-devel@archiver.kernel.org>; Thu,  4 Apr 2019 11:42:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=riseup.net header.i=@riseup.net header.b="FGbqF4SW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729056AbfDDLmB (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 4 Apr 2019 07:42:01 -0400
Received: from mx1.riseup.net ([198.252.153.129]:34724 "EHLO mx1.riseup.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726269AbfDDLmB (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 4 Apr 2019 07:42:01 -0400
Received: from capuchin.riseup.net (capuchin-pn.riseup.net [10.0.1.176])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (Client CN "*.riseup.net", Issuer "COMODO RSA Domain Validation Secure Server CA" (verified OK))
        by mx1.riseup.net (Postfix) with ESMTPS id 048F81B92A5
        for <netfilter-devel@vger.kernel.org>; Thu,  4 Apr 2019 04:42:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=riseup.net; s=squak;
        t=1554378120; bh=kz2tq3LYCW+ijhxdAMZDHA8K9QdAHesFWIgzLUccDPY=;
        h=From:To:Cc:Subject:Date:From;
        b=FGbqF4SWHZG8I9dZgxOlRXYfefoMfmqLPr8dIcSuNOv+hlCGpmI0B8V/V4ILFqMLH
         qy0UQv8OtanVTHY/H43DAcBPQPPIzgBfp1pN9PN/Jd9Wh7XATmd3OWhiZWXchgQ6X7
         4yVzLIikmvRTY9JbGfbqTVxo5aozOpa1JQ7Etrsk=
X-Riseup-User-ID: 91FDE11F905A8146CD03478D50E9AB77445197CB4D92E08136C5EF465FCC2AD7
Received: from [127.0.0.1] (localhost [127.0.0.1])
         by capuchin.riseup.net (Postfix) with ESMTPSA id 3BB90120BCC;
        Thu,  4 Apr 2019 04:41:59 -0700 (PDT)
From:   Fernando Fernandez Mancera <ffmancera@riseup.net>
To:     netfilter-devel@vger.kernel.org
Cc:     Fernando Fernandez Mancera <ffmancera@riseup.net>
Subject: [PATCH nft] doc: update nft list plural form parameters
Date:   Thu,  4 Apr 2019 13:41:58 +0200
Message-Id: <20190404114158.5758-1-ffmancera@riseup.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Signed-off-by: Fernando Fernandez Mancera <ffmancera@riseup.net>
---
 doc/nft.txt | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/doc/nft.txt b/doc/nft.txt
index d162dad..36a92fe 100644
--- a/doc/nft.txt
+++ b/doc/nft.txt
@@ -256,6 +256,7 @@ TABLES
 [verse]
 {add | create} *table* ['family'] 'table' [ {flags 'flags'} ]
 {delete | list | flush} *table* ['family'] 'table'
+list *tables*
 delete *table* ['family'] handle 'handle'
 
 Tables are containers for chains, sets and stateful objects. They are identified
@@ -266,7 +267,8 @@ nfproto* keyword can be used to test which family (ipv4 or ipv6) context the
 packet is being processed in. When no address family is specified, *ip* is used
 by default. The only difference between add and create is that the former will
 not return an error if the specified table already exists while *create* will
-return an error.
+return an error. The plural form of list can be used to list all the existing
+tables.
 
 .Table flags
 [options="header"]
@@ -308,6 +310,7 @@ CHAINS
 [verse]
 {add | create} *chain* ['family'] 'table' 'chain' [ { type 'type' hook 'hook' [device 'device'] priority 'priority' ; [policy 'policy' ;] }]
 {delete | list | flush} *chain* ['family'] 'table' 'chain'
+list *chains*
 delete *chain* ['family'] 'table' handle 'handle'
 rename *chain* ['family'] 'table' 'chain' 'newname'
 
@@ -322,7 +325,7 @@ are specified, the chain is created as a base chain and hooked up to the network
 *create*:: Similar to the *add* command, but returns an error if the chain already exists.
 *delete*:: Delete the specified chain. The chain must not contain any rules or be used as jump target.
 *rename*:: Rename the specified chain.
-*list*:: List all rules of the specified chain.
+*list*:: List all rules of the specified chain. The plural form can be used to list all existing chains.
 *flush*:: Flush all rules of the specified chain.
 
 For base chains, *type*, *hook* and *priority* parameters are mandatory.
@@ -486,6 +489,7 @@ section describes nft set syntax in more detail.
 add *set* ['family'] 'table' 'set' { type 'type' ; [flags 'flags' ;] [timeout 'timeout' ;] [gc-interval 'gc-interval' ;] [elements = { 'element'[,...]
 } ;] [size size ;] [policy policy ;] [auto-merge auto-merge ;] }
 {delete | list | flush} *set* ['family'] 'table' 'set'
+list *sets*
 delete *set* ['family'] 'table' handle 'handle'
 {add | delete} *element* ['family'] 'table' 'set' { 'element'[,...] }
 
@@ -496,7 +500,7 @@ be tuned with the flags that can be specified at set creation time.
 [horizontal]
 *add*:: Add a new set in the specified table. See the Set specification table below for more information about how to specify a sets properties.
 *delete*:: Delete the specified set.
-*list*:: Display the elements in the specified set.
+*list*:: Display the elements in the specified set. The plural form can be used to list all the existing sets.
 *flush*:: Remove all elements from the specified set.
 *add element*:: Comma-separated list of elements to add into the specified set.
 *delete element*:: Comma-separated list of elements to delete from the specified set.
@@ -609,7 +613,8 @@ delete type ['family'] 'table' handle 'handle'
 
 Stateful objects are attached to tables and are identified by an unique name.
 They group stateful information from rules, to reference them in rules the
-keywords "type name" are used e.g. "counter name".
+keywords "type name" are used e.g. "counter name". The plural form can be used
+to list all exisiting stateful objects e.g "list counters".
 
 [horizontal]
 *add*:: Add a new stateful object in the specified table.
-- 
2.20.1

