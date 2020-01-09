Return-Path: <SRS0=zMD2=26=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE973C282DD
	for <netfilter-devel@archiver.kernel.org>; Thu,  9 Jan 2020 19:43:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6DCD2206ED
	for <netfilter-devel@archiver.kernel.org>; Thu,  9 Jan 2020 19:43:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=blackhole.kfki.hu header.i=@blackhole.kfki.hu header.b="R0BYB/6H"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731762AbgAITnM (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 9 Jan 2020 14:43:12 -0500
Received: from smtp-out.kfki.hu ([148.6.0.45]:45131 "EHLO smtp-out.kfki.hu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728567AbgAITnL (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 9 Jan 2020 14:43:11 -0500
Received: from localhost (localhost [127.0.0.1])
        by smtp0.kfki.hu (Postfix) with ESMTP id 848F06740136;
        Thu,  9 Jan 2020 20:43:09 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        blackhole.kfki.hu; h=mime-version:user-agent:message-id:from
        :from:date:date:received:received:received; s=20151130; t=
        1578598987; x=1580413388; bh=cnOQm+WldV8DinQLXnj14UUkpULVSlFkFkD
        bmaAY+vA=; b=R0BYB/6Hr4GoNJqYF9bpyfG24cSlPhXsL7dzI47yzg+71jX+rAi
        SmlRjw8GK1giCCRJXY+vCje6fYpGV3wYz5Vt/fML1f6Qyb6dY4GyFvWPjct2KzoD
        JTBL4qsm22XzOgp3vwt4CTD6WJFispK8wOYs6gK0vKzL8OQjelQUBF/s=
X-Virus-Scanned: Debian amavisd-new at smtp0.kfki.hu
Received: from smtp0.kfki.hu ([127.0.0.1])
        by localhost (smtp0.kfki.hu [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP; Thu,  9 Jan 2020 20:43:07 +0100 (CET)
Received: from blackhole.kfki.hu (blackhole.szhk.kfki.hu [IPv6:2001:738:5001:1::240:2])
        by smtp0.kfki.hu (Postfix) with ESMTP id 01381674012A;
        Thu,  9 Jan 2020 20:42:57 +0100 (CET)
Received: by blackhole.kfki.hu (Postfix, from userid 1000)
        id BD92F20DD8; Thu,  9 Jan 2020 20:42:56 +0100 (CET)
Date:   Thu, 9 Jan 2020 20:42:56 +0100 (CET)
From:   =?UTF-8?Q?Kadlecsik_J=C3=B3zsef?= <kadlec@blackhole.kfki.hu>
To:     netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org
Subject: [ANNOUNCE] ipset 7.5 released
Message-ID: <alpine.DEB.2.20.2001092035200.7220@blackhole.kfki.hu>
User-Agent: Alpine 2.20 (DEB 67 2015-01-07)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

ipset 7.5 is just released - please upgrade to this version! The syzkaller 
fuzzer discovered a NULL dereference bug in ipset, which was fixed by 
Florian Westphal. The CAP_NET_ADMIN capability is required to exploit the 
vulnerability. Other than that, the release brings a lot of backward 
compatibility improvements, thanks to Serhey Popovych.

Userspace changes:
  - configure.ac: Support building with old autoconf 2.63
    (Serhey Popovych)
  - configure.ac: Build on kernels without skb->vlan_proto correctly
    (Serhey Popovych)
  - configure.ac: Add cond_resched_rcu() checks (Serhey Popovych)
  - configure.ac: Better match for ipv6_skip_exthdr() frag_offp
    arg presence (Serhey Popovych)
  - Document explicitly that protocol is not stored in bitmap:port
Kernel part changes:
  - netfilter: ipset: avoid null deref when IPSET_ATTR_LINENO is present
    (Florian Westphal)
  - ip_set: Pass init_net when @net is missing in match check params
    data structure (Serhey Popovych)
  - netfilter: xt_set: Do not restrict --map-set to the mangle table
    (Serhey Popovych)
  - compat: em_ipset: Build on old kernels (Serhey Popovych)
  - compat: Use skb_vlan_tag_present() instead of vlan_tx_tag_present()
    (Serhey Popovych)

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
