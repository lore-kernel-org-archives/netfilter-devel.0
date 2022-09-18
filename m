Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DEF32C54EE9
	for <netfilter-devel@archiver.kernel.org>; Sun, 18 Sep 2022 10:50:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229557AbiIRKuh (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 18 Sep 2022 06:50:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229517AbiIRKug (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 18 Sep 2022 06:50:36 -0400
Received: from www262.sakura.ne.jp (www262.sakura.ne.jp [202.181.97.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E2ED1AD81
        for <netfilter-devel@vger.kernel.org>; Sun, 18 Sep 2022 03:50:35 -0700 (PDT)
Received: from fsav114.sakura.ne.jp (fsav114.sakura.ne.jp [27.133.134.241])
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTP id 28IAnvoJ031851;
        Sun, 18 Sep 2022 19:49:57 +0900 (JST)
        (envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Received: from www262.sakura.ne.jp (202.181.97.72)
 by fsav114.sakura.ne.jp (F-Secure/fsigk_smtp/550/fsav114.sakura.ne.jp);
 Sun, 18 Sep 2022 19:49:57 +0900 (JST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/fsav114.sakura.ne.jp)
Received: from [192.168.1.9] (M106072142033.v4.enabler.ne.jp [106.72.142.33])
        (authenticated bits=0)
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTPSA id 28IAnvGa031847
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NO);
        Sun, 18 Sep 2022 19:49:57 +0900 (JST)
        (envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Message-ID: <2bb83eba-df77-9b0d-24ba-a47d4c0483bc@I-love.SAKURA.ne.jp>
Date:   Sun, 18 Sep 2022 19:49:57 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 6.3; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [syzbot] WARNING: locking bug in tee_netdev_event
Content-Language: en-US
To:     syzbot <syzbot+68f4b631890adeb054ae@syzkaller.appspotmail.com>,
        syzkaller-bugs@googlegroups.com
References: <0000000000009f3f2505e8f01b7a@google.com>
Cc:     netdev@vger.kernel.org, netfilter-devel@vger.kernel.org
From:   Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
In-Reply-To: <0000000000009f3f2505e8f01b7a@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Unreasonable location. Presumably the same memory corruption.

#syz dup: BUG: unable to handle kernel paging request in kernfs_put_active

On 2022/09/18 18:20, syzbot wrote:
> DEBUG_LOCKS_WARN_ON(1)
> WARNING: CPU: 0 PID: 3067 at kernel/locking/lockdep.c:231 check_wait_context kernel/locking/lockdep.c:4727 [inline]
> WARNING: CPU: 0 PID: 3067 at kernel/locking/lockdep.c:231 __lock_acquire+0x2b0/0x30a4 kernel/locking/lockdep.c:5003

