Return-Path: <SRS0=q2Xo=RC=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 068F2C43381
	for <netfilter-devel@archiver.kernel.org>; Wed, 27 Feb 2019 10:04:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D37CC2084D
	for <netfilter-devel@archiver.kernel.org>; Wed, 27 Feb 2019 10:04:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726230AbfB0KEJ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 27 Feb 2019 05:04:09 -0500
Received: from mail.us.es ([193.147.175.20]:53596 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725983AbfB0KEJ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 27 Feb 2019 05:04:09 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 502EC53AA32
        for <netfilter-devel@vger.kernel.org>; Wed, 27 Feb 2019 11:04:07 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 3D2FDDA86F
        for <netfilter-devel@vger.kernel.org>; Wed, 27 Feb 2019 11:04:07 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 31ED9DA84E; Wed, 27 Feb 2019 11:04:07 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 5CF9CDA87D;
        Wed, 27 Feb 2019 11:04:05 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 27 Feb 2019 11:04:05 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 2F2204265A2F;
        Wed, 27 Feb 2019 11:04:05 +0100 (CET)
Date:   Wed, 27 Feb 2019 11:04:04 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Li RongQing <lirongqing@baidu.com>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH][nf-next] netfilter: remove unneeded switch fall-through
Message-ID: <20190227100404.gffxamasm6b4j5mz@salvia>
References: <1550825924-18063-1-git-send-email-lirongqing@baidu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1550825924-18063-1-git-send-email-lirongqing@baidu.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, Feb 22, 2019 at 04:58:44PM +0800, Li RongQing wrote:
> Empty case is fine and does not switch fall-through 

Applied, thanks.
