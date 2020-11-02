Return-Path: <SRS0=+PCd=EI=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9646C00A89
	for <netfilter-devel@archiver.kernel.org>; Mon,  2 Nov 2020 08:55:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 79A8C20756
	for <netfilter-devel@archiver.kernel.org>; Mon,  2 Nov 2020 08:55:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727972AbgKBIzv (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 2 Nov 2020 03:55:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727806AbgKBIzu (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 2 Nov 2020 03:55:50 -0500
Received: from smtp-out.kfki.hu (smtp-out.kfki.hu [IPv6:2001:738:5001::45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A06FEC0617A6
        for <netfilter-devel@vger.kernel.org>; Mon,  2 Nov 2020 00:55:50 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
        by smtp0.kfki.hu (Postfix) with ESMTP id 5B0276740115;
        Mon,  2 Nov 2020 09:55:47 +0100 (CET)
X-Virus-Scanned: Debian amavisd-new at smtp0.kfki.hu
Received: from smtp0.kfki.hu ([127.0.0.1])
        by localhost (smtp0.kfki.hu [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP; Mon,  2 Nov 2020 09:55:45 +0100 (CET)
Received: from localhost.kfki.hu (host-94-248-219-124.kabelnet.hu [94.248.219.124])
        (Authenticated sender: kadlecsik.jozsef@wigner.mta.hu)
        by smtp0.kfki.hu (Postfix) with ESMTPSA id 150876740113;
        Mon,  2 Nov 2020 09:55:45 +0100 (CET)
Received: by localhost.kfki.hu (Postfix, from userid 1000)
        id B1FDA30038B; Mon,  2 Nov 2020 09:55:44 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
        by localhost.kfki.hu (Postfix) with ESMTP id AEA8A3000AD;
        Mon,  2 Nov 2020 09:55:44 +0100 (CET)
Date:   Mon, 2 Nov 2020 09:55:44 +0100 (CET)
From:   Jozsef Kadlecsik <kadlec@netfilter.org>
X-X-Sender: kadlec@localhost
To:     Oskar Berggren <oskar.berggren@gmail.com>
cc:     netfilter-devel@vger.kernel.org
Subject: Re: ipset 7.7 modules fail to build on kernel 4.19.152
In-Reply-To: <CAHOuc7N4gWZQmGaHdZ3oMt6S2PA-8JXTEabaybsH2bM9zHcBfA@mail.gmail.com>
Message-ID: <alpine.DEB.2.23.453.2011020953550.16514@localhost>
References: <CAHOuc7N4gWZQmGaHdZ3oMt6S2PA-8JXTEabaybsH2bM9zHcBfA@mail.gmail.com>
User-Agent: Alpine 2.23 (DEB 453 2020-06-18)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

On Sun, 1 Nov 2020, Oskar Berggren wrote:

> I can build ipset 7.6 modules on 4.19.152 kernel (Debian buster
> current stable), but 7.7 fails:
> 
> $ configure; make
> $ make modules
> jhash.h:90:32 `fallthrough` undeclared
> jhash.h:136:21 `fallthrough` undeclared
> 
> ip_set_core.c:90:40 macro list_for_each_entry_rcu passed 4 arguments
> but takes just 3
> ip_set_core.c:89:2 list_for_each_entry_rcu undeclared
> 
> Plus a few more but I think they are just because the compiler is
> confused after the above problems.
> 
> There are commits in 7.7 touching the above pieces of code.

Does the patch fixes all the issues above?

diff --git a/kernel/include/linux/jhash.h b/kernel/include/linux/jhash.h
index 5e578b1..8df77ec 100644
--- a/kernel/include/linux/jhash.h
+++ b/kernel/include/linux/jhash.h
@@ -1,5 +1,6 @@
 #ifndef _LINUX_JHASH_H
 #define _LINUX_JHASH_H
+#include <linux/netfilter/ipset/ip_set_compat.h>
 
 /* jhash.h: Jenkins hash support.
  *
 
> Btw, and unrelated to above, recent kernels (4.19.134+) remove 
> tc_skb_protocol [0] but seems to provide vlan aware skb_protocol [1] 
> instead. Perhaps ipset should use that when available, instead of its 
> own tc_skb_protocol fallback?
> 
> 
> [0] https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/commit/?h=v4.19.134&id=9fd235ff00008e093951b4801349436fa27c64e8
> [1] https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/commit/?h=v4.19.134&id=d4d0e6c07bcd17d704afe64e10382ffc5d342765

I'll look into it, thanks!

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.hu
PGP key : https://wigner.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics
          H-1525 Budapest 114, POB. 49, Hungary
