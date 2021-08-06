Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A18DC4338F
	for <netfilter-devel@archiver.kernel.org>; Fri,  6 Aug 2021 13:28:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F1B5161181
	for <netfilter-devel@archiver.kernel.org>; Fri,  6 Aug 2021 13:28:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344021AbhHFN2Q (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 6 Aug 2021 09:28:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:39622 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244222AbhHFN2Q (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 6 Aug 2021 09:28:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 374D3610FB;
        Fri,  6 Aug 2021 13:28:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628256480;
        bh=dkh3dvzjEZE9iTbls9gJibdZUt6AbGs04SlkQ7Guf4I=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=XuQDwYZ2Wr0+M+cak2eIvqvRhrJxoGYqqJWHWyOu63+rv1/zt60ch1sNmbxTutcQG
         oyyNjqVBKSrnxhxsNm0xEZVTG6/lG/2LlsZ5jLuWZCFMhIt/mRE3enPv+kBdpFuBOL
         i131lcYAlrYEfVWHwJWrgLjlIhFAqFAsH/2x2j2e5M2An0WxXb+0qMUEXSrAJGPvI7
         pVbGYgk06oX14ptI7veakpj+LoVAFNz1kvVQMq9zYv4qaShQK432umuQL5LAge4VBQ
         8PcYNzmFjJgtHxL9eWLM/C42dBApY8Y9fQ02gmRrcaF4dJl1Ji+n8dgE6oKO5bNM9c
         11ZLsJ4UZ/+qA==
Date:   Fri, 6 Aug 2021 06:27:59 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org
Subject: Re: [PATCH net 3/9] netfilter: conntrack: collect all entries in
 one cycle
Message-ID: <20210806062759.2acb5a47@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210806115207.2976-4-pablo@netfilter.org>
References: <20210806115207.2976-1-pablo@netfilter.org>
        <20210806115207.2976-4-pablo@netfilter.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri,  6 Aug 2021 13:52:01 +0200 Pablo Neira Ayuso wrote:
>  		rcu_read_lock();
>  
>  		nf_conntrack_get_ht(&ct_hash, &hashsz);
>  		if (i >= hashsz)
> -			i = 0;
> +			break;

Sparse says there is a missing rcu_read_unlock() here.
Please follow up on this one.
