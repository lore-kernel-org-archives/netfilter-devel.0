Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BCA62EE49A6
	for <netfilter-devel@archiver.kernel.org>; Thu, 24 Aug 2023 11:47:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238996AbjHXLrU (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 24 Aug 2023 07:47:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241142AbjHXLqy (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 24 Aug 2023 07:46:54 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFCE81736
        for <netfilter-devel@vger.kernel.org>; Thu, 24 Aug 2023 04:46:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1692877574;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=AzIih3JvCE9DGHO93tElU7vDOT/6ETH+VEsIZT4s4u8=;
        b=A657N6j2IwahdgPhD9sQAEekCZBJizcssaJA676qnr+FNsxh1U+gjJD/LZsZxXTxi9N5er
        CPCGPlKIFtxovochs0t2+pkjzal6YuQPAW8EgNoLIEJmSbOEiw+TpdJiAjFpcT1Xk2vrkK
        k1pkrCrNkFFw1LB8Z5PMdXp4w5yu0h8=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-307-r9-h0C_rNsivrO8uJ8n3oQ-1; Thu, 24 Aug 2023 07:46:12 -0400
X-MC-Unique: r9-h0C_rNsivrO8uJ8n3oQ-1
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-3fe805a8826so12748585e9.0
        for <netfilter-devel@vger.kernel.org>; Thu, 24 Aug 2023 04:46:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692877571; x=1693482371;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:to:from:subject:message-id:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=AzIih3JvCE9DGHO93tElU7vDOT/6ETH+VEsIZT4s4u8=;
        b=MRu30ulHMO5mJwSnncjdIaW884t6er0L0sPbuA+Coz4zdZuvtiCRPD6MfAmAmkZhws
         f56kRI5gBWz0XoFOGuYGbA79DmYTlC6OeCgBilrk7CFkXTjBsSTLg7+zngoe4FModZ8O
         bVtzonA1ndnF5e7n5XRxMdw/saofNKLVvf8p4Pz+FjIKVewXtsIUv6eLRWzeiXEynq0n
         eAl8msXJYWlrnDqspWxBOLwNOpETXQMdf3XBCmBCQJ/COEcUY2605KtANOh/ytvgs16q
         uMkDo0VUgNrCi+bJ/zyYbZCKGDFLKLyElb8ZjY0ZctstwBWLZWTKvlFyMiKJh0t5mn5o
         hKig==
X-Gm-Message-State: AOJu0YxuGZZUgffHcuzAFa/KXV4TYrXAcQtgfyu9iSKcoUEAPIk/UhLp
        ju2FnLW2bCInGHWEE7Yvj6jkumWMA5K73sWigoLSbNi5p0GOFKawMg+GDFTawPfJMuqByyESujG
        wFd/28bIUoUWUzSx/j2YtCMIQ7pDdoWK3+VkqCECYGL2hs4xx0C8rjvfVcIKiwD2Hk9NBe0phIK
        V4c6Zc4DWnCFo=
X-Received: by 2002:a05:600c:3b05:b0:3f6:8a3:8e59 with SMTP id m5-20020a05600c3b0500b003f608a38e59mr12101977wms.1.1692877571228;
        Thu, 24 Aug 2023 04:46:11 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHA4w0UVlLgbpXEKLXF/fztZVQIbx5ejmKzAGUDUL6PumEIwaQSe9LyG9IKmag0eDYxoMJU1g==
X-Received: by 2002:a05:600c:3b05:b0:3f6:8a3:8e59 with SMTP id m5-20020a05600c3b0500b003f608a38e59mr12101965wms.1.1692877570823;
        Thu, 24 Aug 2023 04:46:10 -0700 (PDT)
Received: from [10.0.0.196] ([37.186.167.86])
        by smtp.gmail.com with ESMTPSA id u6-20020a7bc046000000b003fedcd02e2asm2402865wmc.35.2023.08.24.04.46.09
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Aug 2023 04:46:10 -0700 (PDT)
Message-ID: <5abb46169719717e3761a5833deb87a7fcaee52b.camel@redhat.com>
Subject: Re: [PATCH nft 4/6] configure: use AC_USE_SYSTEM_EXTENSIONS to get
 _GNU_SOURCE
From:   Thomas Haller <thaller@redhat.com>
To:     NetFilter <netfilter-devel@vger.kernel.org>
Date:   Thu, 24 Aug 2023 13:46:09 +0200
In-Reply-To: <20230824111456.2005125-5-thaller@redhat.com>
References: <20230824111456.2005125-1-thaller@redhat.com>
         <20230824111456.2005125-5-thaller@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.48.4 (3.48.4-1.fc38) 
MIME-Version: 1.0
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, 2023-08-24 at 13:13 +0200, Thomas Haller wrote:
>=20
> diff --git a/configure.ac b/configure.ac
> index 42f0dc4cf392..9d859307adaa 100644
> --- a/configure.ac
> +++ b/configure.ac
> @@ -45,6 +45,9 @@ fi
> =C2=A0AM_PROG_AR
> =C2=A0LT_INIT([disable-static])
> =C2=A0AM_PROG_CC_C_O
> +
> +AC_USE_SYSTEM_EXTENSIONS

AC_USE_SYSTEM_EXTENTIONS needs to move up, right after AC_PROG_CC.
I will fix that in v2.


Thomas

