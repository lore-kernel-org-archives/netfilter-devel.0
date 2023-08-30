Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F69AC6FA8F
	for <netfilter-devel@archiver.kernel.org>; Wed, 30 Aug 2023 23:00:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344278AbjH3XAA (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 30 Aug 2023 19:00:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230350AbjH3XAA (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 30 Aug 2023 19:00:00 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D6EDE70;
        Wed, 30 Aug 2023 15:59:33 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1qbU9h-0004AB-TW; Thu, 31 Aug 2023 00:59:21 +0200
Date:   Thu, 31 Aug 2023 00:59:21 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Wander Lairson Costa <wander@redhat.com>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "open list:NETFILTER" <netfilter-devel@vger.kernel.org>,
        "open list:NETFILTER" <coreteam@netfilter.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Lucas Leong <wmliang@infosec.exchange>, stable@kernel.org
Subject: Re: [PATCH nf] netfilter/osf: avoid OOB read
Message-ID: <20230830225921.GA15759@breakpoint.cc>
References: <20230830205554.97083-2-wander@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230830205554.97083-2-wander@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Wander Lairson Costa <wander@redhat.com> wrote:
> The opt_num field is controlled by user mode and is not currently
> validated inside the kernel. An attacker can take advantage of this to
> trigger an OOB read and potentially leak information.

[..]

Can you send a v2 that rejects bogus nf_osf_user_finger structs?

nfnl_osf_add_callback() seems to be the right place to refuse it.
