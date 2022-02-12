Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1650C433EF
	for <netfilter-devel@archiver.kernel.org>; Sat, 12 Feb 2022 00:02:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354316AbiBLACi (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 11 Feb 2022 19:02:38 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:49780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242360AbiBLACg (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 11 Feb 2022 19:02:36 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4387BD6C
        for <netfilter-devel@vger.kernel.org>; Fri, 11 Feb 2022 16:02:33 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1nIfrv-0003VH-8p; Sat, 12 Feb 2022 01:02:28 +0100
Date:   Sat, 12 Feb 2022 01:02:27 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, eric.dumazet@gmail.com,
        fw@strlen.de
Subject: Re: [PATCH nf] netfilter: xt_socket: missing ifdef
 CONFIG_IP6_NF_IPTABLES dependency
Message-ID: <20220212000227.GA6497@breakpoint.cc>
References: <20220211235609.218507-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220211235609.218507-1-pablo@netfilter.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> nf_defrag_ipv6_disable() requires CONFIG_IP6_NF_IPTABLES.

Indeed, thanks for the fix.

Acked-by: Florian Westphal <fw@strlen.de>
