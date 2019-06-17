Return-Path: <SRS0=CDuC=UQ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0701C31E50
	for <netfilter-devel@archiver.kernel.org>; Mon, 17 Jun 2019 13:36:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C7CB520657
	for <netfilter-devel@archiver.kernel.org>; Mon, 17 Jun 2019 13:36:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727949AbfFQNgq (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 17 Jun 2019 09:36:46 -0400
Received: from mail.us.es ([193.147.175.20]:47662 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725884AbfFQNgq (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 17 Jun 2019 09:36:46 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 68EFFB6C6D
        for <netfilter-devel@vger.kernel.org>; Mon, 17 Jun 2019 15:36:44 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 5A349DA706
        for <netfilter-devel@vger.kernel.org>; Mon, 17 Jun 2019 15:36:44 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 59872DA701; Mon, 17 Jun 2019 15:36:44 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 6EA84DA703;
        Mon, 17 Jun 2019 15:36:42 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 17 Jun 2019 15:36:42 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 454A04265A31;
        Mon, 17 Jun 2019 15:36:42 +0200 (CEST)
Date:   Mon, 17 Jun 2019 15:36:41 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf-next] netfilter: conntrack: small conntrack lookup
 optimization
Message-ID: <20190617133641.bli2ht5jwdo44qxg@salvia>
References: <20190604121404.30351-1-fw@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190604121404.30351-1-fw@strlen.de>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Applied, thanks Florian.
