Return-Path: <SRS0=+9KY=7U=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C9F0C433E0
	for <netfilter-devel@archiver.kernel.org>; Sun,  7 Jun 2020 18:29:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6A4C5206D5
	for <netfilter-devel@archiver.kernel.org>; Sun,  7 Jun 2020 18:29:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726985AbgFGS3y (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 7 Jun 2020 14:29:54 -0400
Received: from correo.us.es ([193.147.175.20]:45888 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726779AbgFGS3y (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 7 Jun 2020 14:29:54 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id D3E9D11EB20
        for <netfilter-devel@vger.kernel.org>; Sun,  7 Jun 2020 20:29:53 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id C5923DA73F
        for <netfilter-devel@vger.kernel.org>; Sun,  7 Jun 2020 20:29:53 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id BB537DA73D; Sun,  7 Jun 2020 20:29:53 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id BEF3DDA722;
        Sun,  7 Jun 2020 20:29:51 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Sun, 07 Jun 2020 20:29:51 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 9F48441E4800;
        Sun,  7 Jun 2020 20:29:51 +0200 (CEST)
Date:   Sun, 7 Jun 2020 20:29:51 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Duncan Roe <duncan_roe@optusnet.com.au>
Cc:     fw@strlen.de, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH libnetfilter_queue v2 1/1] build: dist: Add
 fixmanpages.sh to distribution tree
Message-ID: <20200607182951.GA13814@salvia>
References: <20200606142508.6906-1-duncan_roe@optusnet.com.au>
 <20200606142508.6906-2-duncan_roe@optusnet.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200606142508.6906-2-duncan_roe@optusnet.com.au>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Sun, Jun 07, 2020 at 12:25:08AM +1000, Duncan Roe wrote:
> Also move fixmanpages.sh into the doxygen directory
> 
> Tested by running Slackware package builder on libnetfilter_queue-1.0.4.tar.bz2
> created by 'make dist' after applying the patch. Works now, failed before.

Applied, thanks.
