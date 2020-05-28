Return-Path: <SRS0=RvX8=7K=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7BF2C433DF
	for <netfilter-devel@archiver.kernel.org>; Thu, 28 May 2020 18:43:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AEF9C2078C
	for <netfilter-devel@archiver.kernel.org>; Thu, 28 May 2020 18:43:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1590691416;
	bh=LYXtWfNqWbRlHIsJLxFEA9ZSQ83RZwJtt6Vuc/kRjK4=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=FEj73iO781FNKfUdzqevJUic5lrvHA0OgoHJ88CtG38hzhd7t6egkZOWQrs0z5F+i
	 hOqrDo/2+v8rsSalA1LutbDbwK8l+ngAv8j2z5uIp18QYY0FTeUE2+pGLjlLKpSUuf
	 XKGQG38fJ7J8URW2tJu51y6/aLSbuQWHvQrDuT6Y=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391505AbgE1Sng (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 28 May 2020 14:43:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391497AbgE1Snd (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 28 May 2020 14:43:33 -0400
Received: from mail-lf1-x142.google.com (mail-lf1-x142.google.com [IPv6:2a00:1450:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23429C08C5C7
        for <netfilter-devel@vger.kernel.org>; Thu, 28 May 2020 11:43:33 -0700 (PDT)
Received: by mail-lf1-x142.google.com with SMTP id w15so17128272lfe.11
        for <netfilter-devel@vger.kernel.org>; Thu, 28 May 2020 11:43:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=V9I7snvnyR6f67pT5aVMg4qxsNA0F9Vag9hIROGL8vg=;
        b=P8nw8P71cxagqSPVUA9Kzi2wkC951thaYnOwz/e4kiPGKd2Zew+YultOwwJeyFp5h7
         zM7l8zOFEFg42p7pHhMVJLHi7CpftdQASS+eM/OM/B4nVtTeHsdqVgzMglyZy3GmUpst
         EXyW/r86HANnDshbNT+Vi8bmm9fl991ACFIhI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=V9I7snvnyR6f67pT5aVMg4qxsNA0F9Vag9hIROGL8vg=;
        b=UtmllPHrppVL7p4q9is/fnO1kYg9235GrKMBKHG/yixk9CllrzrC1noLyVzk8Syg8A
         ti1xad78e9u1OQ/HSu33gYBJpPncMr1i9m35o/8TU8preLzFpvcZg6ZxyjLVEPc2Mr0r
         MY+YmEdkdQ8QIZEY0PxCIl62ldxVT1N2zydyi5JEzYK5Pi1Mt08luXJzgmL9OrBVEiES
         trFpXcWf+NWuHPCgVDx7OBPJajARivlgGjMLQiz8FY3lMuqOqMqNcZ2YkIU0HqoUOWic
         eR3ZC3Vk2sNmkYBXb5PtxA0yF5n4H9Eykn0sqESCQs9oAAmI9G9XM73yh17V1gucApow
         hRkA==
X-Gm-Message-State: AOAM531yjwL/oA4/vBLN+MO4NWBZYi6mUMu1dyxzUI/n1W73ld5pn9Xi
        b5CPyJdv9QyAvxnPTP/KQZQfGUvEVCk=
X-Google-Smtp-Source: ABdhPJwg/5pASSE+f1PvwiSSuEtImvdq788u8vq8X3B1jckNygsKYj9ZBZTicAueOP/C9xz9QHx/hA==
X-Received: by 2002:a19:642:: with SMTP id 63mr2355893lfg.173.1590691410792;
        Thu, 28 May 2020 11:43:30 -0700 (PDT)
Received: from mail-lj1-f177.google.com (mail-lj1-f177.google.com. [209.85.208.177])
        by smtp.gmail.com with ESMTPSA id v22sm1583174ljj.75.2020.05.28.11.43.29
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 28 May 2020 11:43:29 -0700 (PDT)
Received: by mail-lj1-f177.google.com with SMTP id a25so23075957ljp.3
        for <netfilter-devel@vger.kernel.org>; Thu, 28 May 2020 11:43:29 -0700 (PDT)
X-Received: by 2002:a2e:b16e:: with SMTP id a14mr2040017ljm.70.1590691409213;
 Thu, 28 May 2020 11:43:29 -0700 (PDT)
MIME-Version: 1.0
References: <20200528054043.621510-1-hch@lst.de> <20200528054043.621510-10-hch@lst.de>
In-Reply-To: <20200528054043.621510-10-hch@lst.de>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Thu, 28 May 2020 11:43:13 -0700
X-Gmail-Original-Message-ID: <CAHk-=wgpnR9sBeie_z0xA3mYzG50Oiw1jZjyHt0eLX6p45ARvQ@mail.gmail.com>
Message-ID: <CAHk-=wgpnR9sBeie_z0xA3mYzG50Oiw1jZjyHt0eLX6p45ARvQ@mail.gmail.com>
Subject: Re: [PATCH 09/14] fs: don't change the address limit for ->write_iter
 in __kernel_write
To:     Christoph Hellwig <hch@lst.de>
Cc:     Al Viro <viro@zeniv.linux.org.uk>, Ian Kent <raven@themaw.net>,
        David Howells <dhowells@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        LSM List <linux-security-module@vger.kernel.org>,
        NetFilter <netfilter-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, May 27, 2020 at 10:41 PM Christoph Hellwig <hch@lst.de> wrote:
>
> -ssize_t __kernel_write(struct file *file, const void *buf, size_t count, loff_t *pos)
> +ssize_t __kernel_write(struct file *file, const void *buf, size_t count,
> +               loff_t *pos)

Please don't do these kinds of pointless whitespace changes.

If you have an actual 80x25 vt100 sitting in a corner, it's not really
conducive to kernel development any more.

Yes, yes, we'd like to have shorter lines for new code, but no, don't
do silly line breaks that just makes old code look and grep worse.

             Linus
