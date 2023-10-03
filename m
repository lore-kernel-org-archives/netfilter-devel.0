Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B407E7AD58
	for <netfilter-devel@archiver.kernel.org>; Tue,  3 Oct 2023 14:23:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239157AbjJCOXw (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 3 Oct 2023 10:23:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238685AbjJCOXw (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 3 Oct 2023 10:23:52 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0E71A3;
        Tue,  3 Oct 2023 07:23:46 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1qngJL-0002O4-4o; Tue, 03 Oct 2023 16:23:43 +0200
Date:   Tue, 3 Oct 2023 16:23:43 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     Simon Horman <horms@kernel.org>,
        network dev <netdev@vger.kernel.org>,
        netfilter-devel@vger.kernel.org, linux-sctp@vger.kernel.org,
        davem@davemloft.net, kuba@kernel.org,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Subject: Re: [PATCH nf] netfilter: handle the connecting collision properly
 in nf_conntrack_proto_sctp
Message-ID: <20231003142343.GA8405@breakpoint.cc>
References: <6ee630f777cada3259b29e732e7ea9321a99197b.1696172868.git.lucien.xin@gmail.com>
 <ZRwOVyKQR8MBjpBh@kernel.org>
 <CADvbK_fK03UO3R=70J+VoGVm_LJuzZbh+_=0doceS8DCPJYBVA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CADvbK_fK03UO3R=70J+VoGVm_LJuzZbh+_=0doceS8DCPJYBVA@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Xin Long <lucien.xin@gmail.com> wrote:
> > The type of vtag is u32. But the type of ct->proto.sctp.vtag[!dir] and init_tag
> > is __be32. This doesn't seem right (and makes Sparse unhappy).
> You're right, I will fix it and re-post with tag:
> 
> Fixes: 9fb9cbb1082d ("[NETFILTER]: Add nf_conntrack subsystem.")

I'm fine with this, the bug is likely inherited from
ipt_conntrack_sctp.c, but that doesn't exist anymore.

Would you also fix up the __be32/u32 confusion?

Better to not add more sparse warnings...

Thanks!
