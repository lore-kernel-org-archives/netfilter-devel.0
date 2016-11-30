From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nftables RFC] build: honor Scrooge McDuck in our release names
Date: Wed, 30 Nov 2016 20:01:37 +0100
Message-ID: <1480532497-9635-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:55172 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755486AbcK3TBt (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 30 Nov 2016 14:01:49 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 9921412A688
        for <netfilter-devel@vger.kernel.org>; Wed, 30 Nov 2016 20:01:47 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 86902DA86D
        for <netfilter-devel@vger.kernel.org>; Wed, 30 Nov 2016 20:01:47 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 93017DA80B
        for <netfilter-devel@vger.kernel.org>; Wed, 30 Nov 2016 20:01:41 +0100 (CET)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

I'm proposing that the upcoming nftables releases are dedicated to
Scrooge McDuck [1]. Personally, I would like to extend this honoring to
every tycoon-wanabee around the world that already found a crack to
abuse the system and get rich through it. World would be a better place
if you moderate yourself, really.

[1] https://en.wikipedia.org/wiki/Scrooge_McDuck#/media/File:ScroogeFirst.jpg

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 configure.ac | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/configure.ac b/configure.ac
index 7e0b75c27722..cf707c32fb8f 100644
--- a/configure.ac
+++ b/configure.ac
@@ -5,7 +5,7 @@ AC_PREREQ(2.61)
 
 AC_COPYRIGHT([Copyright (c) 2008 Patrick McHardy <kaber@trash.net>])
 AC_INIT([nftables], [0.6], [netfilter-devel@vger.kernel.org])
-AC_DEFINE([RELEASE_NAME], ["Support Edward Snowden"], [Release name])
+AC_DEFINE([RELEASE_NAME], ["Scrooge McDuck"], [Release name])
 
 AC_CONFIG_AUX_DIR([build-aux])
 AC_CANONICAL_HOST
-- 
2.1.4

