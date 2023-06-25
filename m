Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8FBE1EB64DC
	for <netfilter-devel@archiver.kernel.org>; Sun, 25 Jun 2023 23:05:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229740AbjFYXFu (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 25 Jun 2023 19:05:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229701AbjFYXFr (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 25 Jun 2023 19:05:47 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 1453BE40;
        Sun, 25 Jun 2023 16:05:45 -0700 (PDT)
Date:   Mon, 26 Jun 2023 01:05:41 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Matthias Maier <tamiko@43-1.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        netfilter-devel@vger.kernel.org
Subject: Re: Kernel oops with netfilter: nf_tables: incorrect error path
 handling with NFT_MSG_NEWRULE
Message-ID: <ZJjIRQevLKW+YJP6@calendula>
References: <87cz1j5tof.fsf@43-1.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <87cz1j5tof.fsf@43-1.org>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

On Sun, Jun 25, 2023 at 12:38:08PM -0500, Matthias Maier wrote:
> Dear all,
> 
>   commit 1240eb93f0616b21c675416516ff3d74798fdc97
>          aka bdace3b1a51887211d3e49417a18fdbd315a313b (linux-6.3.y)
>   netfilter: nf_tables: incorrect error path handling with NFT_MSG_NEWRULE
> 
> causes a kernel oops on my side when booting my machine; see attached.
> 
> Reverting this commit fixes the kernel oops.
> Tested on 6.3.9 and 6.4.0-rc7

Could you give a try to these two fixes on top?

26b5a5712eb8 netfilter: nf_tables: add NFT_TRANS_PREPARE_ERROR to deal with bound set/chain
4bedf9eee016 netfilter: nf_tables: fix chain binding transaction logic

These patches are scheduled for 6.4

You might also need this one on top:

https://patchwork.ozlabs.org/project/netfilter-devel/patch/20230625224219.64876-1-pablo@netfilter.org/

If problem still persists, a reproducer would be good to have.

Thanks.
