Return-Path: <SRS0=/SeC=YO=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F1D6CA9EAF
	for <netfilter-devel@archiver.kernel.org>; Mon, 21 Oct 2019 17:41:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 225612064B
	for <netfilter-devel@archiver.kernel.org>; Mon, 21 Oct 2019 17:41:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726955AbfJURlv (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 21 Oct 2019 13:41:51 -0400
Received: from correo.us.es ([193.147.175.20]:44382 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726289AbfJURlv (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 21 Oct 2019 13:41:51 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 0A61DA1A323
        for <netfilter-devel@vger.kernel.org>; Mon, 21 Oct 2019 19:41:46 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id F0A58DA840
        for <netfilter-devel@vger.kernel.org>; Mon, 21 Oct 2019 19:41:45 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id E65AFDA7B6; Mon, 21 Oct 2019 19:41:45 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id D77654DE4B;
        Mon, 21 Oct 2019 19:41:43 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 21 Oct 2019 19:41:43 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id B5D8A42EF4E0;
        Mon, 21 Oct 2019 19:41:43 +0200 (CEST)
Date:   Mon, 21 Oct 2019 19:41:45 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Phil Sutter <phil@nwl.cc>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH] main: Fix for misleading error with negative chain
 priority
Message-ID: <20191021174145.ubz2tacxwba7hwum@salvia>
References: <20191021165603.32467-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191021165603.32467-1-phil@nwl.cc>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, Oct 21, 2019 at 06:56:03PM +0200, Phil Sutter wrote:
> getopt_long() would try to parse the negative priority as an option and
> return -1 as it is not known:
> 
> | # nft add chain x y { type filter hook input priority -30\; }
> | nft: invalid option -- '3'
> 
> Fix this by prefixing optstring with a plus character. This instructs
> getopt_long() to not collate arguments but just stop after the first
> non-option, leaving the rest for manual handling. In fact, this is just
> what nft desires: mixing options with nft syntax leads to confusive
> command lines anyway.
>
> Signed-off-by: Phil Sutter <phil@nwl.cc>

Acked-by: Pablo Neira Ayuso <pablo@netfilter.org>
