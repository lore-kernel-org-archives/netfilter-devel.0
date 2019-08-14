Return-Path: <SRS0=qEnH=WK=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AED75C433FF
	for <netfilter-devel@archiver.kernel.org>; Wed, 14 Aug 2019 09:12:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 800F920843
	for <netfilter-devel@archiver.kernel.org>; Wed, 14 Aug 2019 09:12:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725996AbfHNJMz (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 14 Aug 2019 05:12:55 -0400
Received: from correo.us.es ([193.147.175.20]:39640 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725861AbfHNJMz (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 14 Aug 2019 05:12:55 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id B90C8C40E6
        for <netfilter-devel@vger.kernel.org>; Wed, 14 Aug 2019 11:12:52 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id AAAE57E063
        for <netfilter-devel@vger.kernel.org>; Wed, 14 Aug 2019 11:12:52 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id A02314CA35; Wed, 14 Aug 2019 11:12:52 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B333CDA704;
        Wed, 14 Aug 2019 11:12:50 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 14 Aug 2019 11:12:50 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [31.4.218.116])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 846C04265A2F;
        Wed, 14 Aug 2019 11:12:50 +0200 (CEST)
Date:   Wed, 14 Aug 2019 11:12:49 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     wenxu@ucloud.cn
Cc:     fw@strlen.de, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH libnftnl] expr: meta: Make NFT_META_BRI_IIF{VPROTO,PVID}
 known
Message-ID: <20190814091249.jcklhom3sap2vhvx@salvia>
References: <1565766727-25830-1-git-send-email-wenxu@ucloud.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1565766727-25830-1-git-send-email-wenxu@ucloud.cn>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Applied.
