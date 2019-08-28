Return-Path: <SRS0=hqFW=WY=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8AAA4C3A5A1
	for <netfilter-devel@archiver.kernel.org>; Wed, 28 Aug 2019 07:40:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5FF7420679
	for <netfilter-devel@archiver.kernel.org>; Wed, 28 Aug 2019 07:40:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="rGUphFce"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726408AbfH1Hkf (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 28 Aug 2019 03:40:35 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:55848 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726382AbfH1Hkf (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 28 Aug 2019 03:40:35 -0400
Received: by mail-wm1-f65.google.com with SMTP id f72so1613725wmf.5
        for <netfilter-devel@vger.kernel.org>; Wed, 28 Aug 2019 00:40:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=pLNRxd+LGizjPDE3c8uqMZITCvvK9wkJZjOp7gwydeo=;
        b=rGUphFcea/lpbIyMnzYHu+HzPYpbV6IC89Y9ahakAp7JYuCO8+Xww5d6hKbcCrlUXz
         qttBruH0IRYClKL+4k7j0+bTBhCJdUH0rHbC/NsYffs4wpbWEVE/KgeJx3MR8QCkS0bk
         n7+wWhQtYLqQzXIE2F5k0W33A0P5ivvSljgPaV79kRN5lywx5K7P0d1kPPDJaYLD1BRK
         2rcOWaHH703F1hPqfYY57tg+MQgEq9sCMjhVrB7EzdoGSwAz/5tu92W/i62x09t9RU+I
         PC5ulNokso/6dOHJHaj0R91QryIZ82wgnit07xC4B7lqc4QfbVpkIGHjVt7RH9xtigSQ
         VDMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=pLNRxd+LGizjPDE3c8uqMZITCvvK9wkJZjOp7gwydeo=;
        b=LxjyeWs/8Kv8pFoMnRGdMJo7B3uVshhiMILf0xCiZSD6p2L+V2hX2V+FPu8Nl7Dbbg
         FZpE1/5L0/aRvJy224tjpeOxl6fZgfmiI8DUpaugq59Rt1UQTs2ujSUiIjzZGxR1J5gu
         dSgz9CjNcZtqeSzWOYbtCptX5iVZY7bqdX91p62Yan6kIDNZ9n3awj2xG9uzTZuJF/D6
         Ma86mx0AIK5mRfyjiqGQ3nszufIT9SxVjnhC+L4Cy1ubCWPQEhHrIB7QpFbMNpxi8W8F
         tXfPrSUqPkHTtsuRRqt4vK0v+Jz7PwZqIy3rbbrJNTLujvhss/1QcTEOngTjFugAsfym
         w0ew==
X-Gm-Message-State: APjAAAXLGPX3FcmTXUmxicfqr5QH1OdfW+GQQiGT/FeCcsj4QzoZ2/Rs
        dYNK3BYM7h5L2d80x6XHmamCa8kU
X-Google-Smtp-Source: APXvYqwjOsC8R3rwAg4QAX3jZ1G0+9wA2TwSElA83uKzHz64S1ktaqdgjiwdjrXCnJNfcll79pdS4A==
X-Received: by 2002:a7b:c415:: with SMTP id k21mr2877597wmi.135.1566978032687;
        Wed, 28 Aug 2019 00:40:32 -0700 (PDT)
Received: from pixies (bzq-82-81-225-244.cablep.bezeqint.net. [82.81.225.244])
        by smtp.gmail.com with ESMTPSA id z7sm1341304wrh.67.2019.08.28.00.40.31
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 28 Aug 2019 00:40:32 -0700 (PDT)
Date:   Wed, 28 Aug 2019 10:40:30 +0300
From:   Shmulik Ladkani <shmulik.ladkani@gmail.com>
To:     Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH nf] netfilter: conntrack: make sysctls per-namespace
 again
Message-ID: <20190828104030.134f38ec@pixies>
In-Reply-To: <20190827112452.31479-1-fw@strlen.de>
References: <20190827135754.7d460ef8@pixies>
        <20190827112452.31479-1-fw@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, 27 Aug 2019 13:24:52 +0200
Florian Westphal <fw@strlen.de> wrote:

> When I merged the extension sysctl tables with the main one I forgot to
> reset them on netns creation.  They currently read/write init_net settings.
> 
> Fixes: d912dec12428 ("netfilter: conntrack: merge acct and helper sysctl table with main one")
> Fixes: cb2833ed0044 ("netfilter: conntrack: merge ecache and timestamp sysctl tables with main one")
> Reported-by: Shmulik Ladkani <shmulik.ladkani@gmail.com>
> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
>  Shmulik, could you please check if this fixes the bug for you?
>  Thanks!

Tested-by: Shmulik Ladkani <shmulik.ladkani@gmail.com>
