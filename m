Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7788CEE14D4
	for <netfilter-devel@archiver.kernel.org>; Wed,  6 Sep 2023 18:46:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241222AbjIFSqk (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 6 Sep 2023 14:46:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234158AbjIFSqj (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 6 Sep 2023 14:46:39 -0400
Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [IPv6:2001:780:45:1d:225:90ff:fe52:c662])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27EA1D7;
        Wed,  6 Sep 2023 11:46:31 -0700 (PDT)
Received: from [78.30.34.192] (port=47690 helo=gnumonks.org)
        by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <pablo@gnumonks.org>)
        id 1qdxXm-001HzX-Qd; Wed, 06 Sep 2023 20:46:29 +0200
Date:   Wed, 6 Sep 2023 20:46:26 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org,
        audit@vger.kernel.org
Subject: Re: [PATCH nf] netfilter: nf_tables: Unbreak audit log reset
Message-ID: <ZPjJAicFFam5AFIq@calendula>
References: <20230906094202.1712-1-pablo@netfilter.org>
 <ZPhjYkRpUvfqPB9F@orbyte.nwl.cc>
 <ZPhm1mf0GaeQUr0e@calendula>
 <ZPiyGC+TfRgyOabJ@orbyte.nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ZPiyGC+TfRgyOabJ@orbyte.nwl.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Sep 06, 2023 at 07:08:40PM +0200, Phil Sutter wrote:
[...]
> The last six come from the 'reset rules table t1' command. While on one
> hand it looks like nftables fits only three rules into a single skb,
> your fix seems to have a problem in that it doesn't subtract s_idx from
> *idx.

Please, feel free to follow up to refine, thanks.
