Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 124A7C4338F
	for <netfilter-devel@archiver.kernel.org>; Sat, 24 Jul 2021 15:53:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DAC7260E8E
	for <netfilter-devel@archiver.kernel.org>; Sat, 24 Jul 2021 15:53:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229982AbhGXPMz (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 24 Jul 2021 11:12:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229545AbhGXPMy (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 24 Jul 2021 11:12:54 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6968C061575
        for <netfilter-devel@vger.kernel.org>; Sat, 24 Jul 2021 08:53:25 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id r2so5646131wrl.1
        for <netfilter-devel@vger.kernel.org>; Sat, 24 Jul 2021 08:53:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=73dMHKgTwsbYJT/qumQlXzssv79wqGOcVEnbvWZ95Io=;
        b=nzNfOgKK/3FFKLaj0Nz9qxT5Ofgu2H00RBX07gUkBarDeq6c469dXZuNXO6K6G58yf
         8U2/+r0Ks7MjQ/2Ps9lC9mG30Ph+dB476w5G74DaoZdQznP4xWHFJkZMy6y3FCsBaNGY
         D3LuQSIj73BKRpzeiVWj5H8FJ06D8/Otiupj4/Q3LRnNxvnlI2Acelmfs65uR39qPO3b
         VRFG98n1ccNcq+GF1gzbcuVAZ4SmOcUAEvF9U4wKSJ/VRJIRAusNMyMKVFHOhTqUGeiJ
         rAlBwHKeSCCtKwx2CitalSY4lgHyYnYTk7FJSJ9tt8fiVH+615Qyn1onBwzozZnVctUF
         ZWtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=73dMHKgTwsbYJT/qumQlXzssv79wqGOcVEnbvWZ95Io=;
        b=D4M5HAPyZZGbiy6JY9yURbRIITFsDOsnChP9PUFv2YKWejUQeHqBlgqP1WRqkj/TIt
         NUtV7dUA5ld4bv9TlUCrtZWeTGKBSph6Jysi5nskfMPADoPBjNQeHARnZ8Kj1VVgSIA0
         uP7OmyxTWKjEJW8TrRdxeFRdxCyEmo8Xt3HV9B2zIz2eG9zZf/jLuO1Xh1RZ2wN/3kZt
         tgvj+QQwA301j7r47+Jq/BA9woj0J1T1sq/LM/OhvfO61ExSJLnA4zjsHN4Bw3NyNooL
         XXSvEXSPexBqryzF+2313nM/+A+iSb+9e6r0ZgV5CRunYTn9sBpI4wecZ9O1beQypKGc
         dJUw==
X-Gm-Message-State: AOAM533CBeKiBbD4clJP1PhiyyeYS+CGaKKPDyIU/wX4Wf/66SssxbvZ
        8z7C7Nw4alAkrP08tQMV5bShaiWip7vylwV+DOtJbR2W8LX8VQ==
X-Google-Smtp-Source: ABdhPJx8m34CVVuEqKClnuomAZvkyf58wd9A3jXcCv6rJuzvGz03FbXqvwylrH67gLqrL2KEqS/HzVclmzPKda3u9R8=
X-Received: by 2002:a5d:5305:: with SMTP id e5mr10570390wrv.237.1627142004136;
 Sat, 24 Jul 2021 08:53:24 -0700 (PDT)
MIME-Version: 1.0
From:   Akshat Kakkar <akshat.1984@gmail.com>
Date:   Sat, 24 Jul 2021 21:23:14 +0530
Message-ID: <CAA5aLPirA-gNiYRCoQR6-2fP80ESvvXKu7f0bVPT80FFxua6=g@mail.gmail.com>
Subject: Nf_nat_h323 module not working with Panasonic VCs
To:     NetFilter <netfilter-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

I have 2 vc endpoints VC1 (Make:Panasonic, IP:10.1.1.11),
VC2(make:Polycom,IP: 10.1.1.12) and 1 MCU (172.16.1.100).

There is a Linux firewall between VCs and MCU.

There is one to one nat configured for these 2 VCs (10.1.1.11  <-->
172.16.1.110, 10.1.1.12  <--> 172.16.1.120)
There is no natting for MCU IP as it is routable.

nf_nat_h323 and nf_conntrack_h323 module is enabled in the firewall.

When VC1 and VC2 initiate call to MCU, everything works fine. Video
call is successful for both VC1 and VC2. h245 IP address for tcp in
h225: CS connect packet is correctly replaced by the natted IP.

However, when there is a dial out from MCU to VCs (i.e. MCU initiate
call to the natted IP (i.e. 172.16.1.110 and 172.16.1.120 of VCs),
natting works fine but h245 IP address for tcp in h225:CS is replaced
correctly only for VC2 and not for VC1. For VC1, it is still its
actual IP (i.e. 10.1.1.12 and not 172.16.1.120).

Because of this, video call is successful only with VC2 and not with
VC1, when initiated from MCU. I tried with another panasonic VC
hardware, there was no change.

Further packet dump analysis showed that for VC1, there are 3 h225
packets (setup, call proceeding and alert) before Connect message but
for VC2 there are only 2 h225 packets (setup and alert) before connect
message.

Is there a bug in nf_nat_h323 module or am I missing something?
