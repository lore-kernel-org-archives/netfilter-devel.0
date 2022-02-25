Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 219E6C433EF
	for <netfilter-devel@archiver.kernel.org>; Fri, 25 Feb 2022 11:58:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240360AbiBYL66 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 25 Feb 2022 06:58:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240359AbiBYL6z (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 25 Feb 2022 06:58:55 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E4B1223532E
        for <netfilter-devel@vger.kernel.org>; Fri, 25 Feb 2022 03:58:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645790303;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XQgbrcsjCANxz/Of//gf2z45aVY1hxYCVO9u5dn2lAg=;
        b=ZB2qUdLLIXk0p+o0zZLCZyFviMDuNgRZO9VX3Idg8jmEEOQu/LSBv3v6/pAjqfL7RW0h1x
        hoju9KcWPpQTzH60FOCbFFNvuW23X6+EgrqCOnsE2QGs7g8mSi6o8873Y+3ielR3CWdTUn
        9n4oMOgqMh4u9VA+5XmLpa+R8Hg9oBY=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-463-hyzuOIzCPte2i5b4CoZCyQ-1; Fri, 25 Feb 2022 06:58:22 -0500
X-MC-Unique: hyzuOIzCPte2i5b4CoZCyQ-1
Received: by mail-wr1-f69.google.com with SMTP id k20-20020adfc714000000b001e305cd1597so796724wrg.19
        for <netfilter-devel@vger.kernel.org>; Fri, 25 Feb 2022 03:58:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:organization
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=XQgbrcsjCANxz/Of//gf2z45aVY1hxYCVO9u5dn2lAg=;
        b=wC3SyPUD4tR2qiIm5A0vvQZCffNRyvekoODOnMAWCgui9G97ZixGduEducXwla6EA2
         aUljW1bMglZsYMAPy7WTkDj4IZHnLvGj+gAGGYBWZdOti9UdX5k2WqnJorqf1CZhMAiM
         gjLuOAe8eqhR073RWXnV4EeusnWwQLHZEWPLQWqk6Wjt1JzgmOGqfiPUlNl+uC6Q5R8e
         xEKMU2W/lCqsrkGlexrO3SP7E8XCgaB45/yfZxw/DVT32OOoCdjWy2Bk0F39PofUndxH
         bLCoTlK0LMDFPFWmis5nct560PN33vNCQz7B6FSo/3/WoT9nmrZdd1GL2PbI3Emvd7xl
         Yf5A==
X-Gm-Message-State: AOAM532XmBdDD44qhqemL7iTVY/OLxbKmaNaOMmoSrK6PYJyrQT4PnH1
        uAGgT94MLg92hTXdg9ofXO1mZ2j79VaXU4y8WOC+suZGEUyU+rXfOxM4pVz9KlR3/aIfEnRJBes
        tuHHZxIDIsNc04YCgdL5YGGa0O/dYuwCMJf8QK2p3ltNbhuD56+zKldfveYlFRpe8iODTUhShmL
        trmlszbg==
X-Received: by 2002:a7b:c192:0:b0:380:fa7a:4f7d with SMTP id y18-20020a7bc192000000b00380fa7a4f7dmr2396140wmi.119.1645790300669;
        Fri, 25 Feb 2022 03:58:20 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyr9r7yux0Nk1L74WVrM7Qm+Ht43rlU8sEVZ2SOOUk+kg1tXhoK57dPICBP3WqOmBDzdasY1g==
X-Received: by 2002:a7b:c192:0:b0:380:fa7a:4f7d with SMTP id y18-20020a7bc192000000b00380fa7a4f7dmr2396116wmi.119.1645790300333;
        Fri, 25 Feb 2022 03:58:20 -0800 (PST)
Received: from butterfly.localnet ([83.148.33.151])
        by smtp.gmail.com with ESMTPSA id x5-20020adfec05000000b001e58cc95affsm2034003wrn.38.2022.02.25.03.58.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Feb 2022 03:58:19 -0800 (PST)
From:   Oleksandr Natalenko <oleksandr@redhat.com>
To:     netfilter-devel@vger.kernel.org
Cc:     Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH nf] netfilter: nf_queue: don't assume sk is full socket
Date:   Fri, 25 Feb 2022 12:58:19 +0100
Message-ID: <2216610.mTzm8X9j6q@redhat.com>
Organization: Red Hat
In-Reply-To: <20220223201004.30615-1-fw@strlen.de>
References: <20220223201004.30615-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hello.

On st=C5=99eda 23. =C3=BAnora 2022 21:10:04 CET Florian Westphal wrote:
> There is no guarantee that state->sk refers to a full socket.
>=20
> If refcount transitions to 0, sock_put calls sk_free which then ends up
> with garbage fields.
>=20
> I'd like to thank Oleksandr Natalenko and Jiri Benc for considerable
> debug work and pointing out state->sk oddities.

No thank you for spotting the exact issue.

> Fixes: ca6fb0651883 ("tcp: attach SYNACK messages to request sockets inst=
ead of listener")
> Signed-off-by: Florian Westphal <fw@strlen.de>

Tested-by: Oleksandr Natalenko <oleksandr@redhat.com>

> ---
>  No reproducer, so there is a chance that the reported crash is caused by
>  something else. That said, I don't see how sock_put use is safe here.

Using your reproducer from [1] I could trigger the issue on unpatched kerne=
l and couldn't trigger the issue on patched kernel with the patch from belo=
w applied.

[1] https://patchwork.ozlabs.org/project/netfilter-devel/patch/202202241521=
18.20619-1-fw@strlen.de/

>=20
>  net/netfilter/nf_queue.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/net/netfilter/nf_queue.c b/net/netfilter/nf_queue.c
> index 6d12afabfe8a..178742a110d9 100644
> --- a/net/netfilter/nf_queue.c
> +++ b/net/netfilter/nf_queue.c
> @@ -54,7 +54,7 @@ static void nf_queue_entry_release_refs(struct nf_queue=
_entry *entry)
>  	dev_put(state->in);
>  	dev_put(state->out);
>  	if (state->sk)
> -		sock_put(state->sk);
> +		sock_gen_put(state->sk);
> =20
>  #if IS_ENABLED(CONFIG_BRIDGE_NETFILTER)
>  	dev_put(entry->physin);
>=20


=2D-=20
Oleksandr Natalenko (post-factum)
Principal Software Maintenance Engineer


