Return-Path: <SRS0=Hnfl=SH=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A68AFC4360F
	for <netfilter-devel@archiver.kernel.org>; Fri,  5 Apr 2019 15:36:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5A92121726
	for <netfilter-devel@archiver.kernel.org>; Fri,  5 Apr 2019 15:36:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=riseup.net header.i=@riseup.net header.b="pxXg5mXi"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731314AbfDEPg4 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 5 Apr 2019 11:36:56 -0400
Received: from mx1.riseup.net ([198.252.153.129]:50212 "EHLO mx1.riseup.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729987AbfDEPg4 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 5 Apr 2019 11:36:56 -0400
Received: from capuchin.riseup.net (capuchin-pn.riseup.net [10.0.1.176])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (Client CN "*.riseup.net", Issuer "COMODO RSA Domain Validation Secure Server CA" (verified OK))
        by mx1.riseup.net (Postfix) with ESMTPS id 3983D1B91F2
        for <netfilter-devel@vger.kernel.org>; Fri,  5 Apr 2019 08:36:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=riseup.net; s=squak;
        t=1554478615; bh=7bSjwC1RKemynA2fo5lSaQrLpIRNFvMb7flb5nVmhWE=;
        h=From:To:Cc:Subject:Date:From;
        b=pxXg5mXiFXehoT11uSIxHacDt/6ZKaMeCCLKgquRC/RHOvLL+3rfm/P/mW9KECjkx
         Tl9TeMrVMI3Nv26k8dPf23LzsOY64XeGbUtT1mR+maaMaOEjnRvgoc82US5af4x68Y
         VN+Ku9y4ORzbaiP406/6Om29X+QEAWMyfDcfxfqE=
X-Riseup-User-ID: E96C83CEFE23909B12AA03A73432689DB16BF3D144846BAE5AE66F6D21F459AE
Received: from [127.0.0.1] (localhost [127.0.0.1])
         by capuchin.riseup.net (Postfix) with ESMTPSA id 68A76120BC1;
        Fri,  5 Apr 2019 08:36:54 -0700 (PDT)
From:   Fernando Fernandez Mancera <ffmancera@riseup.net>
To:     netfilter-devel@vger.kernel.org
Cc:     Fernando Fernandez Mancera <ffmancera@riseup.net>
Subject: [PATCH nft v2] doc: update nft list plural form parameters
Date:   Fri,  5 Apr 2019 17:36:55 +0200
Message-Id: <20190405153655.990-1-ffmancera@riseup.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Signed-off-by: Fernando Fernandez Mancera <ffmancera@riseup.net>
---
 doc/nft.txt | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/doc/nft.txt b/doc/nft.txt
index d162dad..127a703 100644
--- a/doc/nft.txt
+++ b/doc/nft.txt
@@ -256,6 +256,7 @@ TABLES
 [verse]
 {add | create} *table* ['family'] 'table' [ {flags 'flags'} ]
 {delete | list | flush} *table* ['family'] 'table'
+list *tables*
 delete *table* ['family'] handle 'handle'
 
 Tables are containers for chains, sets and stateful objects. They are identified
@@ -308,6 +309,7 @@ CHAINS
 [verse]
 {add | create} *chain* ['family'] 'table' 'chain' [ { type 'type' hook 'hook' [device 'device'] priority 'priority' ; [policy 'policy' ;] }]
 {delete | list | flush} *chain* ['family'] 'table' 'chain'
+list *chains*
 delete *chain* ['family'] 'table' handle 'handle'
 rename *chain* ['family'] 'table' 'chain' 'newname'
 
@@ -486,6 +488,7 @@ section describes nft set syntax in more detail.
 add *set* ['family'] 'table' 'set' { type 'type' ; [flags 'flags' ;] [timeout 'timeout' ;] [gc-interval 'gc-interval' ;] [elements = { 'element'[,...]
 } ;] [size size ;] [policy policy ;] [auto-merge auto-merge ;] }
 {delete | list | flush} *set* ['family'] 'table' 'set'
+list *sets*
 delete *set* ['family'] 'table' handle 'handle'
 {add | delete} *element* ['family'] 'table' 'set' { 'element'[,...] }
 
@@ -606,6 +609,9 @@ STATEFUL OBJECTS
 [verse]
 {add | delete | list | reset} type ['family'] 'table' 'object'
 delete type ['family'] 'table' handle 'handle'
+list counters
+list quotas
+list meters
 
 Stateful objects are attached to tables and are identified by an unique name.
 They group stateful information from rules, to reference them in rules the
-- 
2.20.1

