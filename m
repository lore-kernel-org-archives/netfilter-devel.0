Return-Path: <SRS0=OoQ/=S4=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS,USER_AGENT_NEOMUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3FB7DC4321A
	for <netfilter-devel@archiver.kernel.org>; Fri, 26 Apr 2019 18:32:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 208E22084F
	for <netfilter-devel@archiver.kernel.org>; Fri, 26 Apr 2019 18:32:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726167AbfDZScZ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 26 Apr 2019 14:32:25 -0400
Received: from mail.us.es ([193.147.175.20]:53834 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726005AbfDZScZ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 26 Apr 2019 14:32:25 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id D096811ED85
        for <netfilter-devel@vger.kernel.org>; Fri, 26 Apr 2019 20:32:22 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id C0AA7DA709
        for <netfilter-devel@vger.kernel.org>; Fri, 26 Apr 2019 20:32:22 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id B5A42DA705; Fri, 26 Apr 2019 20:32:22 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 70E49DA703;
        Fri, 26 Apr 2019 20:32:20 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 26 Apr 2019 20:32:20 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 4EB404265A32;
        Fri, 26 Apr 2019 20:32:20 +0200 (CEST)
Date:   Fri, 26 Apr 2019 20:32:19 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Sasha Levin <sashal@kernel.org>
Cc:     stable@vger.kernel.org, netfilter-devel@vger.kernel.org,
        nevola@gmail.com
Subject: Netfilter fixes for 4.19 -stable
Message-ID: <20190426183219.7drkaomdhojwsc22@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Sasha,

Via Laura Garcia.

Could you cherry-pick the following netfilter fixes for 4.19 -stable?

https://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git/commit/net/netfilter/nft_compat.c?id=12c44aba6618b7f6c437076e5722237190f6cd5f
commit    12c44aba6618b7f6c437076e5722237190f6cd5f
netfilter: nft_compat: use refcnt_t type for nft_xt reference count

https://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git/commit/net/netfilter/nft_compat.c?id=cf52572ebbd7189a1966c2b5fc34b97078cd1dce
commit    cf52572ebbd7189a1966c2b5fc34b97078cd1dce
netfilter: nft_compat: make lists per netns

https://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git/commit/net/netfilter/nft_compat.c?id=b2e3d68d1251a051a620f9086e18f7ffa6833b5b
commit    b2e3d68d1251a051a620f9086e18f7ffa6833b5b
netfilter: nft_compat: destroy function must not have side effects

https://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git/commit/net/netfilter/nf_tables_api.c?id=cd5125d8f51882279f50506bb9c7e5e89dc9bef3
commit    cd5125d8f51882279f50506bb9c7e5e89dc9bef3
netfilter: nf_tables: split set destruction in deactivate and destroy phase

https://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git/commit/net/netfilter/nft_compat.c?id=f6ac8585897684374a19863fff21186a05805286
commit    f6ac8585897684374a19863fff21186a05805286
netfilter: nf_tables: unbind set in rule from commit path

https://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git/commit/net/netfilter/nft_compat.c?id=947e492c0fc2132ae5fca081a9c2952ccaab0404
commit    947e492c0fc2132ae5fca081a9c2952ccaab0404
netfilter: nft_compat: don't use refcount_inc on newly allocated entry

https://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git/commit/net/netfilter/nf_tables_api.c?id=b8e204006340b7aaf32bd2b9806c692f6e0cb38a
commit    b8e204006340b7aaf32bd2b9806c692f6e0cb38a
netfilter: nft_compat: use .release_ops and remove list of extension

https://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git/commit/net/netfilter/nf_tables_api.c?id=40ba1d9b4d19796afc9b7ece872f5f3e8f5e2c13
commit    40ba1d9b4d19796afc9b7ece872f5f3e8f5e2c13
netfilter: nf_tables: fix set double-free in abort path

https://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git/commit/net/netfilter/nf_tables_api.c?id=273fe3f1006ea5ebc63d6729e43e8e45e32b256a
commit    273fe3f1006ea5ebc63d6729e43e8e45e32b256a
netfilter: nf_tables: bogus EBUSY when deleting set after flush

https://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git/commit/net/netfilter/nft_objref.c?id=8ffcd32f64633926163cdd07a7d295c500a947d1
commit    8ffcd32f64633926163cdd07a7d295c500a947d1
netfilter: nf_tables: bogus EBUSY in helper removal from transaction

Thanks.
