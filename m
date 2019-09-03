Return-Path: <SRS0=xNQb=W6=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05DE6C3A5A2
	for <netfilter-devel@archiver.kernel.org>; Tue,  3 Sep 2019 17:11:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CB49A21881
	for <netfilter-devel@archiver.kernel.org>; Tue,  3 Sep 2019 17:11:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729637AbfICRLh (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 3 Sep 2019 13:11:37 -0400
Received: from correo.us.es ([193.147.175.20]:43908 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729056AbfICRLh (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 3 Sep 2019 13:11:37 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id B0822DA389
        for <netfilter-devel@vger.kernel.org>; Tue,  3 Sep 2019 19:11:33 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id A2FEAB7FF2
        for <netfilter-devel@vger.kernel.org>; Tue,  3 Sep 2019 19:11:33 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 988E6FB362; Tue,  3 Sep 2019 19:11:33 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id A86B43569;
        Tue,  3 Sep 2019 19:11:31 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 03 Sep 2019 19:11:31 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 7EC24426CCBB;
        Tue,  3 Sep 2019 19:11:31 +0200 (CEST)
Date:   Tue, 3 Sep 2019 19:11:32 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Fernando Fernandez Mancera <ffmancera@riseup.net>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH 2/2 nf-next v3] netfilter: nft_quota: add quota object
 update support
Message-ID: <20190903171132.g7wqqxshmusq4zgc@salvia>
References: <20190826114054.877-1-ffmancera@riseup.net>
 <20190826114054.877-2-ffmancera@riseup.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190826114054.877-2-ffmancera@riseup.net>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Also applied, thanks.
