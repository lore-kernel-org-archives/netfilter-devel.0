Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93225C433F5
	for <netfilter-devel@archiver.kernel.org>; Wed, 12 Jan 2022 11:11:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352777AbiALLLe (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 12 Jan 2022 06:11:34 -0500
Received: from mail.netfilter.org ([217.70.188.207]:48850 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352761AbiALLLd (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 12 Jan 2022 06:11:33 -0500
Received: from netfilter.org (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id B9D0162BDB;
        Wed, 12 Jan 2022 12:08:39 +0100 (CET)
Date:   Wed, 12 Jan 2022 12:11:26 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH v2] netfilter: nft_connlimit: fix nft clone() functions
Message-ID: <Yd63Xp4J4WtdEBLy@salvia>
References: <20220111072115.GF11243@kili>
 <20220111074505.GE1978@kadam>
 <Yd1O9RPFe3xlzztN@salvia>
 <20220112062657.GE1951@kadam>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220112062657.GE1951@kadam>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Jan 12, 2022 at 09:26:57AM +0300, Dan Carpenter wrote:
> On Tue, Jan 11, 2022 at 10:33:41AM +0100, Pablo Neira Ayuso wrote:
> > On Tue, Jan 11, 2022 at 10:45:05AM +0300, Dan Carpenter wrote:
> > > On Tue, Jan 11, 2022 at 10:21:15AM +0300, Dan Carpenter wrote:
> > > > These NULL checks are reversed so the clone() can never succeed.
> > > > 
> > > > Fixes: 37f319f37d90 ("netfilter: nft_connlimit: move stateful fields out of expression data")
> > > > Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> > > > ---
> > > > v2: fix a couple similar bugs
> > > 
> > > Gar.  Nope.  Missed one still.
> > 
> > Already fixed in net-next
> 
> Maybe I misunderstood.  Are all four functions fixed?
> 
> I'm looking at net-next and nft_connlimit_clone() is still broken.

Sorry, patch in the net tree:

commit 51edb2ff1c6fc27d3fa73f0773a31597ecd8e230
Author: Pablo Neira Ayuso <pablo@netfilter.org>
Date:   Mon Jan 10 20:48:17 2022 +0100

    netfilter: nf_tables: typo NULL check in _clone() function

net-next is out of sync at this stage, until merge window reopens it
might stay like this.
