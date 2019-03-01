Return-Path: <SRS0=xc7Z=RE=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B047C43381
	for <netfilter-devel@archiver.kernel.org>; Fri,  1 Mar 2019 13:33:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F41242084D
	for <netfilter-devel@archiver.kernel.org>; Fri,  1 Mar 2019 13:33:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732820AbfCANdP (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 1 Mar 2019 08:33:15 -0500
Received: from mail.us.es ([193.147.175.20]:52636 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727418AbfCANdO (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 1 Mar 2019 08:33:14 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 0DEDFDA72B
        for <netfilter-devel@vger.kernel.org>; Fri,  1 Mar 2019 14:33:13 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id F1935DA86E
        for <netfilter-devel@vger.kernel.org>; Fri,  1 Mar 2019 14:33:12 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id E4CA6DA864; Fri,  1 Mar 2019 14:33:12 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 15E86DA844;
        Fri,  1 Mar 2019 14:33:11 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 01 Mar 2019 14:33:11 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [31.4.223.53])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id E3A924265A2F;
        Fri,  1 Mar 2019 14:33:10 +0100 (CET)
Date:   Fri, 1 Mar 2019 14:33:10 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     network dev <netdev@vger.kernel.org>,
        netfilter-devel@vger.kernel.org,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>
Subject: Re: [PATCH net] ipvs: get sctphdr by sctphoff in sctp_csum_check
Message-ID: <20190301133310.v7b57vwjrvhnkibm@salvia>
References: <cd1c829cfd9ee916e57c51f6879947f0f88c1eb1.1551094063.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cd1c829cfd9ee916e57c51f6879947f0f88c1eb1.1551094063.git.lucien.xin@gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, Feb 25, 2019 at 07:27:43PM +0800, Xin Long wrote:
> sctp_csum_check() is called by sctp_s/dnat_handler() where it calls
> skb_make_writable() to ensure sctphdr to be linearized.
> 
> So there's no need to get sctphdr by calling skb_header_pointer()
> in sctp_csum_check().

Applied, thanks.
