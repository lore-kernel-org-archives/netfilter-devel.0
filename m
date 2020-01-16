Return-Path: <SRS0=22nV=3F=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A3F0C33CB1
	for <netfilter-devel@archiver.kernel.org>; Thu, 16 Jan 2020 13:17:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CCCDE206D5
	for <netfilter-devel@archiver.kernel.org>; Thu, 16 Jan 2020 13:17:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726418AbgAPNRj (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 16 Jan 2020 08:17:39 -0500
Received: from correo.us.es ([193.147.175.20]:37702 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726278AbgAPNRj (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 16 Jan 2020 08:17:39 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 1D15518CE76
        for <netfilter-devel@vger.kernel.org>; Thu, 16 Jan 2020 14:17:37 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 0CC7FDA705
        for <netfilter-devel@vger.kernel.org>; Thu, 16 Jan 2020 14:17:37 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 0259CDA702; Thu, 16 Jan 2020 14:17:37 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 0D6CCDA705;
        Thu, 16 Jan 2020 14:17:35 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 16 Jan 2020 14:17:35 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id E41FC42EF9E1;
        Thu, 16 Jan 2020 14:17:34 +0100 (CET)
Date:   Thu, 16 Jan 2020 14:17:34 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Phil Sutter <phil@nwl.cc>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH 2/2] cache: Fix for doubled output after reset command
Message-ID: <20200116131734.vdscu7fxuvuadayx@salvia>
References: <20200114164630.2492-1-phil@nwl.cc>
 <20200114164630.2492-2-phil@nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200114164630.2492-2-phil@nwl.cc>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Jan 14, 2020 at 05:46:30PM +0100, Phil Sutter wrote:
> Reset command causes a dump of the objects to reset and adds those to
> cache. Yet it ignored if the object in question was already there and up
> to now CMD_RESET was flagged as NFT_CACHE_FULL.
> 
> Tackle this from two angles: First, reduce cache requirements of reset
> command to the necessary bits which is table cache. This alone would
> suffice if there wasn't interactive mode (and other libnftables users):
> A cache containing the objects to reset might be in place already, so
> add dumped objects to cache only if they don't exist already.
> 
> Signed-off-by: Phil Sutter <phil@nwl.cc>

Acked-by: Pablo Neira Ayuso <pablo@netfilter.org>
