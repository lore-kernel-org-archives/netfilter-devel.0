Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 759BCC388F9
	for <netfilter-devel@archiver.kernel.org>; Thu, 19 Nov 2020 20:48:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2E61F22264
	for <netfilter-devel@archiver.kernel.org>; Thu, 19 Nov 2020 20:48:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725944AbgKSUsh (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 19 Nov 2020 15:48:37 -0500
Received: from smtp-out.kfki.hu ([148.6.0.45]:33987 "EHLO smtp-out.kfki.hu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725843AbgKSUsg (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 19 Nov 2020 15:48:36 -0500
Received: from localhost (localhost [127.0.0.1])
        by smtp0.kfki.hu (Postfix) with ESMTP id 1CFFE6740121;
        Thu, 19 Nov 2020 21:48:35 +0100 (CET)
X-Virus-Scanned: Debian amavisd-new at smtp0.kfki.hu
Received: from smtp0.kfki.hu ([127.0.0.1])
        by localhost (smtp0.kfki.hu [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP; Thu, 19 Nov 2020 21:48:32 +0100 (CET)
Received: from blackhole.kfki.hu (blackhole.kfki.hu [IPv6:2001:738:5001:1::240:2])
        by smtp0.kfki.hu (Postfix) with ESMTP id CB7186740124;
        Thu, 19 Nov 2020 21:48:32 +0100 (CET)
Received: by blackhole.kfki.hu (Postfix, from userid 1000)
        id BC8BE340D5C; Thu, 19 Nov 2020 21:48:32 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
        by blackhole.kfki.hu (Postfix) with ESMTP id B8BEF340D5B;
        Thu, 19 Nov 2020 21:48:32 +0100 (CET)
Date:   Thu, 19 Nov 2020 21:48:32 +0100 (CET)
From:   Jozsef Kadlecsik <kadlec@netfilter.org>
X-X-Sender: kadlec@blackhole.kfki.hu
To:     netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org
Subject: [ANNOUNCE] ipset 7.8 released
Message-ID: <alpine.DEB.2.23.453.2011192141150.19567@blackhole.kfki.hu>
User-Agent: Alpine 2.23 (DEB 453 2020-06-18)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

I'm happy to announce ipset 7.8 which includes a couple of fixes, 
compatibility fixes. Small improvements like the new flags of the hash:* 
types make possible to optimize sets for speed or memory and to restore 
exactly the same set (from internal structure point of view) as the saved 
one.

Kernel part changes:
  - Complete backward compatibility fix for package copy of 
    <linux/jhash.h>
  - Compatibility: check for kvzalloc() and GFP_KERNEL_ACCOUNT
  - netfilter: ipset: enable memory accounting for ipset allocations
    (Vasily Averin)
  - netfilter: ipset: prevent uninit-value in hash_ip6_add (Eric Dumazet)
  - Compatibility: use skb_policy() from if_vlan.h if available
  - Compatibility: Check for the fourth arg of list_for_each_entry_rcu()
  - Backward compatibility fix for the package copy of <linux/jhash.h>

ipset 7.7 was released without announcement, so the changelogs are listed 
here for the sake of completeness:

Userspace changes:
  - Expose the initval hash parameter to userspace
  - Handle all variable header parts in helper scripts instead ot test 
    tasks
  - Add bucketsize parameter to all hash types
  - Support the -exist flag with the destroy command

Kernel part changes:
  - Expose the initval hash parameter to userspace
  - Add bucketsize parameter to all hash types
  - Use fallthrough pseudo-keyword in the package copy of <linux/jhash.h> 
    too
  - Support the -exist flag with the destroy command
  - netfilter: Use fallthrough pseudo-keyword (Gustavo A. R. Silva)
  - netfilter: Replace zero-length array with flexible-array member
    (Gustavo A. R. Silva)
  - netfilter: ipset: call ip_set_free() instead of kfree() (Eric Dumazet)
  - netfiler: ipset: fix unaligned atomic access (Russell King)
  - netfilter: ipset: Fix subcounter update skip (Phil Sutter)
  - ipset: Update byte and packet counters regardless of whether they 
    match (Stefano Brivio)
  - netfilter: ipset: Pass lockdep expression to RCU lists (Amol Grover)
  - ip_set: Fix compatibility with kernels between v3.3 and v4.5
    (Serhey Popovych)
  - ip_set: Fix build on kernels without INIT_DEFERRABLE_WORK
    (Serhey Popovych)
  - ipset: Support kernels with at least system_wq support
  - ip_set: Fix build on kernels without system_power_efficient_wq
    (Serhey Popovych)

You can download the source code of ipset from:
        http://ipset.netfilter.org
        ftp://ftp.netfilter.org/pub/ipset/
        git://git.netfilter.org/ipset.git

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.hu
PGP key : https://wigner.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics
          H-1525 Budapest 114, POB. 49, Hungary
