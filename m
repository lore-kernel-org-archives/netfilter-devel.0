Return-Path: <SRS0=hj4T=4T=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88B39C3F2CD
	for <netfilter-devel@archiver.kernel.org>; Mon,  2 Mar 2020 19:22:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6096421775
	for <netfilter-devel@archiver.kernel.org>; Mon,  2 Mar 2020 19:22:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727616AbgCBTWN (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 2 Mar 2020 14:22:13 -0500
Received: from correo.us.es ([193.147.175.20]:42466 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727581AbgCBTWN (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 2 Mar 2020 14:22:13 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 44485303D05
        for <netfilter-devel@vger.kernel.org>; Mon,  2 Mar 2020 20:21:58 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 36E54DA38F
        for <netfilter-devel@vger.kernel.org>; Mon,  2 Mar 2020 20:21:58 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 2C4C3DA3A0; Mon,  2 Mar 2020 20:21:58 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 5D595DA3A5;
        Mon,  2 Mar 2020 20:21:56 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 02 Mar 2020 20:21:56 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 3E15C426CCB9;
        Mon,  2 Mar 2020 20:21:56 +0100 (CET)
Date:   Mon, 2 Mar 2020 20:22:08 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Phil Sutter <phil@nwl.cc>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [iptables PATCH 4/4] nft: cache: Review flush_cache()
Message-ID: <20200302192208.3s5omyihan5xuj44@salvia>
References: <20200302175358.27796-1-phil@nwl.cc>
 <20200302175358.27796-5-phil@nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200302175358.27796-5-phil@nwl.cc>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, Mar 02, 2020 at 06:53:58PM +0100, Phil Sutter wrote:
> While fixing for iptables-nft-restore under stress, I managed to hit
> NULL-pointer deref in flush_cache(). Given that nftnl_*_list_free()
> functions are not NULL-pointer tolerant, better make sure such are not
> passed by accident.

Could you explain what sequence is triggering the NULL-pointer
dereference?

Thank you.
