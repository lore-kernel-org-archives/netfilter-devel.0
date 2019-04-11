Return-Path: <SRS0=iy/8=SN=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90C27C10F13
	for <netfilter-devel@archiver.kernel.org>; Thu, 11 Apr 2019 18:42:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6116B217F4
	for <netfilter-devel@archiver.kernel.org>; Thu, 11 Apr 2019 18:42:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=sysclose.org header.i=@sysclose.org header.b="qopOgsjF";
	dkim=pass (2048-bit key) header.d=sysclose.org header.i=@sysclose.org header.b="OX44MX8G"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726825AbfDKSl7 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 11 Apr 2019 14:41:59 -0400
Received: from smtp.sysclose.org ([69.164.214.230]:50412 "EHLO sysclose.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726738AbfDKSl6 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 11 Apr 2019 14:41:58 -0400
X-Greylist: delayed 487 seconds by postgrey-1.27 at vger.kernel.org; Thu, 11 Apr 2019 14:41:57 EDT
Received: by sysclose.org (Postfix, from userid 5001)
        id CE5AD6803; Thu, 11 Apr 2019 18:33:48 +0000 (UTC)
DKIM-Filter: OpenDKIM Filter v2.11.0 sysclose.org CE5AD6803
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sysclose.org;
        s=201903; t=1555007628;
        bh=CYYQPIAA5T2NOLgibmRawk5c8InAlBHyEcDsSbaplOs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qopOgsjFcDJTr3EhjZkspfjGYHcItNDBof/pYkhxLwxKxpQ5ocVa9ojt4PGzAG9DC
         EWQig4wafoExngL6/UhzzVLxQZxDD7MsyYwlQNCMqEZGkf9tfnvjEx3/rvJG0QxxhX
         Y7yoX8wiwpMLyoIIDMksNIjgq2bwjn7Wv/rtm9ooE5Qgc89vc83Q08hI7ekTio4u9e
         OlLq+lCqY8xIHQedr2T70ea+rhdOcNy2haIVd8VQgujyfdf74bf9EVyh7WoOHO4RbM
         8pf4QuhjHJvZ4+TOd6xy+spMBpuOB9vAHoSi42mv/g9c5ng6Fkode7LuC1LTNRDrft
         t6KNHGyio8z3g==
Received: from localhost (unknown [177.183.215.126])
        by sysclose.org (Postfix) with ESMTPSA id 15C0367D8;
        Thu, 11 Apr 2019 18:33:46 +0000 (UTC)
DKIM-Filter: OpenDKIM Filter v2.11.0 sysclose.org 15C0367D8
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sysclose.org;
        s=201903; t=1555007627;
        bh=CYYQPIAA5T2NOLgibmRawk5c8InAlBHyEcDsSbaplOs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=OX44MX8GWdw+OnWScsoPTQGr9TFeAGh56VqDDVQoKHDJtbOLZtLbirmFW5LmGAY8X
         2/YznpAB6qHch9YZRKziq2cYX0DpIUZz4TQXSfRHLAL6zjfKQwY8+oRxrabDKftvXZ
         9vHcifpaD/eEHX4lAe7J5RNH4jc6XI/sFv4Hni0qhHVKPOhhO0c9v2AOn59lvql2YE
         RtoCpaLv3PdcYB+lkIDw4PA83W6eUiwq8PkT4lB54Onp3SkoRMTT4GhWwmFhg207WO
         PBBmIn0O1Zu6DcpZWA2mr2sxrdbesWjs+tapPzDz/G5TYRXc8y62wBV+76KlOupDfs
         j+2vwrcOkhbwA==
Date:   Thu, 11 Apr 2019 15:33:42 -0300
From:   Flavio Leitner <fbl@sysclose.org>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netdev@vger.kernel.org, Joe Stringer <joe@ovn.org>,
        Pravin B Shelar <pshelar@ovn.org>, dev@openvswitch.org,
        netfilter-devel@vger.kernel.org
Subject: Re: [PATCH net-next 1/8] netfilter: use macros to create module
 aliases.
Message-ID: <20190411183342.GA21048@p50.lan>
References: <20190326205715.22288-1-fbl@sysclose.org>
 <20190326205715.22288-2-fbl@sysclose.org>
 <20190331220743.uwlpdr77cpuhh7fb@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190331220743.uwlpdr77cpuhh7fb@salvia>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, Apr 01, 2019 at 12:07:43AM +0200, Pablo Neira Ayuso wrote:
> On Tue, Mar 26, 2019 at 05:57:08PM -0300, Flavio Leitner wrote:
> > Each NAT helper creates a module alias which follows a pattern.
> > Use macros for consistency.
> > 
> > Signed-off-by: Flavio Leitner <fbl@sysclose.org>
> > ---
> >  include/net/netfilter/nf_conntrack_helper.h | 4 ++++
> >  net/ipv4/netfilter/nf_nat_h323.c            | 2 +-
> >  net/ipv4/netfilter/nf_nat_pptp.c            | 2 +-
> >  net/netfilter/nf_nat_amanda.c               | 2 +-
> >  net/netfilter/nf_nat_ftp.c                  | 2 +-
> >  net/netfilter/nf_nat_irc.c                  | 2 +-
> >  net/netfilter/nf_nat_sip.c                  | 2 +-
> >  net/netfilter/nf_nat_tftp.c                 | 2 +-
> >  8 files changed, 11 insertions(+), 7 deletions(-)
> > 
> > diff --git a/include/net/netfilter/nf_conntrack_helper.h b/include/net/netfilter/nf_conntrack_helper.h
> > index ec52a8dc32fd..e86fadf7e7c5 100644
> > --- a/include/net/netfilter/nf_conntrack_helper.h
> > +++ b/include/net/netfilter/nf_conntrack_helper.h
> > @@ -15,6 +15,10 @@
> >  #include <net/netfilter/nf_conntrack_extend.h>
> >  #include <net/netfilter/nf_conntrack_expect.h>
> >  
> > +#define NF_CT_NAT_HELPER_MOD_NAME(name)	"ip_nat_" name
> 
> I'd suggest a rename from NF_CT_NAT_HELPER_MOD_NAME() to
> NF_NAT_HELPER_NAME().

OK.


> Please, also use "nf_nat_" prefix instead, "ip_nat" is legacy stuff.

I don't think we can, because people might be using
the current alias which is ip_nat_something. This patch
is just making it more robust.

> > +#define MODULE_ALIAS_NFCT_HELPER_NAT(name) \
> > +	MODULE_ALIAS(NF_CT_NAT_HELPER_MOD_NAME(name))
> 
> Probably:
> 
>         MODULE_ALIAS_NF_NAT_HELPER
> 
> instead of MODULE_ALIAS_NFCT_HELPER_NAT.

OK.

fbl
