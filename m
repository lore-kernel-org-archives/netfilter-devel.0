Return-Path: <SRS0=20ch=WJ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66830C32750
	for <netfilter-devel@archiver.kernel.org>; Tue, 13 Aug 2019 19:47:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 35BC7206C2
	for <netfilter-devel@archiver.kernel.org>; Tue, 13 Aug 2019 19:47:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726094AbfHMTrG (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 13 Aug 2019 15:47:06 -0400
Received: from correo.us.es ([193.147.175.20]:40932 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725923AbfHMTrG (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 13 Aug 2019 15:47:06 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 493B1B6325
        for <netfilter-devel@vger.kernel.org>; Tue, 13 Aug 2019 21:47:04 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 3BA2CDA730
        for <netfilter-devel@vger.kernel.org>; Tue, 13 Aug 2019 21:47:04 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 31181DA704; Tue, 13 Aug 2019 21:47:04 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id ED0F2D190F;
        Tue, 13 Aug 2019 21:47:01 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 13 Aug 2019 21:47:01 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [31.4.218.116])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id B7F664265A2F;
        Tue, 13 Aug 2019 21:47:01 +0200 (CEST)
Date:   Tue, 13 Aug 2019 21:47:01 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Ander Juaristi <a@juaristi.eus>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH libnftnl 2/2] Sync meta keys with kernel
Message-ID: <20190813194701.7bclxdr6yatuitps@salvia>
References: <20190813185231.7545-1-a@juaristi.eus>
 <20190813185231.7545-2-a@juaristi.eus>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190813185231.7545-2-a@juaristi.eus>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Just pushed out this so you don't have to bother with this in your
next patchset for libnftnl :-)

http://git.netfilter.org/libnftnl/commit/?id=239fabea9a436aaa7b787f389d80dfb57f7b893c
