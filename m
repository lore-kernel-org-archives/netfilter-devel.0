Return-Path: <SRS0=CfkY=DQ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95696C433DF
	for <netfilter-devel@archiver.kernel.org>; Fri,  9 Oct 2020 20:08:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 58BE72053B
	for <netfilter-devel@archiver.kernel.org>; Fri,  9 Oct 2020 20:08:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391228AbgJIUIo (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 9 Oct 2020 16:08:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388178AbgJIUF7 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 9 Oct 2020 16:05:59 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29AFCC0613D5;
        Fri,  9 Oct 2020 13:05:59 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1kQyeC-0001He-AQ; Fri, 09 Oct 2020 22:05:48 +0200
Date:   Fri, 9 Oct 2020 22:05:48 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Jozsef Kadlecsik <kadlec@netfilter.org>
Cc:     Florian Westphal <fw@strlen.de>,
        Francesco Ruggeri <fruggeri@arista.com>,
        open list <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>, coreteam@netfilter.org,
        netfilter-devel@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf v2] netfilter: conntrack: connection timeout after
 re-register
Message-ID: <20201009200548.GG5723@breakpoint.cc>
References: <20201007193252.7009D95C169C@us180.sjc.aristanetworks.com>
 <CA+HUmGhBxBHU85oFfvoAyP=hG17DG2kgO67eawk1aXmSjehOWQ@mail.gmail.com>
 <alpine.DEB.2.23.453.2010090838430.19307@blackhole.kfki.hu>
 <20201009110323.GC5723@breakpoint.cc>
 <alpine.DEB.2.23.453.2010092035550.19307@blackhole.kfki.hu>
 <20201009185552.GF5723@breakpoint.cc>
 <alpine.DEB.2.23.453.2010092132220.19307@blackhole.kfki.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.23.453.2010092132220.19307@blackhole.kfki.hu>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Jozsef Kadlecsik <kadlec@netfilter.org> wrote:
> > The "delay unregister" remark was wrt. the "all rules were deleted"
> > case, i.e. add a "grace period" rather than acting right away when
> > conntrack use count did hit 0.
> 
> Now I understand it, thanks really. The hooks are removed, so conntrack 
> cannot "see" the packets and the entries become stale. 

Yes.

> What is the rationale behind "remove the conntrack hooks when there are no 
> rule left referring to conntrack"? Performance optimization? But then the 
> content of the whole conntrack table could be deleted too... ;-)

Yes, this isn't the case at the moment -- only hooks are removed,
entries will eventually time out.

> > Conntrack entries are not removed, only the base hooks get unregistered. 
> > This is a problem for tcp window tracking.
> > 
> > When re-register occurs, kernel is supposed to switch the existing 
> > entries to "loose" mode so window tracking won't flag packets as 
> > invalid, but apparently this isn't enough to handle keepalive case.
> 
> "loose" (nf_ct_tcp_loose) mode doesn't disable window tracking, it 
> enables/disables picking up already established connections. 
> 
> nf_ct_tcp_be_liberal would disable TCP window checking (but not tracking) 
> for non RST packets.

You are right, mixup on my part.

> But both seems to be modified only via the proc entries.

Yes, we iterate table on re-register and modify the existing entries.
