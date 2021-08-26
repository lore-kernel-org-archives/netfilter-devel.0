Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F25BCC4320A
	for <netfilter-devel@archiver.kernel.org>; Thu, 26 Aug 2021 10:51:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D7408606A5
	for <netfilter-devel@archiver.kernel.org>; Thu, 26 Aug 2021 10:51:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241744AbhHZKvv (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 26 Aug 2021 06:51:51 -0400
Received: from mail.netfilter.org ([217.70.188.207]:58906 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234055AbhHZKvv (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 26 Aug 2021 06:51:51 -0400
Received: from netfilter.org (unknown [78.30.35.141])
        by mail.netfilter.org (Postfix) with ESMTPSA id DEA6B6017B;
        Thu, 26 Aug 2021 12:50:08 +0200 (CEST)
Date:   Thu, 26 Aug 2021 12:51:00 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Tom Yan <tom.ty89@gmail.com>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [Bug] Reverse translation skips "leading" meta protocol match
Message-ID: <20210826105100.GA4859@salvia>
References: <CAGnHSEmo1D2bCemVuCT-D2jdM8AmUgGKxZrq0RpXUMaLyQqjwA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAGnHSEmo1D2bCemVuCT-D2jdM8AmUgGKxZrq0RpXUMaLyQqjwA@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Aug 26, 2021 at 12:10:05PM +0800, Tom Yan wrote:
[...]
> bridge meh hmm 3 2
>   [ meta load protocol => reg 1 ]
>   [ cmp eq reg 1 0x00000008 ]
>   [ meta load l4proto => reg 1 ]
>   [ cmp eq reg 1 0x00000011 ]
>   [ payload load 2b @ transport header + 2 => reg 1 ]
>   [ cmp eq reg 1 0x00004300 ]
>   [ immediate reg 0 accept ]

https://patchwork.ozlabs.org/project/netfilter-devel/patch/20210826104952.4812-1-pablo@netfilter.org/
