Return-Path: <SRS0=bd9C=D3=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0B98C4363A
	for <netfilter-devel@archiver.kernel.org>; Tue, 20 Oct 2020 15:19:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4CD9220757
	for <netfilter-devel@archiver.kernel.org>; Tue, 20 Oct 2020 15:19:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408634AbgJTPTT (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 20 Oct 2020 11:19:19 -0400
Received: from correo.us.es ([193.147.175.20]:50422 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726689AbgJTPTT (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 20 Oct 2020 11:19:19 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id DDF9C1761B4
        for <netfilter-devel@vger.kernel.org>; Tue, 20 Oct 2020 17:19:17 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id D038DE1506
        for <netfilter-devel@vger.kernel.org>; Tue, 20 Oct 2020 17:19:17 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id C5CF5E1517; Tue, 20 Oct 2020 17:19:17 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 9C41AE150F;
        Tue, 20 Oct 2020 17:19:15 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 20 Oct 2020 17:19:15 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 75F284301DE0;
        Tue, 20 Oct 2020 17:19:15 +0200 (CEST)
Date:   Tue, 20 Oct 2020 17:19:15 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Jeremy Sowden <jeremy@azazel.net>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH] docs: nf_flowtable: fix typo.
Message-ID: <20201020151915.GA19841@salvia>
References: <20201018153019.350400-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20201018153019.350400-1-jeremy@azazel.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Sun, Oct 18, 2020 at 04:30:19PM +0100, Jeremy Sowden wrote:
> "mailined" should be "mainlined."

Applied to nf.git, thanks.
