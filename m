Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,FROM_LOCAL_HEX,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4BD1C4338F
	for <netfilter-devel@archiver.kernel.org>; Tue, 10 Aug 2021 03:18:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 70AB160FC3
	for <netfilter-devel@archiver.kernel.org>; Tue, 10 Aug 2021 03:18:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236540AbhHJDSn (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 9 Aug 2021 23:18:43 -0400
Received: from mail-il1-f199.google.com ([209.85.166.199]:47889 "EHLO
        mail-il1-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236536AbhHJDSa (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 9 Aug 2021 23:18:30 -0400
Received: by mail-il1-f199.google.com with SMTP id c7-20020a928e070000b0290222cccb8651so6776844ild.14
        for <netfilter-devel@vger.kernel.org>; Mon, 09 Aug 2021 20:18:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=5BRXu3w+C12fxdxN1C+eVxxxv4+y9P7u8pANMPW2JlA=;
        b=LVIdlissWsA7FGMclmX2sy23M2VJ46ng0q5Mfgo0jvVnqyF2lUeUyvLUFYY/62RZcy
         eHMzjtoKfUOyvAFulGEYjj8TtRPJc75VKT8ydHlb6IdPeXeDckVu/aQQ6x6Cd0dcnQbs
         lVfqSEvSogBO+McNmJlfKz4f154qE062rw523TeBWzrfyD35U7Ix8hoM7koJN+q+xzEZ
         78VgcOLtUxBTAdkERQnpsXKBSLdg7OoW5cqjY/cu+VWpX2p3xIccKgCyf+iHmWq8Xkrh
         4GTy2O7BzMcAVSjaGjV+VDH6mrIg3X5OftcLDLXM8qgGD+vEXnHVqNvd2OxygxvOR5S/
         Ek5g==
X-Gm-Message-State: AOAM530uEXFA78kkklJYNDJEL7SHDKNCQpojdAdTR3po8Kp/BsUTgg2S
        CHpz2rh+7+J+5gppMgkWxA74jEfa+sntWRM6nm5F3qaw/kHq
X-Google-Smtp-Source: ABdhPJzSejOHZF2vwRQa08jvFtWilpXHY4p8/eqRrMxxZV+P6Xpydk/aba2JEJl1ObwHXQ0rqs6Y+cSJYd76Qvyoc+6FLgQKYkyI
MIME-Version: 1.0
X-Received: by 2002:a6b:4015:: with SMTP id k21mr139228ioa.28.1628565488642;
 Mon, 09 Aug 2021 20:18:08 -0700 (PDT)
Date:   Mon, 09 Aug 2021 20:18:08 -0700
In-Reply-To: <2d002841-402c-2bc3-2b33-3e6d1cd14c23@gmail.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000071b06d05c92bf331@google.com>
Subject: Re: [syzbot] KASAN: use-after-free Write in nft_ct_tmpl_put_pcpu
From:   syzbot <syzbot+649e339fa6658ee623d3@syzkaller.appspotmail.com>
To:     coreteam@netfilter.org, davem@davemloft.net, fw@strlen.de,
        kadlec@netfilter.org, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, pablo@netfilter.org,
        paskripkin@gmail.com, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hello,

syzbot has tested the proposed patch and the reproducer did not trigger any issue:

Reported-and-tested-by: syzbot+649e339fa6658ee623d3@syzkaller.appspotmail.com

Tested on:

commit:         9a73fa37 Merge branch 'for-5.14-fixes' of git://git.ke..
git tree:       upstream
kernel config:  https://syzkaller.appspot.com/x/.config?x=e3a20bae04b96ccd
dashboard link: https://syzkaller.appspot.com/bug?extid=649e339fa6658ee623d3
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.1
patch:          https://syzkaller.appspot.com/x/patch.diff?x=12d6baf6300000

Note: testing is done by a robot and is best-effort only.
