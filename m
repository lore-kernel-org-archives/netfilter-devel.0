Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5A81C678D4
	for <netfilter-devel@archiver.kernel.org>; Tue,  7 Mar 2023 09:57:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230352AbjCGJ5m (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 7 Mar 2023 04:57:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230413AbjCGJ5i (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 7 Mar 2023 04:57:38 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 12E5759E55;
        Tue,  7 Mar 2023 01:57:28 -0800 (PST)
Date:   Tue, 7 Mar 2023 10:57:24 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Eric Dumazet <edumazet@google.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Florian Westphal <fw@strlen.de>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, eric.dumazet@gmail.com
Subject: Re: [PATCH net] netfilter: conntrack:
Message-ID: <ZAcKhAearHVExvfX@salvia>
References: <20230307052254.198305-1-edumazet@google.com>
 <CANn89i+sfROgQUaNR+eMc2BWxtOjMmLgqsv52A1iLGhyydrBbg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CANn89i+sfROgQUaNR+eMc2BWxtOjMmLgqsv52A1iLGhyydrBbg@mail.gmail.com>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Mar 07, 2023 at 06:27:37AM +0100, Eric Dumazet wrote:
> On Tue, Mar 7, 2023 at 6:22 AM Eric Dumazet <edumazet@google.com> wrote:
> >
> > Customers using GKE 1.25 and 1.26 are facing conntrack issues
> > root caused to commit c9c3b6811f74 ("netfilter: conntrack: make
> > max chain length random").
> >
> > Even if we assume Uniform Hashing, a bucket often reachs 8 chained
> > items while the load factor of the hash table is smaller than 0.5
> >
> 
> Sorry for the messed patch title.
> 
> This should have been:
> 
> netfilter: conntrack: adopt safer max chain length
> 
> Florian, Pablo, let me know if you want me to send a v2, thanks !

Applied, thanks
