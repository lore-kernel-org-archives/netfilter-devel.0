Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6EA2C6FA99
	for <netfilter-devel@archiver.kernel.org>; Fri, 10 Mar 2023 11:44:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229541AbjCJLo3 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 10 Mar 2023 06:44:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229621AbjCJLo2 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 10 Mar 2023 06:44:28 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id DF7465F217
        for <netfilter-devel@vger.kernel.org>; Fri, 10 Mar 2023 03:44:27 -0800 (PST)
Date:   Fri, 10 Mar 2023 12:44:23 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Jeremy Sowden <jeremy@azazel.net>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH net 0/4] Netfilter fixes for net
Message-ID: <ZAsYF2wguD2Ksg4f@salvia>
References: <20230309174655.69816-1-pablo@netfilter.org>
 <20230310110856.GG226246@celephais.dreamlands>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230310110856.GG226246@celephais.dreamlands>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, Mar 10, 2023 at 11:08:56AM +0000, Jeremy Sowden wrote:
> On 2023-03-09, at 18:46:51 +0100, Pablo Neira Ayuso wrote:
> > The following patchset contains Netfilter fixes for net:
> > 
> > 1) nft_parse_register_load() gets an incorrect datatype size
> >    as input, from Jeremy Sowden.
> > 
> > 2) incorrect maximum netlink attribute in nft_redir, also
> >    from Jeremy.
> > 
> > Please, pull these changes from:
> > 
> >   git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git
> 
> Have you actually pushed these changes to nf.git?  Can't see them. :)

Oh, I pushed out to master, not main...
