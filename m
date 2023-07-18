Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 851D4EB64DC
	for <netfilter-devel@archiver.kernel.org>; Tue, 18 Jul 2023 18:56:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229449AbjGRS4g (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 18 Jul 2023 14:56:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229703AbjGRS4g (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 18 Jul 2023 14:56:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44357F7
        for <netfilter-devel@vger.kernel.org>; Tue, 18 Jul 2023 11:56:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D286861653
        for <netfilter-devel@vger.kernel.org>; Tue, 18 Jul 2023 18:56:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0ACADC433C8;
        Tue, 18 Jul 2023 18:56:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1689706594;
        bh=bhwIBy2XJmrRGvw+UAV1eCb/VobOIZb9vdtGEjkUtgI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=djeBSKRzlIs8iQXUL6gcxUjyucesLA2o4CsDuSmVWNjegfzCW3aqr7rIoVJOHXt/D
         gKGIqnTjzx2dNMMMJsQv7nHYVh5nY3brjd0qJVwCByLb4RO6n2XReWVDwhHxtADiIM
         a5UqndZwyF4+RWHLY+QxHbv5C2BtHJ6AtDg4HbXTJlnjIA6HKwaMN6K9m4wJqAtG1r
         tge28cpvS59C3vddS4lgKTdJlEIH5secAJgDoKXbClPD5XyvZ8dxLEWIoBN32AHfs8
         iVXX8Uiwx9DuelhYL8fff38hDZ7Ee3l/cnuprIT78rOMBGvTavCrnjftatm8ayuYKS
         M8VoKKlt17VVA==
Date:   Tue, 18 Jul 2023 11:56:33 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     <netfilter-devel@vger.kernel.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>
Subject: Re: [PATCH nf-next 1/2] netlink: allow be16 and be32 types in all
 uint policy checks
Message-ID: <20230718115633.3a15062d@kernel.org>
In-Reply-To: <20230718075234.3863-2-fw@strlen.de>
References: <20230718075234.3863-1-fw@strlen.de>
        <20230718075234.3863-2-fw@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, 18 Jul 2023 09:52:29 +0200 Florian Westphal wrote:
> __NLA_IS_BEINT_TYPE(tp) isn't useful.  NLA_BE16/32 are identical to
> NLA_U16/32, the only difference is that it tells the netlink validation
> functions that byteorder conversion might be needed before comparing
> the value to the policy min/max ones.
> 
> After this change all policy macros that can be used with UINT types,
> such as NLA_POLICY_MASK() can also be used with NLA_BE16/32.
> 
> This will be used to validate nf_tables flag attributes which
> are in bigendian byte order.

Semi-related, how well do we do with NLA_F_NET_BYTEORDER?
On a quick grep we were using it in the kernel -> user
direction but not validating on input. Is that right?
-- 
pw-bot: au
