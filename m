Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD086EE49A4
	for <netfilter-devel@archiver.kernel.org>; Tue, 22 Aug 2023 11:45:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234933AbjHVLpp (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 22 Aug 2023 07:45:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235147AbjHVLpp (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 22 Aug 2023 07:45:45 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29990E4C
        for <netfilter-devel@vger.kernel.org>; Tue, 22 Aug 2023 04:44:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1692704553;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HbQXaohoGNoN4XeBF2B9S9Vm/zCX4Rmo/2WD9AbgG70=;
        b=T252NQmxvSHHd1pJ6l5rk2Ob854ashEWLRzEC2dBz2o6BY5TUpt/KlzxKg0PeFyv68VtAX
        ppzZ555elV10B4g9gz6z+1yFjf2Ow1gb7k1TxinkmASX9BzkVGpNkpZrpOVT7+364QBBmt
        1kmoaLeJx7r5WdzxzahEcjkDugzGVUU=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-96-x6JFq3tUOwKgFItv-2Gv7w-1; Tue, 22 Aug 2023 07:39:24 -0400
X-MC-Unique: x6JFq3tUOwKgFItv-2Gv7w-1
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-317cc34e897so525574f8f.0
        for <netfilter-devel@vger.kernel.org>; Tue, 22 Aug 2023 04:39:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692704362; x=1693309162;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=HbQXaohoGNoN4XeBF2B9S9Vm/zCX4Rmo/2WD9AbgG70=;
        b=I9GTx6MEiZTTGquziQzVKDEgJ1OpDG6lSrr/QuQBWBy6O5vQKhVwzHoVdtmdD8K7Jf
         Bgz5UA1wnfWSYkVO1skW4P5vLI6Ub4QcAT2SUCW8RB1cfnRLG4b4D7dHTLER1UVLher6
         omEDof1aixYe7Qfjaoldrs+0jqY3/wkWEDQy0glhN8xBo0Csm14imHhXDvEQVVtkHwqp
         3xSo64KWbuSsmiqhwuoee78ZOQMj2XNTvDZGbCUJi1AORbdNN7WzzXF5ljZCmhiawmng
         L7LmfG1wvRqy7dqGV4eIRdfJxFq1/Mbs+3MtJxaXhoKAZSFKwWztCbxMtOROapaNwamn
         F5ug==
X-Gm-Message-State: AOJu0YymC6n7RSCQ/4F8mneKeebGx/cuscPZOUhIyN02rAAlEvIbt98S
        sWE6FFmBlUbAB5ztTwJDIWTQ+wsWvlmyJvnDTCkM0tV5xLxdyaPTUNAPLSABI3v8qnanhIih3HU
        vt77rUNVmy9Vmw5mE0oan21LxBGubfBegfbwY
X-Received: by 2002:a5d:65c5:0:b0:319:8dcf:5c10 with SMTP id e5-20020a5d65c5000000b003198dcf5c10mr6705761wrw.6.1692704362450;
        Tue, 22 Aug 2023 04:39:22 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFTvpwQa833BZ9bQ5MSHnprxDcvRvYDun8IKZGM9wnO1MuQ1FnkHuM3UyTgR3myCIiIDg9JZw==
X-Received: by 2002:a5d:65c5:0:b0:319:8dcf:5c10 with SMTP id e5-20020a5d65c5000000b003198dcf5c10mr6705749wrw.6.1692704362091;
        Tue, 22 Aug 2023 04:39:22 -0700 (PDT)
Received: from [10.0.0.196] ([37.186.167.86])
        by smtp.gmail.com with ESMTPSA id n16-20020adfe790000000b003188358e08esm15534250wrm.42.2023.08.22.04.39.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Aug 2023 04:39:21 -0700 (PDT)
Message-ID: <f5680cd01051242a87f768f5770b062c199971b1.camel@redhat.com>
Subject: Re: [nft PATCH 2/2] meta: use reentrant localtime_r()/gmtime_r()
 functions
From:   Thomas Haller <thaller@redhat.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     NetFilter <netfilter-devel@vger.kernel.org>
Date:   Tue, 22 Aug 2023 13:39:20 +0200
In-Reply-To: <ZOR3za+Z+1X0VnIo@calendula>
References: <20230822081318.1370371-1-thaller@redhat.com>
         <20230822081318.1370371-2-thaller@redhat.com> <ZOR3za+Z+1X0VnIo@calendula>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.48.4 (3.48.4-1.fc38) 
MIME-Version: 1.0
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, 2023-08-22 at 10:54 +0200, Pablo Neira Ayuso wrote:
> On Tue, Aug 22, 2023 at 10:13:10AM +0200, Thomas Haller wrote:
> > These functions are POSIX.1-2001. We should have them in all
> > environments we care about.
> >=20
> > Use them as they are thread-safe.
>=20
> Also applied, thanks
>=20


Hi Pablo,



One more consideration, that I didn't realize before. Sorry about that.


localtime() will always call tzset(). And localtime_r() is documented
that it may not call it.

  https://linux.die.net/man/3/localtime_r


I checked implementations, AFAIS, musl will always call do_tzset()
([1]). glibc will only ensure that tzset() was called at least once
([2]).

[1] https://git.musl-libc.org/cgit/musl/tree/src/time/__tz.c?id=3D83b858f83=
b658bd34eca5d8ad4d145f673ae7e5e#n369
[2] https://codebrowser.dev/glibc/glibc/time/tzset.c.html#577


It's not clear to me, whether it would be more correct/desirable to
always call tzset() before localtime_r(). I think it would only matter,
if the timezone were to change (e.g. update /etc/localtime).

nftables calls localtime_r() from print/parse functions. Presumably, we
will print/parse several timestamps during a larger operation, it would
be odd to change/reload the timezone in between or to meaningfully
support that.


I think it is all good, nothing to change. Just to be aware of.


Thomas

