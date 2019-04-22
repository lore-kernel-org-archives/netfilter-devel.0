Return-Path: <SRS0=3cJm=SY=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A848C282E1
	for <netfilter-devel@archiver.kernel.org>; Mon, 22 Apr 2019 08:38:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4FFF820656
	for <netfilter-devel@archiver.kernel.org>; Mon, 22 Apr 2019 08:38:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726874AbfDVIh7 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 22 Apr 2019 04:37:59 -0400
Received: from mail.us.es ([193.147.175.20]:42998 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726305AbfDVIh7 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 22 Apr 2019 04:37:59 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id CBF7527F8B1
        for <netfilter-devel@vger.kernel.org>; Mon, 22 Apr 2019 10:37:57 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id A656CDA709
        for <netfilter-devel@vger.kernel.org>; Mon, 22 Apr 2019 10:37:57 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 53740DA4D9; Mon, 22 Apr 2019 10:37:48 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id A22D8DA7FE;
        Mon, 22 Apr 2019 10:37:45 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 22 Apr 2019 10:37:45 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 67CE94265A31;
        Mon, 22 Apr 2019 10:37:45 +0200 (CEST)
Date:   Mon, 22 Apr 2019 10:37:45 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org,
        syzbot+659574e7bcc7f7eb4df7@syzkaller.appspotmail.com
Subject: Re: [PATCH nf] netfilter: ebtables: CONFIG_COMPAT: drop a bogus
 WARN_ON
Message-ID: <20190422083745.x6qlao2dlqz6aw6d@salvia>
References: <20190414224300.21300-1-fw@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190414224300.21300-1-fw@strlen.de>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, Apr 15, 2019 at 12:43:00AM +0200, Florian Westphal wrote:
> It means userspace gave us a ruleset where there is some other
> data after the ebtables target but before the beginning of the next rule.

Applied, thanks Florian.
