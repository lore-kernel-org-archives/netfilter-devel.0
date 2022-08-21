Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC6FFC00140
	for <netfilter-devel@archiver.kernel.org>; Sun, 21 Aug 2022 14:02:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230363AbiHUOCE (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 21 Aug 2022 10:02:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230507AbiHUOBm (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 21 Aug 2022 10:01:42 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4C7F0248C5
        for <netfilter-devel@vger.kernel.org>; Sun, 21 Aug 2022 07:00:45 -0700 (PDT)
Date:   Sun, 21 Aug 2022 16:00:38 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf] netfilter: nft_fwd: really validate family
Message-ID: <YwI6hox1BhpK8NPE@salvia>
References: <20220821103813.734773-1-pablo@netfilter.org>
 <20220821103813.734773-2-pablo@netfilter.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220821103813.734773-2-pablo@netfilter.org>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Sun, Aug 21, 2022 at 12:38:13PM +0200, Pablo Neira Ayuso wrote:
> This only supports for the netdev family, report EOPNOTSUPP otherwise.

Scratch this, this is already validated via .family field in
expression type.
