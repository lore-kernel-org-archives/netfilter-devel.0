Return-Path: <SRS0=ly5L=WQ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86B9CC3A589
	for <netfilter-devel@archiver.kernel.org>; Tue, 20 Aug 2019 15:50:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5CC6322CE3
	for <netfilter-devel@archiver.kernel.org>; Tue, 20 Aug 2019 15:50:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YuwCdT5/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730686AbfHTPuU (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 20 Aug 2019 11:50:20 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:36337 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729820AbfHTPuT (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 20 Aug 2019 11:50:19 -0400
Received: by mail-io1-f65.google.com with SMTP id o9so13184300iom.3
        for <netfilter-devel@vger.kernel.org>; Tue, 20 Aug 2019 08:50:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=3yp74A9rh1veF+3uWG8H/C7kIb/ZNnwSf+btoSYAKwc=;
        b=YuwCdT5/6XOBnWqCOcAhgxj59yuXmxHhyN3UfDHla+NrWz9+BmsKWW6+uPUwNBzKcg
         N9tW2Zfns7nYUrrqL7TLIqbSG2tsyTo3VNjizk3tYXa9uYoWUZfe9LvB96HR+5n5mgqk
         TqlTz61gV8FV1ycnnxgiiqhLPsan/dBaIYXywzpxoexUjLPFNtLw9a/TOF2dsWCvc0mk
         n5XJCoCz0dbvGFSFxVQQpVubYBKqG7eRSEnefwYFQUTQVYn8P+hRZ7f8XuqP4AmtdZgW
         oScItPtRJtIX3Q81jSAS5EA27n2L3XzkQq3ZGa4yQQSs6Vj7XeiPJsZL2gd9FE1fgCDm
         c40w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=3yp74A9rh1veF+3uWG8H/C7kIb/ZNnwSf+btoSYAKwc=;
        b=bAyWtu364hQSd7VyKmrC+aidwtkuUpMT4fPXACvQbtoQQVuQ0AFEDRTEMYM9lQe1GX
         nhAbz+el0Mh/XJSxKiB7ww4xOWnkuFaVgQLUrm0343BwrL8Kk19iYnoOHbZNjpxTmLos
         xcTrXr6mokwBh+nLt72GrCwMWr4nO/H+LMmnrrkTdCW7xrRtsOYZnsvQ/oYAHWhIYThy
         0jjS+Mcl0cBkzJHPXztbiajLlGbmV1c7aqDJSBrD6DDk2JnF5XLkXxK3rNegj1/qvyL5
         Dg33hXJ6g7+veX7EOM7lGitpfn4O2GCP8FijlBL/FCisOwGrwiSt0VGo/v719CiJDp2c
         B8jA==
X-Gm-Message-State: APjAAAUSB/S8Uq/pkz4qR+OtvUz01oE2QRQN1DAMckdTIbj2B+SaMb3N
        1yfORHnKtapszTDlf2aRsYSMezpOdRNOzCwtJyxG6kzy
X-Google-Smtp-Source: APXvYqzMaKTYQIGwmkdSban//KYOMXn4xffWmykYfqI40UD5Ky9ci/C2AAuUgSUlR7voyDf2Zd3fJW24iIhGNhWlHME=
X-Received: by 2002:a5d:8913:: with SMTP id b19mr12814055ion.83.1566316218491;
 Tue, 20 Aug 2019 08:50:18 -0700 (PDT)
MIME-Version: 1.0
From:   Eric Jallot <ejallot@gmail.com>
Date:   Tue, 20 Aug 2019 17:50:05 +0200
Message-ID: <CAMV0XWFgyO+4XmzyscM7eTPR4ZubLpA0hChU4De0qw+UL_PBvg@mail.gmail.com>
Subject: [PATCH nft 1/2] src: secmark: fix brace indentation in object output
To:     netfilter-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Before patch:
 # nft list secmarks
 table inet t {
        secmark s {
                system_u:object_r:ssh_server_packet_t:s0        }
 }

After patch:
 # nft list secmarks
 table inet t {
         secmark s {
                 system_u:object_r:ssh_server_packet_t:s0
         }
 }

Fixes: 3bc84e5c ("src: add support for setting secmark")
Signed-off-by: Eric Jallot <ejallot@gmail.com>
---
 src/rule.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/src/rule.c b/src/rule.c
index 5655e8c..255fe37 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -1821,6 +1821,7 @@ static void obj_print_data(const struct obj *obj,
                        nft_print(octx, " # handle %" PRIu64,
obj->handle.handle.id);
                nft_print(octx, "%s%s%s", opts->nl, opts->tab, opts->tab);
                nft_print(octx, "%s", obj->secmark.ctx);
+               nft_print(octx, "%s", opts->nl);
                break;
        case NFT_OBJECT_CT_HELPER:
                nft_print(octx, " %s {", obj->handle.obj.name);

--
1.8.3.1
