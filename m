Return-Path: <SRS0=6DLs=DH=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8B54C4727E
	for <netfilter-devel@archiver.kernel.org>; Wed, 30 Sep 2020 09:59:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A63BA2076B
	for <netfilter-devel@archiver.kernel.org>; Wed, 30 Sep 2020 09:59:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728235AbgI3J7q (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 30 Sep 2020 05:59:46 -0400
Received: from correo.us.es ([193.147.175.20]:38292 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728655AbgI3J7p (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 30 Sep 2020 05:59:45 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id DE5096D025
        for <netfilter-devel@vger.kernel.org>; Wed, 30 Sep 2020 11:59:43 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id CDDFADA73F
        for <netfilter-devel@vger.kernel.org>; Wed, 30 Sep 2020 11:59:43 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id CD3C4DA730; Wed, 30 Sep 2020 11:59:43 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id C5648DA704;
        Wed, 30 Sep 2020 11:59:41 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 30 Sep 2020 11:59:41 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 9F33C42EF9E0;
        Wed, 30 Sep 2020 11:59:41 +0200 (CEST)
Date:   Wed, 30 Sep 2020 11:59:41 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     "Jose M. Guisado Gomez" <guigom@riseup.net>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf-next] netfilter: nf_tables: fix userdata memleak
Message-ID: <20200930095941.GA10541@salvia>
References: <20200927083621.9822-1-guigom@riseup.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200927083621.9822-1-guigom@riseup.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Sun, Sep 27, 2020 at 10:36:22AM +0200, Jose M. Guisado Gomez wrote:
> When userdata was introduced for tables and objects its allocation was
> only freed inside the error path of the new{table, object} functions.
> 
> Free user data inside corresponding destroy functions for tables and
> objects.

Applied, thanks.
