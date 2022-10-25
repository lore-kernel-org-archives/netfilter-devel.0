Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A089C04A95
	for <netfilter-devel@archiver.kernel.org>; Tue, 25 Oct 2022 11:52:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231315AbiJYLwi (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 25 Oct 2022 07:52:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231415AbiJYLwh (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 25 Oct 2022 07:52:37 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2770FF0377
        for <netfilter-devel@vger.kernel.org>; Tue, 25 Oct 2022 04:52:37 -0700 (PDT)
Date:   Tue, 25 Oct 2022 13:52:33 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Phil Sutter <phil@nwl.cc>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [nf-next PATCH 0/2] Support resetting rules' state
Message-ID: <Y1fOAZkQU8u81mPf@salvia>
References: <20221014214559.22254-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20221014214559.22254-1-phil@nwl.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, Oct 14, 2022 at 11:45:57PM +0200, Phil Sutter wrote:
> In order to "zero" a rule (in the 'iptables -Z' sense), users had to
> dump (parts of) the ruleset in stateless form and restore it again after
> removing the dumped parts.
> 
> Introduce a simpler method to reset any stateful elements of a rule or
> all rules of a chain/table/family. Affects both counter and quota
> expressions.

Patchset LGTM.

For the record, we agreed on the workshop to extend this to:

- add support for this command to table, chain and set objects too.
- validate that nft syntax is consistent from userspace with other
  existing commands (for example, list).

Thanks Phil.
