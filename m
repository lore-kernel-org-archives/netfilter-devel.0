Return-Path: <SRS0=0Xdd=RL=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,FROM_EXCESS_BASE64,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2484C43381
	for <netfilter-devel@archiver.kernel.org>; Fri,  8 Mar 2019 16:22:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9364B20657
	for <netfilter-devel@archiver.kernel.org>; Fri,  8 Mar 2019 16:22:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NYaYMGDP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726588AbfCHQWL (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 8 Mar 2019 11:22:11 -0500
Received: from mail-yw1-f67.google.com ([209.85.161.67]:43754 "EHLO
        mail-yw1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726412AbfCHQWL (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 8 Mar 2019 11:22:11 -0500
Received: by mail-yw1-f67.google.com with SMTP id d129so2825015ywe.10;
        Fri, 08 Mar 2019 08:22:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+esDnUsohReefzTuWpziQBDSnQQiyKYKmSvyHvyE2Uw=;
        b=NYaYMGDPCTUlJzg33yIZLGhZrf95+iJ61Q6xFYM3gZgUBh1UE+CJ+/w1/AH2zawmuR
         L0PpR+Dmt4x7deORBv2XcVuByu6vm6F4FLVAjDv2EavVDHk5L1UVyV8eEDeFsy/xqr18
         HtiGjE6OCRin48GHUTUjQ+KvQ8TtAHq2ibL2yJaoyolcH9J27XEN497sDFnLFLBQAbyw
         S0zG5D/u8B0pmP1haXCNFPBypzJctGvtNZjXmAa0ISKdXEYq5UtmV/GDDHMiRHLBgCfX
         NlJcWcsiPJzDVZYohyGe4hxCeG7i8TydRIubH7MyiqKgM8hmwkm+EEISvtLVijr277Mr
         UKtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+esDnUsohReefzTuWpziQBDSnQQiyKYKmSvyHvyE2Uw=;
        b=AZdahTvtAp9R3prd4dFvE8dxFc5g0cPRreGVsd6nhVrmplZ8l1oRyB3Aooie4liWet
         bu1+E2BmQLMJ+6C1ue7TxooqZvKzT728bQqCL3VHad6+AvcNy54rt8ZMkOFMTsJ+Veta
         MtPJ9cmoTRp13jetHB1JEcPYK3R328RbNnE0pXIr1T8jZIhiEx/GYOnzeJ65geGt/uii
         JhtBlJ0Z2ncbOq/5jjlP0m+laSGuNb+A0wRQM7k8tpK82wQZhZjFvEyd/eJbI1LpnmPy
         gWjseqeYcV6jmkQCbRuBzWijUNfsHvNfqVDstJIX7Gd6G9uCi6gK67MH8knJ+3l5KQVO
         GQcA==
X-Gm-Message-State: APjAAAXXNW52Fryj6ijoh6gPKtrpFNvctQyJdA2r5ciFbk9x3zn5hPPZ
        LApfTdZSA/S5plBMXsdxzuXIFdxlmjfX0PfcD1Q=
X-Google-Smtp-Source: APXvYqwsJ6p6jtRG3gqxrccTlAHuQ20BWu3wJfowpTx6Y32k622RnmskqamdncjGvhYPZKMZya2WsK39szZuzGGeY/U=
X-Received: by 2002:a81:27d5:: with SMTP id n204mr15139768ywn.495.1552062130243;
 Fri, 08 Mar 2019 08:22:10 -0800 (PST)
MIME-Version: 1.0
References: <20190304204019.2142770-1-arnd@arndb.de> <20190308160441.ler2hs44oaozoq7w@salvia>
In-Reply-To: <20190308160441.ler2hs44oaozoq7w@salvia>
From:   =?UTF-8?B?QWxpbiBOxINzdGFj?= <alin.nastac@gmail.com>
Date:   Fri, 8 Mar 2019 17:21:59 +0100
Message-ID: <CAF1oqRAuk7h2Z2iheq3Ze1vTMNWLf5HHn83fZt07hXA4nOPbAg@mail.gmail.com>
Subject: Re: [PATCH] netfilter: nf_conntrack_sip: fix IPV6 dependency
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        =?UTF-8?B?TcOhdMOpIEVja2w=?= <ecklm94@gmail.com>,
        Fernando Fernandez Mancera <ffmancera@riseup.net>,
        netfilter-devel <netfilter-devel@vger.kernel.org>,
        coreteam@netfilter.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Pablo,
On Fri, Mar 8, 2019 at 5:04 PM Pablo Neira Ayuso <pablo@netfilter.org> wrote:
>
> hi Arnd,
>
> Cc'ing Alin Nastac.
>
> On Mon, Mar 04, 2019 at 09:40:12PM +0100, Arnd Bergmann wrote:
> > With CONFIG_IPV6=m and CONFIG_NF_CONNTRACK_SIP=y, we now get a link failure:
> >
> > net/netfilter/nf_conntrack_sip.o: In function `process_sdp':
> > nf_conntrack_sip.c:(.text+0x4344): undefined reference to `ip6_route_output_flags'
>
> I see. We can probably use nf_route() instead.
>
> Or if needed, use struct nf_ipv6_ops for this.
>
>         if (v6ops)
>                 ret = v6ops->route_xyz(...);
>
> @Alin: Would you send us a patch to do so to fix a3419ce3356cf1f
> netfilter: nf_conntrack_sip: add sip_external_media logic".

nf_ip6_route(net, &dst, &fl6, false) seems to be appropriate.
I'll send the patch Monday.
