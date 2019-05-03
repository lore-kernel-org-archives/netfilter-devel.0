Return-Path: <SRS0=n11Q=TD=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_NEOMUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7D25C43219
	for <netfilter-devel@archiver.kernel.org>; Fri,  3 May 2019 10:30:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B2804206C3
	for <netfilter-devel@archiver.kernel.org>; Fri,  3 May 2019 10:30:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727240AbfECKaL (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 3 May 2019 06:30:11 -0400
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:50446 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725777AbfECKaL (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 3 May 2019 06:30:11 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.89)
        (envelope-from <fw@strlen.de>)
        id 1hMVSC-0002kE-VV; Fri, 03 May 2019 12:30:09 +0200
Date:   Fri, 3 May 2019 12:30:08 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Florian Westphal <fw@strlen.de>
Cc:     Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>,
        pablo@netfilter.org, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf] netfilter: nf_conntrack_h323: Remove deprecated
 config check
Message-ID: <20190503103008.qp76oxyretlpf5ws@breakpoint.cc>
References: <1556853737-14697-1-git-send-email-subashab@codeaurora.org>
 <20190503101951.6ep6uroxtvyrfz4f@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190503101951.6ep6uroxtvyrfz4f@breakpoint.cc>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Florian Westphal <fw@strlen.de> wrote:
> Subash Abhinov Kasiviswanathan <subashab@codeaurora.org> wrote:
> > CONFIG_NF_CONNTRACK_IPV6 has been deprecated so replace it with
> > a check for IPV6 instead.
> 
> Right, I missed this part somehow.
> 
> > Fixes: a0ae2562c6c4b2 ("netfilter: conntrack: remove l3proto abstraction")
> > Signed-off-by: Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
> > ---
> >  include/linux/netfilter_ipv6.h         | 2 +-
> >  net/netfilter/nf_conntrack_h323_main.c | 2 +-
> >  2 files changed, 2 insertions(+), 2 deletions(-)
> > 
> > diff --git a/include/linux/netfilter_ipv6.h b/include/linux/netfilter_ipv6.h
> > index 12113e5..61f7ac9 100644
> > --- a/include/linux/netfilter_ipv6.h
> > +++ b/include/linux/netfilter_ipv6.h
> > @@ -25,7 +25,7 @@ struct ip6_rt_info {
> >   * if IPv6 is a module.
> >   */
> >  struct nf_ipv6_ops {
> > -#if IS_MODULE(CONFIG_IPV6)
> > +#if IS_ENABLED(CONFIG_IPV6)
> 
> I would prefer if we could keep this as IS_ENABLED().

Sigh, I meant 'keep IS_MODULE()'.

The callbacks protected by IS_MODULE(IPV6) are not needed when
ipv6 is builtin because the functions they would point to
can be called directly instead.

We provide wrappers to encap the 'direct or indirect call'
decision, e.g. nf_ip6_route() will use the indirection only
when ipv6 is a module.
