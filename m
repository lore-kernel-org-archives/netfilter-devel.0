Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 565EAC04FF1
	for <netfilter-devel@archiver.kernel.org>; Wed, 20 Sep 2023 19:24:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230059AbjITTYr (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 20 Sep 2023 15:24:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230078AbjITTYo (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 20 Sep 2023 15:24:44 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECCBCC9
        for <netfilter-devel@vger.kernel.org>; Wed, 20 Sep 2023 12:23:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1695237831;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9dvld/WPd0EFVWG7SD8/boCPVhylmIiN190h8yVQI0Y=;
        b=Ob5WQvkHBq064TtyYusg+RmeVRtgceCTVx5+LRcJDjnVCoCDagoYTZsZAQhro+cJktSt4Q
        1r8At8b5o+7O+qC0hYKfsWwA1ugmI9mcflBTYR8yng4ft1gBLANo4GEZ3jqzqrEw25ZokZ
        478hMqAa1Dczzpaa/JheJ6vTyy3Ygcw=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-610-xfqWrLVkOweljSavmOxJZw-1; Wed, 20 Sep 2023 15:23:49 -0400
X-MC-Unique: xfqWrLVkOweljSavmOxJZw-1
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-31ff3e943e0so8772f8f.0
        for <netfilter-devel@vger.kernel.org>; Wed, 20 Sep 2023 12:23:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695237828; x=1695842628;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=9dvld/WPd0EFVWG7SD8/boCPVhylmIiN190h8yVQI0Y=;
        b=RgzmvdZrnpEsax2I0Jfmpr/EfTkpRwZNT8wt7UQsQYvOMOgmVCMTQpF/I8TqelvVu+
         1HN4FUWJFF7m+i0aglHFzN0ROs88p5PTan5KFldli7lHhe6lUVsoNVTw/rGJucbufH/8
         coO1wtc+5nsXxmhij9MX2jJKCmLro6UFYZoqzFjaVNXWjAO4EfTKcEaaip+kpiyM1rr7
         xuficY4wp44mwVTyQq1hwp4E1eG7deMTdgoYfa5cyRwk13lMXbdjMzjHEHmA8I8OTZ3f
         s736VdEtAnYZiHmG6wNBU5jqvhQG9sveTrxMcJMLHTthK+Y0zRSxRJY2klSFAbwXHOhs
         TZgw==
X-Gm-Message-State: AOJu0YyXkcMecg/BiqX0Ad+Jz0+v+LEt59YQ0bpFqaQsNR6TUDVkbqQg
        Vyotcw+7OZwYDCjkbEF54g3uMlRdEGb696rrqxF3Xm0/UwGqfNeMTcwY5kpacDP0Am/smyf5Va/
        V4S1T1dO3yjPYRF9v9Qk0i0e4eou7u85pf0d7
X-Received: by 2002:a5d:6a8c:0:b0:31a:e54e:c790 with SMTP id s12-20020a5d6a8c000000b0031ae54ec790mr3069997wru.6.1695237828100;
        Wed, 20 Sep 2023 12:23:48 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFTI7SKl1kz63OmGuqgRADMsEj3ronYkaEfZUdohfeklECj4Xi7R6Sf3PK5kCLpbHQEArkOgw==
X-Received: by 2002:a5d:6a8c:0:b0:31a:e54e:c790 with SMTP id s12-20020a5d6a8c000000b0031ae54ec790mr3069980wru.6.1695237827697;
        Wed, 20 Sep 2023 12:23:47 -0700 (PDT)
Received: from [10.0.0.196] ([37.186.167.86])
        by smtp.gmail.com with ESMTPSA id bw17-20020a0560001f9100b003217cbab88bsm1095546wrb.16.2023.09.20.12.23.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Sep 2023 12:23:47 -0700 (PDT)
Message-ID: <546258d1a67ca455e0f7fdcce4c58c587324e798.camel@redhat.com>
Subject: Re: [PATCH nft 3/9] datatype: drop flags field from datatype
From:   Thomas Haller <thaller@redhat.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     NetFilter <netfilter-devel@vger.kernel.org>
Date:   Wed, 20 Sep 2023 21:23:46 +0200
In-Reply-To: <ZQs1msEk15D687Rn@calendula>
References: <20230920142958.566615-1-thaller@redhat.com>
         <20230920142958.566615-4-thaller@redhat.com> <ZQs1msEk15D687Rn@calendula>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.48.4 (3.48.4-1.fc38) 
MIME-Version: 1.0
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, 2023-09-20 at 20:10 +0200, Pablo Neira Ayuso wrote:
> On Wed, Sep 20, 2023 at 04:26:04PM +0200, Thomas Haller wrote:
> > Flags are not always bad. For example, as a function argument they
> > allow
> > easier extension in the future. But with datatype's "flags"
> > argument and
> > enum datatype_flags there are no advantages of this approach.
> >=20
> > - replace DTYPE_F_PREFIX with a "bool f_prefix" field. This could
> > even
> > =C2=A0 be a bool:1 bitfield if we cared to represent the information
> > with
> > =C2=A0 one bit only. For now it's not done because that would not help
> > reducing
> > =C2=A0 the size of the struct, so a bitfield is less preferable.
> >=20
> > - instead of DTYPE_F_ALLOC, use the refcnt of zero to represent
> > static
> > =C2=A0 instances. Drop this redundant flag.
>=20
> Not sure I want to rely on refcnt to zero to identify dynamic
> datatypes. I think we need to consolidate datatype_set() to be used
> not only where this deals with dynamic datatypes, it might help
> improve traceability of datatype assignment.

I don't understand. Could you elaborate about datatype_set()?

Btw, for dynamically allocated instances the refcnt is always positive,
and for static ones it's always zero. The DTYPE_F_ALLOC flag is
redundant.


Thomas

