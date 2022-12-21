Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09271C4332F
	for <netfilter-devel@archiver.kernel.org>; Wed, 21 Dec 2022 16:41:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234635AbiLUQlg (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 21 Dec 2022 11:41:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234668AbiLUQld (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 21 Dec 2022 11:41:33 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 58FE123339
        for <netfilter-devel@vger.kernel.org>; Wed, 21 Dec 2022 08:41:20 -0800 (PST)
Date:   Wed, 21 Dec 2022 17:41:17 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     phil@nwl.cc
Subject: Re: [PATCH nft] owner: Fix potential array out of bounds access
Message-ID: <Y6M3LQU5rXnNw1DX@salvia>
References: <20221221163746.63408-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20221221163746.63408-1-pablo@netfilter.org>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Dec 21, 2022 at 05:37:46PM +0100, Pablo Neira Ayuso wrote:
> If the link target length exceeds 'sizeof(tmp)' bytes, readlink() will
> return 'sizeof(tmp)'. Using this value as index is illegal.
> 
> Original update from Phil, for the conntrack-tools tree, which also has
> a copy of this function.

For the record: If this code is generalized, this code is a candidate
for libmnl I think.
