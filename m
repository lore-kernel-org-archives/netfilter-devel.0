Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3DD43C2BB3F
	for <netfilter-devel@archiver.kernel.org>; Mon, 20 Nov 2023 21:26:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230310AbjKTV0E (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 20 Nov 2023 16:26:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231745AbjKTV0D (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 20 Nov 2023 16:26:03 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EB77F4
        for <netfilter-devel@vger.kernel.org>; Mon, 20 Nov 2023 13:25:59 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id 98e67ed59e1d1-280260db156so3882774a91.2
        for <netfilter-devel@vger.kernel.org>; Mon, 20 Nov 2023 13:25:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1700515559; x=1701120359; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references
         :mail-followup-to:reply-to:message-id:subject:cc:to:date:from:sender
         :from:to:cc:subject:date:message-id:reply-to;
        bh=TAGqBbU9xD8oABRQ+y39Py2BF8EOFMjc7mxg0KuC1Kk=;
        b=cJrsMy4oNkWsFAATeK+ENS78IEHb88qQDrjx9uoah3/RXXSrZu1CH3/BV/+TMB54R6
         n87by/y3T134wseLYiI4iXFXuL8hhtoeFQdX8jP7q5zp18ohy+tn+z/MJKaQW6dHHnI3
         EV/uqid4ggdTRQ9jlMlwRaOAM4pX4XcJmQWZdbXXl+MhKkyvfXG64mReYvFC7ZdGDMZt
         aFs4ZbXL0VDWbkKHkbIvedaE1bt9an7OjruqaVl4mLPS0W/vMkkqx1rmbcN0HwgYzjBy
         VY8fwW0ImTqa7ErWGByYKCkRFm3UZYofSxuqR23dC84AeV0wVHnDp/SY7z5KOVI0oVZ6
         JgBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700515559; x=1701120359;
        h=in-reply-to:content-disposition:mime-version:references
         :mail-followup-to:reply-to:message-id:subject:cc:to:date:from:sender
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=TAGqBbU9xD8oABRQ+y39Py2BF8EOFMjc7mxg0KuC1Kk=;
        b=JeKeymekIJ3L57LCLCYdFPn9kgWLZAmMZIghEbisrHymAXLo/taZ/liPHhtE4FgX3D
         3KvogIxmMuCjGaORT5VNN8yL7IwOgs83/WQtb0HkMFq8N7c2shmxW4zFqT05ioc6XIBM
         X8Kuq6HUmskR5Y/LrcYFEyYuT8bWZ4JoMQTQd0RGj3bdSIfBySxDlbmg+jndcixODBE1
         r4s8AMGoE8GARv+NWTb+i1QzeWfa7gvA3tPSCz3J7665ALQ2a6j3A18e+2EIhNOVvz25
         Y4o4jiiSmH2k8ITMcc5t3/ysxp4MFwmFxiOb47PAA6d0f1tY7PzcuvO0p5Hu6hqaMFmR
         W2nQ==
X-Gm-Message-State: AOJu0YytqLqFtd6mNQYQ47+50SXLF8r0gatyW9xyVhqUmwZcZiQkQDUH
        +eJ7T9yOZFevJJPcT1NknK5PNuHAbek=
X-Google-Smtp-Source: AGHT+IHDYSL1sud7iEoJaGK1ny6tk6B+pPNEmb1dRFS+VkWoyIqcZqqYXqzpIJoXsViHaPA3fVa0eA==
X-Received: by 2002:a17:90a:3ee2:b0:27d:2108:af18 with SMTP id k89-20020a17090a3ee200b0027d2108af18mr8995940pjc.25.1700515558616;
        Mon, 20 Nov 2023 13:25:58 -0800 (PST)
Received: from slk15.local.net (n58-108-90-185.meb1.vic.optusnet.com.au. [58.108.90.185])
        by smtp.gmail.com with ESMTPSA id u6-20020a17090add4600b0027d0adf653bsm6115386pjv.7.2023.11.20.13.25.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Nov 2023 13:25:57 -0800 (PST)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From:   Duncan Roe <duncan_roe@optusnet.com.au>
X-Google-Original-From: Duncan Roe <dunc@slk15.local.net>
Date:   Tue, 21 Nov 2023 08:25:54 +1100
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Netfilter Development <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH libnetfilter_queue v3 1/1] src: Add nfq_nlmsg_put2() -
 user specifies header flags
Message-ID: <ZVvO4v45kMwbti2K@slk15.local.net>
Reply-To: duncan_roe@optusnet.com.au
Mail-Followup-To: Pablo Neira Ayuso <pablo@netfilter.org>,
        Netfilter Development <netfilter-devel@vger.kernel.org>
References: <ZVSkE1fzi68CN+uo@calendula>
 <20231115113011.6620-1-duncan_roe@optusnet.com.au>
 <ZVSuTwfVBEsCcthA@calendula>
 <ZVg5jArFjdXUuzPN@slk15.local.net>
 <ZVkdn0wPWdUwgP4U@calendula>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZVkdn0wPWdUwgP4U@calendula>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Pablo,

On Sat, Nov 18, 2023 at 09:25:25PM +0100, Pablo Neira Ayuso wrote:
> On Sat, Nov 18, 2023 at 03:11:56PM +1100, Duncan Roe wrote:
> > Hi Pablo,
> >
> > Can we please sort out just what you want before I send nfq_nlmsg_put2 v4?
> >
> > And, where applicable, would you like the same changes made to nfq_nlmsg_put?
>
> Just send a v4 with the changes I request for this patch, then once
> applied, you can follow up to update nfq_nlmsg_put() in a separated
> patch to amend that description too.
>
> So, please, only one patch series at a time.
>
> > On Wed, Nov 15, 2023 at 12:41:03PM +0100, Pablo Neira Ayuso wrote:
> [...]
> > > > + * attempt to configure NFQA_CFG_F_SECCTX on a system not runnine SELinux.
> > > > + * \n
> > > > + * NLM_F_ACK instructs the kernel to send a message in response
> > > > + * to a successful command.
> > >
> > > As I said above, this is not accurate.
> > > > + * The kernel always sends a message in response to a failed command.
> >
> > I dispute that my description was inaccurate, but admit it could be clearer,
> > maybe if I change the order and elaborate a bit.
> > propose
> >
> > > > + * The kernel always sends a message in response to a failed command.
> > > > + * NLM_F_ACK instructs the kernel to also send a message in response
> > > > + * to a successful command.
>
> LGTM, however:
>
> > > > + * This ensures a following read() will not block.
>
> Remove this sentence, because the blocking behaviour you observe is
> because !NLM_F_ACK and no failure means no message is sent, and if
> your application is there to recv(), it will wait forever because
> kernel will send nothing.

I did post v4 but forgot --in-reply-to in git format-patch.
You'll find the updated patch furtheron in your mbox.

Cheers ... Duncan.
