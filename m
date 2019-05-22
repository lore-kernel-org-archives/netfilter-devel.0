Return-Path: <SRS0=iiCe=TW=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3867DC282CE
	for <netfilter-devel@archiver.kernel.org>; Wed, 22 May 2019 11:40:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0D45E20868
	for <netfilter-devel@archiver.kernel.org>; Wed, 22 May 2019 11:40:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WItvkVfz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728925AbfEVLkJ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 22 May 2019 07:40:09 -0400
Received: from mail-ua1-f66.google.com ([209.85.222.66]:46081 "EHLO
        mail-ua1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727464AbfEVLkJ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 22 May 2019 07:40:09 -0400
Received: by mail-ua1-f66.google.com with SMTP id a95so714865uaa.13
        for <netfilter-devel@vger.kernel.org>; Wed, 22 May 2019 04:40:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=hsXkseJrU9Fv8d94j+UTu4Z9rUYQDLsh+mplf5HyIiw=;
        b=WItvkVfzoWjBOMSzvJIMaloXiL/9duc3W27d3VT1rt6mufUR09c7d2+eRJhkiiM1DE
         3KhkFYONSxsQAytQbiKp9OmkjvTfCtMDrPCw8BboPqYM1/jebiK/2Mgnp7UgAlPpsggd
         +q5xs6zYmgulT7VX94c6AHMfhRyNVNVKZaghRWUbnjDFFKmS+AELoA0Bb/HF7r8qfuuD
         RBe75WQ0rUTG1nuSr3o6TZdcKN688junurP4Dl2kVwtZPlUshPeYb444GUf9fUJuvJyK
         JYffC5gDp6ykdLA05SJ9DH1u7yqZJSdraHpmurMD3fKwxWElhQmC5kqD0UstQDBRTuzu
         s3dA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=hsXkseJrU9Fv8d94j+UTu4Z9rUYQDLsh+mplf5HyIiw=;
        b=ejmXXKVDtTe07f3p+x4tGXMLwTUcsEVWOZVNoYwLdB1Q5IBJOyw8r70HZ3T1reW0c/
         Dlyp2lXvC4PikQ/0I8Nl1wgoL4Bt3ewH7VffwtAK40T8yNb3v7kf5kynvmM4EvS3pAgN
         2RyyUgGX0fk362+2isg3Sfw6StoM0/QQ+GuGTExXd95cZ9JEbwmIS1W814bX5u9cTtM1
         N+0HUaAxfHMNcSjxDZBvIZhvqHKbC7fUv1XM3E6EQAi6HI3QQIGp10zy88dqbCUbxNCo
         1K72W/OGrUKmpNP8Y20Miuu+R8WA1addhn6h+BZZhqrEPmPXQYL0TWOIfwXeu8VaZZeW
         d9fA==
X-Gm-Message-State: APjAAAW0sQIV2aDuyTbSiPDRUEXkq845ZbnXUSa2H/p9bCKFaYuTp8To
        T+p7bA/L9NZ3mWSZZFBwwkEWRFPypZ6YPXDHNbk=
X-Google-Smtp-Source: APXvYqwFmbcaG6jHzOz9mVc1QikzjRk/3riNifePrw4KdY1tYqbRWXeA7h7sKVIUhJ3CdoniX8Rx/rwN/7O+ttkLXlU=
X-Received: by 2002:a9f:2103:: with SMTP id 3mr22570738uab.100.1558525208381;
 Wed, 22 May 2019 04:40:08 -0700 (PDT)
MIME-Version: 1.0
References: <20190517164031.8536-1-sveyret@gmail.com> <20190517164031.8536-2-sveyret@gmail.com>
 <20190522084615.tyjlorqfxyz5p2c2@salvia>
In-Reply-To: <20190522084615.tyjlorqfxyz5p2c2@salvia>
From:   =?UTF-8?Q?St=C3=A9phane_Veyret?= <sveyret@gmail.com>
Date:   Wed, 22 May 2019 13:39:57 +0200
Message-ID: <CAFs+hh6vX8-B9nyrTfN9=_qVr=0jYW9EYdmn0aQxg7gJXu0EMg@mail.gmail.com>
Subject: Re: [PATCH nf-next,v3] netfilter: nft_ct: add ct expectations support
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Thank you Pablo for your feedback. See my comments below.

Le mer. 22 mai 2019 =C3=A0 10:46, Pablo Neira Ayuso <pablo@netfilter.org> a=
 =C3=A9crit :
> I think we should set a maximum number of expectations to be created,
> as a mandatory field, eg.
>
>           size 10;

I feel it would be complicated to set, as it would require to keep
track of all expectations set using this definition, and moreover,
check if those expectations are still alive, or deleted because
already used or timed out.

> > +     priv->l3num =3D ctx->family;
>
> priv->l3num is only set and never used, remove it. You'll also have to

priv->l3num is used for setting expectation, in function
nft_ct_expect_obj_eval (see the call to nf_ct_expect_init).

> > +     nf_ct_helper_ext_add(ct, GFP_ATOMIC);
>
> I think you don't need nf_ct_helper_ext_add(...);

Actually, I had to add this instruction. While testing the feature, i
saw that, even if no helper is really set on the connection,
expectation functions require NF_CT_EXT_HELPER to be set on master
connection. Without it, there would be some null pointer exception,
which fortunately is checked at expectation creation by
__nf_ct_expect_check.

Regards,

St=C3=A9phane.
