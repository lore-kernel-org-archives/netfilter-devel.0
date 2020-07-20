Return-Path: <SRS0=qgEK=A7=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A286EC433E4
	for <netfilter-devel@archiver.kernel.org>; Mon, 20 Jul 2020 11:26:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 83A2B22B4D
	for <netfilter-devel@archiver.kernel.org>; Mon, 20 Jul 2020 11:26:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728419AbgGTL07 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 20 Jul 2020 07:26:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728058AbgGTL07 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 20 Jul 2020 07:26:59 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB4ECC061794
        for <netfilter-devel@vger.kernel.org>; Mon, 20 Jul 2020 04:26:58 -0700 (PDT)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1jxTwb-0006CK-DE; Mon, 20 Jul 2020 13:26:53 +0200
Date:   Mon, 20 Jul 2020 13:26:53 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
Subject: Re: [nf-next PATCH v2] netfilter: include: uapi: Use C99 flexible
 array member
Message-ID: <20200720112653.GV23632@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
References: <20200719100220.4666-1-phil@nwl.cc>
 <0297a19d-2afb-1285-a91c-d32fb9799c33@embeddedor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0297a19d-2afb-1285-a91c-d32fb9799c33@embeddedor.com>
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Gustavo,

On Sun, Jul 19, 2020 at 10:34:01AM -0500, Gustavo A. R. Silva wrote:
> Please, see this:
> 
> https://git.kernel.org/linus/1e6e9d0f4859ec698d55381ea26f4136eff3afe1
> 
> We are refraining from doing flexible-array conversions in UAPI, for now.

Oh, thanks for clarifying. Still, gcc spits out warnings about it when
compiling iptables. I see several options and their downsides:

- Convert iptables' copy of UAPI headers only and maintain the
  divergence in future.

- Compile iptables with -Wno-stringop-overflow, losing the checks in
  valid cases.

Not sure if we may just define that we know how structs in ip_tables.h
and ip6_tables.h are (supposed to) being used and just change it anyway.

BTW: The commit above link points at mentions structs possibly being
embedded as the rationale for keeping things as-is. Yet structs
ipt_entry and ip6t_entry are already embedded into other structs within
the same header file. Seems like gcc is fine with that as long as they
occupy the last field. And that even if they are declared as zero-length
array themselves, which means indexes can't be used to address
individual items.

Cheers, Phil
