Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31546C07208
	for <netfilter-devel@archiver.kernel.org>; Fri, 10 Nov 2023 17:57:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235254AbjKJR4p (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 10 Nov 2023 12:56:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229532AbjKJR4M (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 10 Nov 2023 12:56:12 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 284D18A5E
        for <netfilter-devel@vger.kernel.org>; Fri, 10 Nov 2023 00:09:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1699603792;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
        bh=qYdaBjjGKZWcCtA2MZKcaKd96sBMKZOkAO0EXq1z/wo=;
        b=A7+1GGOiuRixgcNnpFnFxAWeuKOSA1zKdTVYcro3J97JJGeLj6L7S/4m1Cuf3wht4ygr8b
        I9mssjHAzwo5KFab5RtZFwekK0nH0YFPZt8RPFr7bQfTGBnSN++htOC5BhowbpltHsq9b5
        BTXKiGj20ppkRFKimrsmzw4Ob4Fp5Xw=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-201-8vyKxZlmNxeKEI7eDMAtyw-1; Fri, 10 Nov 2023 03:09:50 -0500
X-MC-Unique: 8vyKxZlmNxeKEI7eDMAtyw-1
Received: by mail-ej1-f70.google.com with SMTP id a640c23a62f3a-9c45a6a8832so8089966b.1
        for <netfilter-devel@vger.kernel.org>; Fri, 10 Nov 2023 00:09:50 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699603789; x=1700208589;
        h=mime-version:user-agent:content-transfer-encoding:autocrypt
         :references:in-reply-to:date:cc:to:from:subject:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qYdaBjjGKZWcCtA2MZKcaKd96sBMKZOkAO0EXq1z/wo=;
        b=H8ASrGK9Ki+onRoxIbGbMt6pQLFU+tj3KhWzPe4Cy8a0DVIQnQtuWSnanPpd5RLOzp
         43C9e1i1sabMyWuDEeY9WJI67eUqN+yASQlEQfoDe0fZ4aODE7obrn/wX6k8rd9M1gDP
         UVmp2bfLJtdIm5D6YMZ88GgQnwHYzisrXr21zQbN301V9v1lv5IPCknaLAgJ++l5U5tq
         OPaTAb4KCRagJVkTkfKfg+oYzs6LEboO8gcvC1+YgBctZc1u0H61T50y7X24WHjk3ZTS
         +x7X6zG13B7BaFA0LcIlky9cqF2hsjFZqaR/d+1VS3kl+Tzl4VV2tBO/GEBW83Nczt70
         V7rg==
X-Gm-Message-State: AOJu0YwG/PmeD+fsuiRi+tX1vgcgIPI7DIzH1G+x4xymU3tZn0gL59Vn
        bFvLBM2GMTnAP0oPbh4lEq3vwG4FOjX8b4v7OTCcriXEw9j8LkOFXRMjL9n/6yPZtj31dWI6Ay9
        67NZF7Hm6z2UgU8FTPKbwDE7g9JEIFo+vNSPv
X-Received: by 2002:a17:907:d89:b0:9cf:7c60:47b9 with SMTP id go9-20020a1709070d8900b009cf7c6047b9mr5875640ejc.1.1699603789402;
        Fri, 10 Nov 2023 00:09:49 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHCrysRPdDk4AWE6XAmhTxL60DRaoiDm3M8PK4XVCfgmDPBO9VkFO21lnA5Ex3MVmOhE6ng5w==
X-Received: by 2002:a17:907:d89:b0:9cf:7c60:47b9 with SMTP id go9-20020a1709070d8900b009cf7c6047b9mr5875627ejc.1.1699603789028;
        Fri, 10 Nov 2023 00:09:49 -0800 (PST)
Received: from [10.0.0.194] ([37.186.169.33])
        by smtp.gmail.com with ESMTPSA id y1-20020a170906448100b0098951bb4dc3sm3517802ejo.184.2023.11.10.00.09.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Nov 2023 00:09:48 -0800 (PST)
Message-ID: <4c592bd9b7c5a1d7f24a12ae26c6c6196f96061d.camel@redhat.com>
Subject: Re: [PATCH nft 1/3] parser: don't mark "string" as const
From:   Thomas Haller <thaller@redhat.com>
To:     Florian Westphal <fw@strlen.de>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        NetFilter <netfilter-devel@vger.kernel.org>
Date:   Fri, 10 Nov 2023 09:09:47 +0100
In-Reply-To: <20231109231043.GB8000@breakpoint.cc>
References: <20231109190032.669575-1-thaller@redhat.com>
         <ZU0xWPO9YpItvKTz@calendula>
         <0da07d8c11797fdbc52a20dc59b819aae632c24c.camel@redhat.com>
         <20231109231043.GB8000@breakpoint.cc>
Autocrypt: addr=thaller@redhat.com; prefer-encrypt=mutual; keydata=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
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.50.0 (3.50.0-1.fc39) 
MIME-Version: 1.0
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, 2023-11-10 at 00:10 +0100, Florian Westphal wrote:
> Thomas Haller <thaller@redhat.com> wrote:
> > ifname_expr_alloc() calls `free(name)`, destroying the thing that
> > is
> > pointed at. That's a modification.
> >=20
> > The code required to cast away the constness, which also indicates
> > that
> > it is not actually const.
>=20
> It it.=C2=A0 I hate that free() isn't const void *.

That would work too. But C choose instead to disallow that.

Note that in nftables, ~75% of the free() operate on non-const just
fine. And the compiler is helpful confirming that.

>=20
> I prefer to have const used as much as humanly possible.
>=20

Definitely. Especially for long-lived data.


The "string" in question is a short-lived data allocated by "scanner.l"
and handed over to "parser_bison.y".

See:

=C2=BB=C2=B7=C2=B7=C2=B7=C2=B7=C2=B7=C2=B7=C2=B7=C2=BB=C2=B7=C2=B7=C2=B7=C2=
=B7=C2=B7=C2=B7=C2=B7=C2=BB=C2=B7=C2=B7=C2=B7=C2=B7=C2=B7=C2=B7=C2=B7|=C2=
=BB=C2=B7=C2=B7=C2=B7=C2=B7=C2=B7=C2=B7rule_alloc=C2=BB=C2=B7=C2=B7=C2=B7=
=C2=B7=C2=B7comment_spec
=C2=BB=C2=B7=C2=B7=C2=B7=C2=B7=C2=B7=C2=B7=C2=B7=C2=BB=C2=B7=C2=B7=C2=B7=C2=
=B7=C2=B7=C2=B7=C2=B7=C2=BB=C2=B7=C2=B7=C2=B7=C2=B7=C2=B7=C2=B7=C2=B7{
=C2=BB=C2=B7=C2=B7=C2=B7=C2=B7=C2=B7=C2=B7=C2=B7=C2=BB=C2=B7=C2=B7=C2=B7=C2=
=B7=C2=B7=C2=B7=C2=B7=C2=BB=C2=B7=C2=B7=C2=B7=C2=B7=C2=B7=C2=B7=C2=B7=C2=BB=
=C2=B7=C2=B7=C2=B7=C2=B7=C2=B7=C2=B7=C2=B7$$->cOmment =3D $2;
=C2=BB=C2=B7=C2=B7=C2=B7=C2=B7=C2=B7=C2=B7=C2=B7=C2=BB=C2=B7=C2=B7=C2=B7=C2=
=B7=C2=B7=C2=B7=C2=B7=C2=BB=C2=B7=C2=B7=C2=B7=C2=B7=C2=B7=C2=B7=C2=B7}

Here no free() is involved, but ownership is passed on without
strdup(). If "string" is const, this is another ugliness where you pass
on a string that you seemingly don't own.


There are places where it's ugly and const-correctness breaks down
(during destruction/ref/unref). See free_const() and
datatype_get()/datatype_free(). But those places should be at a minimum
by choosing const (and free_const()) when it makes sense.



Thomas

