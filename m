Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B98DC7EE2C
	for <netfilter-devel@archiver.kernel.org>; Fri,  2 Jun 2023 23:22:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236211AbjFBXWY (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 2 Jun 2023 19:22:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236437AbjFBXWY (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 2 Jun 2023 19:22:24 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5FEF5194
        for <netfilter-devel@vger.kernel.org>; Fri,  2 Jun 2023 16:22:20 -0700 (PDT)
Date:   Sat, 3 Jun 2023 01:22:16 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Jeremy Sowden <jeremy@azazel.net>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH nftables v2] exthdr: add boolean DCCP option matching
Message-ID: <ZHp5qAmgHKHQ5Dqr@calendula>
References: <20230411204534.14871-1-jeremy@azazel.net>
 <ZHp5T9pWQ3u2Fugg@calendula>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ZHp5T9pWQ3u2Fugg@calendula>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Sat, Jun 03, 2023 at 01:20:50AM +0200, Pablo Neira Ayuso wrote:
> On Tue, Apr 11, 2023 at 09:45:34PM +0100, Jeremy Sowden wrote:
> > Iptables supports the matching of DCCP packets based on the presence
> > or absence of DCCP options.  Extend exthdr expressions to add this
> > functionality to nftables.
> 
> Applied, thanks.
> 
> Not related to this patch: there is 'ip options' and 'tcp option',
> probably enhance parser to allow for 'ip option' to address this
> inconsistency in the syntax?

BTW, may I add to this file:

diff --git a/src/dccpopt.c b/src/dccpopt.c
new file mode 100644
index 000000000000..3a2eb9524a20
--- /dev/null
+++ b/src/dccpopt.c

/*
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License version 2 (or any
 * later) as published by the Free Software Foundation.
 */

Thanks.
