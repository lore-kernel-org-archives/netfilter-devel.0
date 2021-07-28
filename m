Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8BA25C432BE
	for <netfilter-devel@archiver.kernel.org>; Wed, 28 Jul 2021 12:44:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 71F4F60F9C
	for <netfilter-devel@archiver.kernel.org>; Wed, 28 Jul 2021 12:44:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234759AbhG1MoR (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 28 Jul 2021 08:44:17 -0400
Received: from smtp-out.kfki.hu ([148.6.0.48]:60277 "EHLO smtp-out.kfki.hu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235797AbhG1MoR (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 28 Jul 2021 08:44:17 -0400
Received: from localhost (localhost [127.0.0.1])
        by smtp2.kfki.hu (Postfix) with ESMTP id 168C9CC00F6;
        Wed, 28 Jul 2021 14:44:13 +0200 (CEST)
X-Virus-Scanned: Debian amavisd-new at smtp2.kfki.hu
Received: from smtp2.kfki.hu ([127.0.0.1])
        by localhost (smtp2.kfki.hu [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP; Wed, 28 Jul 2021 14:44:10 +0200 (CEST)
Received: from ix.szhk.kfki.hu (wdc11.wdc.kfki.hu [148.6.200.11])
        (Authenticated sender: kadlecsik.jozsef@wigner.hu)
        by smtp2.kfki.hu (Postfix) with ESMTPSA id CC0E9CC00F5;
        Wed, 28 Jul 2021 14:44:10 +0200 (CEST)
Received: by ix.szhk.kfki.hu (Postfix, from userid 1000)
        id B7E20180580; Wed, 28 Jul 2021 14:44:10 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by ix.szhk.kfki.hu (Postfix) with ESMTP id B2663180087;
        Wed, 28 Jul 2021 14:44:10 +0200 (CEST)
Date:   Wed, 28 Jul 2021 14:44:10 +0200 (CEST)
From:   Jozsef Kadlecsik <kadlec@netfilter.org>
To:     Jan Engelhardt <jengelh@inai.de>
cc:     netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org
Subject: Re: [ANNOUNCE] ipset 7.13 released
In-Reply-To: <2233nn0-11ns-4o5s-r629-n3n7p0q7r223@vanv.qr>
Message-ID: <fa47f565-f7ea-1b98-718a-6c4251e1cdf@netfilter.org>
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
> 
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

Ohh right, got it. I'm going to release the next version today. 

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.hu
PGP key : https://wigner.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics
          H-1525 Budapest 114, POB. 49, Hungary
