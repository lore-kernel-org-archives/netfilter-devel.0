Return-Path: <SRS0=ZDGT=EC=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 157FDC4363A
	for <netfilter-devel@archiver.kernel.org>; Tue, 27 Oct 2020 09:37:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B0D75207BB
	for <netfilter-devel@archiver.kernel.org>; Tue, 27 Oct 2020 09:37:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2895700AbgJ0Jhw (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 27 Oct 2020 05:37:52 -0400
Received: from correo.us.es ([193.147.175.20]:59290 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2409636AbgJ0Jhv (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 27 Oct 2020 05:37:51 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id B9AC52EFEB5
        for <netfilter-devel@vger.kernel.org>; Tue, 27 Oct 2020 10:37:50 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id A9CF3DA78E
        for <netfilter-devel@vger.kernel.org>; Tue, 27 Oct 2020 10:37:50 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 9ECD2DA789; Tue, 27 Oct 2020 10:37:50 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 50312DA78E;
        Tue, 27 Oct 2020 10:37:48 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 27 Oct 2020 10:37:48 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 33ADA42EF42B;
        Tue, 27 Oct 2020 10:37:48 +0100 (CET)
Date:   Tue, 27 Oct 2020 10:37:47 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org,
        netfilter-announce@lists.netfilter.org
Cc:     coreteam@netfilter.org
Subject: [UPDATES] Renewing Netfilter coreteam PGP keys
Message-ID: <20201027093747.GA6249@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi everyone,

The Netfilter coreteam PGP key 0xAB4655A126D292E4 expired on
November 17th, 2020. Hence, we have generated a new PGP key
0xD55D978A8A1420E4. For more information, please visit:

https://www.netfilter.org/about.html#gpg

In accordance with good key management practices, we have also generated
a revocation certificates for our old PGP key. The revocation
certificate for our old PGP key 0xAB4655A126D292E4 and the new PGP key
have also been sent to the public PGP key servers.

Thanks.
