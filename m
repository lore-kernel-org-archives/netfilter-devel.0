Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7DF2AC433F5
	for <netfilter-devel@archiver.kernel.org>; Mon, 16 May 2022 06:48:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238823AbiEPGsT (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 16 May 2022 02:48:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238204AbiEPGsT (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 16 May 2022 02:48:19 -0400
Received: from mail1.systemli.org (mail1.systemli.org [IPv6:2a11:7980:3::36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D320FDF5D
        for <netfilter-devel@vger.kernel.org>; Sun, 15 May 2022 23:48:15 -0700 (PDT)
From:   vincent@systemli.org
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=systemli.org;
        s=default; t=1652683691;
        bh=CNY1MDre74u0k90ijfumdPDbLN0nk5zbnGkQVawDDbk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iulD637b0cmLvelK2sI5ogT11ZGysLmzMhyBqdwCY3cuiPdVszaWUgdhCyxY1Si9d
         ArFWl6YhWXUxwRYtVYozZ6tjvNQ8LE8Xe73w09wejqdPhhb78hRmwfCrYER1T3cazT
         7A2MpLQO01REJTCbSqG2rKNsvth0l5FnbcK1rAZDRzmRUNNZYTIyvn6iWTJpfmz7KO
         dVpAJsB9TCHpRS1Ph8M6WWYweuBWcjCA9ySR/Tuiyyo+nhmJG/4buzdNK/EmmWYEud
         Ip0f2eU6j+wqhzypE+Su9UqqQ6M8TLKLwf4Bx++x2RTwANOqUhjekalJbw50U5+AOW
         gvHV1WxdHlH/Q==
To:     netfilter-devel@vger.kernel.org
Cc:     Nick Hainke <vincent@systemli.org>
Subject: [PATCH] treewide: use uint* instead of u_int*
Date:   Mon, 16 May 2022 08:47:54 +0200
Message-Id: <20220516064754.204416-1-vincent@systemli.org>
In-Reply-To: <Yn/iZyTrZvj++6ZA@orbyte.nwl.cc>
References: <Yn/iZyTrZvj++6ZA@orbyte.nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Nick Hainke <vincent@systemli.org>

Gcc complains about missing types. Two commits introduced u_int* instead
of uint*. Use uint treewide.

Fixes errors in the form of:
In file included from xtables-legacy-multi.c:5:
xshared.h:83:56: error: unknown type name 'u_int16_t'; did you mean 'uint16_t'?
    83 | set_option(unsigned int *options, unsigned int option, u_int16_t *invflg,
        |                                                        ^~~~~~~~~
        |                                                        uint16_t
make[6]: *** [Makefile:712: xtables_legacy_multi-xtables-legacy-multi.o] Error 1

Fixes: c8f28cc8b841 ("extensions: libxt_conntrack: add support for
                      specifying port ranges")
Fixes: f647f61f273a ("xtables: Make invflags 16bit wide")

Signed-off-by: Nick Hainke <vincent@systemli.org>
---
 extensions/libxt_conntrack.c | 2 +-
 iptables/xshared.c           | 2 +-
 iptables/xshared.h           | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/extensions/libxt_conntrack.c b/extensions/libxt_conntrack.c
index 64018ce1..234085c5 100644
--- a/extensions/libxt_conntrack.c
+++ b/extensions/libxt_conntrack.c
@@ -778,7 +778,7 @@ matchinfo_print(const void *ip, const struct xt_entry_match *match, int numeric,
 
 static void
 conntrack_dump_ports(const char *prefix, const char *opt,
-		     u_int16_t port_low, u_int16_t port_high)
+		     uint16_t port_low, uint16_t port_high)
 {
 	if (port_high == 0 || port_low == port_high)
 		printf(" %s%s %u", prefix, opt, port_low);
diff --git a/iptables/xshared.c b/iptables/xshared.c
index a8512d38..9b5e5b5b 100644
--- a/iptables/xshared.c
+++ b/iptables/xshared.c
@@ -1025,7 +1025,7 @@ static const int inverse_for_options[NUMBER_OF_OPT] =
 };
 
 void
-set_option(unsigned int *options, unsigned int option, u_int16_t *invflg,
+set_option(unsigned int *options, unsigned int option, uint16_t *invflg,
 	   bool invert)
 {
 	if (*options & option)
diff --git a/iptables/xshared.h b/iptables/xshared.h
index 14568bb0..f8212988 100644
--- a/iptables/xshared.h
+++ b/iptables/xshared.h
@@ -80,7 +80,7 @@ struct xtables_target;
 #define IPT_INV_ARPHRD		0x0800
 
 void
-set_option(unsigned int *options, unsigned int option, u_int16_t *invflg,
+set_option(unsigned int *options, unsigned int option, uint16_t *invflg,
 	   bool invert);
 
 /**
-- 
2.36.1

