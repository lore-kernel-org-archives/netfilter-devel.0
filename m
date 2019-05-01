Return-Path: <SRS0=QQeY=TB=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 401C8C43219
	for <netfilter-devel@archiver.kernel.org>; Wed,  1 May 2019 10:15:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0A55021743
	for <netfilter-devel@archiver.kernel.org>; Wed,  1 May 2019 10:15:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FLSz2jyu"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726224AbfEAKPC (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 1 May 2019 06:15:02 -0400
Received: from mail-ed1-f44.google.com ([209.85.208.44]:38245 "EHLO
        mail-ed1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726243AbfEAKPC (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 1 May 2019 06:15:02 -0400
Received: by mail-ed1-f44.google.com with SMTP id w11so7861784edl.5
        for <netfilter-devel@vger.kernel.org>; Wed, 01 May 2019 03:15:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=GgX5bz7+GGT6eLNRqSlLgLjqnhvNS0No0LV4lbPB+m8=;
        b=FLSz2jyuJjtdAQVux0tKnMw67h3jPf8W77fkoib4/3u3zeprgKuIiVCf5c4Bm+lbc9
         PtlksIKwTY7CnJvYaajglpM677iaJkRZlIBcP7ztTIo9YzThN8d1NxerR2j9mkOc1CKJ
         B8TzT/maS9rISrBRpJ88jCv8YSTF+I1m9r45o2FzA9RVcp9HEQyrRKjyxWx6qoH75npK
         Ygd0WnpTJa/rVOsp8JGeIY7Bh2t2YS39ocj9ibKJGfJITkqNgqOQFq13kruvPDVC0NW0
         6CdoSwMpKHi+0aoIW0sdtLA25giavhbOvgFIopAvuH2F0qYrxtG1Pltv5CxV401cdTWV
         yU8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=GgX5bz7+GGT6eLNRqSlLgLjqnhvNS0No0LV4lbPB+m8=;
        b=Hg6+N4TYphROcPcWza0AuQtCXUhZ/SV68MTR6EyJPVTDNUw4sNR4gvIr4YYi+4YqBs
         J3iDSDynaPkU0WgMEcheoKsJBA5BXqG8VivRdEZFqBtYP55ivtrGuT+QW1pbsC4ueR2Y
         pqd+V3S/8vh2KhhdZo/sHoT4umU3+WjNgHIItKDiX872E/hUbMwwaKjH5zJ45gITJKrC
         GdtmTTdsifaaH+NNo1z3RTc/G3PnR30ID0AEMW0R7LwYIwsDYYFTCaJuhER6Pxq8TjcP
         S8XWGThSsuBulKoQP7nUxj6wrQ9p+B9A9nrcACwkPjnpGSOT2B40OK5DBEnoIKTx752P
         5Llw==
X-Gm-Message-State: APjAAAUwkrSmdq10TUk7c7r8ahM/H0Nl34D4sxK7dFc/ldWMjUwfMK3u
        0ilN0gYXCcQKKlTC1qfCIROG2alLHvyftaENx9nhR07lJ28=
X-Google-Smtp-Source: APXvYqyh9Ci1MMuhQygrC6pymbyp5aUh8HMs4QCzwD2Go9Xxg4lMOxXoCqlrzAAXB+cgISM/K/A2Gi+kcZo6Ih/XbkU=
X-Received: by 2002:a50:cb4d:: with SMTP id h13mr32575565edi.110.1556705700760;
 Wed, 01 May 2019 03:15:00 -0700 (PDT)
MIME-Version: 1.0
From:   Mojtaba <mespio@gmail.com>
Date:   Wed, 1 May 2019 14:44:49 +0430
Message-ID: <CABVi_Ex+sOUcpL61fOz+hP_H=oN9FVU3ds5rLrZUWa70c4iP2Q@mail.gmail.com>
Subject: Problem in libnetfilter_conntrack library
To:     netfilter-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hello,
I am working with libnetfilter_conntrack library to provide my
user-space. I download the current development version from
https://git.netfilter.org/libnetfilter_conntrack/.
In the meantime i tried to run some examples for better understanding.
According to README guide, it should be compiled with "make check" ,
But id doesn't work.
Also i just run one them with cc command like this:
 gcc -c utils/conntrack_dump_filter.c
It compiled successfully but it doesn't work properly.
How can i run them for more understanding?
With Best Regards.Mojtaba
-- 
--Mojtaba Esfandiari.S
