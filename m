Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01605C433EF
	for <netfilter-devel@archiver.kernel.org>; Thu, 24 Mar 2022 21:43:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355227AbiCXVpY (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 24 Mar 2022 17:45:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355210AbiCXVpY (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 24 Mar 2022 17:45:24 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09D736C923;
        Thu, 24 Mar 2022 14:43:51 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id z92so7116322ede.13;
        Thu, 24 Mar 2022 14:43:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=wSzpNDCQRogZ+azuDpte4EVFEExx+jAjnQvNc+Cqgl0=;
        b=Haqu9seVxRI8zzYBHnCvFaWJwRQtiJxBcmkmxMLielfcFK7CtkAZwARcEVg4crb4LA
         3FOLsoVvjm4bYplURarE89EpB+gAtct6lUu8kPd32X9xfTv+Lrz5iWba4ldXyoHxgK4C
         1P2USA3S/2vOUiUZMFuKO2Np+0+WHAOdtLu+3Yv5vHulfjo6oVd5NRumBVo8Mtn/0h5Y
         /eOTE/IVMeGzpPGvemgVb9wFLthkuW/xGVguNeZGPypYs64On3oT+CU+K7tZTxRsHAgd
         iXpByW7B/zfigV5Sqo80Csazo/WQmcW4ewtau+GOtVJT24b8uCnrKWsiEogjhQNpKy/z
         7hSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=wSzpNDCQRogZ+azuDpte4EVFEExx+jAjnQvNc+Cqgl0=;
        b=XI/6VeUoGyRWe6WuYErXN1BiSfs+dgSlC3Uao2jqcUhKXvifK1e2IkKnEjb/7lOypG
         oq/zky4Q6Ahd0lxssvtamObhmNcOFjIOFV2ktNiWyb9WM1qO63VJScFQ95OlE5pJIwoQ
         ZUKUcuk7B8z8IubLj4FsgaJg6En3GWzoVMvai3ZdmAUpN58LRgpf7aBFxky1QXzdnDeU
         a2e+ofIWQ8Zhl3lwRw/j+3vHTGbWZy/LUKDO3zYo1iJENWXckkMJ96uZOvC4kxh4N6TH
         2ADcqudvIWVebOjeI2DhlCgSpoAsKlAC7XvPWcOOQYfoyrQD83JaJ2LWduXoJgKqMxkV
         Wj6Q==
X-Gm-Message-State: AOAM531p/5UE30XMQo1dkMjm8d7xuRcqpHobTT9pz51r86Qm1pAu/FlZ
        Yj87pXdhl+sraQX1Abxi0bA=
X-Google-Smtp-Source: ABdhPJyS/CMNVniQKB6LnRzVopZTgXLidvIjP6FpUEqNh0avuqEb2GLlznu44ppmiw21r2kjEmaIEg==
X-Received: by 2002:aa7:d74d:0:b0:418:e883:b4e1 with SMTP id a13-20020aa7d74d000000b00418e883b4e1mr9191590eds.56.1648158229470;
        Thu, 24 Mar 2022 14:43:49 -0700 (PDT)
Received: from smtpclient.apple ([178.254.237.20])
        by smtp.gmail.com with ESMTPSA id i11-20020a50fd0b000000b0041936bc0f7esm2009941eds.52.2022.03.24.14.43.47
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 24 Mar 2022 14:43:48 -0700 (PDT)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 14.0 \(3654.120.0.1.13\))
Subject: Re: bug report and future request 
From:   Martin Zaharinov <micron10@gmail.com>
In-Reply-To: <9ED435A1-F1B8-4220-9466-FA3E9D100B1D@gmail.com>
Date:   Thu, 24 Mar 2022 23:43:47 +0200
Cc:     Florian Westphal <fw@strlen.de>,
        netfilter <netfilter@vger.kernel.org>,
        netfilter-devel@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <59BE8A6C-B066-48C9-AD66-7EDBE2C7482E@gmail.com>
References: <AE6DAC96-EC3E-43C9-A95A-B230842DD7B1@gmail.com>
 <20220321212750.GB24574@breakpoint.cc>
 <4B0C8933-C7D8-49BA-B7F2-29625B0865C1@gmail.com>
 <20220322103203.GD24574@breakpoint.cc>
 <04C4931B-553E-4FEA-85D4-B3E186520EE5@gmail.com>
 <FE0EEED5-48C9-412F-81BA-0028818C2EE8@gmail.com>
 <DB57EE0F-F4CE-4198-89E0-F25ED3C321A5@gmail.com> <YjxiB6Jk4plpx48G@salvia>
 <9ED435A1-F1B8-4220-9466-FA3E9D100B1D@gmail.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
X-Mailer: Apple Mail (2.3654.120.0.1.13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Pablo

unfortunately i can't find any documentation on how to do it :(


Martin

> On 24 Mar 2022, at 14:23, Martin Zaharinov <micron10@gmail.com> wrote:
>=20
> Hi Pablo
>=20
> base on this rule :=20
>=20
> table inet nft-qos-static {
>        set limit_ul {
>                typeof ip saddr
>                flags dynamic
>        }
>        set limit_dl {
>                typeof ip daddr
>                flags dynamic
>        }
>=20
>        chain download {
>                type filter hook postrouting priority filter; policy =
accept;
>                ip daddr @limit_dl drop
>=20
>        }
>        chain upload {
>                type filter hook prerouting priority filter ; policy =
accept;
>                ip saddr @limit_ul drop;
>        }
>        flowtable fastnat {
>                hook ingress priority filter; devices =3D { eth0, eth1 =
};
>        }
>        chain forward {
>                type filter hook forward priority filter; policy =
accept;
>                ip protocol { tcp , udp } flow offload @fastnat;
>        }
> }
>=20
>=20
> where to set this , please help.
>=20
>=20
>> On 24 Mar 2022, at 14:20, Pablo Neira Ayuso <pablo@netfilter.org> =
wrote:
>>=20
>> On Thu, Mar 24, 2022 at 02:09:25PM +0200, Martin Zaharinov wrote:
>>> One more update=20
>>>=20
>>> I try to make rule for limiter in offload mode :
>>>=20
>>> table inet nft-qos-static {
>>>       set limit_ul {
>>>               typeof ip saddr
>>>               flags dynamic
>>>       }
>>>       set limit_dl {
>>>               typeof ip daddr
>>>               flags dynamic
>>>       }
>>>=20
>>>       chain upload {
>>>               type filter hook prerouting priority filter ; policy =
accept;
>>>               ip saddr @limit_ul drop;
>>>       }
>>>=20
>>>       chain download {
>>>               type filter hook postrouting priority filter; policy =
accept;
>>>               ip daddr @limit_dl drop;
>>>=20
>>>       }
>>>       flowtable fastnat {
>>>               hook ingress priority filter; devices =3D { eth0, eth1 =
};
>>>       }
>>>       chain forward {
>>>               type filter hook forward priority filter; policy =
accept;
>>>               ip protocol { tcp , udp } flow offload @fastnat;
>>>       }
>>> }
>>>=20
>>> its not work perfect only upload limit work , download get full =
channel=20
>>>=20
>>> in test i set 100mbit up/down  upload is stay on ~100mbit , but =
download up to 250-300mbit (i have this limit be my isp).
>>>=20
>>> the problem is limiter work only for Upload , is it posible to make =
work on download rule ?
>>=20
>> If you want to combine ratelimit/policing with flowtable, then you
>> have to use the ingress and egress hooks, not prerouting and
>> postrouting.
>>=20
>> Make sure you place the flowtable in a priority that comes after the
>> priority of your ingress hook.
>=20

