Return-Path: <SRS0=/ZNS=BC=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39E40C433E1
	for <netfilter-devel@archiver.kernel.org>; Thu, 23 Jul 2020 08:40:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 15F282080D
	for <netfilter-devel@archiver.kernel.org>; Thu, 23 Jul 2020 08:40:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=tessares-net.20150623.gappssmtp.com header.i=@tessares-net.20150623.gappssmtp.com header.b="CNsYMCaC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727773AbgGWIkB (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 23 Jul 2020 04:40:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727107AbgGWIjz (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 23 Jul 2020 04:39:55 -0400
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A031C08C5C0
        for <netfilter-devel@vger.kernel.org>; Thu, 23 Jul 2020 01:39:55 -0700 (PDT)
Received: by mail-ed1-x541.google.com with SMTP id bm28so3919411edb.2
        for <netfilter-devel@vger.kernel.org>; Thu, 23 Jul 2020 01:39:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tessares-net.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=t34u4KAm1gK/f1oDA6+0ZgZ3T1IDP3Ad7b21M8jn9IE=;
        b=CNsYMCaC5YFx1sCHrUnGTyxK55+RElxWw1Y4CgVq4WviDSpLe5tvZRQNhbw/o8NHkS
         5lNPKTvPIJgzELza08HXzETuGDGqESAjMwaETk5Mmah7A76FYju7HEJcSxVz2Z68Ez32
         Fe8bkyg3EIliyQfIE0WUqAFYcrQUJWfpZsNbAdl/ll0KB40GMQt1yoxZTtepzlC4KdnZ
         GnSg5TjVpPWt7FlYOZYnnYqZEV4wmhNftYUlMk2HjS0eEZRDa0Aihb7OonspbY3XBKmu
         gfkANWXjINxT44g2wwmEPqLtqbE4VWM7CM7H0NR7+q8PAGIse1jhucMrcCJVf3oeSFy2
         TE7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=t34u4KAm1gK/f1oDA6+0ZgZ3T1IDP3Ad7b21M8jn9IE=;
        b=mivP8pXzbqsRCPR8k1nEkz2g6ZfUU5dFcWSvyKmS9iLAhFsCggUX1m8CJjezt3Miw5
         GmAhUg8gkrAdYHNjxBQCjSyIf0hLneejMj5s+zZ1ube7oCHJ+OHoscJypV/ZpY0ESfFa
         som/bAmmHo4Po8M4tM+FIF7I/U043Cy7iiqqNu8leLM9rJQwF/tbngsVqbCGuM6Q9r30
         KoUlpX8ClRQq85KQYe/f9moYsIfVvGJJKt57emt6LK1cs0qNPiZwUBPX6vCTt3B+s5J0
         XIyxBOA8A/JgM+3qRjj81sqjEc5y1MOiMdHoukxB+XPVJrFPuFdN418xo4lDVB2NgTkR
         mamQ==
X-Gm-Message-State: AOAM531D1vOTYtn30vHmGcDZZtt6e8PupW/d8BrmRIfSw69fvd31tnyD
        4//r3B6qXZmK9GaFfQAI7a7RNw==
X-Google-Smtp-Source: ABdhPJwbyZj4th/Ks5mvB+ElB/xiz0sHXiy/UKIrJCc8QLLBnJl9HfUHFNhTU1trrZNOtrIehMUs+A==
X-Received: by 2002:aa7:da4c:: with SMTP id w12mr3098522eds.122.1595493593384;
        Thu, 23 Jul 2020 01:39:53 -0700 (PDT)
Received: from tsr-lap-08.nix.tessares.net ([79.132.248.22])
        by smtp.gmail.com with ESMTPSA id q7sm1560608eja.69.2020.07.23.01.39.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Jul 2020 01:39:52 -0700 (PDT)
Subject: Re: [MPTCP] [PATCH 08/26] net: switch sock_set_timeout to sockptr_t
To:     Christoph Hellwig <hch@lst.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Eric Dumazet <edumazet@google.com>
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        linux-sctp@vger.kernel.org, linux-hams@vger.kernel.org,
        linux-bluetooth@vger.kernel.org, bridge@lists.linux-foundation.org,
        linux-can@vger.kernel.org, dccp@vger.kernel.org,
        linux-decnet-user@lists.sourceforge.net,
        linux-wpan@vger.kernel.org, linux-s390@vger.kernel.org,
        mptcp@lists.01.org, lvs-devel@vger.kernel.org,
        rds-devel@oss.oracle.com, linux-afs@lists.infradead.org,
        tipc-discussion@lists.sourceforge.net, linux-x25@vger.kernel.org
References: <20200723060908.50081-1-hch@lst.de>
 <20200723060908.50081-9-hch@lst.de>
From:   Matthieu Baerts <matthieu.baerts@tessares.net>
Message-ID: <092368db-122f-60bc-6a32-3cd5c70727da@tessares.net>
Date:   Thu, 23 Jul 2020 10:39:50 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200723060908.50081-9-hch@lst.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Christoph,

On 23/07/2020 08:08, Christoph Hellwig wrote:
> Pass a sockptr_t to prepare for set_fs-less handling of the kernel
> pointer from bpf-cgroup.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>   net/mptcp/protocol.c |  6 ++++--

Thank you for looking at that!

For MPTCP-related code:

Acked-by: Matthieu Baerts <matthieu.baerts@tessares.net>

Cheers,
Matt
-- 
Tessares | Belgium | Hybrid Access Solutions
www.tessares.net
