Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A6D5C433EF
	for <netfilter-devel@archiver.kernel.org>; Tue, 15 Mar 2022 20:27:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351698AbiCOU3C (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 15 Mar 2022 16:29:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351697AbiCOU3B (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 15 Mar 2022 16:29:01 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C764FE26;
        Tue, 15 Mar 2022 13:27:48 -0700 (PDT)
Received: from netfilter.org (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id BCEEF62FFE;
        Tue, 15 Mar 2022 21:25:27 +0100 (CET)
Date:   Tue, 15 Mar 2022 21:27:45 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org,
        davem@davemloft.net, netdev@vger.kernel.org
Subject: Re: [PATCH nf-next 2/6] netfilter: nf_tables: Reject tables of
 unsupported family
Message-ID: <YjD2wbXm8XFiXgI8@salvia>
References: <20220315091513.66544-1-pablo@netfilter.org>
 <20220315091513.66544-3-pablo@netfilter.org>
 <20220315115644.66fab74b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220315115644.66fab74b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Mar 15, 2022 at 11:56:44AM -0700, Jakub Kicinski wrote:
> On Tue, 15 Mar 2022 10:15:09 +0100 Pablo Neira Ayuso wrote:
> > +	return false
> > +#ifdef CONFIG_NF_TABLES_INET
> > +		|| family == NFPROTO_INET
> > +#endif
> > +#ifdef CONFIG_NF_TABLES_IPV4
> > +		|| family == NFPROTO_IPV4
> > +#endif
> > +#ifdef CONFIG_NF_TABLES_ARP
> > +		|| family == NFPROTO_ARP
> > +#endif
> > +#ifdef CONFIG_NF_TABLES_NETDEV
> > +		|| family == NFPROTO_NETDEV
> > +#endif
> > +#if IS_ENABLED(CONFIG_NF_TABLES_BRIDGE)
> 
> is there a reason this one is IS_ENABLED() and everything else is ifdef?

bridge might be compiled as a module, if the bridge infrastructure
also comes a module as well.

Anything else is either built-in or off.
