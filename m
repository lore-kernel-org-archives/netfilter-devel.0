Return-Path: <SRS0=WPBU=CJ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLACK,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24A9EC433E2
	for <netfilter-devel@archiver.kernel.org>; Mon, 31 Aug 2020 21:18:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F219120678
	for <netfilter-devel@archiver.kernel.org>; Mon, 31 Aug 2020 21:18:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730226AbgHaVS2 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 31 Aug 2020 17:18:28 -0400
Received: from correo.us.es ([193.147.175.20]:50196 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730221AbgHaVS1 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 31 Aug 2020 17:18:27 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 139981C442B
        for <netfilter-devel@vger.kernel.org>; Mon, 31 Aug 2020 23:18:24 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 0595DDA791
        for <netfilter-devel@vger.kernel.org>; Mon, 31 Aug 2020 23:18:24 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id DEA2FDA7B6; Mon, 31 Aug 2020 23:18:23 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 8465BDA78B;
        Mon, 31 Aug 2020 23:18:21 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 31 Aug 2020 23:18:21 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 44245426CCB9;
        Mon, 31 Aug 2020 23:18:21 +0200 (CEST)
Date:   Mon, 31 Aug 2020 23:18:20 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Julian Anastasov <ja@ssi.bg>
Cc:     Yaroslav Bolyukin <iam@lach.pw>,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Wensong Zhang <wensong@linux-vs.org>,
        Simon Horman <horms@verge.net.au>,
        Jakub Kicinski <kuba@kernel.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>, netdev@vger.kernel.org,
        lvs-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org
Subject: Re: [PATCHv5 net-next] ipvs: remove dependency on ip6_tables
Message-ID: <20200831211820.GB24186@salvia>
References: <alpine.LFD.2.23.451.2008291233110.3043@ja.home.ssi.bg>
 <20200829135953.20228-1-iam@lach.pw>
 <alpine.LFD.2.23.451.2008312005270.4425@ja.home.ssi.bg>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.23.451.2008312005270.4425@ja.home.ssi.bg>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, Aug 31, 2020 at 08:12:05PM +0300, Julian Anastasov wrote:
> 
> 	Hello,
> 
> On Sat, 29 Aug 2020, Yaroslav Bolyukin wrote:
> 
> > This dependency was added because ipv6_find_hdr was in iptables specific
> > code but is no longer required
> > 
> > Fixes: f8f626754ebe ("ipv6: Move ipv6_find_hdr() out of Netfilter code.")
> > Fixes: 63dca2c0b0e7 ("ipvs: Fix faulty IPv6 extension header handling in IPVS").
> > Signed-off-by: Yaroslav Bolyukin <iam@lach.pw>
> 
> 	Looks good to me, thanks! May be maintainers will
> remove the extra dot after the Fixes line.

Applied, thanks. I have also removed the extra dot.
