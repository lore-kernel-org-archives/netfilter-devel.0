Return-Path: <SRS0=mIA1=V7=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16728C31E40
	for <netfilter-devel@archiver.kernel.org>; Sat,  3 Aug 2019 16:40:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DFC0720679
	for <netfilter-devel@archiver.kernel.org>; Sat,  3 Aug 2019 16:40:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388907AbfHCQkd (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 3 Aug 2019 12:40:33 -0400
Received: from correo.us.es ([193.147.175.20]:36816 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388894AbfHCQkc (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 3 Aug 2019 12:40:32 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 078C7C39F1
        for <netfilter-devel@vger.kernel.org>; Sat,  3 Aug 2019 18:40:31 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id ED960DA730
        for <netfilter-devel@vger.kernel.org>; Sat,  3 Aug 2019 18:40:30 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id D436E64497; Sat,  3 Aug 2019 18:40:30 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id E33D0DA72F;
        Sat,  3 Aug 2019 18:40:28 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Sat, 03 Aug 2019 18:40:28 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [31.4.192.194])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id B59744265A2F;
        Sat,  3 Aug 2019 18:40:28 +0200 (CEST)
Date:   Sat, 3 Aug 2019 18:40:27 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Matteo Croce <mcroce@redhat.com>
Cc:     netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, Tonghao Zhang <xiangxia.m.yue@gmail.com>
Subject: Re: [PATCH net-next] netfilter: conntrack: use shared sysctl
 constants
Message-ID: <20190803164027.7hazdzom43rjwupg@salvia>
References: <20190723012303.2221-1-mcroce@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190723012303.2221-1-mcroce@redhat.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Jul 23, 2019 at 03:23:03AM +0200, Matteo Croce wrote:
> Use shared sysctl variables for zero and one constants, as in commit
> eec4844fae7c ("proc/sysctl: add shared variables for range check")

Applied, thanks.
