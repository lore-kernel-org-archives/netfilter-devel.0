Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E20EE80AB1
	for <netfilter-devel@archiver.kernel.org>; Wed, 27 Sep 2023 14:25:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232076AbjI0OZL (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 27 Sep 2023 10:25:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232045AbjI0OZK (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 27 Sep 2023 10:25:10 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABDA8F9
        for <netfilter-devel@vger.kernel.org>; Wed, 27 Sep 2023 07:24:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1695824664;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=aYerT9MfuYGQIQUVZ734QLxjwDC8hS56rwhZM7dz/MA=;
        b=INoBEbhUgt80u9P98y1OT+LaFiH1tTSQTFXGDdTBKNPwJ/xy+zbDiBbfJMABY0TsrcmN9z
        dp7vD4d80II7UEPxCxBmt6om41u8JoNs0EP8DKj5dQdI92y0XNQ4x4RKwgY9cFVyb8FI41
        vIinrCw5DHC3N7mupQ4wz+utX/5Mtuc=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-648-QuqRSYGROni-5HTZfv7-Hw-1; Wed, 27 Sep 2023 10:24:22 -0400
X-MC-Unique: QuqRSYGROni-5HTZfv7-Hw-1
Received: by mail-ej1-f70.google.com with SMTP id a640c23a62f3a-9b295d163fdso109345966b.1
        for <netfilter-devel@vger.kernel.org>; Wed, 27 Sep 2023 07:24:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695824661; x=1696429461;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:to:from:subject:message-id:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=aYerT9MfuYGQIQUVZ734QLxjwDC8hS56rwhZM7dz/MA=;
        b=PK9RQyRKc0rF8a4E7e0u8dMpXMxAFd91dNpeXpO/AyVm+hZh7xFCJM19reC9Ph76Me
         lzkoFFMATrsbSNxnPBlEb9l1prZd4pH7ABGE54V8lXJP1KBhpMi8AMlsk1C5fBfXKxw9
         c9yQCb0hbZYPyzz0urFYGTZr41QP9Ih3ixMr4YKkiSlQxA8hUdX+jUeaKIgR8qbPH3xV
         bpXMFLCzP8edMx7RLKJtdApz01AIbGKeJ0bCWWY/Nwyfu3SXI4ejXsU2EE787SZn99gE
         EEvFrkyEkWBMC7myokz/s8fhhAGY0q8ODctrLAUxH6ZGDXsuGOJVtUEZB0RM45cceaCm
         nuFw==
X-Gm-Message-State: AOJu0Yw9SrLz6SORR7qB1esDDEZYa+ee3nilTvJUwShXkca8mimFonup
        AXakpB13btkVMpk77yrMPh/IJ2TLrUI8EBKmjX/CAT4v0L3Ufxoj8sajCN7Y8DB8s5Bd9P9qwrP
        X2BenRL9iQNeqiaJmh6roXxGaPX1k5HQTgwvJeHrm9HXNiZPpRG83jqJ9GAOSPuTfh03tMEWY5w
        o1h/tQpvQRTao=
X-Received: by 2002:a17:906:5190:b0:9a1:aea8:cb5a with SMTP id y16-20020a170906519000b009a1aea8cb5amr1821522ejk.1.1695824661361;
        Wed, 27 Sep 2023 07:24:21 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHbCd1h+lHbnVeKguy01PhUuV93rIOxSgdptbhkE+LDK0+MdZr8aVl8550i9jsW8w5E3t5ysQ==
X-Received: by 2002:a17:906:5190:b0:9a1:aea8:cb5a with SMTP id y16-20020a170906519000b009a1aea8cb5amr1821507ejk.1.1695824660863;
        Wed, 27 Sep 2023 07:24:20 -0700 (PDT)
Received: from [10.0.0.196] ([37.186.167.86])
        by smtp.gmail.com with ESMTPSA id bg1-20020a170906a04100b009adce1c97ccsm9440636ejb.53.2023.09.27.07.24.20
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Sep 2023 07:24:20 -0700 (PDT)
Message-ID: <6298b85f20f868e97e1465f06d7e68139b57aca8.camel@redhat.com>
Subject: Re: [PATCH nft 1/3] nft: add NFT_ARRAY_SIZE() helper
From:   Thomas Haller <thaller@redhat.com>
To:     NetFilter <netfilter-devel@vger.kernel.org>
Date:   Wed, 27 Sep 2023 16:24:19 +0200
In-Reply-To: <20230927122744.3434851-2-thaller@redhat.com>
References: <20230927122744.3434851-1-thaller@redhat.com>
         <20230927122744.3434851-2-thaller@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.48.4 (3.48.4-1.fc38) 
MIME-Version: 1.0
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, 2023-09-27 at 14:23 +0200, Thomas Haller wrote:
> Add NFT_ARRAY_SIZE() macro, commonly known as ARRAY_SIZE() (or
> G_N_ELEMENTS()).
>=20
> <nft.h> is the right place for macros and static-inline functions. It
> is
> included in *every* C sources, as it only depends on libc headers and
> <config.h>. NFT_ARRAY_SIZE() is part of the basic toolset, that
> should
> be available everywhere.
>=20
> Signed-off-by: Thomas Haller <thaller@redhat.com>
> ---
> =C2=A0include/nft.h | 2 ++
> =C2=A01 file changed, 2 insertions(+)
>=20
> diff --git a/include/nft.h b/include/nft.h
> index 9384054c11c8..4463b5c0fa4a 100644
> --- a/include/nft.h
> +++ b/include/nft.h
> @@ -8,4 +8,6 @@
> =C2=A0#include <stdint.h>
> =C2=A0#include <stdlib.h>
> =C2=A0
> +#define NFT_ARRAY_SIZE(arr) (sizeof(arr)/sizeof((arr)[0]))
> +
> =C2=A0#endif /* NFTABLES_NFT_H */

oh, I just found the "array_size()" macro. Didn't expect it to be
lower-case.

Will use that in v2.

Thomas

