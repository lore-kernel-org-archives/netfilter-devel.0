Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71C7FC433F5
	for <netfilter-devel@archiver.kernel.org>; Tue, 29 Mar 2022 21:28:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234166AbiC2V3r (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 29 Mar 2022 17:29:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234245AbiC2V3q (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 29 Mar 2022 17:29:46 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C9266236BB2
        for <netfilter-devel@vger.kernel.org>; Tue, 29 Mar 2022 14:28:03 -0700 (PDT)
Received: from netfilter.org (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id E59B963032;
        Tue, 29 Mar 2022 23:24:49 +0200 (CEST)
Date:   Tue, 29 Mar 2022 23:28:00 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Phil Sutter <phil@nwl.cc>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [libnfnetlink PATCH 2/2] libnfnetlink: Check getsockname()
 return code
Message-ID: <YkN54N/bHp7zfcEz@salvia>
References: <20220325173426.11493-1-phil@nwl.cc>
 <20220325173426.11493-2-phil@nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220325173426.11493-2-phil@nwl.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, Mar 25, 2022 at 06:34:26PM +0100, Phil Sutter wrote:
> The function may return -1 (and set errno). Assume it will leave
> addr_len value unchanged, so checking is necessary to not hide the
> error.

LGTM.

> Fixes: 4248314d40187 ("nfnl: fix compilation warning with gcc-4.7")
> Signed-off-by: Phil Sutter <phil@nwl.cc>
