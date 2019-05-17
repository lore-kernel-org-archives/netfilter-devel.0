Return-Path: <SRS0=W6An=TR=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27BF2C04AB4
	for <netfilter-devel@archiver.kernel.org>; Fri, 17 May 2019 16:27:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EDF7820848
	for <netfilter-devel@archiver.kernel.org>; Fri, 17 May 2019 16:27:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IP2S1uB6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726740AbfEQQ1u (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 17 May 2019 12:27:50 -0400
Received: from mail-qt1-f181.google.com ([209.85.160.181]:39246 "EHLO
        mail-qt1-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725932AbfEQQ1t (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 17 May 2019 12:27:49 -0400
Received: by mail-qt1-f181.google.com with SMTP id y42so8673936qtk.6
        for <netfilter-devel@vger.kernel.org>; Fri, 17 May 2019 09:27:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding:thread-index:content-language;
        bh=zoo8bdxxiR4uhQ0SYeat+XQ1mlyeBnQ1JF0QxGdc0gY=;
        b=IP2S1uB60VPDZ5PnNPeY3cjhYu8iDPzjtTqjEfD29Muk3xykaOMqkJO2smINQDRJby
         yra5XPxiNrEGIZ4xp3z8C8MMVuz8wVH5jKmtIrNYGgjEQxhpeUncC1nJtco7v5VygN77
         kV4/x9+p4dLZe2OR80jaWSMw8S4uLPtRTBMlR07q4UiqSlF9Hh2Oe0taFwWdKEcSKku2
         ES3PHLFGx3gukyejf320L+M7oahPHayQUdwPUDiOOraIG2cc1fubNtQeFPqT6sI4rvyG
         HgZ+BY37Lz5TOMnoQ/aK6+c4xbw3ROMt79nxZXYmIvFK8ZfKZ/ZyaxcvirTYkSk+3RSZ
         2big==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding:thread-index:content-language;
        bh=zoo8bdxxiR4uhQ0SYeat+XQ1mlyeBnQ1JF0QxGdc0gY=;
        b=Xwh8XO8OEed76Ewb5MI6JhIGX9yTciSdqQnZj3RWpfViuQWYakFhfTZaq/bKHjo0Qe
         cnaIhN5JuTv5t4kIrVX84LBaFcc4SI7SXmyQmIY6kri951XWvan7usElmxd3fIn3JJwx
         /tU0rYp+eQtdFiEPqjoLHyNkHvtEBWmRYiIoMfz5jGtmBwMxNRWJwYduMjoYOeGmzpKS
         c9xVcKGg97xZrV6utSYIdeVR/WYVDnQDpshWcfe/qnOqwTAmusvsBh61EATugzwC2Yc6
         spG0LTFJQwSI8k1ace41AcIAnMBg3jolzwiK7JK5N30GLHHOK9GJcaFbYYBS92o6816r
         KqSQ==
X-Gm-Message-State: APjAAAUE/AYMIRHqx3B2FSjJ6MdgyQaNGuJSN2rx+LGRS/X5K5bTM/NO
        OrJhgHLw6T2E46ifBpoi6anQymMI5dI=
X-Google-Smtp-Source: APXvYqzzChQrnlmBHPdoZKrMVo6EHOemzWbBjCvoPOrmGa7ghEnpf54Zdnz6rddLOJ552Pft4AMizg==
X-Received: by 2002:ac8:37d6:: with SMTP id e22mr50139231qtc.126.1558110467785;
        Fri, 17 May 2019 09:27:47 -0700 (PDT)
Received: from DESKTOPOQALEC1 (toroon0713w-lp140-04-69-158-19-160.dsl.bell.ca. [69.158.19.160])
        by smtp.gmail.com with ESMTPSA id i7sm2339249qtb.59.2019.05.17.09.27.46
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 17 May 2019 09:27:47 -0700 (PDT)
From:   <marcmicalizzi@gmail.com>
To:     <netfilter-devel@vger.kernel.org>
Subject: nftables flow offload possible mtu handling issue
Date:   Fri, 17 May 2019 12:27:48 -0400
Message-ID: <013801d50ccd$77ef0600$67cd1200$@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
        charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AdUMzXc+cXkhlKIlQMOy+U2VYw29xw==
Content-Language: en-ca
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

With flow offload between devices of differing mtus, there seems to be =
an
issue sending from through higher mtu to the lower mtu device.
I=92m currently on 4.20 from the linux-arm mcbin branch, as it=92s all I =
can get
running on my specific embedded platform.

In my case I have

table ip nat {
=A0=A0=A0=A0=A0=A0=A0 chain POSTROUTING {
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 type nat hook postrouting =
priority 100; policy accept;
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 oifname "ppp0" ip saddr =
192.168.10.0/24 snat to
xx.xxx.xx.xxx

=A0=A0=A0=A0=A0=A0=A0 }
}
table ip filter {
=A0=A0=A0=A0=A0=A0=A0 flowtable f1 {
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 hook ingress priority 0
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 devices =3D { eth0.1, ppp0 =
}
=A0=A0=A0=A0=A0=A0=A0 }

=A0=A0=A0=A0=A0=A0=A0 chain FORWARD {
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 type filter hook forward =
priority 0; policy accept;
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 ip protocol tcp flow =
offload @f1
=A0=A0=A0=A0=A0=A0=A0=A0=A0 =A0=A0=A0=A0=A0=A0counter
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 tcp flags syn tcp option =
maxseg size set rt mtu
=A0=A0=A0=A0=A0=A0=A0 }
}

ppp0 has an mtu of 1500.
Running a speedtest from a device connected to eth0.1, download seems to
always be fine, but if eth0.1 has an mtu higher than 1492, upload fails
completely most of the time. (Prior to flow offloading, eth0/eth0.1 has =
an
mtu of 9000, and this is the mtu I would prefer to have it running at.

An interesting observation, as well, is that with eth0.1 mtu at 9000, if
during the upload portion of a speed test I issue `ip link set ppp0 mtu
(1492/1500, whichever it currently is not)`, the upload will start =
working
for the remainder of the upload test.

This also manifests outside speedtest, but less predictably, with =
dropped
connections due to outgoing packet failures.

