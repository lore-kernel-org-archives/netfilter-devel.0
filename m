Return-Path: <SRS0=QW5x=UU=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5627C43613
	for <netfilter-devel@archiver.kernel.org>; Fri, 21 Jun 2019 15:29:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B803C2075E
	for <netfilter-devel@archiver.kernel.org>; Fri, 21 Jun 2019 15:29:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726138AbfFUP3G (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 21 Jun 2019 11:29:06 -0400
Received: from mail.us.es ([193.147.175.20]:50598 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726045AbfFUP3G (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 21 Jun 2019 11:29:06 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 33FAEEDB06
        for <netfilter-devel@vger.kernel.org>; Fri, 21 Jun 2019 17:29:04 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 244DFDA705
        for <netfilter-devel@vger.kernel.org>; Fri, 21 Jun 2019 17:29:04 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 19D76DA702; Fri, 21 Jun 2019 17:29:04 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 2EE60DA705;
        Fri, 21 Jun 2019 17:29:02 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 21 Jun 2019 17:29:02 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 0F2C34265A2F;
        Fri, 21 Jun 2019 17:29:02 +0200 (CEST)
Date:   Fri, 21 Jun 2019 17:29:01 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Stephen Suryaputra <ssuryaextr@gmail.com>
Cc:     netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH nf-next v5] netfilter: add support for matching IPv4
 options
Message-ID: <20190621152901.fjuwuv5bmrygigta@salvia>
References: <20190620161959.7252-1-ssuryaextr@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190620161959.7252-1-ssuryaextr@gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Jun 20, 2019 at 12:19:59PM -0400, Stephen Suryaputra wrote:
> This is the kernel change for the overall changes with this description:
> Add capability to have rules matching IPv4 options. This is developed
> mainly to support dropping of IP packets with loose and/or strict source
> route route options.

Applied, thanks Stephen.
