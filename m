Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 234DFCE7A81
	for <netfilter-devel@archiver.kernel.org>; Mon, 25 Sep 2023 11:02:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229449AbjIYLCf (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 25 Sep 2023 07:02:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229726AbjIYLCe (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 25 Sep 2023 07:02:34 -0400
Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [IPv6:2001:780:45:1d:225:90ff:fe52:c662])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C09349D
        for <netfilter-devel@vger.kernel.org>; Mon, 25 Sep 2023 04:02:28 -0700 (PDT)
Received: from [78.30.34.192] (port=33098 helo=gnumonks.org)
        by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <pablo@gnumonks.org>)
        id 1qkjM8-00Fyks-UO; Mon, 25 Sep 2023 13:02:26 +0200
Date:   Mon, 25 Sep 2023 13:02:24 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org
Subject: Re: [nf PATCH 2/5] netfilter: nf_tables: Add locking for
 NFT_MSG_GETRULE_RESET requests
Message-ID: <ZRFowDL5Bk+nrCSd@calendula>
References: <20230923013807.11398-1-phil@nwl.cc>
 <20230923013807.11398-3-phil@nwl.cc>
 <20230923110437.GB22532@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230923110437.GB22532@breakpoint.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Sat, Sep 23, 2023 at 01:04:37PM +0200, Florian Westphal wrote:
> Phil Sutter <phil@nwl.cc> wrote:
> >  	table = nft_table_lookup(net, nla[NFTA_RULE_TABLE], family, genmask, 0);
> >  	if (IS_ERR(table)) {
> >  		NL_SET_BAD_ATTR(extack, nla[NFTA_RULE_TABLE]);
> > -		return PTR_ERR(table);
> > +		return ERR_CAST(table);
> >  	}
> 
> Can you split that into another patch?

Agreed. Any preparation update would be good to be introduced in first
place. If you think ERR_CAST is better, maybe justify and target this
later at nf-next?

Thanks!
