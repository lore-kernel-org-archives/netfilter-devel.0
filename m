Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.2 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_IN_DEF_DKIM_WL
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E032C43461
	for <netfilter-devel@archiver.kernel.org>; Tue, 13 Apr 2021 17:22:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4F2CE613B1
	for <netfilter-devel@archiver.kernel.org>; Tue, 13 Apr 2021 17:22:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347145AbhDMRW3 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 13 Apr 2021 13:22:29 -0400
Received: from mail-qk1-f175.google.com ([209.85.222.175]:37678 "EHLO
        mail-qk1-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347140AbhDMRW2 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 13 Apr 2021 13:22:28 -0400
Received: by mail-qk1-f175.google.com with SMTP id 130so4419647qkm.4
        for <netfilter-devel@vger.kernel.org>; Tue, 13 Apr 2021 10:22:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=wI/+rBX/o3gQX8aK29t+8LwdIgeCADt3sq9jxR4OClw=;
        b=Euze0Rhb4eDKc/5PfqRI4ogHfbAKtUhknYBijKfYV6DqoytRP03mRWxrQOavsxux45
         teM04XL+atDreXk4G0QQBNhjDHsgHKsOCLkLqWQdxMzdmWBOcfN1cdhX6zaWAuj/L96u
         eXngGpW0aKNbTqLVxqjHTaqj4t5Ir+aSRwAexiVOge/JYlV0QcXnbN7x19tcfCDMtha0
         BmE7UUsrbjhhbBfat5Q2IUKe2Cbr9zOno1ngs5Ljrm0Af0yqLrcywkt5HXeaEULL7ttb
         IkEXCMuTP25S4OJCcfXgvnp6glYn+bDDrCSxpp1zt4HsaUNbpFy8AODL4KNnBEO6YAHi
         QVwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wI/+rBX/o3gQX8aK29t+8LwdIgeCADt3sq9jxR4OClw=;
        b=jTb98TsLVx42/ig2I5HSxHs+ujESAfu1RkiGNcMhXfWNv/GOz1M2mMCYSdP8h+QvEm
         0MHXgqB8NkSaIFtEqjWx1bs04pO0JyB8aWl/Rr2QgaXBPH+RYEtnshhRZVo6xgyNWq3o
         pzJyiN9Y4RZHs/dDF+S4kKqQDY4iucy7DpXudSJn0AP6Zl3T1Xu6+7c541lgHWB4Bguh
         oVXo7fOWffAU2KYQxp7Oe5BSIyC0MSu8jpd2IY9EW8V1/Zwbyzxm03xXZo4s+x4cIcty
         mYzWB5EBdz9Dl5ddXjzpDP1D7wmG9euI9wstDyR/H+74K5bhq6HrSc5LBje/RBRLl6XT
         Wt5w==
X-Gm-Message-State: AOAM532g/npTUXL/ffSR+oOvv+STUVvyRIWaaVW9CXJhxZWDsRYApfbP
        JZDC33Y+hCixpIjhf2EZHHPkYma9YtDOXL1Y0UI47g==
X-Google-Smtp-Source: ABdhPJxbrMdSh8La1h3woquZfue6Wq28zDi4SAsvfCQvM+Qp1voGLuv3L16pfp30x1Jwvdt1vUihBNaWUDibbqomwQI=
X-Received: by 2002:a05:620a:146e:: with SMTP id j14mr10089456qkl.424.1618334468448;
 Tue, 13 Apr 2021 10:21:08 -0700 (PDT)
MIME-Version: 1.0
References: <00000000000046e0e905afcff205@google.com> <0000000000002c193805bee0f97c@google.com>
In-Reply-To: <0000000000002c193805bee0f97c@google.com>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Tue, 13 Apr 2021 19:20:57 +0200
Message-ID: <CACT4Y+bEt4rPp-WdDe5gs89bNBjwMe0OSuwCyOT1eioKPjXYyA@mail.gmail.com>
Subject: Re: [syzbot] KASAN: vmalloc-out-of-bounds Read in bpf_trace_run2
To:     syzbot <syzbot+845923d2172947529b58@syzkaller.appspotmail.com>
Cc:     andrii@kernel.org, Andrii Nakryiko <andriin@fb.com>,
        Alexei Starovoitov <ast@kernel.org>, bpf <bpf@vger.kernel.org>,
        coreteam@netfilter.org, Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Patrick McHardy <kaber@trash.net>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Martin KaFai Lau <kafai@fb.com>,
        KP Singh <kpsingh@chromium.org>, kpsingh@kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        mchehab@s-opensource.com, Ingo Molnar <mingo@kernel.org>,
        Ingo Molnar <mingo@redhat.com>, mmullins@mmlx.us,
        netdev <netdev@vger.kernel.org>,
        NetFilter <netfilter-devel@vger.kernel.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Song Liu <songliubraving@fb.com>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>, yhs@fb.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Apr 1, 2021 at 5:39 AM syzbot
<syzbot+845923d2172947529b58@syzkaller.appspotmail.com> wrote:
>
> syzbot suspects this issue was fixed by commit:
>
> commit befe6d946551d65cddbd32b9cb0170b0249fd5ed
> Author: Steven Rostedt (VMware) <rostedt@goodmis.org>
> Date:   Wed Nov 18 14:34:05 2020 +0000
>
>     tracepoint: Do not fail unregistering a probe due to memory failure
>
> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=123358a1d00000
> start commit:   70b97111 bpf: Use hlist_add_head_rcu when linking to local..
> git tree:       bpf-next
> kernel config:  https://syzkaller.appspot.com/x/.config?x=7e0ca96a9b6ee858
> dashboard link: https://syzkaller.appspot.com/bug?extid=845923d2172947529b58
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=10193f3b900000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=168c729b900000
>
> If the result looks correct, please mark the issue as fixed by replying with:
>
> #syz fix: tracepoint: Do not fail unregistering a probe due to memory failure
>
> For information about bisection process see: https://goo.gl/tpsmEJ#bisection

Looks reasonable:

#syz fix:
tracepoint: Do not fail unregistering a probe due to memory failure
