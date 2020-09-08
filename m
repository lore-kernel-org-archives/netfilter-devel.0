Return-Path: <SRS0=572t=CR=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6251AC433E2
	for <netfilter-devel@archiver.kernel.org>; Tue,  8 Sep 2020 17:53:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 231302078B
	for <netfilter-devel@archiver.kernel.org>; Tue,  8 Sep 2020 17:53:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HktnVl3J"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731656AbgIHRwi (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 8 Sep 2020 13:52:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731631AbgIHQNo (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 8 Sep 2020 12:13:44 -0400
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D362FC0612A4
        for <netfilter-devel@vger.kernel.org>; Tue,  8 Sep 2020 06:05:38 -0700 (PDT)
Received: by mail-io1-xd43.google.com with SMTP id u6so7050937iow.9
        for <netfilter-devel@vger.kernel.org>; Tue, 08 Sep 2020 06:05:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=iEeqc7izn1gfQDcpn1vS0AEKGEVlFCoidzpeUAn3nuQ=;
        b=HktnVl3JUpc47IjAXaLdUkTcu5uSHRpPVcerINmHDjjwFw6KNnfpvJWZHO/6mNhguU
         yaaprGCTuYDd2zFS596+KNDoMcW7P0z0ScNZywkXD7asB7j6Fh0u/ktCx7DHvewcTbR4
         9wNuh0sKAXhHxkLGMmh+UF/+FfS9D8FO8mC/PlO0w1D57PX2ltox5nGU2ZN3HEe4GWpm
         TK6js6i6v22qQ7zVrw6Bvu1GNAvgNL73UYHaxjcrHCmu8vRkFb2FDani3+v8W2nX7Q0l
         Kv91ziC2Ugoe+lwulA/M4UVyIxf4JroMtNmhWHPDavHHFG3MYZjiu564f28SPehAonwI
         abJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=iEeqc7izn1gfQDcpn1vS0AEKGEVlFCoidzpeUAn3nuQ=;
        b=qaE7bbMClv/dgloIIYfARphfdHh+D4QFLefQ2bV8SamDzkmUglHwjl1JPCgMvGslmP
         kJep0d0K/di+bvLoRCiNegqrkQJV46RTOEmf19BHUYcTqowwoMqQWlEcaybOzz/oudBD
         ByJDNyb2oonf/AxHxVUzlzbezUGdeDNUi0cY0kqax117HsFaqlpDYQKqIOdQ0CQJL+WC
         XckRulkwP4ql0bMUv38kkIKf9A6uvMVpZ0GLZa+SSN5AyhMPelHqzwUEGESzyVo4q/gd
         J/XmmY17SqhDwXQ3WbZWTHqsnzk+IHX8bXrUOkkUXujzhaSkdj4gZFGSbMA6/ov8aW5m
         elDQ==
X-Gm-Message-State: AOAM533zyeQQuaXHWvspsJ6Sj3PMhe1O/o1DLdyoc66a0xhkR5PpdgJv
        JkaxCia5v8CC3fGefoL+izNoY8BLVE9JjNsWhmGhNFzFYxA=
X-Google-Smtp-Source: ABdhPJxUvQA2DHHxI/YKdbSTv3D8YGu0CykzL/jAJEla+HY5NSoNy7dPacw+9W+BTVIh7si/mubHH7Av1XLP00+3RJU=
X-Received: by 2002:a05:6638:210f:: with SMTP id n15mr22537928jaj.41.1599570338020;
 Tue, 08 Sep 2020 06:05:38 -0700 (PDT)
MIME-Version: 1.0
From:   Gopal Yadav <gopunop@gmail.com>
Date:   Tue, 8 Sep 2020 18:35:27 +0530
Message-ID: <CAAUOv8iRkeAVDn3UK8DHju+-RvWViopGajN_+9y+Rm30pTWa+A@mail.gmail.com>
Subject: [nftables] TODO: Replace yy_switch_to_buffer by yypop_buffer_state
 and yypush_buffer_state
To:     netfilter-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Netfilter Team,

I am looking to resolve a todo task in function yy_switch_to_buffer in
nftables/src/scanner.c file.
I am not familiar with lex but searching around I found that scanner.c
is produced by lex according to the scanner.l file.
Therefore my guess is, changing the scanner.c file directly is not the
solution, right?
Changes would have to be done in scanner.l, right?
How should I proceed to complete this todo?

I browsed bugzilla to find some other issues to solve, but I feel
lost. Are there any beginner friendly issues to solve or any other
starting point?

Thanks
Gopal
