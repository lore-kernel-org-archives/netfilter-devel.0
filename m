Return-Path: <SRS0=6DLs=DH=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF06DC4727E
	for <netfilter-devel@archiver.kernel.org>; Wed, 30 Sep 2020 09:59:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B24402075F
	for <netfilter-devel@archiver.kernel.org>; Wed, 30 Sep 2020 09:59:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728660AbgI3J7x (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 30 Sep 2020 05:59:53 -0400
Received: from correo.us.es ([193.147.175.20]:38384 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728149AbgI3J7x (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 30 Sep 2020 05:59:53 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 6D3966D02C
        for <netfilter-devel@vger.kernel.org>; Wed, 30 Sep 2020 11:59:52 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 5F14CDA78F
        for <netfilter-devel@vger.kernel.org>; Wed, 30 Sep 2020 11:59:52 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 5E173DA78E; Wed, 30 Sep 2020 11:59:52 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 4D066DA859;
        Wed, 30 Sep 2020 11:59:50 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 30 Sep 2020 11:59:50 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 2683142EF9E4;
        Wed, 30 Sep 2020 11:59:50 +0200 (CEST)
Date:   Wed, 30 Sep 2020 11:59:49 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     "Jose M. Guisado Gomez" <guigom@riseup.net>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf-next] netfilter: nf_tables: use nla_memdup to copy
 udata
Message-ID: <20200930095949.GB10541@salvia>
References: <20200928122457.6411-1-guigom@riseup.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200928122457.6411-1-guigom@riseup.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, Sep 28, 2020 at 02:24:57PM +0200, Jose M. Guisado Gomez wrote:
> When userdata support was added to tables and objects, user data coming
> from user space was allocated and copied using kzalloc + nla_memcpy.
> 
> Use nla_memdup to copy userdata of tables and objects.

Applied, thanks.
