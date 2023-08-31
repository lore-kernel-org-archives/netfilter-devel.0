Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E02ECC83F17
	for <netfilter-devel@archiver.kernel.org>; Thu, 31 Aug 2023 09:14:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231625AbjHaJO1 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 31 Aug 2023 05:14:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231279AbjHaJO0 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 31 Aug 2023 05:14:26 -0400
Received: from mail-ua1-x934.google.com (mail-ua1-x934.google.com [IPv6:2607:f8b0:4864:20::934])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1189ACDD
        for <netfilter-devel@vger.kernel.org>; Thu, 31 Aug 2023 02:14:24 -0700 (PDT)
Received: by mail-ua1-x934.google.com with SMTP id a1e0cc1a2514c-7a25071d633so298046241.0
        for <netfilter-devel@vger.kernel.org>; Thu, 31 Aug 2023 02:14:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1693473263; x=1694078063; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=B0TMNVzlm83qXnlCr2raFC7vXLgMj6Ub4SEW/YgSxPo=;
        b=WuC8g+nsKHA7HqyZsVyYSxT7xPXCgLVVCFkzTghMBaKcAJigiQy3TWfZpVIsGxGcMm
         UJNnstwJll95xDuCmh1/cGeNiHtM87yy6zwaw0FOdLHeumn7NuN6ZMQX0LqjoefXhO4i
         v2JcVfUCzdlkiK5hbk4OZDiaRJgK3KWDUPtkgsj2Kt/LbZC9ee1skb5XwlVO9/ZR+Us2
         l7HYCOO4rTkuROfzriMegOnfanLBeSPq1H9vGilb/sSomOtm75EBT3+BHh7aOo+lhtcm
         uIYklafiQX1ybL++NvwiBYQ+PC/YB3TXjBNAvSrR6Zv4JLFcAYkAyzZ45uJ692Vgt8yW
         shpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693473263; x=1694078063;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=B0TMNVzlm83qXnlCr2raFC7vXLgMj6Ub4SEW/YgSxPo=;
        b=cTIWeCEUYay60k0YDywolxung1e+NNrqUSIo7wRtPuNpAW7WwyxOz7j8lpte8TGZGk
         jGQ6Tdbm9yMjLmVwCGSgLgzxITetLyhSCUWGyZ7xDXC7Dvc5liIdWT3gwXORafR9tbGY
         se0ekd0Muk8/LfNknOWGXDcknK8a0fBjv+YE5/kh3GYCjHrAE0r142NZ68PERG1ImG5b
         imUy1eyty6A6NwTNp6loXD5mx1IQUzLCWPBGyt5tQ+ZoxWSmAaZ3SLmyuyqxEGzKXi5V
         sff9SzDe5Zl8H7CDRXxIlvssDYJlogTXUOExIjew+Xh1luRP5Xep2S3eWfodCdzbw9bk
         1Thg==
X-Gm-Message-State: AOJu0YwCVbpbi6zHxbdS54wCnfVNY+WO+IfWcEmMPznA3Whs+1SBPd1r
        r+RNUwz9EpM086No0UlXyR9aWu8mo4s55U90sRIgMOSZojE=
X-Google-Smtp-Source: AGHT+IHbf3YcxCcalCUSViJksJy/CGtFWH3nNgbsCyTGvQ+jWOdrq3Q300cS+9dr4gei8dyz6RtVRIQ2SJ/+d8eVTT0=
X-Received: by 2002:a67:cf03:0:b0:44e:9614:39bf with SMTP id
 y3-20020a67cf03000000b0044e961439bfmr5284989vsl.6.1693473262854; Thu, 31 Aug
 2023 02:14:22 -0700 (PDT)
MIME-Version: 1.0
From:   Ian Kumlien <ian.kumlien@gmail.com>
Date:   Thu, 31 Aug 2023 11:14:11 +0200
Message-ID: <CAA85sZsLFsThq4jz1gx0UZj5ab+6SUbhPxy+gsM1d7o2S49LdA@mail.gmail.com>
Subject: MASQ leak?
To:     netfilter-devel@vger.kernel.org
Cc:     coreteam@netfilter.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

I was debugging what I thought was a vlan leak and a broken configuration.. or
at worst broken firmware, since I had bought new switches and wasn't completely
comfortable with them yet.

Anyway, it turns out that netfilter masq can leak internal information.

I thought most things would be caught by this:
table ip nat {
...
        chain postrouting {
                type nat hook postrouting priority 100
                oifname $ext_interface masquerade
---

But my machine was still sending unmasquraded data.

It was fixed by doing:
table inet filter {
...
       chain forward {
               type filter hook forward priority 0
                ct state invalid counter drop # <- this one
----

It just seems odd to me that traffic can go through without being NAT:ed

I only discovered this since one device managed to NAK alot of DHCP
packets and eventually
i was disconnected from my ISP (so switches are still suspect, and
will be inspected further when they are reconnected again)

And since i thought it was quite bad to just drop internal traffic
that tries to get somewhere i was looking
 to see if i could do a ttl exceeded or so response to make it retry -
best i could do was:
ct state invalid counter reject with icmp type port-unreachable

Which could be further enhanced by iifname <int interface> as a prefix
