Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55213C433EF
	for <netfilter-devel@archiver.kernel.org>; Tue, 15 Mar 2022 20:10:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346007AbiCOULv (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 15 Mar 2022 16:11:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239744AbiCOULu (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 15 Mar 2022 16:11:50 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id F084550E2C;
        Tue, 15 Mar 2022 13:10:37 -0700 (PDT)
Received: from netfilter.org (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id DB02A62FFE;
        Tue, 15 Mar 2022 21:08:16 +0100 (CET)
Date:   Tue, 15 Mar 2022 21:10:33 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Phil Sutter <phil@nwl.cc>, Jakub Kicinski <kuba@kernel.org>,
        netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org
Subject: Re: [PATCH nf-next 2/6] netfilter: nf_tables: Reject tables of
 unsupported family
Message-ID: <YjDyuU44RhSDCHy7@salvia>
References: <20220315091513.66544-1-pablo@netfilter.org>
 <20220315091513.66544-3-pablo@netfilter.org>
 <20220315115644.66fab74b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <YjDxoXbCfnPVrxT2@orbyte.nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <YjDxoXbCfnPVrxT2@orbyte.nwl.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Mar 15, 2022 at 09:05:53PM +0100, Phil Sutter wrote:
> Hi Jakub,
> 
> On Tue, Mar 15, 2022 at 11:56:44AM -0700, Jakub Kicinski wrote:
> > On Tue, 15 Mar 2022 10:15:09 +0100 Pablo Neira Ayuso wrote:
> > > +	return false
> > > +#ifdef CONFIG_NF_TABLES_INET
> > > +		|| family == NFPROTO_INET
> > > +#endif
> > > +#ifdef CONFIG_NF_TABLES_IPV4
> > > +		|| family == NFPROTO_IPV4
> > > +#endif
> > > +#ifdef CONFIG_NF_TABLES_ARP
> > > +		|| family == NFPROTO_ARP
> > > +#endif
> > > +#ifdef CONFIG_NF_TABLES_NETDEV
> > > +		|| family == NFPROTO_NETDEV
> > > +#endif
> > > +#if IS_ENABLED(CONFIG_NF_TABLES_BRIDGE)
> > 
> > is there a reason this one is IS_ENABLED() and everything else is ifdef?
> 
> I based my patch on the existing ifdefs in nft_chain_filter.c where
> these config symbols are checked exactly like above. Looking at git
> history, the check was changed from a simple ifdef in commit
> dfee0e99bcff7 ("netfilter: bridge: make NF_TABLES_BRIDGE tristate").
> 
> > > +		|| family == NFPROTO_BRIDGE
> > > +#endif
> > > +#ifdef CONFIG_NF_TABLES_IPV6
> > > +		|| family == NFPROTO_IPV6
> > > +#endif
> > > +		;
> > 
> > 	return (IS_ENABLED(CONFIG_NF_TABLES_INET) && family == NFPROTO_INET)) ||
> > 	       (IS_ENABLED(CONFIG_NF_TABLES_IPV4) && family == NFPROTO_IPV4)) ||
> > 		...
> > 
> > would have also been an option, for future reference.
> 
> Yes, that is indeed much cleaner. I wasn't aware of this possibility
> using IS_ENABLED. What do you think, worth a follow-up?

CONFIG_NF_TABLES_INET and CONFIG_NF_TABLES_IPV4 are never modules, I
think IS_ENABLED is misleading there to the reader.
