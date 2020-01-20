Return-Path: <SRS0=8tM5=3J=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=0.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MALFORMED_FREEMAIL,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E6C2C32771
	for <netfilter-devel@archiver.kernel.org>; Mon, 20 Jan 2020 22:07:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C2663217F4
	for <netfilter-devel@archiver.kernel.org>; Mon, 20 Jan 2020 22:07:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iK/k8hIf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726897AbgATWHx (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 20 Jan 2020 17:07:53 -0500
Received: from mail-qt1-f171.google.com ([209.85.160.171]:37618 "EHLO
        mail-qt1-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726607AbgATWHx (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 20 Jan 2020 17:07:53 -0500
Received: by mail-qt1-f171.google.com with SMTP id w47so1054356qtk.4
        for <netfilter-devel@vger.kernel.org>; Mon, 20 Jan 2020 14:07:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=user-agent:date:subject:from:to:cc:message-id:thread-topic
         :references:in-reply-to:mime-version:content-transfer-encoding;
        bh=t0pxz7+wl6TMtHMQhwl4MMdpV8vi3wYqmMoz8ej5jhk=;
        b=iK/k8hIfD859TR/lRgSd3ujIe9Z1jnzCh5AaHwsOpuPIhDmIetoKjS7sSCtl3mYqOT
         q1t3UJ3FT3rtFPFDowexdr2/Ww20HSG427xxcFsRRVeLOkGkV0kAF3S7zJw9ueSas9ey
         7Y9F9RxSwtt2xCXGLFir3F9N01A4u89/jwu15sbhwL4PO644ryYqP6mJ6t05LO6Qgtlk
         9PMBnAF5kYaRir6N8e7C7IO6lqv5hp0P4+QhRIhlnVDpnJVyNWrx8Fn1bPuv8kVXEp5L
         zj9Leq+xEUdbuxiuC9/mmUZMRFP//7Kjft16+AJXzQ5iJFtZj9E/lBsm1C8/uDWA4QAp
         eORA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:user-agent:date:subject:from:to:cc:message-id
         :thread-topic:references:in-reply-to:mime-version
         :content-transfer-encoding;
        bh=t0pxz7+wl6TMtHMQhwl4MMdpV8vi3wYqmMoz8ej5jhk=;
        b=jHeP/+TczZRf9f5V1/4fA7rJpZf7x7CvSeORm0SwEQ5V+GRW9VybB3WpvQOTdGIP1E
         Ei+hEB01ZTyAs6KIQLTFygRkhbN9ktjOSSpjeA0Y3X15yc3HogcYDSNs4bRy5xCYOKsO
         fIwI6FDlmMYrh8rLPAiUsLUqREL/pmWqQux2Sp3O+ue3SHW5NBErCtbbTS4+OrhCC/c2
         OG7VLIDRtgODZDTjQ2SK1g9G7ANiTboZQdkhFjp/4Ac89aJTsIz4Op+XTxe//8d07Y0C
         7EjXwSyNAb/7u85LokW1iv+A4NNi8KdkyxsBydNXodfxB+ujRiAOUyIHqZXnRkSRVZ+c
         ys1w==
X-Gm-Message-State: APjAAAUv4Ee6dljkpld38GHpkaFmK1Cotjbwt98/69a+HtPSa4iEvbBt
        kjP0zZH7IzyoJXAcBRX2kpYynBxiato=
X-Google-Smtp-Source: APXvYqzP0xg9oM6iVWHzbWLXCSK0xIixPTXXagDOJ3DKaTOG6aypTeJ+0iUIaPKc5rQ5HyXn9cXz2A==
X-Received: by 2002:aed:31a7:: with SMTP id 36mr1537833qth.67.1579558071283;
        Mon, 20 Jan 2020 14:07:51 -0800 (PST)
Received: from [10.117.94.148] ([173.38.117.91])
        by smtp.gmail.com with ESMTPSA id u55sm18774095qtc.28.2020.01.20.14.07.50
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 20 Jan 2020 14:07:50 -0800 (PST)
User-Agent: Microsoft-MacOutlook/10.21.0.200113
Date:   Mon, 20 Jan 2020 17:07:49 -0500
Subject: Re: load balancing between two chains
From:   sbezverk <sbezverk@gmail.com>
To:     Florian Westphal <fw@strlen.de>
CC:     Phil Sutter <phil@nwl.cc>,
        "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
Message-ID: <D2179763-BA51-4DA2-AA97-16CD2DA8FF2C@gmail.com>
Thread-Topic: load balancing between two chains
References: <011F145A-C830-444E-A9AD-DB45178EBF78@gmail.com>
 <20200120112309.GG19873@orbyte.nwl.cc>
 <F6976F28-188D-4267-8B95-F4BF1EDD43F2@gmail.com>
 <20200120170656.GE795@breakpoint.cc>
 <A774A3A8-64EB-4897-8574-076CC326F020@gmail.com>
 <20200120213954.GF795@breakpoint.cc>
 <BC7FFB04-4465-4B3B-BA5B-17BEA0FC909B@gmail.com>
 <20200120220012.GH795@breakpoint.cc>
In-Reply-To: <20200120220012.GH795@breakpoint.cc>
Mime-version: 1.0
Content-type: text/plain;
        charset="UTF-8"
Content-transfer-encoding: quoted-printable
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Here you go:

sbezverk@kube-4:~$ sudo nft --debug=3Dnetlink list ruleset
ip kube-nfproxy-v4 filter-input 23=20
  [ ct load state =3D> reg 1 ]
  [ bitwise reg 1 =3D (reg=3D1 & 0x00000008 ) ^ 0x00000000 ]
  [ cmp neq reg 1 0x00000000 ]
  [ immediate reg 0 jump -> k8s-filter-services ]
  userdata =3D {=20
ip kube-nfproxy-v4 filter-input 24 23=20
  [ immediate reg 0 jump -> k8s-filter-firewall ]
  userdata =3D {=20
ip kube-nfproxy-v4 filter-output 27=20
  [ ct load state =3D> reg 1 ]
  [ bitwise reg 1 =3D (reg=3D1 & 0x00000008 ) ^ 0x00000000 ]
  [ cmp neq reg 1 0x00000000 ]
  [ immediate reg 0 jump -> k8s-filter-services ]
  userdata =3D {=20
ip kube-nfproxy-v4 filter-output 28 27=20
  [ immediate reg 0 jump -> k8s-filter-firewall ]
  userdata =3D {=20
ip kube-nfproxy-v4 filter-forward 25=20
  [ immediate reg 0 jump -> k8s-filter-forward ]
  userdata =3D {=20
ip kube-nfproxy-v4 filter-forward 26 25=20
  [ ct load state =3D> reg 1 ]
  [ bitwise reg 1 =3D (reg=3D1 & 0x00000008 ) ^ 0x00000000 ]
  [ cmp neq reg 1 0x00000000 ]
  [ immediate reg 0 jump -> k8s-filter-services ]
  userdata =3D {=20
ip kube-nfproxy-v4 k8s-filter-firewall 29=20
  [ meta load mark =3D> reg 1 ]
  [ cmp eq reg 1 0x00008000 ]
  [ immediate reg 0 drop ]
  userdata =3D {=20
ip kube-nfproxy-v4 k8s-filter-services 35=20
  [ payload load 1b @ network header + 9 =3D> reg 1 ]
  [ payload load 4b @ network header + 16 =3D> reg 9 ]
  [ payload load 2b @ transport header + 2 =3D> reg 10 ]
  [ lookup reg 1 set no-endpoints dreg 0 0x0 ]
  userdata =3D {=20
ip kube-nfproxy-v4 k8s-filter-forward 30=20
  [ ct load state =3D> reg 1 ]
  [ bitwise reg 1 =3D (reg=3D1 & 0x00000001 ) ^ 0x00000000 ]
  [ cmp neq reg 1 0x00000000 ]
  [ immediate reg 0 drop ]
  userdata =3D {=20
ip kube-nfproxy-v4 k8s-filter-forward 31 30=20
  [ meta load mark =3D> reg 1 ]
  [ cmp eq reg 1 0x00004000 ]
  [ immediate reg 0 accept ]
  userdata =3D {=20
ip kube-nfproxy-v4 k8s-filter-forward 32 31=20
  [ payload load 4b @ network header + 12 =3D> reg 1 ]
  [ bitwise reg 1 =3D (reg=3D1 & 0x0000f0ff ) ^ 0x00000000 ]
  [ cmp eq reg 1 0x00007039 ]
  [ ct load state =3D> reg 1 ]
  [ bitwise reg 1 =3D (reg=3D1 & 0x00000006 ) ^ 0x00000000 ]
  [ cmp neq reg 1 0x00000000 ]
  [ immediate reg 0 accept ]
  userdata =3D {=20
ip kube-nfproxy-v4 k8s-filter-forward 33 32=20
  [ payload load 4b @ network header + 16 =3D> reg 1 ]
  [ bitwise reg 1 =3D (reg=3D1 & 0x0000f0ff ) ^ 0x00000000 ]
  [ cmp eq reg 1 0x00007039 ]
  [ ct load state =3D> reg 1 ]
  [ bitwise reg 1 =3D (reg=3D1 & 0x00000006 ) ^ 0x00000000 ]
  [ cmp neq reg 1 0x00000000 ]
  [ immediate reg 0 accept ]
  userdata =3D {=20
ip kube-nfproxy-v4 k8s-filter-do-reject 34=20
  [ reject type 0 code 1 ]
  userdata =3D {=20
ip kube-nfproxy-v4 nat-preroutin 36=20
  [ immediate reg 0 jump -> k8s-nat-services ]
  userdata =3D {=20
ip kube-nfproxy-v4 nat-output 37=20
  [ immediate reg 0 jump -> k8s-nat-services ]
  userdata =3D {=20
ip kube-nfproxy-v4 nat-postrouting 38=20
  [ immediate reg 0 jump -> k8s-nat-postrouting ]
  userdata =3D {=20
ip kube-nfproxy-v4 k8s-nat-mark-drop 39=20
  [ immediate reg 1 0x00008000 ]
  [ meta set mark with reg 1 ]
  userdata =3D {=20
ip kube-nfproxy-v4 k8s-nat-do-mark-masq 47=20
  [ immediate reg 1 0x00004000 ]
  [ meta set mark with reg 1 ]
  [ immediate reg 0 return ]
  userdata =3D {=20
ip kube-nfproxy-v4 k8s-nat-mark-masq 48=20
  [ payload load 1b @ network header + 9 =3D> reg 1 ]
  [ payload load 4b @ network header + 16 =3D> reg 9 ]
  [ payload load 2b @ transport header + 2 =3D> reg 10 ]
  [ lookup reg 1 set do-mark-masq dreg 0 0x0 ]
  userdata =3D {=20
ip kube-nfproxy-v4 k8s-nat-mark-masq 49 48=20
  [ immediate reg 0 return ]
  userdata =3D {=20
ip kube-nfproxy-v4 k8s-nat-services 41=20
  [ payload load 4b @ network header + 12 =3D> reg 1 ]
  [ bitwise reg 1 =3D (reg=3D1 & 0x0000f0ff ) ^ 0x00000000 ]
  [ cmp neq reg 1 0x00007039 ]
  [ immediate reg 0 jump -> k8s-nat-mark-masq ]
  userdata =3D {=20
ip kube-nfproxy-v4 k8s-nat-services 42 41=20
  [ payload load 1b @ network header + 9 =3D> reg 1 ]
  [ payload load 4b @ network header + 16 =3D> reg 9 ]
  [ payload load 2b @ transport header + 2 =3D> reg 10 ]
  [ lookup reg 1 set cluster-ip dreg 0 0x0 ]
  userdata =3D {=20
ip kube-nfproxy-v4 k8s-nat-services 43 42=20
  [ payload load 1b @ network header + 9 =3D> reg 1 ]
  [ payload load 4b @ network header + 16 =3D> reg 9 ]
  [ payload load 2b @ transport header + 2 =3D> reg 10 ]
  [ lookup reg 1 set external-ip dreg 0 0x0 ]
  userdata =3D {=20
ip kube-nfproxy-v4 k8s-nat-services 44 43=20
  [ payload load 1b @ network header + 9 =3D> reg 1 ]
  [ payload load 4b @ network header + 16 =3D> reg 9 ]
  [ payload load 2b @ transport header + 2 =3D> reg 10 ]
  [ lookup reg 1 set loadbalancer-ip dreg 0 0x0 ]
  userdata =3D {=20
ip kube-nfproxy-v4 k8s-nat-services 45 44=20
  [ fib daddr type =3D> reg 1 ]
  [ cmp eq reg 1 0x00000002 ]
  [ immediate reg 0 jump -> k8s-nat-nodeports ]
  userdata =3D {=20
ip kube-nfproxy-v4 k8s-nat-nodeports 46=20
  [ payload load 1b @ network header + 9 =3D> reg 1 ]
  [ payload load 2b @ transport header + 2 =3D> reg 9 ]
  [ lookup reg 1 set nodeports dreg 0 0x0 ]
  userdata =3D {=20
ip kube-nfproxy-v4 k8s-nat-postrouting 40=20
  [ meta load mark =3D> reg 1 ]
  [ cmp eq reg 1 0x00004000 ]
  [ masq flags 0xc ]
  userdata =3D {=20
ip kube-nfproxy-v4 k8s-nfproxy-svc-Z2V2H34MNX3I6O2G 112=20
  [ numgen reg 1 =3D inc mod 2 ]
  [ lookup reg 1 set __map2 dreg 0 0x0 ]
  userdata =3D {=20
ip kube-nfproxy-v4 k8s-nfproxy-svc-Z2V2H34MNX3I6O2G 59 112=20
  [ counter pkts 1 bytes 60 ]
  userdata =3D {=20
ip kube-nfproxy-v4 k8s-nfproxy-sep-WTQR35QT3M6PVG5X 54=20
  [ counter pkts 3 bytes 180 ]
  userdata =3D {=20
ip kube-nfproxy-v4 k8s-nfproxy-sep-WTQR35QT3M6PVG5X 55 54=20
  [ payload load 4b @ network header + 12 =3D> reg 1 ]
  [ bitwise reg 1 =3D (reg=3D1 & 0xffffffff ) ^ 0x00000000 ]
  [ cmp eq reg 1 0x6850a8c0 ]
  [ immediate reg 1 0x00004000 ]
  [ meta set mark with reg 1 ]
  userdata =3D {=20
ip kube-nfproxy-v4 k8s-nfproxy-sep-WTQR35QT3M6PVG5X 56 55=20
  [ immediate reg 1 0x6850a8c0 ]
  [ immediate reg 2 0x00002b19 ]
  [ nat dnat ip addr_min reg 1 addr_max reg 1 proto_min reg 2 proto_max reg=
 2 flags 16]
  userdata =3D {=20
ip kube-nfproxy-v4 k8s-nfproxy-sep-WTQR35QT3M6PVG5X 108 56=20
  [ counter pkts 0 bytes 0 ]
  userdata =3D {=20
ip kube-nfproxy-v4 k8s-nfproxy-sep-WTQR35QT3M6PVG5X 109 108=20
  [ payload load 4b @ network header + 12 =3D> reg 1 ]
  [ bitwise reg 1 =3D (reg=3D1 & 0xffffffff ) ^ 0x00000000 ]
  [ cmp eq reg 1 0x6850a8c0 ]
  [ immediate reg 1 0x00004000 ]
  [ meta set mark with reg 1 ]
  userdata =3D {=20
ip kube-nfproxy-v4 k8s-nfproxy-sep-WTQR35QT3M6PVG5X 110 109=20
  [ immediate reg 1 0x6850a8c0 ]
  [ immediate reg 2 0x00002b19 ]
  [ nat dnat ip addr_min reg 1 addr_max reg 1 proto_min reg 2 proto_max reg=
 2 flags 16]
  userdata =3D {=20
ip kube-nfproxy-v4 k8s-nfproxy-svc-M53CN2XYVUHRQ7UB 170=20
  [ numgen reg 1 =3D inc mod 3 ]
  [ lookup reg 1 set __map5 dreg 0 0x0 ]
  userdata =3D {=20
ip kube-nfproxy-v4 k8s-nfproxy-svc-M53CN2XYVUHRQ7UB 76 170=20
  [ counter pkts 4 bytes 240 ]
  userdata =3D {=20
ip kube-nfproxy-v4 k8s-nfproxy-svc-PL4AZP3AKMRCVEEV 101=20
  [ numgen reg 1 =3D inc mod 2 ]
  [ lookup reg 1 set __map1 dreg 0 0x0 ]
  userdata =3D {=20
ip kube-nfproxy-v4 k8s-nfproxy-svc-PL4AZP3AKMRCVEEV 83 101=20
  [ counter pkts 0 bytes 0 ]
  userdata =3D {=20
ip kube-nfproxy-v4 k8s-nfproxy-sep-F3FYSUNEU5GRF2PR 67=20
  [ counter pkts 156 bytes 9360 ]
  userdata =3D {=20
ip kube-nfproxy-v4 k8s-nfproxy-sep-F3FYSUNEU5GRF2PR 68 67=20
  [ payload load 4b @ network header + 12 =3D> reg 1 ]
  [ bitwise reg 1 =3D (reg=3D1 & 0xffffffff ) ^ 0x00000000 ]
  [ cmp eq reg 1 0x27007039 ]
  [ immediate reg 1 0x00004000 ]
  [ meta set mark with reg 1 ]
  userdata =3D {=20
ip kube-nfproxy-v4 k8s-nfproxy-sep-F3FYSUNEU5GRF2PR 69 68=20
  [ immediate reg 1 0x27007039 ]
  [ immediate reg 2 0x0000911f ]
  [ nat dnat ip addr_min reg 1 addr_max reg 1 proto_min reg 2 proto_max reg=
 2 flags 16]
  userdata =3D {=20
ip kube-nfproxy-v4 k8s-nfproxy-sep-TMVEFT7EX55F4T62 71=20
  [ counter pkts 3 bytes 180 ]
  userdata =3D {=20
ip kube-nfproxy-v4 k8s-nfproxy-sep-TMVEFT7EX55F4T62 72 71=20
  [ payload load 4b @ network header + 12 =3D> reg 1 ]
  [ bitwise reg 1 =3D (reg=3D1 & 0xffffffff ) ^ 0x00000000 ]
  [ cmp eq reg 1 0x29007039 ]
  [ immediate reg 1 0x00004000 ]
  [ meta set mark with reg 1 ]
  userdata =3D {=20
ip kube-nfproxy-v4 k8s-nfproxy-sep-TMVEFT7EX55F4T62 73 72=20
  [ immediate reg 1 0x29007039 ]
  [ immediate reg 2 0x0000901f ]
  [ nat dnat ip addr_min reg 1 addr_max reg 1 proto_min reg 2 proto_max reg=
 2 flags 16]
  userdata =3D {=20
ip kube-nfproxy-v4 k8s-nfproxy-sep-UOK7V3LF34NNNXJK 78=20
  [ counter pkts 0 bytes 0 ]
  userdata =3D {=20
ip kube-nfproxy-v4 k8s-nfproxy-sep-UOK7V3LF34NNNXJK 79 78=20
  [ payload load 4b @ network header + 12 =3D> reg 1 ]
  [ bitwise reg 1 =3D (reg=3D1 & 0xffffffff ) ^ 0x00000000 ]
  [ cmp eq reg 1 0x29007039 ]
  [ immediate reg 1 0x00004000 ]
  [ meta set mark with reg 1 ]
  userdata =3D {=20
ip kube-nfproxy-v4 k8s-nfproxy-sep-UOK7V3LF34NNNXJK 80 79=20
  [ immediate reg 1 0x29007039 ]
  [ immediate reg 2 0x00009a1f ]
  [ nat dnat ip addr_min reg 1 addr_max reg 1 proto_min reg 2 proto_max reg=
 2 flags 16]
  userdata =3D {=20
ip kube-nfproxy-v4 k8s-nfproxy-svc-ZQKXCYOBISQCSH6Q 124=20
  [ numgen reg 1 =3D inc mod 1 ]
  [ lookup reg 1 set __map4 dreg 0 0x0 ]
  userdata =3D {=20
ip kube-nfproxy-v4 k8s-nfproxy-svc-ZQKXCYOBISQCSH6Q 125 124=20
  [ counter pkts 0 bytes 0 ]
  userdata =3D {=20
ip kube-nfproxy-v4 k8s-nfproxy-sep-GTJ7BFLUOQRCGMD5 88=20
  [ counter pkts 0 bytes 0 ]
  userdata =3D {=20
ip kube-nfproxy-v4 k8s-nfproxy-sep-GTJ7BFLUOQRCGMD5 89 88=20
  [ payload load 4b @ network header + 12 =3D> reg 1 ]
  [ bitwise reg 1 =3D (reg=3D1 & 0xffffffff ) ^ 0x00000000 ]
  [ cmp eq reg 1 0x34007039 ]
  [ immediate reg 1 0x00004000 ]
  [ meta set mark with reg 1 ]
  userdata =3D {=20
ip kube-nfproxy-v4 k8s-nfproxy-sep-GTJ7BFLUOQRCGMD5 90 89=20
  [ immediate reg 1 0x34007039 ]
  [ immediate reg 2 0x00001d23 ]
  [ nat dnat ip addr_min reg 1 addr_max reg 1 proto_min reg 2 proto_max reg=
 2 flags 16]
  userdata =3D {=20
ip kube-nfproxy-v4 k8s-nfproxy-svc-MLOFX2HRWDMEIJ2C 138=20
  [ numgen reg 1 =3D inc mod 2 ]
  [ lookup reg 1 set __map6 dreg 0 0x0 ]
  userdata =3D {=20
ip kube-nfproxy-v4 k8s-nfproxy-svc-MLOFX2HRWDMEIJ2C 132 138=20
  [ counter pkts 1597 bytes 126466 ]
  userdata =3D {=20
ip kube-nfproxy-v4 k8s-nfproxy-sep-AB4FZJCEEYJGUR7G 97=20
  [ counter pkts 0 bytes 0 ]
  userdata =3D {=20
ip kube-nfproxy-v4 k8s-nfproxy-sep-AB4FZJCEEYJGUR7G 98 97=20
  [ payload load 4b @ network header + 12 =3D> reg 1 ]
  [ bitwise reg 1 =3D (reg=3D1 & 0xffffffff ) ^ 0x00000000 ]
  [ cmp eq reg 1 0x34007039 ]
  [ immediate reg 1 0x00004000 ]
  [ meta set mark with reg 1 ]
  userdata =3D {=20
ip kube-nfproxy-v4 k8s-nfproxy-sep-AB4FZJCEEYJGUR7G 99 98=20
  [ immediate reg 1 0x34007039 ]
  [ immediate reg 2 0x00002623 ]
  [ nat dnat ip addr_min reg 1 addr_max reg 1 proto_min reg 2 proto_max reg=
 2 flags 16]
  userdata =3D {=20
ip kube-nfproxy-v4 k8s-nfproxy-svc-BKEZZE5BBBAFLJMD 151=20
  [ numgen reg 1 =3D inc mod 2 ]
  [ lookup reg 1 set __map7 dreg 0 0x0 ]
  userdata =3D {=20
ip kube-nfproxy-v4 k8s-nfproxy-svc-BKEZZE5BBBAFLJMD 145 151=20
  [ counter pkts 0 bytes 0 ]
  userdata =3D {=20
ip kube-nfproxy-v4 k8s-nfproxy-svc-XZFCNG333PM4X5VI 164=20
  [ numgen reg 1 =3D inc mod 2 ]
  [ lookup reg 1 set __map8 dreg 0 0x0 ]
  userdata =3D {=20
ip kube-nfproxy-v4 k8s-nfproxy-svc-XZFCNG333PM4X5VI 158 164=20
  [ counter pkts 0 bytes 0 ]
  userdata =3D {=20
ip kube-nfproxy-v4 k8s-nfproxy-svc-ALEQQYFAJOE576GL 117=20
  [ numgen reg 1 =3D inc mod 1 ]
  [ lookup reg 1 set __map0 dreg 0 0x0 ]
  userdata =3D {=20
ip kube-nfproxy-v4 k8s-nfproxy-svc-ALEQQYFAJOE576GL 118 117=20
  [ counter pkts 0 bytes 0 ]
  userdata =3D {=20
ip kube-nfproxy-v4 k8s-nfproxy-sep-5CXJFIVYWUOH4QP5 120=20
  [ counter pkts 1 bytes 60 ]
  userdata =3D {=20
ip kube-nfproxy-v4 k8s-nfproxy-sep-5CXJFIVYWUOH4QP5 121 120=20
  [ payload load 4b @ network header + 12 =3D> reg 1 ]
  [ bitwise reg 1 =3D (reg=3D1 & 0xffffffff ) ^ 0x00000000 ]
  [ cmp eq reg 1 0x2f007039 ]
  [ immediate reg 1 0x00004000 ]
  [ meta set mark with reg 1 ]
  userdata =3D {=20
ip kube-nfproxy-v4 k8s-nfproxy-sep-5CXJFIVYWUOH4QP5 122 121=20
  [ immediate reg 1 0x2f007039 ]
  [ immediate reg 2 0x0000bb01 ]
  [ nat dnat ip addr_min reg 1 addr_max reg 1 proto_min reg 2 proto_max reg=
 2 flags 16]
  userdata =3D {=20
ip kube-nfproxy-v4 k8s-nfproxy-sep-ZLBUKWY4CZE4VBQ6 127=20
  [ counter pkts 1597 bytes 127401 ]
  userdata =3D {=20
ip kube-nfproxy-v4 k8s-nfproxy-sep-ZLBUKWY4CZE4VBQ6 128 127=20
  [ payload load 4b @ network header + 12 =3D> reg 1 ]
  [ bitwise reg 1 =3D (reg=3D1 & 0xffffffff ) ^ 0x00000000 ]
  [ cmp eq reg 1 0x2a007039 ]
  [ immediate reg 1 0x00004000 ]
  [ meta set mark with reg 1 ]
  userdata =3D {=20
ip kube-nfproxy-v4 k8s-nfproxy-sep-ZLBUKWY4CZE4VBQ6 129 128=20
  [ immediate reg 1 0x2a007039 ]
  [ immediate reg 2 0x00003500 ]
  [ nat dnat ip addr_min reg 1 addr_max reg 1 proto_min reg 2 proto_max reg=
 2 flags 16]
  userdata =3D {=20
ip kube-nfproxy-v4 k8s-nfproxy-sep-L7QM2ZN4KU2U3Y7S 134=20
  [ counter pkts 0 bytes 0 ]
  userdata =3D {=20
ip kube-nfproxy-v4 k8s-nfproxy-sep-L7QM2ZN4KU2U3Y7S 135 134=20
  [ payload load 4b @ network header + 12 =3D> reg 1 ]
  [ bitwise reg 1 =3D (reg=3D1 & 0xffffffff ) ^ 0x00000000 ]
  [ cmp eq reg 1 0x2b007039 ]
  [ immediate reg 1 0x00004000 ]
  [ meta set mark with reg 1 ]
  userdata =3D {=20
ip kube-nfproxy-v4 k8s-nfproxy-sep-L7QM2ZN4KU2U3Y7S 136 135=20
  [ immediate reg 1 0x2b007039 ]
  [ immediate reg 2 0x00003500 ]
  [ nat dnat ip addr_min reg 1 addr_max reg 1 proto_min reg 2 proto_max reg=
 2 flags 16]
  userdata =3D {=20
ip kube-nfproxy-v4 k8s-nfproxy-sep-47JQSZ5IZC6OSGGT 140=20
  [ counter pkts 0 bytes 0 ]
  userdata =3D {=20
ip kube-nfproxy-v4 k8s-nfproxy-sep-47JQSZ5IZC6OSGGT 141 140=20
  [ payload load 4b @ network header + 12 =3D> reg 1 ]
  [ bitwise reg 1 =3D (reg=3D1 & 0xffffffff ) ^ 0x00000000 ]
  [ cmp eq reg 1 0x2a007039 ]
  [ immediate reg 1 0x00004000 ]
  [ meta set mark with reg 1 ]
  userdata =3D {=20
ip kube-nfproxy-v4 k8s-nfproxy-sep-47JQSZ5IZC6OSGGT 142 141=20
  [ immediate reg 1 0x2a007039 ]
  [ immediate reg 2 0x00003500 ]
  [ nat dnat ip addr_min reg 1 addr_max reg 1 proto_min reg 2 proto_max reg=
 2 flags 16]
  userdata =3D {=20
ip kube-nfproxy-v4 k8s-nfproxy-sep-SLRAZLUBLWQJXVD6 147=20
  [ counter pkts 0 bytes 0 ]
  userdata =3D {=20
ip kube-nfproxy-v4 k8s-nfproxy-sep-SLRAZLUBLWQJXVD6 148 147=20
  [ payload load 4b @ network header + 12 =3D> reg 1 ]
  [ bitwise reg 1 =3D (reg=3D1 & 0xffffffff ) ^ 0x00000000 ]
  [ cmp eq reg 1 0x2b007039 ]
  [ immediate reg 1 0x00004000 ]
  [ meta set mark with reg 1 ]
  userdata =3D {=20
ip kube-nfproxy-v4 k8s-nfproxy-sep-SLRAZLUBLWQJXVD6 149 148=20
  [ immediate reg 1 0x2b007039 ]
  [ immediate reg 2 0x00003500 ]
  [ nat dnat ip addr_min reg 1 addr_max reg 1 proto_min reg 2 proto_max reg=
 2 flags 16]
  userdata =3D {=20
ip kube-nfproxy-v4 k8s-nfproxy-sep-MDXSOI4QEYHXQ5TE 153=20
  [ counter pkts 0 bytes 0 ]
  userdata =3D {=20
ip kube-nfproxy-v4 k8s-nfproxy-sep-MDXSOI4QEYHXQ5TE 154 153=20
  [ payload load 4b @ network header + 12 =3D> reg 1 ]
  [ bitwise reg 1 =3D (reg=3D1 & 0xffffffff ) ^ 0x00000000 ]
  [ cmp eq reg 1 0x2a007039 ]
  [ immediate reg 1 0x00004000 ]
  [ meta set mark with reg 1 ]
  userdata =3D {=20
ip kube-nfproxy-v4 k8s-nfproxy-sep-MDXSOI4QEYHXQ5TE 155 154=20
  [ immediate reg 1 0x2a007039 ]
  [ immediate reg 2 0x0000c123 ]
  [ nat dnat ip addr_min reg 1 addr_max reg 1 proto_min reg 2 proto_max reg=
 2 flags 16]
  userdata =3D {=20
ip kube-nfproxy-v4 k8s-nfproxy-sep-MQDIJAQHMGQYQDQC 160=20
  [ counter pkts 0 bytes 0 ]
  userdata =3D {=20
ip kube-nfproxy-v4 k8s-nfproxy-sep-MQDIJAQHMGQYQDQC 161 160=20
  [ payload load 4b @ network header + 12 =3D> reg 1 ]
  [ bitwise reg 1 =3D (reg=3D1 & 0xffffffff ) ^ 0x00000000 ]
  [ cmp eq reg 1 0x2b007039 ]
  [ immediate reg 1 0x00004000 ]
  [ meta set mark with reg 1 ]
  userdata =3D {=20
ip kube-nfproxy-v4 k8s-nfproxy-sep-MQDIJAQHMGQYQDQC 162 161=20
  [ immediate reg 1 0x2b007039 ]
  [ immediate reg 2 0x0000c123 ]
  [ nat dnat ip addr_min reg 1 addr_max reg 1 proto_min reg 2 proto_max reg=
 2 flags 16]
  userdata =3D {=20
ip kube-nfproxy-v4 k8s-nfproxy-sep-23NTSA2UXPPQIPK4 166=20
  [ counter pkts 0 bytes 0 ]
  userdata =3D {=20
ip kube-nfproxy-v4 k8s-nfproxy-sep-23NTSA2UXPPQIPK4 167 166=20
  [ payload load 4b @ network header + 12 =3D> reg 1 ]
  [ bitwise reg 1 =3D (reg=3D1 & 0xffffffff ) ^ 0x00000000 ]
  [ cmp eq reg 1 0x35007039 ]
  [ immediate reg 1 0x00004000 ]
  [ meta set mark with reg 1 ]
  userdata =3D {=20
ip kube-nfproxy-v4 k8s-nfproxy-sep-23NTSA2UXPPQIPK4 168 167=20
  [ immediate reg 1 0x35007039 ]
  [ immediate reg 2 0x00005322 ]
  [ nat dnat ip addr_min reg 1 addr_max reg 1 proto_min reg 2 proto_max reg=
 2 flags 16]
  userdata =3D {=20
table inet filter {
        chain input {
                type filter hook input priority filter; policy accept;
        }

        chain forward {
                type filter hook forward priority filter; policy accept;
        }

        chain output {
                type filter hook output priority filter; policy accept;
        }
}
table ip kube-nfproxy-v4 {
        map no-endpoints {
                type inet_proto . ipv4_addr . inet_service : verdict
        }

        map do-mark-masq {
                type inet_proto . ipv4_addr . inet_service : verdict
                elements =3D { tcp . 57.128.0.1 . 443 : jump k8s-nat-do-mark-=
masq,
                             tcp . 57.128.0.10 . 53 : jump k8s-nat-do-mark-=
masq,
                             tcp . 57.128.0.10 . 9153 : jump k8s-nat-do-mar=
k-masq,
                             tcp . 57.139.80.125 . 8081 : jump k8s-nat-do-m=
ark-masq,
                             tcp . 57.141.10.218 . 443 : jump k8s-nat-do-ma=
rk-masq,
                             tcp . 57.141.53.140 . 808 : jump k8s-nat-do-ma=
rk-masq,
                             tcp . 192.168.80.104 . 808 : jump k8s-nat-do-m=
ark-masq,
                             udp . 57.128.0.10 . 53 : jump k8s-nat-do-mark-=
masq,
                             udp . 57.141.53.140 . 809 : jump k8s-nat-do-ma=
rk-masq,
                             udp . 192.168.80.104 . 809 : jump k8s-nat-do-m=
ark-masq }
        }

        map cluster-ip {
                type inet_proto . ipv4_addr . inet_service : verdict
                elements =3D { tcp . 57.128.0.1 . 443 : jump k8s-nfproxy-svc-=
Z2V2H34MNX3I6O2G,
                             tcp . 57.128.0.10 . 53 : jump k8s-nfproxy-svc-=
BKEZZE5BBBAFLJMD,
                             tcp . 57.128.0.10 . 9153 : jump k8s-nfproxy-sv=
c-XZFCNG333PM4X5VI,
                             tcp . 57.139.80.125 . 8081 : jump k8s-nfproxy-=
svc-ALEQQYFAJOE576GL,
                             tcp . 57.141.10.218 . 443 : jump k8s-nfproxy-s=
vc-ZQKXCYOBISQCSH6Q,
                             tcp . 57.141.53.140 . 808 : jump k8s-nfproxy-s=
vc-M53CN2XYVUHRQ7UB,
                             udp . 57.128.0.10 . 53 : jump k8s-nfproxy-svc-=
MLOFX2HRWDMEIJ2C,
                             udp . 57.141.53.140 . 809 : jump k8s-nfproxy-s=
vc-PL4AZP3AKMRCVEEV }
        }

        map external-ip {
                type inet_proto . ipv4_addr . inet_service : verdict
                elements =3D { tcp . 192.168.80.104 . 808 : jump k8s-nfproxy-=
svc-M53CN2XYVUHRQ7UB,
                             udp . 192.168.80.104 . 809 : jump k8s-nfproxy-=
svc-PL4AZP3AKMRCVEEV }
        }

        map loadbalancer-ip {
                type inet_proto . ipv4_addr . inet_service : verdict
        }

        map nodeports {
                type inet_proto . inet_service : verdict
                elements =3D { tcp . 30283 : jump k8s-nfproxy-svc-ALEQQYFAJOE=
576GL }
        }

        chain filter-input {
                type filter hook input priority filter; policy accept;
                ct state new jump k8s-filter-services comment "	jump k8s-fi=
lter-firewall comment "}

        chain filter-output {
                type filter hook output priority filter; policy accept;
                ct state new jump k8s-filter-services
                jump k8s-filter-firewall comment "}

        chain filter-forward {
                type filter hook forward priority filter; policy accept;
                jump k8s-filter-forward
                ct state new jump k8s-filter-services comment "}

        chain k8s-filter-firewall {
                meta mark 0x00008000 drop
        }

        chain k8s-filter-services {
                ip protocol . ip daddr . @th,16,16 vmap @no-endpoints
        }

        chain k8s-filter-forward {
                ct state invalid drop
                meta mark 0x00004000 accept comment "	ip saddr 57.112.0.0/1=
2 ct state established,related accept
                ip daddr 57.112.0.0/12 ct state established,related accept
        }

        chain k8s-filter-do-reject {
                reject with icmp type host-unreachable
        }

        chain nat-preroutin {
                type nat hook prerouting priority filter; policy accept;
                jump k8s-nat-services
        }

        chain nat-output {
                type nat hook output priority filter; policy accept;
                jump k8s-nat-services
        }

        chain nat-postrouting {
                type nat hook postrouting priority filter; policy accept;
                jump k8s-nat-postrouting comment "}

        chain k8s-nat-mark-drop {
                meta mark set 0x00008000
        }

        chain k8s-nat-do-mark-masq {
                meta mark set 0x00004000 return
        }

        chain k8s-nat-mark-masq {
                ip protocol . ip daddr . @th,16,16 vmap @do-mark-masq
                return comment ""
        }

        chain k8s-nat-services {
                ip saddr !=3D 57.112.0.0/12 jump k8s-nat-mark-masq
                ip protocol . ip daddr . @th,16,16 vmap @cluster-ip comment=
 "	ip protocol . ip daddr . @th,16,16 vmap @external-ip
                ip protocol . ip daddr . @th,16,16 vmap @loadbalancer-ip
                fib daddr type local jump k8s-nat-nodeports comment "2"
        }

        chain k8s-nat-nodeports {
                ip protocol . @th,16,16 vmap @nodeports comment ""
        }

        chain k8s-nat-postrouting {
                meta mark 0x00004000 masquerade random,persistent comment "=
"
        }

        chain k8s-nfproxy-svc-Z2V2H34MNX3I6O2G {
                numgen inc mod 2 vmap { 0 : goto k8s-nfproxy-sep-WTQR35QT3M=
6PVG5X, 1 : goto k8s-nfproxy-sep-WTQR35QT3M6PVG5X }
                counter packets 1 bytes 60 comment ""
        }

        chain k8s-nfproxy-fw-Z2V2H34MNX3I6O2G {
        }

        chain k8s-nfproxy-xlb-Z2V2H34MNX3I6O2G {
        }

        chain k8s-nfproxy-sep-WTQR35QT3M6PVG5X {
                counter packets 3 bytes 180 comment ""
                ip saddr 192.168.80.104 meta mark set 0x00004000 comment ""
                dnat to 192.168.80.104:6443 fully-random
                counter packets 0 bytes 0
                ip saddr 192.168.80.104 meta mark set 0x00004000 comment ""
                dnat to 192.168.80.104:6443 fully-random comment ""
        }

        chain k8s-nfproxy-svc-M53CN2XYVUHRQ7UB {
                numgen inc mod 3 vmap { 0 : goto k8s-nfproxy-sep-TMVEFT7EX5=
5F4T62, 1 : goto k8s-nfproxy-sep-GTJ7BFLUOQRCGMD5, 2 : goto k8s-nfproxy-sep-=
23NTSA2UXPPQIPK4 }
                counter packets 4 bytes 240 comment ""
        }

        chain k8s-nfproxy-fw-M53CN2XYVUHRQ7UB {
        }

        chain k8s-nfproxy-xlb-M53CN2XYVUHRQ7UB {
        }

        chain k8s-nfproxy-svc-PL4AZP3AKMRCVEEV {
                numgen inc mod 2 vmap { 0 : goto k8s-nfproxy-sep-UOK7V3LF34=
NNNXJK, 1 : goto k8s-nfproxy-sep-AB4FZJCEEYJGUR7G }
                counter packets 0 bytes 0 comment ""
        }

        chain k8s-nfproxy-fw-PL4AZP3AKMRCVEEV {
        }

        chain k8s-nfproxy-xlb-PL4AZP3AKMRCVEEV {
        }

        chain k8s-nfproxy-sep-F3FYSUNEU5GRF2PR {
                counter packets 156 bytes 9360 comment ""
                ip saddr 57.112.0.39 meta mark set 0x00004000 comment ""
                dnat to 57.112.0.39:8081 fully-random
        }

        chain k8s-nfproxy-sep-TMVEFT7EX55F4T62 {
                counter packets 3 bytes 180 comment ""
                ip saddr 57.112.0.41 meta mark set 0x00004000 comment ""
                dnat to 57.112.0.41:8080 fully-random
        }

        chain k8s-nfproxy-sep-UOK7V3LF34NNNXJK {
                counter packets 0 bytes 0 comment ""
                ip saddr 57.112.0.41 meta mark set 0x00004000 comment ""
                dnat to 57.112.0.41:8090 fully-random
        }

        chain k8s-nfproxy-svc-ZQKXCYOBISQCSH6Q {
                numgen inc mod 1 vmap { 0 : goto k8s-nfproxy-sep-5CXJFIVYWU=
OH4QP5 } comment ""
                counter packets 0 bytes 0 comment ""
        }

        chain k8s-nfproxy-fw-ZQKXCYOBISQCSH6Q {
        }

        chain k8s-nfproxy-xlb-ZQKXCYOBISQCSH6Q {
        }

        chain k8s-nfproxy-sep-GTJ7BFLUOQRCGMD5 {
                counter packets 0 bytes 0 comment ""
                ip saddr 57.112.0.52 meta mark set 0x00004000 comment ""
                dnat to 57.112.0.52:8989 fully-random
        }

        chain k8s-nfproxy-svc-MLOFX2HRWDMEIJ2C {
                numgen inc mod 2 vmap { 0 : goto k8s-nfproxy-sep-ZLBUKWY4CZ=
E4VBQ6, 1 : goto k8s-nfproxy-sep-L7QM2ZN4KU2U3Y7S }
                counter packets 1597 bytes 126466 comment ""
        }

        chain k8s-nfproxy-fw-MLOFX2HRWDMEIJ2C {
        }

        chain k8s-nfproxy-xlb-MLOFX2HRWDMEIJ2C {
        }

        chain k8s-nfproxy-sep-AB4FZJCEEYJGUR7G {
                counter packets 0 bytes 0 comment ""
                ip saddr 57.112.0.52 meta mark set 0x00004000 comment ""
                dnat to 57.112.0.52:8998 fully-random
        }

        chain k8s-nfproxy-svc-BKEZZE5BBBAFLJMD {
                numgen inc mod 2 vmap { 0 : goto k8s-nfproxy-sep-47JQSZ5IZC=
6OSGGT, 1 : goto k8s-nfproxy-sep-SLRAZLUBLWQJXVD6 }
                counter packets 0 bytes 0 comment ""
        }

        chain k8s-nfproxy-fw-BKEZZE5BBBAFLJMD {
        }

        chain k8s-nfproxy-xlb-BKEZZE5BBBAFLJMD {
        }

        chain k8s-nfproxy-svc-XZFCNG333PM4X5VI {
                numgen inc mod 2 vmap { 0 : goto k8s-nfproxy-sep-MDXSOI4QEY=
HXQ5TE, 1 : goto k8s-nfproxy-sep-MQDIJAQHMGQYQDQC }
                counter packets 0 bytes 0 comment ""
        }

        chain k8s-nfproxy-fw-XZFCNG333PM4X5VI {
        }

        chain k8s-nfproxy-xlb-XZFCNG333PM4X5VI {
        }

        chain k8s-nfproxy-svc-ALEQQYFAJOE576GL {
                numgen inc mod 1 vmap { 0 : goto k8s-nfproxy-sep-F3FYSUNEU5=
GRF2PR } comment ""
                counter packets 0 bytes 0 comment ""
        }

        chain k8s-nfproxy-fw-ALEQQYFAJOE576GL {
        }

        chain k8s-nfproxy-xlb-ALEQQYFAJOE576GL {
        }

        chain k8s-nfproxy-sep-5CXJFIVYWUOH4QP5 {
                counter packets 1 bytes 60 comment ""
                ip saddr 57.112.0.47 meta mark set 0x00004000 comment ""
                dnat to 57.112.0.47:443 fully-random
        }

        chain k8s-nfproxy-sep-ZLBUKWY4CZE4VBQ6 {
                counter packets 1597 bytes 127401 comment ""
                ip saddr 57.112.0.42 meta mark set 0x00004000 comment ""
                dnat to 57.112.0.42:53 fully-random
        }

        chain k8s-nfproxy-sep-L7QM2ZN4KU2U3Y7S {
                counter packets 0 bytes 0 comment ""
                ip saddr 57.112.0.43 meta mark set 0x00004000 comment ""
                dnat to 57.112.0.43:53 fully-random
        }

        chain k8s-nfproxy-sep-47JQSZ5IZC6OSGGT {
                counter packets 0 bytes 0 comment ""
                ip saddr 57.112.0.42 meta mark set 0x00004000 comment ""
                dnat to 57.112.0.42:53 fully-random
        }

        chain k8s-nfproxy-sep-SLRAZLUBLWQJXVD6 {
                counter packets 0 bytes 0 comment ""
                ip saddr 57.112.0.43 meta mark set 0x00004000 comment ""
                dnat to 57.112.0.43:53 fully-random
        }

        chain k8s-nfproxy-sep-MDXSOI4QEYHXQ5TE {
                counter packets 0 bytes 0 comment ""
                ip saddr 57.112.0.42 meta mark set 0x00004000 comment ""
                dnat to 57.112.0.42:9153 fully-random
        }

        chain k8s-nfproxy-sep-MQDIJAQHMGQYQDQC {
                counter packets 0 bytes 0 comment ""
                ip saddr 57.112.0.43 meta mark set 0x00004000 comment ""
                dnat to 57.112.0.43:9153 fully-random
        }

        chain k8s-nfproxy-sep-23NTSA2UXPPQIPK4 {
                counter packets 0 bytes 0 comment ""
                ip saddr 57.112.0.53 meta mark set 0x00004000 comment ""
                dnat to 57.112.0.53:8787 fully-random
        }
}
table ip6 kube-nfproxy-v6 {
}
sbezverk@kube-4:~$=20






=EF=BB=BFOn 2020-01-20, 5:00 PM, "Florian Westphal" <fw@strlen.de> wrote:

    sbezverk <sbezverk@gmail.com> wrote:
    > Numgen has GOTO directive and not Jump (Phil asked to change it), I t=
hought it means after hitting any chains in numgen the processing will go ba=
ck to service chain, no?
    >=20
    > It is Ubuntu 18.04
    >=20
    > sbezverk@kube-4:~$ uname -a
    > Linux kube-4 5.4.10-050410-generic #202001091038 SMP Thu Jan 9 10:41:=
11 UTC 2020 x86_64 x86_64 x86_64 GNU/Linux
    > sbezverk@kube-4:~$ sudo nft --version
    > nftables v0.9.1 (Headless Horseman)
    > sbezverk@kube-4:~$
    >=20
    > I also want to remind you that I do NOT use nft cli to program rules,=
 I use nft cli just to see resulting rules.
   =20
    In that case, please include "nft --debug=3Dnetlink list ruleset".
   =20
    It would also be good to check if things work when you add it via nft
    tool.
   =20
    >     >=20
    >     >         chain k8s-nfproxy-svc-M53CN2XYVUHRQ7UB {
    >     >                 numgen inc mod 2 vmap { 0 : goto k8s-nfproxy-se=
p-TMVEFT7EX55F4T62, 1 : goto k8s-nfproxy-sep-GTJ7BFLUOQRCGMD5 }
    >     >                 counter packets 1 bytes 60 comment ""
    >     >         }
   =20
    Just to clarify, the "goto" means that the "counter" should NEVER
    increment here because nft interpreter returns to the chain that had
   =20
    "jump k8s-nfproxy-svc-M53CN2XYVUHRQ7UB".
   =20
    jump and goto do the same thing except that goto doesn't record the
    location/chain to return to.
   =20


