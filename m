Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EFBCFC4332F
	for <netfilter-devel@archiver.kernel.org>; Mon, 21 Nov 2022 19:40:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230490AbiKUTkv (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 21 Nov 2022 14:40:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229501AbiKUTkv (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 21 Nov 2022 14:40:51 -0500
X-Greylist: delayed 550 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 21 Nov 2022 11:40:50 PST
Received: from smtp-out.kfki.hu (smtp-out.kfki.hu [148.6.0.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52D0CFCE4;
        Mon, 21 Nov 2022 11:40:50 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
        by smtp2.kfki.hu (Postfix) with ESMTP id 7196BCC0102;
        Mon, 21 Nov 2022 20:31:36 +0100 (CET)
X-Virus-Scanned: Debian amavisd-new at smtp2.kfki.hu
Received: from smtp2.kfki.hu ([127.0.0.1])
        by localhost (smtp2.kfki.hu [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP; Mon, 21 Nov 2022 20:31:34 +0100 (CET)
Received: from blackhole.kfki.hu (blackhole.szhk.kfki.hu [148.6.240.2])
        by smtp2.kfki.hu (Postfix) with ESMTP id 297B9CC00FF;
        Mon, 21 Nov 2022 20:31:34 +0100 (CET)
Received: by blackhole.kfki.hu (Postfix, from userid 1000)
        id 274FB343157; Mon, 21 Nov 2022 20:31:34 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
        by blackhole.kfki.hu (Postfix) with ESMTP id 25FC4343156;
        Mon, 21 Nov 2022 20:31:34 +0100 (CET)
Date:   Mon, 21 Nov 2022 20:31:34 +0100 (CET)
From:   Jozsef Kadlecsik <kadlec@netfilter.org>
To:     netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org
Subject: [ANNOUNCE] ipset 7.16 released
Message-ID: <d65fe5d8-d5ea-ef7-102d-aa1d15bb4d69@netfilter.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="110363376-945108895-1669059094=:505418"
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--110363376-945108895-1669059094=:505418
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hi,

I'm happy to announce ipset 7.16, which includes a few fixes,
compatibility patches to support recent kernels and a new "bitmask"
option for the hash:ip, hash:ipport, hash:netnet types to use
any kind of netmask, from Vishwanath Pai.

Userspace changes:
  - Add new ipset_parse_bitmask() function to the library interface
  - test: Make sure no more than 64 clashing elements can be added
    to hash:net,iface sets
  - Fix all debug mode warnings
  - netfilter: ipset: add tests for the new bitmask feature (Vishwanath=20
    Pai)
  - netfilter: ipset: Update the man page to include netmask/bitmask=20
    options (Vishwanath Pai)
  - netfilter: ipset: Add bitmask support to hash:netnet (Vishwanath Pai)
  - netfilter: ipset: Add bitmask support to hash:ipport (Vishwanath Pai)
  - netfilter: ipset: Add bitmask support to hash:ip (Vishwanath Pai)
  - netfilter: ipset: Add support for new bitmask parameter (Vishwanath=20
    Pai)
  - ipset-translate: allow invoking with a path name (Quentin Armitage)
  - Fix IPv6 sets nftables translation (Pablo Neira Ayuso)
  - Fix typo in ipset-translate man page (Bernhard M. Wiedemann)

Kernel part changes:
  - netfilter: ipset: restore allowing 64 clashing elements in=20
    hash:net,iface
  - netfilter: ipset: Add support for new bitmask parameter (Vishwanath=20
    Pai)
  - netfilter: ipset: regression in ip_set_hash_ip.c (Vishwanath Pai)
  - netfilter: move from strlcpy with unused retval to strscpy
    (Wolfram Sang)
  - compatibility: handle unsafe_memcpy()
  - netlink: Bounds-check struct nlmsgerr creation (Kees Cook)
  - compatibility: move to skb_protocol in the code from tc_skb_protocol
  - Compatibility: check kvcalloc, kvfree, kvzalloc in slab.h too
  - sched: consistently handle layer3 header accesses in the presence
    of VLANs (Toke H=C3=B8iland-J=C3=B8rgensen)
  - treewide: Replace GPLv2 boilerplate/reference with SPDX
    - rule 500 (Thomas Gleixner)
  - headers: Remove some left-over license text in=20
    include/uapi/linux/netfilter/ (Christophe JAILLET)
  - netfilter: ipset: enforce documented limit to prevent allocating
    huge memory
  - netfilter: ipset: Fix oversized kvmalloc() calls

You can download the source code of ipset from:
        https://ipset.netfilter.org
        git://git.netfilter.org/ipset.git

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.hu
PGP key : https://wigner.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics
          H-1525 Budapest 114, POB. 49, Hungary
--110363376-945108895-1669059094=:505418--
