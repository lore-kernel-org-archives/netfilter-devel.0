Return-Path: <SRS0=8vd7=4K=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A936AC35671
	for <netfilter-devel@archiver.kernel.org>; Sat, 22 Feb 2020 19:34:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5B6A7206ED
	for <netfilter-devel@archiver.kernel.org>; Sat, 22 Feb 2020 19:34:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=blackhole.kfki.hu header.i=@blackhole.kfki.hu header.b="uWIoq9DI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726793AbgBVTeo (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 22 Feb 2020 14:34:44 -0500
Received: from smtp-out.kfki.hu ([148.6.0.46]:35827 "EHLO smtp-out.kfki.hu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726550AbgBVTeo (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 22 Feb 2020 14:34:44 -0500
Received: from localhost (localhost [127.0.0.1])
        by smtp1.kfki.hu (Postfix) with ESMTP id EAA163C800F8;
        Sat, 22 Feb 2020 20:34:42 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        blackhole.kfki.hu; h=mime-version:user-agent:message-id:from
        :from:date:date:received:received:received; s=20151130; t=
        1582400080; x=1584214481; bh=KRHpkErE98Hx1o6eOkjgj94LQQREXWDwyRH
        H20BnE/I=; b=uWIoq9DIkL610S92oGpf27mRv90bYCT+8Y8bqFs7r+hsqfFxCFx
        HkAk81fDqVF1JHzXqvV2cqfOKm0jYFda5oRtcKfmnns2mPteKP/IdZ9JO+FSQ4Dl
        NnjNUpH/Tmt9ejPtACc6pGafi/WiAeZF02AOiIf9fQXgpWV8KEwcqM04=
X-Virus-Scanned: Debian amavisd-new at smtp1.kfki.hu
Received: from smtp1.kfki.hu ([127.0.0.1])
        by localhost (smtp1.kfki.hu [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP; Sat, 22 Feb 2020 20:34:40 +0100 (CET)
Received: from blackhole.kfki.hu (blackhole.szhk.kfki.hu [148.6.240.2])
        by smtp1.kfki.hu (Postfix) with ESMTP id A7EA53C800F3;
        Sat, 22 Feb 2020 20:34:40 +0100 (CET)
Received: by blackhole.kfki.hu (Postfix, from userid 1000)
        id 7C49E21B3B; Sat, 22 Feb 2020 20:34:40 +0100 (CET)
Date:   Sat, 22 Feb 2020 20:34:40 +0100 (CET)
From:   Jozsef Kadlecsik <kadlec@netfilter.org>
X-X-Sender: kadlec@blackhole.kfki.hu
To:     netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org
Subject: [ANNOUNCE] ipset 7.6 released
Message-ID: <alpine.DEB.2.20.2002222023100.8763@blackhole.kfki.hu>
User-Agent: Alpine 2.20 (DEB 67 2015-01-07)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

I'm happy to announce ipset 7.6. The release contains mostly bugfixes 
uncovered by syzbot. The fixing of "INFO: rcu detected stall in hash_xxx" 
is resulted faster add/del operations due to the introduced region locks
instead of using a single lock to protect the set data.

Please note, the oldest kernel version supported by the ipset package
is now 3.11.

Userspace changes:
  - Add checking system_power_efficient_wq in the kernel source tree
  - .gitignore: add temporary files to the list

Kernel part changes:
  - netfilter: ipset: Fix forceadd evaluation path
  - netfilter: ipset: Correct the reported memory size
  - ip_set: Include kernel header instead of UAPI (Serhey Popovych)
  - netfilter: ipset: Fix "INFO: rcu detected stall in hash_xxx" reports
  - netfilter: ipset: fix suspicious RCU usage in find_set_and_id
  - Add compatibility support for bitmap_zalloc() and bitmap_zero()
  - netfilter: ipset: use bitmap infrastructure completely
  - netfilter: fix a use-after-free in mtype_destroy() (Cong Wang)

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
