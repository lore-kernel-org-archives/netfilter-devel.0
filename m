Return-Path: <SRS0=WNzP=VO=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27260C76186
	for <netfilter-devel@archiver.kernel.org>; Wed, 17 Jul 2019 09:56:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EE31620818
	for <netfilter-devel@archiver.kernel.org>; Wed, 17 Jul 2019 09:56:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OyeokHXO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726260AbfGQJ4h (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 17 Jul 2019 05:56:37 -0400
Received: from mail-vs1-f67.google.com ([209.85.217.67]:42755 "EHLO
        mail-vs1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725799AbfGQJ4h (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 17 Jul 2019 05:56:37 -0400
Received: by mail-vs1-f67.google.com with SMTP id 190so16017676vsf.9
        for <netfilter-devel@vger.kernel.org>; Wed, 17 Jul 2019 02:56:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=EoWQ86vB0fsG2wvp5Fa1qCDFpLt33pq3JG8d93x5iu4=;
        b=OyeokHXO9/1OV1/4hGwV5I181Vov8LVFZ2OVHS2gM/eMTY/SNjxHUNtWdKWe1+GxLf
         1vDwby1hu1Q+vvP6BsXT+HU1PvSxiOX2Eph+/ej8ufDGQ1juoZwdm44d97Rl4m5vygkq
         88Z6nu+IOcElDMhhVokVpxusjrGmzcqv6kd2Fp2BeC+pAs10B6PHpSn5HoNSP/Tg+Cdh
         h1I2l4b3C8o/qJIBhTUpZstdWCR/QHm6S7EPivbVPPkNM2dhNLXXWmt+9eR+/Ydt0G5e
         DtPyS/DBR/4YKzKZsHfFZisFTY/suTgPXtZhHn/gEKQM5aelWHuMnYOW1cqijl+2lE+9
         nKKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=EoWQ86vB0fsG2wvp5Fa1qCDFpLt33pq3JG8d93x5iu4=;
        b=k5S1Py6mIRTkHGCrT9ReVvXehRJwAXRvtvMM4kMQEhKbB6c7h2hsDOdyx65oJhkrWV
         bMc69apwH93I2MiROPWtcmppGQ/7fdkWIEg+OUirrNP+fugELdTBMUZZ08nDjlmW6tpD
         MFroC/0dY9XW1EbRjyQUbtmic2sBeFqiyo8wlY7u79Dwxps/GYKzRTP9ZIF+VkkrOTrO
         8DiaB9qL3sg31xgGcy/NuDoOSeq8Vla/2NfsLdAvA7g4i6qdmf2WuHezfoQcB5DISJhB
         9CtV3EfmdUbpa0VmmCCp8+1W1/P/2ZfofRadQN/SUf8j1mJFt9uJLtM7hfWGAcX8VCWb
         uHDg==
X-Gm-Message-State: APjAAAUPPRNLeZE1Z8RZ7gV4fgOVrYBJI8IWmhOJW6OHxOHWzQ4O/hvD
        +W4E3ZXsHr2gGfZ4UA+OQktvR+Rhd7FpRmsXxEonTTX+
X-Google-Smtp-Source: APXvYqwFJXyR2VxOWrSPOnYlWR4FCsFb7X52KW3HpyI+P7xuLzFLihqJ1TOWBWS6q51forNSLdZTz20BLQCxkclKreI=
X-Received: by 2002:a67:eb87:: with SMTP id e7mr23606176vso.118.1563357396306;
 Wed, 17 Jul 2019 02:56:36 -0700 (PDT)
MIME-Version: 1.0
References: <20190709130209.24639-1-sveyret@gmail.com> <20190709130209.24639-2-sveyret@gmail.com>
 <20190716191935.j62mlzahtupzoji6@salvia> <20190716192924.tdjzbvwpdovli7kk@salvia>
In-Reply-To: <20190716192924.tdjzbvwpdovli7kk@salvia>
From:   =?UTF-8?Q?St=C3=A9phane_Veyret?= <sveyret@gmail.com>
Date:   Wed, 17 Jul 2019 11:56:25 +0200
Message-ID: <CAFs+hh49ezQJZf5y2_TSpkDiXinPqay_1OFBNk-=k3QY2bZ4vQ@mail.gmail.com>
Subject: Re: [PATCH nftables v5 1/1] add ct expectations support
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Pablo,

Not sure I will have time to work on it before August. Anyway, I will
take the latest version and see, because I ran the test again in my
environment, and I don't get the same error. The only error related to
objects.t is:

ip/objects.t: ERROR: line 3: Table ip test-ip4 already exists

(I have this same error on a lot of other tests, so I think it is not
related to expectations). In /tmp/nftables-test.log, I have:

        ct expectation ctexpect1 {
                protocol tcp
                dport 1234
                timeout 2m
                size 12
                l3proto ip
        }

        ct expectation ctexpect2 {
                protocol udp
                dport 0
                timeout
                size 0
                l3proto ip
        }
=E2=80=A6
        chain output {
                type filter hook output priority filter; policy accept;
                ct expectation set "ctexpect1"
        }

which seems rather correct=E2=80=A6

Le mar. 16 juil. 2019 =C3=A0 21:29, Pablo Neira Ayuso <pablo@netfilter.org>=
 a =C3=A9crit :
>
> On Tue, Jul 16, 2019 at 09:19:35PM +0200, Pablo Neira Ayuso wrote:
> > On Tue, Jul 09, 2019 at 03:02:09PM +0200, St=C3=A9phane Veyret wrote:
> > > This modification allow to directly add/list/delete expectations.
> >
> > Applied, thanks Stephane.
>
> Small problem still, if you don't mind to follow up with an
> incremental fix:
>
> ip/objects.t: ERROR: line 52: Failed to add JSON equivalent rule
>
> Looking at /tmp/nftables-test.log, it says:
>
> command: {"nftables": [{"add": {"rule": {"table": "test-ip4", "chain": "o=
utput", "family": "ip", "expr": [{"ct expect": "ctexpect1"}]}}}]}
> internal:0:0-0: Error: Unknown statement object 'ct expect'.
>
> Thanks.



--=20
Bien cordialement, / Plej kore,

St=C3=A9phane Veyret
