Return-Path: <SRS0=xYYy=UR=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_NEOMUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99A74C31E51
	for <netfilter-devel@archiver.kernel.org>; Tue, 18 Jun 2019 12:40:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 79F0320679
	for <netfilter-devel@archiver.kernel.org>; Tue, 18 Jun 2019 12:40:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728018AbfFRMk3 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 18 Jun 2019 08:40:29 -0400
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:52294 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725913AbfFRMk3 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 18 Jun 2019 08:40:29 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.89)
        (envelope-from <fw@strlen.de>)
        id 1hdDPW-00008L-R5; Tue, 18 Jun 2019 14:40:26 +0200
Date:   Tue, 18 Jun 2019 14:40:26 +0200
From:   Florian Westphal <fw@strlen.de>
To:     =?utf-8?Q?=C4=B0brahim?= Ercan <ibrahim.metu@gmail.com>
Cc:     Florian Westphal <fw@strlen.de>, netfilter@vger.kernel.org,
        netfilter-devel@vger.kernel.org
Subject: Re: Is this possible SYN Proxy bug?
Message-ID: <20190618124026.4kvpdkbstdgaluij@breakpoint.cc>
References: <CAK6Qs9mam2U6JdeBnkzX9sfdeWWkLx_+ZgHOTmYjSC2wKfg0cQ@mail.gmail.com>
 <20190618104041.unuonhmuvgnlty3l@breakpoint.cc>
 <CAK6Qs9kmxqOaCjgcBefPR-NKEdGKTcfKUL_tu09CQYp3OT5krA@mail.gmail.com>
 <20190618115905.6kd2hqg2hlbs5frc@breakpoint.cc>
 <CAK6Qs9mTkAaH9+RqzmtrbNps1=NtW4c8wtJy7Kjay=r7VSJwsQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAK6Qs9mTkAaH9+RqzmtrbNps1=NtW4c8wtJy7Kjay=r7VSJwsQ@mail.gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

İbrahim Ercan <ibrahim.metu@gmail.com> wrote:
> On Tue, Jun 18, 2019 at 2:59 PM Florian Westphal <fw@strlen.de> wrote:
> 
> > >
> > > I am confused. So this statement from manual page is just a illusion?
> > > --mss maximum segment size
> > >               Maximum segment size announced to clients. This must
> > > match the backend.
> >
> > ?
> >
> > Your question was about MSS sent to server.
> >
> > Flow is this:
> > Client          Synproxy         Server
> > -> Syn, mss X
> >     <-Synack,mss M
> > -> ACK
> >                      -> Syn, mss Y
> >
> > M is what you need to configure via --mss switch.
> >
> > Because Synproxy keeps no state, it can only send
> > to real server the MSS that was encoded in syncookie (in synack)
> > packet.  Therefore, X == Y only if the Value from client matches
> > exactly one for the four values of the mss table, in all other
> > cases Y is the next lowest available one.  In your case thats 536.
> >
> > > I don't understand why these restriction exist. Why can't we set mss
> > > value same as what client send to us?
> >
> > We only have 2 bits out of the 32Bit Sequence number for MSS. Increasing
> > mss state table reduces security margin of the cookie.
> 
> My question about both way actually. If you check out my tests, M is
> also not correct. Client sends mss 1260 and syn proxy responds 1260
> too although I set mss 1460 in iptables.

Does this patch fix the problem for you?

diff --git a/net/ipv4/netfilter/ipt_SYNPROXY.c b/net/ipv4/netfilter/ipt_SYNPROXY.c
--- a/net/ipv4/netfilter/ipt_SYNPROXY.c
+++ b/net/ipv4/netfilter/ipt_SYNPROXY.c
@@ -286,6 +286,7 @@ synproxy_tg4(struct sk_buff *skb, const struct xt_action_param *par)
 			opts.options |= XT_SYNPROXY_OPT_ECN;
 
 		opts.options &= info->options;
+		opts.mss = info->mss;
 		if (opts.options & XT_SYNPROXY_OPT_TIMESTAMP)
 			synproxy_init_timestamp_cookie(info, &opts);
 		else
diff --git a/net/ipv6/netfilter/ip6t_SYNPROXY.c b/net/ipv6/netfilter/ip6t_SYNPROXY.c
--- a/net/ipv6/netfilter/ip6t_SYNPROXY.c
+++ b/net/ipv6/netfilter/ip6t_SYNPROXY.c
@@ -300,6 +300,7 @@ synproxy_tg6(struct sk_buff *skb, const struct xt_action_param *par)
 			opts.options |= XT_SYNPROXY_OPT_ECN;
 
 		opts.options &= info->options;
+		opts.mss = info->mss;
 		if (opts.options & XT_SYNPROXY_OPT_TIMESTAMP)
 			synproxy_init_timestamp_cookie(info, &opts);
 		else
