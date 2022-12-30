Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB909C4167B
	for <netfilter-devel@archiver.kernel.org>; Fri, 30 Dec 2022 12:42:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231474AbiL3Mmx (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 30 Dec 2022 07:42:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229519AbiL3Mmw (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 30 Dec 2022 07:42:52 -0500
Received: from smtp-out.kfki.hu (smtp-out.kfki.hu [IPv6:2001:738:5001::45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56CE911A35;
        Fri, 30 Dec 2022 04:42:51 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
        by smtp0.kfki.hu (Postfix) with ESMTP id E97D867400F1;
        Fri, 30 Dec 2022 13:42:49 +0100 (CET)
X-Virus-Scanned: Debian amavisd-new at smtp0.kfki.hu
Received: from smtp0.kfki.hu ([127.0.0.1])
        by localhost (smtp0.kfki.hu [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP; Fri, 30 Dec 2022 13:42:47 +0100 (CET)
Received: from mentat.rmki.kfki.hu (host-94-248-211-167.kabelnet.hu [94.248.211.167])
        (Authenticated sender: kadlecsik.jozsef@wigner.hu)
        by smtp0.kfki.hu (Postfix) with ESMTPSA id AB53C67400F0;
        Fri, 30 Dec 2022 13:42:47 +0100 (CET)
Received: by mentat.rmki.kfki.hu (Postfix, from userid 1000)
        id 6A91545E; Fri, 30 Dec 2022 13:42:47 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
        by mentat.rmki.kfki.hu (Postfix) with ESMTP id 67B33516;
        Fri, 30 Dec 2022 13:42:47 +0100 (CET)
Date:   Fri, 30 Dec 2022 13:42:47 +0100 (CET)
From:   Jozsef Kadlecsik <kadlec@netfilter.org>
To:     netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org
Subject: [ANNOUNCE] ipset 7.17 released
Message-ID: <c4a91b1a-821f-9c3b-735-fca0c554d950@netfilter.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-deepspam: maybeham 2%
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

I'm happy to announce ipset 7.17, which includes two important fixes: 
handle 0/0 subnets properly in hash:net,port,net types and a reworking
to add/delete multiple entries in one step for all hash types.

Userspace changes:
  - Tests: When verifying comments/timeouts, make sure entries don't 
    expire
  - Tests: Make sure the internal batches add the correct number of 
    elements
  - Tests: Verify that hash:net,port,net type can handle 0/0 properly
  - Makefile: Create LZMA-compressed dist-files (Phil Sutter)

Kernel part changes:
 - netfilter: ipset: Rework long task execution when adding/deleting 
   entries
 - netfilter: ipset: fix hash:net,port,net hang with /0 subnet

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

