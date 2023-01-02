Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 252CBC3DA7A
	for <netfilter-devel@archiver.kernel.org>; Mon,  2 Jan 2023 15:04:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233341AbjABPE5 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 2 Jan 2023 10:04:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235976AbjABPEz (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 2 Jan 2023 10:04:55 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 544847659
        for <netfilter-devel@vger.kernel.org>; Mon,  2 Jan 2023 07:04:54 -0800 (PST)
Date:   Mon, 2 Jan 2023 16:04:51 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft,v2 00/16] vxlan, geneve, gre, gretap matching support
Message-ID: <Y7LykwhYJI6ZUg2Y@salvia>
References: <20221017110408.742223-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20221017110408.742223-1-pablo@netfilter.org>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, Oct 17, 2022 at 01:03:52PM +0200, Pablo Neira Ayuso wrote:
> Hi,
> 
> The following patchset adds support for vxlan, geneve, gre and gretap.
> This patchset includes tests and documentation update.

This is now applied to nftables.git repository now that 6.2-rc is out.

This batch is missing support for:

-j/--json
-o/--optimize

At least -o should be easy to add.

-j requires a bit more work, I am considering two possibilities with
this: either add "tunnel" field to "payload" or use "vxlan ip" in the
existing "protocol" field. I have not yet evaluated the up/down sides
of any these options for the json support.
