Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF93DC56202
	for <netfilter-devel@archiver.kernel.org>; Sun, 22 Nov 2020 10:50:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B6D9D20936
	for <netfilter-devel@archiver.kernel.org>; Sun, 22 Nov 2020 10:50:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727391AbgKVKt2 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 22 Nov 2020 05:49:28 -0500
Received: from correo.us.es ([193.147.175.20]:49044 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727329AbgKVKt1 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 22 Nov 2020 05:49:27 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 15AF3508CD9
        for <netfilter-devel@vger.kernel.org>; Sun, 22 Nov 2020 11:49:26 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 07DF9DA8F6
        for <netfilter-devel@vger.kernel.org>; Sun, 22 Nov 2020 11:49:26 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id F198BDA8F4; Sun, 22 Nov 2020 11:49:25 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id BD335DA722;
        Sun, 22 Nov 2020 11:49:23 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Sun, 22 Nov 2020 11:49:23 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id A048F4265A5A;
        Sun, 22 Nov 2020 11:49:23 +0100 (CET)
Date:   Sun, 22 Nov 2020 11:49:23 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org
Subject: Re: [PATCH net 1/4] netfilter: nftables_offload: set address type in
 control dissector
Message-ID: <20201122104923.GA26512@salvia>
References: <20201121123601.21733-1-pablo@netfilter.org>
 <20201121123601.21733-2-pablo@netfilter.org>
 <20201121164442.01b39ffb@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20201121164442.01b39ffb@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Sat, Nov 21, 2020 at 04:44:42PM -0800, Jakub Kicinski wrote:
> On Sat, 21 Nov 2020 13:35:58 +0100 Pablo Neira Ayuso wrote:
> > If the address type is missing through the control dissector, then
> > matching on IPv4 and IPv6 addresses does not work.
> 
> Doesn't work where? Are you talking about a specific driver?

No.

It does not work for any kind of match, the control flow dissector
needs to be set on.
