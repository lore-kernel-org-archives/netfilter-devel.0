Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB691C43217
	for <netfilter-devel@archiver.kernel.org>; Thu,  6 Oct 2022 14:19:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230039AbiJFOTU (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 6 Oct 2022 10:19:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231400AbiJFOTB (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 6 Oct 2022 10:19:01 -0400
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DD36AE237;
        Thu,  6 Oct 2022 07:17:00 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id bj12so4807089ejb.13;
        Thu, 06 Oct 2022 07:17:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date;
        bh=siHFTyZ2T6NDzGGqdGCiadSHdBb67ju2rDdUolohprk=;
        b=OeoBEH+8yY9uy4Ea6XuDgON/McDZQxYP74nJZ3EsTQg/dmOjfdbxk1P60Sou1tRd0F
         pPF5GLC0X1i3Ry1pZiPp7S/KX4g8oFK6bJWfxE9WOepIPssKoFBkvr6EefLXRJjiSjwl
         v7gcFSDqRI0g8hJbh5pbsg31/qGBe4vyi3poAE4KOPqgfY2mznz5jalB8gZqcB96mq5D
         n8CExFMsFLxjzzz5+wZi0oPP0lvonFTpFURUlnvZ/iBFwMtBbJ6LSCpoK7/yt3HypelH
         z5Nq2axGA1vXFDpOiMpstCRMJp0xO3NWRkdxT2PgyA53GPSkkSvsaSDbWC/FiSfdV8ea
         q6HA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
         :subject:date;
        bh=siHFTyZ2T6NDzGGqdGCiadSHdBb67ju2rDdUolohprk=;
        b=79nkHUDNX2yHoWXLO1MHEr73yO7CynBN+GwLbA2alEzdWPU/5vTGW0ybqB1kdHxu3I
         pqlbd5N+Yqe4i2YomE1jY/FmgmlxjXxEkM89iECaDBed9+OdgdhXWhyjhw2brLfQdic4
         fdFiqS26FV4a29GV5iBwZXf8q/u8ApYZksZXF643u3CINq1gt7XmvaUWIGlShYsU7cba
         lGEtqRKp8TChJLVhYYgHEI/htQ7rJXyzgh+UJLrBp7Q+f3h1ylHwaAXVAc095SSlxDmL
         tmIRDbOVb0Rf/FL1MH3/GpwBljpsrWCd8Pi5jz1WDwkeR2jqPnpkhmODqWhZQNi0DOOf
         WYBA==
X-Gm-Message-State: ACrzQf3Oi0NiQfdI9ti4Qmr1N8f6e9zVI2A11FQ26xtoFYZYkuQWkCRK
        gBFGFpllaJLBXzlFfkq+FXA=
X-Google-Smtp-Source: AMsMyM6ypikGhX0m04qpoCA/ePFTdTWGB9UZH9GCnQNpmS914YaRa7naTZhFmx7jpK4YhMoKkXvfzw==
X-Received: by 2002:a17:906:9b8e:b0:78c:65a4:af84 with SMTP id dd14-20020a1709069b8e00b0078c65a4af84mr47679ejc.127.1665065818358;
        Thu, 06 Oct 2022 07:16:58 -0700 (PDT)
Received: from smtpclient.apple ([178.254.237.20])
        by smtp.gmail.com with ESMTPSA id f14-20020a17090631ce00b0078135401b9csm10394581ejf.130.2022.10.06.07.16.50
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 06 Oct 2022 07:16:53 -0700 (PDT)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 14.0 \(3654.120.0.1.13\))
Subject: Re: Kernel 6.0.0 bug pptp not work
From:   Martin Zaharinov <micron10@gmail.com>
In-Reply-To: <20221006134340.GA31481@breakpoint.cc>
Date:   Thu, 6 Oct 2022 17:16:48 +0300
Cc:     pablo@netfilter.org, Paolo Abeni <pabeni@redhat.com>,
        netfilter-devel@vger.kernel.org,
        netfilter <netfilter@vger.kernel.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <FF11BA5A-6D5C-4078-8050-8E70107C6A03@gmail.com>
References: <3D70BC1B-A19E-45E3-B6BC-6B2719BA9B46@gmail.com>
 <20221006111811.GA3034@breakpoint.cc>
 <0DF040F3-ACC8-447E-99DA-BB77FEE03C7E@gmail.com>
 <20221006134340.GA31481@breakpoint.cc>
To:     Florian Westphal <fw@strlen.de>
X-Mailer: Apple Mail (2.3654.120.0.1.13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Florian

Yes after add this rull with small modifycation work perfect.


Thanks for this !


Martin

> On 6 Oct 2022, at 16:43, Florian Westphal <fw@strlen.de> wrote:
>=20
> Martin Zaharinov <micron10@gmail.com> wrote:
>> Huh
>> Very strange in kernel 6.0.0 i not found : =
net.netfilter.nf_conntrack_helper
>>=20
>>=20
>> in old kernel 5.19.14 in sysctl -a | grep =
net.netfilter.nf_conntrack_helper=20
>>=20
>> net.netfilter.nf_conntrack_helper =3D 1
>=20
> Yes, so this is expected -- 6.0.0 should behave like 5.19.14 with
> net.netfilter.nf_conntrack_helper=3D0.
>=20
> You need something like:
>=20
> table inet foo {
>        ct helper pptp {
>                type "pptp" protocol tcp
>                l3proto ip
>        }
>=20
>        chain prerouting {
>                type filter hook prerouting priority filter; policy =
accept;
>                tcp dport 1723 ct helper set "pptp"
>        }
> }
>=20
> ... so that the helper will start processing traffic on the pptp =
control port.
> You might want to refine the rule a big, e.g.
> 'iifname ppp*' or similar, to restrict/limit the helper to those =
clients that need
> it.

