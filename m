Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.4 required=3.0 tests=BAYES_00,FORGED_MUA_MOZILLA,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A64AC433E9
	for <netfilter-devel@archiver.kernel.org>; Thu, 11 Mar 2021 13:36:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BFF5264FE0
	for <netfilter-devel@archiver.kernel.org>; Thu, 11 Mar 2021 13:36:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233560AbhCKNfp (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 11 Mar 2021 08:35:45 -0500
Received: from correo.us.es ([193.147.175.20]:35000 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233534AbhCKNfR (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 11 Mar 2021 08:35:17 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id A18201C4386
        for <netfilter-devel@vger.kernel.org>; Thu, 11 Mar 2021 14:35:16 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 8EACBDA78A
        for <netfilter-devel@vger.kernel.org>; Thu, 11 Mar 2021 14:35:16 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 83C8CDA791; Thu, 11 Mar 2021 14:35:16 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 5A1D3DA78A;
        Thu, 11 Mar 2021 14:35:14 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 11 Mar 2021 14:35:14 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 30FCB42DF560;
        Thu, 11 Mar 2021 14:35:14 +0100 (CET)
Date:   Thu, 11 Mar 2021 14:35:13 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Arturo Borrero Gonzalez <arturo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [conntrack-tools PATCH 2/2] tests: conntrackd: silence sysctl
Message-ID: <20210311133513.GB25079@salvia>
References: <161537982333.41950.4295612522904541534.stgit@endurance>
 <161537982997.41950.2854340685406654847.stgit@endurance>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <161537982997.41950.2854340685406654847.stgit@endurance>
User-Agent: Mozilla/5.0
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Mar 10, 2021 at 01:37:10PM +0100, Arturo Borrero Gonzalez wrote:
> We are not interested in sysctl echoing the value it just set.
> 
> Signed-off-by: Arturo Borrero Gonzalez <arturo@netfilter.org>

Acked-by: Pablo Neira Ayuso <pablo@netfilter.org>
