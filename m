Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5C3DC433F5
	for <netfilter-devel@archiver.kernel.org>; Thu,  6 Oct 2022 12:58:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231553AbiJFM6T (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 6 Oct 2022 08:58:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231741AbiJFM6D (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 6 Oct 2022 08:58:03 -0400
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1B3495B4;
        Thu,  6 Oct 2022 05:57:26 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id 13so4409683ejn.3;
        Thu, 06 Oct 2022 05:57:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date;
        bh=aR41UreoGmAHZ0eE6k6l03yztretTneo/I2xHbqnPhc=;
        b=DPiHf5C2cmdRHmCOmEh3ZWXHovpEhMgCszZKLveTHT/CWdH6no564UqxKWrazoEsqX
         NEvNxgl+P1wdxmc34EoQcb+/7E8Qkcc62MQwnvh1gOGsgHwZF5YH6aGoivwp+DvhQyF2
         VP9jhykBdU5VNn/sGlA5LsepoSRxLNBCwUviMkNFoWoTYm/n7UwqYum33psMxfy1oLrU
         hx0Pr4QAUNYjvMnUQIz/7VsCAIDtJuX/P84L2djB3W8Rxktjm0BzPT5/NJt8vjfKo9b2
         Vsr34vEz5JiU4GtRp5WOsTPbWO616AbAXuH2zP2jls/bzq5rp5FPJamNX/23undzBEoW
         a0XA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
         :subject:date;
        bh=aR41UreoGmAHZ0eE6k6l03yztretTneo/I2xHbqnPhc=;
        b=oZgp7Ct6Ypugt/ujiLJwZwPlmTDwpjIYFaiePSO3IBTNR/nE/offeV054SjdHerCP0
         I44u42mD8qzfd+oJryNS4PBacjzxYmFSwFeoBsUMwTm+fG0BldiiQ+xClbEvS3Jn1qux
         wl8njXhKpH1FooXwaaXaNcyHB7tsNpMWJ+xeFP+TwgpxAVNJSr3dlQo9ENVLXBopilwt
         PCFF1WaCrlhsEqAhZ0rT3bkHY0QhWk9nuVWLFXMiO6aV0YmZ0ZCCrK75WviaY/DJOXLp
         SfVUdk/su5NHkz6jCP2k5AAyXDCVJfu1LacB1jqvTA44FpsNDW+VJllvFF5phHm/j04K
         fsJg==
X-Gm-Message-State: ACrzQf1hnRLFeMlbwWxfxD8Si3qn0yRcEVBEkK+m/GlIGa5aPmg6BHpZ
        mPcYNi0bgOD/3vXTx17Em3Y=
X-Google-Smtp-Source: AMsMyM7cVnQmP4Juvzn9jeex1m+d6UXB6r/fpti1/83cREBZsP84t85+Ou+hnwRSjO8n9FUcRkLFyA==
X-Received: by 2002:a17:907:70a:b0:750:bf91:caa3 with SMTP id xb10-20020a170907070a00b00750bf91caa3mr3850378ejb.711.1665061045263;
        Thu, 06 Oct 2022 05:57:25 -0700 (PDT)
Received: from smtpclient.apple ([178.254.237.20])
        by smtp.gmail.com with ESMTPSA id e17-20020aa7d7d1000000b004573052bf5esm5808257eds.49.2022.10.06.05.57.23
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 06 Oct 2022 05:57:24 -0700 (PDT)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 14.0 \(3654.120.0.1.13\))
Subject: Re: Kernel 6.0.0 bug pptp not work
From:   Martin Zaharinov <micron10@gmail.com>
In-Reply-To: <0DF040F3-ACC8-447E-99DA-BB77FEE03C7E@gmail.com>
Date:   Thu, 6 Oct 2022 15:57:23 +0300
Cc:     pablo@netfilter.org, Paolo Abeni <pabeni@redhat.com>,
        netfilter-devel@vger.kernel.org,
        netfilter <netfilter@vger.kernel.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <BDFD3407-955E-4FB4-B124-229978690BFF@gmail.com>
References: <3D70BC1B-A19E-45E3-B6BC-6B2719BA9B46@gmail.com>
 <20221006111811.GA3034@breakpoint.cc>
 <0DF040F3-ACC8-447E-99DA-BB77FEE03C7E@gmail.com>
To:     Florian Westphal <fw@strlen.de>
X-Mailer: Apple Mail (2.3654.120.0.1.13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hm.. in kernel 6.0-rc7=20

Pablo Neira Ayuso (2):
      netfilter: nfnetlink_osf: fix possible bogus match in =
nf_osf_find()
      netfilter: conntrack: remove nf_conntrack_helper documentation


https://lwn.net/Articles/909391/




@Pablo Abeni

Same with flowtable and without very slow connect vpn.

now i back to old kernel 5.19.14 to make test and yes all is fine click =
on connect button and connection established for less that 5 sec



m.

> On 6 Oct 2022, at 15:46, Martin Zaharinov <micron10@gmail.com> wrote:
>=20
> Huh
> Very strange in kernel 6.0.0 i not found : =
net.netfilter.nf_conntrack_helper
>=20
>=20
> in old kernel 5.19.14 in sysctl -a | grep =
net.netfilter.nf_conntrack_helper=20
>=20
> net.netfilter.nf_conntrack_helper =3D 1
>=20
>=20
> m.
>=20
>> On 6 Oct 2022, at 14:18, Florian Westphal <fw@strlen.de> wrote:
>>=20
>> Martin Zaharinov <micron10@gmail.com> wrote:
>>> Hi Team
>>>=20
>>> I make test image with kernel 6.0.0 and schem is :
>>>=20
>>> internet <> router NAT <> windows client pptp
>>>=20
>>> with l2tp all is fine and connections is establesh.
>>>=20
>>> But when try to make pptp connection  stay on finish phase and not =
connect .
>>>=20
>>> try to remove module : nf_conntrack_pptp and same not work.
>>=20
>> Did you rely on
>> sysctl net.netfilter.nf_conntrack_helper=3D1, or are you assigning =
the
>> helper via ruleset?
>=20

