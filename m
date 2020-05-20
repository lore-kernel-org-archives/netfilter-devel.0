Return-Path: <SRS0=7yxH=7C=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB112C433DF
	for <netfilter-devel@archiver.kernel.org>; Wed, 20 May 2020 22:24:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B04DA2072C
	for <netfilter-devel@archiver.kernel.org>; Wed, 20 May 2020 22:24:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=paul-moore-com.20150623.gappssmtp.com header.i=@paul-moore-com.20150623.gappssmtp.com header.b="msVBo6vx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728435AbgETWYg (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 20 May 2020 18:24:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728190AbgETWYg (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 20 May 2020 18:24:36 -0400
Received: from mail-ed1-x543.google.com (mail-ed1-x543.google.com [IPv6:2a00:1450:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03414C061A0F
        for <netfilter-devel@vger.kernel.org>; Wed, 20 May 2020 15:24:35 -0700 (PDT)
Received: by mail-ed1-x543.google.com with SMTP id g9so4956361edr.8
        for <netfilter-devel@vger.kernel.org>; Wed, 20 May 2020 15:24:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=gSA5WX2rtYW1qr92WeUFtesNCfHgIL2bBAZXuvDm0SU=;
        b=msVBo6vx1uLY8kixELthZHbZQmWYjR6LF1IP0asJUxfiblGt0twNVtio+IPlD9s69X
         dslHn7W89LjVlaIduTLjqvnwMoWiIRjsBwC+diTsfQbYQbSFgftrsLRJsfwcOFryamx7
         lKrtGGSmAP7yGPH95pSfbNt1PaFVu4mof4iN6z9kimmZ/Bt+fuMdDtaK/0rgudeoulwC
         NTLW6ZpFcZdwQbTyd5IcOWyiF6kwwdx00mpP5CwgO4bApAJpgB+D+/rkXD/SMxBxm9Ev
         peaLzBDsTISSXMBWhBu2Mrn0L1dCViPGzWd4jJwTM3abixQPq925CqueoicY9gsf5Wz6
         Ymgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=gSA5WX2rtYW1qr92WeUFtesNCfHgIL2bBAZXuvDm0SU=;
        b=YSwG+fiUjAl7REvUNjjisMxmZuqpbjbC3fuvu7VPxqgaY+ogOp5IX/e2knF6Q4bjm2
         T5yIs5TeJVtCgDkPq+mYVjTT6g6zEDY+eGqi0IhYdJ+aVcuEw1eO9ztzqtz7D9PJEYCA
         LbMNbE6FNk8o+0mvdnC1sHwecs3rHHdPt/le/xbNVN9Lfr+GyGHJzUETyc+ftbH/8dkK
         J3E16rbz4m/Qi4sVXnHRHFVig7eux4Qfu7MONrM0/IIeqFKk/2ZGVPfUzL89TYC+XL+g
         mZ16Go+6j459NED6bprMrSwX7W9wrqfJW4KkZs3uetVPpMuiMYYZud7YmBokGDdbi6qq
         mqHw==
X-Gm-Message-State: AOAM533aiO89KmuUE0JFyg7CmnA2c3SsQz1PRlZaKX7uWs4M8q497Vwv
        taQUOVKgFnfMPnLy4AdIqYIOQRCaibZY2j9C4vGV
X-Google-Smtp-Source: ABdhPJwyqUoPXRS1K83vaC0amG6iqYApHCZJSf4TceWjICSJ1ftF4STVZFMnk8HOeRoFwUQbHOTEDke4sib5YKcAtW4=
X-Received: by 2002:a05:6402:14d3:: with SMTP id f19mr5159480edx.135.1590013474492;
 Wed, 20 May 2020 15:24:34 -0700 (PDT)
MIME-Version: 1.0
References: <6404938413ca29b0e0196dd74bacb9b0c1cb6f42.1589993784.git.rgb@redhat.com>
In-Reply-To: <6404938413ca29b0e0196dd74bacb9b0c1cb6f42.1589993784.git.rgb@redhat.com>
From:   Paul Moore <paul@paul-moore.com>
Date:   Wed, 20 May 2020 18:24:23 -0400
Message-ID: <CAHC9VhT9MBseD87hOq-9FN7-fdKEPn5bcvUYiX3S3Nu4EJwiig@mail.gmail.com>
Subject: Re: [PATCH ghak25 v6a] audit: add subj creds to NETFILTER_CFG record
 to cover async unregister
To:     Richard Guy Briggs <rgb@redhat.com>
Cc:     Linux-Audit Mailing List <linux-audit@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        netfilter-devel@vger.kernel.org, sgrubb@redhat.com,
        Ondrej Mosnacek <omosnace@redhat.com>, fw@strlen.de,
        twoerner@redhat.com, Eric Paris <eparis@parisplace.org>,
        tgraf@infradead.org
Content-Type: text/plain; charset="UTF-8"
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, May 20, 2020 at 2:47 PM Richard Guy Briggs <rgb@redhat.com> wrote:
>
> Some table unregister actions seem to be initiated by the kernel to
> garbage collect unused tables that are not initiated by any userspace
> actions.  It was found to be necessary to add the subject credentials to
> cover this case to reveal the source of these actions.  A sample record:
>
> The uid, auid, tty, ses and exe fields have not been included since they
> are in the SYSCALL record and contain nothing useful in the non-user
> context.
>
> Here are two sample orphaned records:
>
>   type=NETFILTER_CFG msg=audit(2020-05-20 12:14:36.505:5) : table=filter family=ipv4 entries=0 op=register pid=1 subj=kernel comm=swapper/0
>
>   type=NETFILTER_CFG msg=audit(2020-05-20 12:15:27.701:301) : table=nat family=bridge entries=0 op=unregister pid=30 subj=system_u:system_r:kernel_t:s0 comm=kworker/u4:1
>
> Signed-off-by: Richard Guy Briggs <rgb@redhat.com>

Merged into audit/next, thanks Richard.

-- 
paul moore
www.paul-moore.com
