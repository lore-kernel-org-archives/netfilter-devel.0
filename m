Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0868C4361B
	for <netfilter-devel@archiver.kernel.org>; Wed,  9 Dec 2020 09:32:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A4A9C23B7B
	for <netfilter-devel@archiver.kernel.org>; Wed,  9 Dec 2020 09:32:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729194AbgLIJcT (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 9 Dec 2020 04:32:19 -0500
Received: from correo.us.es ([193.147.175.20]:39862 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729334AbgLIJcS (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 9 Dec 2020 04:32:18 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 27B2CE8E91
        for <netfilter-devel@vger.kernel.org>; Wed,  9 Dec 2020 10:31:27 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 138A4DA90D
        for <netfilter-devel@vger.kernel.org>; Wed,  9 Dec 2020 10:31:27 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 079FFDA918; Wed,  9 Dec 2020 10:31:27 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 0452CDA8F4;
        Wed,  9 Dec 2020 10:31:25 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 09 Dec 2020 10:31:25 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id DD8D942EE39A;
        Wed,  9 Dec 2020 10:31:24 +0100 (CET)
Date:   Wed, 9 Dec 2020 10:31:33 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Brett Mastbergen <brett.mastbergen@gmail.com>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf] netfilter: nft_ct: Remove confirmation check for
 NFT_CT_ID
Message-ID: <20201209093133.GA14835@salvia>
References: <20201208213924.3106-1-brett.mastbergen@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20201208213924.3106-1-brett.mastbergen@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Dec 08, 2020 at 04:39:24PM -0500, Brett Mastbergen wrote:
> Since commit 656c8e9cc1ba ("netfilter: conntrack: Use consistent ct id
> hash calculation") the ct id will not change from initialization to
> confirmation.  Removing the confirmation check allows for things like
> adding an element to a 'typeof ct id' set in prerouting upon reception
> of the first packet of a new connection, and then being able to
> reference that set consistently both before and after the connection
> is confirmed.

Applied, thanks.
