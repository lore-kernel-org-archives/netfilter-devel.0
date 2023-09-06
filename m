Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3EF6BEB8FDE
	for <netfilter-devel@archiver.kernel.org>; Wed,  6 Sep 2023 14:40:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234885AbjIFOk3 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 6 Sep 2023 10:40:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230039AbjIFOk2 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 6 Sep 2023 10:40:28 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6747C92
        for <netfilter-devel@vger.kernel.org>; Wed,  6 Sep 2023 07:39:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1694011179;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=REdtke3vmj9Nqdu5Ci+lwg5/zM8m+BVWX0KHd2gYMuQ=;
        b=U3iodFpgavynNYCY0oEA/ISRPTedLaH/FOVvk+C4AygsM6qfRSDtoRoPA0OvAN5CC/ZzEl
        rfHs8DG6zTSM9tyFi23RsOw3dmMMpFc3zoSSc9GUe7VXv3OY8IVCTf6I3jD9OfYkeQ7cau
        mpSAbdTxPIM50EhrI0eZ7D2J+Fpz0EE=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-301-yK7UWhfJNaiv1BmNNjOdKw-1; Wed, 06 Sep 2023 10:39:38 -0400
X-MC-Unique: yK7UWhfJNaiv1BmNNjOdKw-1
Received: by mail-ej1-f70.google.com with SMTP id a640c23a62f3a-9a1c758ef63so49946366b.1
        for <netfilter-devel@vger.kernel.org>; Wed, 06 Sep 2023 07:39:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1694011176; x=1694615976;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:to:from:subject:message-id:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=REdtke3vmj9Nqdu5Ci+lwg5/zM8m+BVWX0KHd2gYMuQ=;
        b=NwoBmSVzlyPP6QGRSGtE6dHOqR4IPe2fFou03z9VfVvR9/0sxVY66rZwANEbhF/IHs
         bZJBWquMDH9ZRlZu1vTYSqx4ZZwAs0UhOLA+iF4y5Od5HfQ7me6c35U3P3TsbleOhoGb
         07sizo1GnSRrn7xPj6xxOCcJ8jZozSiTSFJgNy68N94swjG73XLKBIsgUROdhsj4zJHT
         02VZiZ1Nif8o9tRXIOrLcevXGg4bAWOW2QhbLJJnt8sEbFqSHYF8hVVI+ng8qhB9lXMd
         Q8EQqXocU+iUWOKZE3Tb73rkMcr6VECOMdlz+oZ8vfpToeJEMOZEO4KgBJConjFNS3ip
         jWjg==
X-Gm-Message-State: AOJu0Yy7VMi+qtxTgW/ZMTkcC0lYB+3XUG9mu0b4PQnPkSrECyoobP/m
        R0M4EyTGZLHxjxtPoTdnFWWBKEQJ5+XVmYkoM5Nb4iAlTLpp4x8jw1mRa+Q5FkuG9HB2EXPGNSF
        XJTRKzqfJXf/a/cIQ7dG1azlmUBBcAb9ziydY
X-Received: by 2002:a17:906:109a:b0:9a1:ffec:aadf with SMTP id u26-20020a170906109a00b009a1ffecaadfmr11178472eju.5.1694011176110;
        Wed, 06 Sep 2023 07:39:36 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHliGJ7xNgLOuA0EcT4C7S+C6GbVeW17wWaBaaT1w+1a8C/6xf7MHrsUmcCE89H4vLHuV66yA==
X-Received: by 2002:a17:906:109a:b0:9a1:ffec:aadf with SMTP id u26-20020a170906109a00b009a1ffecaadfmr11178463eju.5.1694011175817;
        Wed, 06 Sep 2023 07:39:35 -0700 (PDT)
Received: from [10.0.0.196] ([37.186.167.86])
        by smtp.gmail.com with ESMTPSA id qx12-20020a170906fccc00b0099bd86f9248sm9072778ejb.63.2023.09.06.07.39.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Sep 2023 07:39:35 -0700 (PDT)
Message-ID: <31f44ad2e7c4451554dc3cca6742140b733c1cdd.camel@redhat.com>
Subject: Re: [PATCH nft 4/5] tests: shell: add and use feature probe for map
 query like a set
From:   Thomas Haller <thaller@redhat.com>
To:     Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
Date:   Wed, 06 Sep 2023 16:39:34 +0200
In-Reply-To: <20230904090640.3015-5-fw@strlen.de>
References: <20230904090640.3015-1-fw@strlen.de>
         <20230904090640.3015-5-fw@strlen.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.48.4 (3.48.4-1.fc38) 
MIME-Version: 1.0
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, 2023-09-04 at 11:06 +0200, Florian Westphal wrote:
>=20
> +set +e
> +$NFT get element ip dynset dynmark { 10.2.3.4 } && exit 1
> +
> +# success, but indicate skip for reduced test to avoid dump
> validation error
> +if [ $NFT_HAVE_map_lookup -eq 0 ];then
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0exit 123
> +fi

Instead of adding a comment, print a message with the reason why it was
skipped. That's useful information to see in the test output.
The `echo` line also makes the comment redundant.

Thomas

