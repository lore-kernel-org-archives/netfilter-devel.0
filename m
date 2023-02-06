Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC390C05027
	for <netfilter-devel@archiver.kernel.org>; Mon,  6 Feb 2023 10:20:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229899AbjBFKUC (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 6 Feb 2023 05:20:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230239AbjBFKTk (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 6 Feb 2023 05:19:40 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C4F80ED
        for <netfilter-devel@vger.kernel.org>; Mon,  6 Feb 2023 02:19:36 -0800 (PST)
Date:   Mon, 6 Feb 2023 11:19:33 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Fernando Fernandez Mancera <ffmancera@riseup.net>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft v6] src: add support to command "destroy"
Message-ID: <Y+DUNb50mi5KiHCS@salvia>
References: <20230102143822.632-1-ffmancera@riseup.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230102143822.632-1-ffmancera@riseup.net>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, Jan 02, 2023 at 03:38:22PM +0100, Fernando Fernandez Mancera wrote:
> "destroy" command performs a deletion as "delete" command but does not fail
> when the object does not exist. As there is no NLM_F_* flag for ignoring such
> error, it needs to be ignored directly on error handling.
> 
> Example of use:
> 
> 	# nft list ruleset
>         table ip filter {
>                 chain output {
>                 }
>         }
>         # nft destroy table ip missingtable
> 	# echo $?
> 	0
>         # nft list ruleset
>         table ip filter {
>                 chain output {
>                 }
>         }

Applied, thanks.

[...]
>  create mode 100755 tests/shell/testcases/rule_management/0011destroy_0
>  create mode 100755 tests/shell/testcases/rule_management/0012destroy_0
>  create mode 100644 tests/shell/testcases/rule_management/dumps/0011destroy_0.nft
>  create mode 100644 tests/shell/testcases/rule_management/dumps/0012destroy_0.nft

More tests for other objects would be good to have.
