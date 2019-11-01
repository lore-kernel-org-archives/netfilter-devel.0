Return-Path: <SRS0=Gx1r=YZ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2AA40CA9ECF
	for <netfilter-devel@archiver.kernel.org>; Fri,  1 Nov 2019 15:44:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9C56C20650
	for <netfilter-devel@archiver.kernel.org>; Fri,  1 Nov 2019 15:44:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=blackhole.kfki.hu header.i=@blackhole.kfki.hu header.b="env889Da"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728931AbfKAPo2 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 1 Nov 2019 11:44:28 -0400
Received: from smtp-out.kfki.hu ([148.6.0.48]:47055 "EHLO smtp-out.kfki.hu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726951AbfKAPo2 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 1 Nov 2019 11:44:28 -0400
Received: from localhost (localhost [127.0.0.1])
        by smtp2.kfki.hu (Postfix) with ESMTP id 804E3CC0130;
        Fri,  1 Nov 2019 16:44:25 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        blackhole.kfki.hu; h=mime-version:user-agent:message-id:from
        :from:date:date:received:received:received; s=20151130; t=
        1572623063; x=1574437464; bh=FciZkGk3B24yfqxRiLmfx4wAFoAMhCkIKhH
        HvZo+DaA=; b=env889Da/QmwgNotkK3Wmzz6r2QazTiOEUZUVTzVJ+DsRREaT6X
        +Pts4fw6T7vgV8hj5vL3jgEMdjgUsX/GYlXn4y2gp7Emj3Dn8ckn1BEVc/gGRAW8
        FTJLOo9PqH1KznVQedUTI4e4/GryG4jyWuCAGlyNjJrrKctHdsXGz6pI=
X-Virus-Scanned: Debian amavisd-new at smtp2.kfki.hu
Received: from smtp2.kfki.hu ([127.0.0.1])
        by localhost (smtp2.kfki.hu [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP; Fri,  1 Nov 2019 16:44:23 +0100 (CET)
Received: from blackhole.kfki.hu (blackhole.kfki.hu [148.6.240.2])
        by smtp2.kfki.hu (Postfix) with ESMTP id 2F955CC0131;
        Fri,  1 Nov 2019 16:44:23 +0100 (CET)
Received: by blackhole.kfki.hu (Postfix, from userid 1000)
        id 0848A21A47; Fri,  1 Nov 2019 16:44:22 +0100 (CET)
Date:   Fri, 1 Nov 2019 16:44:22 +0100 (CET)
From:   =?UTF-8?Q?Kadlecsik_J=C3=B3zsef?= <kadlec@blackhole.kfki.hu>
To:     netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org
Subject: [ANNOUNCE] ipset 7.4 released
Message-ID: <alpine.DEB.2.20.1911011627280.9207@blackhole.kfki.hu>
User-Agent: Alpine 2.20 (DEB 67 2015-01-07)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

I'm happy to announce ipset 7.4 which brings a few corrections and fixes.
As a new feature, Kristian Evensen added wildcard support to the type
hash:net,iface.

Please note, if you want to use ipset with kernel 5.2 and above, you need 
ipset 7.4 otherwise some commands do not work: from 5.2 NL_VALIDATE_STRICT 
is enabled and three netlink nla policies in ipset was not complete.

The sorting is changed: instead of textual sorting it now follows the 
natural ordering of IP addresses (i.e. 2.2.2.2 comes before 11.11.11.11) 
and in the case of the same prefix, more specific netblocks come before 
the least specific ones.

Userspace changes:
  - Fix compatibility support for netlink extended ACK and add
    synchronize_rcu_bh() checking
  - treewide: Replace GPLv2 boilerplate/reference with SPDX - rule 500
    (Thomas Gleixner)
  - ipset: Add wildcard support to net,iface (Kristian Evensen)
  - Sort naturally instead of textual sort (bugzilla #1369)
  - Do not return with error at 'make modules_install' when modules
    are not loaded (reported by Oskar Berggren)
Kernel part changes:
  - Fix nla_policies to fully support NL_VALIDATE_STRICT
  - treewide: Replace GPLv2 boilerplate/reference with SPDX - rule 500
    (Thomas Gleixner)
  - netfilter: remove unnecessary spaces (yangxingwu)
  - ipset: Add wildcard support to net,iface (Kristian Evensen)
  - ipset: Copy the right MAC address in hash:ip,mac IPv6 sets
    (Stefano Brivio)
  - netfilter: ipset: move ip_set_get_ip_port() to ip_set_bitmap_port.c.
    (Jeremy Sowden)
  - netfilter: ipset: move function to ip_set_bitmap_ip.c. (Jeremy Sowden) 
  - netfilter: ipset: make ip_set_put_flags extern. (Jeremy Sowden)
  - netfilter: ipset: move functions to ip_set_core.c. (Jeremy Sowden)
  - netfilter: ipset: move ip_set_comment functions from ip_set.h
    to ip_set_core.c. (Jeremy Sowden)
  - netfilter: ipset: remove inline from static functions in .c files.
    (Jeremy Sowden)
  - netfilter: ipset: add a coding-style fix to ip_set_ext_destroy.
    (Jeremy Sowden)
  - netfilter: added missing includes to a number of header-files.
    (Jeremy Sowden)
  - netfilter: inlined four headers files into another one. (Jeremy 
    Sowden)
  - netfilter: ipset: Fix an error code in ip_set_sockfn_get()
    (Dan Carpenter)

You can download the source code of ipset from:
        http://ipset.netfilter.org
        ftp://ftp.netfilter.org/pub/ipset/
        git://git.netfilter.org/ipset.git

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
