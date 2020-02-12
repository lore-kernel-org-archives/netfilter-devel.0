Return-Path: <SRS0=6DSs=4A=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6ED5BC352A4
	for <netfilter-devel@archiver.kernel.org>; Wed, 12 Feb 2020 20:45:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0DAA92467D
	for <netfilter-devel@archiver.kernel.org>; Wed, 12 Feb 2020 20:45:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727947AbgBLUpI (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 12 Feb 2020 15:45:08 -0500
Received: from correo.us.es ([193.147.175.20]:44458 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727111AbgBLUpI (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 12 Feb 2020 15:45:08 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 14E72E1232
        for <netfilter-devel@vger.kernel.org>; Wed, 12 Feb 2020 21:45:08 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 07703DA70F
        for <netfilter-devel@vger.kernel.org>; Wed, 12 Feb 2020 21:45:08 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id F126CDA709; Wed, 12 Feb 2020 21:45:07 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 24713DA70E;
        Wed, 12 Feb 2020 21:45:06 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 12 Feb 2020 21:45:06 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id F156542EF42A;
        Wed, 12 Feb 2020 21:45:05 +0100 (CET)
Date:   Wed, 12 Feb 2020 21:45:04 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Laurent Fasnacht <fasnacht@protonmail.ch>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft include v2 1/7] tests: shell: add test for glob
 includes
Message-ID: <20200212204504.wlgd36irwxt3v77p@salvia>
References: <20200210101709.9182-1-fasnacht@protonmail.ch>
 <20200210101709.9182-2-fasnacht@protonmail.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200210101709.9182-2-fasnacht@protonmail.ch>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, Feb 10, 2020 at 10:17:20AM +0000, Laurent Fasnacht wrote:
> Including more than MAX_INCLUDE_DEPTH file in one statement should succeed.

Applied, thanks.
