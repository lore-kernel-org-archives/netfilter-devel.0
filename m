Return-Path: <SRS0=U5qg=5O=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D70EC43331
	for <netfilter-devel@archiver.kernel.org>; Sun, 29 Mar 2020 15:58:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E509F20733
	for <netfilter-devel@archiver.kernel.org>; Sun, 29 Mar 2020 15:58:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728282AbgC2P6b (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 29 Mar 2020 11:58:31 -0400
Received: from correo.us.es ([193.147.175.20]:41134 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727167AbgC2P6b (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 29 Mar 2020 11:58:31 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 5FD27E2C50
        for <netfilter-devel@vger.kernel.org>; Sun, 29 Mar 2020 17:58:29 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 522E4FF6F8
        for <netfilter-devel@vger.kernel.org>; Sun, 29 Mar 2020 17:58:29 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 47C51FF6F4; Sun, 29 Mar 2020 17:58:29 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 65D82FA525;
        Sun, 29 Mar 2020 17:58:27 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Sun, 29 Mar 2020 17:58:27 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 402F842EF42B;
        Sun, 29 Mar 2020 17:58:27 +0200 (CEST)
Date:   Sun, 29 Mar 2020 17:58:26 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     wenxu@ucloud.cn
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH 2/2] netfilter: flowtable: add counter support in HW
 offload
Message-ID: <20200329155826.7ezr5wlaznub72b6@salvia>
References: <1585357074-13162-1-git-send-email-wenxu@ucloud.cn>
 <1585357074-13162-2-git-send-email-wenxu@ucloud.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1585357074-13162-2-git-send-email-wenxu@ucloud.cn>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Sat, Mar 28, 2020 at 08:57:54AM +0800, wenxu@ucloud.cn wrote:
> From: wenxu <wenxu@ucloud.cn>
> 
> Store the conntrack counters to the conntrack entry in the
> HW flowtable offload.

Applied.
