Return-Path: <SRS0=bgPs=S7=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8873AC43219
	for <netfilter-devel@archiver.kernel.org>; Mon, 29 Apr 2019 01:30:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3CF3F20675
	for <netfilter-devel@archiver.kernel.org>; Mon, 29 Apr 2019 01:30:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BBwlR2Fk"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726764AbfD2BaY (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 28 Apr 2019 21:30:24 -0400
Received: from mail-ot1-f51.google.com ([209.85.210.51]:37266 "EHLO
        mail-ot1-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726681AbfD2BaY (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 28 Apr 2019 21:30:24 -0400
Received: by mail-ot1-f51.google.com with SMTP id r20so6124909otg.4
        for <netfilter-devel@vger.kernel.org>; Sun, 28 Apr 2019 18:30:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=KA4kQ1yNxYTd+A3wWslOopdNbOncTPtiPvVpUqG4PGA=;
        b=BBwlR2FkSLJAQw0o6nbWbrI0uG5f+ZoERFog6aqMjhMPV+qu7cbQ/Mi5Jlt1ssgfnm
         xyBfc04pVGyag0+hJdDcOL0OU3US9CA1b4DnM9GuChntbEQ7xWSup2Jo3iM1EfWIfTBU
         23n5QIbJMUFpLoq0f7InszZuJBTfrb5oE2y/2CLgBh/VqljMWlykJNVqkxSBG4cETSzw
         G7mdEw1wZwG3Ac10bWuD3ILJrSXSasDwLUgeYVuOAYu7LZef779i0muIHkrHaOFUMNU6
         T2TaJUnvscooAeVJlp+IQLBsi65NcWlzRSYxH9pU/JWj02tMUFbxvXJPDjRDB6isMHiH
         wjxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=KA4kQ1yNxYTd+A3wWslOopdNbOncTPtiPvVpUqG4PGA=;
        b=ZXdDkDOBuXZg8ochELkbvHEs0pExWacfMKUUQCZ8J0sm+ST3WeuczSKtS1fnP4rOh2
         MNswqmflDKORqUr17Q7KEzTVsRKernbM2o2wjQTtM1QHdUXxDqaf+KiWGsrl2QhfqYV5
         L9NGbVrPTtmPTnrN2/DwJk8ym0WtwtOO8EhoZ4015GUihpAc0URY8dxdA5TGzC92vI6o
         P9KlTsAhf8yarqoFiwk/nctvkhEkB9YK8MPgFKO3x4QE9N2ftQt3gUmfJUjJHdHCfx4G
         DBBaIkdZjcV/DhCLyhMFE+sIl4W33ZFgNW0pDPcI8T1rMHBdROhSAaKTZEaSzgJ0wYwC
         egZA==
X-Gm-Message-State: APjAAAXzy3I0tMc4IIx4FjgrQgSbAJdYj4ywH/6XQL62VKOdRU3lugJM
        a2fedns5xzEln0130Q0wwkroeNXomSxJl3tW+of9BdCBCPQ=
X-Google-Smtp-Source: APXvYqxe3p1jRlx2xU6hd/O169Rvjjehoj+ADWPxZR9Wl/qilemgXg83u40N/3/mNq886RrIlZQnkwhWYp1DStpAWbc=
X-Received: by 2002:a9d:58c5:: with SMTP id s5mr8536337oth.361.1556501423624;
 Sun, 28 Apr 2019 18:30:23 -0700 (PDT)
MIME-Version: 1.0
From:   Vijay Pasapuleti <vijaypas@gmail.com>
Date:   Sun, 28 Apr 2019 20:30:13 -0500
Message-ID: <CAC=w+U5PqMuz3nxdaWiTYwJf=Jfv6ErVEbYehXs2PDe+8A0-xg@mail.gmail.com>
Subject: Netlink socket protocol NETLINK_NFLOG
To:     netfilter-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Is there anyway of getting NETLINK_NFLOG protocol to work in the
4.1.16 kernel? Basically, I am wondering if there's a way to get ulogd
(the older version -- not ulogd2) to work on the above kernel. It
looks like net/netlink/af_netlink.c has support for NETLINK_NFLOG but
the socket call from ulogd fails with 'unsupported protocol'.

h->fd = socket(PF_NETLINK, SOCK_RAW, NETLINK_NFLOG);


is the call that fails in libipulog.c.

Thanks in advance!
