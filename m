Return-Path: <SRS0=jECH=SL=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15BA9C10F0E
	for <netfilter-devel@archiver.kernel.org>; Tue,  9 Apr 2019 13:41:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D816E2070D
	for <netfilter-devel@archiver.kernel.org>; Tue,  9 Apr 2019 13:41:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=paul-moore-com.20150623.gappssmtp.com header.i=@paul-moore-com.20150623.gappssmtp.com header.b="YEhdK1Tr"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727169AbfDINlM (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 9 Apr 2019 09:41:12 -0400
Received: from mail-lj1-f193.google.com ([209.85.208.193]:37702 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726372AbfDINlM (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 9 Apr 2019 09:41:12 -0400
Received: by mail-lj1-f193.google.com with SMTP id v13so14485385ljk.4
        for <netfilter-devel@vger.kernel.org>; Tue, 09 Apr 2019 06:41:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=p3vyeIn43IG+brbHELRfPrc4NO3qJy22/cRNmBwEyGY=;
        b=YEhdK1Tr1X1VAi2x4C9Scm7lUUzJpv+938XjrX0A+cTfKoaFB+Q0mGB01QfJ4S14ca
         VPn67lqVFVG0ODvDCDcZyb4R6m5UJOkNTaEGIFDSQsUwtxX/CDULbZ7SCSE0Ou84AJpY
         RUYz7Yx2EnAna3gJwgWun8XzBOHLvMpLJS6O7MoeKDcDzT2tM/n+BHJkqFZyXOqAvGME
         UumFcqkYcqocGjGk/exUSNSDXNiF2aJyllsIeQCjLrGc7pzav2VZAzAv4sqE3rab0Lzi
         bkCutZuMsjQifi+XC6TwbGb2H4GKmwztZ1iCEg2mZeVEQILzFRKFrZrKJwS3VKvpHfft
         MfPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=p3vyeIn43IG+brbHELRfPrc4NO3qJy22/cRNmBwEyGY=;
        b=XCuRPgykEpR+ajY+o3ehvn+HqouAEs9cqjn++O6Zs69gHWSxIQnfpqbZ73heVLLLiD
         sVsA4d5pOaUgVoLrZDw+96OunDNom2Gkf8+JYTZOz2oEU2NthP9DznCxWSokFrLT09FT
         deL06Y0HQ9jIwUBnkj0nyDfTBpjnsVKRpGXyJdhS4xh0bPRmO6aAtRITKcoCMK5mURiU
         af6U7mLjOLGEb3GDEL67UEIgDwuUBWLfAqIMFJTs2ySoh43359a5VpINJYgL5+IADni0
         kZfuxb/+PFcKXF3bSxu4NO5plkb2ePlptMPbnim5z7bGU/GR+K765a58Pckd/XyCZjtD
         n40Q==
X-Gm-Message-State: APjAAAWj+xEp8kjPlagjfbiIxgeE1gNv+rBhra0fKPwDVAlwTxdM0VbL
        6tXZ0OcmqQ3LfLaBrLdpFC0NABoWfcAhvuYTJBkt
X-Google-Smtp-Source: APXvYqxdHKPr+2RXagsy6oke+WsSror1Au2F3cfqo87dZHnTU7VnFYh0IZ+ojX7bGxfI2rP/TxrbFRMJ5Pcqi8JYG1I=
X-Received: by 2002:a2e:9649:: with SMTP id z9mr2697569ljh.92.1554817269998;
 Tue, 09 Apr 2019 06:41:09 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1554732921.git.rgb@redhat.com> <baa5f3c6d4aa7f9fec903ebb51949f3ac743d067.1554732921.git.rgb@redhat.com>
 <CAFqZXNvZTb-OrCHugEc2TrW57EX_f_+absARpR1bUBN3_uavdQ@mail.gmail.com>
In-Reply-To: <CAFqZXNvZTb-OrCHugEc2TrW57EX_f_+absARpR1bUBN3_uavdQ@mail.gmail.com>
From:   Paul Moore <paul@paul-moore.com>
Date:   Tue, 9 Apr 2019 09:40:58 -0400
Message-ID: <CAHC9VhRbxefdpTX5ct+1=uccv9b2GH+imDPPbB90RBWSjMcgbA@mail.gmail.com>
Subject: Re: [PATCH ghak90 V6 05/10] audit: add contid support for signalling
 the audit daemon
To:     Ondrej Mosnacek <omosnace@redhat.com>
Cc:     Richard Guy Briggs <rgb@redhat.com>,
        containers@lists.linux-foundation.org, linux-api@vger.kernel.org,
        Linux-Audit Mailing List <linux-audit@redhat.com>,
        linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        Steve Grubb <sgrubb@redhat.com>,
        David Howells <dhowells@redhat.com>,
        Simo Sorce <simo@redhat.com>,
        Eric Paris <eparis@parisplace.org>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        "Eric W . Biederman" <ebiederm@xmission.com>, nhorman@tuxdriver.com
Content-Type: text/plain; charset="UTF-8"
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Apr 9, 2019 at 8:58 AM Ondrej Mosnacek <omosnace@redhat.com> wrote:
>
> On Tue, Apr 9, 2019 at 5:40 AM Richard Guy Briggs <rgb@redhat.com> wrote:
> > Add audit container identifier support to the action of signalling the
> > audit daemon.
> >
> > Since this would need to add an element to the audit_sig_info struct,
> > a new record type AUDIT_SIGNAL_INFO2 was created with a new
> > audit_sig_info2 struct.  Corresponding support is required in the
> > userspace code to reflect the new record request and reply type.
> > An older userspace won't break since it won't know to request this
> > record type.
> >
> > Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
>
> This looks good to me.
>
> Reviewed-by: Ondrej Mosnacek <omosnace@redhat.com>
>
> Although I'm wondering if we shouldn't try to future-proof the
> AUDIT_SIGNAL_INFO2 format somehow, so that we don't need to add
> another AUDIT_SIGNAL_INFO3 when the need arises to add yet-another
> identifier to it... The simplest solution I can come up with is to add
> a "version" field at the beginning (set to 2 initially), then v<N>_len
> at the beginning of data for version <N>. But maybe this is too
> complicated for too little gain...

FWIW, I believe the long term solution to this is the fabled netlink
attribute approach that we haven't talked about in some time, but I
keep dreaming about (it has been mostly on the back burner becasue 1)
time and 2) didn't want to impact the audit container ID work).  While
I'm not opposed to trying to make things like this a bit more robust
by adding version fields and similar things, there are still so many
(so very many) problems with the audit kernel/userspace interface that
still need to be addressed.

-- 
paul moore
www.paul-moore.com
