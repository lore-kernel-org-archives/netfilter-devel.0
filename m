Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC243C48BDF
	for <netfilter-devel@archiver.kernel.org>; Sun, 20 Jun 2021 12:22:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A017A610CD
	for <netfilter-devel@archiver.kernel.org>; Sun, 20 Jun 2021 12:22:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229593AbhFTMY5 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 20 Jun 2021 08:24:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229591AbhFTMY5 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 20 Jun 2021 08:24:57 -0400
Received: from mail-lj1-x233.google.com (mail-lj1-x233.google.com [IPv6:2a00:1450:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AEC1C061574
        for <netfilter-devel@vger.kernel.org>; Sun, 20 Jun 2021 05:22:44 -0700 (PDT)
Received: by mail-lj1-x233.google.com with SMTP id a21so16022087ljj.1
        for <netfilter-devel@vger.kernel.org>; Sun, 20 Jun 2021 05:22:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=8J2fW15A5DViXf1jLAsw6iBiwaWd/jZj6otzgwLqcz0=;
        b=AOUd8QPFBKd+Mjy3prXwaV/Z/YMIdlCaaWWRYC/on88n6IY3aGQwfdCy2++ePK08UP
         bgVBMuuKg22AJa86yGQ+W2IKruoVcn2SrO3UwyNHbVCzUZUXilDojlv7QyQIVF8+L6J1
         wIh+cfWhm8ZYnR7IFagCWhTv1YmHo2zKoZwuYewD4HRwaijQ8NjEIOsC66cacH/rmNe5
         CnL2G7+/ENP/Gq2u6J2ZnTkBkCmrodH4FIj4psxAtXhH6sfyYPai/XmzjD+/DswHN8mf
         ZeWTUzeMXPHawn8b9BjjhuvI5Nv24OZK/UdYjMDfe+KIaDN3/njYbqZMLdNtJ79Kgpvo
         ANlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=8J2fW15A5DViXf1jLAsw6iBiwaWd/jZj6otzgwLqcz0=;
        b=Dy3r3QRaELiVAkDzPRczwGvu4geSlvt+SOpmKNChXH6jmIxatJh2OZBKnifJowj5km
         wMVBjouwrT0ldkZhmzOMKDT2mm9sK2oqxBuZmFvHoPAyaM+NQ9GFvHnqoQdH63gSx4wX
         gEKhK94N+UgSZz1PlzjwOsKabpOx+8EexBpgn8uSvw06VbCYQH1WoBkbBdJR/bIjcy/o
         6CGxer9JwG/TxXpt0JJ2RARXm4rBYS6aHthNI6Pls6Ti5DnexhHuMF4uOcMz9xJTxvos
         M226NRVAa/YzRg8ce27xRKZDx+mQEfnJU24s8jT5T5nvLR+xJG81zSizAy4t6pYCPMuK
         KtnQ==
X-Gm-Message-State: AOAM533HqyT+FI4t2rzIcqgCpoN5E4CVioe037J+bMLUUNDswYMP0mOB
        vk8dXiN/IgKHWeS1nbtdhgWI7YI/bN+Z1O0lOsrlOWsmZSo=
X-Google-Smtp-Source: ABdhPJzk6oKVQRdHqxaaKM1gtzd1ZSZtpGt70fhU2KAwrq1tV9/em70gevIDq9K8AMTHGPj0PLqlMRmFisIX7Z466do=
X-Received: by 2002:a2e:a317:: with SMTP id l23mr17307415lje.117.1624191762933;
 Sun, 20 Jun 2021 05:22:42 -0700 (PDT)
MIME-Version: 1.0
From:   Pascal Dupuis <cdemills@gmail.com>
Date:   Sun, 20 Jun 2021 14:22:32 +0200
Message-ID: <CAPo1VG=UuHtCpLZnQ=-kbeTuXz2Xv_-WZ-xfPGB7qjpaFeia1g@mail.gmail.com>
Subject: can't compile with CLANG + ThinLTO
To:     netfilter-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hello,
since kernel 5.12, I compile kernel and xtables-addons-kmod with CLANG using:

1) extract the kernel source, and get the config included in
https://elrepo.org/linux/kernel/el8/SRPMS/kernel-ml-5.12.12-1.el8.elrepo.nosrc.rpm
2) inside the kernel source, execute
env LC_ALL=C TMPDIR=/var/tmp MAKEFLAGS="LLVM=1 " make oldconfig
explanation: this uses CLANG as compiler, but LTO is not enabled.
3) substitute the new .config to the one from elrepo
4) compile the kernel with
 env LC_ALL=C TMPDIR=/var/tmp MAKEFLAGS="LLVM=1" nice -n 20 rpmbuild
--noclean --nocheck --nodebuginfo --without bpftool --without perf
--without tools -ba SPECS/kernel-ml-5.12.spec
5) install and boot the new kernel
6) generate the xtables-addons-kmod with
env LC_ALL=C TMPDIR=/var/tmp MAKEFLAGS="LLVM=1" akmods --kernels
5.12.12-1.el8.clang.nolto.x86_64

I also tried using  MAKEFLAGS="LLVM=1 LLVM_IAS=1" and selecting
"thinlto" at step 2). It either failed either produced unbootable
kernels. At kernel 5.12.12, this step succeeds and produces a working
kernel.

But step 6, now becoming
env LC_ALL=C TMPDIR=/var/tmp MAKEFLAGS="LLVM=1 LLVM_IAS=1" akmods
--kernels 5.12.12-1.el8.clang.thinlto.x86_64
fails during the compilation. I tried to narrow down the problem by
calling the script generated by akmods a few times. It fails after
invoking ld.ldd with "error: permission denied". Restarting  manually
the last failed line succeeds, but relaunching the script fails at
another ld.ldd invocation.

The platform is x86_64 with CentOS 8 Stream, clang is 11.0

Could you please try to compile this module under a kernel with
CLANG+ThinLTO enabled ?

Thanks in advance

Pascal Dupuis
