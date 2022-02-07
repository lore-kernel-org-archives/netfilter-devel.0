Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A173C4167B
	for <netfilter-devel@archiver.kernel.org>; Mon,  7 Feb 2022 14:18:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237570AbiBGOSC convert rfc822-to-8bit (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 7 Feb 2022 09:18:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1390301AbiBGN5W (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 7 Feb 2022 08:57:22 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D2A7C03FEDE
        for <netfilter-devel@vger.kernel.org>; Mon,  7 Feb 2022 05:57:02 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1nH4Vf-0007KN-2n; Mon, 07 Feb 2022 14:56:51 +0100
Date:   Mon, 7 Feb 2022 14:56:51 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Pierre Ducroquet <pducroquet@entrouvert.com>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [Patch] document nft statements undefine/redefine
Message-ID: <20220207135651.GC25000@breakpoint.cc>
References: <17129011.jtLeUFmENV@entrouvert-pierred>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <17129011.jtLeUFmENV@entrouvert-pierred>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Pierre Ducroquet <pducroquet@entrouvert.com> wrote:
> I found out that two statements, undefine and redefine, have been added to the 
> nft language a while ago (2018) but not documented then.
> Cf. https://patchwork.ozlabs.org/project/netfilter-devel/patch/
> 3622208.jy4NlOniyd@voxel/
> 
> The attached patch adds a basic documentation of this feature.

Applied, thanks.
