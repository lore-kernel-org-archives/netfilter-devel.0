Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4137CC433F5
	for <netfilter-devel@archiver.kernel.org>; Wed, 27 Oct 2021 09:09:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 17FFB61039
	for <netfilter-devel@archiver.kernel.org>; Wed, 27 Oct 2021 09:09:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239925AbhJ0JLy (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 27 Oct 2021 05:11:54 -0400
Received: from mail.netfilter.org ([217.70.188.207]:47748 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239877AbhJ0JLx (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 27 Oct 2021 05:11:53 -0400
Received: from netfilter.org (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 8CD5763F04;
        Wed, 27 Oct 2021 11:07:39 +0200 (CEST)
Date:   Wed, 27 Oct 2021 11:09:23 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Phil Sutter <phil@nwl.cc>,
        =?utf-8?B?xaB0xJtww6FuIE7Em21lYw==?= <snemec@redhat.com>,
        netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft] tests: run-tests.sh: ensure non-zero exit when
 $failed != 0
Message-ID: <YXkXQ2hrbZJ7YLcw@salvia>
References: <20211020124409.489875-1-snemec@redhat.com>
 <20211020150641.GK1668@orbyte.nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20211020150641.GK1668@orbyte.nwl.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Phil,

On Wed, Oct 20, 2021 at 05:06:41PM +0200, Phil Sutter wrote:
> Hi,
> 
> On Wed, Oct 20, 2021 at 02:44:09PM +0200, Štěpán Němec wrote:
> > POSIX [1] does not specify the behavior of `exit' with arguments
> > outside the 0-255 range, but what generally (bash, dash, zsh, OpenBSD
> > ksh, busybox) seems to happen is the shell exiting with status & 255
> > [2], which results in zero exit for certain non-zero arguments.
> 
> Standards aside, failed=256 is an actual bug:
> 
> | % bash -c "exit 255"; echo $?
> | 255
> | % bash -c "exit 256"; echo $?
> | 0
> | % bash -c "exit 257"; echo $?
> | 1

This is extra information you provided here for the commit message for
completion?

Thanks.
