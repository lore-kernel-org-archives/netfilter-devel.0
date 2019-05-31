Return-Path: <SRS0=7QpW=T7=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DBFADC04AB6
	for <netfilter-devel@archiver.kernel.org>; Fri, 31 May 2019 15:54:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BBDE126A0A
	for <netfilter-devel@archiver.kernel.org>; Fri, 31 May 2019 15:54:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726824AbfEaPyK (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 31 May 2019 11:54:10 -0400
Received: from mail.us.es ([193.147.175.20]:37608 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726576AbfEaPyK (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 31 May 2019 11:54:10 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 2A53181A0C
        for <netfilter-devel@vger.kernel.org>; Fri, 31 May 2019 17:54:08 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 1B5D2DA701
        for <netfilter-devel@vger.kernel.org>; Fri, 31 May 2019 17:54:08 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 02505DA709; Fri, 31 May 2019 17:54:08 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 054EADA703;
        Fri, 31 May 2019 17:54:06 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 31 May 2019 17:54:06 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id D2DE34265A5B;
        Fri, 31 May 2019 17:54:05 +0200 (CEST)
Date:   Fri, 31 May 2019 17:54:05 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Lukasz Pawelczyk <l.pawelczyk@samsung.com>
Cc:     Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lukasz Pawelczyk <havner@gmail.com>
Subject: Re: [PATCH v3] netfilter: xt_owner: Add supplementary groups option
Message-ID: <20190531155405.npz2fhey7vj56zjx@salvia>
References: <CGME20190510114627eucas1p25476833d2d375b113353741c18aecd92@eucas1p2.samsung.com>
 <20190510114622.831-1-l.pawelczyk@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190510114622.831-1-l.pawelczyk@samsung.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, May 10, 2019 at 01:46:22PM +0200, Lukasz Pawelczyk wrote:
> The XT_OWNER_SUPPL_GROUPS flag causes GIDs specified with XT_OWNER_GID
> to be also checked in the supplementary groups of a process.
> 
> f_cred->group_info cannot be modified during its lifetime and f_cred
> holds a reference to it so it's safe to use.

Applied, thanks.
