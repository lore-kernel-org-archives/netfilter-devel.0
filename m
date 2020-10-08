Return-Path: <SRS0=yEJZ=DP=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89047C433DF
	for <netfilter-devel@archiver.kernel.org>; Thu,  8 Oct 2020 16:46:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1FDE421D7D
	for <netfilter-devel@archiver.kernel.org>; Thu,  8 Oct 2020 16:46:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730267AbgJHQqn (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 8 Oct 2020 12:46:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730235AbgJHQqn (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 8 Oct 2020 12:46:43 -0400
Received: from a3.inai.de (a3.inai.de [IPv6:2a01:4f8:10b:45d8::f5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82404C061755
        for <netfilter-devel@vger.kernel.org>; Thu,  8 Oct 2020 09:46:43 -0700 (PDT)
Received: by a3.inai.de (Postfix, from userid 25121)
        id ECD1F58757E98; Thu,  8 Oct 2020 18:46:40 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by a3.inai.de (Postfix) with ESMTP id E8BDF60E6E48A;
        Thu,  8 Oct 2020 18:46:40 +0200 (CEST)
Date:   Thu, 8 Oct 2020 18:46:40 +0200 (CEST)
From:   Jan Engelhardt <jengelh@inai.de>
To:     Phil Sutter <phil@nwl.cc>
cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
Subject: Re: [iptables PATCH] libiptc: Avoid gcc-10 zero-length array
 warning
In-Reply-To: <20201008160714.GB13016@orbyte.nwl.cc>
Message-ID: <9437p77p-4rp3-q1rn-745q-9267q7osor7s@vanv.qr>
References: <20201008130116.25798-1-phil@nwl.cc> <s95qopq1-3o5o-oo9-1qso-osp024914p67@vanv.qr> <20201008145822.GA13016@orbyte.nwl.cc> <q9379q5-3n1-p1r-1ro4-n5q2r086574q@vanv.qr> <20201008160714.GB13016@orbyte.nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


On Thursday 2020-10-08 18:07, Phil Sutter wrote:
>> iptables does not rely or even do such embedding nonsense. When we
>> have a flexible array member T x[0] or T x[] somewhere, we really do
>> mean that Ts follow, not some Us like in the RDMA case.
>
>In fact, struct ipt_replace has a zero-length array as last field of
>type struct ipt_entry which in turn has a zero-length array as last
>field. :)

In the RDMA thread, I was informed that the trailing members' only
purpose is to serve as something of a shorthand:

Shortcut:
	struct ipt_entry *e = replace->elements;
The long way:
	struct ipt_entry *e = (void *)((char *)replace + sizeof(*replace));

But such gritty detail is often stowed away in some nice accessor
functions or macros. That's what's currently missing in spots
apprently.

	struct ipt_entry *next = get_next_blah(replace);

Then the get_next can do that arithmetic, we won't need
ipt_replace::elements, and could do away with the flexible array
member altogether, especially when it's not used with equal-sized
elements, and ipt_entry is of variadic size.
