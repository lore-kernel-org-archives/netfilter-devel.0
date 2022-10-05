Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3DEAAC433F5
	for <netfilter-devel@archiver.kernel.org>; Wed,  5 Oct 2022 23:41:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229612AbiJEXlv (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 5 Oct 2022 19:41:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229516AbiJEXlu (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 5 Oct 2022 19:41:50 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 865B583056;
        Wed,  5 Oct 2022 16:41:49 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id z97so563188ede.8;
        Wed, 05 Oct 2022 16:41:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:in-reply-to:to:references:date:subject:mime-version
         :content-transfer-encoding:from:from:to:cc:subject:date;
        bh=qV/XlcU+XCgYvXAU4Rj9Tj37IJYRs29lPeONn/QayIg=;
        b=Prt7HW3hf3K0Rg05e0x1PvDKWjCqksaJyneszCJuE90/iK/IUwvLrE8zJVn8bYkGBq
         j/xtsNgmf97KLu4UwJ/HnVTgkIaVmLvk2JM3z0dkMJAQLYV3sPkb/h7GL5zF+itgu6hO
         jioMm1HPSOAYC/TfLBWQL5+Q5wRZc7nS+mmsBmxDMwMPcsG0BX5d1TXPqFxESKVzlJgD
         TJW7uxzeSgqVRzlQYXzpOxx1MJSd8Xn8VjeQNJs3TAmmm7lqrgRe5kipq9J6mL7AXmlS
         Rs/22hDRgXTqlw8+8v9MQ9vjCs4P+TldDUuP/zlDKPMJvg22+yaJtoQOn5ef7M9RTboB
         Kdag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=message-id:in-reply-to:to:references:date:subject:mime-version
         :content-transfer-encoding:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=qV/XlcU+XCgYvXAU4Rj9Tj37IJYRs29lPeONn/QayIg=;
        b=kKnU2BYbRTyaGuErXgRk9EOoaiLdgmahSykJvwLhpjpPC+KjdjxLNSeuwz0W037icY
         dtPD1EN+o9M8ds+mPAsMtZwyby8zO/cTaFU4dV60AZ6b4647lmsEmJ6Nsb7XIk5XrBg9
         3QeRK+Sa82M8ibdc6ZEzgjfr12ogMh3wQnIq6uKzQHql+9KOgqQ8yFh9wL1FVwBXkkNS
         DO34Xi1/XpyWMRCCttiWZT+2PQBpZ+W3qSf4KqfKoMvFFRhj3PCPsJPyfvZmHTdDNYae
         SIIFuMrBq3nbx+GFRab47PaZIWJAiSAeOoA2QHjfjDJSvTeqKjOQvvkdj3Na0axWP709
         ygnw==
X-Gm-Message-State: ACrzQf3nRfNamNESu/yAaK0p6dWKEZ0sHST4a1zxP1r41XgBOdOnpRuw
        Ewi3qYWUyttoIlHgx8kxa3I=
X-Google-Smtp-Source: AMsMyM6/ihWb/eGx1cxFZGViA8bXwnRWnoHiuK8tLhQmBDNPyXoXqim/Fur4/vrFdl52l65Fc3BEcA==
X-Received: by 2002:a05:6402:90a:b0:458:ca4d:a2f8 with SMTP id g10-20020a056402090a00b00458ca4da2f8mr2020065edz.230.1665013307975;
        Wed, 05 Oct 2022 16:41:47 -0700 (PDT)
Received: from smtpclient.apple ([178.254.237.20])
        by smtp.gmail.com with ESMTPSA id r17-20020a056402019100b00458c7d569f7sm4545460edv.60.2022.10.05.16.41.44
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 05 Oct 2022 16:41:44 -0700 (PDT)
From:   Martin Zaharinov <micron10@gmail.com>
Content-Type: text/plain;
        charset=us-ascii
Content-Transfer-Encoding: quoted-printable
Mime-Version: 1.0 (Mac OS X Mail 14.0 \(3654.120.0.1.13\))
Subject: Re: Kernel 6.0.0 bug pptp not work
Date:   Thu, 6 Oct 2022 02:41:43 +0300
References: <3D70BC1B-A19E-45E3-B6BC-6B2719BA9B46@gmail.com>
To:     Florian Westphal <fw@strlen.de>, pablo@netfilter.org,
        Paolo Abeni <pabeni@redhat.com>,
        netfilter-devel@vger.kernel.org,
        netfilter <netfilter@vger.kernel.org>
In-Reply-To: <3D70BC1B-A19E-45E3-B6BC-6B2719BA9B46@gmail.com>
Message-Id: <E01A900C-4406-4AC5-B3E7-D645A0291B34@gmail.com>
X-Mailer: Apple Mail (2.3654.120.0.1.13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Small update=20
with kernel 5.19.14 all is fine connect pptp for less that 2 sec

after switch to kernel 6.0.0 one time need more that 1 min to establish =
pptp connection other time not work .

m

> On 6 Oct 2022, at 2:34, Martin Zaharinov <micron10@gmail.com> wrote:
>=20
> Hi Team
>=20
> I make test image with kernel 6.0.0 and schem is :
>=20
> internet <> router NAT <> windows client pptp
>=20
> with l2tp all is fine and connections is establesh.
>=20
> But when try to make pptp connection  stay on finish phase and not =
connect .
>=20
> try to remove module : nf_conntrack_pptp and same not work.
>=20
>=20
> how to debug and find why not work ?
>=20
>=20
> Best regards,
> Martin

