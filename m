Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C40E4C43334
	for <netfilter-devel@archiver.kernel.org>; Tue, 28 Jun 2022 17:03:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232501AbiF1RDA (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 28 Jun 2022 13:03:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234249AbiF1RCd (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 28 Jun 2022 13:02:33 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3014119292
        for <netfilter-devel@vger.kernel.org>; Tue, 28 Jun 2022 10:02:33 -0700 (PDT)
Date:   Tue, 28 Jun 2022 19:02:30 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf] netfilter: nft_dynset: restore set element counter
 when failing to update
Message-ID: <Yrs0JistID/VWqzZ@salvia>
References: <20220622093219.194566-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220622093219.194566-1-pablo@netfilter.org>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Jun 22, 2022 at 11:32:19AM +0200, Pablo Neira Ayuso wrote:
> This patch fixes a race condition.
> 
> nft_rhash_update() might fail for two reasons:
> 
> - Element already exists in the hashtable.
> - Another packet won race to insert an entry in the hashtable.
> 
> In both cases, new() has already bumped the counter via atomic_add_unless().
> Decrement the set element counter in this case.

For the record: I'll place this in nf.git.
