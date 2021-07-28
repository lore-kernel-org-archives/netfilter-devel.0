Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DCDCEC4320E
	for <netfilter-devel@archiver.kernel.org>; Wed, 28 Jul 2021 11:25:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C5FF160FC4
	for <netfilter-devel@archiver.kernel.org>; Wed, 28 Jul 2021 11:25:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232111AbhG1LZA (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 28 Jul 2021 07:25:00 -0400
Received: from smtp-out.kfki.hu ([148.6.0.45]:34473 "EHLO smtp-out.kfki.hu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234521AbhG1LZA (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 28 Jul 2021 07:25:00 -0400
Received: from localhost (localhost [127.0.0.1])
        by smtp0.kfki.hu (Postfix) with ESMTP id 4B1CD67400CB;
        Wed, 28 Jul 2021 13:24:54 +0200 (CEST)
X-Virus-Scanned: Debian amavisd-new at smtp0.kfki.hu
Received: from smtp0.kfki.hu ([127.0.0.1])
        by localhost (smtp0.kfki.hu [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP; Wed, 28 Jul 2021 13:24:52 +0200 (CEST)
Received: from ix.szhk.kfki.hu (wdc11.wdc.kfki.hu [148.6.200.11])
        (Authenticated sender: kadlecsik.jozsef@wigner.hu)
        by smtp0.kfki.hu (Postfix) with ESMTPSA id 05CE567400CA;
        Wed, 28 Jul 2021 13:24:52 +0200 (CEST)
Received: by ix.szhk.kfki.hu (Postfix, from userid 1000)
        id CE85B180580; Wed, 28 Jul 2021 13:24:51 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by ix.szhk.kfki.hu (Postfix) with ESMTP id C8E38180514;
        Wed, 28 Jul 2021 13:24:51 +0200 (CEST)
Date:   Wed, 28 Jul 2021 13:24:51 +0200 (CEST)
From:   Jozsef Kadlecsik <kadlec@netfilter.org>
To:     Jan Engelhardt <jengelh@inai.de>
cc:     netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org
Subject: Re: [ANNOUNCE] ipset 7.13 released
In-Reply-To: <2233nn0-11ns-4o5s-r629-n3n7p0q7r223@vanv.qr>
Message-ID: <e0fc986b-b0f4-b6a1-876f-d4d07bb2dada@netfilter.org>
References: <f5d9071-7558-17a-9cd1-6ac0922710@netfilter.org> <2233nn0-11ns-4o5s-r629-n3n7p0q7r223@vanv.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, 28 Jul 2021, Jan Engelhardt wrote:

> On Tuesday 2021-07-27 12:35, Jozsef Kadlecsik wrote:
> >
> >I'm happy to announce ipset 7.13 - 7.12 was released but not announced due 
> >to additional fixes required in two patches.
> 
> Did you really try building that?

I always build and run the testsuite before an announcement. Could not 
detect any problem.
 
> [   19s] Making all in src
> [   19s] make[2]: Entering directory '/home/abuild/rpmbuild/BUILD/ipset-7.13/src'
> [   19s] gcc -DHAVE_CONFIG_H -I. -I..    -I../include  -std=gnu99  -O2 -DNDEBUG -O2 -Wall -D_FORTIFY_SOURCE=2 -fstack-protector-strong -funwind-tables -fasynchr
> onous-unwind-tables -fstack-clash-protection -Werror=return-type  -g -c -o ipset.o ipset.c
> [   19s] /bin/sh ../libtool  --tag=CC   --mode=link gcc -std=gnu99  -O2 -DNDEBUG -O2 -Wall -D_FORTIFY_SOURCE=2 -fstack-protector-strong -funwind-tables -fasynch
> ronous-unwind-tables -fstack-clash-protection -Werror=return-type  -g   -o ipset ipset.o ../lib/libipset.la
> [   19s] libtool: link: gcc -std=gnu99 -O2 -DNDEBUG -O2 -Wall -D_FORTIFY_SOURCE=2 -fstack-protector-strong -funwind-tables -fasynchronous-unwind-tables -fstack-
> clash-protection -Werror=return-type -g -o .libs/ipset ipset.o  ../lib/.libs/libipset.so -lmnl -ldl -Wl,-rpath -Wl,/usr/lib64
> [   19s] /usr/lib64/gcc/x86_64-suse-linux/11/../../../../x86_64-suse-linux/bin/ld: ipset.o: in function `main':
> [   19s] /home/abuild/rpmbuild/BUILD/ipset-7.13/src/ipset.c:35: undefined reference to `ipset_xlate_argv'
> [   19s] collect2: error: ld returned 1 exit status
> 
> abuild@a4:~/rpmbuild/BUILD/ipset-7.13> readelf -aW lib/.libs/libipset.so.13.2.0 | grep ipset_xlate_argv
>    199: 0000000000019c40  4361 FUNC    LOCAL  DEFAULT   15 ipset_xlate_argv
> 
> Function not exported, hence link failure.

I'll look into the problem.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.hu
PGP key : https://wigner.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics
          H-1525 Budapest 114, POB. 49, Hungary
