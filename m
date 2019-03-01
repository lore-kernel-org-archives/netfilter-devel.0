Return-Path: <SRS0=xc7Z=RE=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9505AC43381
	for <netfilter-devel@archiver.kernel.org>; Fri,  1 Mar 2019 13:32:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 67AC12084D
	for <netfilter-devel@archiver.kernel.org>; Fri,  1 Mar 2019 13:32:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727951AbfCANcf (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 1 Mar 2019 08:32:35 -0500
Received: from mail.us.es ([193.147.175.20]:52300 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726416AbfCANcf (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 1 Mar 2019 08:32:35 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id C4F05191910
        for <netfilter-devel@vger.kernel.org>; Fri,  1 Mar 2019 14:32:33 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 9872ADA85E
        for <netfilter-devel@vger.kernel.org>; Fri,  1 Mar 2019 14:32:33 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 7E2CCDA878; Fri,  1 Mar 2019 14:32:33 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 603EFDA872;
        Fri,  1 Mar 2019 14:32:31 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 01 Mar 2019 14:32:31 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [31.4.223.53])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 250114265A2F;
        Fri,  1 Mar 2019 14:32:31 +0100 (CET)
Date:   Fri, 1 Mar 2019 14:32:30 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Li RongQing <lirongqing@baidu.com>
Cc:     netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        bridge@lists.linux-foundation.org
Subject: Re: [PATCH][nf-next][v2] netfilter: convert the proto argument from
 u8 to u16
Message-ID: <20190301133230.xccq7quitjqr4p3d@salvia>
References: <1550843152-1772-1-git-send-email-lirongqing@baidu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1550843152-1772-1-git-send-email-lirongqing@baidu.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, Feb 22, 2019 at 09:45:52PM +0800, Li RongQing wrote:
> The proto in struct xt_match and struct xt_target is u16, when
> calling xt_check_target/match, their proto argument is u8,
> and will cause truncation, it is harmless to ip packet, since
> ip proto is u8
> 
> if a etable's match/target has proto that is u16, will cause
> the check failure.
> 
> and convert be16 to short in bridge/netfilter/ebtables.c

Applied, thanks.
