Return-Path: <SRS0=yEJZ=DP=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F3C6C04EBE
	for <netfilter-devel@archiver.kernel.org>; Thu,  8 Oct 2020 16:07:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F203121D7D
	for <netfilter-devel@archiver.kernel.org>; Thu,  8 Oct 2020 16:07:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730861AbgJHQHR (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 8 Oct 2020 12:07:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730664AbgJHQHR (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 8 Oct 2020 12:07:17 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1288EC061755
        for <netfilter-devel@vger.kernel.org>; Thu,  8 Oct 2020 09:07:17 -0700 (PDT)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1kQYRm-00073V-Az; Thu, 08 Oct 2020 18:07:14 +0200
Date:   Thu, 8 Oct 2020 18:07:14 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Jan Engelhardt <jengelh@inai.de>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
Subject: Re: [iptables PATCH] libiptc: Avoid gcc-10 zero-length array warning
Message-ID: <20201008160714.GB13016@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Jan Engelhardt <jengelh@inai.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
References: <20201008130116.25798-1-phil@nwl.cc>
 <s95qopq1-3o5o-oo9-1qso-osp024914p67@vanv.qr>
 <20201008145822.GA13016@orbyte.nwl.cc>
 <q9379q5-3n1-p1r-1ro4-n5q2r086574q@vanv.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <q9379q5-3n1-p1r-1ro4-n5q2r086574q@vanv.qr>
Sender:  <n0-1@orbyte.nwl.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Oct 08, 2020 at 05:31:03PM +0200, Jan Engelhardt wrote:
> 
> On Thursday 2020-10-08 16:58, Phil Sutter wrote:
> >
> >While the question of whether kernel UAPI headers should adhere to
> >strict ISO C or not may be debatable, my motivation for working around
> >the situation in user space comes from Gustavo's complaints when I tried
> >to convert the relevant struct members into flexible arrays. He
> >apparently is a burnt child looking at commit 1e6e9d0f4859e ("uapi:
> >revert flexible-array conversions").
> 
> Ugh... RDMA.
> 
> iptables does not rely or even do such embedding nonsense. When we
> have a flexible array member T x[0] or T x[] somewhere, we really do
> mean that Ts follow, not some Us like in the RDMA case.

In fact, struct ipt_replace has a zero-length array as last field of
type struct ipt_entry which in turn has a zero-length array as last
field. :)

Embedding is allowed as a gcc-extension. So while my initial approach at
getting rid of the warning in iptables compile-output worked, it didn't
make the header ISO C compatible.

> It's probably fair to restore [] for our headers.

Since gcc in pedantic mode neither accepts zero length arrays nor
embedded structs with flexible member arrays, doing so won't break ISO C
compatibility at least. ;)

Cheers, Phil
