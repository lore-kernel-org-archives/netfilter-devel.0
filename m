Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9FA76C001B0
	for <netfilter-devel@archiver.kernel.org>; Thu, 10 Aug 2023 12:12:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231610AbjHJMMJ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 10 Aug 2023 08:12:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230335AbjHJMMJ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 10 Aug 2023 08:12:09 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5CE31724
        for <netfilter-devel@vger.kernel.org>; Thu, 10 Aug 2023 05:12:08 -0700 (PDT)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1qU4WN-00051R-2V
        for netfilter-devel@vger.kernel.org; Thu, 10 Aug 2023 14:12:07 +0200
Date:   Thu, 10 Aug 2023 14:12:07 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     netfilter-devel@vger.kernel.org
Subject: Re: [iptables PATCH] tests: iptables-test: Fix command segfault
 reports
Message-ID: <ZNTUF1qmdfQpcNef@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        netfilter-devel@vger.kernel.org
References: <20230810115523.28565-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230810115523.28565-1-phil@nwl.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Aug 10, 2023 at 01:55:23PM +0200, Phil Sutter wrote:
> Logging produced a stack trace due to undefined variable 'cmd'.
> 
> Fixes: 0e80cfea3762b ("tests: iptables-test: Implement fast test mode")
> Signed-off-by: Phil Sutter <phil@nwl.cc>

Patch applied.
