Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68AD6C6FA8E
	for <netfilter-devel@archiver.kernel.org>; Thu,  2 Mar 2023 10:43:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229540AbjCBKnn (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 2 Mar 2023 05:43:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229455AbjCBKnm (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 2 Mar 2023 05:43:42 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7150317CCF;
        Thu,  2 Mar 2023 02:43:41 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1pXgPR-0000T8-Pa; Thu, 02 Mar 2023 11:43:37 +0100
Date:   Thu, 2 Mar 2023 11:43:37 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Martin Zaharinov <micron10@gmail.com>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        netfilter <netfilter@vger.kernel.org>,
        netfilter-devel@vger.kernel.org
Subject: Re: Bug report DNAT destination not work
Message-ID: <20230302104337.GA23204@breakpoint.cc>
References: <CALidq=VJF36a6DWf8=PNahwHLJd5FKspXVJfmzK3NFCxb6zKbg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALidq=VJF36a6DWf8=PNahwHLJd5FKspXVJfmzK3NFCxb6zKbg@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Martin Zaharinov <micron10@gmail.com> wrote:
> iptables -t nat -A PREROUTING -d 100.91.1.238/32 -i bond0 -p tcp --dport
> 7878 -j DNAT --to-destination 10.240.241.99:7878
> iptables v1.8.9 (legacy): unknown option "--to-destination"
> Try `iptables -h' or 'iptables --help' for more information.

Looks like a problem with your iptables installation which can't find
libxt_DNAT.so?  In v1.8.9 this should be a symlink to libxt_NAT.so.

If you run 'iptables -j DNAT --help' and it doesn't say

"DNAT target options:" at the end then it very much looks like a
problem with your iptables installation and not the kernel.

> try with kernel 6.1.11 6.1.12 6.1.13

Tested iptables-nft and iptables-legacy on 1.8.9 with kernel 6.1.14, no problems.

There were no significant kernel changes in this area that I know of in
6.1 either.
