Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25900C433F5
	for <netfilter-devel@archiver.kernel.org>; Thu, 12 May 2022 13:19:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353697AbiELNTu (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 12 May 2022 09:19:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354268AbiELNTu (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 12 May 2022 09:19:50 -0400
Received: from mail-oa1-x29.google.com (mail-oa1-x29.google.com [IPv6:2001:4860:4864:20::29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6136250EBC
        for <netfilter-devel@vger.kernel.org>; Thu, 12 May 2022 06:19:46 -0700 (PDT)
Received: by mail-oa1-x29.google.com with SMTP id 586e51a60fabf-ee1e7362caso6553204fac.10
        for <netfilter-devel@vger.kernel.org>; Thu, 12 May 2022 06:19:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=rnW1lNdXaHOrseNx+8VZQkCoh4hVp7eYD17JDIqBNtY=;
        b=oi7x1SH011n4JulssPJJ4GDfjqKYhSYQ0T1tiXB9tvhOy5Mdy+Z2PCzNAsF/7iEFCB
         ukYsBCXrB1SmnFjtouzUbdnGqEvBkCgNZ6K2pDdf9JUPG+14CPagbSXalfyEgPFuJ4Bq
         mXBGFNv1v8gnl+euHb+kBd3WEpGNNxHVvhWTyHlBXlUdlUsadWCM/Y6QowcbTg+Ijk7U
         rJVnJVj8st0ixwA+ZgS20uf/eDSDjA/9RKZXa8/aFYaMNnd/cdcNMU+eXVXdez2BFjaO
         adWE499AXKAD9+6tdp+EsvjFRq0Gtr3Ctt7xvI4uC8zJ9UXKQYgVs00vMMHTwynaf55c
         RNcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rnW1lNdXaHOrseNx+8VZQkCoh4hVp7eYD17JDIqBNtY=;
        b=W1NoKQ2Nkia7v5n+UoklqVbYedqex3cYkgDai0qUkn/JEBWZ6MM573+NMlr6h1e05y
         DbueVbWqSfFawDnVcpM+BSSRF5idESHAqnVprUr/fOxQN3qGfvzjDTbobOFA0vwfnQtq
         SJBmEGJ7dG7hdo/llXYZkjo/DphtZXSeO1en+hmGOE0jqAErcVeT9ggpkdUdEBZDq45u
         KFfLGcVB6tpMaaI96X/VogokGveCX9rz4ttDy5JVY/09QGcUppwod6TjoentBg8WxOCG
         F2izOloDloRW34Kahakgu5vJFYXLryvfQyrekMJpVUK0TTwFKJhqUb8vMSHHmYO4AG4/
         Aw5g==
X-Gm-Message-State: AOAM530ZjR3tIDoQy+bKmYg8nnkFkQeQ/Gw6YHO9RsAEccfUOUL+ycgr
        27FP+QWJzdWYCgQxi5RKwnFgejAWXbAMgRodIYrYzA==
X-Google-Smtp-Source: ABdhPJzJ9UCZzyIr9uCRxfqtNYldmP9u2JwxV1+G+hxFwMYyTA5WI0Koxn2yjLH38Pjz4Dugu1UDn8pxJ9yV+0b+L+A=
X-Received: by 2002:a05:6870:b61e:b0:ec:a426:bab5 with SMTP id
 cm30-20020a056870b61e00b000eca426bab5mr5478149oab.163.1652361585876; Thu, 12
 May 2022 06:19:45 -0700 (PDT)
MIME-Version: 1.0
References: <0000000000004c57c005b0fc4114@google.com> <000000000000b15b3505d7d9e8ca@google.com>
In-Reply-To: <000000000000b15b3505d7d9e8ca@google.com>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Thu, 12 May 2022 15:19:34 +0200
Message-ID: <CACT4Y+YOJU91CLaNhFosG7koHPpz8U38nurXyboXb_9gGw=Fgg@mail.gmail.com>
Subject: Re: [syzbot] INFO: task hung in usb_get_descriptor
To:     syzbot <syzbot+31ae6d17d115e980fd14@syzkaller.appspotmail.com>
Cc:     brouer@redhat.com, coreteam@netfilter.org, davem@davemloft.net,
        edumazet@google.com, eman.mohamed@rofaidarealestate.com,
        gregkh@linuxfoundation.org, gustavoars@kernel.org,
        hdanton@sina.com, ingrassia@epigenesys.com, johan@kernel.org,
        kaber@trash.net, kadlec@blackhole.kfki.hu,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        mathias.nyman@linux.intel.com, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, pablo@netfilter.org,
        skhan@linuxfoundation.org, stern@rowland.harvard.edu,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Sat, 12 Feb 2022 at 23:43, syzbot
<syzbot+31ae6d17d115e980fd14@syzkaller.appspotmail.com> wrote:
>
> syzbot suspects this issue was fixed by commit:
>
> commit 363eaa3a450abb4e63bd6e3ad79d1f7a0f717814
> Author: Shuah Khan <skhan@linuxfoundation.org>
> Date:   Tue Mar 30 01:36:51 2021 +0000
>
>     usbip: synchronize event handler with sysfs code paths
>
> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=1616e872700000
> start commit:   4fa56ad0d12e Merge tag 'for-linus' of git://git.kernel.org..
> git tree:       upstream
> kernel config:  https://syzkaller.appspot.com/x/.config?x=144ecdb0be3abc07
> dashboard link: https://syzkaller.appspot.com/bug?extid=31ae6d17d115e980fd14
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=12548d11d00000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=13ec77e9d00000
>
> If the result looks correct, please mark the issue as fixed by replying with:
>
> #syz fix: usbip: synchronize event handler with sysfs code paths

Based on subsystem and commit subject looks legit:

#syz fix: usbip: synchronize event handler with sysfs code paths
