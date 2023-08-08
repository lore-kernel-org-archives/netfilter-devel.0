Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3459C41513
	for <netfilter-devel@archiver.kernel.org>; Tue,  8 Aug 2023 20:39:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231158AbjHHUjd (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 8 Aug 2023 16:39:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231218AbjHHUi5 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 8 Aug 2023 16:38:57 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33E085A7D
        for <netfilter-devel@vger.kernel.org>; Tue,  8 Aug 2023 13:07:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1691525273;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XQxg2+GFsWE1eF8crOmGCbQlbI55NVJdzJHl8bILcbo=;
        b=Td/V4sRhZCg+PE+me/dJz5nzChZkBxVJaL1dI7u6m7YcY1KuE2SFklLN11vOC9Cwk9gXnx
        6ve/3rpe6oqmne87QR2k/nDVsWA9+mBJmZjXQOqZjW5Rb1DNzprWvGF2os9Bhw3le789Lq
        NNk3EY4eP0Cd/bIq5hGTNa3r3Ze8C8M=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-434-oSNdlrezPGC0kdHeXv2GTg-1; Tue, 08 Aug 2023 16:07:52 -0400
X-MC-Unique: oSNdlrezPGC0kdHeXv2GTg-1
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-31799700ed4so544963f8f.1
        for <netfilter-devel@vger.kernel.org>; Tue, 08 Aug 2023 13:07:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691525269; x=1692130069;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=XQxg2+GFsWE1eF8crOmGCbQlbI55NVJdzJHl8bILcbo=;
        b=bSHgfk/j2QOcOjCDTJFODTKNgIy9RRO4dovoXftFU9IYFxVBWo6i/ggv2d5FGjn6FG
         VLDFTZYapW2WMgq6ZH2mdBbZ3afXSKPemNR7bLgwXvrfse6SiaOBaHJDF0LZRFdW4v3I
         OVw8YsFCjCH8DCWQlI+BDZBKnQGu3V1DMAVm2nPZcKP3tmfS1tWZOOxzCVey7EXNS5DM
         uGK1/hTj5kPAdH2Wd3ev8AGkCoa+ykNsKdp8lz4Z4+FfvDZljb4qXT/dG4CfowebN8yF
         sJXKJJGDZLP+ZgwiHumDRSqdyEio1pzoUqFn9R//29cC1ndQc8bJkswdm9oWzWeXQntb
         FDug==
X-Gm-Message-State: AOJu0YxbFFLc5D+dT9/p9WynQ7K1a+GJ3+0P1NK2+InJu8Lj7NSnVo6b
        /XJwAhJoOO6kFBRX5YgZc6OINXelYXcK073VNeV5QbYg/ITn6y4XEyiaUBijXliyHVh09DXi6s6
        4iIvF1IUW6T7SOca7/Xnk92DbDKPpHeOADRuX
X-Received: by 2002:adf:e892:0:b0:317:5f08:32a3 with SMTP id d18-20020adfe892000000b003175f0832a3mr318419wrm.6.1691525269651;
        Tue, 08 Aug 2023 13:07:49 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFil7N/gk6ljHxJZUn7WRLS6XdAC5j4SvWXn4adaQKAHgMz38u+bdhJ34WH8VKxAgew6gl50g==
X-Received: by 2002:adf:e892:0:b0:317:5f08:32a3 with SMTP id d18-20020adfe892000000b003175f0832a3mr318412wrm.6.1691525269377;
        Tue, 08 Aug 2023 13:07:49 -0700 (PDT)
Received: from [10.0.0.196] ([37.186.180.70])
        by smtp.gmail.com with ESMTPSA id o10-20020a5d474a000000b003141a3c4353sm14542273wrs.30.2023.08.08.13.07.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Aug 2023 13:07:48 -0700 (PDT)
Message-ID: <87ab9a5321184254f40941a1f6f265b4ac66804f.camel@redhat.com>
Subject: Re: [nft PATCH v4 6/6] py: add Nftables.{get,set}_input() API
From:   Thomas Haller <thaller@redhat.com>
To:     Phil Sutter <phil@nwl.cc>
Cc:     NetFilter <netfilter-devel@vger.kernel.org>
Date:   Tue, 08 Aug 2023 22:07:48 +0200
In-Reply-To: <ZNJLbiVq6QolAOvi@orbyte.nwl.cc>
References: <20230803193940.1105287-1-thaller@redhat.com>
         <20230803193940.1105287-13-thaller@redhat.com>
         <ZNJLbiVq6QolAOvi@orbyte.nwl.cc>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.48.4 (3.48.4-1.fc38) 
MIME-Version: 1.0
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, 2023-08-08 at 16:04 +0200, Phil Sutter wrote:
> On Thu, Aug 03, 2023 at 09:35:24PM +0200, Thomas Haller wrote:
> > Similar to the existing Nftables.{get,set}_debug() API.
> >=20
> > Only notable (internal) difference is that
> > nft_ctx_input_set_flags()
> > returns the old value already, so we don't need to call
> > Nftables.get_input() first.
> >=20
> > The benefit of this API, is that it follows the existing API for
> > debug
> > flags. Also, when future flags are added it requires few changes to
> > the
> > python code.
> >=20
> > The disadvantage is that it looks different from the underlying C
> > API,
> > which is confusing when reading the C API. Also, it's a bit
> > cumbersome
> > to reset only one flag. For example:
> >=20
> > =C2=A0=C2=A0=C2=A0=C2=A0 def _drop_flag_foo(flag):
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if isinstance(flag, int):
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 retu=
rn flag & ~FOO_NUM
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if flag =3D=3D 'foo':
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 retu=
rn 0
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return flag
> >=20
> > =C2=A0=C2=A0=C2=A0=C2=A0 ctx.set_input(_drop_flag_foo(v) for v in ctx.g=
et_input())
>=20
> Which would be easier if there were dedicated setter/getter pairs for
> each flag. The code for debug flags optimizes for setting multiple
> flags
> at once ("get me all the debugging now!"). Not a veto from my side
> though, adding getter/setter pairs after the fact is still possible
> without breaking anything.

Or

  ctx.set_input(ctx.get_input(numeric=3DTrue) & ~FOO_NUM)


Thomas

