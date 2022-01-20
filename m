Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E9A0C433EF
	for <netfilter-devel@archiver.kernel.org>; Thu, 20 Jan 2022 03:56:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234345AbiATD4L (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 19 Jan 2022 22:56:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229787AbiATD4K (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 19 Jan 2022 22:56:10 -0500
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A33F6C061574
        for <netfilter-devel@vger.kernel.org>; Wed, 19 Jan 2022 19:56:10 -0800 (PST)
Received: by mail-pl1-x635.google.com with SMTP id f13so4161035plg.0
        for <netfilter-devel@vger.kernel.org>; Wed, 19 Jan 2022 19:56:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:from:date:to:cc:subject:message-id:mail-followup-to
         :references:mime-version:content-disposition:in-reply-to;
        bh=1omeCxP89lJLsswkj3rXmPCGUtOvvvEKu1O4ruafRXg=;
        b=NHqzsH6f3FR5hMxNoDw2WbulXiqU1wTZ4oIu/rB2h56bymIG+NqbEMD8bc6JIqodnz
         PWWKt4FMNiqWVM2PQPCagdS+2rPtVi3RBfBFdL+kQx68w3cl/yT/KUX97BIh+7JC4SaE
         zGjgDGM/Nu3Jzm4uWOSoO3Zl4bFgYim7qd0N9LhKZT59Sv/LVw9cZH0ds0qRrD2e+s7J
         npLsD0tZaC1Jk2oAHndvf7WnDIrA2Azjk8vtYA8dqAoTxm9x+N0nLt9DMAN+N3swnLZF
         KIJ708YIafwMzhObXrzQt8fCEQLf/IyJ4zG7xZbi/TBq7Mwk1h5e+H29ID7OkHFfp/OA
         SAwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:from:date:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to;
        bh=1omeCxP89lJLsswkj3rXmPCGUtOvvvEKu1O4ruafRXg=;
        b=u5+wsRzzvK0ZvzB09AvCTIZqXopf/dT/GLUyRkUtEiXw0Y2TKmftMZ+7+qNLwg7EoS
         kDcKiSAL6bYMjEdmN+NEix1HXpbQXTUUxY0PTfJ2ZlwFJ0b+jtrPEOWcMr/fJteYNWYz
         /1TNCtDBi1SVCowQ03bd8NyxLNcmjdBxrkC+XXZZoh5mFCsv8fLw6jX3IVV4rXvHhrBh
         BKNfghWXXjCGWv42zj1FSwQMg+pW4mHL/nh5RlgQwUP/9K1U12mkY8bhPW9rRaIVadEa
         ogserlKe/mzvtHw8kM7SYutXlBqfNG4tUIIVxeQ2UHHmV2urF8zI3/buDcNOySmIaYdZ
         Gutg==
X-Gm-Message-State: AOAM531x6zKETMCyEV0U1bbI8ALql4SB7kUNG4sqxkuGtdXEMQDM2R7v
        dkLN/yam1/HvR/lViAbJunUZUnLi7ak=
X-Google-Smtp-Source: ABdhPJynCFJAy70Z13TS6ga2QiNenDKObItgxt0MFadI3KYEBolwRnTOV/fSjqQEayN1CwQBohq1Vg==
X-Received: by 2002:a17:903:11c3:b0:14a:58c4:f34c with SMTP id q3-20020a17090311c300b0014a58c4f34cmr35641964plh.151.1642650970202;
        Wed, 19 Jan 2022 19:56:10 -0800 (PST)
Received: from slk1.local.net (n110-23-108-30.sun3.vic.optusnet.com.au. [110.23.108.30])
        by smtp.gmail.com with ESMTPSA id o17sm885163pgh.77.2022.01.19.19.56.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Jan 2022 19:56:09 -0800 (PST)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From:   Duncan Roe <duncan_roe@optusnet.com.au>
X-Google-Original-From: Duncan Roe <dunc@slk1.local.net>
Date:   Thu, 20 Jan 2022 14:56:05 +1100
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Florian Westphal <fw@strlen.de>,
        Netfilter Development <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH libnetfilter_queue v3 1-5/5] src: Speed-up
Message-ID: <YejdVZaoUz+t1qRU@slk1.local.net>
Mail-Followup-To: Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Netfilter Development <netfilter-devel@vger.kernel.org>
References: <20220109031653.23835-1-duncan_roe@optusnet.com.au>
 <20220109031653.23835-6-duncan_roe@optusnet.com.au>
 <YeYClrLxYGDeD8ua@slk1.local.net>
 <YeYTzwpxiqLz8ulb@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YeYTzwpxiqLz8ulb@salvia>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Jan 18, 2022 at 02:11:43AM +0100, Pablo Neira Ayuso wrote:
>
> This patch have a number of showstoppers such as exposing structure
> layout on the header files.
>
That's only in patch 5. You could apply 1-4. There are actually no other
showstoppers, right?

Cheers ... Duncan.
