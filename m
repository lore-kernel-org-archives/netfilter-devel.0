Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 059C4C4338F
	for <netfilter-devel@archiver.kernel.org>; Thu, 12 Aug 2021 08:21:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D893A60EB2
	for <netfilter-devel@archiver.kernel.org>; Thu, 12 Aug 2021 08:21:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235117AbhHLIV1 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 12 Aug 2021 04:21:27 -0400
Received: from mail.netfilter.org ([217.70.188.207]:47014 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234199AbhHLIV1 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 12 Aug 2021 04:21:27 -0400
Received: from netfilter.org (bl11-146-165.dsl.telepac.pt [85.244.146.165])
        by mail.netfilter.org (Postfix) with ESMTPSA id 1C55A60074
        for <netfilter-devel@vger.kernel.org>; Thu, 12 Aug 2021 10:20:18 +0200 (CEST)
Date:   Thu, 12 Aug 2021 10:20:55 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Netfilter Development <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH libnetfilter_queue] include: deprecate
 libnetfilter_queue/linux_nfnetlink_queue.h
Message-ID: <20210812082055.GA1284@salvia>
References: <20210810160813.26984-1-pablo@netfilter.org>
 <YRNsdKcEl0z3a2ox@slk1.local.net>
 <20210811090203.GA23374@salvia>
 <YRQfo6YISjO7z6gH@slk1.local.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <YRQfo6YISjO7z6gH@slk1.local.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Aug 12, 2021 at 05:06:11AM +1000, Duncan Roe wrote:
> On Wed, Aug 11, 2021 at 11:02:03AM +0200, Pablo Neira Ayuso wrote:
> > On Wed, Aug 11, 2021 at 04:21:40PM +1000, Duncan Roe wrote:
> > [...]
> > > Suggest you leave include/libnetfilter_queue/libnetfilter_queue.h unaltered.
> > >
> > > That way, if a user fails to insert linux/netfilter/nfnetlink_queue.h at all, he
> > > will get the warning. With the patched libnetfilter_queue.h, he will get
> > > compilation errors where previously he did not.
> >
> > OK, done and pushed it out. Thanks.
> 
> You really didn't need all these extra #include lines. The only source that
> doesn't compile with "#include <libnetfilter_queue/linux_nfnetlink_queue.h>"
> removed from libnetfilter_queue.h is libnetfilter_queue.c.

Those are needed, otherwise libnetfilter_queue emits warnings all over
the place.
