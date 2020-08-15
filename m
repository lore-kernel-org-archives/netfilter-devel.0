Return-Path: <SRS0=d1l0=BZ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79A34C433DF
	for <netfilter-devel@archiver.kernel.org>; Sat, 15 Aug 2020 21:59:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 507AA206B6
	for <netfilter-devel@archiver.kernel.org>; Sat, 15 Aug 2020 21:59:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IrRhsFF/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726602AbgHOV7O (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 15 Aug 2020 17:59:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728900AbgHOVvn (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 15 Aug 2020 17:51:43 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EECFC02B8E1
        for <netfilter-devel@vger.kernel.org>; Sat, 15 Aug 2020 04:38:03 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id p37so5765445pgl.3
        for <netfilter-devel@vger.kernel.org>; Sat, 15 Aug 2020 04:38:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=QFza27HlE2Fo6lDT7DKec0DmzTvgfr60QoBd9fZUbx0=;
        b=IrRhsFF/vfzELqdTxIg25ycQZEjWrMQ8fkNLq9GcOSJdBqR0EK2Fq6mSw3LIa3dwgv
         NXRwelbOThFJMybvof6rCN+6EaeOXrad5WY44hlxzJecCb1hQBpzqq+Z9SCJCZWgKpW2
         axeK6L9VE+Eftx0IkrjOQ5BDeZf4UF7L37VhYMpwf1Tt2ZSAkNR24bRRGHN9+VT+7Uz2
         Wxl/yj8DGMxpYIL/T80fWgWtUvdhBGPF/mWyGfkKl+Xp2Oh1l6D0bq5mQfUItMFt3KVb
         M0vUlG0izygGDFFw+m6vc7ozeuKyq8LKev+StJb/c8DOibqkzG5OJwI6KrZg6CU81ntR
         W/Bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=QFza27HlE2Fo6lDT7DKec0DmzTvgfr60QoBd9fZUbx0=;
        b=JlKU7HBUxTAhC1suEt5PXF4mMwK/1lMNOJj/GTD0xzbX/XWiCzKDpUkPDHCq73iKk6
         km3ftycCMujzVsemFXjKvCyEJ3T9gOgWdPmqSkXChphEICUnGt/A9QNHAcpaVGeJZjcX
         50Y4/7j1pDXceYF6ezjY8/9HcsZks/25E60JR1hfofGBbPW6+TamzstJVUsGYrOhfo8t
         tSseEMx0MpKuyjJiBqdsmXdm2MtXgM0b5blUzqlMIoTnPBEZ33Z+urSeFTr8Hz2U6MyF
         uRr9O6Q+/ijZaY2q7m3LikWhHaBl56p44wqqCYlj4xHZZWstCsUsWAEorN/Aqeaw7Glh
         BVbQ==
X-Gm-Message-State: AOAM53319Ew2abb78GnbYxxp5ZT7YTagsokRxsvsj4I/fySUMMMqgwxl
        2kPMkZkOHkDvc6jkgQmFJNc6o40fCDTi9vQYakyoU4Qx8cA6Lw==
X-Google-Smtp-Source: ABdhPJy4tAJLFsft3Z2t5a1ljARRSFP2JuZSzhBmoOlVbre+vI+bfgpAEBSWIU0Kne3iKnle74kI3LWDu6guLNQOQjw=
X-Received: by 2002:a65:610f:: with SMTP id z15mr4571720pgu.123.1597491481615;
 Sat, 15 Aug 2020 04:38:01 -0700 (PDT)
MIME-Version: 1.0
From:   Amiq Nahas <m992493@gmail.com>
Date:   Sat, 15 Aug 2020 17:07:50 +0530
Message-ID: <CAPicJaHOopep5rmgcq7VbDz6h66vd9Jsqp+yE1ukCyb8qZ+tPQ@mail.gmail.com>
Subject: iptables: undefined symbol xtables_fini
To:     netfilter-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

I am using Linux 5.6.0-rc7 on Ubuntu 18.04.

Built iptables by following instructions at
http://www.linuxfromscratch.org/blfs/view/svn/postlfs/iptables.html
Basically used these commands:

`./configure --prefix=/usr      \
            --sbindir=/sbin    \
            --disable-nftables \
            --enable-libipq    \
            --with-xtlibdir=/lib/xtables &&
make`

`make install &&
ln -sfv ../../sbin/xtables-legacy-multi /usr/bin/iptables-xml &&

for file in ip4tc ip6tc ipq xtables
do
  mv -v /usr/lib/lib${file}.so.* /lib &&
  ln -sfv ../../lib/$(readlink /usr/lib/lib${file}.so) /usr/lib/lib${file}.so
done`


Now I am trying to add a rule
`iptables -I FORWARD -m conntrack --ctorigsrc 172.5.1.123 --ctproto
tcp -j MARK --set-mark 123`

I get this error
`iptables: symbol lookup error: iptables: undefined symbol: xtables_fini`

What am I doing wrong?
