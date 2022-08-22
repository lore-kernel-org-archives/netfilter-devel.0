Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CAC19C28D13
	for <netfilter-devel@archiver.kernel.org>; Mon, 22 Aug 2022 20:41:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234902AbiHVUlo convert rfc822-to-8bit (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 22 Aug 2022 16:41:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237572AbiHVUln (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 22 Aug 2022 16:41:43 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37E5A4507A;
        Mon, 22 Aug 2022 13:41:41 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1oQEES-0006XR-Th; Mon, 22 Aug 2022 22:41:12 +0200
Date:   Mon, 22 Aug 2022 22:41:12 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Gabriel Ryan <gabe@cs.columbia.edu>
Cc:     Florian Westphal <fw@strlen.de>,
        Abhishek Shah <abhishek.shah@columbia.edu>,
        coreteam@netfilter.org, davem@davemloft.net, edumazet@google.com,
        kadlec@netfilter.org, kuba@kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, pabeni@redhat.com,
        pablo@netfilter.org, linux-kernel@vger.kernel.org
Subject: Re: data-race in nf_tables_newtable / nf_tables_newtable
Message-ID: <20220822204112.GA19050@breakpoint.cc>
References: <CAEHB2488dNqBKcgWLSeq500JLC1+q6RV=ENcUPm=rN9bWf0QkQ@mail.gmail.com>
 <20220819123542.GA2461@breakpoint.cc>
 <CALbthtdzW-_4TVngjt-VjCS6GqCEP967-UE7oEoDkBAVaRFOzw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <CALbthtdzW-_4TVngjt-VjCS6GqCEP967-UE7oEoDkBAVaRFOzw@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Gabriel Ryan <gabe@cs.columbia.edu> wrote:
> Hi Florian,
> 
> I just looked at the lock event trace from our report and it looks
> like two distinct commit mutexes were held when the race was
> triggered. I think the race is probably on the table_handle variable
> on net/netfilter/nf_tables_api.c:1221, and not the table->handle field
> being written to.

See

https://patchwork.ozlabs.org/project/netfilter-devel/patch/20220821085939.571378-1-pablo@netfilter.org/

which makes table_handle per netns.
