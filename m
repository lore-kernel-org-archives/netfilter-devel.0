Return-Path: <SRS0=yud9=WI=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94954C433FF
	for <netfilter-devel@archiver.kernel.org>; Mon, 12 Aug 2019 08:06:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 61F7820820
	for <netfilter-devel@archiver.kernel.org>; Mon, 12 Aug 2019 08:06:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727011AbfHLIGQ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 12 Aug 2019 04:06:16 -0400
Received: from correo.us.es ([193.147.175.20]:50918 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726405AbfHLIGP (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 12 Aug 2019 04:06:15 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 8FD36C4145
        for <netfilter-devel@vger.kernel.org>; Mon, 12 Aug 2019 10:06:12 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 7F41C1150B9
        for <netfilter-devel@vger.kernel.org>; Mon, 12 Aug 2019 10:06:12 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 74CFA7E064; Mon, 12 Aug 2019 10:06:12 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 2D134DA730;
        Mon, 12 Aug 2019 10:06:10 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 12 Aug 2019 10:06:10 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [31.4.218.116])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 0754C4265A2F;
        Mon, 12 Aug 2019 10:06:09 +0200 (CEST)
Date:   Mon, 12 Aug 2019 10:06:09 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     michael-dev@fami-braun.de
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH] tests: add json test for vlan rule fix
Message-ID: <20190812080609.fmexmxoepjqzi6gp@salvia>
References: <20190811101603.2892-1-michael-dev@fami-braun.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190811101603.2892-1-michael-dev@fami-braun.de>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Sun, Aug 11, 2019 at 12:16:03PM +0200, michael-dev@fami-braun.de wrote:
> From: "M. Braun" <michael-dev@fami-braun.de>
> 
> This fixes
> 
> ERROR: did not find JSON equivalent for rule 'ether type vlan ip
> protocol 1 accept'
> 
> when running
> 
> ./nft-test.py -j bridge/vlan.t

Applied, thanks.
