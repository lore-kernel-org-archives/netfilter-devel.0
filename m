Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4E62C433EF
	for <netfilter-devel@archiver.kernel.org>; Fri, 24 Dec 2021 16:07:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353147AbhLXQHh (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 24 Dec 2021 11:07:37 -0500
Received: from mail.netfilter.org ([217.70.188.207]:44632 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353145AbhLXQHg (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 24 Dec 2021 11:07:36 -0500
Received: from netfilter.org (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 6EB77607C4;
        Fri, 24 Dec 2021 17:04:59 +0100 (CET)
Date:   Fri, 24 Dec 2021 17:07:30 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf-next] netfilter: exthdr: add support for tcp option
 removal
Message-ID: <YcXwQpTpRwe5XvZP@salvia>
References: <20211220143247.554667-1-fw@strlen.de>
 <YcO5tQz5ImOxtZLx@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <YcO5tQz5ImOxtZLx@salvia>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Dec 23, 2021 at 12:50:17AM +0100, Pablo Neira Ayuso wrote:
> On Mon, Dec 20, 2021 at 03:32:47PM +0100, Florian Westphal wrote:
> > This allows to replace a tcp option with nop padding to selectively disable
> > a particular tcp option.
> > 
> > Optstrip mode is chosen when userspace passes the exthdr expression with
> > neither a source nor a destination register attribute.
> > 
> > This is identical to xtables TCPOPTSTRIP extension.
> 
> Is it worth to retain the bitmap approach?

Probably a new nested attribute to store the list of types that you
would like to strip:

        NFTA_EXTHDR_TYPES
         NFTA_EXTHDR_TYPE
         NFTA_EXTHDR_TYPE

From the kernel, you could build a bitmap (just like TCPOPTSTRIP)
based on this list.

From the dump path, you can iterate over the bitmap to check for
bitset to build this nest.

> > Signed-off-by: Florian Westphal <fw@strlen.de>
> > ---
> >  proposed userspace syntax is:
> > 
> >  nft add rule f in delete tcp option sack-perm
> 
>    nft add rule f in tcp option reset sack-perm,...
