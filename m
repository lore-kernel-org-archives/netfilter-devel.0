Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.4 required=3.0 tests=BAYES_00,FORGED_MUA_MOZILLA,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0CB0EC433DB
	for <netfilter-devel@archiver.kernel.org>; Wed, 17 Feb 2021 23:00:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BABDF64E58
	for <netfilter-devel@archiver.kernel.org>; Wed, 17 Feb 2021 23:00:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231239AbhBQXAC (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 17 Feb 2021 18:00:02 -0500
Received: from correo.us.es ([193.147.175.20]:54310 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229707AbhBQXAB (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 17 Feb 2021 18:00:01 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id B2907D28C6
        for <netfilter-devel@vger.kernel.org>; Wed, 17 Feb 2021 23:59:20 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id A3264DA78A
        for <netfilter-devel@vger.kernel.org>; Wed, 17 Feb 2021 23:59:20 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 984EEDA730; Wed, 17 Feb 2021 23:59:20 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 50593DA73D;
        Wed, 17 Feb 2021 23:59:18 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 17 Feb 2021 23:59:18 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 2870042DC6E2;
        Wed, 17 Feb 2021 23:59:18 +0100 (CET)
Date:   Wed, 17 Feb 2021 23:59:17 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Ondrej Mosnacek <omosnace@redhat.com>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [ebtables PATCH] Open the lockfile with O_CLOEXEC
Message-ID: <20210217225917.GA32273@salvia>
References: <20210217213023.15403-1-omosnace@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210217213023.15403-1-omosnace@redhat.com>
User-Agent: Mozilla/5.0
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Feb 17, 2021 at 10:30:23PM +0100, Ondrej Mosnacek wrote:
> Otherwise the fd will leak to subprocesses (e.g. modprobe). That's
> mostly benign, but it may trigger an SELinux denial when the modprobe
> process transitions to another domain.

Applied, thanks.
