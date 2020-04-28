Return-Path: <SRS0=gJ4i=6M=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8AABC83000
	for <netfilter-devel@archiver.kernel.org>; Tue, 28 Apr 2020 22:16:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A802C20730
	for <netfilter-devel@archiver.kernel.org>; Tue, 28 Apr 2020 22:16:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=paul-moore-com.20150623.gappssmtp.com header.i=@paul-moore-com.20150623.gappssmtp.com header.b="JSVaWkif"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727097AbgD1WQG (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 28 Apr 2020 18:16:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726291AbgD1WQF (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 28 Apr 2020 18:16:05 -0400
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A2A6C03C1AD
        for <netfilter-devel@vger.kernel.org>; Tue, 28 Apr 2020 15:16:04 -0700 (PDT)
Received: by mail-ej1-x641.google.com with SMTP id s9so199834eju.1
        for <netfilter-devel@vger.kernel.org>; Tue, 28 Apr 2020 15:16:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=PnnqL1409FTplYbdxZXMGWIU/LS1S0bA0+MaHJS3rik=;
        b=JSVaWkifSMAbvB+qkRZCIScM82BWlcqEIYeDgxRWwMT/zTYljYYd/0oFc407HRKsS6
         gpiiZ+4GT7XLDZj0WdwfjuX27ceruASro/HQ9B+Q3yBd4T6uebOCCOPHcYtnoiww5ab3
         NDl1uDlTaCfaRKd6SWgc+FO0h+qlcrC4OTNu8hBjJ0pQF0KGDBYhKWicE4hvsuBA4hwk
         A8tlhmnd00/JjQd13nEJDSdQMGjubHlpZH9yFkpe+FY5PWskWdcQa/Vix1O3pfFca2za
         LpsqqNijHOrrWiVMLCLiOTVWLrH+rPNQFGNZw9BRwXueT1/V6r3PuN5w/xztiESdPDq/
         gxgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PnnqL1409FTplYbdxZXMGWIU/LS1S0bA0+MaHJS3rik=;
        b=qLgV1edc6U+CrMuPIxLxb60kQ84M8JAaf4JDjquLUnhEXt3WcCEFGBA6IzaWdUsOAf
         MVSgnju6ictjbgiRbXO0C7nHenqttXn2IWpgncquGJy9IJ2jvgCSyE4tko5whpk/a8U3
         9nUEq2P3I2eqxCb+w/bQmxZYcYrD0ls7+9zWckm98lrCpxcikdrt0pRJRb02tdFgLSsO
         Rw3jlp4yZwaVtqADHoKbhY6zHcJ4tlGCpvbERBtV9fV3z5m6LQt73wuQHz9uALFyLbar
         AIus3UhLOeW+fOjcLT8XSXF2+3gqR4+iEsdeXIbNyOdjyCLvJ8OwGAhm1wyOlAg5OgAm
         QGww==
X-Gm-Message-State: AGi0PuYUlP1PgrUCsR3fGxU3cO324Hl/EfwdOr6xmU/8nT8/Lg+fmWAU
        8qxdMfr8U+ye3WVd6jTgKVERlAu+8pTz1pdAEXybGZ8=
X-Google-Smtp-Source: APiQypKYPfWFJVQAq/qz8yuzktFBrdOoFdA8P09VBub3DtaP5z/FDVGTygaTpOb+BmDJjKEvjz4La4ZvC8rdqOKMOwI=
X-Received: by 2002:a17:906:29c4:: with SMTP id y4mr26782535eje.95.1588112163155;
 Tue, 28 Apr 2020 15:16:03 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1587500467.git.rgb@redhat.com> <e75f9c91a251278979182f0181d3595d3bb3b2b8.1587500467.git.rgb@redhat.com>
In-Reply-To: <e75f9c91a251278979182f0181d3595d3bb3b2b8.1587500467.git.rgb@redhat.com>
From:   Paul Moore <paul@paul-moore.com>
Date:   Tue, 28 Apr 2020 18:15:52 -0400
Message-ID: <CAHC9VhTfJ0u_wtRpGhBWd3YyE4nZwv4VmPC_oeZbMAZ9qi4bkg@mail.gmail.com>
Subject: Re: [PATCH ghak25 v4 2/3] netfilter: add audit table unregister actions
To:     Richard Guy Briggs <rgb@redhat.com>
Cc:     Linux-Audit Mailing List <linux-audit@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        netfilter-devel@vger.kernel.org, sgrubb@redhat.com,
        omosnace@redhat.com, fw@strlen.de, twoerner@redhat.com,
        Eric Paris <eparis@parisplace.org>, ebiederm@xmission.com,
        tgraf@infradead.org
Content-Type: text/plain; charset="UTF-8"
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Apr 22, 2020 at 5:40 PM Richard Guy Briggs <rgb@redhat.com> wrote:
>
> Audit the action of unregistering ebtables and x_tables.
>
> See: https://github.com/linux-audit/audit-kernel/issues/44
> Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
> ---
>  include/linux/audit.h           | 1 +
>  kernel/auditsc.c                | 5 +++--
>  net/bridge/netfilter/ebtables.c | 2 ++
>  net/netfilter/x_tables.c        | 2 ++
>  4 files changed, 8 insertions(+), 2 deletions(-)

Merged into audit/next, thanks.

-- 
paul moore
www.paul-moore.com
