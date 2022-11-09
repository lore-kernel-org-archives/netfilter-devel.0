Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85E1FC433FE
	for <netfilter-devel@archiver.kernel.org>; Wed,  9 Nov 2022 15:08:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231831AbiKIPIZ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 9 Nov 2022 10:08:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231882AbiKIPIY (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 9 Nov 2022 10:08:24 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2BB856474
        for <netfilter-devel@vger.kernel.org>; Wed,  9 Nov 2022 07:08:22 -0800 (PST)
Date:   Wed, 9 Nov 2022 16:08:18 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Jeremy Sowden <jeremy@azazel.net>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH ulogd2] doc: mysql: declare MAC protocol columns unsigned
Message-ID: <Y2vCYinfGfhRyN+K@salvia>
References: <20221105165403.2355665-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20221105165403.2355665-1-jeremy@azazel.net>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Sat, Nov 05, 2022 at 04:54:02PM +0000, Jeremy Sowden wrote:
> By default, MySQL smallints are signed.  This causes problems inserting packets
> for ethertypes above 0x7fff, such as IPv6 (0x86dd):
> 
>   MariaDB [ulogd]> SELECT INSERT_PACKET_FULL(...,'f4:7b:09:41:7a:71','f0:2f:74:4e:b2:f3',34525,0,NULL,NULL,NULL);
>                                                                                          ^^^^^
> 
> which fails as follows:
> 
>   ERROR 1264 (22003): Out of range value for column 'mac_protocol' at row 1

Applied, thanks
