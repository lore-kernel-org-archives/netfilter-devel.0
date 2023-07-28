Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB597C001DE
	for <netfilter-devel@archiver.kernel.org>; Fri, 28 Jul 2023 17:34:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233565AbjG1Res (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 28 Jul 2023 13:34:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234281AbjG1Rep (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 28 Jul 2023 13:34:45 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 925E63A9A
        for <netfilter-devel@vger.kernel.org>; Fri, 28 Jul 2023 10:34:43 -0700 (PDT)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1qPRMP-0000pO-Av
        for netfilter-devel@vger.kernel.org; Fri, 28 Jul 2023 19:34:41 +0200
Date:   Fri, 28 Jul 2023 19:34:41 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     netfilter-devel@vger.kernel.org
Subject: Re: [iptables PATCH 1/4] *tables-restore: Enforce correct counters
 syntax if present
Message-ID: <ZMP8MZOvEK4Zxq7i@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        netfilter-devel@vger.kernel.org
References: <20230728123147.15750-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230728123147.15750-1-phil@nwl.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, Jul 28, 2023 at 02:31:44PM +0200, Phil Sutter wrote:
> If '--counters' option was not given, restore parsers would ignore
> anything following the policy word. Make them more strict, rejecting
> anything in that spot which does not look like counter values even if
> not restoring counters.
> 
> Signed-off-by: Phil Sutter <phil@nwl.cc>

Series applied.
