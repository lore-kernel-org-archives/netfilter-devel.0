Return-Path: <SRS0=X9fE=6Q=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8BADC3A5A9
	for <netfilter-devel@archiver.kernel.org>; Sat,  2 May 2020 16:49:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8FB48206CD
	for <netfilter-devel@archiver.kernel.org>; Sat,  2 May 2020 16:49:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728389AbgEBQtQ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 2 May 2020 12:49:16 -0400
Received: from correo.us.es ([193.147.175.20]:32772 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728312AbgEBQtQ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 2 May 2020 12:49:16 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id BB902E2C42
        for <netfilter-devel@vger.kernel.org>; Sat,  2 May 2020 18:49:14 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id AD455BAAB8
        for <netfilter-devel@vger.kernel.org>; Sat,  2 May 2020 18:49:14 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id A2A19BAAB4; Sat,  2 May 2020 18:49:14 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id ACB78DA7B2;
        Sat,  2 May 2020 18:49:12 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Sat, 02 May 2020 18:49:12 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 900204301DE0;
        Sat,  2 May 2020 18:49:12 +0200 (CEST)
Date:   Sat, 2 May 2020 18:49:12 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Michael Braun <michael-dev@fami-braun.de>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH] main: fix get_optstring truncating output
Message-ID: <20200502164912.GA5534@salvia>
References: <20200502101143.18160-1-michael-dev@fami-braun.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200502101143.18160-1-michael-dev@fami-braun.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Sat, May 02, 2020 at 12:11:43PM +0200, Michael Braun wrote:
> Without this patch, get_optstring returns optstring = +hvVcf:insNSI:d:aejuy.
> After this patch, get_optstring returns optstring = +hvVcf:insNSI:d:aejuypTt
> 
> This is due to optstring containing up to two chars per option, thus it was too
> short.

Applied, thanks.
