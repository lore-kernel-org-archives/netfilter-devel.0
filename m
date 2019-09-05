Return-Path: <SRS0=iWGL=XA=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 668CDC43331
	for <netfilter-devel@archiver.kernel.org>; Thu,  5 Sep 2019 15:54:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 04D0A206B8
	for <netfilter-devel@archiver.kernel.org>; Thu,  5 Sep 2019 15:54:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389115AbfIEPyZ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 5 Sep 2019 11:54:25 -0400
Received: from correo.us.es ([193.147.175.20]:48326 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731552AbfIEPyY (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 5 Sep 2019 11:54:24 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 12A92117726
        for <netfilter-devel@vger.kernel.org>; Thu,  5 Sep 2019 17:54:20 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 057E7A6AC
        for <netfilter-devel@vger.kernel.org>; Thu,  5 Sep 2019 17:54:20 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id EF501DA8E8; Thu,  5 Sep 2019 17:54:19 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 9A5A9DA4D0;
        Thu,  5 Sep 2019 17:54:17 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 05 Sep 2019 17:54:17 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 7A0064265A5A;
        Thu,  5 Sep 2019 17:54:17 +0200 (CEST)
Date:   Thu, 5 Sep 2019 17:54:18 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Eric Garver <eric@garver.life>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft] tests: shell: check that rule add with index works
 with echo
Message-ID: <20190905155418.z2lpiet466ceixjy@salvia>
References: <20190903232713.14394-1-eric@garver.life>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190903232713.14394-1-eric@garver.life>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Sep 03, 2019 at 07:27:13PM -0400, Eric Garver wrote:
> If --echo is used the rule cache will not be populated. This causes
> rules added using the "index" keyword to be simply appended to the
> chain. The bug was introduced in commit 3ab02db5f836 ("cache: add
> NFT_CACHE_UPDATE and NFT_CACHE_FLUSHED flags").
> 
> Signed-off-by: Eric Garver <eric@garver.life>
> ---
> I think the issue is in cache_evaluate(). It sets the flags to
> NFT_CACHE_FULL and then bails early, but I'm not sure of the best way to
> fix it. So I'll start by submitting a test case. :)
> ---
>  tests/shell/testcases/cache/0007_echo_cache_init_0 | 14 ++++++++++++++
>  .../cache/dumps/0007_echo_cache_init_0.nft         |  7 +++++++
>  2 files changed, 21 insertions(+)
>  create mode 100755 tests/shell/testcases/cache/0007_echo_cache_init_0
>  create mode 100644 tests/shell/testcases/cache/dumps/0007_echo_cache_init_0.nft
> 
> diff --git a/tests/shell/testcases/cache/0007_echo_cache_init_0 b/tests/shell/testcases/cache/0007_echo_cache_init_0
> new file mode 100755
> index 000000000000..280a0d06bdc3
> --- /dev/null
> +++ b/tests/shell/testcases/cache/0007_echo_cache_init_0
> @@ -0,0 +1,14 @@
> +#!/bin/bash
> +
> +set -e
> +
> +$NFT -i >/dev/null <<EOF
> +add table inet t
> +add chain inet t c
> +add rule inet t c accept comment "first"
> +add rule inet t c accept comment "third"
> +EOF
> +
> +# make sure the rule cache gets initialized when using echo option
> +#
> +$NFT --echo add rule inet t c index 0 accept comment '"second"' >/dev/null

Looks like the problem is index == 0?

                if (cmd->handle.index.id ||
                    cmd->handle.position.id)
                        flags |= NFT_CACHE_RULE | NFT_CACHE_UPDATE;

We might need to set up a flag, eg. cmd->handle.flags &
NFT_HANDLE_INDEX, similarly with position, given that index.id can be
zero. Alternatively, initialize index id to -1, assuming we'll never
get to ~0U index.
