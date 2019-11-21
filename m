Return-Path: <SRS0=7szD=ZN=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 630A2C432C0
	for <netfilter-devel@archiver.kernel.org>; Thu, 21 Nov 2019 17:51:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3B04920658
	for <netfilter-devel@archiver.kernel.org>; Thu, 21 Nov 2019 17:51:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726875AbfKURvs (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 21 Nov 2019 12:51:48 -0500
Received: from orbyte.nwl.cc ([151.80.46.58]:41726 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726279AbfKURvs (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 21 Nov 2019 12:51:48 -0500
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.91)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1iXqcL-0006Yn-CL; Thu, 21 Nov 2019 18:51:45 +0100
Date:   Thu, 21 Nov 2019 18:51:45 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Stefano Brivio <sbrivio@redhat.com>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>,
        Kadlecsik =?utf-8?Q?J=C3=B3zsef?= <kadlec@blackhole.kfki.hu>,
        Eric Garver <eric@garver.life>
Subject: Re: [PATCH nft v2 1/3] src: Add support for and export
 NFT_SET_SUBKEY attributes
Message-ID: <20191121175145.GB3074@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Stefano Brivio <sbrivio@redhat.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>,
        Kadlecsik =?utf-8?Q?J=C3=B3zsef?= <kadlec@blackhole.kfki.hu>,
        Eric Garver <eric@garver.life>
References: <cover.1574353687.git.sbrivio@redhat.com>
 <3982a275e0a29b00b742d5b5322163cae8e6c046.1574353687.git.sbrivio@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3982a275e0a29b00b742d5b5322163cae8e6c046.1574353687.git.sbrivio@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Nov 21, 2019 at 06:10:04PM +0100, Stefano Brivio wrote:
> To support arbitrary range concatenations, the kernel needs to know
> how long each field in the concatenation is.
> 
> While evaluating concatenated expressions, export the datatype size,
> in bits, into the new subkey_len array, and hand the data over via
> libnftnl.
> 
> Note that, while the subkey length is expressed in bits, and the
> kernel attribute is 32-bit long to make UAPI more future-proof, we
> just reserve 8 bits for it, at the moment, and still store this data
> in bits.
> 
> As we don't have subkeys exceeding 128 bits in length, this should be
> fine, at least for a while, but it can be easily changed later on to
> use the full 32 bits allowed by the netlink attribute.
> 
> This change depends on the UAPI kernel patch with title:
>   netfilter: nf_tables: Support for subkeys, set with multiple ranged fields
> 
> Signed-off-by: Stefano Brivio <sbrivio@redhat.com>

Acked-by: Phil Sutter <phil@nwl.cc>
