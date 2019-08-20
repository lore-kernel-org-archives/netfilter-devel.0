Return-Path: <SRS0=ly5L=WQ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F593C3A589
	for <netfilter-devel@archiver.kernel.org>; Tue, 20 Aug 2019 15:50:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D941522CE3
	for <netfilter-devel@archiver.kernel.org>; Tue, 20 Aug 2019 15:50:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Zlsgjfah"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730702AbfHTPuW (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 20 Aug 2019 11:50:22 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:38980 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730661AbfHTPuV (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 20 Aug 2019 11:50:21 -0400
Received: by mail-io1-f65.google.com with SMTP id l7so12432961ioj.6
        for <netfilter-devel@vger.kernel.org>; Tue, 20 Aug 2019 08:50:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=cYZRe+pzlEDD9Va1ELVo5Tsw8eulKPgcH/qwHX2e89Y=;
        b=ZlsgjfahZrTyZV4NLhQQaF2fXjMERZ5lN1amjzOtmamzqCjPdq3yaZtVP7Q08gmEXn
         sWBSdhpOPE5krWTLAp8Lr9VhJGX/YtPV9j2l3HX80CWgOFopuRyFlH9HsbMqhBaI+YHL
         7CtHaGkIBE4+A8cCUgkDeSDlQtsdaC6/Kh6HDk1gDuEuKOetAn6cLRS3pPWcOhHTtRsX
         +gFlTdRle9pnZkINpfWbN8ElfoMztkA75Vi89jaTFaMh1iHVWEL0Fmksqi1fcd2HOGtP
         2rjeri8bHO0YEPZD9RKZPV5aS1eTurXo1Mc9JFRofQF1WQurfAtBAjSbaFs3qRwoWkWq
         gXcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=cYZRe+pzlEDD9Va1ELVo5Tsw8eulKPgcH/qwHX2e89Y=;
        b=OIo4sn7xCjPFdRhwFNEwsD00fNjocSCdK4gZh36FUwuAJ0gLqFOe4wRI6YrzkEcYEx
         yCkVKb4U1EzMjGQqqrr9dB6eNISQ8V6ATZuUsFvDdzpDVXtyg3jRS2Ndp57VrYGYc8FM
         WcIyq9wnuU4+W5MeKvjoImFgdwpjVRCuhRdFRpCr28G/fBcYRjvHsAEM8voqbeE4RxFU
         Mw3lzAiBNY7q82Sg8xCs7LUF5eMFGmDZw69rxboAofIAnjSqBy01PcpHpBqGFuwC7g00
         cHpW8Dfw8Bmu8kvNpUG2XBTSR6tLRMr/OKl0yFhVCBZkNf/rxxrzTzF8+i59OyolqKHS
         8/4A==
X-Gm-Message-State: APjAAAWdrz/NRuv6Pu3mrd2+C+SliKvej+CZc5Oei+iWCV3dnxafTTSB
        4CtWzjb5l2U63+oXYYTZTo1x6cnT+Ah7D3iCn3+3e6MW
X-Google-Smtp-Source: APXvYqwdRyKE+2iwvE0G3NKA80vt7d3spTLOeWw9R13ZbXKKCZ7xfKa7XXwzBFrYBSZBoTWf4jyvL6leu1fCL8zJLw4=
X-Received: by 2002:a5d:8954:: with SMTP id b20mr1219705iot.118.1566316220591;
 Tue, 20 Aug 2019 08:50:20 -0700 (PDT)
MIME-Version: 1.0
From:   Eric Jallot <ejallot@gmail.com>
Date:   Tue, 20 Aug 2019 17:50:08 +0200
Message-ID: <CAMV0XWGubiNxMu_HSgnXMCn75p92dMvLr9E+wBx3gx3gTE6GCA@mail.gmail.com>
Subject: [PATCH nft 2/2] src: secmark: fix missing quotes in selctx strings output
To:     netfilter-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Colon is not allowed in strings and breaks nft -f.
So move to quoted string in selctx output.

Before patch:
 # nft list ruleset > rules.nft; cat rules.nft
 table inet t {
         secmark s {
                 system_u:object_r:ssh_server_packet_t:s0
         }
 }
 # nft flush ruleset
 # nft -f rules.nft
 rules.nft:3:11-11: Error: syntax error, unexpected colon
                system_u:object_r:ssh_server_packet_t:s0
                        ^

After patch:
 # nft list ruleset > rules.nft; cat rules.nft
 table inet t {
         secmark s {
                 "system_u:object_r:ssh_server_packet_t:s0"
         }
 }
 # nft flush ruleset
 # nft -f rules.nft

Fixes: 3bc84e5c ("src: add support for setting secmark")
Signed-off-by: Eric Jallot <ejallot@gmail.com>
---
 src/rule.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/rule.c b/src/rule.c
index 255fe37..e4aee9d 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -1820,7 +1820,7 @@ static void obj_print_data(const struct obj *obj,
                if (nft_output_handle(octx))
                        nft_print(octx, " # handle %" PRIu64,
obj->handle.handle.id);
                nft_print(octx, "%s%s%s", opts->nl, opts->tab, opts->tab);
-               nft_print(octx, "%s", obj->secmark.ctx);
+               nft_print(octx, "\"%s\"", obj->secmark.ctx);
                nft_print(octx, "%s", opts->nl);
                break;
        case NFT_OBJECT_CT_HELPER:

--
1.8.3.1
