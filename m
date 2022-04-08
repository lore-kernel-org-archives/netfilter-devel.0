Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ECA55C433F5
	for <netfilter-devel@archiver.kernel.org>; Fri,  8 Apr 2022 12:40:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235832AbiDHMml (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 8 Apr 2022 08:42:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbiDHMmg (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 8 Apr 2022 08:42:36 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A726C176D0F
        for <netfilter-devel@vger.kernel.org>; Fri,  8 Apr 2022 05:40:31 -0700 (PDT)
Received: from netfilter.org (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 69699643A2;
        Fri,  8 Apr 2022 14:36:41 +0200 (CEST)
Date:   Fri, 8 Apr 2022 14:40:28 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Phil Sutter <phil@nwl.cc>
Cc:     netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>
Subject: Re: [nf-next PATCH] netfilter: nf_log_syslog: Consolidate entry
 checks
Message-ID: <YlAtPO6K8iUmYgJ4@salvia>
References: <20220324153422.8497-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220324153422.8497-1-phil@nwl.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Mar 24, 2022 at 04:34:22PM +0100, Phil Sutter wrote:
> Every syslog logging callback has to perform the same check to cover for
> rogue containers, introduce a helper for clarity. Drop the FIXME as
> there is a viable solution since commit 2851940ffee31 ("netfilter: allow
> logging from non-init namespaces").

Applied, thanks
