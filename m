Return-Path: <SRS0=8tM5=3J=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=0.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MALFORMED_FREEMAIL,
	MIME_QP_LONG_LINE,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A06DC33CAA
	for <netfilter-devel@archiver.kernel.org>; Mon, 20 Jan 2020 16:32:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D0C74217F4
	for <netfilter-devel@archiver.kernel.org>; Mon, 20 Jan 2020 16:32:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="qPpvP7kz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729606AbgATQb5 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 20 Jan 2020 11:31:57 -0500
Received: from mail-qk1-f173.google.com ([209.85.222.173]:37640 "EHLO
        mail-qk1-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729559AbgATQb4 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 20 Jan 2020 11:31:56 -0500
Received: by mail-qk1-f173.google.com with SMTP id 21so30686540qky.4
        for <netfilter-devel@vger.kernel.org>; Mon, 20 Jan 2020 08:31:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=user-agent:date:subject:from:to:cc:message-id:thread-topic
         :references:in-reply-to:mime-version:content-transfer-encoding;
        bh=RizTOlpd3gHLWTC8qkNSwMe9D9sWsiHx51m1Ol93Ecw=;
        b=qPpvP7kzFSuKHPulLzpwrBWpOR5WDR5KXOGEth0xDi5zvL6gEszWOoYryhdaWifioZ
         BHvEjFBmJkzYK8hPYGbXL1cacpWIH0zPKfHaGAdi3A6LddJnRAPoeNgZ1lkJ7tH0r0Qd
         Fh54dqdl9bm2R/Zjs51m/t3j7hNQwvhG0Lq4DLTO+X+wfz0qKt6tjkxjfiNFql3kWgVk
         YKvdUbEAkwSYbEACw7t5j0gGJ5aSI4pZ1vx9qYFIGE7/GtRjObKSK1tLrcHbHDdF96Ph
         8cbwEj23MXfS7wS/D0DUNdS9Ss7EcWEc39bNh3wLNB1WyBDuL/GzBzUHkcI0E2W9Kncp
         KmRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:user-agent:date:subject:from:to:cc:message-id
         :thread-topic:references:in-reply-to:mime-version
         :content-transfer-encoding;
        bh=RizTOlpd3gHLWTC8qkNSwMe9D9sWsiHx51m1Ol93Ecw=;
        b=rP4Bpqa/Zn1YOwpdm4eREu7Ztij3OXhE31fePweNQDq7RXYsN5aeGFMuvMtkqYUj0R
         fhMm7RVrejvWvDQkF4qUBNfQKOSWGCi3xprZwmQfqOzAtnaebtAPLgjZrnZ/0Nzfd/ec
         BDteHm5DZuSdJC5hHaa6oP1PaN8WPBKCWAP0sXDuklCTxZ1gikhucBGWBPdcVRngM6bG
         cMKPAHVaDTxbJQvpcMMxgwgW5p1pxDabwLtHYrk/8MqSMO7bNk1NEADuTV9exKRKk16A
         5oDrs2iRE6PkREYgxDnFsioAb4Wwvu3I56da06GrPer1W4gIwJ3qTLRx74+kP2cQOln7
         HfUA==
X-Gm-Message-State: APjAAAW7+ISK00CMh31JryryzautX0zc5Bn6EZsF+wwsH1kR2/XcYweY
        oCioPhSoK4kSisTZlsam07SYKEvALuQ=
X-Google-Smtp-Source: APXvYqwmJ970ne5N4f9IlLf92UEFoeWhvsNdk2q8LEwjYJusHRe1/9gnFHZSAi06u6AXkOsD7YgPjQ==
X-Received: by 2002:a37:a4e:: with SMTP id 75mr286007qkk.411.1579537915380;
        Mon, 20 Jan 2020 08:31:55 -0800 (PST)
Received: from [10.117.94.148] ([173.38.117.91])
        by smtp.gmail.com with ESMTPSA id z4sm15772318qkz.62.2020.01.20.08.31.54
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 20 Jan 2020 08:31:54 -0800 (PST)
User-Agent: Microsoft-MacOutlook/10.21.0.200113
Date:   Mon, 20 Jan 2020 11:31:53 -0500
Subject: Re: load balancing between two chains
From:   sbezverk <sbezverk@gmail.com>
To:     Phil Sutter <phil@nwl.cc>
CC:     "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
Message-ID: <F6976F28-188D-4267-8B95-F4BF1EDD43F2@gmail.com>
Thread-Topic: load balancing between two chains
References: <011F145A-C830-444E-A9AD-DB45178EBF78@gmail.com>
 <20200120112309.GG19873@orbyte.nwl.cc>
In-Reply-To: <20200120112309.GG19873@orbyte.nwl.cc>
Mime-version: 1.0
Content-type: text/plain;
        charset="UTF-8"
Content-transfer-encoding: quoted-printable
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

HI Phil,

There is no loadblancer, curl is executed from the actual node with both po=
ds, so all traffic is local to the node.

As per your suggestion I modified nfproxy rules:

        chain k8s-nfproxy-svc-M53CN2XYVUHRQ7UB {
                numgen random mod 2 vmap { 0 : goto k8s-nfproxy-sep-I7XZOUO=
VPIQW4IXA, 1 : goto k8s-nfproxy-sep-ZNSGEJWUBCC5QYMQ }
                counter packets 3 bytes 180 comment ""
        }

        chain k8s-nfproxy-sep-ZNSGEJWUBCC5QYMQ {
                counter packets 0 bytes 0 comment ""
                ip saddr 57.112.0.38 meta mark set 0x00004000 comment ""
                dnat to 57.112.0.38:8080 fully-random
        }

        chain k8s-nfproxy-sep-I7XZOUOVPIQW4IXA {
                counter packets 1 bytes 60 comment ""
                ip saddr 57.112.0.36 meta mark set 0x00004000 comment ""
                dnat to 57.112.0.36:8989 fully-random
        }

I could not find file /proc/net/nf_conntrac but I do see nf_conntrack modul=
e is loaded:
nf_conntrack          131072  12 xt_conntrack,nf_nat,nft_ct,nft_nat,nf_nat_=
ipv6,ipt_MASQUERADE,nf_nat_ipv4,xt_nat,nf_conntrack_netlink,nft_masq,nft_mas=
q_ipv4,ip_vs

tcpdump in the pod 1 does not see any curl's generated packets, but in pod =
2 it does.=20

I noticed one hofully useful fact,  it is always endpoint associated with 1=
st chain in numgen rule works and 2nd does not.

Anything else I could try to collect to understand why this rule does not w=
ork as intended?

Thank you very much for your help
Serguei

=EF=BB=BFOn 2020-01-20, 6:23 AM, "Phil Sutter" <n0-1@orbyte.nwl.cc on behalf of p=
hil@nwl.cc> wrote:

    Hi Serguei,
   =20
    On Sun, Jan 19, 2020 at 09:46:11PM -0500, sbezverk wrote:
    > While doing some performance test, btw the results are awesome so far=
, I came across an issue. It is kubernetes environment, there is a Cluster s=
cope service with 2 backends, 2 pods. The rule for this service program a lo=
ad balancing between 2 chains representing each backend pod.  When I curl th=
e service, only 1 backend pod replies, second times out. If I delete pod whi=
ch was working, then second pod starts replying to curl requests. Here are s=
ome logs and packets captures. Appreciate if you could take a look at it and=
 share your thoughts.
   =20
    Please add counters to your rules to check if both dnat statements are
    hit. You may also switch 'jump' in vmap to 'goto' and add a final rule
    in k8s-nfproxy-svc-M53CN2XYVUHRQ7UB (which should never see packets).
   =20
    Did you provide a dump of traffic between load-balancer and pod2? (No
    traffic is relevant info, too!) A dump of /proc/net/nf_conntrack in
    error situation might reveal something, too.
   =20
    Cheers, Phil
   =20


