Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00464C433EF
	for <netfilter-devel@archiver.kernel.org>; Wed, 27 Oct 2021 22:13:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DAAF160EFE
	for <netfilter-devel@archiver.kernel.org>; Wed, 27 Oct 2021 22:13:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230110AbhJ0WP3 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 27 Oct 2021 18:15:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230097AbhJ0WP3 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 27 Oct 2021 18:15:29 -0400
Received: from bmailout2.hostsharing.net (bmailout2.hostsharing.net [IPv6:2a01:37:3000::53df:4ef0:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B865C061570
        for <netfilter-devel@vger.kernel.org>; Wed, 27 Oct 2021 15:13:03 -0700 (PDT)
Received: from h08.hostsharing.net (h08.hostsharing.net [IPv6:2a01:37:1000::53df:5f1c:0])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client CN "*.hostsharing.net", Issuer "RapidSSL TLS DV RSA Mixed SHA256 2020 CA-1" (verified OK))
        by bmailout2.hostsharing.net (Postfix) with ESMTPS id A9F22280067AF;
        Thu, 28 Oct 2021 00:13:01 +0200 (CEST)
Received: by h08.hostsharing.net (Postfix, from userid 100393)
        id 98FE64C76C; Thu, 28 Oct 2021 00:13:01 +0200 (CEST)
Date:   Thu, 28 Oct 2021 00:13:01 +0200
From:   Lukas Wunner <lukas@wunner.de>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft] src: Support netdev egress hook
Message-ID: <20211027221301.GA5956@wunner.de>
References: <20211027101715.47905-1-pablo@netfilter.org>
 <20211027121442.GA20375@wunner.de>
 <YXlUIuoRaI8WmbZT@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YXlUIuoRaI8WmbZT@salvia>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Oct 27, 2021 at 03:29:06PM +0200, Pablo Neira Ayuso wrote:
> I'll apply these two patches if you are fine with their state.

I'm fine with them.  Do you want me to resend them as patches
(instead of as attachments)?

When running tests I noted an oddity:

tests/shell/testcases/0031set_timeout_size_0 fails because
1d2h3m4s10ms is reported as 1d2h3m4s8ms, so 2 msec less.
Might be caused by the kernel I tested against (v5.13.12),
doesn't seem related to my patches, but odd nevertheless.

Thanks,

Lukas
