Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B77FC433F5
	for <netfilter-devel@archiver.kernel.org>; Mon, 25 Oct 2021 07:42:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4584D6023B
	for <netfilter-devel@archiver.kernel.org>; Mon, 25 Oct 2021 07:42:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231801AbhJYHo3 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 25 Oct 2021 03:44:29 -0400
Received: from mail-il1-f199.google.com ([209.85.166.199]:52776 "EHLO
        mail-il1-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229521AbhJYHo3 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 25 Oct 2021 03:44:29 -0400
Received: by mail-il1-f199.google.com with SMTP id l14-20020a056e021c0e00b0025a176247ebso3042861ilh.19
        for <netfilter-devel@vger.kernel.org>; Mon, 25 Oct 2021 00:42:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=FRp5DFjNkB5DYili8ZiV7kEXz8tHdesF7it/j+y3PY0=;
        b=YcTDQKNnoXZqnseWbgNRHRwLgRIee0wDvHPw3HT2xwNfjh/efbK5O2sZjn9PqIt5vO
         4IOHU/w22BA6n+ubiJOs7SO7apjAzl3ALs2qWZAYTnuLZgwo12mOkiklrqDcoXntB75r
         16ayH6xiVSAK8RBO+3Mv60mLDltfDoGoLCajFzMmzgxe7GOFNyd+943PcTTf2ao2IdKV
         Nq9dKE6Rb7VKc45DOcaedy8JHvmwc9WUVcj9o8ykdMMyG3wksojKD4xNM9h1716fhtMN
         UGIo2ZD/xvMFsP1ATpRyMwHgMmMRBnxmwTL7bRUaJUWIW9chnBWSV4Gg1FJnE55yaLVV
         O2Zw==
X-Gm-Message-State: AOAM530d5vPXJdMnoot8OqHW8gBnsFjJPmL82eJJJQjLHeP6enlAGoQl
        6WZtj7EB772gM0EweSYwIfYDaeZeoDB7Ovmyn073Zy9QVsKe
X-Google-Smtp-Source: ABdhPJyY3BE6Hexn4GAHUITeNQNHgSQLr4zZ1XijU4QpLsYOvdQlTqckWVWab9qr7zgTSAsIBnAEP48S7JkF97KWJ3GsV36XpeUH
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1607:: with SMTP id t7mr9303589ilu.296.1635147727196;
 Mon, 25 Oct 2021 00:42:07 -0700 (PDT)
Date:   Mon, 25 Oct 2021 00:42:07 -0700
In-Reply-To: <000000000000d5efd605ccc6a5df@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000006f55c405cf287f25@google.com>
Subject: Re: [syzbot] general protection fault in nf_tables_dump_tables
From:   syzbot <syzbot+0e3358e5ebb1956c271d@syzkaller.appspotmail.com>
To:     coreteam@netfilter.org, davem@davemloft.net, fw@strlen.de,
        kadlec@netfilter.org, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, pablo@netfilter.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

syzbot suspects this issue was fixed by commit:

commit a499b03bf36b0c2e3b958a381d828678ab0ffc5e
Author: Florian Westphal <fw@strlen.de>
Date:   Mon Sep 13 12:42:33 2021 +0000

    netfilter: nf_tables: unlink table before deleting it

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=13efcb0cb00000
start commit:   9bc62afe03af Merge tag 'net-5.15-rc3' of git://git.kernel...
git tree:       net
kernel config:  https://syzkaller.appspot.com/x/.config?x=e917f3dfc452c977
dashboard link: https://syzkaller.appspot.com/bug?extid=0e3358e5ebb1956c271d
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=14374e5f300000

If the result looks correct, please mark the issue as fixed by replying with:

#syz fix: netfilter: nf_tables: unlink table before deleting it

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
