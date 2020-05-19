Return-Path: <SRS0=LRg4=7B=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC78BC433DF
	for <netfilter-devel@archiver.kernel.org>; Tue, 19 May 2020 19:18:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B688C20758
	for <netfilter-devel@archiver.kernel.org>; Tue, 19 May 2020 19:18:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=paul-moore-com.20150623.gappssmtp.com header.i=@paul-moore-com.20150623.gappssmtp.com header.b="aL74m/ak"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727000AbgESTSg (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 19 May 2020 15:18:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726059AbgESTSg (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 19 May 2020 15:18:36 -0400
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11C14C08C5C0
        for <netfilter-devel@vger.kernel.org>; Tue, 19 May 2020 12:18:36 -0700 (PDT)
Received: by mail-ej1-x641.google.com with SMTP id s3so286729eji.6
        for <netfilter-devel@vger.kernel.org>; Tue, 19 May 2020 12:18:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=pwDvf5G6HSaQ20Oxj0p6X54Wu/x0ouoEho2X1JQouNk=;
        b=aL74m/akDHaUWo5DAGjBl2jfoa794VKfiSki1M36FYTwo9YSo59CMBv/99InzLpL/G
         +7bB/+sII5PnN82+4x8MI41VhKSZRJhRKIyl/uZjJXfGPM6l4GX1/QJlMHeYVcsSpXFl
         wiuYrMgqIe5WbM6vXOjKN+fQ7jY/sLkvgVzU6w7BZO+qrL+9RS5hQ4oPfUUjw/jBJiWT
         lgKeV6RdJcYPdZ1ikTnTr1qiSAXLJsrWc0aSIGhxLYqdbKPeNy74eMNqRrcxX539grw1
         vi3Z5ac6eRp6dL45/+2koWyZBj74tbhta40NiTnV4/SUaSRQ02x4RWgnFS6TjaTj8ffw
         u2qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=pwDvf5G6HSaQ20Oxj0p6X54Wu/x0ouoEho2X1JQouNk=;
        b=VKAxdAVXC8uXXcKDPYScL5VFcU9fEne+Zlqo73cSc6Q5G7IO0Z4+FamhyDK6h1GHmf
         iyruekeBr9EzLLw0VaSBiYa3gb9QOosJ3IxDMQEZeyqGp8t53QS6KGD0oR9afFcm4aQ5
         vJ9nNFk4ihE6vAI5K2xpsUwZdDNPLWX5bp5lgCceLU+NgUVLEAHPECcodgGQ3TZbtlJH
         VYPvo3DCOe3QrXaqkMS0XybiQF3kaYLpaSviIA0Zt9yQC1nYqdnSpaY19itfMvua3cd5
         lL6N19fLuFNuU3R1le7XeJ+iSdL+RuUod6kMF66ktW1ITUs1iIQa1BgXOZmjSQFe0chm
         MAVg==
X-Gm-Message-State: AOAM532EO3u5oAn6r1xh6tBIe4O0xFYT2pu0roIeiW42lEIDOXSZTn/+
        IQJaDvpEzdCH52Mn3SiLkeXWC2EdflyeTScmbqqg
X-Google-Smtp-Source: ABdhPJwIXuucs0DGivH6PwCdg07KxPMElgAI2ADtY9VUQAv/qt4fe3j2mqb2tBpIQWZ5V2ksbjrenTScUT/dJ6h48BY=
X-Received: by 2002:a17:907:40f1:: with SMTP id no1mr689589ejb.178.1589915914530;
 Tue, 19 May 2020 12:18:34 -0700 (PDT)
MIME-Version: 1.0
References: <2794b22c0b88637a4270b346e52aeb8db7f59457.1589853445.git.rgb@redhat.com>
In-Reply-To: <2794b22c0b88637a4270b346e52aeb8db7f59457.1589853445.git.rgb@redhat.com>
From:   Paul Moore <paul@paul-moore.com>
Date:   Tue, 19 May 2020 15:18:23 -0400
Message-ID: <CAHC9VhQYUooJbZ9tcOOwb=48LTjtnfo0g11vQuyLzoxdetaxnw@mail.gmail.com>
Subject: Re: [PATCH ghak25 v5] audit: add subj creds to NETFILTER_CFG record
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

On Tue, May 19, 2020 at 11:31 AM Richard Guy Briggs <rgb@redhat.com> wrote:
>
> Some table unregister actions seem to be initiated by the kernel to
> garbage collect unused tables that are not initiated by any userspace
> actions.  It was found to be necessary to add the subject credentials to
> cover this case to reveal the source of these actions.  A sample record:
>
> The tty, ses and exe fields have not been included since they are in the
> SYSCALL record and contain nothing useful in the non-user context.
>
>   type=NETFILTER_CFG msg=audit(2020-03-11 21:25:21.491:269) : table=nat family=bridge entries=0 op=unregister pid=153 uid=root auid=unset subj=system_u:system_r:kernel_t:s0 comm=kworker/u4:2

Based on where things were left in the discussion on the previous
draft, I think it would be good if you could explain a bit why the uid
and auid fields are useful here.

-- 
paul moore
www.paul-moore.com
