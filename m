Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82DD6C433EF
	for <netfilter-devel@archiver.kernel.org>; Thu, 20 Jan 2022 10:57:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229971AbiATK5g (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 20 Jan 2022 05:57:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230007AbiATK5c (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 20 Jan 2022 05:57:32 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5B2AC061574
        for <netfilter-devel@vger.kernel.org>; Thu, 20 Jan 2022 02:57:32 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1nAV8F-0002Ox-8L; Thu, 20 Jan 2022 11:57:31 +0100
Date:   Thu, 20 Jan 2022 11:57:31 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Jeremy Sowden <jeremy@azazel.net>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: Re: [iptables PATCH] extensions: libxt_NFLOG: fix typo
Message-ID: <20220120105731.GD31905@breakpoint.cc>
References: <20220120105405.2738662-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220120105405.2738662-1-jeremy@azazel.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Jeremy Sowden <jeremy@azazel.net> wrote:
> The deprecation warning for `--nflog-range` contains a spelling mistake.
> Fix it.

applied, thanks.
