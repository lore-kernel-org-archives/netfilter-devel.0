Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF15BC4332F
	for <netfilter-devel@archiver.kernel.org>; Mon, 21 Nov 2022 19:47:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229782AbiKUTrc (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 21 Nov 2022 14:47:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231610AbiKUTr1 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 21 Nov 2022 14:47:27 -0500
Received: from mail-yw1-x112e.google.com (mail-yw1-x112e.google.com [IPv6:2607:f8b0:4864:20::112e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 348C3D39DC
        for <netfilter-devel@vger.kernel.org>; Mon, 21 Nov 2022 11:47:22 -0800 (PST)
Received: by mail-yw1-x112e.google.com with SMTP id 00721157ae682-381662c78a9so123668067b3.7
        for <netfilter-devel@vger.kernel.org>; Mon, 21 Nov 2022 11:47:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=miGLX/uer5DgQxU7dvQq3Q5LleCS+CJp67dSlDVaExE=;
        b=W2eOWoW8GzSBhampXzP/DkPaV0qxqLK7MXncDfdEBhfBV0RYg1+uYg9j9oBTndzM3T
         96Ik633xtnuZok5Z8y8RfrMiVr+a75bpLEwv/Rl49WaGFUifA/lPteT7VUVt2P1uaNhQ
         p6q1xNDRV1aNGPRDHmUu9DNNwkjc6hHvJIPJOp2GqIagFJX82jlHrGYZvUM01JjJD3YY
         Xs/LFjGEpBLKr7g+8yqOzY+gYblQXhLmDy2WnCKnCLP1bT6JOr1nxQsyB5lsnEqVPY3q
         kgAF8ahZxe+UEz+dCBQN3snrVjZ4vOkXoAlPIL0CyKCWtXsWjSGEHAsdyGjs/gC+GDmJ
         DHdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=miGLX/uer5DgQxU7dvQq3Q5LleCS+CJp67dSlDVaExE=;
        b=igz/bcjocJ99/apUOg5h10nKu9J4YyQZaDD44oWCQmAHF6S38ETrUhE8c9XKcO7TPo
         ekPHf77SIxroX6qo+MLVGZ12MzLgFpUWODlDCnGhHVNlnGGmoq7GKGnmDWaC+t8nCDlD
         wKlH3pLffOSim9WtnhoYjxceS+hDjIGyUMiKdWCIsu1obaQAsIjwEo4X/l34HHu4NsUY
         gvceHpbDppSUqroZlwWsP1kLsMY+aWwHGCB9rYQRHmShuSnAwh22QRPzLWTSXgLA/Hnf
         cAIRHm6qTifhNW7Xl9tFHUwZ3eEFyhi9+ryRcZUf24epm1zDMVc/y4z957A3teOIZqp6
         yDzg==
X-Gm-Message-State: ANoB5plEuClo/JHEQuD5w66E6Uw3jDOZbajEFU64OTq3CVajlPcbpwuO
        UtbQzO9z/DmfU4dYhbwmkgKYafIsNVlhtM5m07PwqCwx+CY=
X-Google-Smtp-Source: AA0mqf7B/dgQPr7bn/BklMbZlqJRMsNTBtq6JKRQPaSuWwvWGzkQMMVJYbTG6638TJXaq3twZOa68lSzR7DB2QQgO3c=
X-Received: by 2002:a0d:c103:0:b0:370:7a9a:564 with SMTP id
 c3-20020a0dc103000000b003707a9a0564mr18324139ywd.278.1669060041149; Mon, 21
 Nov 2022 11:47:21 -0800 (PST)
MIME-Version: 1.0
References: <20221121182615.90843-1-nbd@nbd.name> <3a9c2e94-3c45-5f83-c703-75e1cde13be1@nbd.name>
In-Reply-To: <3a9c2e94-3c45-5f83-c703-75e1cde13be1@nbd.name>
From:   Eric Dumazet <edumazet@google.com>
Date:   Mon, 21 Nov 2022 11:47:10 -0800
Message-ID: <CANn89iKps9pM=DPn1aWF1SDMqrr=HHkHL8VofVHThUmtqzn=tQ@mail.gmail.com>
Subject: Re: [PATCH] netfilter: nf_flow_table: add missing locking
To:     Felix Fietkau <nbd@nbd.name>
Cc:     netfilter-devel@vger.kernel.org,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, Nov 21, 2022 at 11:45 AM Felix Fietkau <nbd@nbd.name> wrote:
>
> On 21.11.22 19:26, Felix Fietkau wrote:
> > nf_flow_table_block_setup and the driver TC_SETUP_FT call can modify the flow
> > block cb list while they are being traversed elsewhere, causing a crash.
> > Add a write lock around the calls to protect readers
> >
> > Signed-off-by: Felix Fietkau <nbd@nbd.name>
> Sorry, I forgot to add this:
>
> Reported-by: Chad Monroe <chad.monroe@smartrg.com>
>
> - Felix

Hi Felix

Could you also add a Fixes: tag ?

Thanks.
