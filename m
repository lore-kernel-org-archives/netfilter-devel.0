Return-Path: <SRS0=jECH=SL=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF82CC10F0E
	for <netfilter-devel@archiver.kernel.org>; Tue,  9 Apr 2019 14:08:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9DBA72084F
	for <netfilter-devel@archiver.kernel.org>; Tue,  9 Apr 2019 14:08:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=paul-moore-com.20150623.gappssmtp.com header.i=@paul-moore-com.20150623.gappssmtp.com header.b="RYaMYmZg"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726446AbfDIOIt (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 9 Apr 2019 10:08:49 -0400
Received: from mail-lj1-f195.google.com ([209.85.208.195]:37593 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726463AbfDIOIs (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 9 Apr 2019 10:08:48 -0400
Received: by mail-lj1-f195.google.com with SMTP id v13so14580421ljk.4
        for <netfilter-devel@vger.kernel.org>; Tue, 09 Apr 2019 07:08:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=bJqwsdxna4Q7olx1D3bxkirl81KCJrqbp6C3D799jOY=;
        b=RYaMYmZgaC0PAGqbNW8JyoyXmTkaZWh0jFfuadqfVhFNh4yifjUEeeaDfGvqPhnfo9
         QI+BexXT3kmM4AhboT/k0KecivnHifHJcSp+cNIAp8nL50MOF8C5OQe31hzSxh8mGUei
         +J8XTagY0dOGuNc/NUImPnO1tlmBVw7QrTQuyCucsN/TXYBzPE4Omo2+JoQdK+92qgOW
         fME30PGDubQUNYvOjA7EaHwUo0hdpWwh101+n5pw+57np51nP8SstJufG7BFTUH8ZzVI
         e2hYxtTdlWRnhnpfPDsMbo3qj3DUhGLMajgvWnAgj6/5mCc6retn1xvIIbhku6J0PrD1
         IFww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=bJqwsdxna4Q7olx1D3bxkirl81KCJrqbp6C3D799jOY=;
        b=YbT+HW4hmlmhUhAGbpJgNIgqRuUEugZz87XPYniOuGFENo9vDPutpylRpF+4AXGUMu
         KK2SMkv9WV7BRGZvUjkUmoyr2YVBb5hB5uJdGcIVXkbX5htJwuhf5w3kQp+5UbfZ3XT2
         R7ce9ynrsbauiPnWKIY379yER4/NGjt+kcLsE4N8ICLg6QYiGOlvHCsfkRGSwIaM8we0
         xshAfmq2klyxdBOqilfEshIWnEEqcRpztc0xD+T+bUO8foBwwK3dB9PxZL0ozU+eqbcX
         o1TXK5xevSfkokxVT2SFKXk0eBHCOR6rKwaKkH/LZ/r/Ammbbf3I5ovWKEpyhg24EvLl
         74rA==
X-Gm-Message-State: APjAAAVYw9PDTMDajG4+RjTZ5wH85qJDdCgGJCsum+9vM+Y6btcEFHCn
        iep6sZvV4utDq02Zx2feHcaNlekwvZUVSqr5rL+N
X-Google-Smtp-Source: APXvYqyt5fG4EaaXMN+QXFBDUje0i0ygJRMUjGXJsdatvrnmqTymIGvwjojwIPLd69AxWFGGOZ8wRP7JCmuaa5vQzQ8=
X-Received: by 2002:a2e:4e12:: with SMTP id c18mr741895ljb.3.1554818926625;
 Tue, 09 Apr 2019 07:08:46 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1554732921.git.rgb@redhat.com> <baa5f3c6d4aa7f9fec903ebb51949f3ac743d067.1554732921.git.rgb@redhat.com>
 <CAFqZXNvZTb-OrCHugEc2TrW57EX_f_+absARpR1bUBN3_uavdQ@mail.gmail.com>
 <CAHC9VhRbxefdpTX5ct+1=uccv9b2GH+imDPPbB90RBWSjMcgbA@mail.gmail.com> <20190409135304.rgkcpgya6h3ciphy@madcap2.tricolour.ca>
In-Reply-To: <20190409135304.rgkcpgya6h3ciphy@madcap2.tricolour.ca>
From:   Paul Moore <paul@paul-moore.com>
Date:   Tue, 9 Apr 2019 10:08:35 -0400
Message-ID: <CAHC9VhS9EwnfS8BxL__mQrgYywTOgrXdnW=4zCiM_DYJc4U5+g@mail.gmail.com>
Subject: Re: [PATCH ghak90 V6 05/10] audit: add contid support for signalling
 the audit daemon
To:     Richard Guy Briggs <rgb@redhat.com>
Cc:     Ondrej Mosnacek <omosnace@redhat.com>,
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

On Tue, Apr 9, 2019 at 9:53 AM Richard Guy Briggs <rgb@redhat.com> wrote:
> On 2019-04-09 09:40, Paul Moore wrote:
> > On Tue, Apr 9, 2019 at 8:58 AM Ondrej Mosnacek <omosnace@redhat.com> wrote:
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
> While this particular message type is used very infrequently, adding a
> version field to every message type strikes me as a huge overhead for
> the small likelihood of the format needing to change.
>
> I'd prefer to just key it off the AUDIT_FEATURE_BITMAP or some other
> easily detectable change in this distinguishing feature, such as the
> presence of /proc/self/audit_containerid, which is what I've done in the
> accompanying userspace patchset that I'm preparing to post that works
> with this change.

That's fine.  As I said, I'm not overly worried about this; I view
this as a bit of a necessary hack.

-- 
paul moore
www.paul-moore.com
