Return-Path: <SRS0=pwfE=YW=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 150E9CA9EAE
	for <netfilter-devel@archiver.kernel.org>; Tue, 29 Oct 2019 12:07:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DB20321479
	for <netfilter-devel@archiver.kernel.org>; Tue, 29 Oct 2019 12:07:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727525AbfJ2MHr (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 29 Oct 2019 08:07:47 -0400
Received: from correo.us.es ([193.147.175.20]:44614 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725776AbfJ2MHr (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 29 Oct 2019 08:07:47 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id CCD7B1694B2
        for <netfilter-devel@vger.kernel.org>; Tue, 29 Oct 2019 13:07:41 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id C0042CA0F3
        for <netfilter-devel@vger.kernel.org>; Tue, 29 Oct 2019 13:07:41 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id B5817CA0F1; Tue, 29 Oct 2019 13:07:41 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id A32C6B8004;
        Tue, 29 Oct 2019 13:07:39 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 29 Oct 2019 13:07:39 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 7E9CB42EE39D;
        Tue, 29 Oct 2019 13:07:39 +0100 (CET)
Date:   Tue, 29 Oct 2019 13:07:41 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Phil Sutter <phil@nwl.cc>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH] tests/py: Fix test script for Python3 tempfile
Message-ID: <20191029120741.kwx4w7droeqlhqj4@salvia>
References: <20191029112508.16502-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191029112508.16502-1-phil@nwl.cc>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Oct 29, 2019 at 12:25:08PM +0100, Phil Sutter wrote:
> When instantiating a temporary file using tempfile's TemporaryFile()
> constructor, the resulting object's 'name' attribute is of type int.
> This in turn makes print_msg() puke while trying to concatenate string
> and int using '+' operator.
> 
> Fix this by using format strings consequently, thereby cleaning up code
> a bit.
> 
> Signed-off-by: Phil Sutter <phil@nwl.cc>

Acked-by: Pablo Neira Ayuso <pablo@netfilter.org>
