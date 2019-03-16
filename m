Return-Path: <SRS0=RSCw=RT=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8C7DC10F03
	for <netfilter-devel@archiver.kernel.org>; Sat, 16 Mar 2019 12:15:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A8886218FE
	for <netfilter-devel@archiver.kernel.org>; Sat, 16 Mar 2019 12:15:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Ouwox/aC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726868AbfCPMPN (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 16 Mar 2019 08:15:13 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:33240 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726310AbfCPMPM (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 16 Mar 2019 08:15:12 -0400
Received: by mail-pf1-f193.google.com with SMTP id i19so8186404pfd.0;
        Sat, 16 Mar 2019 05:15:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=wX0+RhRVXnGfkIonRB0TJgpOIjfOJjR0TKpZGa+6gsk=;
        b=Ouwox/aCVl3nDyIay7jRKjIR4F2pNVyTM0Du021bc0OhKkid9AHNWeExDxDhiOvyil
         Mc6VwlVKDj3yZ5SBcaq9HLQXG7yjJjXo0oclsESvmm5ZMRlvmNe+SSAbq7IXytZtiGhA
         YFTnPFlnA4j9kklFczVeKc4adBhhpSR7cYNCi4D9Ikb4NsG5Bm7zCfeVF4DsfPbDPgSP
         pf7d/2uNfwdA5NNktrOnz6cigWAtnFdk8CTdaJGaCnshRDKjG3tEd0m86+5l2FupZ6Es
         bw6r1S62jI2WacTxwrP5QlfvQBl4DxSsztq1QSIOMexQ+3aH6qoBOm3NF4h47dxjF1wF
         qjiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=wX0+RhRVXnGfkIonRB0TJgpOIjfOJjR0TKpZGa+6gsk=;
        b=X/tozSgn+L/F6XEbSJn0nRkLFMT5cmbChz+WX/NhFL+h7JkMfK3iAEBI8EQpvrkfr/
         XauZTD9Sbkazq8ju1yh1q76rAiUivWjmFjovlZFFjWWw35ooEt886H7biG6nrj5q3d3M
         O8W5Kb3/TyQteDuGJhq3UKhmiF1UX1ottLGIULEeP+hOIqs94N9+hlCEbjq6gWJCj/os
         U0BOKS1nbXFeyNZO/ViApPLEnuqUVuddlDRg75rMRUeNow8xxxgm4RbwAw2X214yRDQK
         MfL2LSuspUdQ4AG+sf66M10nh75ppEXWtxuKYaBVfW+IWJs05cYWFP7kMf+xvbOh9b0L
         MIwg==
X-Gm-Message-State: APjAAAUdwP8m0jUaIv67i7iiqL/8pXR8Cm6FH68cyQxe0dp7zc4g7fIg
        j0Nv7fF1hFpdGiVf+HJGNQ==
X-Google-Smtp-Source: APXvYqxtnR9ERVBkq1Ia2JNW7psVeUTV02A4nNzYVHAoAk1DB2aGBy60a2/CJxuZDEVcLk333c+vqw==
X-Received: by 2002:a17:902:9a01:: with SMTP id v1mr9659473plp.34.1552738512196;
        Sat, 16 Mar 2019 05:15:12 -0700 (PDT)
Received: from localhost ([2001:19f0:7001:54c5:5400:1ff:fec8:7fc2])
        by smtp.gmail.com with ESMTPSA id b65sm7949264pfm.127.2019.03.16.05.15.10
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Sat, 16 Mar 2019 05:15:11 -0700 (PDT)
Date:   Sat, 16 Mar 2019 20:15:07 +0800
From:   Jacky Hu <hengqing.hu@gmail.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     jacky.hu@walmart.com, jason.niesz@walmart.com,
        Wensong Zhang <wensong@linux-vs.org>,
        Simon Horman <horms@verge.net.au>,
        Julian Anastasov <ja@ssi.bg>,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Florian Westphal <fw@strlen.de>, netdev@vger.kernel.org,
        lvs-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org
Subject: Re: [PATCH v3] ipvs: allow tunneling with gue encapsulation
Message-ID: <20190316121507.GA32042@i716>
References: <20190316072009.2247-1-hengqing.hu@gmail.com>
 <20190316090649.mm7fskvzx5hzp672@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190316090649.mm7fskvzx5hzp672@salvia>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Here is the report:
Added break statements for switch cases to avoid fall through.
It makes iptunnel_handle_offloads gets proper gso_type_mask.

Thanks!
