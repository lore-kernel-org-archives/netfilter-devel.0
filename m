Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1414DC433C1
	for <netfilter-devel@archiver.kernel.org>; Mon, 29 Mar 2021 00:51:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DCF5B61941
	for <netfilter-devel@archiver.kernel.org>; Mon, 29 Mar 2021 00:51:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231655AbhC2AvR (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 28 Mar 2021 20:51:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229873AbhC2Au6 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 28 Mar 2021 20:50:58 -0400
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BFF4C061574
        for <netfilter-devel@vger.kernel.org>; Sun, 28 Mar 2021 17:50:57 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id hq27so16801170ejc.9
        for <netfilter-devel@vger.kernel.org>; Sun, 28 Mar 2021 17:50:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=30hFefP4ZO3Nkr29x6IoXC7oVy/hkWSV5Sy2cpozq2o=;
        b=IN9c0bwKYu7WHm08RU2hXvRkJ/DfU1jsPofy54Fcf5MqkKU4M4/zuXrJ74WhTw/oc3
         Qn5gL2Pqce1lQX9GzI2fkvvBsraDayLX1V5Uq6rlYkWPvqtXpTHrEGNVvOhyFjVeG7uK
         s+gaEa+LrZFYqvHQhzYnfqYCrTnphcqt2pVup20vGGEGbZGkkCQIX57OmG3ALy9P940c
         PZbB4lIINkmfSj0ffEv/BLIhTgYN+Mj7oVZsfVb/CBGwdAUfsJt6D+HqlpR/UD/S/KqL
         Lc4Lf/0yjyZIBWuUC2YKbfp74Bmy4TWB7qiSMbhl976eoNSQCgRZSGKbGEKCw+jxPngo
         Ab/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=30hFefP4ZO3Nkr29x6IoXC7oVy/hkWSV5Sy2cpozq2o=;
        b=XrWf1rVELTu88ED15hyNgF6r3S3rVx2Q0dJiAHhm1GmcQ5YBnOKefeII+PhzDHTHCA
         jr7w7836wwcf0g/Dx8aC5a9g/ptude/lACWND0c/ow8X5Udvn88nwZiOFIxdYRHdo7zy
         kiVQQL+GHTtq3lEbAuFJw1Xpk5JmZDbgWEa79q5Sf1V9++x5due3GdOlVrSQy/O3uTxo
         pIGGstJbON2RggOJvHaw8VGmWp0oeDpvAtNYJNXI97pxka6fAwuSPiU9rQ/s0UrXvCUp
         3V6IKr0HvlMWg3Lg5DTfp2qnjfYR/Dibk9C0j5CO7KCz35EAe7pOU8VroUJuuTUJncCd
         DV3Q==
X-Gm-Message-State: AOAM531dmJPtO0eHO1YRCauJh9+u87p//orq+SXQy6lBslYsnRiImDdp
        9NOoTTeTrLwqXJLG48zGzoOQJ0+MPXhJi7V53sCH
X-Google-Smtp-Source: ABdhPJymzHFuTcp5RmAop4j8vr4nvsReBMBhbfDdtl2mYkWAszWg3rggapnjcBBz8387TSOrzu38UIz933tpKAZEQSs=
X-Received: by 2002:a17:906:b846:: with SMTP id ga6mr25901053ejb.542.1616979056270;
 Sun, 28 Mar 2021 17:50:56 -0700 (PDT)
MIME-Version: 1.0
References: <28de34275f58b45fd4626a92ccae96b6d2b4e287.1616702731.git.rgb@redhat.com>
In-Reply-To: <28de34275f58b45fd4626a92ccae96b6d2b4e287.1616702731.git.rgb@redhat.com>
From:   Paul Moore <paul@paul-moore.com>
Date:   Sun, 28 Mar 2021 20:50:45 -0400
Message-ID: <CAHC9VhRo62vCJL0d_YiKC-Mq9S3P5rNN3yoiF+NBu7oeeeU9rw@mail.gmail.com>
Subject: Re: [PATCH v5] audit: log nftables configuration change events once
 per table
To:     Richard Guy Briggs <rgb@redhat.com>
Cc:     Linux-Audit Mailing List <linux-audit@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        netfilter-devel@vger.kernel.org,
        Eric Paris <eparis@parisplace.org>,
        Steve Grubb <sgrubb@redhat.com>,
        Florian Westphal <fw@strlen.de>, Phil Sutter <phil@nwl.cc>,
        twoerner@redhat.com, tgraf@infradead.org, dan.carpenter@oracle.com,
        Jones Desougi <jones.desougi+netfilter@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, Mar 26, 2021 at 1:39 PM Richard Guy Briggs <rgb@redhat.com> wrote:
>
> Reduce logging of nftables events to a level similar to iptables.
> Restore the table field to list the table, adding the generation.
>
> Indicate the op as the most significant operation in the event.
>
> A couple of sample events:
>
> type=PROCTITLE msg=audit(2021-03-18 09:30:49.801:143) : proctitle=/usr/bin/python3 -s /usr/sbin/firewalld --nofork --nopid
> type=SYSCALL msg=audit(2021-03-18 09:30:49.801:143) : arch=x86_64 syscall=sendmsg success=yes exit=172 a0=0x6 a1=0x7ffdcfcbe650 a2=0x0 a3=0x7ffdcfcbd52c items=0 ppid=1 pid=367 auid=unset uid=root gid=root euid=root suid=root fsuid=root egid=roo
> t sgid=root fsgid=root tty=(none) ses=unset comm=firewalld exe=/usr/bin/python3.9 subj=system_u:system_r:firewalld_t:s0 key=(null)
> type=NETFILTER_CFG msg=audit(2021-03-18 09:30:49.801:143) : table=firewalld:2 family=ipv6 entries=1 op=nft_register_table pid=367 subj=system_u:system_r:firewalld_t:s0 comm=firewalld
> type=NETFILTER_CFG msg=audit(2021-03-18 09:30:49.801:143) : table=firewalld:2 family=ipv4 entries=1 op=nft_register_table pid=367 subj=system_u:system_r:firewalld_t:s0 comm=firewalld
> type=NETFILTER_CFG msg=audit(2021-03-18 09:30:49.801:143) : table=firewalld:2 family=inet entries=1 op=nft_register_table pid=367 subj=system_u:system_r:firewalld_t:s0 comm=firewalld
>
> type=PROCTITLE msg=audit(2021-03-18 09:30:49.839:144) : proctitle=/usr/bin/python3 -s /usr/sbin/firewalld --nofork --nopid
> type=SYSCALL msg=audit(2021-03-18 09:30:49.839:144) : arch=x86_64 syscall=sendmsg success=yes exit=22792 a0=0x6 a1=0x7ffdcfcbe650 a2=0x0 a3=0x7ffdcfcbd52c items=0 ppid=1 pid=367 auid=unset uid=root gid=root euid=root suid=root fsuid=root egid=r
> oot sgid=root fsgid=root tty=(none) ses=unset comm=firewalld exe=/usr/bin/python3.9 subj=system_u:system_r:firewalld_t:s0 key=(null)
> type=NETFILTER_CFG msg=audit(2021-03-18 09:30:49.839:144) : table=firewalld:3 family=ipv6 entries=30 op=nft_register_chain pid=367 subj=system_u:system_r:firewalld_t:s0 comm=firewalld
> type=NETFILTER_CFG msg=audit(2021-03-18 09:30:49.839:144) : table=firewalld:3 family=ipv4 entries=30 op=nft_register_chain pid=367 subj=system_u:system_r:firewalld_t:s0 comm=firewalld
> type=NETFILTER_CFG msg=audit(2021-03-18 09:30:49.839:144) : table=firewalld:3 family=inet entries=165 op=nft_register_chain pid=367 subj=system_u:system_r:firewalld_t:s0 comm=firewalld
>
> The issue was originally documented in
> https://github.com/linux-audit/audit-kernel/issues/124
>
> Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
> ---
> Changelog:
> v5:
> (sorry for all the noise...)
> - fix kbuild missing prototype warning in nf_tables_commit_audit_{alloc,collect,log}() <lkp@intel.com>
>
> v4:
> - move nf_tables_commit_audit_log() before nf_tables_commit_release() [fw]
> - move nft2audit_op[] from audit.h to nf_tables_api.c
>
> v3:
> - fix function braces, reduce parameter scope [pna]
> - pre-allocate nft_audit_data per table in step 1, bail on ENOMEM [pna]
>
> v2:
> - convert NFT ops to array indicies in nft2audit_op[] [ps]
> - use linux lists [pna]
> - use functions for each of collection and logging of audit data [pna]
> ---
>  net/netfilter/nf_tables_api.c | 187 +++++++++++++++++++---------------
>  1 file changed, 104 insertions(+), 83 deletions(-)

Netfilter folks, were you planning to pull this via your tree/netdev
or would you like me to merge this via the audit tree?  If the latter,
I would appreciate it if I could get an ACK from one of you; if the
former, my ACK is below.

Acked-by: Paul Moore <paul@paul-moore.com>

-- 
paul moore
www.paul-moore.com
