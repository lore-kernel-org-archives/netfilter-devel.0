Return-Path: <SRS0=o6T4=AF=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5AAAAC433E0
	for <netfilter-devel@archiver.kernel.org>; Wed, 24 Jun 2020 12:07:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3C5EE20B1F
	for <netfilter-devel@archiver.kernel.org>; Wed, 24 Jun 2020 12:07:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389930AbgFXMHV (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 24 Jun 2020 08:07:21 -0400
Received: from correo.us.es ([193.147.175.20]:43738 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388522AbgFXMHU (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 24 Jun 2020 08:07:20 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 7ABBB1878A4
        for <netfilter-devel@vger.kernel.org>; Wed, 24 Jun 2020 14:07:19 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 6A7D0DA78D
        for <netfilter-devel@vger.kernel.org>; Wed, 24 Jun 2020 14:07:19 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 5FD7ADA78F; Wed, 24 Jun 2020 14:07:19 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 581ADDA78B;
        Wed, 24 Jun 2020 14:07:17 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 24 Jun 2020 14:07:17 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 3834742EF42B;
        Wed, 24 Jun 2020 14:07:17 +0200 (CEST)
Date:   Wed, 24 Jun 2020 14:07:16 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Rob Gill <rrobgill@protonmail.com>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH v3] netfilter: Add MODULE_DESCRIPTION entries to kernel
 modules
Message-ID: <20200624120716.GA27906@salvia>
References: <20200621052729.9445-1-rrobgill@protonmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200621052729.9445-1-rrobgill@protonmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Sun, Jun 21, 2020 at 05:27:36AM +0000, Rob Gill wrote:
> The user tool modinfo is used to get information on kernel modules, including a
> description where it is available.
> 
> This patch adds a brief MODULE_DESCRIPTION to netfilter kernel modules
> (descriptions taken from Kconfig file or code comments)

Applied, thanks.
