Return-Path: <SRS0=HFPz=AM=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93ADDC433E1
	for <netfilter-devel@archiver.kernel.org>; Wed,  1 Jul 2020 20:32:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 73D96208A7
	for <netfilter-devel@archiver.kernel.org>; Wed,  1 Jul 2020 20:32:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1593635546;
	bh=Qu1PVZWZQB1pW5uORGG9JkdLLWLwrioSV8gFiogltGY=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=KP3Mt2eEMGn01pfDCNlIQGMkxPGCIE09p00zij30qoFOwtsMNE79ST0mlbkv9t75k
	 7m1PSup1vFEng6vjFTh8s3f9zk9x4eJJO8Z7YmpblIiXZxyTbT3AGmQV+ju4n8MBJr
	 cFArRIoJVMjzZ4w1ls1fwAExNA8lxC1GRgU/y5aw=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726990AbgGAUcX (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 1 Jul 2020 16:32:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726144AbgGAUcX (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 1 Jul 2020 16:32:23 -0400
Received: from mail-lj1-x241.google.com (mail-lj1-x241.google.com [IPv6:2a00:1450:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D59D8C08C5DB
        for <netfilter-devel@vger.kernel.org>; Wed,  1 Jul 2020 13:32:22 -0700 (PDT)
Received: by mail-lj1-x241.google.com with SMTP id b25so25235224ljp.6
        for <netfilter-devel@vger.kernel.org>; Wed, 01 Jul 2020 13:32:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=yQTuuRnTRD5guY+N3kjgnPLHXT6P3qZiYHrrKJ47r1w=;
        b=M5E2TfLcC3cfW8OMyrKhXxxtIvY0Y104cXmmv3Q4raTCa6ajB/XOROYaclyuBwWh+A
         QwyVYKRQgeqALuvdcW7sv0dw33dOl/5F5gCyZFcJBfQqk4HuU7lj0CC2aelEfwTDdC0Y
         4kjCbqfpjXn7jho9KN1KvD2s7uo+DH0VG6r6M=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=yQTuuRnTRD5guY+N3kjgnPLHXT6P3qZiYHrrKJ47r1w=;
        b=e4/Pcw6MAp8Teml7/AQngJZyhFbKjqi4RK5jud7jBd6OWX6U3k2Gn5IlejIvLvXs8w
         ot5Mx8CUgnXU1gtwE1xsSu349OvAB7O7j4787GlpRoLnkkDGQiSfdgxNUlebXFK8ERC+
         sJNj3gRxvKjiIzo+CFCHW4p2iu0Kgp759KdEmMq4IYOZTleUkk2DdgNY8W3OVTA5PSzf
         F+vXoE9eMykId7uaSZJ39nRAa+5wl1L35jp4Tv3B2XXygPp+9hQ2P1sQ73sahWlYzkSa
         AE2Bi69YAu23rphRjeAmvSj2pmcL5VSSq6GHYv776gZktqaKUQuJ/FChMBsICaW3DR0+
         ua3Q==
X-Gm-Message-State: AOAM533BzmupBCIJHNqV+UB/l2bHVKKREwlsjQDJ3MzAbaWsSU0yFVjR
        ZZFWmROQNwYWig4juFFLH4+p0axqfJM=
X-Google-Smtp-Source: ABdhPJxpFsZg6aZ2bRsCmke3Wg/O/+xUzgtA/Zdqd1/ag9muLFkY8r0+a/vS7hJ3xDyUkxYzWiukPA==
X-Received: by 2002:a2e:9891:: with SMTP id b17mr10974516ljj.22.1593635540863;
        Wed, 01 Jul 2020 13:32:20 -0700 (PDT)
Received: from mail-lf1-f52.google.com (mail-lf1-f52.google.com. [209.85.167.52])
        by smtp.gmail.com with ESMTPSA id y24sm2167521ljy.91.2020.07.01.13.32.19
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 01 Jul 2020 13:32:19 -0700 (PDT)
Received: by mail-lf1-f52.google.com with SMTP id t74so14516014lff.2
        for <netfilter-devel@vger.kernel.org>; Wed, 01 Jul 2020 13:32:19 -0700 (PDT)
X-Received: by 2002:a19:8a07:: with SMTP id m7mr16119813lfd.31.1593635539128;
 Wed, 01 Jul 2020 13:32:19 -0700 (PDT)
MIME-Version: 1.0
References: <20200624161335.1810359-14-hch@lst.de> <20200701091943.GC3874@shao2-debian>
 <20200701121344.GA14149@lst.de>
In-Reply-To: <20200701121344.GA14149@lst.de>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Wed, 1 Jul 2020 13:32:03 -0700
X-Gmail-Original-Message-ID: <CAHk-=whYihRm0brAXPc0dFcsU2M+FA4VoOiwGGdVLC_sHT=M1g@mail.gmail.com>
Message-ID: <CAHk-=whYihRm0brAXPc0dFcsU2M+FA4VoOiwGGdVLC_sHT=M1g@mail.gmail.com>
Subject: Re: [fs] 140402bab8: stress-ng.splice.ops_per_sec -100.0% regression
To:     Christoph Hellwig <hch@lst.de>
Cc:     kernel test robot <rong.a.chen@intel.com>,
        Al Viro <viro@zeniv.linux.org.uk>, Ian Kent <raven@themaw.net>,
        David Howells <dhowells@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        LSM List <linux-security-module@vger.kernel.org>,
        NetFilter <netfilter-devel@vger.kernel.org>, lkp@lists.01.org
Content-Type: text/plain; charset="UTF-8"
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Jul 1, 2020 at 5:13 AM Christoph Hellwig <hch@lst.de> wrote:
>
> FYI, this is because stress-nh tests splice using /dev/null.  Which
> happens to actually have the iter ops, but doesn't have explicit
> splice_read operation.

Heh. I guess a splice op for /dev/null should be fairly trivial to implement..

               Linus
