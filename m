Return-Path: <SRS0=n11Q=TD=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C7D0C43219
	for <netfilter-devel@archiver.kernel.org>; Fri,  3 May 2019 16:15:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6DAFA20651
	for <netfilter-devel@archiver.kernel.org>; Fri,  3 May 2019 16:15:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726633AbfECQPy (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 3 May 2019 12:15:54 -0400
Received: from mail.us.es ([193.147.175.20]:34326 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725809AbfECQPy (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 3 May 2019 12:15:54 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id F4235E2C43
        for <netfilter-devel@vger.kernel.org>; Fri,  3 May 2019 18:15:51 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id E596FDA702
        for <netfilter-devel@vger.kernel.org>; Fri,  3 May 2019 18:15:51 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id DB45FDA701; Fri,  3 May 2019 18:15:51 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id F1B40DA702;
        Fri,  3 May 2019 18:15:49 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 03 May 2019 18:15:49 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id C67C84265A31;
        Fri,  3 May 2019 18:15:49 +0200 (CEST)
Date:   Fri, 3 May 2019 18:15:49 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Eric Garver <eric@garver.life>
Cc:     netfilter-devel@vger.kernel.org, Phil Sutter <phil@nwl.cc>
Subject: Re: [PATCH nft] parser_json: fix crash on add rule to bad references
Message-ID: <20190503161549.t2n6vwbzmdisaz2s@salvia>
References: <20190501163445.29604-1-eric@garver.life>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190501163445.29604-1-eric@garver.life>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, May 01, 2019 at 12:34:45PM -0400, Eric Garver wrote:
> Pass the location via the handle so the error leg in
> rule_translate_index() can reference it. Applies to invalid references
> to tables, chains, and indexes.

Applied, thanks.
