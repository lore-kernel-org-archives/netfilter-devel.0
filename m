Return-Path: <SRS0=SDnU=YX=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5DAF1CA9EAF
	for <netfilter-devel@archiver.kernel.org>; Wed, 30 Oct 2019 08:24:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3E39B2083E
	for <netfilter-devel@archiver.kernel.org>; Wed, 30 Oct 2019 08:24:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726594AbfJ3IYx (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 30 Oct 2019 04:24:53 -0400
Received: from correo.us.es ([193.147.175.20]:51370 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725953AbfJ3IYw (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 30 Oct 2019 04:24:52 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id DFAB315C106
        for <netfilter-devel@vger.kernel.org>; Wed, 30 Oct 2019 09:24:48 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id D1988A8E5
        for <netfilter-devel@vger.kernel.org>; Wed, 30 Oct 2019 09:24:48 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id C7419DA8E8; Wed, 30 Oct 2019 09:24:48 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id E4269DA801;
        Wed, 30 Oct 2019 09:24:46 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 30 Oct 2019 09:24:46 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id C106342EE395;
        Wed, 30 Oct 2019 09:24:46 +0100 (CET)
Date:   Wed, 30 Oct 2019 09:24:48 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Phil Sutter <phil@nwl.cc>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [iptables PATCH v2 00/10] Reduce code size around arptables-nft
Message-ID: <20191030082448.7wluvc36yxq3p3n6@salvia>
References: <20191028154818.31257-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191028154818.31257-1-phil@nwl.cc>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, Oct 28, 2019 at 04:48:08PM +0100, Phil Sutter wrote:
> A review of xtables-arp.c exposed a significant amount of dead, needless
> or duplicated code. This series deals with some low hanging fruits. Most
> of the changes affect xtables-arp.c and nft-arp.c only, but where common
> issues existed or code was to be shared, other files are touched as
> well.

Acked-by: Pablo Neira Ayuso <pablo@netfilter.org>
