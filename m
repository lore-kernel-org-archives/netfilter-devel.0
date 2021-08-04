Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A322C4338F
	for <netfilter-devel@archiver.kernel.org>; Wed,  4 Aug 2021 13:19:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2C89560D07
	for <netfilter-devel@archiver.kernel.org>; Wed,  4 Aug 2021 13:19:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237972AbhHDNT7 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 4 Aug 2021 09:19:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237968AbhHDNT7 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 4 Aug 2021 09:19:59 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4BADC061798
        for <netfilter-devel@vger.kernel.org>; Wed,  4 Aug 2021 06:19:45 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id e21so2967515pla.5
        for <netfilter-devel@vger.kernel.org>; Wed, 04 Aug 2021 06:19:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=W8wT+0czkOSnCM9mJFrp+Gx4RB63rCwEzXEJPChhqEA=;
        b=F1iHwcQnGP4vpeuQwxKdRIE1QaeSKlKt2o0jFEZ9bFU0V395IhXcgspeNY8sxWlroJ
         EPEss3ulUfiBaCG5rhX5te8GF5yvcardezbWws9+oX+Ky1wLIAPSyhdjmxv+6htpuMis
         dnjjLHuOSqqckWVjeYm67NLEYE/mXmMrXsP7CzcxhrvW72X+vmV3giyCYr3OYH1LN3PT
         8Twg1R/8QSt3wQmuThKeAP1elTdii2UKD7SdWAx1yKKM2Ty4DvW0Agcbs6nsOYHI2Pre
         q5bQxj6B0BPXc/IOFOg6b476oOmCM93y8G1pWRx5y+ZiqrHj894+RF8L4TF6aUXa5AaG
         IiOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=W8wT+0czkOSnCM9mJFrp+Gx4RB63rCwEzXEJPChhqEA=;
        b=cWYunMgEjq/tS5lhsDCLG0DXXbDeXUg6doLUzDVguIsaOfUZYPMEOjkpSPirlYw2zu
         FvmXxqE5H7PlsKO9yQfKL/W9Fi7p0Fd5HJSMcUauOcKwWAAnKe7cArdEb7F1xYjCm3BN
         bbjoTMdGTilfAdb5WoFNkpsWT6zpr9+RR/gaRoiMGNkY9e2oA5hyqt7X0oiDtlmmFKDa
         TnWXKXw7CMgxitVOU9sxn9uX5PDeIMGxBJNcOsAukaCrdR5NqBrcU5B0wzVp8CbUAVdV
         Afn48mxkO0nGHRCSaWEjHow4fNDiHh6dAXg3yiYxen6UB2yGGKq4A0SsnxnZMrxRr/ST
         pIig==
X-Gm-Message-State: AOAM5324TE75rChDOs/asW8IltfS5m/nAlqxq+HCIw6kF2XOr+VZK2jt
        ZtqsMRVC0F7gjo2o4jhuA3U=
X-Google-Smtp-Source: ABdhPJzR9c2glDnzz2yJTddvvo5ZgW62F4RXW7jaO9/Q7aN/71hQYFY1ssZD/egfcwme1i++WkEPIA==
X-Received: by 2002:a17:90a:8809:: with SMTP id s9mr9797749pjn.44.1628083185242;
        Wed, 04 Aug 2021 06:19:45 -0700 (PDT)
Received: from horizon.localdomain ([2001:1284:f016:8709:20d6:9d5d:5ea5:8f61])
        by smtp.gmail.com with ESMTPSA id g23sm3226143pfu.174.2021.08.04.06.19.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Aug 2021 06:19:44 -0700 (PDT)
Received: by horizon.localdomain (Postfix, from userid 1000)
        id 58AD6C05DE; Wed,  4 Aug 2021 10:19:42 -0300 (-03)
Date:   Wed, 4 Aug 2021 10:19:42 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org, Oz Shlomo <ozsh@nvidia.com>,
        Paul Blakey <paulb@nvidia.com>
Subject: Re: [PATCH v2 nf] netfilter: conntrack: remove offload_pickup sysctl
 again
Message-ID: <YQqT7s7tsz9U26xq@horizon.localdomain>
References: <20210804130215.3625-1-fw@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210804130215.3625-1-fw@strlen.de>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Aug 04, 2021 at 03:02:15PM +0200, Florian Westphal wrote:
> These two sysctls were added because the hardcoded defaults (2 minutes,
> tcp, 30 seconds, udp) turned out to be too low for some setups.
> 
> They appeared in 5.14-rc1 so it should be fine to remove it again.
> 
> Marcelo convinced me that there should be no difference between a flow
> that was offloaded vs. a flow that was not wrt. timeout handling.
> Thus the default is changed to those for TCP established and UDP stream,
> 5 days and 120 seconds, respectively.
> 
> Marcelo also suggested to account for the timeout value used for the
> offloading, this avoids increase beyond the value in the conntrack-sysctl
> and will also instantly expire the conntrack entry with altered sysctls.
> 
> Example:
>    nf_conntrack_udp_timeout_stream=60
>    nf_flowtable_udp_timeout=60
> 
> This will remove offloaded udp flows after one minute, rather than two.
> 
> An earlier version of this patch also cleared the ASSURED bit to
> allow nf_conntrack to evict the entry via early_drop (i.e., table full).
> However, it looks like we can safely assume that connection timed out
> via HW is still in established state, so this isn't needed.
> 
> Quoting Oz:
>  [..] the hardware sends all packets with a set FIN flags to sw.
>  [..] Connections that are aged in hardware are expected to be in the
>  established state.
> 
> In case it turns out that back-to-sw-path transition can occur for
> 'dodgy' connections too (e.g., one side disappeared while software-path
> would have been in RETRANS timeout), we can adjust this later.

Yup. Maybe an early soft timeout in sw.

> 
> Cc: Oz Shlomo <ozsh@nvidia.com>
> Cc: Paul Blakey <paulb@nvidia.com>
> Suggested-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
> Signed-off-by: Florian Westphal <fw@strlen.de>

Reviewed-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>

Thanks!
