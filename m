Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4E69C433F5
	for <netfilter-devel@archiver.kernel.org>; Tue, 19 Apr 2022 09:04:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345941AbiDSJHK (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 19 Apr 2022 05:07:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240297AbiDSJHJ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 19 Apr 2022 05:07:09 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 653B722B33;
        Tue, 19 Apr 2022 02:04:27 -0700 (PDT)
Date:   Tue, 19 Apr 2022 11:04:24 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Simon Horman <horms@verge.net.au>
Cc:     Julian Anastasov <ja@ssi.bg>, Pengcheng Yang <yangpc@wangsu.com>,
        lvs-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf,v2] ipvs: correctly print the memory size of
 ip_vs_conn_tab
Message-ID: <Yl57GONaSbzgMJY8@salvia>
References: <1649761545-1864-1-git-send-email-yangpc@wangsu.com>
 <dd2f82a6-bf70-2b10-46e0-9d81e4dde6@ssi.bg>
 <Yl55e0mDsrgcCAX2@vergenet.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Yl55e0mDsrgcCAX2@vergenet.net>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Apr 19, 2022 at 10:57:31AM +0200, Simon Horman wrote:
> On Fri, Apr 15, 2022 at 04:22:47PM +0300, Julian Anastasov wrote:
> > 
> > 	Hello,
> > 
> > On Tue, 12 Apr 2022, Pengcheng Yang wrote:
> > 
> > > The memory size of ip_vs_conn_tab changed after we use hlist
> > > instead of list.
> > > 
> > > Fixes: 731109e78415 ("ipvs: use hlist instead of list")
> > > Signed-off-by: Pengcheng Yang <yangpc@wangsu.com>
> > > ---
> > 
> > 	v2 looks better to me for nf-next, thanks!
> > 
> > Acked-by: Julian Anastasov <ja@ssi.bg>
> 
> Acked-by: Simon Horman <horms@verge.net.au>

Applied to nf.git, thanks
