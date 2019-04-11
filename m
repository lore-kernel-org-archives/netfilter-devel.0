Return-Path: <SRS0=iy/8=SN=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_NEOMUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 065E3C10F13
	for <netfilter-devel@archiver.kernel.org>; Thu, 11 Apr 2019 08:59:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C39F02084D
	for <netfilter-devel@archiver.kernel.org>; Thu, 11 Apr 2019 08:59:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="l6NFE1ZG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726160AbfDKI7p (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 11 Apr 2019 04:59:45 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:40490 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726121AbfDKI7p (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 11 Apr 2019 04:59:45 -0400
Received: by mail-wr1-f68.google.com with SMTP id h4so6238915wre.7
        for <netfilter-devel@vger.kernel.org>; Thu, 11 Apr 2019 01:59:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=v/FhiuQhTm0y3O3lV17XohvlXpKrrfIr0OfslA49Hms=;
        b=l6NFE1ZGmTXOpJgZK7i6JPJOwBGpcXK4eX2FeCYwRdZCzgJSOfBT1KbAcsbR7WeA8Z
         6S094MX2ikQRLQ7NW/jP095xUExaL9aCbkNwD5mISZE06lrvqQPbj0m9IOKbGjfabIKd
         YWfsiFUownzURRQxXAw3WauvR5J7vl148wmlUmMXpjFjov3JIvKnBKZvxBbZPwmz1et/
         JB1CJVBWqe0h3wAbB+LxaNn5lEFDFZM/WgZ3n2ytjgnP8DGNIR/cOEe/yBjgXVn66ppP
         WSInjINXoelrTWk61oHwh9LSVcfsIr6ucUK2TMwbHWjgFy4n8nLdBrzp12c8lTisGZ0P
         0tDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=v/FhiuQhTm0y3O3lV17XohvlXpKrrfIr0OfslA49Hms=;
        b=JoDaIMyVGiiXV6eR76L6pj8uGYVWpuBQAfKcayTd770rV7/hITiS9MOChTZe5SwUqN
         0y35ri1V4HFN303jSznyG0h1sbiyUAcZk/vg7qP+v2V6rULOhCVNKSPHQh4tep2wVmDd
         qDcBdCQ/6TwRqptzGbSOJyJhNW/sRcUnDa27de52rUKhRpbEwgk+EPOwBeVZT5rL0HtA
         fpSC9t/LcP+Dl28dXyaZNgmR0SNzm+eT0YGAbFQJOqfGsyha/3pGnWZG4znMarmrOx6N
         8TgJp1oVVL89T/H7pLuAqgiRNAGF6l4iOUGvPdtg6PdAGk8Ia6x9FIEclHzEXdMaJZPx
         WotQ==
X-Gm-Message-State: APjAAAUD8RSMVjrsuRdn6P3++DTHGwlTJKjybQ45es3LA6DosnxKCOo3
        hdiFXl1BYhFigbbDH6Sd8H2lLmVDBTY=
X-Google-Smtp-Source: APXvYqwEEM9J7M5z/xkWHiZyDPocCR7jV4SbSKq4i0Pi7xVb5mzDEUi5md0fYzYWwmIdj1BqLO09jA==
X-Received: by 2002:a5d:6050:: with SMTP id j16mr25803535wrt.253.1554973183274;
        Thu, 11 Apr 2019 01:59:43 -0700 (PDT)
Received: from nevthink ([82.213.198.93])
        by smtp.gmail.com with ESMTPSA id v16sm70688500wro.48.2019.04.11.01.59.42
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 11 Apr 2019 01:59:42 -0700 (PDT)
Date:   Thu, 11 Apr 2019 10:59:40 +0200
From:   Laura Garcia Liebana <nevola@gmail.com>
To:     netfilter-devel@vger.kernel.org
Cc:     pablo@netfilter.org
Subject: [PATCH nft] parser_json: fix segfault in translating string to nft
 object
Message-ID: <20190411085940.l47vszzffm4e3e3c@nevthink>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

A segmentation fault is produced when applying an input JSON file
like the following:

{"nftables": [
	{ "add":
		{"map":
			{"family": "ip",
				"name": "persistencia",
				"table": "nftlb",
				"type": "ipv4_addr",
				"map": "mark",
				"size": 65535,
				"flags": ["timeout"],
				"timeout": 44
			}
		}
	}
]}

The captured error is:

 Program received signal SIGSEGV, Segmentation fault.
 #1  0x00007ffff7f734f9 in string_to_nft_object (str=0x55555555f410
  "mark") at parser_json.c:2513
 2513			if (!strcmp(str, obj_tbl[i]))

The obj_tbl array is allocated with the maximum element index even
if lower indexes are not populated, so it produces null pointer
items.

This patch ensures that the maximum number of possible indexes
but also the element is not comparing a null pointer.

Signed-off-by: Laura Garcia Liebana <nevola@gmail.com>
---
 src/parser_json.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/src/parser_json.c b/src/parser_json.c
index 827604b..d0eacb6 100644
--- a/src/parser_json.c
+++ b/src/parser_json.c
@@ -2500,17 +2500,18 @@ static struct cmd *json_parse_cmd_add_rule(struct json_ctx *ctx, json_t *root,
 
 static int string_to_nft_object(const char *str)
 {
-	const char *obj_tbl[] = {
+	const char *obj_tbl[__NFT_OBJECT_MAX] = {
 		[NFT_OBJECT_COUNTER] = "counter",
 		[NFT_OBJECT_QUOTA] = "quota",
 		[NFT_OBJECT_CT_HELPER] = "ct helper",
 		[NFT_OBJECT_LIMIT] = "limit",
 		[NFT_OBJECT_SECMARK] = "secmark",
 	};
+
 	unsigned int i;
 
-	for (i = 1; i < array_size(obj_tbl); i++) {
-		if (!strcmp(str, obj_tbl[i]))
+	for (i = 0; i < NFT_OBJECT_MAX; i++) {
+		if (obj_tbl[i] && !strcmp(str, obj_tbl[i]))
 			return i;
 	}
 	return 0;
-- 
2.11.0

