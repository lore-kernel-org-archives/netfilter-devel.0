Return-Path: <SRS0=AyPt=3K=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=0.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MALFORMED_FREEMAIL,
	NORMAL_HTTP_TO_IP,NUMERIC_HTTP_ADDR,SPF_HELO_NONE,SPF_PASS,WEIRD_PORT
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 051ADC35240
	for <netfilter-devel@archiver.kernel.org>; Tue, 21 Jan 2020 04:18:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BBD8020663
	for <netfilter-devel@archiver.kernel.org>; Tue, 21 Jan 2020 04:18:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PvWEEE1Z"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727829AbgAUESy (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 20 Jan 2020 23:18:54 -0500
Received: from mail-qt1-f182.google.com ([209.85.160.182]:47047 "EHLO
        mail-qt1-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727009AbgAUESy (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 20 Jan 2020 23:18:54 -0500
Received: by mail-qt1-f182.google.com with SMTP id e25so1551677qtr.13
        for <netfilter-devel@vger.kernel.org>; Mon, 20 Jan 2020 20:18:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=user-agent:date:subject:from:to:cc:message-id:thread-topic
         :references:in-reply-to:mime-version:content-transfer-encoding;
        bh=Lv8LS72GqxDQnC666bmYlnkfXWeqg5sbZHbhgT4dgtY=;
        b=PvWEEE1Z2JzZfwSYsVKYaWENkDdHOZwzevtpcWUG//Xlc4GtqvwJDFCFzkAjIbVFKA
         y5bVjqRTez+YjSF3qGbcr8L5yzAQDdyjMz7CWv2jlN5MtfHg76k3k7XC80GqPB6QYYVQ
         QY6DFR5MIA/A8zVcjHMKUGbU6S9fSTYcCTfwL8jQfUJi5nwrMR2ReKQFwqEmnpijsLdz
         jjErFycioLSmcbsSIfp6ScdhIoIITM3rlMQVv1Y2ue5Xfp/4BrRc4dANhoQUrviVGzvE
         iQi0Zcc2PqzErcCAsxhLLfJbjblsOHMsOCwMhj2/Y3+qtzZh2V2IQ7kcCAJd4+06IZKf
         9c9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:user-agent:date:subject:from:to:cc:message-id
         :thread-topic:references:in-reply-to:mime-version
         :content-transfer-encoding;
        bh=Lv8LS72GqxDQnC666bmYlnkfXWeqg5sbZHbhgT4dgtY=;
        b=R6uQ6G6CoNdip4zRTxBdmlZb5eiNI5rrXL+Rz//09YiMDxI32+dM2OS9UuEk89uC1c
         ZvMpPtXoq9uimJaXP9K47J6dAnvI6qSpn4PV63c7BOUFXbyuIrLPA/2grUQh+e4SyrG6
         A8jyiGQSu14MCcsv6uGwPELwQLJGdyiR3aMlcPSeahOe4uBN1mvJIlDTwYy5QWrXQ+Pe
         HXcgPZrEw0FEjXGCnjM/aexWWYBi1inWqyevLOy3bpGvVBW/tv43NltQ/K2Lce1MwJtb
         Nm/1eCByBZwtGuUi49PXtBGuTb41GXkNYfQ+8ReRIEhlIA1hFiToXroChuk6ml6GUiwk
         w3jA==
X-Gm-Message-State: APjAAAX9qqm8iaDAY6fd5W7PMWmqTG16WXfnvu8lPv8gvvGzbKSjtz55
        XsO2o2qNsERJxw4mfo1Bl7y5S3JmAww=
X-Google-Smtp-Source: APXvYqzprWyMWNnYfhIaFB5RDikRvBSvJAE8KOAOLpqWPUbsYXvzBBXpY+OTgd8GIYECTbE36JuQew==
X-Received: by 2002:ac8:6784:: with SMTP id b4mr2606939qtp.27.1579580332900;
        Mon, 20 Jan 2020 20:18:52 -0800 (PST)
Received: from [10.117.94.148] ([173.38.117.91])
        by smtp.gmail.com with ESMTPSA id v67sm16663789qkh.46.2020.01.20.20.18.51
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 20 Jan 2020 20:18:52 -0800 (PST)
User-Agent: Microsoft-MacOutlook/10.21.0.200113
Date:   Mon, 20 Jan 2020 23:18:51 -0500
Subject: Re: load balancing between two chains
From:   sbezverk <sbezverk@gmail.com>
To:     Florian Westphal <fw@strlen.de>
CC:     Phil Sutter <phil@nwl.cc>,
        "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
Message-ID: <F21D35D7-3662-4E47-AACA-65E65DDC28F0@gmail.com>
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

Hello,

After changing code to  set element id as a non big-endian, loadbalancing s=
tarted working, the side effect though,  set shows large number for elements=
 ID.

sbezverk@kube-4:~$ curl http://57.141.53.140:808
Still alive pod1 :)
sbezverk@kube-4:~$ curl http://57.141.53.140:808
Still alive from pod3 :)
sbezverk@kube-4:~$ curl http://57.141.53.140:808
Still alive from pod2 :)
sbezverk@kube-4:~$ curl http://57.141.53.140:808
Still alive pod1 :)

        chain k8s-nfproxy-svc-M53CN2XYVUHRQ7UB { # handle 60
                numgen inc mod 3 vmap { 0 : goto k8s-nfproxy-sep-TMVEFT7EX5=
5F4T62, 16777216 : goto k8s-nfproxy-sep-23NTSA2UXPPQIPK4, 33554432 : goto k8=
s-nfproxy-sep-GTJ7BFLUOQRCGMD5 } # handle 155
                counter packets 0 bytes 0 comment "" # handle 136
        }

Let me know if you plan to fix it eventually.

Thank you very much for your help
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


