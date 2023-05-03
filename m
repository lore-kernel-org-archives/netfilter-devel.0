Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE16CC77B7F
	for <netfilter-devel@archiver.kernel.org>; Wed,  3 May 2023 18:53:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229455AbjECSxE (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 3 May 2023 14:53:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229562AbjECSxC (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 3 May 2023 14:53:02 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86B783C16
        for <netfilter-devel@vger.kernel.org>; Wed,  3 May 2023 11:53:01 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1puHb2-0000cD-3z; Wed, 03 May 2023 20:53:00 +0200
Date:   Wed, 3 May 2023 20:53:00 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Boris Sukholitko <boris.sukholitko@broadcom.com>
Cc:     netfilter-devel@vger.kernel.org,
        Ilya Lifshits <ilya.lifshits@broadcom.com>
Subject: Re: [PATCH nf-next 02/19] selftest: netfilter: no need for ps -x
 option
Message-ID: <20230503185300.GD28036@breakpoint.cc>
References: <20230503125552.41113-1-boris.sukholitko@broadcom.com>
 <20230503125552.41113-3-boris.sukholitko@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230503125552.41113-3-boris.sukholitko@broadcom.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Boris Sukholitko <boris.sukholitko@broadcom.com> wrote:
> Some ps commands (e.g. busybox derived) have no -x option. For the
> purposes of hash calculation of the list of processes this option is
> inessential.
> 
> Signed-off-by: Boris Sukholitko <boris.sukholitko@broadcom.com>
> ---
>  tools/testing/selftests/netfilter/nft_flowtable.sh | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/tools/testing/selftests/netfilter/nft_flowtable.sh b/tools/testing/selftests/netfilter/nft_flowtable.sh
> index 4d8bc51b7a7b..3cf20e9bd3a6 100755
> --- a/tools/testing/selftests/netfilter/nft_flowtable.sh
> +++ b/tools/testing/selftests/netfilter/nft_flowtable.sh
> @@ -489,8 +489,8 @@ ip -net $nsr1 addr add 10.0.1.1/24 dev veth0
>  ip -net $nsr1 addr add dead:1::1/64 dev veth0
>  ip -net $nsr1 link set up dev veth0
>  
> -KEY_SHA="0x"$(ps -xaf | sha1sum | cut -d " " -f 1)
> -KEY_AES="0x"$(ps -xaf | md5sum | cut -d " " -f 1)
> +KEY_SHA="0x"$(ps -af | sha1sum | cut -d " " -f 1)

Could be

> +KEY_SHA="0x"$(ps xaf | sha1sum | cut -d " " -f 1)

instead.
