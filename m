Return-Path: <SRS0=oAJK=BK=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.6 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	HK_RANDOM_FROM,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01B87C433E0
	for <netfilter-devel@archiver.kernel.org>; Fri, 31 Jul 2020 00:26:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D4DB120663
	for <netfilter-devel@archiver.kernel.org>; Fri, 31 Jul 2020 00:26:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="sOOQDS6l"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730781AbgGaA0R (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 30 Jul 2020 20:26:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730914AbgGaA0Q (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 30 Jul 2020 20:26:16 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19BF1C061574
        for <netfilter-devel@vger.kernel.org>; Thu, 30 Jul 2020 17:26:16 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id t6so2290710pjr.0
        for <netfilter-devel@vger.kernel.org>; Thu, 30 Jul 2020 17:26:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Z3Lm1sGkWQwPe3NkE6iARE36RcrQ0xDQdl/rL+tDjI0=;
        b=sOOQDS6l29PwJncVTdlZkzs7X7QSPkZPgnQAmSIwmUOgSvyL2/q0N7p90FYdSW2s8j
         7CUVCSO8S+NAKPz3nxM6HhwyGHv+sbArXQoh5HbHlu8QYOGJbIQnOYENg9nXxXSjqXmE
         b/NXnhhTJcnAncLg5glbJ16Gmu7U9R7QCPUgEmu8abMsBqnftD0pBFG9svq8rL0X1x/+
         8QDgT9u9tf81CyG+A5/tzVxH58yQi4pFayRE1lwYeGvyydlZNXXPSUdjYJIU9bOJ2Y5Q
         Duxb7LFSRiGHX9usLWXOtYqk0aAF6bIjq1IUM4JvYDAPcBT2UjU0aKEK9VPxeKVm1Hx4
         PkFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Z3Lm1sGkWQwPe3NkE6iARE36RcrQ0xDQdl/rL+tDjI0=;
        b=BL9eYx93sOimpshtLwYyeSrZuHzWIbczLa2RXSTbsKls5t6WxSG6XcuiZCq5uA25QG
         4MNE/vLqZbQ48rkFNlHn6dq3V6sxzPR6mcqRB56dRUZeFp2tozwhNjb0U+kt/y5PFv8Q
         CegdQ5d2C3COILl9KZNaPhci4AlHdygvbuno2XcIPLvMTATscXiivfTiKGy+8UxarrEy
         pwr+CqlDwNY0o6NgNqE/vqY4YOfpL/C/i+SsgDmpVn4A1UQF0Wg+ygiWQqsAbJuu9SpD
         KIQmpwKWo05nOMw+9zsuld3wQO5iQI58/eqwtek0ZVoQSfWSaY8XO4HOWEvYmoc7J89V
         pMCw==
X-Gm-Message-State: AOAM533gLAPkfS04arIpteq1v6G4xtFn/vGsxBmr0IiZMOwJI1kUbZpt
        bF0NaVILlhU5mLjSPWH/Ogij2w==
X-Google-Smtp-Source: ABdhPJwcr954AG1gqEdKpM5QuRqbV3+wB5pscU2NtJ0l5WoRi0tIaQ0FwOD7I+WVx/5rp3y/anJJGw==
X-Received: by 2002:a63:8c5d:: with SMTP id q29mr1238398pgn.249.1596155175408;
        Thu, 30 Jul 2020 17:26:15 -0700 (PDT)
Received: from google.com (56.4.82.34.bc.googleusercontent.com. [34.82.4.56])
        by smtp.gmail.com with ESMTPSA id p19sm7867698pgj.74.2020.07.30.17.26.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Jul 2020 17:26:14 -0700 (PDT)
Date:   Fri, 31 Jul 2020 00:26:11 +0000
From:   William Mcvicker <willmcvicker@google.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     security@kernel.org, Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-team@android.com
Subject: Re: [PATCH 1/1] netfilter: nat: add range checks for access to
 nf_nat_l[34]protos[]
Message-ID: <20200731002611.GA1035680@google.com>
References: <20200727175720.4022402-1-willmcvicker@google.com>
 <20200727175720.4022402-2-willmcvicker@google.com>
 <20200729214607.GA30831@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200729214607.GA30831@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Pablo,

Yes, I believe this oops is only triggered by userspace when the user
specifically passes in an invalid nf_nat_l3protos index. I'm happy to re-work
the patch to check for this in ctnetlink_create_conntrack().

> BTW, do you have a Fixes: tag for this? This will be useful for
> -stable maintainer to pick up this fix.

Regarding the Fixes: tag, I don't have one offhand since this bug was reported
to me, but I can search through the code history to find the commit that
exposed this vulnerability.

Thanks,
Will

On 07/29/2020, Pablo Neira Ayuso wrote:
> Hi Will,
> 
> On Mon, Jul 27, 2020 at 05:57:20PM +0000, Will McVicker wrote:
> > The indexes to the nf_nat_l[34]protos arrays come from userspace. So we
> > need to make sure that before indexing the arrays, we verify the index
> > is within the array bounds in order to prevent an OOB memory access.
> > Here is an example kernel panic on 4.14.180 when userspace passes in an
> > index greater than NFPROTO_NUMPROTO.
> > 
> > Internal error: Oops - BUG: 0 [#1] PREEMPT SMP
> > Modules linked in:...
> > Process poc (pid: 5614, stack limit = 0x00000000a3933121)
> > CPU: 4 PID: 5614 Comm: poc Tainted: G S      W  O    4.14.180-g051355490483
> > Hardware name: Qualcomm Technologies, Inc. SM8150 V2 PM8150 Google Inc. MSM
> > task: 000000002a3dfffe task.stack: 00000000a3933121
> > pc : __cfi_check_fail+0x1c/0x24
> > lr : __cfi_check_fail+0x1c/0x24
> > ...
> > Call trace:
> > __cfi_check_fail+0x1c/0x24
> > name_to_dev_t+0x0/0x468
> > nfnetlink_parse_nat_setup+0x234/0x258
> 
> If this oops is only triggerable from userspace, I think a sanity
> check in nfnetlink_parse_nat_setup should suffice to reject
> unsupported layer 3 and layer 4 protocols.
> 
> I mean, in this patch I see more chunks in the packet path, such as
> nf_nat_l3proto_ipv4 that should never happen. I would just fix the
> userspace ctnetlink path.
> 
> BTW, do you have a Fixes: tag for this? This will be useful for
> -stable maintainer to pick up this fix.
> 
> Thanks.
