Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05D82C11F64
	for <netfilter-devel@archiver.kernel.org>; Mon, 28 Jun 2021 18:35:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DD3A161C85
	for <netfilter-devel@archiver.kernel.org>; Mon, 28 Jun 2021 18:35:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232608AbhF1SiS (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 28 Jun 2021 14:38:18 -0400
Received: from smtp-out.kfki.hu ([148.6.0.48]:53659 "EHLO smtp-out.kfki.hu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234624AbhF1SiS (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 28 Jun 2021 14:38:18 -0400
X-Greylist: delayed 529 seconds by postgrey-1.27 at vger.kernel.org; Mon, 28 Jun 2021 14:38:17 EDT
Received: from localhost (localhost [127.0.0.1])
        by smtp2.kfki.hu (Postfix) with ESMTP id 17D98CC0119;
        Mon, 28 Jun 2021 20:27:01 +0200 (CEST)
X-Virus-Scanned: Debian amavisd-new at smtp2.kfki.hu
Received: from smtp2.kfki.hu ([127.0.0.1])
        by localhost (smtp2.kfki.hu [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP; Mon, 28 Jun 2021 20:26:58 +0200 (CEST)
Received: from blackhole.kfki.hu (blackhole.szhk.kfki.hu [148.6.240.2])
        by smtp2.kfki.hu (Postfix) with ESMTP id C0CBDCC0113;
        Mon, 28 Jun 2021 20:26:58 +0200 (CEST)
Received: by blackhole.kfki.hu (Postfix, from userid 1000)
        id BDA0C340D5D; Mon, 28 Jun 2021 20:26:58 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by blackhole.kfki.hu (Postfix) with ESMTP id BC03E340D5C;
        Mon, 28 Jun 2021 20:26:58 +0200 (CEST)
Date:   Mon, 28 Jun 2021 20:26:58 +0200 (CEST)
From:   Jozsef Kadlecsik <kadlec@netfilter.org>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH ipset,v4 0/4] nftables to ipset translation
 infrastructure
In-Reply-To: <20210625203043.17265-1-pablo@netfilter.org>
Message-ID: <40f46e61-7265-8344-a9fd-df03a9d6fa1@netfilter.org>
References: <20210625203043.17265-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Pablo,

On Fri, 25 Jun 2021, Pablo Neira Ayuso wrote:

> This v4 of the patchset to add the ipset to nftables translation
> utility. Example invocation of this new tool is the following:
> 
> 	# ipset-translate restore < file.ipset
> 
> This v4 round includes:
> 
> - regression tests: there is at least one test for each ipset type.
> - many bugfixes that have been spotted by the regression test
>   infrastructure.
> - Disentanglement of the ipset_xlate() logic for ADT commands.
> 
> to run regression tests:
> 
> 	# cd tests/xlate
> 	# ./runtest.sh
> 	[OK] tests are fine!
> 
> The xlate.t file contains the ipset set definitions, then the
> xlate.t.nft file contains the expected output in nftables syntax.
> In case that there is a mismatch, the diff with the expected output is
> provided.
> 
> Please, apply, thanks!

The patches are applied to the ipset git tree. Thanks indeed!

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.hu
PGP key : https://wigner.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics
          H-1525 Budapest 114, POB. 49, Hungary
