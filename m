Return-Path: <SRS0=aW9c=VA=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 732A1C06514
	for <netfilter-devel@archiver.kernel.org>; Wed,  3 Jul 2019 19:10:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 511C0218A0
	for <netfilter-devel@archiver.kernel.org>; Wed,  3 Jul 2019 19:10:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727279AbfGCTJ7 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 3 Jul 2019 15:09:59 -0400
Received: from mail.us.es ([193.147.175.20]:42818 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726762AbfGCTJ6 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 3 Jul 2019 15:09:58 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 1FA0DC1A00
        for <netfilter-devel@vger.kernel.org>; Wed,  3 Jul 2019 21:09:56 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 10800114D6E
        for <netfilter-devel@vger.kernel.org>; Wed,  3 Jul 2019 21:09:56 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 05C841021A9; Wed,  3 Jul 2019 21:09:56 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 0751671E8;
        Wed,  3 Jul 2019 21:09:54 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 03 Jul 2019 21:09:54 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id D07BE40705C3;
        Wed,  3 Jul 2019 21:09:53 +0200 (CEST)
Date:   Wed, 3 Jul 2019 21:09:53 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Julian Anastasov <ja@ssi.bg>
Cc:     Randy Dunlap <rdunlap@infradead.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        lvs-devel@vger.kernel.org
Subject: Re: linux-next: Tree for Jul 3 (netfilter/ipvs/)
Message-ID: <20190703190953.jybqfokxbgtuijyu@salvia>
References: <20190703214900.45e94ae4@canb.auug.org.au>
 <406d9741-68ad-f465-1248-64eef05b1350@infradead.org>
 <alpine.LFD.2.21.1907032126220.3226@ja.home.ssi.bg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.21.1907032126220.3226@ja.home.ssi.bg>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Jul 03, 2019 at 09:29:26PM +0300, Julian Anastasov wrote:
> 
> 	Hello,
> 
> On Wed, 3 Jul 2019, Randy Dunlap wrote:
> 
> > On 7/3/19 4:49 AM, Stephen Rothwell wrote:
> > > Hi all,
> > > 
> > > Changes since 20190702:
> > > 
> > 
> > on i386:
> 
> 	Oh, well. net/gre.h was included by CONFIG_NF_CONNTRACK, so
> it is failing when CONFIG_NF_CONNTRACK is not used.
> 
> 	Pablo, should I post v2 or just a fix?

I let you choose.
