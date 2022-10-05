Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64DCFC433FE
	for <netfilter-devel@archiver.kernel.org>; Wed,  5 Oct 2022 22:53:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229463AbiJEWxg (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 5 Oct 2022 18:53:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229534AbiJEWxg (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 5 Oct 2022 18:53:36 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8F7E82B63A
        for <netfilter-devel@vger.kernel.org>; Wed,  5 Oct 2022 15:53:30 -0700 (PDT)
Date:   Thu, 6 Oct 2022 00:53:27 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft 2/2] src: add ipip support
Message-ID: <Yz4K58ugmtD/U7gD@salvia>
References: <20221005224833.24056-1-pablo@netfilter.org>
 <20221005224833.24056-3-pablo@netfilter.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20221005224833.24056-3-pablo@netfilter.org>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Oct 06, 2022 at 12:48:33AM +0200, Pablo Neira Ayuso wrote:
> This generates an implicit dependency on NFT_META_L4PROTO for IPPROTO_IP.

s/IPPROTO_IP/IPPROTO_IPIP

> This does _not_ generate a dependendy for NFT_META_PROTOCOL on 0x800 (ip)
> because the tunnel protocol driver "ip6tnl" in the tree uses IPPROTO_IP

again:

s/IPPROTO_IP/IPPROTO_IPIP

> for IPv4 over IPv6 (ipip6).
