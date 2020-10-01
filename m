Return-Path: <SRS0=AsZf=DI=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8CB8BC4727C
	for <netfilter-devel@archiver.kernel.org>; Thu,  1 Oct 2020 09:30:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E8A0820719
	for <netfilter-devel@archiver.kernel.org>; Thu,  1 Oct 2020 09:30:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=doubly.so header.i=@doubly.so header.b="XwvJmlvq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731067AbgJAJag (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 1 Oct 2020 05:30:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725975AbgJAJag (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 1 Oct 2020 05:30:36 -0400
Received: from mout-p-201.mailbox.org (mout-p-201.mailbox.org [IPv6:2001:67c:2050::465:201])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 391BBC0613D0
        for <netfilter-devel@vger.kernel.org>; Thu,  1 Oct 2020 02:30:36 -0700 (PDT)
Received: from smtp1.mailbox.org (smtp1.mailbox.org [80.241.60.240])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mout-p-201.mailbox.org (Postfix) with ESMTPS id 4C27CC4LfXzQlWy;
        Thu,  1 Oct 2020 11:30:31 +0200 (CEST)
X-Virus-Scanned: amavisd-new at heinlein-support.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=doubly.so; s=MBO0001;
        t=1601544629;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=JY/oLn2EPEJD6vCO8x6pM4gOUlf8nYKLLgzH3IgNJPE=;
        b=XwvJmlvqVJQDn5EqTrH6hS5FvHr6yj9HsuJEH58Twklgdi9orPaG4NowFQ0LPwIeGNccF2
        aPe0CJYv9tsiljue6sAfc+jci5pfk/hPT9rjSryijeRVTbP2yNzNqguI/rkwORADxOukOH
        V/ApuVC0GQdL3rReQtKOO1e/aSEai+AvTnJ0ueoAJx6EY7D+DbG/c8Zyeljy1tlBBmyHp8
        4fJZJXKtubrXgp4os58wgGDgqFZ9qvFFk/ue6mnFZHEb9IiYZeMmIuc2YGM2KQgPyqWZFF
        w7JWWcEkBlBBkRnLdAnQMha33lUAl8tqVAAJExDWtH0HD63JHcPkkYUrGwcYXQ==
Received: from smtp1.mailbox.org ([80.241.60.240])
        by spamfilter01.heinlein-hosting.de (spamfilter01.heinlein-hosting.de [80.241.56.115]) (amavisd-new, port 10030)
        with ESMTP id JxVBZ0m1tFDJ; Thu,  1 Oct 2020 11:30:28 +0200 (CEST)
To:     netfilter-devel@vger.kernel.org
Cc:     pablo@netfilter.org
From:   Devin Bayer <dev@doubly.so>
Subject: [PATCH] nft: migrate man page examples with `meter` directive to sets
Message-ID: <b35b744f-a29c-d76b-6969-8cf6371c2a1a@doubly.so>
Date:   Thu, 1 Oct 2020 11:30:27 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-MBO-SPAM-Probability: 
X-Rspamd-Score: -3.86 / 15.00 / 15.00
X-Rspamd-Queue-Id: 97FB0180E
X-Rspamd-UID: b80b2b
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hello,

this updates the two examples in the man page that use the obsolete 
`meter` to use sets. I also fixed a bit of formatting for the conntrack 
expressions.

Thanks,
Devin

---
  doc/payload-expression.txt | 12 +++++++-----
  doc/statements.txt         | 29 +++++++++++++++++++----------
  2 files changed, 26 insertions(+), 15 deletions(-)

diff --git a/doc/payload-expression.txt b/doc/payload-expression.txt
index e6f108b1..e2beb8be 100644
--- a/doc/payload-expression.txt
+++ b/doc/payload-expression.txt
@@ -642,6 +642,8 @@ zone id is tied to the given direction. +
  *ct* {*original* | *reply*} {*proto-src* | *proto-dst*}
  *ct* {*original* | *reply*} {*ip* | *ip6*} {*saddr* | *daddr*}

+The conntrack-specific types in this table are described in the 
sub-section CONNTRACK TYPES above.
+
  .Conntrack expressions
  [options="header"]
  |==================
@@ -698,15 +700,15 @@ integer (64 bit)
  conntrack zone |
  integer (16 bit)
  |count|
-count number of connections
+number of current connections|
  integer (32 bit)
  |id|
-Connection id
-ct_id
+Connection id|
+ct_id|
  |==========================================
-A description of conntrack-specific types listed above can be found 
sub-section CONNTRACK TYPES above.

  .restrict the number of parallel connections to a server
  --------------------
-filter input tcp dport 22 meter test { ip saddr ct count over 2 } reject
+nft add set filter ssh_flood '{ type ipv4_addr; flags dynamic; }'
+nft filter input tcp dport 22 add @ssh_flood '{ ip saddr ct count over 
2 }' reject
  --------------------
diff --git a/doc/statements.txt b/doc/statements.txt
index 9155f286..9cbae019 100644
--- a/doc/statements.txt
+++ b/doc/statements.txt
@@ -704,8 +704,17 @@ blacklists.

  .Example for simple blacklist
  -----------------------------
-# declare a set, bound to table "filter", in family "ip". Timeout and 
size are mandatory because we will add elements from packet path.
-nft add set ip filter blackhole "{ type ipv4_addr; flags timeout; size 
65536; }"
+# declare a set, bound to table "filter", in family "ip".
+# Timeout and size are mandatory because we will add elements from 
packet path.
+# Entries will timeout after one minute, after which they might be
+# re-added if limit condition persists.
+nft add set ip filter blackhole \
+    "{ type ipv4_addr; timeout 1m; size 65536 }"
+
+# declare a set to store the limit per saddr.
+# This must be separate from blackhole since the timeout is different
+nft add set ip filter flood \
+    "{ type ipv4_addr; flags dynamic; timeout 10s; size 128000 }"

  # whitelist internal interface.
  nft add rule ip filter input meta iifname "internal" accept
@@ -713,17 +722,17 @@ nft add rule ip filter input meta iifname 
"internal" accept
  # drop packets coming from blacklisted ip addresses.
  nft add rule ip filter input ip saddr @blackhole counter drop

-# add source ip addresses to the blacklist if more than 10 tcp 
connection requests occurred per second and ip address.
-# entries will timeout after one minute, after which they might be 
re-added if limit condition persists.
-nft add rule ip filter input tcp flags syn tcp dport ssh meter flood 
size 128000 { ip saddr timeout 10s limit rate over 10/second} add 
@blackhole { ip saddr timeout 1m } drop
+# add source ip addresses to the blacklist if more than 10 tcp connection
+# requests occurred per second and ip address.
+nft add rule ip filter input tcp flags syn tcp dport ssh \
+    add @flood { ip saddr limit rate over 10/second } \
+    add @blackhole { ip saddr } drop

-# inspect state of the rate limit meter:
-nft list meter ip filter flood
-
-# inspect content of blackhole:
+# inspect state of the sets.
+nft list set ip filter flood
  nft list set ip filter blackhole

-# manually add two addresses to the set:
+# manually add two addresses to the blackhole.
  nft add element filter blackhole { 10.2.3.4, 10.23.1.42 }
  -----------------------------------------------

--
2.25.1
