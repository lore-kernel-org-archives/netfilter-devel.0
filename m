Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B990AE748FC
	for <netfilter-devel@archiver.kernel.org>; Mon,  2 Oct 2023 16:48:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238281AbjJBQsn (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 2 Oct 2023 12:48:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237844AbjJBQsm (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 2 Oct 2023 12:48:42 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03102A9;
        Mon,  2 Oct 2023 09:48:39 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1qnM60-0002xv-B8; Mon, 02 Oct 2023 18:48:36 +0200
Date:   Mon, 2 Oct 2023 18:48:36 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     Florian Westphal <fw@strlen.de>,
        network dev <netdev@vger.kernel.org>,
        netfilter-devel@vger.kernel.org, linux-sctp@vger.kernel.org,
        davem@davemloft.net, kuba@kernel.org,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Subject: Re: [PATCH nf] netfilter: handle the connecting collision properly
 in nf_conntrack_proto_sctp
Message-ID: <20231002164836.GA9274@breakpoint.cc>
References: <6ee630f777cada3259b29e732e7ea9321a99197b.1696172868.git.lucien.xin@gmail.com>
 <CADvbK_fE2KGLtqBxFUVikrCxkRjG_eodeHjRuMGWU=og_qk9_A@mail.gmail.com>
 <20231002151808.GD30843@breakpoint.cc>
 <CADvbK_edFWwc3JGyyexCw+vKbpKsbftRDZD34sjRXCCWtGYLYg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CADvbK_edFWwc3JGyyexCw+vKbpKsbftRDZD34sjRXCCWtGYLYg@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Xin Long <lucien.xin@gmail.com> wrote:
> On Mon, Oct 2, 2023 at 11:18 AM Florian Westphal <fw@strlen.de> wrote:
> >
> > Xin Long <lucien.xin@gmail.com> wrote:
> > > a reproducer is attached.
> > >
> > > Thanks.
> >
> > Do you think its worth it to turn this into a selftest?
> I think so, it's a typical SCTP collision scenario, if it's okay to you
> I'd like to add this to:
> 
> tools/testing/selftests/netfilter/conntrack_sctp_collision.sh

LGTM, thanks!

> should I repost this netfilter patch together with this selftest or I
> can post this selftest later?

Posting it later is fine.
