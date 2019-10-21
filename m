Return-Path: <SRS0=/SeC=YO=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4CE42CA9EAF
	for <netfilter-devel@archiver.kernel.org>; Mon, 21 Oct 2019 16:00:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1C6A02084B
	for <netfilter-devel@archiver.kernel.org>; Mon, 21 Oct 2019 16:00:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728052AbfJUQAg (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 21 Oct 2019 12:00:36 -0400
Received: from correo.us.es ([193.147.175.20]:47154 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726332AbfJUQAg (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 21 Oct 2019 12:00:36 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 0BB6715C108
        for <netfilter-devel@vger.kernel.org>; Mon, 21 Oct 2019 18:00:32 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id EC50BB8007
        for <netfilter-devel@vger.kernel.org>; Mon, 21 Oct 2019 18:00:31 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id E1D95B7FFB; Mon, 21 Oct 2019 18:00:31 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 71E9EA8271;
        Mon, 21 Oct 2019 18:00:29 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 21 Oct 2019 18:00:29 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 3821E42EF4E0;
        Mon, 21 Oct 2019 18:00:29 +0200 (CEST)
Date:   Mon, 21 Oct 2019 18:00:31 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft] main: misleading error reporting in chain definitions
Message-ID: <20191021160031.yqnn4oelty3qmiue@salvia>
References: <20191021153835.30123-1-pablo@netfilter.org>
 <20191021154713.GC17858@orbyte.nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191021154713.GC17858@orbyte.nwl.cc>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, Oct 21, 2019 at 05:47:13PM +0200, Phil Sutter wrote:
> Hi Pablo,
> 
> On Mon, Oct 21, 2019 at 05:38:35PM +0200, Pablo Neira Ayuso wrote:
> >  # nft add chain x y { type filter hook input priority -30\; }
> >  nft: invalid option -- '3'
> > 
> > Fix this by restricting getopt_long() to the first curly brace.
> 
> Wouldn't it suffice to set the first char of OPTSTRING to '+'? Exporting
> POSIXLY_CORRECT=1 prior to calling the above command works at least.

Would you post a patch? :-)
