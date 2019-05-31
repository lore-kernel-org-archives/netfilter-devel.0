Return-Path: <SRS0=7QpW=T7=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_NEOMUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F0C7C04AB6
	for <netfilter-devel@archiver.kernel.org>; Fri, 31 May 2019 15:48:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0AAA926808
	for <netfilter-devel@archiver.kernel.org>; Fri, 31 May 2019 15:48:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726576AbfEaPsm (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 31 May 2019 11:48:42 -0400
Received: from mail.us.es ([193.147.175.20]:36340 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726518AbfEaPsm (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 31 May 2019 11:48:42 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 19D8581A0B
        for <netfilter-devel@vger.kernel.org>; Fri, 31 May 2019 17:48:39 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 0A13DDA705
        for <netfilter-devel@vger.kernel.org>; Fri, 31 May 2019 17:48:39 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id DD613DA70C; Fri, 31 May 2019 17:48:38 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id AE486DA703;
        Fri, 31 May 2019 17:48:36 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 31 May 2019 17:48:36 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 8D07B4265A5B;
        Fri, 31 May 2019 17:48:36 +0200 (CEST)
Date:   Fri, 31 May 2019 17:48:36 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Simon Horman <horms@verge.net.au>
Cc:     Julian Anastasov <ja@ssi.bg>, lvs-devel@vger.kernel.org,
        netfilter-devel@vger.kernel.org, Jacky Hu <hengqing.hu@gmail.com>,
        jacky.hu@walmart.com, jason.niesz@walmart.com
Subject: Re: [PATCHv2 net-next 0/3] Add UDP tunnel support for ICMP errors in
 IPVS
Message-ID: <20190531154836.5ew2axyhl2ogparp@salvia>
References: <20190505121440.16389-1-ja@ssi.bg>
 <20190507134745.ljijkwuu63wiqwxi@verge.net.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190507134745.ljijkwuu63wiqwxi@verge.net.au>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, May 07, 2019 at 03:47:45PM +0200, Simon Horman wrote:
> On Sun, May 05, 2019 at 03:14:37PM +0300, Julian Anastasov wrote:
> > This patchset is a followup to the commit that adds UDP/GUE tunnel:
> > "ipvs: allow tunneling with gue encapsulation".
> > 
> > What we do is to put tunnel real servers in hash table (patch 1),
> > add function to lookup tunnels (patch 2) and use it to strip the
> > embedded tunnel headers from ICMP errors (patch 3).
> > 
> > v1->v2:
> > patch 1: remove extra parentheses
> > patch 2: remove extra parentheses
> > patch 3: parse UDP header into ipvs_udp_decap
> > patch 3: v1 ignores forwarded ICMP errors for UDP, do not do that
> > patch 3: add comment for fragment check
> > 
> > Julian Anastasov (3):
> >   ipvs: allow rs_table to contain different real server types
> >   ipvs: add function to find tunnels
> >   ipvs: strip udp tunnel headers from icmp errors
> 
> Thanks Julian,
> 
> this looks good for me.
> For all patches:
> 
> Signed-off-by: Simon Horman <horms@verge.net.au>
> 
> Pablo, could you consider applying these to nf-next when appropriate?

Series applied, thanks.
