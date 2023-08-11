Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 229A3C41513
	for <netfilter-devel@archiver.kernel.org>; Fri, 11 Aug 2023 11:29:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236471AbjHKL33 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 11 Aug 2023 07:29:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236416AbjHKL32 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 11 Aug 2023 07:29:28 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFFBBE71
        for <netfilter-devel@vger.kernel.org>; Fri, 11 Aug 2023 04:28:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1691753322;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ntS/K3AkBFKQFK33sN3G1xppkVKVpYhps1z0LHfO48Q=;
        b=bBSXzlPwxlmfjS4yMW1o1NtYmShFIEzT+yRlosDCbtIo/exKXniQc11ynEVJmNbOj9vrAE
        yT/8LkZgQecLZLPhKP9gE5dk2hm2bAXrfqQPX7qDzeTCUYt5Wt0RhNwAp2s62loivHEhtw
        wTWqbpK52ifV9Ds1gAANutaE05G+BoQ=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-605-GVZaHnb-OyWl6PzFx7lE9A-1; Fri, 11 Aug 2023 07:28:40 -0400
X-MC-Unique: GVZaHnb-OyWl6PzFx7lE9A-1
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-31765e6c4b4so425434f8f.1
        for <netfilter-devel@vger.kernel.org>; Fri, 11 Aug 2023 04:28:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691753319; x=1692358119;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ntS/K3AkBFKQFK33sN3G1xppkVKVpYhps1z0LHfO48Q=;
        b=KgVkFQLN5jRfMUIbi02Ke9nxqmhURc0GCBIBM5ck9DTaZL3V3Z1roYCsv4UJxrclhC
         XFNF9YPsf21CNuahHj+SxI9qcMe0LoxxjBSg1aNjSGyBPe4KBE/SDujbhWZnH4UZuH2i
         v9OkAAACb+0LlY0N/C1T12kfJ0EFP3LLde8xBsdbEjsAnzr8NkfleWdUH/YIO3gGSRW4
         H5aeHxaEZWC2fnnWZodyIxxiz+bdjf9FOgUWHPbkIOawv32zm8hMSvSU169/wByvW8kE
         FUmmq+5m89e1P64+PoaASdp4RRN+NTaZtuNsEGEVbNWR/e/L+dEYU+I1Z6DXIvj21sSV
         yKIA==
X-Gm-Message-State: AOJu0YyJP9MF8FuG2zXzV6TdDhbuRu6NGsD6AgHvU8V88vaqFUhfzBzW
        N2CfTU/s/au2/aiPFPu5plWdNQHiWisN5auhvDYH5f4Lr0TIP+beJE0EOhQvDt7BYLsXVaQgQNb
        h2KAITk1f8cGJgK80V6lS0jkkjOjdYcODon5C
X-Received: by 2002:a5d:4b43:0:b0:315:9d08:9d4a with SMTP id w3-20020a5d4b43000000b003159d089d4amr999785wrs.4.1691753319442;
        Fri, 11 Aug 2023 04:28:39 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGQpaSa989p8oRerReoXHIO5kabeG3tHZlCtU9u5TuXh7MiY1qnJCZB6LQ9KPujbiw1c0hg5g==
X-Received: by 2002:a5d:4b43:0:b0:315:9d08:9d4a with SMTP id w3-20020a5d4b43000000b003159d089d4amr999777wrs.4.1691753319068;
        Fri, 11 Aug 2023 04:28:39 -0700 (PDT)
Received: from [10.0.0.196] ([37.186.180.70])
        by smtp.gmail.com with ESMTPSA id d2-20020a5d6dc2000000b00317f70240afsm5133768wrz.27.2023.08.11.04.28.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Aug 2023 04:28:38 -0700 (PDT)
Message-ID: <fa007805b7c61958043e94defe340e41896b17ad.camel@redhat.com>
Subject: Re: [nft PATCH] src: use reentrant 
 getprotobyname_r()/getprotobynumber_r()/getservbyport_r()
From:   Thomas Haller <thaller@redhat.com>
To:     Jan Engelhardt <jengelh@inai.de>
Cc:     NetFilter <netfilter-devel@vger.kernel.org>
Date:   Fri, 11 Aug 2023 13:28:37 +0200
In-Reply-To: <o4o37q01-r4s6-o009-379n-rsr0n79817r0@vanv.qr>
References: <20230810123035.3866306-1-thaller@redhat.com>
         <o4o37q01-r4s6-o009-379n-rsr0n79817r0@vanv.qr>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.48.4 (3.48.4-1.fc38) 
MIME-Version: 1.0
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, 2023-08-10 at 23:48 +0200, Jan Engelhardt wrote:
>=20
> On Thursday 2023-08-10 14:30, Thomas Haller wrote:
> >=20
> > +bool nft_getprotobyname(const char *name, uint8_t *out_proto);
>=20
> Knowing that proto can only be uint8, why not make this work like
> getc() where the return type is a type with a larger range?
>=20
> int nft_getprotobyname(const char *name)
> {
> =C2=A0=C2=A0=C2=A0 workworkwork();
> =C2=A0=C2=A0=C2=A0 if (error)
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0return -1;
> =C2=A0=C2=A0=C2=A0 return workresult;
> }
>=20

Hi,

I will do (in version2).

Thanks!
Thomas

