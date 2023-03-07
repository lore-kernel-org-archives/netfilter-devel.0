Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF7A2C678D4
	for <netfilter-devel@archiver.kernel.org>; Tue,  7 Mar 2023 12:58:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229975AbjCGM6o (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 7 Mar 2023 07:58:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229876AbjCGM6F (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 7 Mar 2023 07:58:05 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 544367B136
        for <netfilter-devel@vger.kernel.org>; Tue,  7 Mar 2023 04:57:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678193831;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+DD1n1ZqC0cPSsfNCSwBbvIvgKgWohidMiihDgckDd4=;
        b=JfxhZ2yxWa2vfHKGf9uaLcgGADIuLShNzAtXcVioSrc+P9+ycFO+4Q1QcIKDvBByDjiRke
        orjyRvs8aY1lWfsdAGhJeOKvdDqRWGG1fpznejByRaHFQtGbfh7EHAibFx38+WpL/mO9oz
        4VTHuYYcbBZLK4rm8FWVDzrrs7uonT4=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-613-M28JhugqNweuWeM9KuuxsQ-1; Tue, 07 Mar 2023 07:57:10 -0500
X-MC-Unique: M28JhugqNweuWeM9KuuxsQ-1
Received: by mail-wm1-f69.google.com with SMTP id e17-20020a05600c219100b003e21fa60ec1so4942445wme.2
        for <netfilter-devel@vger.kernel.org>; Tue, 07 Mar 2023 04:57:10 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678193829;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=+DD1n1ZqC0cPSsfNCSwBbvIvgKgWohidMiihDgckDd4=;
        b=3wieEzllXY+JzLRb/p525zpM3hKz0zq5WCqZ+L6nZuVGimNfbpI8MjAmOCW2JLO/WZ
         xMia05IMirl0IO/EwC0c2jZnAK9lSOjgo9plS2hPjmjK2qDCTdZxh2ip/hcw5db8pkSr
         g/RSw7HiPp29nJgDNi/oKJOmH6gzUthg0dZ1njwc/AgCuTeixc3Zt9NG0dHKmjfgsFXJ
         v7Ee6hf6RyHSA/JYdbyPkanwZ0j5DCp7myOjrjjYv+Z/hBPIDaOM5Qtx2A8yuBqRP+m5
         fAiMl6caHK1g3oJ5mG1bXBuiQF4cqcGJWcChbi8JvzNiQHxxg/Uh7wV0KpUEZULqxnE0
         sCcg==
X-Gm-Message-State: AO0yUKWiSLffmywcCPChB6h7QSV7Xu+MTs8PWyNvHHCzkruUNNtBrFz5
        Ruqxl+sWwxTDTBRaoKExreapPYF4d4CjhKZYQbsm//REay4GCdEz405VRoO4OupCr9vgTIsI444
        JwxYUipWWgBMmQNAVU//IqaYq6Cuh
X-Received: by 2002:a05:600c:1d03:b0:3ea:840c:e8ff with SMTP id l3-20020a05600c1d0300b003ea840ce8ffmr11569304wms.3.1678193829238;
        Tue, 07 Mar 2023 04:57:09 -0800 (PST)
X-Google-Smtp-Source: AK7set8Cvl1jwhUH2gPf2Ts+kJr/a2wl0SB3eMY/6BNMFKs2XFVTgpZGHk5CSZ1Dv4Ug+hj/2HtfJQ==
X-Received: by 2002:a05:600c:1d03:b0:3ea:840c:e8ff with SMTP id l3-20020a05600c1d0300b003ea840ce8ffmr11569291wms.3.1678193828983;
        Tue, 07 Mar 2023 04:57:08 -0800 (PST)
Received: from gerbillo.redhat.com (146-241-121-28.dyn.eolo.it. [146.241.121.28])
        by smtp.gmail.com with ESMTPSA id s25-20020a05600c319900b003db03725e86sm12859377wmp.8.2023.03.07.04.57.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Mar 2023 04:57:08 -0800 (PST)
Message-ID: <66e565ba357feb2b4411828c65624986eaefb393.camel@redhat.com>
Subject: Re: [PATCH net 0/3] Netfilter fixes for net
From:   Paolo Abeni <pabeni@redhat.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        edumazet@google.com
Date:   Tue, 07 Mar 2023 13:57:07 +0100
In-Reply-To: <20230307100424.2037-1-pablo@netfilter.org>
References: <20230307100424.2037-1-pablo@netfilter.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4 (3.46.4-1.fc37) 
MIME-Version: 1.0
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, 2023-03-07 at 11:04 +0100, Pablo Neira Ayuso wrote:
> Hi,
>=20
> The following patchset contains Netfilter fixes for net:
>=20
> 1) Restore ctnetlink zero mark in events and dump, from Ivan Delalande.
>=20
> 2) Fix deadlock due to missing disabled bh in tproxy, from Florian Westph=
al.
>=20
> 3) Safer maximum chain load in conntrack, from Eric Dumazet.
>=20
> Please, pull these changes from:
>=20
>   git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git
>=20
> Thanks.
>=20
> ----------------------------------------------------------------
>=20
> The following changes since commit 528125268588a18a2f257002af051b62b14bb2=
82:
>=20
>   Merge branch 'nfp-ipsec-csum' (2023-03-03 08:28:44 +0000)
>=20
> are available in the Git repository at:
>=20
>   git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git HEAD

It's not clear to me the root cause, but pulling from the above ref.
yields nothing. I have to replace 'HEAD' with main to get the expected
patches.

Cheers,

Paolo

