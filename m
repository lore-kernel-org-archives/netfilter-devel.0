Return-Path: <SRS0=RE83=6O=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D0CDC47253
	for <netfilter-devel@archiver.kernel.org>; Thu, 30 Apr 2020 15:37:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7A15320661
	for <netfilter-devel@archiver.kernel.org>; Thu, 30 Apr 2020 15:37:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727965AbgD3Phd (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 30 Apr 2020 11:37:33 -0400
Received: from correo.us.es ([193.147.175.20]:57880 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727963AbgD3Phd (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 30 Apr 2020 11:37:33 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id ED21818CDCE
        for <netfilter-devel@vger.kernel.org>; Thu, 30 Apr 2020 17:37:31 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id DE4F6BAAA3
        for <netfilter-devel@vger.kernel.org>; Thu, 30 Apr 2020 17:37:31 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id D3DBFDA736; Thu, 30 Apr 2020 17:37:31 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id D89DEBAABA;
        Thu, 30 Apr 2020 17:37:29 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 30 Apr 2020 17:37:29 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id BDE8742EFB80;
        Thu, 30 Apr 2020 17:37:29 +0200 (CEST)
Date:   Thu, 30 Apr 2020 17:37:29 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Phil Sutter <phil@nwl.cc>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH 3/4] segtree: Merge get_set_interval_find() and
 get_set_interval_end()
Message-ID: <20200430153729.GA3602@salvia>
References: <20200430151408.32283-1-phil@nwl.cc>
 <20200430151408.32283-4-phil@nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200430151408.32283-4-phil@nwl.cc>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Apr 30, 2020 at 05:14:07PM +0200, Phil Sutter wrote:
> Both functions were very similar already. Under the assumption that they
> will always either see a range (or start of) that matches exactly or not
> at all, reduce complexity and make get_set_interval_find() accept NULL
> (left or) right values. This way it becomes a full replacement for
> get_set_interval_end().

I have to go back to the commit log of this patch, IIRC my intention
here was to allow users to ask for a single element, then return the
range that contains it.
