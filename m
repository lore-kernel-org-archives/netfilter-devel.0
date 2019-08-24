Return-Path: <SRS0=H+Om=WU=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F1D8C3A59E
	for <netfilter-devel@archiver.kernel.org>; Sat, 24 Aug 2019 16:53:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 674092173E
	for <netfilter-devel@archiver.kernel.org>; Sat, 24 Aug 2019 16:53:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726604AbfHXQxn (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 24 Aug 2019 12:53:43 -0400
Received: from ganesha.gnumonks.org ([213.95.27.120]:60365 "EHLO
        ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726211AbfHXQxm (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 24 Aug 2019 12:53:42 -0400
Received: from [47.60.33.188] (helo=gnumonks.org)
        by ganesha.gnumonks.org with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <pablo@gnumonks.org>)
        id 1i1ZIF-00020n-9f; Sat, 24 Aug 2019 18:53:41 +0200
Date:   Sat, 24 Aug 2019 18:53:34 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Phil Sutter <phil@nwl.cc>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [iptables PATCH 14/14] nft: bridge: Rudimental among extension
 support
Message-ID: <20190824165333.l4qyhk3fyzglstmp@salvia>
References: <20190821092602.16292-1-phil@nwl.cc>
 <20190821092602.16292-15-phil@nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190821092602.16292-15-phil@nwl.cc>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Aug 21, 2019 at 11:26:02AM +0200, Phil Sutter wrote:
[...]
> +/* XXX: move this into libnftnl, replacing nftnl_set_lookup() */
> +static struct nftnl_set *nft_set_byname(struct nft_handle *h,
> +					const char *table, const char *set)

Probably extend libnftnl to allow to take a pointer to a nftnl_set
object, as an alternative to the set name? The idea is that this
set object now belongs to the lookup extension, so this extension will
take care of releasing it from the destroy path.

Then, the lookup extension will have a pointer to the anonymous set so
you could then skip the cache code (and all the updates to have access
to it).

Anonymous sets can only be attached to one rule and they go away when
the rule is released. Then, flushing the rule would also release this
object.
