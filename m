Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29F78C433B4
	for <netfilter-devel@archiver.kernel.org>; Sat, 15 May 2021 00:57:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 01CCE613F2
	for <netfilter-devel@archiver.kernel.org>; Sat, 15 May 2021 00:57:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234666AbhEOA6i (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 14 May 2021 20:58:38 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:39988 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234599AbhEOA6e (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 14 May 2021 20:58:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1621040241;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rxGaQwvsNYK5N1lvG59CWQ+jpZLPd1XR2Zv9ItBnlNU=;
        b=FU1O2qHGRaoodRyZAP6cD23IC1+ucMxaCeNipiGzaaRSmTDn5VnVS7gY+m2lMURbDYJWJc
        NsYWjyAEIl9cLfWpxZrgAVykfZb87Ag39T0p2PhSZHqtWRQ1KG0jHkiFVxulRDqjPvt6R1
        pd3hBusyInb+UdlngwRvR+qLJSWpFes=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-390-r7-IS_iQNDewmQ7URIH4XQ-1; Fri, 14 May 2021 20:57:19 -0400
X-MC-Unique: r7-IS_iQNDewmQ7URIH4XQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B48E1107ACC7;
        Sat, 15 May 2021 00:57:18 +0000 (UTC)
Received: from maya.cloud.tilaa.com (unknown [10.36.110.6])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6B0F05D9CD;
        Sat, 15 May 2021 00:57:18 +0000 (UTC)
Date:   Sat, 15 May 2021 02:57:08 +0200
From:   Stefano Brivio <sbrivio@redhat.com>
To:     Florian Westphal <fw@strlen.de>
Cc:     <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH nf-next 0/2] nf_tables: avoid retpoline overhead on set
 lookups
Message-ID: <20210515025708.1cacf2ac@elisabeth>
In-Reply-To: <20210513202956.22709-1-fw@strlen.de>
References: <20210513202956.22709-1-fw@strlen.de>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Florian,

On Thu, 13 May 2021 22:29:54 +0200
Florian Westphal <fw@strlen.de> wrote:

> This adds a nft_set_do_lookup() helper, then extends it to use
> direct calls when RETPOLINE feature is enabled.
> 
> For non-retpoline builds, nft_set_do_lookup() inline helper
> does a indirect call.  INDIRECT_CALLABLE_SCOPE macro allows to
> keep the lookup functions static in this case.

Thanks for doing this! And sorry I looked into it more than one year
ago without ever finishing it ;)

I ran some quick tests, I was curious to see the impact of dropping
indirect calls on that path. With the 'performance' test cases of
nft_concat_range.sh, roughly estimating clock cycles as clock frequency
divided by packet rate, it looks like this offsets entirely the usage of
retpolines!

With a 'return true;' in the lookup function (I patched nft_set_pipapo),
on my usual single AMD Epyc 7351 thread, 2.9GHz, average of three runs,
I get:

                                               | packet |  est.  |
                                               |  rate  | cycles |
                                               | (Mpps) |        |
-----------------------------------------------|--------|--------|
Without retpolines, netdev drop                | 15.443 |    188 |
Without retpolines, dummy lookup function      |  9.995 |    292 |
-> Without retpolines, set lookup              |        |    104-|-.
- - - - - - - - - - - - - - - - - - - - - - - -|- - - - | - - - -|
With retpolines, netdev drop                   | 10.420 |    278 | |
With retpolines, dummy lookup function         |  7.038 |    412 |
-> With retpolines, set lookup                 |        |    134 | |
- - - - - - - - - - - - - - - - - - - - - - - -|- - - - | - - - -|
This series, retpolines, netdev drop           | 10.431 |    278 | |
This series, retpolines, dummy lookup function |  7.549 |    384 |
-> This series, retpolines, set lookup         |  ^ +7% |    106-|-'

estimated clock cycles for set lookup only are the difference between
cycles to hit the dummy lookup function and cycles to drop packets from
the netdev hook -- they're now approximately the same with and without
retpolines.

For context, I also ran the whole set of tests with actual matching.
This is indicative, just a single run:

 --------------.-----------------------------------.--------------------------.
AMD Epyc 7351  |          baselines, Mpps          |       this series        |
 1 thread      |___________________________________|__________________________|
 2.9GHz        |        |        |        |        |        |        |        |
 512KiB L1D$   | netdev |  hash  | rbtree |        |  hash  | rbtree |        |
 --------------|  hook  |   no   | single |        |   no   | single |        |
type   entries |  drop  | ranges | field  | pipapo | ranges | field  | pipapo |
 --------------|--------|--------|--------|--------|--------|-----------------|
net,port       |        |        |        |        | +15%   |  +4%   |  +4%   |
         1000  |   10.1 |    5.2 |    2.7 |    4.6 |    6.0 |    2.8 |    4.8 |
 --------------|--------|--------|--------|--------|--------|--------|--------|
port,net       |        |        |        |        | +11%   |  +5%   |  +4%   |
          100  |   10.4 |    5.4 |    4.1 |    5.0 |    6.0 |    4.3 |    5.2 |
 --------------|--------|--------|--------|--------|--------|--------|--------|
net6,port      |        |        |        |        | +15%   |  +9%   |  +6%   |
         1000  |   10.0 |    4.6 |    1.1 |    3.1 |    9.9 |    1.2 |    3.3 |
 --------------|--------|--------|--------|--------|--------|--------|--------|
port,proto     |        |        |        |        |  +7%   |  +3%   |  +3%   |
        10000  |   10.7 |    6.0 |    3.0 |    3.0 |    6.4 |    3.1 |    3.1 |
 --------------|--------|--------|--------|--------|--------|--------|--------|
net6,port,mac  |        |        |        |        |  +3%   |  +4%   |  +3%   |
           10  |    9.9 |    3.8 |    2.7 |    3.3 |    3.9 |    2.8 |    3.4 |
 --------------|--------|--------|--------|--------|--------|--------|--------|
net6,port,mac, |        |        |        |        |  +3%   |  +9%   |  +4%   |
proto    1000  |   10.0 |    3.6 |    1.1 |    2.4 |    3.7 |    1.2 |    2.5 |
 --------------|--------|--------|--------|--------|--------|--------|--------|
net,mac        |        |        |        |        |  +6%   |  +4%   |  +3%   |
         1000  |   10.5 |    4.8 |    2.7 |    4.0 |    5.1 |    2.8 |    4.1 |
 --------------'--------'--------'--------'--------'--------'--------'--------'

-- 
Stefano

