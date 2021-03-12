Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6BAE4C433E6
	for <netfilter-devel@archiver.kernel.org>; Fri, 12 Mar 2021 13:14:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 32E9B64FF9
	for <netfilter-devel@archiver.kernel.org>; Fri, 12 Mar 2021 13:14:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231201AbhCLNNt (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 12 Mar 2021 08:13:49 -0500
Received: from static-213-198-238-194.adsl.eunet.rs ([213.198.238.194]:42162
        "EHLO fx.arvanta.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231821AbhCLNNm (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 12 Mar 2021 08:13:42 -0500
Received: from arya.arvanta.net (arya.arvanta.net [10.5.1.6])
        by fx.arvanta.net (Postfix) with ESMTP id 0E1D715D0E;
        Fri, 12 Mar 2021 14:13:35 +0100 (CET)
Date:   Fri, 12 Mar 2021 14:13:34 +0100
From:   Milan =?utf-8?Q?P=2E_Stani=C4=87?= <mps@arvanta.net>
To:     Jan Engelhardt <jengelh@inai.de>
Cc:     Netfilter Developer Mailing List 
        <netfilter-devel@vger.kernel.org>,
        Paolo Pisati <p.pisati@gmail.com>
Subject: Re: xtables-addons-3.17 fail build on armv7 with musl libc
Message-ID: <YEto/oEJUGFYBBZF@arya.arvanta.net>
References: <YEaQ2wXhLxG69EQg@arya.arvanta.net>
 <813166p2-2s15-op14-8r17-64oo79q9n@vanv.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <813166p2-2s15-op14-8r17-64oo79q9n@vanv.qr>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

On Thu, 2021-03-11 at 17:18, Jan Engelhardt wrote:
> On Monday 2021-03-08 22:02, Milan P. Stanić wrote:
> 
> >I'm trying to fix build of xtables-addons-3.17 on Alpine Linux which is
> >based on musl libc. Build pass on our x86, x86_64, aarch64, ppc64le and
> >s390x arches but fails on armv7. Here is excerpt from build log.
> >
> >   33 | static inline uint32_t __div64_32(uint64_t *n, uint32_t base)
> >      |                                   ~~~~~~~~~~^
> 
> I have addresses the issue in v3.18 now. No new warnings have shown to me with
> regards to time_after.

Yes, it works now without any warning or error. Thanks
