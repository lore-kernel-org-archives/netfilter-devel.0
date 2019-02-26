Return-Path: <SRS0=SqQQ=RB=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B376EC43381
	for <netfilter-devel@archiver.kernel.org>; Tue, 26 Feb 2019 09:47:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7E361213A2
	for <netfilter-devel@archiver.kernel.org>; Tue, 26 Feb 2019 09:47:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727614AbfBZJrl (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 26 Feb 2019 04:47:41 -0500
Received: from mail.us.es ([193.147.175.20]:46902 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727612AbfBZJrl (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 26 Feb 2019 04:47:41 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 51B9919190E
        for <netfilter-devel@vger.kernel.org>; Tue, 26 Feb 2019 10:47:38 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 4011CDA863
        for <netfilter-devel@vger.kernel.org>; Tue, 26 Feb 2019 10:47:38 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 3F104DA844; Tue, 26 Feb 2019 10:47:38 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 24105DA86F;
        Tue, 26 Feb 2019 10:47:36 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 26 Feb 2019 10:47:35 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 0502B4265A4E;
        Tue, 26 Feb 2019 10:47:35 +0100 (CET)
Date:   Tue, 26 Feb 2019 10:47:35 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Tham <tham@fidion.de>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH] netfilter: nf_conntrack_amanda: add support for STATE
 streams
Message-ID: <20190226094735.2uioiyrulqgcmkbf@salvia>
References: <a01c1d2d-d55d-c55b-c39d-2b35c070bcae@fidion.de>
 <20190215143902.ga5e2pljilncvqcu@salvia>
 <ecf05928-0258-f835-6ea2-f6bb73a83481@fidion.de>
 <20190218095336.2u54jnsn3mmxoq5q@salvia>
 <767a3554-3a6f-651d-44d7-7b309a29688f@fidion.de>
 <20190218124245.s3b5zoysnu7gtloy@salvia>
 <5ed5cbb2-d083-ef70-7ca6-6c0ca7cb8062@fidion.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5ed5cbb2-d083-ef70-7ca6-6c0ca7cb8062@fidion.de>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Feb 26, 2019 at 10:10:48AM +0100, Florian Tham wrote:
> Hello Pablo,
> 
> On 2/18/19 1:42 PM, Pablo Neira Ayuso wrote:
> >> After I set max_expected to 4, the backup completes successfully.
> > 
> > Then, the new protocol version needs to set up more than 3
> > expectations in parallel. Please, document this in your patch
> > description.
> 
> I did so in my reply to this message on Feb. 18. Does this work for you,
> or is there anything else I can do?

Yes, no worries.

I'll mangle the patch to add what you said.
