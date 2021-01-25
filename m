Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7956C433DB
	for <netfilter-devel@archiver.kernel.org>; Mon, 25 Jan 2021 13:24:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 72A3622EBD
	for <netfilter-devel@archiver.kernel.org>; Mon, 25 Jan 2021 13:24:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728801AbhAYNYY (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 25 Jan 2021 08:24:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728776AbhAYNXf (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 25 Jan 2021 08:23:35 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0575C061574
        for <netfilter-devel@vger.kernel.org>; Mon, 25 Jan 2021 05:22:54 -0800 (PST)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1l41pG-0002Ed-60; Mon, 25 Jan 2021 14:22:38 +0100
Date:   Mon, 25 Jan 2021 14:22:38 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Lukas Wunner <lukas@wunner.de>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Laura Garcia Liebana <nevola@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>, coreteam@netfilter.org,
        netfilter-devel@vger.kernel.org, Thomas Graf <tgraf@suug.ch>
Subject: Re: [netfilter-core] [PATCH nft v4] src: Support netdev egress hook
Message-ID: <20210125132238.GG3158@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>, Lukas Wunner <lukas@wunner.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Laura Garcia Liebana <nevola@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>, coreteam@netfilter.org,
        netfilter-devel@vger.kernel.org, Thomas Graf <tgraf@suug.ch>
References: <4b3c95a0449591c97f68be15d8d17bda298a7b5e.1611498014.git.lukas@wunner.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4b3c95a0449591c97f68be15d8d17bda298a7b5e.1611498014.git.lukas@wunner.de>
Sender:  <n0-1@orbyte.nwl.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Lukas,

On Sun, Jan 24, 2021 at 03:25:06PM +0100, Lukas Wunner wrote:
[...]
> diff --git a/tests/py/inet/ip.t.payload.netdev b/tests/py/inet/ip.t.payload.netdev
> index 95be919..38ed0ad 100644
> --- a/tests/py/inet/ip.t.payload.netdev
> +++ b/tests/py/inet/ip.t.payload.netdev
> @@ -12,3 +12,17 @@ netdev test-netdev ingress
>    [ payload load 6b @ link header + 6 => reg 10 ]
>    [ lookup reg 1 set __set%d ]
>  
> +# meta protocol ip ip saddr . ip daddr . ether saddr { 1.1.1.1 . 2.2.2.2 . ca:fe:ca:fe:ca:fe }
> +__set%d test-netdev 3
> +__set%d test-netdev 0
> +	element 01010101 02020202 fecafeca 0000feca  : 0 [end]
> +netdev test-netdev egress 
> +  [ meta load protocol => reg 1 ]
> +  [ cmp eq reg 1 0x00000008 ]
> +  [ meta load iiftype => reg 1 ]
> +  [ cmp eq reg 1 0x00000001 ]
> +  [ payload load 4b @ network header + 12 => reg 1 ]
> +  [ payload load 4b @ network header + 16 => reg 9 ]
> +  [ payload load 6b @ link header + 6 => reg 10 ]
> +  [ lookup reg 1 set __set%d ]
> +

This payload dump is identical to the one which exists in that file
already with the exception of the chain name. AFAIR, nft-test.py checks
only element list and VM code when verifying, deliberately ignoring the
chain name (so a single payload dump serves all tested chains). From my
perspective, you should not need to add any payload dump at all. Could
you please try without them?

Thanks, Phil
