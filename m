Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED5B1C433EF
	for <netfilter-devel@archiver.kernel.org>; Tue, 11 Jan 2022 09:33:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349282AbiAKJdt (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 11 Jan 2022 04:33:49 -0500
Received: from mail.netfilter.org ([217.70.188.207]:45750 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236995AbiAKJdr (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 11 Jan 2022 04:33:47 -0500
Received: from netfilter.org (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 08FCD607C3;
        Tue, 11 Jan 2022 10:30:54 +0100 (CET)
Date:   Tue, 11 Jan 2022 10:33:41 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH v2] netfilter: nft_connlimit: fix nft clone() functions
Message-ID: <Yd1O9RPFe3xlzztN@salvia>
References: <20220111072115.GF11243@kili>
 <20220111074505.GE1978@kadam>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220111074505.GE1978@kadam>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Jan 11, 2022 at 10:45:05AM +0300, Dan Carpenter wrote:
> On Tue, Jan 11, 2022 at 10:21:15AM +0300, Dan Carpenter wrote:
> > These NULL checks are reversed so the clone() can never succeed.
> > 
> > Fixes: 37f319f37d90 ("netfilter: nft_connlimit: move stateful fields out of expression data")
> > Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> > ---
> > v2: fix a couple similar bugs
> 
> Gar.  Nope.  Missed one still.

Already fixed in net-next
