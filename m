Return-Path: <SRS0=uZng=VW=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 888CAC7618B
	for <netfilter-devel@archiver.kernel.org>; Thu, 25 Jul 2019 09:17:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 49F522190F
	for <netfilter-devel@archiver.kernel.org>; Thu, 25 Jul 2019 09:17:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390322AbfGYJRc (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 25 Jul 2019 05:17:32 -0400
Received: from mail.us.es ([193.147.175.20]:49534 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390290AbfGYJRb (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 25 Jul 2019 05:17:31 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id CD2DBBAEE6
        for <netfilter-devel@vger.kernel.org>; Thu, 25 Jul 2019 11:17:29 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id BBF706DA95
        for <netfilter-devel@vger.kernel.org>; Thu, 25 Jul 2019 11:17:29 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id BB515A6D8; Thu, 25 Jul 2019 11:17:29 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 990986E7A0;
        Thu, 25 Jul 2019 11:17:27 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 25 Jul 2019 11:17:27 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [31.4.183.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 2DB3240705C7;
        Thu, 25 Jul 2019 11:17:27 +0200 (CEST)
Date:   Thu, 25 Jul 2019 11:17:24 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     wenxu@ucloud.cn
Cc:     nikolay@cumulusnetworks.com, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf-next v3] netfilter:nft_meta: add NFT_META_VLAN support
Message-ID: <20190725091724.l42cvxgkjfdu6pzd@salvia>
References: <1562506649-3745-1-git-send-email-wenxu@ucloud.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1562506649-3745-1-git-send-email-wenxu@ucloud.cn>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Sun, Jul 07, 2019 at 09:37:29PM +0800, wenxu@ucloud.cn wrote:
> From: wenxu <wenxu@ucloud.cn>
> 
> This patch provide a meta vlan to set the vlan tag of the packet.
> 
> for q-in-q outer vlan id 20:
> meta vlan set 0x88a8:20
> 
> set the default 0x8100 vlan type with vlan id 20
> meta vlan set 20

Support for pushing and popping vlan will be needed soon, this design
does not cover that usecase.
