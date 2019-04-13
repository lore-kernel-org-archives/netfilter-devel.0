Return-Path: <SRS0=eJXe=SP=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F426C10F11
	for <netfilter-devel@archiver.kernel.org>; Sat, 13 Apr 2019 13:00:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 12A542070D
	for <netfilter-devel@archiver.kernel.org>; Sat, 13 Apr 2019 13:00:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727059AbfDMNAY (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 13 Apr 2019 09:00:24 -0400
Received: from mail.us.es ([193.147.175.20]:52046 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726833AbfDMNAY (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 13 Apr 2019 09:00:24 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 960ACDC9B9
        for <netfilter-devel@vger.kernel.org>; Sat, 13 Apr 2019 15:00:22 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 868A7DA701
        for <netfilter-devel@vger.kernel.org>; Sat, 13 Apr 2019 15:00:22 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 7AA51DA707; Sat, 13 Apr 2019 15:00:22 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 7A523DA701;
        Sat, 13 Apr 2019 15:00:20 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Sat, 13 Apr 2019 15:00:20 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 574FA4265A31;
        Sat, 13 Apr 2019 15:00:20 +0200 (CEST)
Date:   Sat, 13 Apr 2019 15:00:19 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Julian Anastasov <ja@ssi.bg>
Cc:     Simon Horman <horms@verge.net.au>, lvs-devel@vger.kernel.org,
        netfilter-devel@vger.kernel.org, Alex Gartrell <agartrell@fb.com>,
        Jacky Hu <hengqing.hu@gmail.com>, jacky.hu@walmart.com,
        jason.niesz@walmart.com
Subject: Re: [PATCH net] ipvs: do not schedule icmp errors from tunnels
Message-ID: <20190413130019.rcdbwedzd4xv5fud@salvia>
References: <20190331102452.7415-1-ja@ssi.bg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190331102452.7415-1-ja@ssi.bg>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Sun, Mar 31, 2019 at 01:24:52PM +0300, Julian Anastasov wrote:
> We can receive ICMP errors from client or from
> tunneling real server. While the former can be
> scheduled to real server, the latter should
> not be scheduled, they are decapsulated only when
> existing connection is found.

Applied, thanks.
