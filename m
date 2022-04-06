Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E8BAC433F5
	for <netfilter-devel@archiver.kernel.org>; Wed,  6 Apr 2022 14:39:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235015AbiDFOlI (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 6 Apr 2022 10:41:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235046AbiDFOks (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 6 Apr 2022 10:40:48 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6496E307648
        for <netfilter-devel@vger.kernel.org>; Wed,  6 Apr 2022 04:06:16 -0700 (PDT)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1nc3UL-0007L9-H3; Wed, 06 Apr 2022 13:06:13 +0200
Date:   Wed, 6 Apr 2022 13:06:13 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH libnftnl 0/3] add description infrastructure
Message-ID: <Yk10JYXS/uGGqsxe@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
References: <20220120000402.916332-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220120000402.916332-1-pablo@netfilter.org>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Pablo,

On Thu, Jan 20, 2022 at 01:03:59AM +0100, Pablo Neira Ayuso wrote:
> This is my proposal to address the snprintf data printing depending on
> the arch. The idea is to add description objects that can be used to
> build the userdata area as well as to parse the userdata to create the
> description object.
> 
> This is revisiting 6e48df5329ea ("src: add "typeof" build/parse/print
> support") in nftables which adds build and parse userdata callbacks to
> expression in libnftables. My proposal is to move this to libnftnl.

Looking at your PoC again, I assume it was meant for use by applications
to create and populate an nftnl_set_desc object and serialize it into
nftnl_set's userdata using nftnl_set_desc_build_udata(). Since the
information is needed within libnftnl though, the whole API does not
make sense anymore and nftnl_set_desc must be serialized by libnftnl
itself. This in turn means one may just integrate the data structure
into nftnl_set's 'desc' field directly and extend nftnl_set_set_data()
to allow populating the new fields, plus
nftnl_set_desc_add_{expr,datatype}() I guess.

Am I on the right track there?

Maybe it's quicker for me to add the missing bits to my stuff instead of
adjusting it to your series after making it work for the intended
purpose. Especially since I'm not quite sure what goal we're trying to
achieve.

Cheers, Phil
