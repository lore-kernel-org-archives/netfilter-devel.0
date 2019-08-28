Return-Path: <SRS0=hqFW=WY=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5FE88C3A5A1
	for <netfilter-devel@archiver.kernel.org>; Wed, 28 Aug 2019 12:13:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3A18520856
	for <netfilter-devel@archiver.kernel.org>; Wed, 28 Aug 2019 12:13:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726259AbfH1MNU (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 28 Aug 2019 08:13:20 -0400
Received: from rs07.intra2net.com ([85.214.138.66]:37238 "EHLO
        rs07.intra2net.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726253AbfH1MNT (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 28 Aug 2019 08:13:19 -0400
Received: from mail.m.i2n (unknown [172.17.128.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by rs07.intra2net.com (Postfix) with ESMTPS id CD3E815001B0;
        Wed, 28 Aug 2019 14:13:17 +0200 (CEST)
Received: from localhost (mail.m.i2n [127.0.0.1])
        by localhost (Postfix) with ESMTP id 8F48C438;
        Wed, 28 Aug 2019 14:13:17 +0200 (CEST)
X-Virus-Scanned: by Intra2net Mail Security (AVE=8.3.54.84,VDF=8.16.22.22)
Received: from localhost (storm.m.i2n [172.16.1.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.m.i2n (Postfix) with ESMTPS id 1858F2C4;
        Wed, 28 Aug 2019 14:13:15 +0200 (CEST)
Date:   Wed, 28 Aug 2019 14:13:15 +0200
From:   Thomas Jarosch <thomas.jarosch@intra2net.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH] netfilter: nf_conntrack_ftp: Fix debug output
Message-ID: <20190828121315.tbrrkl6567xwkmkx@intra2net.com>
References: <20190821141428.cjb535xrhpgry5zd@intra2net.com>
 <20190823123442.366wk6yoyct4b35m@salvia>
 <20190823125047.2yq5quu4mcwgh5b3@intra2net.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190823125047.2yq5quu4mcwgh5b3@intra2net.com>
User-Agent: NeoMutt/20180716
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Pablo,

> One customer site is having FTP NAT problems after migrating from 3.14 to 4.19.
> The tcpdump traces look normal to me. Still IP addresses for passive FTP
> don't get rewritten with 4.19, it instantly works with 3.14.
> It works fine with 4.19 for me using test VMs.

quick follow up: Everything is working out of the box in the kernel. I finally 
had access to the machine and the FTP conntrack helper was not set up correctly.

Still it's good to have working debug code now.

Cheers,
Thomas
