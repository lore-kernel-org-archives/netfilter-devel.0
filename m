Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C718BE7D0AA
	for <netfilter-devel@archiver.kernel.org>; Thu, 21 Sep 2023 20:48:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232430AbjIUUsF (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 21 Sep 2023 16:48:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230410AbjIUUru (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 21 Sep 2023 16:47:50 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5AA37E4E4
        for <netfilter-devel@vger.kernel.org>; Thu, 21 Sep 2023 10:36:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1695317763;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7L/Yzv6HMqOR9bct7nj3Jb7bGoexyEhbypyyoWQ6koA=;
        b=EFKNCVQm68XViqqpzqEQxM617vxX4aUD5J64VZyMkIYMu0AM4v7L4axIbEiO4w54KZUgYM
        Xp1s2VCrA/D2lQR7nhC0vcatX8/1YsagxNoNoJh/WEp2OuoziIA8uoqXAZ1rdkQxdPDcU1
        8P8OlDLWWssaDwg+36yk5DA065dblss=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-606-vUu4ihp7Pwea1FTPug7Mkg-1; Thu, 21 Sep 2023 05:08:23 -0400
X-MC-Unique: vUu4ihp7Pwea1FTPug7Mkg-1
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-31ff3e943e0so16158f8f.0
        for <netfilter-devel@vger.kernel.org>; Thu, 21 Sep 2023 02:08:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695287302; x=1695892102;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=7L/Yzv6HMqOR9bct7nj3Jb7bGoexyEhbypyyoWQ6koA=;
        b=f1sLyXfuad5tX/rmCGprQf/zoQeKULbMv51daxkmvx/EB89BMFRB9Gq855+DUNtkiz
         hHfcV1pobZHza+wR+kLJfrM4rkaiG97rk59toEeVoZNgcvJF4LaLrtIZkjsOXjTi7Hga
         qmLFzqHcakzGRWyivDU2PNep8wtLFcgPfm9kQol9IgbLIYhIi2uP+6igYYi3C24Y5K+n
         GOAcKVIf0N5yczhAGCM8FN8Z6oTyDKfYv6st235oVD2zADXpJBxSqgCUbe+y3lc5f2K0
         IyPTPCYYXfIqSuoVmllkemNzBxSotkOC8FRMSLp1EjdWFc/c4BjJlra0LAdYkCSTReHU
         sLCA==
X-Gm-Message-State: AOJu0YwC8MmcYLdnWtqKFZqMdiX3S7YTnHTbuDeAqOBs2A3UDlUPTu7v
        aVnv/WP36xcG7hHcQcBucsKhb/tlQhpKLm+DosCqURoytsvtkgNxX1Vojio0u7j0ItDZ/Ufwz/f
        VFmyFUj2uc3WNg2k6Vt+tXEx6aD58pmm+jg9e
X-Received: by 2002:a5d:4fcd:0:b0:321:547b:f060 with SMTP id h13-20020a5d4fcd000000b00321547bf060mr4002944wrw.1.1695287301983;
        Thu, 21 Sep 2023 02:08:21 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGKJpATv7qud8ZIQizMun7Ed5aJba2m6fdDKobC3LDsscg8q1YZBK2G2D3zbDYnaOIw+0kvhg==
X-Received: by 2002:a5d:4fcd:0:b0:321:547b:f060 with SMTP id h13-20020a5d4fcd000000b00321547bf060mr4002928wrw.1.1695287301644;
        Thu, 21 Sep 2023 02:08:21 -0700 (PDT)
Received: from [10.0.0.196] ([37.186.167.86])
        by smtp.gmail.com with ESMTPSA id o9-20020a5d6849000000b0031989784d96sm1181983wrw.76.2023.09.21.02.08.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Sep 2023 02:08:21 -0700 (PDT)
Message-ID: <4adc5da36ee141a73a0131c02fcc652f235c144b.camel@redhat.com>
Subject: Re: [PATCH nft 3/4] all: add free_const() and use it instead of
 xfree()
From:   Thomas Haller <thaller@redhat.com>
To:     Phil Sutter <phil@nwl.cc>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        NetFilter <netfilter-devel@vger.kernel.org>
Date:   Thu, 21 Sep 2023 11:08:20 +0200
In-Reply-To: <ZQt3Gm5HWLKkOEB5@orbyte.nwl.cc>
References: <20230920131554.204899-1-thaller@redhat.com>
         <20230920131554.204899-4-thaller@redhat.com>
         <ZQr+F7ChyFfArBYQ@orbyte.nwl.cc> <ZQsYf3moTtXQytXX@calendula>
         <ZQsitnx/cPf2cPk0@orbyte.nwl.cc>
         <754c07f7fc0a44d3619e51993c7a891a064ccdae.camel@redhat.com>
         <ZQs4eu74k86+7FK0@orbyte.nwl.cc>
         <f56d6b485b7154c8b8c24765ced9d222eabbd211.camel@redhat.com>
         <ZQt3Gm5HWLKkOEB5@orbyte.nwl.cc>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.48.4 (3.48.4-1.fc38) 
MIME-Version: 1.0
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, 2023-09-21 at 00:50 +0200, Phil Sutter wrote:
> On Wed, Sep 20, 2023 at 09:48:40PM +0200, Thomas Haller wrote:
> >=20
> > datatype_free() in the patch uses+requires free_const() twice:
> >=20
> > =C2=BB=C2=B7=C2=B7=C2=B7=C2=B7=C2=B7=C2=B7=C2=B7free_const(dtype->name)=
;
> > =C2=BB=C2=B7=C2=B7=C2=B7=C2=B7=C2=B7=C2=B7=C2=B7free_const(dtype->desc)=
;
> > =C2=BB=C2=B7=C2=B7=C2=B7=C2=B7=C2=B7=C2=B7=C2=B7free(dtype);
>=20
> Ah, I see. The only reason why these are allocated is
> concat_type_alloc(), BTW. If it didn't exist, dtype_clone() could
> just
> copy the pointers and datatype_free() would ignore them.


Good point. It's easy to avoid cloning the strings for some particular
cases. Patch will follow.

Thomas

