Return-Path: <SRS0=l45K=UY=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2EA7C48BD4
	for <netfilter-devel@archiver.kernel.org>; Tue, 25 Jun 2019 08:08:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8940120883
	for <netfilter-devel@archiver.kernel.org>; Tue, 25 Jun 2019 08:08:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727692AbfFYII7 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 25 Jun 2019 04:08:59 -0400
Received: from mail.us.es ([193.147.175.20]:41960 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726951AbfFYII7 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 25 Jun 2019 04:08:59 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id EB8BEC328F
        for <netfilter-devel@vger.kernel.org>; Tue, 25 Jun 2019 10:08:56 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id D56D6207DE
        for <netfilter-devel@vger.kernel.org>; Tue, 25 Jun 2019 10:08:56 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id D4C0558F; Tue, 25 Jun 2019 10:08:56 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 611621150DA;
        Tue, 25 Jun 2019 10:08:54 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 25 Jun 2019 10:08:54 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 3B2204265A5B;
        Tue, 25 Jun 2019 10:08:54 +0200 (CEST)
Date:   Tue, 25 Jun 2019 10:08:53 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Felix Kaechele <felix@kaechele.ca>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH 08/13] netfilter: ctnetlink: Resolve conntrack
 L3-protocol flush regression
Message-ID: <20190625080853.d6f523cimgg2u44v@salvia>
References: <20190513095630.32443-1-pablo@netfilter.org>
 <20190513095630.32443-9-pablo@netfilter.org>
 <0a4e3cd2-82f7-8ad6-2403-9852e34c8ac3@kaechele.ca>
 <20190624235816.vw6ahepdgvxhvdej@salvia>
 <4367f30f-4602-a4b6-a96e-35d879cc7758@kaechele.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4367f30f-4602-a4b6-a96e-35d879cc7758@kaechele.ca>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, Jun 24, 2019 at 11:02:40PM -0400, Felix Kaechele wrote:
> On 2019-06-24 7:58 p.m., Pablo Neira Ayuso wrote:
> > Could you give a try to this patch?
> 
> Hi there,
> 
> unfortunately the patch didn't work for me.
> 
> I did some deeper digging and it seems that nf_conntrack_find_get within
> ctnetlink_del_conntrack will not find the entry if the address family for
> the delete query is AF_UNSPEC (due to nfmsg->version being 0) but the
> conntrack entry was initially created with AF_INET as the address family. I
> believe the tuples will have different hashes in this case and my guess is
> that this is not accounted for in the code, i.e. that AF_UNSPEC should match
> both AF_INET and AF_INET6. At the moment it seems to match none instead.

As you describe, conntrack is a hashtable and the layer 3 protocol is
part of the hash:

https://elixir.bootlin.com/linux/latest/source/net/netfilter/nf_conntrack_core.c#L188

so AF_UNSPEC cannot work.

There is no support for layer 3 wildcard deletion.
