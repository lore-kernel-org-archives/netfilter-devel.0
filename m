Return-Path: <SRS0=TR/Z=U2=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3CB1DC48BE4
	for <netfilter-devel@archiver.kernel.org>; Thu, 27 Jun 2019 19:21:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 143CD208CB
	for <netfilter-devel@archiver.kernel.org>; Thu, 27 Jun 2019 19:21:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726463AbfF0TVN (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 27 Jun 2019 15:21:13 -0400
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:50334 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726426AbfF0TVN (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 27 Jun 2019 15:21:13 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.89)
        (envelope-from <fw@strlen.de>)
        id 1hgZxF-0005gn-G1; Thu, 27 Jun 2019 21:21:09 +0200
Date:   Thu, 27 Jun 2019 21:21:09 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Florian Westphal <fw@strlen.de>,
        Ibrahim Ercan <ibrahim.ercan@labristeknoloji.com>,
        netfilter-devel@vger.kernel.org, ibrahim.metu@gmail.com
Subject: Re: [PATCH v2] netfilter: synproxy: erroneous TCP mss option fixed.
Message-ID: <20190627192109.zpkn2vff3ykin6ya@breakpoint.cc>
References: <CAK6Qs9k_bdU9ZL4WRXBGYdtfnP_qhot0hzC=uMQG6C_pkz3+2w@mail.gmail.com>
 <1561441324-19193-1-git-send-email-ibrahim.ercan@labristeknoloji.com>
 <20190627185744.ynxyes7an6gd7hlg@salvia>
 <20190627190019.hrlowm5lxw7grmsk@breakpoint.cc>
 <20190627190857.f6lwop54735wo6dg@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190627190857.f6lwop54735wo6dg@salvia>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Thu, Jun 27, 2019 at 09:00:19PM +0200, Florian Westphal wrote:
> > Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > > >  		opts.options &= info->options;
> > > > +		client_mssinfo = opts.mss;
> > > > +		opts.mss = info->mss;
> > > 
> > > No need for this new client_mssinfo variable, right? I mean, you can
> > > just set:
> > > 
> > >         opts.mss = info->mss;
> > > 
> > > and use it from synproxy_send_client_synack().
> > 
> > I thought that as well but we need both mss values,
> > the one configured in the target (info->mss) and the
> > ine received from the peer.
> > 
> > The former is what we announce to peer in the syn/ack
> > (as tcp option), the latter is what we need to encode
> > in the syncookie (to decode it on cookie ack).
> 
> I see, probably place client_mss field into the synproxy_options
> structure?

I worked on a fix for this too (Ibrahim was faster), I
tried to rename opts.mss so we have

u16 mss_peer;
u16 mss_configured;

but I got confused myself as to where which mss is to be used.

perhaps
u16 mss_option;
u16 mss_encode;

... would have been better.
