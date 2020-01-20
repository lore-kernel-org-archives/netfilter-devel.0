Return-Path: <SRS0=8tM5=3J=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=0.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MALFORMED_FREEMAIL,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7875C2D0DB
	for <netfilter-devel@archiver.kernel.org>; Mon, 20 Jan 2020 17:42:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8C74422525
	for <netfilter-devel@archiver.kernel.org>; Mon, 20 Jan 2020 17:42:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RGCb5Z3L"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726991AbgATRmO (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 20 Jan 2020 12:42:14 -0500
Received: from mail-qv1-f42.google.com ([209.85.219.42]:44603 "EHLO
        mail-qv1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726642AbgATRmO (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 20 Jan 2020 12:42:14 -0500
Received: by mail-qv1-f42.google.com with SMTP id n8so145032qvg.11
        for <netfilter-devel@vger.kernel.org>; Mon, 20 Jan 2020 09:42:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=user-agent:date:subject:from:to:cc:message-id:thread-topic
         :references:in-reply-to:mime-version:content-transfer-encoding;
        bh=HAql6hobgUhJHyJhua7V9NnokIMOp9hah2j9DjeDDOI=;
        b=RGCb5Z3LV5HAp1zDbGqjmBSDg46UR4EnIGafk8DrL4PJi87ptbgYYnRdaIzEwc+Ey7
         iAoxFGMWIj+wTifhklsqX9BibAFrYQD26lnP6Qy4zvMlvb74BS+ZsyHYYQhJmK0HBOnA
         FlTZoqOdcC0xfALE7Kn42IQGl/Wi0z0oxdiboTUNbp7j5gyQjxCwSgTTEYNrrD2GK0oy
         Ky6bMPQhgVZ9o7NP7BN9h7RuYNDqiX4sOlrSbuuZAP2MCsLsTF+guG5NmhYpNjFmlK3b
         QtXUpKlZhhcBZgulBRShCmWsZuudjHntoQz1r/QrT8G00LCHrMt6dZSDdmuyiXLjNlyl
         pzKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:user-agent:date:subject:from:to:cc:message-id
         :thread-topic:references:in-reply-to:mime-version
         :content-transfer-encoding;
        bh=HAql6hobgUhJHyJhua7V9NnokIMOp9hah2j9DjeDDOI=;
        b=kzCX39Kgq8meZUFr+cW1H39KZg08aKxdBJpBl48Ryo41iFaddl1ISBfxznFS7t/4/7
         VQo1QDqRApsopagkpy28Bj+En+62qceoIYwG4LKfYvwXWu2DGvzWRnLh7zu4jdG2qxuJ
         wPRysX8hMF4VoHGv2Hz+rsMEE+h3G6qdh6lkzqGuz7Thp6itWkuFccvrWF35DcKim7Uu
         P143Rz5njVbaD3EOt0FFTOEGV63aQCM0DVlP5ggF6Mye/fsiokTH/tTCFYP0krjvtoUO
         o0pBQxEx8kp99BW653Wc90M++F7tpOTbqBuH1rZVZe37sLvEqvHiwdhFxL+H9EsX58i+
         J1qg==
X-Gm-Message-State: APjAAAVya9xT2OoPX98p6gGEPBsvnI0UkJTkp6xja07jt8wqNdh8lbrb
        /AC541myAgMqcdfLBqr+LMLMpxWRNhYfpA==
X-Google-Smtp-Source: APXvYqx6NL9sx2XvTukoqm6yF18N6yz2hyQNsOcC3qNfEY3sKaS3+b6Ae0XdTgtCSFXP1rInh7mlQQ==
X-Received: by 2002:ad4:4e86:: with SMTP id dy6mr827964qvb.81.1579542133106;
        Mon, 20 Jan 2020 09:42:13 -0800 (PST)
Received: from [10.117.94.148] ([173.38.117.91])
        by smtp.gmail.com with ESMTPSA id r66sm16137212qkd.125.2020.01.20.09.42.12
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 20 Jan 2020 09:42:12 -0800 (PST)
User-Agent: Microsoft-MacOutlook/10.21.0.200113
Date:   Mon, 20 Jan 2020 12:42:11 -0500
Subject: Re: load balancing between two chains
From:   sbezverk <sbezverk@gmail.com>
To:     Florian Westphal <fw@strlen.de>
CC:     Phil Sutter <phil@nwl.cc>,
        "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
Message-ID: <A774A3A8-64EB-4897-8574-076CC326F020@gmail.com>
Thread-Topic: load balancing between two chains
References: <011F145A-C830-444E-A9AD-DB45178EBF78@gmail.com>
 <20200120112309.GG19873@orbyte.nwl.cc>
 <F6976F28-188D-4267-8B95-F4BF1EDD43F2@gmail.com>
 <20200120170656.GE795@breakpoint.cc>
In-Reply-To: <20200120170656.GE795@breakpoint.cc>
Mime-version: 1.0
Content-type: text/plain;
        charset="UTF-8"
Content-transfer-encoding: quoted-printable
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hello,

Changed kernel to 5.4.10, and switch to use "inc" instead of "random".  Now=
 first curl works and second fails. Whenever second chain is selected to be =
used,  curl connection gets stuck.=20

        chain k8s-nfproxy-svc-M53CN2XYVUHRQ7UB {
                numgen inc mod 2 vmap { 0 : goto k8s-nfproxy-sep-TMVEFT7EX5=
5F4T62, 1 : goto k8s-nfproxy-sep-GTJ7BFLUOQRCGMD5 }
                counter packets 1 bytes 60 comment ""
        }

        chain k8s-nfproxy-sep-TMVEFT7EX55F4T62 {
                counter packets 1 bytes 60 comment ""
                ip saddr 57.112.0.41 meta mark set 0x00004000 comment ""
                dnat to 57.112.0.41:8080 fully-random
        }

        chain k8s-nfproxy-sep-GTJ7BFLUOQRCGMD5 {
                counter packets 0 bytes 0 comment ""
                ip saddr 57.112.0.52 meta mark set 0x00004000 comment ""
                dnat to 57.112.0.52:8989 fully-random
        }

Any debug I could enable to see where the packet goes?

Thank you
Serguei
=EF=BB=BFOn 2020-01-20, 12:06 PM, "Florian Westphal" <fw@strlen.de> wrote:

    sbezverk <sbezverk@gmail.com> wrote:
    > HI Phil,
    >=20
    > There is no loadblancer, curl is executed from the actual node with b=
oth pods, so all traffic is local to the node.
    >=20
    > As per your suggestion I modified nfproxy rules:
    >=20
    >         chain k8s-nfproxy-svc-M53CN2XYVUHRQ7UB {
    >                 numgen random mod 2 vmap { 0 : goto k8s-nfproxy-sep-I=
7XZOUOVPIQW4IXA, 1 : goto k8s-nfproxy-sep-ZNSGEJWUBCC5QYMQ }
    >                 counter packets 3 bytes 180 comment ""
    >         }
    >=20
    >         chain k8s-nfproxy-sep-ZNSGEJWUBCC5QYMQ {
    >                 counter packets 0 bytes 0 comment ""
    >                 ip saddr 57.112.0.38 meta mark set 0x00004000 comment=
 ""
    >                 dnat to 57.112.0.38:8080 fully-random
    >         }
    >=20
    >         chain k8s-nfproxy-sep-I7XZOUOVPIQW4IXA {
    >                 counter packets 1 bytes 60 comment ""
    >                 ip saddr 57.112.0.36 meta mark set 0x00004000 comment=
 ""
    >                 dnat to 57.112.0.36:8989 fully-random
    >         }
   =20
    Weird, it looks like it generates 0 and something else, not 1.
   =20
    Works for me on x86_64 with 5.4.10 kernel:
   =20
    table ip test {
            chain output {
                    type filter hook output priority filter; policy accept;
                    jump k8s-nfproxy-svc-M53CN2XYVUHRQ7UB
            }
   =20
            chain k8s-nfproxy-svc-M53CN2XYVUHRQ7UB {
                    numgen random mod 2 vmap { 0 : goto k8s-nfproxy-sep-I7X=
ZOUOVPIQW4IXA, 1 : goto k8s-nfproxy-sep-ZNSGEJWUBCC5QYMQ }
                    counter packets 0 bytes 0
            }
   =20
            chain k8s-nfproxy-sep-ZNSGEJWUBCC5QYMQ {
                    counter packets 68602 bytes 5763399
                    ip saddr 57.112.0.38 meta mark set 0x00004000 comment "=
"
            }
   =20
            chain k8s-nfproxy-sep-I7XZOUOVPIQW4IXA {
                    counter packets 69159 bytes 5809685
                    ip saddr 57.112.0.36 meta mark set 0x00004000 comment "=
"
            }
    }
   =20
    (I removed nat rules and then ran ping -f 127.0.0.1).
   =20
    Does it work when you use "numgen inc" instead of "numgen rand" ?
   =20


