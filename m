Return-Path: <SRS0=Pnh4=S5=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS,
	USER_AGENT_MUTT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94474C4321A
	for <netfilter-devel@archiver.kernel.org>; Sat, 27 Apr 2019 12:28:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6740920C01
	for <netfilter-devel@archiver.kernel.org>; Sat, 27 Apr 2019 12:28:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1556368086;
	bh=vrMEILYXAPDIv9m/wqFQ1ACXIj9xGDu6gS6qJvnghxg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=pGXFD2O2sESCw4Wub+Oyw+EykRRD7lI144dSkfPNwCAjxobpWX6GUivk+DqEvKwlD
	 ptJq85tmAQBSHU7M1qkXu67c1eb54XagjkqbH7fJ8S1j1TE9W/P0RodXY2RS4bhzHK
	 CYwP1jwgwCWbcoLHHPOZHvRBnJJP0FtRqe9ZGvpQ=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726442AbfD0M2F (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 27 Apr 2019 08:28:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:50616 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726345AbfD0M2F (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 27 Apr 2019 08:28:05 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E7022208C2;
        Sat, 27 Apr 2019 12:28:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556368084;
        bh=vrMEILYXAPDIv9m/wqFQ1ACXIj9xGDu6gS6qJvnghxg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=id1SaEc2Dt3TFcnXKND5RYhAxoFOYhRFek/5qNqKfxlJ5u2xF/+zY4JyH2D3UOVVc
         QYIQGShP+Sg4TnBVn8ZJaBDgg62WXLYr2fxAlb8NT+4gmIlgzvM3o2+8dCvdrZRFoq
         yjfTfJ/pAyFVanARFs6IdelpJi5hCTM3t1CJxfKU=
Date:   Sat, 27 Apr 2019 08:28:02 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     stable@vger.kernel.org, netfilter-devel@vger.kernel.org,
        nevola@gmail.com
Subject: Re: Netfilter fixes for 4.19 -stable
Message-ID: <20190427122802.GC17719@sasha-vm>
References: <20190426183219.7drkaomdhojwsc22@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20190426183219.7drkaomdhojwsc22@salvia>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, Apr 26, 2019 at 08:32:19PM +0200, Pablo Neira Ayuso wrote:
>Hi Sasha,
>
>Via Laura Garcia.
>
>Could you cherry-pick the following netfilter fixes for 4.19 -stable?
>
>https://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git/commit/net/netfilter/nft_compat.c?id=12c44aba6618b7f6c437076e5722237190f6cd5f
>commit    12c44aba6618b7f6c437076e5722237190f6cd5f
>netfilter: nft_compat: use refcnt_t type for nft_xt reference count
>
>https://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git/commit/net/netfilter/nft_compat.c?id=cf52572ebbd7189a1966c2b5fc34b97078cd1dce
>commit    cf52572ebbd7189a1966c2b5fc34b97078cd1dce
>netfilter: nft_compat: make lists per netns
>
>https://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git/commit/net/netfilter/nft_compat.c?id=b2e3d68d1251a051a620f9086e18f7ffa6833b5b
>commit    b2e3d68d1251a051a620f9086e18f7ffa6833b5b
>netfilter: nft_compat: destroy function must not have side effects
>
>https://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git/commit/net/netfilter/nf_tables_api.c?id=cd5125d8f51882279f50506bb9c7e5e89dc9bef3
>commit    cd5125d8f51882279f50506bb9c7e5e89dc9bef3
>netfilter: nf_tables: split set destruction in deactivate and destroy phase
>
>https://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git/commit/net/netfilter/nft_compat.c?id=f6ac8585897684374a19863fff21186a05805286
>commit    f6ac8585897684374a19863fff21186a05805286
>netfilter: nf_tables: unbind set in rule from commit path
>
>https://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git/commit/net/netfilter/nft_compat.c?id=947e492c0fc2132ae5fca081a9c2952ccaab0404
>commit    947e492c0fc2132ae5fca081a9c2952ccaab0404
>netfilter: nft_compat: don't use refcount_inc on newly allocated entry
>
>https://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git/commit/net/netfilter/nf_tables_api.c?id=b8e204006340b7aaf32bd2b9806c692f6e0cb38a
>commit    b8e204006340b7aaf32bd2b9806c692f6e0cb38a
>netfilter: nft_compat: use .release_ops and remove list of extension
>
>https://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git/commit/net/netfilter/nf_tables_api.c?id=40ba1d9b4d19796afc9b7ece872f5f3e8f5e2c13
>commit    40ba1d9b4d19796afc9b7ece872f5f3e8f5e2c13
>netfilter: nf_tables: fix set double-free in abort path
>
>https://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git/commit/net/netfilter/nf_tables_api.c?id=273fe3f1006ea5ebc63d6729e43e8e45e32b256a
>commit    273fe3f1006ea5ebc63d6729e43e8e45e32b256a
>netfilter: nf_tables: bogus EBUSY when deleting set after flush
>
>https://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git/commit/net/netfilter/nft_objref.c?id=8ffcd32f64633926163cdd07a7d295c500a947d1
>commit    8ffcd32f64633926163cdd07a7d295c500a947d1
>netfilter: nf_tables: bogus EBUSY in helper removal from transaction

I've had to play a bit with the ordering, but queued them all up,
thanks!

--
Thanks,
Sasha
