Return-Path: <SRS0=7szD=ZN=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3FD5C432C0
	for <netfilter-devel@archiver.kernel.org>; Thu, 21 Nov 2019 17:53:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8633C20658
	for <netfilter-devel@archiver.kernel.org>; Thu, 21 Nov 2019 17:53:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726701AbfKURx3 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 21 Nov 2019 12:53:29 -0500
Received: from orbyte.nwl.cc ([151.80.46.58]:41762 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726279AbfKURx2 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 21 Nov 2019 12:53:28 -0500
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.91)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1iXqdz-0006c3-H1; Thu, 21 Nov 2019 18:53:27 +0100
Date:   Thu, 21 Nov 2019 18:53:27 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Stefano Brivio <sbrivio@redhat.com>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>,
        Kadlecsik =?utf-8?Q?J=C3=B3zsef?= <kadlec@blackhole.kfki.hu>,
        Eric Garver <eric@garver.life>
Subject: Re: [PATCH libnftnl v2] set: Add support for NFTA_SET_SUBKEY
 attributes
Message-ID: <20191121175327.GE3074@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Stefano Brivio <sbrivio@redhat.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>,
        Kadlecsik =?utf-8?Q?J=C3=B3zsef?= <kadlec@blackhole.kfki.hu>,
        Eric Garver <eric@garver.life>
References: <de1e8744507f6590886a5cb7eef98f23775ee2fa.1574354321.git.sbrivio@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <de1e8744507f6590886a5cb7eef98f23775ee2fa.1574354321.git.sbrivio@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Nov 21, 2019 at 06:10:21PM +0100, Stefano Brivio wrote:
> If the NFTNL_SET_SUBKEY flag is passed, send one NFTA_SET_SUBKEY
> attribute for each subkey_len attribute in the set description.
> 
> Note that our internal representation, and nftables storage, for
> these attributes, is 8-bit wide, but the kernel uses 32 bits. As
> field length is expressed in bits, this is probably a good
> compromise to keep the UAPI future-proof and memory footprint to
> a minimum, for the moment being.
> 
> This is the libnftnl counterpart for nftables patch:
>   src: Add support for and export NFT_SET_SUBKEY attributes
> 
> and it has a UAPI dependency on kernel patch:
>   [PATCH nf-next 1/8] nf_tables: Support for subkeys, set with multiple ranged fields
> 
> v2:
>  - fixed grammar in commit message
>  - removed copy of array bytes in nftnl_set_nlmsg_build_subkey_payload(),
>    we're simply passing values to htonl() (Phil Sutter)
> 
> Signed-off-by: Stefano Brivio <sbrivio@redhat.com>

Acked-by: Phil Sutter <phil@nwl.cc>
