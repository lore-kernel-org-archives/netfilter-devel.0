Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=BAYES_00,FROM_LOCAL_HEX,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9BF6C47083
	for <netfilter-devel@archiver.kernel.org>; Wed,  2 Jun 2021 11:18:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CF3C3613B1
	for <netfilter-devel@archiver.kernel.org>; Wed,  2 Jun 2021 11:18:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231329AbhFBLUQ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 2 Jun 2021 07:20:16 -0400
Received: from mail-il1-f198.google.com ([209.85.166.198]:42641 "EHLO
        mail-il1-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230131AbhFBLUQ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 2 Jun 2021 07:20:16 -0400
Received: by mail-il1-f198.google.com with SMTP id d17-20020a9236110000b02901cf25fcfdcdso1285533ila.9
        for <netfilter-devel@vger.kernel.org>; Wed, 02 Jun 2021 04:18:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to:cc;
        bh=fUuOkxrIdoQmAb56CsmjGA6rmm8IFaIzsgB206kzii4=;
        b=XY/cGtUBSGqnoC1+fePQ4wzmaPsFQa5hFyQY9ZlmpvLQWEOsnkTlOtOY/5dECCXm9D
         f4Ee4Qg8fCIx6VcOlGdvIvyPJFnzgh9QYYwNgSKvOeqWAQsDpJ3NKBV+h5bgf3QkPHOe
         54H4PDKoBcrjcJK22aUWghiBufjjeDLjjmd9CSyR4tn4VsuDhDtJVhUb93VNElyLlxGx
         BS/QLWtTA6KRC8VvuiEtcqOJyVXRqyQNvZE2L1iLCyX60N+PB52zLM4M5Be9J2K9oQSj
         zNdOnZVrosWu6aZwFbphYgyQVI4WQa9r1VI7EXC/9xk7ByPkcG+0+1yDLWbRWGqDw8X2
         EB+g==
X-Gm-Message-State: AOAM533cXXWqT/MFRbkAIDvwxISNjGxXV4KFO+kWs9e/dC/E+7y5cQLo
        LejO6my6XDj54CocaDIFRdmwtQhm2/DI2fwCQay1r8G6qBIT
X-Google-Smtp-Source: ABdhPJz7V5+svtllpxH9nzf4ovxVaVuS5+ylKIbKxC0l1D+WwRHYpJWQy/Nm9+9mMbCvDsJopVTIjAVhfqs6ZSYfC97n2tcnqNcJ
MIME-Version: 1.0
X-Received: by 2002:a92:c5ad:: with SMTP id r13mr14881585ilt.238.1622632713370;
 Wed, 02 Jun 2021 04:18:33 -0700 (PDT)
Date:   Wed, 02 Jun 2021 04:18:33 -0700
In-Reply-To: <YLdo77SkmGLgPUBi@casper.infradead.org>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000007b451b05c3c69e4d@google.com>
Subject: Re: [syzbot] WARNING in idr_get_next
From:   syzbot <syzbot+f7204dcf3df4bb4ce42c@syzkaller.appspotmail.com>
To:     Matthew Wilcox <willy@infradead.org>
Cc:     anmol.karan123@gmail.com, bjorn.andersson@linaro.org,
        coreteam@netfilter.org, davem@davemloft.net, dsahern@kernel.org,
        ebiggers@google.com, ebiggers@kernel.org, eric.dumazet@gmail.com,
        fw@strlen.de, kadlec@netfilter.org, kuba@kernel.org,
        linux-fsdevel@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        linux-kernel@vger.kernel.org, manivannan.sadhasivam@linaro.org,
        necip@google.com, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, pablo@netfilter.org,
        syzkaller-bugs@googlegroups.com, willy@infradead.org,
        yoshfuji@linux-ipv6.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

> #syz fixed qrtr: Convert qrtr_ports from IDR to XArray

unknown command "fixed"

>
> On Wed, Jun 02, 2021 at 03:30:06AM -0700, syzbot wrote:
>> syzbot suspects this issue was fixed by commit:
>> 
>> commit 43016d02cf6e46edfc4696452251d34bba0c0435
>> Author: Florian Westphal <fw@strlen.de>
>> Date:   Mon May 3 11:51:15 2021 +0000
>
> Your bisect went astray.
