Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D466C6FA99
	for <netfilter-devel@archiver.kernel.org>; Sun, 12 Mar 2023 15:17:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229836AbjCLPRf (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 12 Mar 2023 11:17:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229499AbjCLPRe (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 12 Mar 2023 11:17:34 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6467EA5C4
        for <netfilter-devel@vger.kernel.org>; Sun, 12 Mar 2023 08:17:33 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1pbNRz-0005rY-0k; Sun, 12 Mar 2023 16:17:31 +0100
Date:   Sun, 12 Mar 2023 16:17:31 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Jeremy Sowden <jeremy@azazel.net>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH nf-next] netfilter: nft_exthdr: add boolean DCCP option
 matching
Message-ID: <20230312151731.GA30453@breakpoint.cc>
References: <20230312143714.158943-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230312143714.158943-1-jeremy@azazel.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Jeremy Sowden <jeremy@azazel.net> wrote:
> The xt_dccp iptables module supports the matching of DCCP packets based
> on the presence or absence of DCCP options.  Extend nft_exthdr to add
> this functionality to nftables.

Is DCCP even used in reality?
