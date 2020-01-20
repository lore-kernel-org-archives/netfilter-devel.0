Return-Path: <SRS0=8tM5=3J=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=0.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MALFORMED_FREEMAIL,
	NORMAL_HTTP_TO_IP,NUMERIC_HTTP_ADDR,SPF_HELO_NONE,SPF_PASS,WEIRD_PORT
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9FD03C32771
	for <netfilter-devel@archiver.kernel.org>; Mon, 20 Jan 2020 22:50:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 653032253D
	for <netfilter-devel@archiver.kernel.org>; Mon, 20 Jan 2020 22:50:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="b+k3itua"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726867AbgATWuL (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 20 Jan 2020 17:50:11 -0500
Received: from mail-qv1-f47.google.com ([209.85.219.47]:39898 "EHLO
        mail-qv1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726607AbgATWuL (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 20 Jan 2020 17:50:11 -0500
Received: by mail-qv1-f47.google.com with SMTP id y8so561989qvk.6
        for <netfilter-devel@vger.kernel.org>; Mon, 20 Jan 2020 14:50:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=user-agent:date:subject:from:to:cc:message-id:thread-topic
         :references:in-reply-to:mime-version:content-transfer-encoding;
        bh=0pEQsgsXZGXHMXd4h8h7V6Po1RVNYu74J59RKMaRn8Q=;
        b=b+k3ituaId03gwfX5xrbfi0bLuQpeNqJouYJcLr4JgWl6msP9tyWtVw/iYIUcEhMS7
         fru2MnYFHPDATPLFu7f9KC1O6E0wEtuXcHcFg77j+KLD0a2p7xlC1JIpzUEZQCUPERSG
         kZDq4N4ReoRj4woO3n3rW9eKUcZZEijivx7DIr9IFqNLBlHQK3UneU8+Wj1XrjzKJbI/
         ULufutxalwt1/65tIznaSiJIG/zfLECZC9Ycb5yDEP+Xvys5LXzjB002fyCKNka/epSh
         ul8dI3N/5OvoAkFYv2LmLpG4SQ52xqEgjsnUz6d/j6nEkQn4k5b8bRURRmbkblKoSfxZ
         Yl4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:user-agent:date:subject:from:to:cc:message-id
         :thread-topic:references:in-reply-to:mime-version
         :content-transfer-encoding;
        bh=0pEQsgsXZGXHMXd4h8h7V6Po1RVNYu74J59RKMaRn8Q=;
        b=r68mZLFqoMH/wZ5q8g6yDbryNG41Y6qTsg7QOo5Mh3isA3u1RETUl8IVDSjhkhgBA/
         vZj03+K7f/3ALvPqwb4Q57TJwdVPLyfPhRrAJq3ef8TI4lDg3IiXqoar4YhhZjZswjyN
         VAXbJWZIKYPfw98xc5guomQzTbI4SNicANU+MM/4t5D3m9U3qX4FwwbtSMt420Fq1j5V
         R0Qjn9E+IygMSD6IUUzDOE/Etj2E3jIVk7yQhE3uVyVSnCDCrd2ec+rd7ajE+QplO93t
         9I6KcOs5Y0ZILwQ1ULxcmuREyrm7Y7H+hUphs8h0OKpuS7PCJoGN1ENTnG+uLwlIxtlX
         M7mg==
X-Gm-Message-State: APjAAAXrGIZYd8hSWY3MOqCGXwLvEXgkDeR3LF6PR3wYvHCtY9bUjU9e
        Esob5xn3iSa3FxK5BJRPKls=
X-Google-Smtp-Source: APXvYqzwKmjM641iSkMtNyQ8VafD2xsX0JJ5OjgnFlthYtyYat6Iv/emdAs0tF0Y3RULExFGtx3p1g==
X-Received: by 2002:ad4:46e4:: with SMTP id h4mr2032191qvw.181.1579560609933;
        Mon, 20 Jan 2020 14:50:09 -0800 (PST)
Received: from [10.117.94.148] ([173.38.117.91])
        by smtp.gmail.com with ESMTPSA id t38sm18594962qta.78.2020.01.20.14.50.08
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 20 Jan 2020 14:50:09 -0800 (PST)
User-Agent: Microsoft-MacOutlook/10.21.0.200113
Date:   Mon, 20 Jan 2020 17:50:08 -0500
Subject: Re: load balancing between two chains
From:   sbezverk <sbezverk@gmail.com>
To:     Florian Westphal <fw@strlen.de>
CC:     Phil Sutter <phil@nwl.cc>,
        "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
Message-ID: <3A3D5C9C-86A9-432E-A64F-6F0014E7DD99@gmail.com>
Thread-Topic: load balancing between two chains
References: <011F145A-C830-444E-A9AD-DB45178EBF78@gmail.com>
 <20200120112309.GG19873@orbyte.nwl.cc>
 <F6976F28-188D-4267-8B95-F4BF1EDD43F2@gmail.com>
 <20200120170656.GE795@breakpoint.cc>
 <A774A3A8-64EB-4897-8574-076CC326F020@gmail.com>
 <20200120213954.GF795@breakpoint.cc>
 <BC7FFB04-4465-4B3B-BA5B-17BEA0FC909B@gmail.com>
 <20200120220012.GH795@breakpoint.cc>
 <20200120221225.GI795@breakpoint.cc>
In-Reply-To: <20200120221225.GI795@breakpoint.cc>
Mime-version: 1.0
Content-type: text/plain;
        charset="UTF-8"
Content-transfer-encoding: quoted-printable
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

It started working?!?!?!?!

sbezverk@kube-4:~$ curl http://57.141.53.140:808
Still alive pod1 :)
sbezverk@kube-4:~$ curl http://57.141.53.140:808
Still alive from pod2 :)
sbezverk@kube-4:~$ curl http://57.141.53.140:808
Still alive from pod3 :)
sbezverk@kube-4:~$ curl http://57.141.53.140:808
Still alive pod1 :)
sbezverk@kube-4:~$ curl http://57.141.53.140:808
Still alive from pod2 :)
sbezverk@kube-4:~$ curl http://57.141.53.140:808
Still alive from pod3 :)
sbezverk@kube-4:~$ curl http://57.141.53.140:808
Still alive pod1 :)
sbezverk@kube-4:~$ curl http://57.141.53.140:808
Still alive from pod2 :)

        chain k8s-nfproxy-svc-M53CN2XYVUHRQ7UB { # handle 60
                numgen inc mod 3 vmap { 0 : goto k8s-nfproxy-sep-TMVEFT7EX5=
5F4T62, 1 : goto k8s-nfproxy-sep-GTJ7BFLUOQRCGMD5, 2 : goto k8s-nfproxy-sep-=
23NTSA2UXPPQIPK4, 16777216 : goto endianbug } # handle 174
                counter packets 4 bytes 240 comment "" # handle 76
        }


        chain endianbug { # handle 171
                counter packets 0 bytes 0 # handle 172
        }

Why is that?

Thank you
Serguei

=EF=BB=BFOn 2020-01-20, 5:12 PM, "Florian Westphal" <fw@strlen.de> wrote:

    Florian Westphal <fw@strlen.de> wrote:
    > sbezverk <sbezverk@gmail.com> wrote:
    > > Numgen has GOTO directive and not Jump (Phil asked to change it), I=
 thought it means after hitting any chains in numgen the processing will go =
back to service chain, no?
    > >=20
    > > It is Ubuntu 18.04
    > >=20
    > > sbezverk@kube-4:~$ uname -a
    > > Linux kube-4 5.4.10-050410-generic #202001091038 SMP Thu Jan 9 10:4=
1:11 UTC 2020 x86_64 x86_64 x86_64 GNU/Linux
    > > sbezverk@kube-4:~$ sudo nft --version
    > > nftables v0.9.1 (Headless Horseman)
    > > sbezverk@kube-4:~$
    > >=20
    > > I also want to remind you that I do NOT use nft cli to program rule=
s, I use nft cli just to see resulting rules.
    >=20
    > In that case, please include "nft --debug=3Dnetlink list ruleset".
    >=20
    > It would also be good to check if things work when you add it via nft
    > tool.
   =20
    Oh, and for the fun of it, you could also try this:
   =20
    chain k8s-nfproxy-svc-M53CN2XYVUHRQ7UB {
    	numgen inc mod 2 vmap { 0 : goto k8s-nfproxy-sep-I7XZOUOVPIQW4IXA, 1 :=
 goto k8s-nfproxy-sep-ZNSGEJWUBCC5QYMQ, 16777216 : goto endianbug }
    	counter packets 0 bytes 0 }=20
            chain endianbug {
    		 counter packets 0 bytes 0
    	}
     ...
   =20
    numgen generates a 32bit number in host byte order, so nft internally
    converts the keys accordingly (16777216 is htonl(1)).
   =20


