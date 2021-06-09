Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED0C9C48BCD
	for <netfilter-devel@archiver.kernel.org>; Wed,  9 Jun 2021 23:12:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D6267613EE
	for <netfilter-devel@archiver.kernel.org>; Wed,  9 Jun 2021 23:12:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229542AbhFIXOB (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 9 Jun 2021 19:14:01 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:24337 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229809AbhFIXOB (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 9 Jun 2021 19:14:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623280325;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Xo+qEGPn9KlOEgBL5PwWCJqZ+YfGoUOCc0kKfLWHJdY=;
        b=esnkm3OJU/0JYs+ujCRY8KuXS/3SKT2/bBfD0uybdss3nrRjAptu+fIW3OKutKDvaNwlMW
        1aQ/tj9WrdknA8W95F3qLGJTDik3iyI9MnmkqlNNpQ8USFaVYXu4k+r7d5UW1r0xQzlMeh
        OmlxwXOivHM1FFMR45r2XcqHcUl3EA4=
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com
 [209.85.166.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-591-PYmnmCyIMTOmOBn1ugbfjA-1; Wed, 09 Jun 2021 19:12:04 -0400
X-MC-Unique: PYmnmCyIMTOmOBn1ugbfjA-1
Received: by mail-io1-f70.google.com with SMTP id z8-20020a5e92480000b02904ae394676efso12143215iop.1
        for <netfilter-devel@vger.kernel.org>; Wed, 09 Jun 2021 16:12:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:references:mime-version:in-reply-to:date
         :message-id:subject:to:cc;
        bh=Xo+qEGPn9KlOEgBL5PwWCJqZ+YfGoUOCc0kKfLWHJdY=;
        b=L8hH1VNELEhhxyjZszF+OVj2KJT5Iv7H9OAP9ZAe0J9AkoaerK/YVYjG0w4MLFvchq
         VbnofqrAS+VI8ZE7sG4z+Fz7H/ckVSMgSGsY+p9XQCuA1wj3r9/dxCC6udo7ROSgqCBY
         uRn03vVCBcUVmcSkXTgYhJiHE1oOCHAsj8v3yQyKJfVNi4Hx4wDYij0jrNyjfaUWuFuO
         erHwCOGHaavK0yJDux7g78DSDGfP1e/DWaAVNxgGiIkcw2KHl7oEotXpHz7jc4nzIDeP
         /oFMnc0mTP4jqYcZzJzW0o4iFjg7JkN7BnTwXbRcQDd3BTdiAjkFtZzYcxHZN87aTrUp
         ClqA==
X-Gm-Message-State: AOAM533a6AyABTwBTTRC0Su3POCyKjJXekZpsr6P1PcDdT0vVZzeKqx1
        E3AcrtTNdP0biW3UjEV83tpYD6v9yXpNqTwxCLOkrqmBl5yUOogchxNiUovZydH86jgYSgEQ7mZ
        C1cGNBgwSt4MqsnaaiN6MZzplMYBn+jyMVx93yWVSZfvO
X-Received: by 2002:a6b:cd08:: with SMTP id d8mr1436095iog.86.1623280323829;
        Wed, 09 Jun 2021 16:12:03 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyZ4W7rT0BWT8AOuMgF8SiZ51SGwXkiWKePQKFpOj3OskJWHFByWg1HzMWV9aNPLKykjbMn1uQs/pyzRsMmLYc=
X-Received: by 2002:a6b:cd08:: with SMTP id d8mr1436081iog.86.1623280323598;
 Wed, 09 Jun 2021 16:12:03 -0700 (PDT)
Received: from 868169051519 named unknown by gmailapi.google.com with
 HTTPREST; Wed, 9 Jun 2021 16:12:02 -0700
From:   Marcelo Ricardo Leitner <mleitner@redhat.com>
References: <20210603121235.13804-1-ozsh@nvidia.com> <20210607121609.GA7908@salvia>
MIME-Version: 1.0
In-Reply-To: <20210607121609.GA7908@salvia>
Date:   Wed, 9 Jun 2021 16:12:02 -0700
Message-ID: <CALnP8ZYO25m0o_T1ABVu4uXN9NJh3E5G3gd0j66uEDHi6XUwqg@mail.gmail.com>
Subject: Re: [PATCH nf-next 0/3] Control nf flow table timeouts
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Oz Shlomo <ozsh@nvidia.com>, Paul Blakey <paulb@nvidia.com>,
        netfilter-devel@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, Jun 07, 2021 at 02:16:09PM +0200, Pablo Neira Ayuso wrote:
> On Thu, Jun 03, 2021 at 03:12:32PM +0300, Oz Shlomo wrote:
> > TCP and UDP connections may be offloaded from nf conntrack to nf flow table.
> > Offloaded connections are aged after 30 seconds of inactivity.
> > Once aged, ownership is returned to conntrack with a hard coded tcp/udp
> > pickup time of 120/30 seconds, after which the connection may be deleted.
> >
> > The current hard-coded pickup intervals may introduce a very aggressive
> > aging policy. For example, offloaded tcp connections in established state
> > will timeout from nf conntrack after just 150 seconds of inactivity,
> > instead of 5 days. In addition, the hard-coded 30 second offload timeout
> > period can significantly increase the hardware insertion rate requirements
> > in some use cases.
> >
> > This patchset provides the user with the ability to configure protocol
> > specific offload timeout and pickup intervals via sysctl.
> > The first and second patches introduce the sysctl configuration for
> > tcp and udp protocols. The last patch modifies nf flow table aging
> > mechanisms to use the configured time intervals.
>
> Series applied, thanks.

Patchset missed a description of the new sysctl entries in
nf_conntrack-sysctl.rst, btw.

  Marcelo

