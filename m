Return-Path: <SRS0=dQkn=A4=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 744AEC433DF
	for <netfilter-devel@archiver.kernel.org>; Fri, 17 Jul 2020 10:06:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4CCFA20768
	for <netfilter-devel@archiver.kernel.org>; Fri, 17 Jul 2020 10:06:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726104AbgGQKGv (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 17 Jul 2020 06:06:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726040AbgGQKGu (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 17 Jul 2020 06:06:50 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A70BC061755
        for <netfilter-devel@vger.kernel.org>; Fri, 17 Jul 2020 03:06:50 -0700 (PDT)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1jwNGS-0008Ts-IL; Fri, 17 Jul 2020 12:06:48 +0200
Date:   Fri, 17 Jul 2020 12:06:48 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [nf-next PATCH] netfilter: include: uapi: Use C99 flexible array
 member
Message-ID: <20200717100648.GE23632@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
References: <20200713111552.25399-1-phil@nwl.cc>
 <20200715181433.GA17636@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200715181433.GA17636@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Pablo,

On Wed, Jul 15, 2020 at 08:14:33PM +0200, Pablo Neira Ayuso wrote:
> On Mon, Jul 13, 2020 at 01:15:52PM +0200, Phil Sutter wrote:
> [...]
> > Avoid this warning by declaring 'entries' as an ISO C99 flexible array
> > member. This makes gcc aware of the intended use and enables sanity
> > checking as described in:
> > https://gcc.gnu.org/onlinedocs/gcc/Zero-Length.html
> > 
> > Signed-off-by: Phil Sutter <phil@nwl.cc>
> > ---
> >  include/uapi/linux/netfilter_ipv4/ip_tables.h  | 2 +-
> >  include/uapi/linux/netfilter_ipv6/ip6_tables.h | 2 +-
> >  2 files changed, 2 insertions(+), 2 deletions(-)
> > 
> > diff --git a/include/uapi/linux/netfilter_ipv4/ip_tables.h b/include/uapi/linux/netfilter_ipv4/ip_tables.h
> > index 50c7fee625ae9..1a298cc7a29c1 100644
> > --- a/include/uapi/linux/netfilter_ipv4/ip_tables.h
> > +++ b/include/uapi/linux/netfilter_ipv4/ip_tables.h
> > @@ -203,7 +203,7 @@ struct ipt_replace {
> >  	struct xt_counters __user *counters;
> >  
> >  	/* The entries (hang off end: not really an array). */
> > -	struct ipt_entry entries[0];
> > +	struct ipt_entry entries[];
> 
> arpt_replace uses this idiom too.

Oh, indeed. I focussed on those cases gcc complained about when
compiling iptables. Grepping for '\[0\]' in all of
include/uapi/linux/netfilter* reveals a few more cases. Do you think
it's worth "fixing" those as well?

Thanks, Phil
