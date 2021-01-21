Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3B41C433E0
	for <netfilter-devel@archiver.kernel.org>; Thu, 21 Jan 2021 15:08:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 51E7E238A1
	for <netfilter-devel@archiver.kernel.org>; Thu, 21 Jan 2021 15:08:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732408AbhAUPIh (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 21 Jan 2021 10:08:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731979AbhAUPFH (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 21 Jan 2021 10:05:07 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F36BFC0613D6
        for <netfilter-devel@vger.kernel.org>; Thu, 21 Jan 2021 07:04:26 -0800 (PST)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1l2bVZ-0003io-Ig; Thu, 21 Jan 2021 16:04:25 +0100
Date:   Thu, 21 Jan 2021 16:04:25 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH 4/4] json: icmp: refresh json output
Message-ID: <20210121150425.GR3158@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
References: <20210121135510.14941-1-fw@strlen.de>
 <20210121135510.14941-5-fw@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210121135510.14941-5-fw@strlen.de>
Sender:  <n0-1@orbyte.nwl.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

On Thu, Jan 21, 2021 at 02:55:10PM +0100, Florian Westphal wrote:
> nft inserts dependencies for icmp header types, but I forgot to
> update the json test files to reflect this change.

For asymmetric JSON output, there are *.t.json.output files. Please add
the missing dependency expressions there.

In general, *.t.json files should contain JSON equivalents for rules as
they are *input* into nft. So we want them to be as close to the
introductory standard syntax comment as possible. This patch "breaks" a
few cases, e.g.:

[...]
> @@ -301,6 +301,8 @@
>                      "source-quench",
>                      "redirect",
>                      "echo-request",
> +                    "router-advertisement",
> +                    "router-solicitation",
>                      "time-exceeded",
>                      "parameter-problem",
>                      "timestamp-request",
> @@ -308,9 +310,7 @@
>                      "info-request",
>                      "info-reply",
>                      "address-mask-request",
> -                    "address-mask-reply",
> -                    "router-advertisement",
> -                    "router-solicitation"
> +                    "address-mask-reply"
>                  ]
>              }
>          }

Input is indeed sorted as prior to this patch. The reordered output is
found in icmp.t.json.output. The benefit from being picky here is minor,
but here's a better example:

[...]
> @@ -466,11 +482,11 @@
>                      "protocol": "icmp"
>                  }
>              },
> -	    "op": "==",
> +            "op": "==",
>              "right": {
>                  "set": [
> -                    2,
> -                    4,
> +                    "prot-unreachable",
> +                    "frag-needed",
>                      33,
>                      54,
>                      56

We test that icmp code values 2 and 4 are accepted. Standard syntax test
covers the asymmetric output containing the names. JSON should do the
same. OTOH, names as input is tested in the negated form of the same
test which follows this one.

Thanks, Phil
