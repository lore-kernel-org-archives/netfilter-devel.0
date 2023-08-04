Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59A9DC001DB
	for <netfilter-devel@archiver.kernel.org>; Fri,  4 Aug 2023 19:41:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229656AbjHDTlA (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 4 Aug 2023 15:41:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229379AbjHDTk7 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 4 Aug 2023 15:40:59 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FFE3E7;
        Fri,  4 Aug 2023 12:40:58 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1qS0fP-0007ip-9T; Fri, 04 Aug 2023 21:40:55 +0200
Date:   Fri, 4 Aug 2023 21:40:55 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Maciej =?utf-8?Q?=C5=BBenczykowski?= <maze@google.com>
Cc:     Florian Westphal <fw@strlen.de>, coreteam@netfilter.org,
        kadlec@netfilter.org, Pablo Neira Ayuso <pablo@netfilter.org>,
        Linux Network Development Mailing List 
        <netdev@vger.kernel.org>,
        Netfilter Development Mailing List 
        <netfilter-devel@vger.kernel.org>, Martin KaFai Lau <kafai@fb.com>
Subject: Re: [PATCH netfilter] netfilter: nfnetlink_log: always add a
 timestamp
Message-ID: <20230804194055.GO30550@breakpoint.cc>
References: <20230725085443.2102634-1-maze@google.com>
 <20230727135825.GF2963@breakpoint.cc>
 <CANP3RGfL1k6g8XCi50iEMEYwOfsMmr-y-KB=0N=jGV8hzcoSeA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CANP3RGfL1k6g8XCi50iEMEYwOfsMmr-y-KB=0N=jGV8hzcoSeA@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Maciej Żenczykowski <maze@google.com> wrote:
> On Thu, Jul 27, 2023 at 3:58 PM Florian Westphal <fw@strlen.de> wrote:
> >
> > Maciej Żenczykowski <maze@google.com> wrote:
> > > Compared to all the other work we're already doing to deliver
> > > an skb to userspace this is very cheap - at worse an extra
> > > call to ktime_get_real() - and very useful.
> >
> > Reviewed-by: Florian Westphal <fw@strlen.de>
> 
> I'm not sure if there's anything else that needs to happen for this to
> get merged.

This is fine, it'll be merged for -next.
