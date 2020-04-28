Return-Path: <SRS0=gJ4i=6M=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1CB03C83004
	for <netfilter-devel@archiver.kernel.org>; Tue, 28 Apr 2020 22:15:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F06C12072A
	for <netfilter-devel@archiver.kernel.org>; Tue, 28 Apr 2020 22:15:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=paul-moore-com.20150623.gappssmtp.com header.i=@paul-moore-com.20150623.gappssmtp.com header.b="mm3kqkdC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726312AbgD1WPi (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 28 Apr 2020 18:15:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726291AbgD1WPf (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 28 Apr 2020 18:15:35 -0400
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92DC6C03C1AD
        for <netfilter-devel@vger.kernel.org>; Tue, 28 Apr 2020 15:15:34 -0700 (PDT)
Received: by mail-ej1-x642.google.com with SMTP id a2so181976ejx.5
        for <netfilter-devel@vger.kernel.org>; Tue, 28 Apr 2020 15:15:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=qXp1I6HH/Av+hIwjTztKPUJHlaLNrd82Kk+BvbSp5Bg=;
        b=mm3kqkdC+EWN6cCtmnWpNqxp2ySzDqRbJZ7+w1bSCQSTA3qxENuw9e0df0/6tHEQ/4
         5OBPzZ7D3LrqmAkBGte9uquywy5hghC5AV0DkLK/rvvtljsGi7DmtqIyoQnzwLAZU6Lv
         SWfQshcKQ4jPn66HCtTBqY0wiR7w2vG0DdDs9pJ7yL6/Bl/npmIEWwbR6dU5dr9gFKi+
         HfOK1q1XbS7BbgFDX9dF+3opV31KLklT1yeIPmJt2/NuPlYGZDQn1ZuCVZkF0YD2N/wK
         6958w72b83xb9YvktEIrP66m8d5FMq/Yjo7PtVBI4TlKSZ8gsrwuRwp/oNx5ahsQlXx8
         D+Zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qXp1I6HH/Av+hIwjTztKPUJHlaLNrd82Kk+BvbSp5Bg=;
        b=pkDo7+/wuVQmHPnsGYf0Mviq3e/oRoUMZslJdhuAy0urVZWHZ5NqzJtZi3wqBsG1PC
         IZKlN7/0bQFmOZ85wNUVilk+ZRMi0X4puD980JSRcoZ8Kf51UFKeY7M1atM27JoPgmCM
         S/A/t8jiXLa/2+ScWYmXdhTnI2wTq07jrEIRGGxDsljBbTBJe7rBYWntmWPiw0ZFfzFt
         DkYIDlpXYI3GCIoH/kabxdTr8a2pIN44AWSdRiAm4JncEJNNO1JqWEeIbOZArghMD69q
         6T4+W/zUDX8vR6SMupa/MRBALS6fV0ZanwUYFJcr+PGLiNnjqd9uta1hiFq6W1Llb6QQ
         T05w==
X-Gm-Message-State: AGi0PuZacU/VNq/sWPvtntsuXxRlxKeiObjo7948wZbgemH/+Pwk/5TC
        jJIMxz4fFBDiSMuMgSak4ZeZAe4mhAdI+4hWkeCNb0c=
X-Google-Smtp-Source: APiQypKItbOYLluWf/Xq3D81mI8VPZ2D1qUNRDymz1VnlMeA6yrBY3d7Oyzty7KYlstf868GeukM9WpAoQE7x9f7el8=
X-Received: by 2002:a17:906:f106:: with SMTP id gv6mr27400254ejb.271.1588112133067;
 Tue, 28 Apr 2020 15:15:33 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1587500467.git.rgb@redhat.com> <97d8dabf45ee191bc4b51dea2ae27d34fd5ea40d.1587500467.git.rgb@redhat.com>
In-Reply-To: <97d8dabf45ee191bc4b51dea2ae27d34fd5ea40d.1587500467.git.rgb@redhat.com>
From:   Paul Moore <paul@paul-moore.com>
Date:   Tue, 28 Apr 2020 18:15:22 -0400
Message-ID: <CAHC9VhRoUntHAhdmkhMOE661rS2_6VK-zL_F8ZxiqGswLQ77UA@mail.gmail.com>
Subject: Re: [PATCH ghak25 v4 1/3] audit: tidy and extend netfilter_cfg
 x_tables and ebtables logging
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
> NETFILTER_CFG record generation was inconsistent for x_tables and
> ebtables configuration changes.  The call was needlessly messy and there
> were supporting records missing at times while they were produced when
> not requested.  Simplify the logging call into a new audit_log_nfcfg
> call.  Honour the audit_enabled setting while more consistently
> recording information including supporting records by tidying up dummy
> checks.
>
> Add an op= field that indicates the operation being performed (register
> or replace).
>
> Here is the enhanced sample record:
>   type=NETFILTER_CFG msg=audit(1580905834.919:82970): table=filter family=2 entries=83 op=replace
>
> Generate audit NETFILTER_CFG records on ebtables table registration.
> Previously this was being done for x_tables registration and replacement
> operations and ebtables table replacement only.
>
> See: https://github.com/linux-audit/audit-kernel/issues/25
> See: https://github.com/linux-audit/audit-kernel/issues/35
> See: https://github.com/linux-audit/audit-kernel/issues/43
>
> Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
> ---
>  include/linux/audit.h           | 21 +++++++++++++++++++++
>  kernel/auditsc.c                | 24 ++++++++++++++++++++++++
>  net/bridge/netfilter/ebtables.c | 12 ++++--------
>  net/netfilter/x_tables.c        | 12 +++---------
>  4 files changed, 52 insertions(+), 17 deletions(-)

Merged into audit/next, thanks.

-- 
paul moore
www.paul-moore.com
