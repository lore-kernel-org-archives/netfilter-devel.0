Return-Path: <SRS0=E6gp=UJ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7353C282DD
	for <netfilter-devel@archiver.kernel.org>; Mon, 10 Jun 2019 12:28:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8C1AB20820
	for <netfilter-devel@archiver.kernel.org>; Mon, 10 Jun 2019 12:28:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=blackhole.kfki.hu header.i=@blackhole.kfki.hu header.b="X2w3sDYo"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389813AbfFJM2T (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 10 Jun 2019 08:28:19 -0400
Received: from smtp-out.kfki.hu ([148.6.0.45]:56851 "EHLO smtp-out.kfki.hu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389001AbfFJM2T (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 10 Jun 2019 08:28:19 -0400
Received: from localhost (localhost [127.0.0.1])
        by smtp0.kfki.hu (Postfix) with ESMTP id 371B267400D9;
        Mon, 10 Jun 2019 14:28:17 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        blackhole.kfki.hu; h=mime-version:user-agent:message-id:from
        :from:date:date:received:received:received; s=20151130; t=
        1560169694; x=1561984095; bh=PBzpwHw1GDzklK/M1D7lQGRGs7gtsbtqehd
        JlSG/ew0=; b=X2w3sDYoalQKuVIQJ4N917DCiNCwJ14fFWqS/Lg8mHVuHIpMhJd
        ZUIudEEIxUoapMFX1Ei7oule8pfd6U3j7aXR/ceKxSLcjkJT8+hMmf/54aUj7JR9
        5xZDtp4OIBiUsdvC/YxI6NqkF0PugSdnG9jj+PXZ7aBojo0Aj0DXltfQ=
X-Virus-Scanned: Debian amavisd-new at smtp0.kfki.hu
Received: from smtp0.kfki.hu ([127.0.0.1])
        by localhost (smtp0.kfki.hu [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP; Mon, 10 Jun 2019 14:28:14 +0200 (CEST)
Received: from blackhole.kfki.hu (blackhole.szhk.kfki.hu [IPv6:2001:738:5001:1::240:2])
        by smtp0.kfki.hu (Postfix) with ESMTP id B0D1A67400BC;
        Mon, 10 Jun 2019 14:28:14 +0200 (CEST)
Received: by blackhole.kfki.hu (Postfix, from userid 1000)
        id 8AB2822577; Mon, 10 Jun 2019 14:28:14 +0200 (CEST)
Date:   Mon, 10 Jun 2019 14:28:14 +0200 (CEST)
From:   Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
To:     netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org
Subject: [ANNOUNCE] ipset 7.2 released
Message-ID: <alpine.DEB.2.20.1906101424280.22562@blackhole.kfki.hu>
User-Agent: Alpine 2.20 (DEB 67 2015-01-07)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

I'm happy to announce ipset 7.2. The number of changes fairly low, some 
fixes and corrections:

Userspace changes:
  - Update my email address
Kernel part changes:
  - Update my email address
  - ipset: Fix memory accounting for hash types on resize
    (Stefano Brivio)
  - Fix error path in set_target_v3_checkentry()
  - Fix the last missing check of nla_parse()
  - netfilter: ipset: fix a missing check of nla_parse (Aditya 
    Pakki)
  - netfilter: ipset: merge uadd and udel functions (Florent 
    Fourcot)
  - netfilter: ipset: remove useless memset() calls (Florent 
    Fourcot)

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
