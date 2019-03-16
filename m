Return-Path: <SRS0=RSCw=RT=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA0C1C43381
	for <netfilter-devel@archiver.kernel.org>; Sat, 16 Mar 2019 09:06:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C1219218FC
	for <netfilter-devel@archiver.kernel.org>; Sat, 16 Mar 2019 09:06:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726105AbfCPJGE (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 16 Mar 2019 05:06:04 -0400
Received: from mail.us.es ([193.147.175.20]:36852 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726084AbfCPJGE (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 16 Mar 2019 05:06:04 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 05589DA885
        for <netfilter-devel@vger.kernel.org>; Sat, 16 Mar 2019 10:06:02 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id E4D4DDA856
        for <netfilter-devel@vger.kernel.org>; Sat, 16 Mar 2019 10:06:01 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id DA5C6DA84E; Sat, 16 Mar 2019 10:06:01 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 0166ADA846;
        Sat, 16 Mar 2019 10:06:00 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Sat, 16 Mar 2019 10:06:00 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id D29F54265A4E;
        Sat, 16 Mar 2019 10:05:59 +0100 (CET)
Date:   Sat, 16 Mar 2019 10:05:59 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Fernando Fernandez Mancera <ffmancera@riseup.net>
Cc:     Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft v2 1/6] osf: add version fingerprint support
Message-ID: <20190316090559.yky2tctzfzhyjs6g@salvia>
References: <20190314201309.iqdyb7icreyyhhke@salvia>
 <20190314200737.erhjrhoaciclapsn@salvia>
 <27D82259-F921-48E0-A718-A08E2BCCAACD@riseup.net>
 <20190315100333.GD3511@orbyte.nwl.cc>
 <20190315171328.c5xgazye2hattjxr@salvia>
 <1eb195ad-028e-5760-c4c8-1062441231c9@riseup.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1eb195ad-028e-5760-c4c8-1062441231c9@riseup.net>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, Mar 15, 2019 at 09:21:56PM +0100, Fernando Fernandez Mancera wrote:
[...]
> We can hide the flags for the json support if needed by counting the
> numbers of colons.

No need to parse colons, we can map:

        osf genre
        osf version

to json, I think.
