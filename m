Return-Path: <SRS0=mMMR=27=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53BAEC33CA2
	for <netfilter-devel@archiver.kernel.org>; Fri, 10 Jan 2020 11:21:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2841E2072A
	for <netfilter-devel@archiver.kernel.org>; Fri, 10 Jan 2020 11:21:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727704AbgAJLVR (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 10 Jan 2020 06:21:17 -0500
Received: from correo.us.es ([193.147.175.20]:56362 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727685AbgAJLVR (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 10 Jan 2020 06:21:17 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id E59D420A528
        for <netfilter-devel@vger.kernel.org>; Fri, 10 Jan 2020 12:21:15 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id D7D93DA71A
        for <netfilter-devel@vger.kernel.org>; Fri, 10 Jan 2020 12:21:15 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id CD578DA701; Fri, 10 Jan 2020 12:21:15 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id C293BDA701;
        Fri, 10 Jan 2020 12:21:13 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 10 Jan 2020 12:21:13 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id A659942EF4E2;
        Fri, 10 Jan 2020 12:21:13 +0100 (CET)
Date:   Fri, 10 Jan 2020 12:21:13 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Phil Sutter <phil@nwl.cc>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH 2/3] monitor: Fix for use after free when printing
 map elements
Message-ID: <20200110112113.on3sooff6qpz7mjh@salvia>
References: <20200110111114.23952-1-phil@nwl.cc>
 <20200110111114.23952-3-phil@nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200110111114.23952-3-phil@nwl.cc>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, Jan 10, 2020 at 12:11:13PM +0100, Phil Sutter wrote:
> When populating the dummy set, 'data' field must be cloned just like
> 'key' field.
> 
> Fixes: 343a51702656a ("src: store expr, not dtype to track data in sets")
> Signed-off-by: Phil Sutter <phil@nwl.cc>

Acked-by: Pablo Neira Ayuso <pablo@netfilter.org>
