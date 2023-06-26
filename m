Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6E02EB64D7
	for <netfilter-devel@archiver.kernel.org>; Mon, 26 Jun 2023 15:16:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230336AbjFZPQN (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 26 Jun 2023 11:16:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230394AbjFZPQM (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 26 Jun 2023 11:16:12 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4C6EC10DC
        for <netfilter-devel@vger.kernel.org>; Mon, 26 Jun 2023 08:16:07 -0700 (PDT)
Date:   Mon, 26 Jun 2023 17:16:03 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Jeremy Sowden <jeremy@azazel.net>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH nf v2] lib/ts_bm: reset initial match offset for every
 block of text
Message-ID: <ZJmrs+G4mNuoVnMs@calendula>
References: <20230619190657.1905910-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230619190657.1905910-1-jeremy@azazel.net>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, Jun 19, 2023 at 08:06:57PM +0100, Jeremy Sowden wrote:
> The `shift` variable which indicates the offset in the string at which
> to start matching the pattern is initialized to `bm->patlen - 1`, but it
> is not reset when a new block is retrieved.  This means the implemen-
> tation may start looking at later and later positions in each successive
> block and miss occurrences of the pattern at the beginning.  E.g.,
> consider a HTTP packet held in a non-linear skb, where the HTTP request
> line occurs in the second block:
> 
>   [... 52 bytes of packet headers ...]
>   GET /bmtest HTTP/1.1\r\nHost: www.example.com\r\n\r\n
> 
> and the pattern is "GET /bmtest".
> 
> Once the first block comprising the packet headers has been examined,
> `shift` will be pointing to somewhere near the end of the block, and so
> when the second block is examined the request line at the beginning will
> be missed.
> 
> Reinitialize the variable for each new block.

Applied to nf.git, thanks
