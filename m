Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46C46CE79A9
	for <netfilter-devel@archiver.kernel.org>; Tue, 19 Sep 2023 18:26:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232038AbjISS0v (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 19 Sep 2023 14:26:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232002AbjISS0u (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 19 Sep 2023 14:26:50 -0400
Received: from smtp-out.kfki.hu (smtp-out.kfki.hu [IPv6:2001:738:5001::48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A7D9BF
        for <netfilter-devel@vger.kernel.org>; Tue, 19 Sep 2023 11:26:43 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by smtp2.kfki.hu (Postfix) with ESMTP id 77FFECC02B6;
        Tue, 19 Sep 2023 20:26:40 +0200 (CEST)
X-Virus-Scanned: Debian amavisd-new at smtp2.kfki.hu
Received: from smtp2.kfki.hu ([127.0.0.1])
        by localhost (smtp2.kfki.hu [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP; Tue, 19 Sep 2023 20:26:38 +0200 (CEST)
Received: from blackhole.kfki.hu (blackhole.szhk.kfki.hu [148.6.240.2])
        by smtp2.kfki.hu (Postfix) with ESMTP id 41AB6CC02B4;
        Tue, 19 Sep 2023 20:26:38 +0200 (CEST)
Received: by blackhole.kfki.hu (Postfix, from userid 1000)
        id 3AAF23431A9; Tue, 19 Sep 2023 20:26:38 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by blackhole.kfki.hu (Postfix) with ESMTP id 3925C343155;
        Tue, 19 Sep 2023 20:26:38 +0200 (CEST)
Date:   Tue, 19 Sep 2023 20:26:38 +0200 (CEST)
From:   Jozsef Kadlecsik <kadlec@netfilter.org>
To:     netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org
Subject: [ANNOUNCE] ipset 7.18 released
Message-ID: <55c2bf9d-ec58-8db-e457-8a36ebbbc4c0@blackhole.kfki.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

I'm happy to announce ipset 7.18, which brings a few fixes, backports, 
tests suite fixes and json output support.

Userspace changes:
  - Add json output to list command (Thomas Oberhammer)
  - tests: hash:ip,port.t: Replace VRRP by GRE protocol (Phil Sutter)
  - tests: hash:ip,port.t: 'vrrp' is printed as 'carp' (Phil Sutter)
  - tests: cidr.sh: Add ipcalc fallback (Phil Sutter)
  - tests: xlate: Make test input valid (Phil Sutter)
  - tests: xlate: Test built binary by default (Phil Sutter)
  - xlate: Drop dead code (Phil Sutter)
  - xlate: Fix for fd leak in error path (Phil Sutter)
  - configure.ac: fix bashisms (Sam James)
  - lib/Makefile.am: fix pkgconfig dir (Sam James)

Kernel part changes:
 - netfilter: ipset: Fix race between IPSET_CMD_CREATE and IPSET_CMD_SWAP
    (reported by Kyle Zeng)
  - netfilter: ipset: add the missing IP_SET_HASH_WITH_NET0 macro for
    ip_set_hash_netportnet.c (Kyle Zeng)
  - compatibility: handle strscpy_pad()
  - netfilter: ipset: refactor deprecated strncpy (Justin Stitt)
  - netfilter: ipset: remove rcu_read_lock_bh pair from ip_set_test
    (Florian Westphal)
  - netfilter: ipset: Replace strlcpy with strscpy (Azeem Shaikh)
  - netfilter: ipset: Add schedule point in call_ad(). (Kuniyuki Iwashima)
  - net: Kconfig: fix spellos (Randy Dunlap)
  - netfilter: ipset: Fix overflow before widen in the bitmap_ip_create()
    function. (Gavrilov Ilia)

You can download the source code of ipset from:
        https://ipset.netfilter.org
        git://git.netfilter.org/ipset.git

Best regards,
Jozsef
-
E-mail:  kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.hu
PGP key: https://wigner.hu/~kadlec/pgp_public_key.txt
Address: Wigner Research Centre for Physics
         H-1525 Budapest 114, POB. 49, Hungary
