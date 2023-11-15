Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C25AC07548
	for <netfilter-devel@archiver.kernel.org>; Wed, 15 Nov 2023 09:58:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234675AbjKOJ6t (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 15 Nov 2023 04:58:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234833AbjKOJ6s (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 15 Nov 2023 04:58:48 -0500
Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [IPv6:2001:780:45:1d:225:90ff:fe52:c662])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4983011F
        for <netfilter-devel@vger.kernel.org>; Wed, 15 Nov 2023 01:58:45 -0800 (PST)
Received: from [78.30.43.141] (port=48928 helo=gnumonks.org)
        by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <pablo@gnumonks.org>)
        id 1r3CfR-00BFWu-Fp; Wed, 15 Nov 2023 10:58:43 +0100
Date:   Wed, 15 Nov 2023 10:58:40 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Thomas Haller <thaller@redhat.com>
Cc:     NetFilter <netfilter-devel@vger.kernel.org>, fw@strlen.de
Subject: Re: [PATCH nft v3 1/6] json: fix use after free in table_flags_json()
Message-ID: <ZVSWUEhdY10ZyxWx@calendula>
References: <20231114153150.406334-1-thaller@redhat.com>
 <20231114153150.406334-2-thaller@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20231114153150.406334-2-thaller@redhat.com>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Nov 14, 2023 at 04:29:25PM +0100, Thomas Haller wrote:
> Add `$NFT -j list ruleset` to the end of "tests/shell/testcases/transactions/table_onoff".
> Then valgrind will find this issue:
> 
>   $ make -j && ./tests/shell/run-tests.sh tests/shell/testcases/transactions/table_onoff -V
> 
> Gives:
> 
>   ==286== Invalid read of size 4
>   ==286==    at 0x49B0261: do_dump (dump.c:211)
>   ==286==    by 0x49B08B8: do_dump (dump.c:378)
>   ==286==    by 0x49B08B8: do_dump (dump.c:378)
>   ==286==    by 0x49B04F7: do_dump (dump.c:273)
>   ==286==    by 0x49B08B8: do_dump (dump.c:378)
>   ==286==    by 0x49B0E84: json_dump_callback (dump.c:465)
>   ==286==    by 0x48AF22A: do_command_list_json (json.c:2016)
>   ==286==    by 0x48732F1: do_command_list (rule.c:2335)
>   ==286==    by 0x48737F5: do_command (rule.c:2605)
>   ==286==    by 0x48A867D: nft_netlink (libnftables.c:42)
>   ==286==    by 0x48A92B1: nft_run_cmd_from_buffer (libnftables.c:597)
>   ==286==    by 0x402CBA: main (main.c:533)

I have applied this. This fix does not need to wait the entire series.
