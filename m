Return-Path: <SRS0=PHp+=BU=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2E9FC433DF
	for <netfilter-devel@archiver.kernel.org>; Mon, 10 Aug 2020 11:02:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D480F206C3
	for <netfilter-devel@archiver.kernel.org>; Mon, 10 Aug 2020 11:02:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726462AbgHJLCk (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 10 Aug 2020 07:02:40 -0400
Received: from correo.us.es ([193.147.175.20]:49108 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726033AbgHJLCi (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 10 Aug 2020 07:02:38 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id D1FF2EB461
        for <netfilter-devel@vger.kernel.org>; Mon, 10 Aug 2020 13:02:36 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id C5481DA796
        for <netfilter-devel@vger.kernel.org>; Mon, 10 Aug 2020 13:02:36 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id BAE7ADA791; Mon, 10 Aug 2020 13:02:36 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 9750DDA73F;
        Mon, 10 Aug 2020 13:02:34 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 10 Aug 2020 13:02:34 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 7457E4265A32;
        Mon, 10 Aug 2020 13:02:34 +0200 (CEST)
Date:   Mon, 10 Aug 2020 13:02:34 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Stephen Suryaputra <ssuryaextr@gmail.com>
Cc:     netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH nf,v2] netfilter: nf_tables: nft_exthdr: the presence
 return value should be little-endian
Message-ID: <20200810110234.GA8449@salvia>
References: <20200804214409.105658-1-ssuryaextr@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200804214409.105658-1-ssuryaextr@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Aug 04, 2020 at 05:44:09PM -0400, Stephen Suryaputra wrote:
> On big-endian machine, the returned register data when the exthdr is
> present is not being compared correctly because little-endian is
> assumed. The function nft_cmp_fast_mask(), called by nft_cmp_fast_eval()
> and nft_cmp_fast_init(), calls cpu_to_le32().

Applied, thanks.
