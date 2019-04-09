Return-Path: <SRS0=jECH=SL=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_NEOMUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7836BC282DA
	for <netfilter-devel@archiver.kernel.org>; Tue,  9 Apr 2019 10:17:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 43EB92133D
	for <netfilter-devel@archiver.kernel.org>; Tue,  9 Apr 2019 10:17:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726908AbfDIKRx (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 9 Apr 2019 06:17:53 -0400
Received: from mail.us.es ([193.147.175.20]:55902 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726511AbfDIKRx (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 9 Apr 2019 06:17:53 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id EE08F443831
        for <netfilter-devel@vger.kernel.org>; Tue,  9 Apr 2019 12:17:49 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id D7559DA70A
        for <netfilter-devel@vger.kernel.org>; Tue,  9 Apr 2019 12:17:49 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id CC0DDDA717; Tue,  9 Apr 2019 12:17:49 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 52724DA712;
        Tue,  9 Apr 2019 12:17:47 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 09 Apr 2019 12:17:47 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 2090D4265A5B;
        Tue,  9 Apr 2019 12:17:47 +0200 (CEST)
Date:   Tue, 9 Apr 2019 12:17:46 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Sasha Levin <sashal@kernel.org>
Cc:     stable@vger.kernel.org, netfilter-devel@vger.kernel.org,
        gregkh@linuxfoundation.org, fhimpe@ai.vub.ac.be, fw@strlen.de
Subject: netfilter fixes for 5.0.7 stable
Message-ID: <20190409101746.ovmtakjy3czzzz5q@salvia>
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

Would you mind to cherry-pick these two patches into 5.0.y?

b8e204006340 ("netfilter: nft_compat: use .release_ops and remove list of extension")
b25a31bf0ca0 ("netfilter: nf_tables: add missing ->release_ops() in error path of newrule()")

Thanks.
