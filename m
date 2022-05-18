Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC347C433F5
	for <netfilter-devel@archiver.kernel.org>; Wed, 18 May 2022 14:21:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237392AbiEROVN (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 18 May 2022 10:21:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238633AbiEROVD (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 18 May 2022 10:21:03 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B893CBC29
        for <netfilter-devel@vger.kernel.org>; Wed, 18 May 2022 07:20:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=bKvVhYgjyDC2/m7kEK7vywQi96nl8lE73QkUeSzbcOY=; b=P9WpZo7kcUhBXzVH38cec4Kvgk
        m3t/UG6q/w2qrq8MmTlisI0h1iht+x/qMnQVG4ei+Lb0ntq6lI0zLzMFvMo4LdhiUACY7PYJL2Ptm
        dGfFQ8pqCZI/YD7i7yozLFbKka6BICWZLYh61uLpWzdlRBc1n5a93cuSgcDm5uQnn2E14l5dbE2kO
        zsGYuh5fWKBrfwN7UzpMhLJVnubA9QfmuUEPVn5EFyWqfmYLhBKhtPBQ3QxiNcDWcp/XKlp9I9ACw
        gIdydLFMRskiNEtWzvn980tJRfzXVfa2c1zawU/898FFUCn6e/jwBLhtc6mdNBuaOaUO7N2/hir64
        gfUYqy8g==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1nrKXm-00022X-Vc; Wed, 18 May 2022 16:20:55 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org,
        Nick Hainke <vincent@systemli.org>,
        =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <zenczykowski@gmail.com>,
        =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <maze@google.com>
Subject: [iptables PATCH] Revert "fix build for missing ETH_ALEN definition"
Date:   Wed, 18 May 2022 16:20:46 +0200
Message-Id: <20220518142046.21881-1-phil@nwl.cc>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This reverts commit c5d9a723b5159a28f547b577711787295a14fd84 as it broke
compiling against musl libc. Might be a bug in the latter, but for the
time being try to please both by avoiding the include and instead
defining ETH_ALEN if unset.

While being at it, move netinet/ether.h include up.

Fixes: 1bdb5535f561a ("libxtables: Extend MAC address printing/parsing support")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 libxtables/xtables.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/libxtables/xtables.c b/libxtables/xtables.c
index 96fd783a066cf..0638f9271c601 100644
--- a/libxtables/xtables.c
+++ b/libxtables/xtables.c
@@ -28,6 +28,7 @@
 #include <stdlib.h>
 #include <string.h>
 #include <unistd.h>
+#include <netinet/ether.h>
 #include <sys/socket.h>
 #include <sys/stat.h>
 #include <sys/statfs.h>
@@ -45,7 +46,6 @@
 
 #include <xtables.h>
 #include <limits.h> /* INT_MAX in ip_tables.h/ip6_tables.h */
-#include <linux/if_ether.h> /* ETH_ALEN */
 #include <linux/netfilter_ipv4/ip_tables.h>
 #include <linux/netfilter_ipv6/ip6_tables.h>
 #include <libiptc/libxtc.h>
@@ -72,6 +72,10 @@
 #define PROC_SYS_MODPROBE "/proc/sys/kernel/modprobe"
 #endif
 
+#ifndef ETH_ALEN
+#define ETH_ALEN 6
+#endif
+
 /* we need this for ip6?tables-restore.  ip6?tables-restore.c sets line to the
  * current line of the input file, in order  to give a more precise error
  * message.  ip6?tables itself doesn't need this, so it is initialized to the
@@ -2245,8 +2249,6 @@ void xtables_print_num(uint64_t number, unsigned int format)
 	printf(FMT("%4lluT ","%lluT "), (unsigned long long)number);
 }
 
-#include <netinet/ether.h>
-
 static const unsigned char mac_type_unicast[ETH_ALEN] =   {};
 static const unsigned char msk_type_unicast[ETH_ALEN] =   {1};
 static const unsigned char mac_type_multicast[ETH_ALEN] = {1};
-- 
2.34.1

