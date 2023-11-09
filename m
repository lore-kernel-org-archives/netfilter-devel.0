Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D12BC4332F
	for <netfilter-devel@archiver.kernel.org>; Thu,  9 Nov 2023 20:36:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229560AbjKIUgw (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 9 Nov 2023 15:36:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230150AbjKIUgv (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 9 Nov 2023 15:36:51 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6861444B9
        for <netfilter-devel@vger.kernel.org>; Thu,  9 Nov 2023 12:36:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1699562162;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
        bh=M7Rxf2HerlRdsCUz8qR0hHyk09BcyfwDD6guapQIGfw=;
        b=Iv7Qkte2S+4rMNmjmVHl/r4F/SLjWXEX74jsc0BPMqrs7tnMw1Gc4n3tbllW5Ybo+4AFHf
        7IiBlHJJD9YYaKIjm++YZEq87U8u7Vy4h4CBBWEx32qS15059p1RuLUG8f59PpZm8LLkvq
        HA0b1mUXYryBGZq7D2DuRtq1DzSEmMk=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-638-wyyfpbaTO1eNu_B0bqF2NQ-1; Thu, 09 Nov 2023 15:36:01 -0500
X-MC-Unique: wyyfpbaTO1eNu_B0bqF2NQ-1
Received: by mail-ej1-f71.google.com with SMTP id a640c23a62f3a-9dd4e40349bso30374766b.0
        for <netfilter-devel@vger.kernel.org>; Thu, 09 Nov 2023 12:36:00 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699562160; x=1700166960;
        h=mime-version:user-agent:content-transfer-encoding:autocrypt
         :references:in-reply-to:date:cc:to:from:subject:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=M7Rxf2HerlRdsCUz8qR0hHyk09BcyfwDD6guapQIGfw=;
        b=DUyn/nHfYA7LHDNjlUlGUMOkOncgYQ3ZFWX9+7f0s6nEV/iTkeMmpEKj8/D/tBSifJ
         RFBVgRObywnYlVaZ2xKG/kfFzut8693fl0TSuZjlNpyG9gvqckSxlgmczEMXGX5i7Ib7
         QdPNFzx8zkYhXwZyOESj88q/tmAdzAFxfyLT2jO43RBVVI8X2Exb1vtGJkbdKrmcOvBH
         m5bOdyGunq+HgGURGc2bpT8yxvCc2aFKI/VozP7UuwgEKM0Cscb4IK6LdmqP5kYtuWra
         PdUb/zxdKr4oOr/BPlA9ryLT1RrzNLGkMy5nKKa1fxqHPPZFD9ZrJUUKISvPubRo99sw
         aTQw==
X-Gm-Message-State: AOJu0Yyls32vtNcqWCaZYc3Ybw4LL7c92XXqDxrZJ01Ib1n0fLsYAX5B
        qSBMC67cu5JNQWegzLrPv//QMCCtQcVCrltT8+EaRFpUlh7wEb8mr8apmjID1RHE/oHsf1HF90f
        QbOGPZp6A+a75BGKXTD1FvjCoMDui
X-Received: by 2002:a17:906:739e:b0:9e6:69d:46aa with SMTP id f30-20020a170906739e00b009e6069d46aamr30296ejl.6.1699562159962;
        Thu, 09 Nov 2023 12:35:59 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFbNBmFdvOpzvvXzpnwnZbHXoWQjMHp8IpoWqvigEuV96M0ZYRsptYAJ8mYC8ZnDBfdZxGwHg==
X-Received: by 2002:a17:906:739e:b0:9e6:69d:46aa with SMTP id f30-20020a170906739e00b009e6069d46aamr30287ejl.6.1699562159624;
        Thu, 09 Nov 2023 12:35:59 -0800 (PST)
Received: from [10.0.0.168] ([37.186.169.33])
        by smtp.gmail.com with ESMTPSA id l9-20020a170906078900b009bf7a4d591bsm2959472ejc.45.2023.11.09.12.35.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Nov 2023 12:35:59 -0800 (PST)
Message-ID: <3b81fb7a25e8daf8a6c2c76ab0672207cf2c09c0.camel@redhat.com>
Subject: Re: [PATCH nft 01/12] tests: shell: export DIFF to use it from
 feature scripts
From:   Thomas Haller <thaller@redhat.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, fw@strlen.de
Date:   Thu, 09 Nov 2023 21:35:58 +0100
In-Reply-To: <ZU0vsd5zUuf3mSdm@calendula>
References: <20231109162304.119506-1-pablo@netfilter.org>
         <20231109162304.119506-2-pablo@netfilter.org>
         <f887b55faf6c8467b90fb2363cb780ee7aa51f2c.camel@redhat.com>
         <ZU0vsd5zUuf3mSdm@calendula>
Autocrypt: addr=thaller@redhat.com; prefer-encrypt=mutual; keydata=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
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.50.0 (3.50.0-1.fc39) 
MIME-Version: 1.0
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, 2023-11-09 at 20:14 +0100, Pablo Neira Ayuso wrote:
> On Thu, Nov 09, 2023 at 06:49:21PM +0100, Thomas Haller wrote:
> > On Thu, 2023-11-09 at 17:22 +0100, Pablo Neira Ayuso wrote:
> > > export DIFF so it can be used from feature scripts to probe the
> > > kernel.
> > >=20
> > > +DIFF=3D"$(which diff)"
> > > +if [ ! -x "$DIFF" ] ; then
> > > +	DIFF=3Dtrue
> > > +fi
> > > +export DIFF
> >=20
> >=20
> > what is the purpose of having $DIFF variable at all?
> > Why not require to have `diff` installed?
> >=20
> > Maybe that justification is somewhere in the history of the
> > project. If
> > so, could you drop one line in the commit message what the point
> > is?
>=20
> It is all available in git annotate:
>=20
> 68310ba0f9c2 ("tests: shell: Search diff tool once and for all")
> 7d93e2c2fbc7 ("tests: shell: autogenerate dump verification")

First use of $DIFF comes from=20

  3fb3bb603374 ('tests/listing: add some listing tests')

which says:

    In order to ease debug in case of failure, if the diff tool is in the s=
ystem,
    then a textual diff is printed.


With the `true` fallback, checks are skipped. It would be possible, to
use a fallback that still checks for equality (albeit without fancy
diff output).

But really. Just require everybody to install a diff program.


>=20
> I just need to move it around so I can use it from feature scripts.
> If you prefer I can just use 'diff' instead from the feature scripts.

Sure. The patch is fine.


I think one day,

   sed 's/\$DIFF\>/diff/g' -i $(git grep -l DIFF tests/shell/)

should be done.



Thomas

