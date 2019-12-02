Return-Path: <SRS0=20nZ=ZY=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 329F9C432C3
	for <netfilter-devel@archiver.kernel.org>; Mon,  2 Dec 2019 17:35:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0F4B620848
	for <netfilter-devel@archiver.kernel.org>; Mon,  2 Dec 2019 17:35:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727628AbfLBRff (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 2 Dec 2019 12:35:35 -0500
Received: from correo.us.es ([193.147.175.20]:60310 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727471AbfLBRff (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 2 Dec 2019 12:35:35 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 6C4EB5E477E
        for <netfilter-devel@vger.kernel.org>; Mon,  2 Dec 2019 18:35:32 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 5E15EDA712
        for <netfilter-devel@vger.kernel.org>; Mon,  2 Dec 2019 18:35:32 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 53D90DA711; Mon,  2 Dec 2019 18:35:32 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 2E3DADA70E;
        Mon,  2 Dec 2019 18:35:30 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 02 Dec 2019 18:35:30 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 08A6A42EE38E;
        Mon,  2 Dec 2019 18:35:29 +0100 (CET)
Date:   Mon, 2 Dec 2019 18:35:31 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Phil Sutter <phil@nwl.cc>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [libnftnl PATCH] tests: flowtable: Don't check
 NFTNL_FLOWTABLE_SIZE
Message-ID: <20191202173531.qreftv7dnsswmqjh@salvia>
References: <20191202173305.29737-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191202173305.29737-1-phil@nwl.cc>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, Dec 02, 2019 at 06:33:05PM +0100, Phil Sutter wrote:
> Marshalling code around that attribute has been dropped by commit
> d1c4b98c733a5 ("flowtable: remove NFTA_FLOWTABLE_SIZE") so it's value is
> lost during the test.
> 
> Assuming that NFTNL_FLOWTABLE_SIZE will receive kernel support at a
> later point, leave the test code in place but just comment it out.
> 
> Fixes: d1c4b98c733a5 ("flowtable: remove NFTA_FLOWTABLE_SIZE")
> Signed-off-by: Phil Sutter <phil@nwl.cc>

Acked-by: Pablo Neira Ayuso <pablo@netfilter.org>
