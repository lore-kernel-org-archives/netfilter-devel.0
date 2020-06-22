Return-Path: <SRS0=UFFK=AD=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA090C433E0
	for <netfilter-devel@archiver.kernel.org>; Mon, 22 Jun 2020 08:40:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CAAE7206D4
	for <netfilter-devel@archiver.kernel.org>; Mon, 22 Jun 2020 08:40:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726854AbgFVIkd (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 22 Jun 2020 04:40:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726580AbgFVIkd (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 22 Jun 2020 04:40:33 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 386D0C061794
        for <netfilter-devel@vger.kernel.org>; Mon, 22 Jun 2020 01:40:33 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1jnI0F-0002xd-Eu; Mon, 22 Jun 2020 10:40:31 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nft] doc: revisit meta/rt primary expressions and ct statement
Date:   Mon, 22 Jun 2020 10:40:26 +0200
Message-Id: <20200622084026.3703-1-fw@strlen.de>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Clarify meta/rt ipsec examples and document that 'ct helper set'
needs to be used *after* conntrack lookup.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 doc/primary-expression.txt | 11 +++++++----
 doc/statements.txt         |  4 ++++
 2 files changed, 11 insertions(+), 4 deletions(-)

diff --git a/doc/primary-expression.txt b/doc/primary-expression.txt
index 48a7609da339..a9c39cbba420 100644
--- a/doc/primary-expression.txt
+++ b/doc/primary-expression.txt
@@ -123,7 +123,7 @@ integer (32 bit)
 pseudo-random number|
 integer (32 bit)
 |ipsec|
-boolean|
+true if packet was ipsec encrypted |
 boolean (1 bit)
 |iifkind|
 Input interface kind |
@@ -162,7 +162,7 @@ Device group (32 bit number). Can be specified numerically or as symbolic name d
 Packet type: *host* (addressed to local host), *broadcast* (to all),
 *multicast* (to group), *other* (addressed to another host).
 |ifkind|
-Interface kind (16 byte string). Does not have to exist.
+Interface kind (16 byte string). See TYPES in ip-link(8) for a list.
 |time|
 Either an integer or a date in ISO format. For example: "2019-06-06 17:00".
 Hour and seconds are optional and can be omitted if desired. If omitted,
@@ -183,11 +183,12 @@ For example, 17:00 and 17:00:00 would be equivalent.
 -----------------------
 # qualified meta expression
 filter output meta oif eth0
+filter forward meta iifkind { "tun", "veth" }
 
 # unqualified meta expression
 filter output oif eth0
 
-# packet was subject to ipsec processing
+# incoming packet was subject to ipsec processing
 raw prerouting meta ipsec exists accept
 -----------------------
 
@@ -362,13 +363,15 @@ Routing Realm (32 bit number). Can be specified numerically or as symbolic name
 --------------------------
 # IP family independent rt expression
 filter output rt classid 10
-filter output rt ipsec missing
 
 # IP family dependent rt expressions
 ip filter output rt nexthop 192.168.0.1
 ip6 filter output rt nexthop fd00::1
 inet filter output rt ip nexthop 192.168.0.1
 inet filter output rt ip6 nexthop fd00::1
+
+# outgoing packet will be encapsulated/encrypted by ipsec
+filter output rt ipsec exists
 -------------------------- 
 
 IPSEC EXPRESSIONS
diff --git a/doc/statements.txt b/doc/statements.txt
index ced311cb8d17..f777ffad7153 100644
--- a/doc/statements.txt
+++ b/doc/statements.txt
@@ -218,6 +218,10 @@ has to be assigned before a conntrack lookup takes place, i.e. this has to be
 done in prerouting and possibly output (if locally generated packets need to be
 placed in a distinct zone), with a hook priority of -300.
 
+The conntrack helper needs to be assigned after a conntrack entry has been
+found, i.e. it will not work when used with hook priorities equal or before
+-200.
+
 .Conntrack statement types
 [options="header"]
 |==================
-- 
2.26.2

