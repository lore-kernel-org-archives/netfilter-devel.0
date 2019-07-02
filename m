Return-Path: <SRS0=aW9c=VA=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	HEXHASH_WORD,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C93B2C06510
	for <netfilter-devel@archiver.kernel.org>; Wed,  3 Jul 2019 00:58:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A37D42089C
	for <netfilter-devel@archiver.kernel.org>; Wed,  3 Jul 2019 00:58:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727342AbfGCA6p (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 2 Jul 2019 20:58:45 -0400
Received: from mail.us.es ([193.147.175.20]:46450 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727237AbfGCA6o (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 2 Jul 2019 20:58:44 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 6AB5880781
        for <netfilter-devel@vger.kernel.org>; Wed,  3 Jul 2019 01:43:24 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 5AE786D2AC
        for <netfilter-devel@vger.kernel.org>; Wed,  3 Jul 2019 01:43:24 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 4F5ACCE158; Wed,  3 Jul 2019 01:43:24 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 0FA3DDA708;
        Wed,  3 Jul 2019 01:43:22 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 03 Jul 2019 01:43:22 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id E0AEA4265A31;
        Wed,  3 Jul 2019 01:43:21 +0200 (CEST)
Date:   Wed, 3 Jul 2019 01:43:21 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, netfilter-devel@vger.kernel.org
Subject: netfilter patches for -stable
Message-ID: <20190702234321.cwqnmqhfymfg6hqh@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Greg,

Would you consider to take the following patches for -stable?

e75b3e1c9bc5 netfilter: nf_flow_table: ignore DF bit setting
8437a6209f76 netfilter: nft_flow_offload: set liberal tracking mode for tcp
91a9048f2380 netfilter: nft_flow_offload: don't offload when sequence numbers need adjustment
69aeb538587e netfilter: nft_flow_offload: IPCB is only valid for ipv4 family

Users report this is fixing a connection stall in:

        https://bugzilla.kernel.org/show_bug.cgi?id=203671

Thanks.
