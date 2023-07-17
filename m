Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6260C001B0
	for <netfilter-devel@archiver.kernel.org>; Mon, 17 Jul 2023 11:19:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229658AbjGQLTd (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 17 Jul 2023 07:19:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229915AbjGQLTc (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 17 Jul 2023 07:19:32 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C75A51B9
        for <netfilter-devel@vger.kernel.org>; Mon, 17 Jul 2023 04:19:30 -0700 (PDT)
Date:   Mon, 17 Jul 2023 13:19:26 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Arturo Borrero Gonzalez <arturo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH] tests/build/run-tests.sh: fix issues reported by
 shellcheck
Message-ID: <ZLUjvpQ22001nDkV@calendula>
References: <168958880448.138167.17646583365002263276.stgit@nostromo.nostromo>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <168958880448.138167.17646583365002263276.stgit@nostromo.nostromo>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, Jul 17, 2023 at 12:13:24PM +0200, Arturo Borrero Gonzalez wrote:
> Improve a bit the script as reported by shellcheck, also including
> information about the log file.
> 
> The log file, by the way, is added to the gitignore to reduce noise
> in the git tree.

Applied, thanks
