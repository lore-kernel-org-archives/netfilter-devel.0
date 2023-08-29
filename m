Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9023CC71153
	for <netfilter-devel@archiver.kernel.org>; Tue, 29 Aug 2023 13:02:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231757AbjH2NCU (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 29 Aug 2023 09:02:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235917AbjH2NCL (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 29 Aug 2023 09:02:11 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 825D0CC9
        for <netfilter-devel@vger.kernel.org>; Tue, 29 Aug 2023 06:01:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1693314073;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DLd7p7rS74SYauvwPPET/vn5NZaQgJixJ6Jq+b9vIE0=;
        b=VsSBfzi+gGQqmOF9UJ/P5IrUfLtaAi/kF56Vqx5bN6b3ko18a48Gva1Ak3wsEYlz9sltzv
        yOipu5xJeKgeMy4WkJEEd+E9TqL9tTSFXDKoWUoUzUHEARa/+O5dE6+N/Il0pJHyGFF6bS
        CqEVboOGu7KcP2sUcAyCY556S0fokcc=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-440-46rvjb1TOICZJVeD9t3EMg-1; Tue, 29 Aug 2023 09:01:12 -0400
X-MC-Unique: 46rvjb1TOICZJVeD9t3EMg-1
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-3fe805a8826so10910725e9.0
        for <netfilter-devel@vger.kernel.org>; Tue, 29 Aug 2023 06:01:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693314070; x=1693918870;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=DLd7p7rS74SYauvwPPET/vn5NZaQgJixJ6Jq+b9vIE0=;
        b=ckiPgLyeKMFtmUSDnlFYe6/oTghy+o9GB6sTJuwWo4YEs/QmMfBcxb0DdElAK7NI5G
         olwmUuTTiJf5ESeg/XI+RZPfdpTzjSaKfuBjjvI/PAn25v+VWppJgcyUif1piwR3DBnn
         54zicNZmZnphGlYJcOSTrJG7XeGDZYcBqylWcL3jAWvGyppm7qjvJEZHeR92BbVYgl3y
         mjGXpBv5HsmVU/w2R0KfUJ9WAFBUi2MNkMWdnl1RxElxBiZ8Eh4QSVCFdleLutxuqVwL
         +hIjCUTArBB96kkNzpw7Mbq4KfD0Uyiwp5roPO0glrjzAipEDjxRfZNy8L8CEJnTXo3c
         iDBw==
X-Gm-Message-State: AOJu0YycA/BWRv0JH9JnTA7IgSnQNT7iKUy2f2OwaSi3m8PFKzSvcnte
        aPgmk5qE0ucahvXJvyJKgNbUY9MpMF/Eb/h8dPJKaXlHlVW9XgD8NbIsQZgtw3mneIuAI+xq89L
        kiKsiZyKWER1Z44j+MJ5uUV8VLiSogizSckWc
X-Received: by 2002:a05:600c:6027:b0:401:d8a4:17b0 with SMTP id az39-20020a05600c602700b00401d8a417b0mr1013384wmb.2.1693314070456;
        Tue, 29 Aug 2023 06:01:10 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE8ce3xUQ1xJsi+MniYubaV0ZunRi6azYTYbP31n7y79QlvX8hNVnhp1blDhEkZ1hzLcWZUww==
X-Received: by 2002:a05:600c:6027:b0:401:d8a4:17b0 with SMTP id az39-20020a05600c602700b00401d8a417b0mr1013364wmb.2.1693314070089;
        Tue, 29 Aug 2023 06:01:10 -0700 (PDT)
Received: from [10.0.0.196] ([37.186.167.86])
        by smtp.gmail.com with ESMTPSA id v18-20020adfedd2000000b0031934b035d2sm13699006wro.52.2023.08.29.06.01.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Aug 2023 06:01:09 -0700 (PDT)
Message-ID: <87441c57ed674f1aaaf8e77b9a775ce466041c8d.camel@redhat.com>
Subject: Re: [PATCH nft 5/8] src: rework SNPRINTF_BUFFER_SIZE() and avoid
 "-Wunused-but-set-variable"
From:   Thomas Haller <thaller@redhat.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     NetFilter <netfilter-devel@vger.kernel.org>
Date:   Tue, 29 Aug 2023 15:01:08 +0200
In-Reply-To: <ZOz7IMG0J1B0HVlB@calendula>
References: <20230828144441.3303222-1-thaller@redhat.com>
         <20230828144441.3303222-6-thaller@redhat.com> <ZOy5nTEQJvu7zdrx@calendula>
         <aa481d83b0320078a17bebf215378992a4f7cb21.camel@redhat.com>
         <ZOzFgtwJI6AasAYZ@calendula>
         <31efcb8e9ceac6f71003abd9517cca981550fc91.camel@redhat.com>
         <ZOz7IMG0J1B0HVlB@calendula>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.48.4 (3.48.4-1.fc38) 
MIME-Version: 1.0
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, 2023-08-28 at 21:53 +0200, Pablo Neira Ayuso wrote:
> On Mon, Aug 28, 2023 at 06:45:00PM +0200, Thomas Haller wrote:
> > On Mon, 2023-08-28 at 18:04 +0200, Pablo Neira Ayuso wrote:
> > > On Mon, Aug 28, 2023 at 05:49:53PM +0200, Thomas Haller wrote:
> > > > On Mon, 2023-08-28 at 17:13 +0200, Pablo Neira Ayuso wrote:
> > >=20
> > > > SNPRINTF_BUFFER_SIZE() rejects truncation of the string by
> > > > asserting
> > > > against it. That behavior is part of the API of that function.
> > > > Error
> > > > checking after an assert seems unnecessary.
> > > >=20
> > > > The check "if (len =3D=3D NF_LOG_PREFIXLEN)" seems wrong anyway.
> > > > After
> > > > truncation, "len" would be zero. The code previously checked
> > > > whether
> > > > nothing was appended, but the error string didn't match that
> > > > situation.
> > > >=20
> > > > Maybe SNPRINTF_BUFFER_SIZE() should not assert against
> > > > truncation?
> > >=20
> > > IIRC, the goal for this function was to handle snprintf() and all
> > > its
> > > corner cases. If there is no need for it or a better way to do
> > > this,
> > > this is welcome.
> > >=20
> >=20
> > I think the macro is sensible (at least, after some cleanup).
> >=20
> > It makes a choice, that the caller must ensure a priori that the
> > buffer
> > is long enough (by asserting).
> >=20
> > By looking at the callers, it's not clear to me, whether the
> > callers
> > can always ensure that.=C2=A0 For meta_key_parse(), it seems the maximu=
m
> > string is limited by meta_templates. But for
> > stmt_evaluate_log_prefix()
> > it may be possible to craft user-input that triggers the assertion,
> > isn't it?
> >=20
> > Maybe the macro and the callers should anticipate and handle
> > truncation?
>=20
> This should not silently truncate strings, instead bail out to user
> in
> case the string is too long.

v2 of the patchset is supposed to do that. wdyt?


Thanks
Thomas

