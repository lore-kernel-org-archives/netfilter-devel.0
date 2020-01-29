Return-Path: <SRS0=bO8k=3S=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A72F0C2D0DB
	for <netfilter-devel@archiver.kernel.org>; Wed, 29 Jan 2020 17:39:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 807CD20716
	for <netfilter-devel@archiver.kernel.org>; Wed, 29 Jan 2020 17:39:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727345AbgA2RjX (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 29 Jan 2020 12:39:23 -0500
Received: from correo.us.es ([193.147.175.20]:52824 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726679AbgA2RjX (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 29 Jan 2020 12:39:23 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 29A9EBAEE9
        for <netfilter-devel@vger.kernel.org>; Wed, 29 Jan 2020 18:39:22 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 17870DA709
        for <netfilter-devel@vger.kernel.org>; Wed, 29 Jan 2020 18:39:22 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 0D135DA703; Wed, 29 Jan 2020 18:39:22 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 22317DA70F;
        Wed, 29 Jan 2020 18:39:20 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 29 Jan 2020 18:39:20 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 0922242EFB80;
        Wed, 29 Jan 2020 18:39:20 +0100 (CET)
Date:   Wed, 29 Jan 2020 18:39:18 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Duncan Roe <duncan_roe@optusnet.com.au>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH libnetfilter_queue v2 1/1] Simplify struct pkt_buff:
 remove tail
Message-ID: <20200129173918.seepq7zzez4bfn7k@salvia>
References: <20200118204357.dg5b7qo5aqbesg4s@salvia>
 <20200126040202.11237-2-duncan_roe@optusnet.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200126040202.11237-2-duncan_roe@optusnet.com.au>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Sun, Jan 26, 2020 at 03:02:02PM +1100, Duncan Roe wrote:
> In struct pkt_buff, we only ever needed any 2 of len, data and tail.
> This has caused bugs in the past, e.g. commit 8a4316f31.
> Delete tail, and where the value of pktb->tail was required,
> use new pktb_tail() function.

Applied, thanks.
