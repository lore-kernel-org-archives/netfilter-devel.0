From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: ipset 6.32 - build failure
Date: Fri, 17 Mar 2017 13:03:08 +0100 (CET)
Message-ID: <alpine.LSU.2.20.1703171257250.6463@n3.vanv.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
To: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from a3.inai.de ([88.198.180.161]:49884 "EHLO a3.inai.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751074AbdCQMDy (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 17 Mar 2017 08:03:54 -0400
Received: from localhost (localhost [127.0.0.1])
        by a3.inai.de (Postfix) with ESMTP id A7DCF17AC879
        for <netfilter-devel@vger.kernel.org>; Fri, 17 Mar 2017 13:03:08 +0100 (CET)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


With 4.10.3, ipset 6.32 seems to run into an issue:

[   59s] /home/abuild/rpmbuild/BUILD/ipset-default-6.32/kernel/net/netfilter/xt_set.c: In function 'set_match_v0':
[   59s] /home/abuild/rpmbuild/BUILD/ipset-default-6.32/kernel/net/netfilter/xt_set.c:75:18: error: 'struct xt_action_param' has no member named 'family'
[   59s]   ADT_OPT(opt, par->family, info->match_set.u.compat.dim,
[   59s]                   ^
[   59s] /home/abuild/rpmbuild/BUILD/ipset-default-6.32/kernel/net/netfilter/xt_set.c:61:12: note: in definition of macro 'ADT_OPT'
[   59s]   .family = f,   \
[   59s]             ^

abuild@a4:/home/abuild/rpmbuild/BUILD/ipset-default-6.32> make modules
make -C /usr/src/linux-obj/x86_64/default M=$PWD/kernel/net V= \
                KCFLAGS="-DPACKAGE_VERSION=6.32" \
                IP_SET_MAX=256 KDIR=$PWD/kernel modules
make[1]: Entering directory '/usr/src/linux-4.10.3-1-obj/x86_64/default'
  CC [M]  /home/abuild/rpmbuild/BUILD/ipset-default-6.32/kernel/net/netfilter/xt_set.o
/home/abuild/rpmbuild/BUILD/ipset-default-6.32/kernel/net/netfilter/xt_set.c: In function 'set_match_v0':
/home/abuild/rpmbuild/BUILD/ipset-default-6.32/kernel/net/netfilter/xt_set.c:75:18: error: 'struct xt_action_param' has no member named 'family'
  ADT_OPT(opt, par->family, info->match_set.u.compat.dim,
                  ^
/home/abuild/rpmbuild/BUILD/ipset-default-6.32/kernel/net/netfilter/xt_set.c:61:12: note: in definition of macro 'ADT_OPT'
  .family = f,   \
            ^


Commit 613dbd95723aee7abd16860745691b6c7bda20dc in the kernel was the one to
remove par->family. There is a new function called xt_family().
