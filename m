Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36636EB64DA
	for <netfilter-devel@archiver.kernel.org>; Mon, 26 Jun 2023 15:27:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229943AbjFZP1H (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 26 Jun 2023 11:27:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229841AbjFZP1F (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 26 Jun 2023 11:27:05 -0400
Received: from out1-smtp.messagingengine.com (out1-smtp.messagingengine.com [66.111.4.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDB24191;
        Mon, 26 Jun 2023 08:27:04 -0700 (PDT)
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id DCFCB5C00AE;
        Mon, 26 Jun 2023 11:27:03 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute2.internal (MEProxy); Mon, 26 Jun 2023 11:27:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=cc
        :cc:content-type:content-type:date:date:from:from:in-reply-to
        :in-reply-to:message-id:mime-version:references:reply-to:sender
        :subject:subject:to:to; s=fm2; t=1687793223; x=1687879623; bh=qt
        tqZXpSKamB5otZ32d+y05MeuHZ42ualfyqG20dva8=; b=mrF1N8lgLHacCt/fqn
        wxy5vWa8pENl7uOfgUjwbLujjul7crL4qnp6GrR/H/q1aOmOMkInjGtaBKT7wO7z
        fr4G6uE37vM3vnAMWlHZagItvgNL+XxtH9iiOLnaNoqP4F+nStgu55ivIe56fXw3
        ZlkG8VUCMEEL6uqz+Jb7Rd8Xi5+rrbq9bAkOigyNozeMSZz51aa7yLS7Tmx+CPb9
        NjUAfToQ3wCNjPPedgQhhUeAb3ci2s2ga2Dx4Lx5IFZYq4AgI9yj2DWyt59lzjtm
        tMFHMpRpUFuY4DO/2kTiiFfBJL7GsNiY3lS1bHk8VXDAHpj/7fNeTj7H9vSDZFtz
        JP6g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:content-type:date:date
        :feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm2; t=1687793223; x=1687879623; bh=qttqZXpSKamB5
        otZ32d+y05MeuHZ42ualfyqG20dva8=; b=Onot+tS/VsTc9E6iTmQbopr2P9vVF
        cypeeRzxZz7Nc5TdTiZQVEpAmN0HtXZKdIHf4cqZkJLOr4sXWh/CetIAui0Xj+uF
        4kdEsz/cVqfSMq7NkxQfe7YouGZ6/FB4IPAZgY6A8McyIh/WxtlgAZnpFKiNUfsP
        vy2sK2LJq/l64t1+gDxsKOFbIWaFtBqtU8JRAmElzlcbOobLvs/jz7tmg0wcWfsM
        2wcAxp7O8NMWUyNTMVnyf48uBNL1SRf/bv47cy06XIu18eIZMueYLdf8JKMn4KE/
        sjF/kV94gxU1JEEENw4bxhas1uotVMm7wOCUR7zFDmXqOAugMx4McqYMA==
X-ME-Sender: <xms:R66ZZLEcpsgXr37KuHez6SSEpFhXrp9fVOce0wngCM68QmyI7zfGcQ>
    <xme:R66ZZIVZo-WBpV12u_zXM6RHuMf830pjJ3FLoG7B-wbXu_9sW0NEchEvt5xrN8D7L
    vlG6mPO3GdUpA>
X-ME-Received: <xmr:R66ZZNLz9lzlOwkZgM5O4E0GI2IPkMHKwk-yyUGZ6gHAfoKIrzS_Rl5kKQb6_eXuqefLJzKTVmmjI24yRq20X-96hkTjaWy55SXZJQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrgeehfedgkeehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvfevuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghg
    ucfmjfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepheegvd
    evvdeljeeugfdtudduhfekledtiefhveejkeejuefhtdeufefhgfehkeetnecuvehluhhs
    thgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorg
    hhrdgtohhm
X-ME-Proxy: <xmx:R66ZZJHor5rC8l6ozIkSAjZukD5nS97TYyGySMGw2f97aYpWKmEZ0A>
    <xmx:R66ZZBUQyEfos6pa2IovLClngpw12L0rn_M8LG50ZLhipCj0I9A0vA>
    <xmx:R66ZZENT5NilCbx8iJJg60WzgPh8Xc9LVCKT36nZX9UYNmre0sNcQQ>
    <xmx:R66ZZDIQCEppl8BC74InKRK4NYh6D0xJ4Jm5AtpXtiZYSWC_D2b_Uw>
Feedback-ID: i787e41f1:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 26 Jun 2023 11:27:03 -0400 (EDT)
Date:   Mon, 26 Jun 2023 17:27:00 +0200
From:   Greg KH <greg@kroah.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, stable@vger.kernel.org,
        carnil@debian.org
Subject: Re: [PATCH -stable,5.10 0/3] stable fixes for 5.10
Message-ID: <2023062655-unfunded-traitor-b3f0@gregkh>
References: <20230626110506.76630-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230626110506.76630-1-pablo@netfilter.org>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, Jun 26, 2023 at 01:05:03PM +0200, Pablo Neira Ayuso wrote:
> Hi Greg, Sasha,
> 
> The following batch contains Netfilter fixes for 5.10.
> 
> Patches 1 and 2 you can manually cherry-pick them:
> 
> 1) 08a01c11a5bb ("netfilter: nftables: statify nft_parse_register()")
> 2) 98494660a286 ("netfilter: nf_tables: validate registers coming from userspace.")
> 
> Patch 3 is a backport:
> 
> 3) 99e73e80d3df ("netfilter: nf_tables: hold mutex on netns pre_exit path")
> 
> Thanks.
> 
> Pablo Neira Ayuso (3):
>   netfilter: nftables: statify nft_parse_register()
>   netfilter: nf_tables: validate registers coming from userspace.
>   netfilter: nf_tables: hold mutex on netns pre_exit path
> 
>  include/net/netfilter/nf_tables.h |  1 -
>  net/netfilter/nf_tables_api.c     | 34 +++++++++++++++++--------------
>  2 files changed, 19 insertions(+), 16 deletions(-)
> 
> -- 
> 2.30.2
> 

All now queued up, thanks.

greg k-h
