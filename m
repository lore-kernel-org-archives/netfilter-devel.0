Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 399C3C4167B
	for <netfilter-devel@archiver.kernel.org>; Sat, 10 Dec 2022 17:34:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229704AbiLJReV (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 10 Dec 2022 12:34:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229529AbiLJReV (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 10 Dec 2022 12:34:21 -0500
Received: from smtp-out.kfki.hu (smtp-out.kfki.hu [148.6.0.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D49518B1D
        for <netfilter-devel@vger.kernel.org>; Sat, 10 Dec 2022 09:34:16 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
        by smtp0.kfki.hu (Postfix) with ESMTP id 9F5276740109;
        Sat, 10 Dec 2022 18:34:13 +0100 (CET)
X-Virus-Scanned: Debian amavisd-new at smtp0.kfki.hu
Received: from smtp0.kfki.hu ([127.0.0.1])
        by localhost (smtp0.kfki.hu [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP; Sat, 10 Dec 2022 18:34:09 +0100 (CET)
Received: from mentat.rmki.kfki.hu (host-79-121-9-93.kabelnet.hu [79.121.9.93])
        (Authenticated sender: kadlecsik.jozsef@wigner.hu)
        by smtp0.kfki.hu (Postfix) with ESMTPSA id 22F216740106;
        Sat, 10 Dec 2022 18:34:09 +0100 (CET)
Received: by mentat.rmki.kfki.hu (Postfix, from userid 1000)
        id A7EF38DC; Sat, 10 Dec 2022 18:34:08 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
        by mentat.rmki.kfki.hu (Postfix) with ESMTP id 9DA46A28;
        Sat, 10 Dec 2022 18:34:08 +0100 (CET)
Date:   Sat, 10 Dec 2022 18:34:08 +0100 (CET)
From:   Jozsef Kadlecsik <kadlec@netfilter.org>
To:     Phil Sutter <phil@nwl.cc>
cc:     netfilter-devel@vger.kernel.org, Jan Engelhardt <jengelh@inai.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [ipset PATCH] Makefile: Create LZMA-compressed dist-files
In-Reply-To: <20221208001605.24217-1-phil@nwl.cc>
Message-ID: <94a58581-188b-b86e-6115-6f3256487c6e@netfilter.org>
References: <20221208001605.24217-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-deepspam: ham 0%
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Phil,

On Thu, 8 Dec 2022, Phil Sutter wrote:

> Use a more modern alternative to gzip.
> 
> Suggested-by: Jan Engelhardt <jengelh@inai.de>
> Suggested-by: Pablo Neira Ayuso <pablo@netfilter.org>
> Signed-off-by: Phil Sutter <phil@nwl.cc>
> ---
>  configure.ac | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Thanks, patch is applied to the ipset git tree.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.hu
PGP key : https://wigner.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics
          H-1525 Budapest 114, POB. 49, Hungary
