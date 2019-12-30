Return-Path: <SRS0=r9U9=2U=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4857BC2D0C2
	for <netfilter-devel@archiver.kernel.org>; Mon, 30 Dec 2019 11:54:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 17BD3206DB
	for <netfilter-devel@archiver.kernel.org>; Mon, 30 Dec 2019 11:54:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727421AbfL3Lye (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 30 Dec 2019 06:54:34 -0500
Received: from correo.us.es ([193.147.175.20]:48288 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726196AbfL3Lye (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 30 Dec 2019 06:54:34 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 6E9B3F25A6
        for <netfilter-devel@vger.kernel.org>; Mon, 30 Dec 2019 12:53:56 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 6148ADA70F
        for <netfilter-devel@vger.kernel.org>; Mon, 30 Dec 2019 12:53:56 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 56D9FDA702; Mon, 30 Dec 2019 12:53:56 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 6F862DA707;
        Mon, 30 Dec 2019 12:53:54 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 30 Dec 2019 12:53:54 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [185.124.28.61])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 24D3342EE38E;
        Mon, 30 Dec 2019 12:53:54 +0100 (CET)
Date:   Mon, 30 Dec 2019 12:53:53 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Duncan Roe <duncan_roe@optusnet.com.au>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH libnetfilter_queue] src: doc: Eliminate doxygen warnings
 from libnetfilter_queue.c
Message-ID: <20191230115353.tg3lxjhnckqqs3pj@salvia>
References: <20191225231815.29967-1-duncan_roe@optusnet.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191225231815.29967-1-duncan_roe@optusnet.com.au>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Dec 26, 2019 at 10:18:15AM +1100, Duncan Roe wrote:
> - Change items of the form #<word> to "\b <word>".
>   (#<word> is rather obscurely documented to be a reference to a documented
>            entity)
> - Re-work text wrapping in above change to keep lines within 80cc
> - Add 2 missing \param directives
> 
> 12 warnings fixed

This patch does not apply for some reason, please rebase and resubmit.

Thanks.
