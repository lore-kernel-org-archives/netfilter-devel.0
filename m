Return-Path: <SRS0=TR/Z=U2=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3265C48BD6
	for <netfilter-devel@archiver.kernel.org>; Thu, 27 Jun 2019 12:19:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A6A852085A
	for <netfilter-devel@archiver.kernel.org>; Thu, 27 Jun 2019 12:19:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726693AbfF0MTb (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 27 Jun 2019 08:19:31 -0400
Received: from mail.us.es ([193.147.175.20]:56286 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726308AbfF0MTb (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 27 Jun 2019 08:19:31 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 7028C11ED85
        for <netfilter-devel@vger.kernel.org>; Thu, 27 Jun 2019 14:19:29 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 5F9425C01B
        for <netfilter-devel@vger.kernel.org>; Thu, 27 Jun 2019 14:19:29 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 5E200DA4D1; Thu, 27 Jun 2019 14:19:29 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 5C461FB37C;
        Thu, 27 Jun 2019 14:19:27 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 27 Jun 2019 14:19:27 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 3A2344265A2F;
        Thu, 27 Jun 2019 14:19:27 +0200 (CEST)
Date:   Thu, 27 Jun 2019 14:19:26 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Arturo Borrero Gonzalez <arturo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH 1/3] nft: use own allocation function
Message-ID: <20190627121926.6nydxo55chwgtrnj@salvia>
References: <156163260014.22035.13586288868224137755.stgit@endurance>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <156163260014.22035.13586288868224137755.stgit@endurance>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Jun 27, 2019 at 12:50:00PM +0200, Arturo Borrero Gonzalez wrote:
> In the current setup, nft (the frontend object) is using the xzalloc() function
> from libnftables, which does not makes sense, as this is typically an internal
> helper function.
> 
> In order to don't use this public libnftables symbol (a later patch just
> removes it), let's introduce a new allocation function in the nft frontend.
> This results in a bit of code duplication, but given the simplicity of the code,
> I don't think it's a big deal.
> 
> Other possible approach would be to have xzalloc() become part of libnftables
> public API, but that is a much worse scenario I think.

Could you replace the call to xzalloc() in main.c by calloc()?

Also check for the error if calloc() fails, then print error and
exit().

Just like other error path in main.c

Thanks!
