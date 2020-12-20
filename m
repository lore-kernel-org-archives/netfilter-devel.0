Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B857C2BBCD
	for <netfilter-devel@archiver.kernel.org>; Sun, 20 Dec 2020 15:03:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CCEF22250F
	for <netfilter-devel@archiver.kernel.org>; Sun, 20 Dec 2020 15:03:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727396AbgLTPCc (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 20 Dec 2020 10:02:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726943AbgLTPCc (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 20 Dec 2020 10:02:32 -0500
Received: from smtp-out.kfki.hu (smtp-out.kfki.hu [IPv6:2001:738:5001::45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E037C0617B0;
        Sun, 20 Dec 2020 07:01:44 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
        by smtp0.kfki.hu (Postfix) with ESMTP id 49BC26740155;
        Sun, 20 Dec 2020 16:01:40 +0100 (CET)
X-Virus-Scanned: Debian amavisd-new at smtp0.kfki.hu
Received: from smtp0.kfki.hu ([127.0.0.1])
        by localhost (smtp0.kfki.hu [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP; Sun, 20 Dec 2020 16:01:38 +0100 (CET)
Received: from localhost.kfki.hu (host-94-248-219-210.kabelnet.hu [94.248.219.210])
        (Authenticated sender: kadlecsik.jozsef@wigner.mta.hu)
        by smtp0.kfki.hu (Postfix) with ESMTPSA id 02A416740156;
        Sun, 20 Dec 2020 16:01:37 +0100 (CET)
Received: by localhost.kfki.hu (Postfix, from userid 1000)
        id 87B09300564; Sun, 20 Dec 2020 16:01:37 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
        by localhost.kfki.hu (Postfix) with ESMTP id 8513D30038E;
        Sun, 20 Dec 2020 16:01:37 +0100 (CET)
Date:   Sun, 20 Dec 2020 16:01:37 +0100 (CET)
From:   Jozsef Kadlecsik <kadlec@netfilter.org>
To:     netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org
Subject: [ANNOUNCE] ipset 7.10 released
Message-ID: <b56e4c5-cd49-272f-fd39-707442d86cd5@mail.kfki.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

I'm happy to announce ipset 7.10. It comes with two fixes from Vasily 
Averin and a few backward compatibility patches. Please note, the support 
of older kernel trees was broken in 7.9 which is fixed in 7.10.

Kernel part changes:
  - Fix patch "Handle false warning from -Wstringop-overflow"
  - Backward compatibility: handle renaming nla_strlcpy to nla_strscpy
  - treewide: rename nla_strlcpy to nla_strscpy. (Francis Laniel)
  - netfilter: ipset: fix shift-out-of-bounds in htable_bits()
    (Vasily Averin)
  - netfilter: ipset: fixes possible oops in mtype_resize (Vasily Averin)
  - Handle false warning from -Wstringop-overflow
  - Backward compatibility: handle missing strscpy with a wrapper of 
    strlcpy.
  - Move compiler specific compatibility support to separated file (broken
    compatibility support reported by Ed W)

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
