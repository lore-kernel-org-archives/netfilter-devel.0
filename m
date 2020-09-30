Return-Path: <SRS0=6DLs=DH=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA9E4C4727E
	for <netfilter-devel@archiver.kernel.org>; Wed, 30 Sep 2020 09:58:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 663122075F
	for <netfilter-devel@archiver.kernel.org>; Wed, 30 Sep 2020 09:58:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727657AbgI3J61 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 30 Sep 2020 05:58:27 -0400
Received: from correo.us.es ([193.147.175.20]:37324 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725776AbgI3J60 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 30 Sep 2020 05:58:26 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 88E226D8DA
        for <netfilter-devel@vger.kernel.org>; Wed, 30 Sep 2020 11:58:24 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 7B844DA78C
        for <netfilter-devel@vger.kernel.org>; Wed, 30 Sep 2020 11:58:24 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 65D82DA73D; Wed, 30 Sep 2020 11:58:24 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 35EF2DA73D;
        Wed, 30 Sep 2020 11:58:22 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 30 Sep 2020 11:58:22 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 10AD442EF9E3;
        Wed, 30 Sep 2020 11:58:22 +0200 (CEST)
Date:   Wed, 30 Sep 2020 11:58:21 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Phil Sutter <phil@nwl.cc>
Cc:     Florian Westphal <fw@strlen.de>, Eric Garver <e@erig.me>,
        netfilter-devel@vger.kernel.org
Subject: Re: [iptables PATCH] nft: Fix for broken address mask match detection
Message-ID: <20200930095821.GA10484@salvia>
References: <20200928170547.13857-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200928170547.13857-1-phil@nwl.cc>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, Sep 28, 2020 at 07:05:47PM +0200, Phil Sutter wrote:
> Trying to decide whether a bitwise expression is needed to match parts
> of a source or destination address only, add_addr() checks if all bytes
> in 'mask' are 0xff or not. The check is apparently broken though as each
> byte in 'mask' is cast to a signed char before comparing against 0xff,
> therefore the bitwise is always added:
> 
> | # ./bad/iptables-nft -A foo -s 10.0.0.1 -j ACCEPT
> | # ./good/iptables-nft -A foo -s 10.0.0.2 -j ACCEPT
> | # nft --debug=netlink list chain ip filter foo
> | ip filter foo 5
> |   [ payload load 4b @ network header + 12 => reg 1 ]
> |   [ bitwise reg 1 = (reg=1 & 0xffffffff ) ^ 0x00000000 ]
> |   [ cmp eq reg 1 0x0100000a ]
> |   [ counter pkts 0 bytes 0 ]
> |   [ immediate reg 0 accept ]
> |
> | ip filter foo 6 5
> |   [ payload load 4b @ network header + 12 => reg 1 ]
> |   [ cmp eq reg 1 0x0200000a ]
> |   [ counter pkts 0 bytes 0 ]
> |   [ immediate reg 0 accept ]
> |
> | table ip filter {
> | 	chain foo {
> | 		ip saddr 10.0.0.1 counter packets 0 bytes 0 accept
> | 		ip saddr 10.0.0.2 counter packets 0 bytes 0 accept
> | 	}
> | }
> 
> Fix the cast, safe an extra op and gain 100% performance in ideal cases.

LGTM.
