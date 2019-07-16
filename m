Return-Path: <SRS0=/Fuh=VN=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77CB2C7618F
	for <netfilter-devel@archiver.kernel.org>; Tue, 16 Jul 2019 19:29:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4F33720659
	for <netfilter-devel@archiver.kernel.org>; Tue, 16 Jul 2019 19:29:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728781AbfGPT33 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 16 Jul 2019 15:29:29 -0400
Received: from mail.us.es ([193.147.175.20]:47068 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728340AbfGPT32 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 16 Jul 2019 15:29:28 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 98C8EBEBA6
        for <netfilter-devel@vger.kernel.org>; Tue, 16 Jul 2019 21:29:26 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 89C3B1150D8
        for <netfilter-devel@vger.kernel.org>; Tue, 16 Jul 2019 21:29:26 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 7F6631150CE; Tue, 16 Jul 2019 21:29:26 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 923F6DA732;
        Tue, 16 Jul 2019 21:29:24 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 16 Jul 2019 21:29:24 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 6D8894265A2F;
        Tue, 16 Jul 2019 21:29:24 +0200 (CEST)
Date:   Tue, 16 Jul 2019 21:29:24 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     =?iso-8859-1?Q?St=E9phane?= Veyret <sveyret@gmail.com>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nftables v5 1/1] add ct expectations support
Message-ID: <20190716192924.tdjzbvwpdovli7kk@salvia>
References: <20190709130209.24639-1-sveyret@gmail.com>
 <20190709130209.24639-2-sveyret@gmail.com>
 <20190716191935.j62mlzahtupzoji6@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190716191935.j62mlzahtupzoji6@salvia>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Jul 16, 2019 at 09:19:35PM +0200, Pablo Neira Ayuso wrote:
> On Tue, Jul 09, 2019 at 03:02:09PM +0200, Stéphane Veyret wrote:
> > This modification allow to directly add/list/delete expectations.
> 
> Applied, thanks Stephane.

Small problem still, if you don't mind to follow up with an
incremental fix:

ip/objects.t: ERROR: line 52: Failed to add JSON equivalent rule

Looking at /tmp/nftables-test.log, it says:

command: {"nftables": [{"add": {"rule": {"table": "test-ip4", "chain": "output", "family": "ip", "expr": [{"ct expect": "ctexpect1"}]}}}]}
internal:0:0-0: Error: Unknown statement object 'ct expect'.

Thanks.
