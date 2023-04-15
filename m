Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6605C77B77
	for <netfilter-devel@archiver.kernel.org>; Sat, 15 Apr 2023 22:56:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229894AbjDOW45 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 15 Apr 2023 18:56:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229600AbjDOW44 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 15 Apr 2023 18:56:56 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2849B2D78
        for <netfilter-devel@vger.kernel.org>; Sat, 15 Apr 2023 15:56:55 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id l21so4050076pla.5
        for <netfilter-devel@vger.kernel.org>; Sat, 15 Apr 2023 15:56:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20221208.gappssmtp.com; s=20221208; t=1681599414; x=1684191414;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ubRjxle8AfL59Prm/wkmTmVjb75/p8iBeRuuijtLjNg=;
        b=TZKMN8poAHP4YwAqnU9eEVSOlb5ek8a5pOp6pAenCZDEHOJssxaf+A4++1IIYw7MpM
         7aq9yaEQTpQNruGixDOeSiEIZuumGKqQqq61OfoKbml+6JwtYe2rw4/T/V8o5iEBSi51
         OSOWCMJ+FlQaNG/1ktYx6rTm4HSd8b8EpSnbipfzd+GjNGowid2Q/djKv2jOWWHaHmEP
         hSiqOIeyIH6QSf2ALrjHP/WGwHSsfWJFwgnpnRFGR3vBzTBTPXI+33kdhOkhQoB8hegE
         UeeIqG5sqAzmDiUPg8p1YaOLplu+Tnxv7+bB8KIo23tQvL0qQzEtGCfEbteC9xiY3pS+
         pioA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681599414; x=1684191414;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ubRjxle8AfL59Prm/wkmTmVjb75/p8iBeRuuijtLjNg=;
        b=F1a65RijxnUU7zn17qIhhk1hNLCbul09FVXUhR4MoM+7rLCyoW5JDt6A/KnvWyisVb
         idSD3ddQ9sY0dLaDjLSiv+lhR/Vu3VWUdi1o11Ur8zoeqNEcXe39wysIic8gU8Qm1MJx
         4vpCIJ9oflQmPNXn4v5IwdDJ9GbEwqXvJskUdK3LXpUT3NfEMfd5lr35kJS/6nShZXyi
         gjEVJZzaIaD5eiRt2OmlZ22e4cO0Qd7SqEJRhQFmWUvcUDI9oLkcxvVMKvO0Ak02QJOQ
         oNRFF6gAxmV5dRQYEG22beFuw9YJqAt0yQ6ns9G8LhPIIQaivsEEWraZ5VTLycXqeDhs
         jwAg==
X-Gm-Message-State: AAQBX9fDhjFyGh9iosQjYmyN+zuJDgNe+PfdyGFWyxMGVoRHhrmHPMmQ
        7x85ZEERZxcH9tjDGQhWRKnP3A==
X-Google-Smtp-Source: AKy350bsEaGCTirqACeAVtm48St3ie5XE0fYZj2D3HWUz1dZxDWvNItGbUZOV8DjHKhZt7C3oJG6Eg==
X-Received: by 2002:a05:6a20:78a8:b0:e9:5b0a:deff with SMTP id d40-20020a056a2078a800b000e95b0adeffmr9990865pzg.22.1681599414582;
        Sat, 15 Apr 2023 15:56:54 -0700 (PDT)
Received: from hermes.local (204-195-120-218.wavecable.com. [204.195.120.218])
        by smtp.gmail.com with ESMTPSA id e25-20020a635019000000b00502e6bfedc0sm4647359pgb.0.2023.04.15.15.56.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 15 Apr 2023 15:56:54 -0700 (PDT)
Date:   Sat, 15 Apr 2023 15:56:51 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     david.keisarschm@mail.huji.ac.il
Cc:     linux-kernel@vger.kernel.org,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Andrea Parri <parri.andrea@gmail.com>,
        Will Deacon <will@kernel.org>,
        Boqun Feng <boqun.feng@gmail.com>,
        Nicholas Piggin <npiggin@gmail.com>,
        David Howells <dhowells@redhat.com>,
        Jade Alglave <j.alglave@ucl.ac.uk>,
        Luc Maranget <luc.maranget@inria.fr>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Akira Yokosawa <akiyks@gmail.com>,
        Daniel Lustig <dlustig@nvidia.com>,
        Joel Fernandes <joel@joelfernandes.org>, Jason@zx2c4.com,
        keescook@chromium.org, ilay.bahat1@gmail.com, aksecurity@gmail.com,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-arch@vger.kernel.org
Subject: Re: [PATCH v5 3/3] Replace invocation of weak PRNG
Message-ID: <20230415155651.18ce590f@hermes.local>
In-Reply-To: <20230415173756.5520-1-david.keisarschm@mail.huji.ac.il>
References: <20230415173756.5520-1-david.keisarschm@mail.huji.ac.il>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Sat, 15 Apr 2023 20:37:53 +0300
david.keisarschm@mail.huji.ac.il wrote:

> diff --git a/include/uapi/linux/netfilter/xt_dscp.h b/include/uapi/linux/netfilter/xt_dscp.h
> index 7594e4df8..223d635e8 100644
> --- a/include/uapi/linux/netfilter/xt_dscp.h
> +++ b/include/uapi/linux/netfilter/xt_dscp.h
> @@ -1,32 +1,27 @@
>  /* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
> -/* x_tables module for matching the IPv4/IPv6 DSCP field
> +/* x_tables module for setting the IPv4/IPv6 DSCP field
>   *
>   * (C) 2002 Harald Welte <laforge@gnumonks.org>
> + * based on ipt_FTOS.c (C) 2000 by Matthew G. Marsh <mgm@paktronix.com>
>   * This software is distributed under GNU GPL v2, 1991
>   *
>   * See RFC2474 for a description of the DSCP field within the IP Header.
>   *
> - * xt_dscp.h,v 1.3 2002/08/05 19:00:21 laforge Exp
> + * xt_DSCP.h,v 1.7 2002/03/14 12:03:13 laforge Exp
>  */

This part of the change is a mess.
Why are you adding ipt_FTOS.c here?
Why are you updating ancient header line from 2002?

