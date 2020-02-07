Return-Path: <SRS0=l6lg=33=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7FA8DC04EB5
	for <netfilter-devel@archiver.kernel.org>; Fri,  7 Feb 2020 16:09:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 527DD20838
	for <netfilter-devel@archiver.kernel.org>; Fri,  7 Feb 2020 16:09:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727130AbgBGQJc (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 7 Feb 2020 11:09:32 -0500
Received: from correo.us.es ([193.147.175.20]:48028 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727028AbgBGQJb (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 7 Feb 2020 11:09:31 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 58BD1F8D44
        for <netfilter-devel@vger.kernel.org>; Fri,  7 Feb 2020 17:09:31 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 49D40DA713
        for <netfilter-devel@vger.kernel.org>; Fri,  7 Feb 2020 17:09:31 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 3F9F8DA707; Fri,  7 Feb 2020 17:09:31 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 75DA3DA70E;
        Fri,  7 Feb 2020 17:09:29 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 07 Feb 2020 17:09:29 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [84.78.24.221])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 2D2B642EFB81;
        Fri,  7 Feb 2020 17:09:29 +0100 (CET)
Date:   Fri, 7 Feb 2020 17:09:26 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Jeremy Sowden <jeremy@azazel.net>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH nft v4 0/6] Remaining bitwise-shift-related changes
Message-ID: <20200207160926.erdnjl4itv4cykqs@salvia>
References: <20200203112023.646840-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200203112023.646840-1-jeremy@azazel.net>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, Feb 03, 2020 at 11:20:17AM +0000, Jeremy Sowden wrote:
> While most of the v3 bitwise-shift patches were applied, a couple of the
> tidy-up ones and the new tests in the bitwise-shift series needed a bit
> more work.  This version introduces some new changes: a patch renaming a
> variable and a couple adding some Python tests.

Series applied, thanks Jeremy.
