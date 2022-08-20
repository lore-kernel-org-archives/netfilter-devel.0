Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 135E8C25B08
	for <netfilter-devel@archiver.kernel.org>; Sat, 20 Aug 2022 16:27:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345955AbiHTQ1T (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 20 Aug 2022 12:27:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229605AbiHTQ1T (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 20 Aug 2022 12:27:19 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB0F55927D;
        Sat, 20 Aug 2022 09:27:17 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1oPRJJ-0006ky-Aj; Sat, 20 Aug 2022 18:26:57 +0200
Date:   Sat, 20 Aug 2022 18:26:57 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Cc:     syzkaller@googlegroups.com, george.kennedy@oracle.com,
        vegard.nossum@oracle.com, john.p.donnelly@oracle.com,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        bridge@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] netfilter: ebtables: fix a NULL pointer dereference in
 ebt_do_table()
Message-ID: <YwELUWJw1qTatIiI@strlen.de>
References: <20220820070331.48817-1-harshit.m.mogalapalli@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220820070331.48817-1-harshit.m.mogalapalli@oracle.com>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com> wrote:
> In ebt_do_table() function dereferencing 'private->hook_entry[hook]'
> can lead to NULL pointer dereference. So add a check to prevent that.

This looks incorrect, i.e. paperimg over the problem.

If hook_entry[hook] is NULL, how did this make it to the eval loop?

I guess ebtables lacks a sanity check on incoming ruleset?
