Return-Path: <SRS0=8tM5=3J=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=0.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MALFORMED_FREEMAIL,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7055AC32771
	for <netfilter-devel@archiver.kernel.org>; Mon, 20 Jan 2020 21:54:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3FF0E22525
	for <netfilter-devel@archiver.kernel.org>; Mon, 20 Jan 2020 21:54:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="d+LSrtRq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727372AbgATVyW (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 20 Jan 2020 16:54:22 -0500
Received: from mail-qk1-f172.google.com ([209.85.222.172]:34967 "EHLO
        mail-qk1-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726752AbgATVyW (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 20 Jan 2020 16:54:22 -0500
Received: by mail-qk1-f172.google.com with SMTP id z76so767372qka.2
        for <netfilter-devel@vger.kernel.org>; Mon, 20 Jan 2020 13:54:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=user-agent:date:subject:from:to:cc:message-id:thread-topic
         :references:in-reply-to:mime-version:content-transfer-encoding;
        bh=J1TiWGdB0IMmBuBOYAvYumo1uggTa/JcygiOv81w90c=;
        b=d+LSrtRqCHI42MNRWs7334GmMiRGxKRxTXngUx4visd+XASQ03KGfc4o5Qjroc3CKp
         S2rAxsovkC12I5oKzyYeri39DhJNZAktt2xbuWpr0VMHSpK8JH8iDX/nwBZ53OA/ADYY
         n6MpLOBeGziJZoAtm2jL6Mez/NlVKuwMG/qbeTh3hLlfmI00cnmyaUUp7WH0kM/dWdvZ
         iHmWGU2pot4IpjHSZ6/pSd92CafAcWHvIvCTU7u1iqMBDgKJxFyKjioLtbGKoqhtZGY+
         pobtCpdIShHGc6boooZFp5+AruT41eRv6Dr9kTgxN7CKdtkGijJBtde5HGiF+NwzaUnY
         iGpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:user-agent:date:subject:from:to:cc:message-id
         :thread-topic:references:in-reply-to:mime-version
         :content-transfer-encoding;
        bh=J1TiWGdB0IMmBuBOYAvYumo1uggTa/JcygiOv81w90c=;
        b=PBtzzCJP7FG4vMzTa2LoKG+Wd3s+x2d461eoH+8XSzamJNkFiSgXnPVy0g+UlVaa4H
         l/5qXJMW8/upezzyaSbXuRa5bFGO/axpInCdl1v/YaxbzrLHShDaEAA0j9Yqt2k2IoJ4
         /kHM5PAjg0O2R9zg2Sa6qVvXxN/lRol3eLknBXIWBGYC2OIUXwckqsFtw8THftRa2n8r
         qb0NzBsbPe9laIdx24alp9lLYP1TTVDKVvL0tDrCLPhmos4yF0LJqPzatGzAf+tR6+ft
         NjlInKwxiAB2nWJSANdcqUJfyfKGgWd1piP3oP3hISgaEUT77qp71RaxYjChMNhjIjAl
         jX0g==
X-Gm-Message-State: APjAAAVBjXlFFK3H+Vl4ZE6qouAoe/sbsUUNAwEgalGKDLBMtV5Q8HOB
        blM4sYXJFwOrXrAk1Jc4gQ5Q2AOja37i1Q==
X-Google-Smtp-Source: APXvYqzcNu4Uk/tndCWyhgLBKIZy4Wv8hA+FvJ4Nj28wcWf5hlFBgu9Gy7pnWVU4t9ZVCfyHA6UtxQ==
X-Received: by 2002:a05:620a:128f:: with SMTP id w15mr1605759qki.472.1579557261708;
        Mon, 20 Jan 2020 13:54:21 -0800 (PST)
Received: from [10.117.94.148] ([173.38.117.91])
        by smtp.gmail.com with ESMTPSA id 17sm18280081qtz.85.2020.01.20.13.54.20
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 20 Jan 2020 13:54:21 -0800 (PST)
User-Agent: Microsoft-MacOutlook/10.21.0.200113
Date:   Mon, 20 Jan 2020 16:54:20 -0500
Subject: Re: load balancing between two chains
From:   sbezverk <sbezverk@gmail.com>
To:     Florian Westphal <fw@strlen.de>
CC:     Phil Sutter <phil@nwl.cc>,
        "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
Message-ID: <BC7FFB04-4465-4B3B-BA5B-17BEA0FC909B@gmail.com>
Thread-Topic: load balancing between two chains
References: <011F145A-C830-444E-A9AD-DB45178EBF78@gmail.com>
 <20200120112309.GG19873@orbyte.nwl.cc>
 <F6976F28-188D-4267-8B95-F4BF1EDD43F2@gmail.com>
 <20200120170656.GE795@breakpoint.cc>
 <A774A3A8-64EB-4897-8574-076CC326F020@gmail.com>
 <20200120213954.GF795@breakpoint.cc>
In-Reply-To: <20200120213954.GF795@breakpoint.cc>
Mime-version: 1.0
Content-type: text/plain;
        charset="UTF-8"
Content-transfer-encoding: quoted-printable
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Numgen has GOTO directive and not Jump (Phil asked to change it), I thought=
 it means after hitting any chains in numgen the processing will go back to =
service chain, no?

It is Ubuntu 18.04

sbezverk@kube-4:~$ uname -a
Linux kube-4 5.4.10-050410-generic #202001091038 SMP Thu Jan 9 10:41:11 UTC=
 2020 x86_64 x86_64 x86_64 GNU/Linux
sbezverk@kube-4:~$ sudo nft --version
nftables v0.9.1 (Headless Horseman)
sbezverk@kube-4:~$

I also want to remind you that I do NOT use nft cli to program rules, I use=
 nft cli just to see resulting rules.

If you need to enable any kernel/module  debugging or try some debugging co=
de, please let me know I am opened, also live debugging session on my server=
 is also possible. This issue has a very high priority as it would be a real=
 show stopper in kubernetes environment.

Thank you
Serguei=20

=EF=BB=BFOn 2020-01-20, 4:39 PM, "Florian Westphal" <fw@strlen.de> wrote:

    sbezverk <sbezverk@gmail.com> wrote:
    > Changed kernel to 5.4.10, and switch to use "inc" instead of "random"=
.  Now first curl works and second fails. Whenever second chain is selected =
to be used,  curl connection gets stuck.=20
    >=20
    >         chain k8s-nfproxy-svc-M53CN2XYVUHRQ7UB {
    >                 numgen inc mod 2 vmap { 0 : goto k8s-nfproxy-sep-TMVE=
FT7EX55F4T62, 1 : goto k8s-nfproxy-sep-GTJ7BFLUOQRCGMD5 }
    >                 counter packets 1 bytes 60 comment ""
    >         }
    >=20
    >         chain k8s-nfproxy-sep-TMVEFT7EX55F4T62 {
    >                 counter packets 1 bytes 60 comment ""
    >                 ip saddr 57.112.0.41 meta mark set 0x00004000 comment=
 ""
    >                 dnat to 57.112.0.41:8080 fully-random
    >         }
    >=20
    >         chain k8s-nfproxy-sep-GTJ7BFLUOQRCGMD5 {
    >                 counter packets 0 bytes 0 comment ""
    >                 ip saddr 57.112.0.52 meta mark set 0x00004000 comment=
 ""
    >                 dnat to 57.112.0.52:8989 fully-random
    >         }
    >=20
    > Any debug I could enable to see where the packet goes?
   =20
    The counter after numgen should not increment, but it does.
    Either numgen does something wrong, or hash alg is broken and doesn't
    find a result for "1".
   =20
    There was such a bug but it was fixed in 5.1...
   =20
    please show:
    uname -a
    nft --version
   =20


