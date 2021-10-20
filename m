Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2616C433F5
	for <netfilter-devel@archiver.kernel.org>; Wed, 20 Oct 2021 15:06:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B8438611EF
	for <netfilter-devel@archiver.kernel.org>; Wed, 20 Oct 2021 15:06:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230355AbhJTPI7 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 20 Oct 2021 11:08:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230340AbhJTPI4 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 20 Oct 2021 11:08:56 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9925BC061749
        for <netfilter-devel@vger.kernel.org>; Wed, 20 Oct 2021 08:06:42 -0700 (PDT)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1mdDAv-00055C-13; Wed, 20 Oct 2021 17:06:41 +0200
Date:   Wed, 20 Oct 2021 17:06:41 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     =?utf-8?B?xaB0xJtww6FuIE7Em21lYw==?= <snemec@redhat.com>
Cc:     netfilter-devel@vger.kernel.org,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nft] tests: run-tests.sh: ensure non-zero exit when
 $failed != 0
Message-ID: <20211020150641.GK1668@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        =?utf-8?B?xaB0xJtww6FuIE7Em21lYw==?= <snemec@redhat.com>,
        netfilter-devel@vger.kernel.org,
        Pablo Neira Ayuso <pablo@netfilter.org>
References: <20211020124409.489875-1-snemec@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20211020124409.489875-1-snemec@redhat.com>
Sender:  <n0-1@orbyte.nwl.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

On Wed, Oct 20, 2021 at 02:44:09PM +0200, Štěpán Němec wrote:
> POSIX [1] does not specify the behavior of `exit' with arguments
> outside the 0-255 range, but what generally (bash, dash, zsh, OpenBSD
> ksh, busybox) seems to happen is the shell exiting with status & 255
> [2], which results in zero exit for certain non-zero arguments.

Standards aside, failed=256 is an actual bug:

| % bash -c "exit 255"; echo $?
| 255
| % bash -c "exit 256"; echo $?
| 0
| % bash -c "exit 257"; echo $?
| 1

Thanks, Phil
