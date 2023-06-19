Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3065EB64DB
	for <netfilter-devel@archiver.kernel.org>; Mon, 19 Jun 2023 08:54:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231148AbjFSIyB (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 19 Jun 2023 04:54:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231154AbjFSIxn (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 19 Jun 2023 04:53:43 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7E1BD3C06
        for <netfilter-devel@vger.kernel.org>; Mon, 19 Jun 2023 01:52:44 -0700 (PDT)
Date:   Mon, 19 Jun 2023 10:52:41 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Arturo Borrero Gonzalez <arturo@netfilter.org>
Cc:     Florian Westphal <fw@strlen.de>,
        netfilter-devel <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH nft] cache: include set elements in "nft set list"
Message-ID: <ZJAXWZuX5VpT9vNX@calendula>
References: <20230618163951.408565-1-fw@strlen.de>
 <d8129d5c-2a6b-25ee-af54-78a47e133842@netfilter.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <d8129d5c-2a6b-25ee-af54-78a47e133842@netfilter.org>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, Jun 19, 2023 at 09:59:03AM +0200, Arturo Borrero Gonzalez wrote:
> On 6/18/23 18:39, Florian Westphal wrote:
> > Make "nft list sets" include set elements in listing by default.
> > In nftables 1.0.0, "nft list sets" did not include the set elements,
> > but with "--json" they were included.
> > 
> > 1.0.1 and newer never include them.
> > This causes a problem for people updating from 1.0.0 and relying
> > on the presence of the set elements.
> > 
> > Change nftables to always include the set elements.
> > The "--terse" option is honored to get the "no elements" behaviour.
> > 
> 
> Hi,
> 
> Would you recommend the debian package backports this fix for 1.0.6/1.0.7 ?

fine with me.
