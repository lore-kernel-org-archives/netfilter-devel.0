Return-Path: <SRS0=xYYy=UR=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8FB20C31E51
	for <netfilter-devel@archiver.kernel.org>; Tue, 18 Jun 2019 11:59:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 61B362070B
	for <netfilter-devel@archiver.kernel.org>; Tue, 18 Jun 2019 11:59:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725988AbfFRL7H (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 18 Jun 2019 07:59:07 -0400
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:52026 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725913AbfFRL7H (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 18 Jun 2019 07:59:07 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.89)
        (envelope-from <fw@strlen.de>)
        id 1hdClV-0008Fe-45; Tue, 18 Jun 2019 13:59:05 +0200
Date:   Tue, 18 Jun 2019 13:59:05 +0200
From:   Florian Westphal <fw@strlen.de>
To:     =?utf-8?Q?=C4=B0brahim?= Ercan <ibrahim.metu@gmail.com>
Cc:     Florian Westphal <fw@strlen.de>, netfilter@vger.kernel.org,
        netfilter-devel@vger.kernel.org
Subject: Re: Is this possible SYN Proxy bug?
Message-ID: <20190618115905.6kd2hqg2hlbs5frc@breakpoint.cc>
References: <CAK6Qs9mam2U6JdeBnkzX9sfdeWWkLx_+ZgHOTmYjSC2wKfg0cQ@mail.gmail.com>
 <20190618104041.unuonhmuvgnlty3l@breakpoint.cc>
 <CAK6Qs9kmxqOaCjgcBefPR-NKEdGKTcfKUL_tu09CQYp3OT5krA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAK6Qs9kmxqOaCjgcBefPR-NKEdGKTcfKUL_tu09CQYp3OT5krA@mail.gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

İbrahim Ercan <ibrahim.metu@gmail.com> wrote:
> On Tue, Jun 18, 2019 at 1:40 PM Florian Westphal <fw@strlen.de> wrote:
> >
> > Problem is that we do not keep any state.  Syncookes are restricted to 4
> > mss value:
> > static __u16 const msstab[] = {
> >  536,
> > 1300,
> > 1440,   /* 1440, 1452: PPPoE */
> > 1460,
> > };
> >
> > So, 1260 forces lowest value supported.
> >
> > The table was based off a research paper that had mss distribution
> > tables.  Maybe more recent data is available and if things have changed
> > we could update the table accordingly.
> 
> I am confused. So this statement from manual page is just a illusion?
> --mss maximum segment size
>               Maximum segment size announced to clients. This must
> match the backend.

?

Your question was about MSS sent to server.

Flow is this:
Client          Synproxy         Server
-> Syn, mss X
    <-Synack,mss M
-> ACK
                     -> Syn, mss Y

M is what you need to configure via --mss switch.

Because Synproxy keeps no state, it can only send
to real server the MSS that was encoded in syncookie (in synack)
packet.  Therefore, X == Y only if the Value from client matches
exactly one for the four values of the mss table, in all other
cases Y is the next lowest available one.  In your case thats 536.

> I don't understand why these restriction exist. Why can't we set mss
> value same as what client send to us?

We only have 2 bits out of the 32Bit Sequence number for MSS. Increasing
mss state table reduces security margin of the cookie.
