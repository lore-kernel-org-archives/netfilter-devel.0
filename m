Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA9D8E7D0AB
	for <netfilter-devel@archiver.kernel.org>; Thu, 21 Sep 2023 20:48:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232460AbjIUUso (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 21 Sep 2023 16:48:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232462AbjIUUs1 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 21 Sep 2023 16:48:27 -0400
Received: from smtp-out.kfki.hu (smtp-out.kfki.hu [IPv6:2001:738:5001::48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E455F8921F;
        Thu, 21 Sep 2023 10:39:41 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by smtp2.kfki.hu (Postfix) with ESMTP id 488B2CC02CC;
        Thu, 21 Sep 2023 09:02:52 +0200 (CEST)
X-Virus-Scanned: Debian amavisd-new at smtp2.kfki.hu
Received: from smtp2.kfki.hu ([127.0.0.1])
        by localhost (smtp2.kfki.hu [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP; Thu, 21 Sep 2023 09:02:50 +0200 (CEST)
Received: from blackhole.kfki.hu (blackhole.szhk.kfki.hu [148.6.240.2])
        by smtp2.kfki.hu (Postfix) with ESMTP id 11272CC02CB;
        Thu, 21 Sep 2023 09:02:50 +0200 (CEST)
Received: by blackhole.kfki.hu (Postfix, from userid 1000)
        id 0B15B3431A9; Thu, 21 Sep 2023 09:02:50 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by blackhole.kfki.hu (Postfix) with ESMTP id 08CFA343155;
        Thu, 21 Sep 2023 09:02:50 +0200 (CEST)
Date:   Thu, 21 Sep 2023 09:02:50 +0200 (CEST)
From:   Jozsef Kadlecsik <kadlec@netfilter.org>
To:     netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org
Subject: [ANNOUNCE] ipset 7.19 released
Message-ID: <c2818bd0-257c-6eb5-7a85-a1a0f0a7629d@netfilter.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

The installation of the pkgconfig file of libipset was broken in 7.18, 
thus a new release was needed. The only modification in the new package is 
the fixed install path.

Userspace changes:
  - build: Fix the double-prefix in pkgconfig (Sam James)

Kernel part changes:
  none

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
