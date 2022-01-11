Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D3E5C433EF
	for <netfilter-devel@archiver.kernel.org>; Tue, 11 Jan 2022 10:34:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349272AbiAKKei (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 11 Jan 2022 05:34:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349054AbiAKKef (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 11 Jan 2022 05:34:35 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A6BEC06173F
        for <netfilter-devel@vger.kernel.org>; Tue, 11 Jan 2022 02:34:35 -0800 (PST)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1n7EU5-0004iq-0u; Tue, 11 Jan 2022 11:34:33 +0100
Date:   Tue, 11 Jan 2022 11:34:33 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [iptables PATCH 06/11] xtables: Do not pass nft_handle to
 do_parse()
Message-ID: <Yd1dOa5CFYgrS+dn@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
References: <20211224171754.14210-1-phil@nwl.cc>
 <20211224171754.14210-7-phil@nwl.cc>
 <YdylQQa+QMyS5lcQ@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YdylQQa+QMyS5lcQ@salvia>
Sender:  <n0-1@orbyte.nwl.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, Jan 10, 2022 at 10:29:37PM +0100, Pablo Neira Ayuso wrote:
> On Fri, Dec 24, 2021 at 06:17:49PM +0100, Phil Sutter wrote:
> [...]
> > diff --git a/iptables/xshared.h b/iptables/xshared.h
> > index dde94b7335f6a..1954168f64058 100644
> > --- a/iptables/xshared.h
> > +++ b/iptables/xshared.h
> [...]
> >  struct xt_cmd_parse {
> >  	unsigned int			command;
> >  	unsigned int			rulenum;
> > @@ -272,6 +305,11 @@ struct xt_cmd_parse {
> >  	bool				restore;
> >  	int				verbose;
> >  	bool				xlate;
> 
> Probably wrap these two common functions between legacy and nft in a
> structure? Something like: struct nft_parse_ops...

Ah yes, thanks for suggesting. Wrapping the callbacks didn't come to
mind despite the need for two assignments everywhere.

I'll fix and resubmit.

Cheers, Phil
