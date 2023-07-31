Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7215C001DC
	for <netfilter-devel@archiver.kernel.org>; Mon, 31 Jul 2023 12:23:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231651AbjGaMX5 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 31 Jul 2023 08:23:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231894AbjGaMXz (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 31 Jul 2023 08:23:55 -0400
Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [IPv6:2001:780:45:1d:225:90ff:fe52:c662])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BF92E44
        for <netfilter-devel@vger.kernel.org>; Mon, 31 Jul 2023 05:23:27 -0700 (PDT)
Received: from [46.222.105.127] (port=12776 helo=gnumonks.org)
        by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <pablo@gnumonks.org>)
        id 1qQRvd-000r7e-DR; Mon, 31 Jul 2023 14:23:15 +0200
Date:   Mon, 31 Jul 2023 14:23:10 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel <netfilter-devel@vger.kernel.org>
Subject: Re: nftables: syntax ambiguity with objref map and ct helper objects
Message-ID: <ZMenriLfu+luvh9i@calendula>
References: <20230728195614.GA18109@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230728195614.GA18109@breakpoint.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Florian,

On Fri, Jul 28, 2023 at 09:56:14PM +0200, Florian Westphal wrote:
> Hi,
> 
> I wanted to allow creating objref maps that
> return "ct timeout" or "ct helper" templates.
> 
> However:
>   map .. {
>     type ipv4_addr : ct timeout
> 
>   The above is fine, but this is not:
> 
>   map .. {
>     type ipv4_addr : ct helper

This is type, not typeof, is it intentional?

> It caues ambiguity in parser due to existing
> "ct helper" expression, as in
> "nft describe ct helper", not the freestanding
> objref name.
> 
> I could just allow:
>     type ipv4_addr : helper
> 
> ... without "ct", but then we'd require different
> keywords for the definition and the use as data
> element in the key definition, and its inconsistent
> with "ct timeout".
> 
> Should we add a new explicit keyword for
> *both* objref names and the data element usage?
> 
> Perhaps:
> 
> object type ct helper "sip-external" {
>     ....
> 
> And
>     type ipv4_addr : object type ct helper
> 
> ?
> 
> Any better ideas or suggesions on a sane syntax to avoid this?

This works fine with typeof:

table ip x {
        map x {
                typeof ip saddr : ct helper
        }
}

it seems typeof support for 'ct timeout' is missing?

Thanks for reporting.
