Return-Path: <SRS0=/8pw=SU=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_NEOMUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0CEEC10F0E
	for <netfilter-devel@archiver.kernel.org>; Thu, 18 Apr 2019 11:28:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8FDB1217D7
	for <netfilter-devel@archiver.kernel.org>; Thu, 18 Apr 2019 11:28:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388814AbfDRL2z (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 18 Apr 2019 07:28:55 -0400
Received: from mail.us.es ([193.147.175.20]:35136 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388375AbfDRL2y (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 18 Apr 2019 07:28:54 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id BE3041C442B
        for <netfilter-devel@vger.kernel.org>; Thu, 18 Apr 2019 13:28:52 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id AE5FBDA70A
        for <netfilter-devel@vger.kernel.org>; Thu, 18 Apr 2019 13:28:52 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id A3E55DA703; Thu, 18 Apr 2019 13:28:52 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 9CBA4DA704;
        Thu, 18 Apr 2019 13:28:50 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 18 Apr 2019 13:28:50 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 7ABC64265A31;
        Thu, 18 Apr 2019 13:28:50 +0200 (CEST)
Date:   Thu, 18 Apr 2019 13:28:50 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     David Miller <davem@davemloft.net>
Cc:     fbl@redhat.com, netdev@vger.kernel.org, joe@ovn.org,
        pshelar@ovn.org, dev@openvswitch.org,
        netfilter-devel@vger.kernel.org
Subject: Re: [PATCH net-next v3 0/4] openvswitch: load and reference the NAT
 helper
Message-ID: <20190418112850.6c4e4bolkype5vtf@salvia>
References: <20190417144617.14922-1-fbl@redhat.com>
 <20190417.232509.1761143873528182624.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190417.232509.1761143873528182624.davem@davemloft.net>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Apr 17, 2019 at 11:25:09PM -0700, David Miller wrote:
> From: Flavio Leitner <fbl@redhat.com>
> Date: Wed, 17 Apr 2019 11:46:13 -0300
> 
> > The request_module() is quite expensive and triggers the
> > usermode helper in userspace. Instead, load only if the
> > module is not present and keep module references to avoid
> > problems.
> > 
> > The first patch standardize the module alias which is already
> > there, but not in a formal way.
> > 
> > The second patch adds an API to point to the NAT helper.
> > 
> > The third patch will register each NAT helper using the
> > new API.
> > 
> > The last patch fixes openvswitch to use the new API to
> > load and reference the NAT helper and also report an error
> > if the operation fails.
> 
> Netfilter folks, besides a review, I was wondering if you'd like
> to take this series the netfilter tree since it's mostly changes
> in that area?

I'll place this in the nf-next tree, thanks.
