Return-Path: <SRS0=6aKc=BY=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD223C433DF
	for <netfilter-devel@archiver.kernel.org>; Fri, 14 Aug 2020 09:57:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9951C204EA
	for <netfilter-devel@archiver.kernel.org>; Fri, 14 Aug 2020 09:57:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727118AbgHNJ5S (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 14 Aug 2020 05:57:18 -0400
Received: from correo.us.es ([193.147.175.20]:39264 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726997AbgHNJ5S (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 14 Aug 2020 05:57:18 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 1C744C22E0
        for <netfilter-devel@vger.kernel.org>; Fri, 14 Aug 2020 11:57:17 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 09B75DA722
        for <netfilter-devel@vger.kernel.org>; Fri, 14 Aug 2020 11:57:17 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id F327FDA730; Fri, 14 Aug 2020 11:57:16 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id EB425DA722;
        Fri, 14 Aug 2020 11:57:14 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 14 Aug 2020 11:57:14 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (170.pool85-48-185.static.orange.es [85.48.185.170])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 80E6942EF42A;
        Fri, 14 Aug 2020 11:57:14 +0200 (CEST)
Date:   Fri, 14 Aug 2020 11:57:13 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH lnf-conntrack] conntrack: sctp: update states
Message-ID: <20200814095713.GB5816@salvia>
References: <20200813170630.22987-1-fw@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200813170630.22987-1-fw@strlen.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Aug 13, 2020 at 07:06:30PM +0200, Florian Westphal wrote:
> with more recent kernels "conntrack -L" prints NONE instead of
> HEARTBEAT_SENT/RECEIVED because the state is unknown in userspace.
> 
> Signed-off-by: Florian Westphal <fw@strlen.de>

Reviewed-by: Pablo Neira Ayuso <pablo@netfilter.org>

Thanks!
