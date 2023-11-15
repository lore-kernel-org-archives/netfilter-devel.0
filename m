Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0955C07548
	for <netfilter-devel@archiver.kernel.org>; Wed, 15 Nov 2023 10:53:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234709AbjKOKxd (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 15 Nov 2023 05:53:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234098AbjKOKxc (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 15 Nov 2023 05:53:32 -0500
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FCB19F
        for <netfilter-devel@vger.kernel.org>; Wed, 15 Nov 2023 02:53:28 -0800 (PST)
Received: by mail-pl1-x631.google.com with SMTP id d9443c01a7336-1cc29f39e7aso43655915ad.0
        for <netfilter-devel@vger.kernel.org>; Wed, 15 Nov 2023 02:53:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1700045608; x=1700650408; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references
         :mail-followup-to:reply-to:message-id:subject:cc:to:date:from:sender
         :from:to:cc:subject:date:message-id:reply-to;
        bh=1klQnxioFqh4PQRjknkaJL+EfIoN2a5ojqktztaYHjY=;
        b=drA0xTWY3Fi6nrYa0xtemdyaijx1vh8tK+K6lHNQ5JQ8rAor8fOm1Xi/G1tsCXBcjF
         JmFryMim3kw4/44ulCjzJkHFJO3OgYnHxKj0n32N0me/MIj02bYZPJTJpMzSId55Siwe
         Zlu0icMrmTmoUamQi/TEJiSNiLSTnVPHL2P3JnsuZb67I+lKemUnCNbOPuIhGbw7pAFX
         pElGcPUhS6cpTxc+uwXSjXl7CATKejVmJ9NuUIwSbm6xg0QfEPmJmalfb50yYFPxDSP4
         jHpM4CSu+dbO/0te3g91J5emw6F6uiE4MQzbEIM8AA4+2oVLV8iv2FMXIufUTYkHXdVv
         jcLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700045608; x=1700650408;
        h=in-reply-to:content-disposition:mime-version:references
         :mail-followup-to:reply-to:message-id:subject:cc:to:date:from:sender
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1klQnxioFqh4PQRjknkaJL+EfIoN2a5ojqktztaYHjY=;
        b=Eo39Y5DCEHehvEiDymnZsMzpuyJcZRZI6sDkWGtD/OTzj98Rv9kwB7T8kd3+MiON1l
         6fxlA7yCnuI2/zKqJhF4hr/7bqQW6bdvNQxwXHclNqFiNJ+U7KpLYhCPGuZ7hFlzrf3V
         t9Yr4Eo8j7ztugD3en5LE9a/lmlAwKmfgkDOrsh6p0S5UqU4jl9DUxVJAu0xFQ0eDY0A
         pCGZCUIo+LFNp4c/fciwAMCJ6mdnvg/ITxtUY8gcw+ke4Px20OYd27AAJzm4q2hH7U8z
         VNylFfVQpZRi3a52oMKI+kEjg7ox3SBnqvYZwOhXbUaWOWLwmJRApC2edAJjCc3RoFn8
         0Qww==
X-Gm-Message-State: AOJu0Yz0T043IgZOcFzyoCuU0I79LEg76QrA/vluaJJcJMsW58xOXVca
        tMlpKrFz0HKDorU4Np+RElBvgmf0ILY=
X-Google-Smtp-Source: AGHT+IGFY5jMztLmNlrpGzsQSFciLHPsTILzWH5NJNXz+D0LrhzGfX3HmySjLYX0FABXH9s/XoOw0Q==
X-Received: by 2002:a17:902:e88c:b0:1cc:ee07:1654 with SMTP id w12-20020a170902e88c00b001ccee071654mr5435949plg.14.1700045607996;
        Wed, 15 Nov 2023 02:53:27 -0800 (PST)
Received: from slk15.local.net (n58-108-90-185.meb1.vic.optusnet.com.au. [58.108.90.185])
        by smtp.gmail.com with ESMTPSA id m18-20020a170902db1200b001c9c6a78a56sm7102123plx.97.2023.11.15.02.53.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Nov 2023 02:53:27 -0800 (PST)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From:   Duncan Roe <duncan_roe@optusnet.com.au>
X-Google-Original-From: Duncan Roe <dunc@slk15.local.net>
Date:   Wed, 15 Nov 2023 21:53:24 +1100
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Netfilter Development <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH libnetfilter_queue v2 1/1] src: Add nfq_nlmsg_put2() -
 user specifies header flags
Message-ID: <ZVSjJFXtfhX0WbP3@slk15.local.net>
Reply-To: duncan_roe@optusnet.com.au
Mail-Followup-To: Pablo Neira Ayuso <pablo@netfilter.org>,
        Netfilter Development <netfilter-devel@vger.kernel.org>
References: <ZVORoqFJonvQaABS@calendula>
 <20231115100950.6553-1-duncan_roe@optusnet.com.au>
 <ZVScl0WNyKIQlghR@calendula>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZVScl0WNyKIQlghR@calendula>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Nov 15, 2023 at 11:25:27AM +0100, Pablo Neira Ayuso wrote:
> On Wed, Nov 15, 2023 at 09:09:50PM +1100, Duncan Roe wrote:
> > +EXPORT_SYMBOL
> > +struct nlmsghdr *nfq_nlmsg_put2(char *buf, int type, uint32_t queue_num,
> > +				uint16_t flags)
> >  {
> >  	struct nlmsghdr *nlh = mnl_nlmsg_put_header(buf);
> >  	nlh->nlmsg_type = (NFNL_SUBSYS_QUEUE << 8) | type;
> > -	nlh->nlmsg_flags = NLM_F_REQUEST
> > +	nlh->nlmsg_flags = flags;
>
> Leave this as is.
>
> NLM_F_REQUEST means this message goes to the kernel, this flag is a
> must have.

How about

	nlh->nlmsg_flags = NLM_F_REQUEST | flags;

Or, you could apply v1.
I couldn't see a use case for other flags (NLM_F_DUMP and so on) otherwise I
would have made flags an arg in v1.

On Tue, Nov 14, 2023 at 04:26:26PM +0100, Pablo Neira Ayuso wrote:
[...]
> I like this, but I'd suggest instead:
>
>   struct nlmsghdr *nfq_nlmsg_put2(char *buf, int type, uint32_t queue_num, uint16_flags);
>
> I should have expose those netlink flags in first place.
>
> There are more useful netlink flags, so just expose them all.
>
LMK,

Cheers ... Duncan.
