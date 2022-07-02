Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5AD9C43334
	for <netfilter-devel@archiver.kernel.org>; Sat,  2 Jul 2022 00:27:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230452AbiGBA1S (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 1 Jul 2022 20:27:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230415AbiGBA1R (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 1 Jul 2022 20:27:17 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69879564F4
        for <netfilter-devel@vger.kernel.org>; Fri,  1 Jul 2022 17:27:16 -0700 (PDT)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1o7Qyf-0005os-78
        for netfilter-devel@vger.kernel.org; Sat, 02 Jul 2022 02:27:13 +0200
Date:   Sat, 2 Jul 2022 02:27:13 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     netfilter-devel@vger.kernel.org
Subject: Re: [iptables PATCH] libxtables: Fix unsupported extension warning
 corner case
Message-ID: <Yr+Q4W408C5ZYdwc@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        netfilter-devel@vger.kernel.org
References: <20220630162957.29464-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220630162957.29464-1-phil@nwl.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Jun 30, 2022 at 06:29:57PM +0200, Phil Sutter wrote:
> Some extensions are not supported in revision 0 by user space anymore,
> for those the warning in xtables_compatible_revision() does not print as
> no revision 0 is tried.
> 
> To fix this, one has to track if none of the user space supported
> revisions were accepted by the kernel. Therefore add respective logic to
> xtables_find_{target,match}().
> 
> Note that this does not lead to duplicated warnings for unsupported
> extensions that have a revision 0 because xtables_compatible_revision()
> returns true for them to allow for extension's help output.
> 
> For the record, these ip6tables extensions are affected: set/SET,
> socket, tos/TOS, TPROXY and SNAT. In addition to that, TEE is affected
> for both families.
> 
> Fixes: 17534cb18ed0a ("Improve error messages for unsupported extensions")
> Signed-off-by: Phil Sutter <phil@nwl.cc>

Pushed to iptables.git.
