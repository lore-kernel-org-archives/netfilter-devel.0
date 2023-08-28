Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7137AC83F12
	for <netfilter-devel@archiver.kernel.org>; Mon, 28 Aug 2023 13:27:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230136AbjH1N0w (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 28 Aug 2023 09:26:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231216AbjH1N03 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 28 Aug 2023 09:26:29 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5651111D
        for <netfilter-devel@vger.kernel.org>; Mon, 28 Aug 2023 06:25:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1693229140;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3lkVi8G9t3DhEUoFFRrWK8mrl/xbvzQsgW1UJs7JQLE=;
        b=JQykOUc42Pgk1YCb5H8LZRQzsMlwB75Q0EMaTNMpVV9Gv4gFRYBMPPDOJTHU53+3xTrL9V
        FDB54/CFIe8pfvmCsLRMzjcCeBXs5i82cB3j64zF1noTzJvTBFSHjC+d/cetIGmX4e+niA
        3wTz8MgYO8AvarnaCFGT0iYIV2st7lc=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-78-Pm2ZKsKbNfyIMRfjRE56pg-1; Mon, 28 Aug 2023 09:25:37 -0400
X-MC-Unique: Pm2ZKsKbNfyIMRfjRE56pg-1
Received: by mail-qt1-f199.google.com with SMTP id d75a77b69052e-40ff89fcb76so38678811cf.2
        for <netfilter-devel@vger.kernel.org>; Mon, 28 Aug 2023 06:25:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693229136; x=1693833936;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3lkVi8G9t3DhEUoFFRrWK8mrl/xbvzQsgW1UJs7JQLE=;
        b=icoh6A716+iotS7h2nXHOzLcZSckWG1pHXM9OuchpIHuADlfCFkHrz0+mD6X/iittk
         Wdfb5g0f8DXKWZdN4cWgQOBJg04ktEOhgkym8QpTjqAlEf4BcJ9RmNpsvxX3Po4mdt2N
         hqHf4IBCV3akuxIojKuYdNPOGDOuWXX2mpC3fLr2UFzh0pWhdTA+BYTCjqM7XhDTJmPR
         /ai6EaMXtZOeu3zPhbSXbJbgXzu/LbR6jXjB9bgH8joWWJI7V0jUfwva8AUA+eNw4TEo
         glDE2ZkHz0PHcnglp/lr6RkO2bHJxDCqjPUNk2ynObIrTyQ6fq5zy7wwBHivBVlEKwWs
         3CLg==
X-Gm-Message-State: AOJu0Yxq6f6HMRGNQ1aUxHIglZGfKkb1X1IrWC83hKCVokdVkPNWCW1n
        wUlYyuR7LyGsIiAH/4eixXJpP9gF3ZyJtddy/XlOU01tA5+m4wz51Xn1zzWfbOLQRbDSKiuHs36
        VlaiWVdBl8SvsztJuBn8cbAok4pFzKcMLaMUUmGiBQcKW
X-Received: by 2002:a05:622a:1a24:b0:411:f4fe:9ed9 with SMTP id f36-20020a05622a1a2400b00411f4fe9ed9mr16323496qtb.33.1693229136765;
        Mon, 28 Aug 2023 06:25:36 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGBLr77o5uusum213XormNvFrxdCOcrOegbeF8tGFSkFqjJPSBRC5UPszDdYzg0ivfq4iMGUTGklyqa2fGqOrY=
X-Received: by 2002:a05:622a:1a24:b0:411:f4fe:9ed9 with SMTP id
 f36-20020a05622a1a2400b00411f4fe9ed9mr16323477qtb.33.1693229136556; Mon, 28
 Aug 2023 06:25:36 -0700 (PDT)
MIME-Version: 1.0
References: <20230828132107.18376-1-wander@redhat.com>
In-Reply-To: <20230828132107.18376-1-wander@redhat.com>
From:   Wander Lairson Costa <wander@redhat.com>
Date:   Mon, 28 Aug 2023 10:25:25 -0300
Message-ID: <CAAq0SUkY=MfgJk+w8ZPtn=A5GEm_4BknPL-bgLn=77_fc3XX6Q@mail.gmail.com>
Subject: Re: [PATCH nf] netfilter/xt_u32: validate user space input
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Patrick McHardy <kaber@trash.net>,
        Jan Engelhardt <jengelh@gmx.de>,
        "open list:NETFILTER" <netfilter-devel@vger.kernel.org>,
        "open list:NETFILTER" <coreteam@netfilter.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Cc:     stable@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

+stable as I forgot to add it in the Cc section.

On Mon, Aug 28, 2023 at 10:21=E2=80=AFAM Wander Lairson Costa <wander@redha=
t.com> wrote:
>
> The xt_u32 module doesn't validate the fields in the xt_u32 structure.
> An attacker may take advantage of this to trigger an OOB read by setting
> the size fields with a value beyond the arrays boundaries.
>
> Add a checkentry function to validate the structure.
>
> This was originally reported by the ZDI project (ZDI-CAN-18408).
>
> Fixes: 1b50b8a371e9 ("[NETFILTER]: Add u32 match")
> Signed-off-by: Wander Lairson Costa <wander@redhat.com>
> ---
>  net/netfilter/xt_u32.c | 21 +++++++++++++++++++++
>  1 file changed, 21 insertions(+)
>
> diff --git a/net/netfilter/xt_u32.c b/net/netfilter/xt_u32.c
> index 177b40d08098..117d4615d668 100644
> --- a/net/netfilter/xt_u32.c
> +++ b/net/netfilter/xt_u32.c
> @@ -96,11 +96,32 @@ static bool u32_mt(const struct sk_buff *skb, struct =
xt_action_param *par)
>         return ret ^ data->invert;
>  }
>
> +static int u32_mt_checkentry(const struct xt_mtchk_param *par)
> +{
> +       const struct xt_u32 *data =3D par->matchinfo;
> +       const struct xt_u32_test *ct;
> +       unsigned int i;
> +
> +       if (data->ntests > ARRAY_SIZE(data->tests))
> +               return -EINVAL;
> +
> +       for (i =3D 0; i < data->ntests; ++i) {
> +               ct =3D &data->tests[i];
> +
> +               if (ct->nnums > ARRAY_SIZE(ct->location) ||
> +                   ct->nvalues > ARRAY_SIZE(ct->value))
> +                       return -EINVAL;
> +       }
> +
> +       return 0;
> +}
> +
>  static struct xt_match xt_u32_mt_reg __read_mostly =3D {
>         .name       =3D "u32",
>         .revision   =3D 0,
>         .family     =3D NFPROTO_UNSPEC,
>         .match      =3D u32_mt,
> +       .checkentry =3D u32_mt_checkentry,
>         .matchsize  =3D sizeof(struct xt_u32),
>         .me         =3D THIS_MODULE,
>  };
> --
> 2.41.0
>

