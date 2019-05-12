Return-Path: <SRS0=q8lh=TM=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7BCB0C04A6B
	for <netfilter-devel@archiver.kernel.org>; Sun, 12 May 2019 07:59:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 400852146F
	for <netfilter-devel@archiver.kernel.org>; Sun, 12 May 2019 07:59:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="At3I3J1c"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726232AbfELH7o (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 12 May 2019 03:59:44 -0400
Received: from mail-vk1-f171.google.com ([209.85.221.171]:46505 "EHLO
        mail-vk1-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726031AbfELH7o (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 12 May 2019 03:59:44 -0400
Received: by mail-vk1-f171.google.com with SMTP id d77so2535755vke.13
        for <netfilter-devel@vger.kernel.org>; Sun, 12 May 2019 00:59:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=/8pjnN6LiWkRa+erINUX3KnzN1Tza7wnAPjkgE1kC9Q=;
        b=At3I3J1cYCalXPhLXqPMmoLuBVNDEkD/6ENB0rtJzSJqBIOolKc/Cbzd1lRBxksJkJ
         GBSy5/wFT0pbX9EzwNcusGU1uKVfkxmc0Qv/fpn2QrYEf1NmgJukY8KAb5jET5sinPYi
         WKxDhl7yG6NiJzqI8fYiDpXhdHPriROGMg88N6F2kCkG3Ifi71iLXjIm4SuhXnyzujGF
         neGplXoSjSbntxSdQKGgiIQda1myyOu8ZYwsFbhGGxOaR0KxoRmYPs7n22l1YRblseWC
         8wcYp8Km4VLVAd96LVZMqyD2xL6PetkLpu+mWFoym6bZc/EHOMcVZABDcUt+2asWspg6
         RQvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=/8pjnN6LiWkRa+erINUX3KnzN1Tza7wnAPjkgE1kC9Q=;
        b=lk3zdseAjYGmp7gKWzXR2BmtINSRPTyqVtQPkLlMxlT3x3+8QaZ1QEPZ+2z01OzIC0
         cmW4xfVAlKd6x9AvSVERhKmx4wuaibJH5GP6Do0fMdlNPpMRd1/hOp2bJ9YfmNdRV/Pp
         JYicj6Zgi56EAiTedDvy89tCdAMk4tL0+VoL7dsIXDoDoqnrfQ/aVZ1+GmflVbVhHCpa
         F/FUKzJZTtjWzH7dZS8lJ03sKe5Wp8AfWbwz9Xm66y3v/e9XyzgYClEf85pg9ukBg/uU
         jh5fnefU/H0Fuisl/4fV+8jLmNPXg1O/LFVsNhWlA5/b30cSD6DhJ+IuXu9gT/26v7vm
         dM1g==
X-Gm-Message-State: APjAAAX9hGyyeYsyYnJrck39yaWONbGp1OJr6HKu+cmA0+zGU+Z3di7M
        9ANESmkyXe6VB/+vWPVjmqhhczSs2ehXEMGnxCsSoCP1
X-Google-Smtp-Source: APXvYqwKkLkiX2cY1ihnZ98MgOwtkj7r/Y4C0jGu2GkJt/+hqIxgSyQzayx5DY+3wr+JFyyjQtrVycSrRd+5ABsWC2U=
X-Received: by 2002:a1f:a54f:: with SMTP id o76mr8315100vke.86.1557647983113;
 Sun, 12 May 2019 00:59:43 -0700 (PDT)
MIME-Version: 1.0
From:   =?UTF-8?Q?St=C3=A9phane_Veyret?= <sveyret@gmail.com>
Date:   Sun, 12 May 2019 09:59:32 +0200
Message-ID: <CAFs+hh4ghFJqE=b+CXiVL9AguKr1MjZntuDvzYyqmDy5aGJPLw@mail.gmail.com>
Subject: Undefined reference?
To:     netfilter-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hello,

I am currently trying to add a new feature to nftables. I made
modifications on the kernel and updated a VM with this modified
kernel. I then made modifications on libnftnl, make && make install it
on this VM. I even made some tests which I managed to execute.

Now, I am trying to modify the nftables userspace tool. I had to set variab=
les:
LIBNFTNL_CFLAGS=3D"-g -O2"
LIBNFTNL_LIBS=3D$HOME/libnftnl/src/.libs/libnftnl.so ./configure
in order for configure to work, but it worked. But at linking time, I
get the following error for each nftnl_* function:
ld: ./.libs/libnftables.so: undefined reference to `nftnl_trace_free'

I tried to set the LD_LIBRARY_PATH to /usr/local/lib but it did not
change anything. Do you have an idea of what the problem is?

Regards,

St=C3=A9phane.
