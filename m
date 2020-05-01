Return-Path: <SRS0=Z556=6P=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB2B5C4724C
	for <netfilter-devel@archiver.kernel.org>; Fri,  1 May 2020 18:59:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 973D6216FD
	for <netfilter-devel@archiver.kernel.org>; Fri,  1 May 2020 18:59:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730325AbgEAS7r (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 1 May 2020 14:59:47 -0400
Received: from correo.us.es ([193.147.175.20]:37510 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729766AbgEAS7r (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 1 May 2020 14:59:47 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 0CD0EB570E
        for <netfilter-devel@vger.kernel.org>; Fri,  1 May 2020 20:59:46 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id F4053BAAAF
        for <netfilter-devel@vger.kernel.org>; Fri,  1 May 2020 20:59:45 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id E95DEBAABA; Fri,  1 May 2020 20:59:45 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id E687B2132B;
        Fri,  1 May 2020 20:59:43 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 01 May 2020 20:59:43 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id BD89B4301DE1;
        Fri,  1 May 2020 20:59:43 +0200 (CEST)
Date:   Fri, 1 May 2020 20:59:43 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Brett Mastbergen <brett.mastbergen@gmail.com>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft] ct: Add support for the 'id' key
Message-ID: <20200501185943.GA19881@salvia>
References: <20200501175535.4674-1-brett.mastbergen@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200501175535.4674-1-brett.mastbergen@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, May 01, 2020 at 01:55:35PM -0400, Brett Mastbergen wrote:
> The 'id' key allows for matching on the id of the conntrack entry.

Applied, thanks Brett.
