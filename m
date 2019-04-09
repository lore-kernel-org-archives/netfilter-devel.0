Return-Path: <SRS0=jECH=SL=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8BD23C282DA
	for <netfilter-devel@archiver.kernel.org>; Tue,  9 Apr 2019 14:01:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 642A62084F
	for <netfilter-devel@archiver.kernel.org>; Tue,  9 Apr 2019 14:01:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726464AbfDIOBC (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 9 Apr 2019 10:01:02 -0400
Received: from mail-ot1-f68.google.com ([209.85.210.68]:33079 "EHLO
        mail-ot1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726401AbfDIOBB (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 9 Apr 2019 10:01:01 -0400
Received: by mail-ot1-f68.google.com with SMTP id j10so15658926otq.0
        for <netfilter-devel@vger.kernel.org>; Tue, 09 Apr 2019 07:01:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=84zlGAP1TXPZoscHpIelfxKCxDv/074dG8oVeQkrcfo=;
        b=lZSGLLp6r97v3Ue+DeeihI+OTTe2kH7BK5PN2YrY6f5J29oVSA47U5YMXczIVJorWB
         ib4rUTg/57dtpVTHUjaWjD23c4MYPRD8DTPHGwHYAH0YOFKxLABuTlKdDuJkBPwEA4Qb
         1UmGkbPQGghRj2m/yRse7IVo2p3Kv6JNiYrP9YxExLZccRBOafguG00aGZHPYXuOyXc7
         EJSW0kzoUIByfDfwyep4fqDR9WmlzuTKYqiIPiTxIteHRBZnC4YhhAag7OK5OQv6iNMo
         P8y36LUjuieb4xMLwn7tA2EeGN0xHodAjnbay0/hxXraOJmqHQDBUgU/WHFgFV/i1ey4
         okJA==
X-Gm-Message-State: APjAAAUo5gyGPhhrlkNEh/2hODbdZ/A2KCUY/645sUNvBRUJx6Y/DyCD
        qYfdCCY7IpPzow7xDxOhGolIXTvs5XlTgJCtLqFC2g==
X-Google-Smtp-Source: APXvYqwpF2ICSPaYToowzQx+5lqr7LpqWWDRuiSr5SuTU1Rlg3HJTCzxvqu4bOEDI6MPVitnW8anmSGxD/TkAKosIUY=
X-Received: by 2002:a9d:6941:: with SMTP id p1mr23464533oto.64.1554818459654;
 Tue, 09 Apr 2019 07:00:59 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1554732921.git.rgb@redhat.com> <baa5f3c6d4aa7f9fec903ebb51949f3ac743d067.1554732921.git.rgb@redhat.com>
 <CAFqZXNvZTb-OrCHugEc2TrW57EX_f_+absARpR1bUBN3_uavdQ@mail.gmail.com>
 <CAHC9VhRbxefdpTX5ct+1=uccv9b2GH+imDPPbB90RBWSjMcgbA@mail.gmail.com> <20190409134852.GB15660@hmswarspite.think-freely.org>
In-Reply-To: <20190409134852.GB15660@hmswarspite.think-freely.org>
From:   Ondrej Mosnacek <omosnace@redhat.com>
Date:   Tue, 9 Apr 2019 16:00:49 +0200
Message-ID: <CAFqZXNvzOOjXt7p7dgP14D6TeNKPkSULdtdhapYs5d1H366YjQ@mail.gmail.com>
Subject: Re: [PATCH ghak90 V6 05/10] audit: add contid support for signalling
 the audit daemon
To:     Neil Horman <nhorman@tuxdriver.com>
Cc:     Paul Moore <paul@paul-moore.com>,
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

On Tue, Apr 9, 2019 at 3:49 PM Neil Horman <nhorman@tuxdriver.com> wrote:
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
> >
>
> Agreed, this change as-is is in keeping with the message structure that audit
> has today, and so is ok with me, but the long term goal should be a conversion
> to netlink attributes for all audit messages.  Thats a big undertaking and
> should be addressed separately though.

Yeah, you both have a good point that doing it now and only for this
message is not necessarily better than not doing it at all. And doing
a general overhaul is out of scope for this series, obviously. I
didn't really mind the current solution before and I mind it even less
now, so consider me satisfied :) I was really just thinking out
loud...

-- 
Ondrej Mosnacek <omosnace at redhat dot com>
Software Engineer, Security Technologies
Red Hat, Inc.
