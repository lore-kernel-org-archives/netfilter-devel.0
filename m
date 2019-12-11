Return-Path: <SRS0=EbRH=2B=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9909FC43603
	for <netfilter-devel@archiver.kernel.org>; Wed, 11 Dec 2019 21:59:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6AF6B206A5
	for <netfilter-devel@archiver.kernel.org>; Wed, 11 Dec 2019 21:59:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726518AbfLKV7N (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 11 Dec 2019 16:59:13 -0500
Received: from correo.us.es ([193.147.175.20]:33230 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726313AbfLKV7N (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 11 Dec 2019 16:59:13 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 2ABD34A2BB7
        for <netfilter-devel@vger.kernel.org>; Wed, 11 Dec 2019 22:59:10 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 1D1E6DA703
        for <netfilter-devel@vger.kernel.org>; Wed, 11 Dec 2019 22:59:10 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 12ACBDA702; Wed, 11 Dec 2019 22:59:10 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 1CCF8DA703;
        Wed, 11 Dec 2019 22:59:08 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 11 Dec 2019 22:59:08 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id E286E4265A5A;
        Wed, 11 Dec 2019 22:59:07 +0100 (CET)
Date:   Wed, 11 Dec 2019 22:59:08 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Duncan Roe <duncan_roe@optusnet.com.au>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH libnetfilter_queue] src: Fix value returned by
 nfq_udp_get_payload_len()
Message-ID: <20191211215908.boque4mu2jfixnym@salvia>
References: <20191209211204.gejs3uz2lc7nbjra@salvia>
 <20191209235255.5688-1-duncan_roe@optusnet.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191209235255.5688-1-duncan_roe@optusnet.com.au>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Applied, thanks.
