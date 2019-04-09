Return-Path: <SRS0=jECH=SL=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F19AEC10F0E
	for <netfilter-devel@archiver.kernel.org>; Tue,  9 Apr 2019 14:07:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BE3A220883
	for <netfilter-devel@archiver.kernel.org>; Tue,  9 Apr 2019 14:07:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=paul-moore-com.20150623.gappssmtp.com header.i=@paul-moore-com.20150623.gappssmtp.com header.b="TJF+s2Rh"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726479AbfDIOHg (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 9 Apr 2019 10:07:36 -0400
Received: from mail-lj1-f194.google.com ([209.85.208.194]:34756 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726464AbfDIOHg (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 9 Apr 2019 10:07:36 -0400
Received: by mail-lj1-f194.google.com with SMTP id j89so14622027ljb.1
        for <netfilter-devel@vger.kernel.org>; Tue, 09 Apr 2019 07:07:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=UQxJMSZMCM3zKcDpRRfm0HzVbtFnEegjOT3D0Jsz53o=;
        b=TJF+s2Rh3KaDaWciSpvRfu5kfPblnXMMZ136vWoCaUsQQF2c7PN9rSIpCeiG27E307
         jrNVOiiACI5M/apRlWCXc0OE5bXix2BwUtVDiV0vRm/4or5lruqN4xtLiWisx+EiPtkj
         Lu0iWDZWt3IiIJO6b2MO7E/fI4NMGhpy+bXK9mtECKza8SMr05XajqZJv/wa05GNmu6f
         HmqRwvvUe7hdIr/I0wMo7Ht+CEiSfXXp9pUNg5B4uUHkq8+h0OUlKYVdgEax9DRan8Vs
         IMDS/y8mbiUPiCAjn9m0duONEAWQvRFgBW1B9hS0f0H8dp/PQGiCB8kJbRFBuwOmcg7J
         9sbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=UQxJMSZMCM3zKcDpRRfm0HzVbtFnEegjOT3D0Jsz53o=;
        b=EKfheh+AasIansHN/jlWSthCO46aYgPvvONEMdqbhPiyBsIsvIB9ldKgJrHMBfXDNp
         xRT44v4qbtvB8rpwPUW7LW6DSSHhF/mueSwxj6C+H0rNf6BZ7YtCYR+M2BBA4uxsop8j
         sG3KAWW+iBfqs5ufxGnGBV6ax9M8/Bq1btJRX7iaF9zqYApcYCLm+3ki2XRyWbL+uzfS
         bXBxPHTd6ffoVlcw0NFFOF7biFtv2pnfy+ng/4w0C/z3KaOa1qRVvgoWUfwDZbqjGiA0
         MLEbOVjVM95luS314H0LWcIxPtTmp4Y4Y9py8Mx5m1diI9d8WnZu6ZRHIxec7W0slfdc
         pkYA==
X-Gm-Message-State: APjAAAW0UgpdAJCYtQbxh7snoV5xp+c6ZKD/MOf7KB8Pi7WMg3CYROi1
        Sy7OpYJMlUWakREUdGZGx5J4JMv+zbyt9AFrT6ad
X-Google-Smtp-Source: APXvYqyEgbz1ViHg/yoq+SHC9WJ9RsRoXWSV3JGxCZUXOc3HVStH4Y161vmCk/BoPcyMqeZkGNVZEihNWTJpgEa0Hjg=
X-Received: by 2002:a2e:88c1:: with SMTP id a1mr19600298ljk.78.1554818854001;
 Tue, 09 Apr 2019 07:07:34 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1554732921.git.rgb@redhat.com> <baa5f3c6d4aa7f9fec903ebb51949f3ac743d067.1554732921.git.rgb@redhat.com>
 <CAFqZXNvZTb-OrCHugEc2TrW57EX_f_+absARpR1bUBN3_uavdQ@mail.gmail.com>
 <CAHC9VhRbxefdpTX5ct+1=uccv9b2GH+imDPPbB90RBWSjMcgbA@mail.gmail.com> <20190409134852.GB15660@hmswarspite.think-freely.org>
In-Reply-To: <20190409134852.GB15660@hmswarspite.think-freely.org>
From:   Paul Moore <paul@paul-moore.com>
Date:   Tue, 9 Apr 2019 10:07:22 -0400
Message-ID: <CAHC9VhQ2DAfaHcSUoE3vTtSzGL5TtRuLZgGrt4TyG44pKuBD7g@mail.gmail.com>
Subject: Re: [PATCH ghak90 V6 05/10] audit: add contid support for signalling
 the audit daemon
To:     Neil Horman <nhorman@tuxdriver.com>
Cc:     Ondrej Mosnacek <omosnace@redhat.com>,
        Richard Guy Briggs <rgb@redhat.com>,
        containers@lists.linux-foundation.org, linux-api@vger.kernel.org,
        Linux-Audit Mailing List <linux-audit@redhat.com>,
        linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        Steve Grubb <sgrubb@redhat.com>,
        David Howells <dhowells@redhat.com>,
        Simo Sorce <simo@redhat.com>,
        Eric Paris <eparis@parisplace.org>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        "Eric W . Biederman" <ebiederm@xmission.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Apr 9, 2019 at 9:49 AM Neil Horman <nhorman@tuxdriver.com> wrote:
> On Tue, Apr 09, 2019 at 09:40:58AM -0400, Paul Moore wrote:
> > On Tue, Apr 9, 2019 at 8:58 AM Ondrej Mosnacek <omosnace@redhat.com> wrote:
> > >
> > > On Tue, Apr 9, 2019 at 5:40 AM Richard Guy Briggs <rgb@redhat.com> wrote:
> > > > Add audit container identifier support to the action of signalling the
> > > > audit daemon.
> > > >
> > > > Since this would need to add an element to the audit_sig_info struct,
> > > > a new record type AUDIT_SIGNAL_INFO2 was created with a new
> > > > audit_sig_info2 struct.  Corresponding support is required in the
> > > > userspace code to reflect the new record request and reply type.
> > > > An older userspace won't break since it won't know to request this
> > > > record type.
> > > >
> > > > Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
> > >
> > > This looks good to me.
> > >
> > > Reviewed-by: Ondrej Mosnacek <omosnace@redhat.com>
> > >
> > > Although I'm wondering if we shouldn't try to future-proof the
> > > AUDIT_SIGNAL_INFO2 format somehow, so that we don't need to add
> > > another AUDIT_SIGNAL_INFO3 when the need arises to add yet-another
> > > identifier to it... The simplest solution I can come up with is to add
> > > a "version" field at the beginning (set to 2 initially), then v<N>_len
> > > at the beginning of data for version <N>. But maybe this is too
> > > complicated for too little gain...
> >
> > FWIW, I believe the long term solution to this is the fabled netlink
> > attribute approach that we haven't talked about in some time, but I
> > keep dreaming about (it has been mostly on the back burner becasue 1)
> > time and 2) didn't want to impact the audit container ID work).  While
> > I'm not opposed to trying to make things like this a bit more robust
> > by adding version fields and similar things, there are still so many
> > (so very many) problems with the audit kernel/userspace interface that
> > still need to be addressed.
>
> Agreed, this change as-is is in keeping with the message structure that audit
> has today, and so is ok with me, but the long term goal should be a conversion
> to netlink attributes for all audit messages.  Thats a big undertaking and
> should be addressed separately though.

You've likely missed all the conversations around this from some time
ago, but this is the direction I want us to go towards eventually, and
yes, this is a huge undertaking (much larger than the audit container
ID work) that will need to be done in stages.

The first step is moving away from audit_log_format() to an in-kernel
audit API that separates the data from the record format; I've got a
lot of ideas on that, but as I said earlier, it's mostly on the back
burner so it doesn't hold up the audit container ID work.

-- 
paul moore
www.paul-moore.com
