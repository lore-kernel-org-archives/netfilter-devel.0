Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ABD74C388F9
	for <netfilter-devel@archiver.kernel.org>; Thu, 19 Nov 2020 21:46:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5D2ED22202
	for <netfilter-devel@archiver.kernel.org>; Thu, 19 Nov 2020 21:46:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726475AbgKSVq2 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 19 Nov 2020 16:46:28 -0500
Received: from smtp-out.kfki.hu ([148.6.0.46]:38171 "EHLO smtp-out.kfki.hu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726159AbgKSVq1 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 19 Nov 2020 16:46:27 -0500
Received: from localhost (localhost [127.0.0.1])
        by smtp1.kfki.hu (Postfix) with ESMTP id 168A63C80142;
        Thu, 19 Nov 2020 22:46:26 +0100 (CET)
X-Virus-Scanned: Debian amavisd-new at smtp1.kfki.hu
Received: from smtp1.kfki.hu ([127.0.0.1])
        by localhost (smtp1.kfki.hu [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP; Thu, 19 Nov 2020 22:46:23 +0100 (CET)
Received: from blackhole.kfki.hu (blackhole.szhk.kfki.hu [148.6.240.2])
        by smtp1.kfki.hu (Postfix) with ESMTP id D8C413C8013D;
        Thu, 19 Nov 2020 22:46:23 +0100 (CET)
Received: by blackhole.kfki.hu (Postfix, from userid 1000)
        id CEB9B340D5C; Thu, 19 Nov 2020 22:46:23 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
        by blackhole.kfki.hu (Postfix) with ESMTP id CA5AC340D5B;
        Thu, 19 Nov 2020 22:46:23 +0100 (CET)
Date:   Thu, 19 Nov 2020 22:46:23 +0100 (CET)
From:   Jozsef Kadlecsik <kadlec@netfilter.org>
X-X-Sender: kadlec@blackhole.kfki.hu
To:     Jan Engelhardt <jengelh@inai.de>
cc:     netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org
Subject: Re: [ANNOUNCE] ipset 7.8 released
In-Reply-To: <45rqn0n5-5385-o997-rn9q-os784nqrn9p@vanv.qr>
Message-ID: <alpine.DEB.2.23.453.2011192237290.19567@blackhole.kfki.hu>
References: <alpine.DEB.2.23.453.2011192141150.19567@blackhole.kfki.hu> <45rqn0n5-5385-o997-rn9q-os784nqrn9p@vanv.qr>
User-Agent: Alpine 2.23 (DEB 453 2020-06-18)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Jan,

On Thu, 19 Nov 2020, Jan Engelhardt wrote:

> LIBVERSION changed from 14:0:1 (ipset 7.6) to 14:1:2,
> producing libipset.so.13 (7.6) and now libipset.so.12
> 
> That seems incorrect! It should have been
> - 14:0:1 (no changes)
> - 15:0:2 (compatible changes)
> - 15:0:0 (incompatible changes)

Oh, my. It should be 15:0:2 (compatible changes). I dunno how many times I 
can mix it up, this numbering scheme is simply alien to my brain wiring.

I released 7.9. Thanks for the quick feedback!

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.hu
PGP key : https://wigner.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics
          H-1525 Budapest 114, POB. 49, Hungary
