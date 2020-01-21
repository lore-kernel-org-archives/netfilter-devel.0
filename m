Return-Path: <SRS0=AyPt=3K=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3ECAEC33CAA
	for <netfilter-devel@archiver.kernel.org>; Tue, 21 Jan 2020 12:55:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1DF7A2051A
	for <netfilter-devel@archiver.kernel.org>; Tue, 21 Jan 2020 12:55:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726968AbgAUMzp (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 21 Jan 2020 07:55:45 -0500
Received: from correo.us.es ([193.147.175.20]:34874 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725890AbgAUMzp (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 21 Jan 2020 07:55:45 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id BC914172C86
        for <netfilter-devel@vger.kernel.org>; Tue, 21 Jan 2020 13:55:43 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id AC7FEDA71F
        for <netfilter-devel@vger.kernel.org>; Tue, 21 Jan 2020 13:55:43 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id A205EDA705; Tue, 21 Jan 2020 13:55:43 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 7EF33DA705;
        Tue, 21 Jan 2020 13:55:39 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 21 Jan 2020 13:55:39 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 61B2C42EE38E;
        Tue, 21 Jan 2020 13:55:39 +0100 (CET)
Date:   Tue, 21 Jan 2020 13:55:38 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Phil Sutter <phil@nwl.cc>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH 1/4] netlink: Fix leak in unterminated string
 deserializer
Message-ID: <20200121125538.s2e6rvjenw3hoppx@salvia>
References: <20200120162540.9699-1-phil@nwl.cc>
 <20200120162540.9699-2-phil@nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200120162540.9699-2-phil@nwl.cc>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, Jan 20, 2020 at 05:25:37PM +0100, Phil Sutter wrote:
> Allocated 'mask' expression is not freed before returning to caller,
> although it is used temporarily only.
> 
> Fixes: b851ba4731d9f ("src: add interface wildcard matching")
> Signed-off-by: Phil Sutter <phil@nwl.cc>

Acked-by: Pablo Neira Ayuso <pablo@netfilter.org>
