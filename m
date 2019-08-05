Return-Path: <SRS0=7PQj=WB=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B45F5C0650F
	for <netfilter-devel@archiver.kernel.org>; Mon,  5 Aug 2019 09:30:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 95B5920880
	for <netfilter-devel@archiver.kernel.org>; Mon,  5 Aug 2019 09:30:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727158AbfHEJas (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 5 Aug 2019 05:30:48 -0400
Received: from correo.us.es ([193.147.175.20]:57408 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726423AbfHEJas (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 5 Aug 2019 05:30:48 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 30058BA1B3
        for <netfilter-devel@vger.kernel.org>; Mon,  5 Aug 2019 11:30:46 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 1F56A5C023
        for <netfilter-devel@vger.kernel.org>; Mon,  5 Aug 2019 11:30:46 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 150D0A8EF; Mon,  5 Aug 2019 11:30:46 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 203491150CB;
        Mon,  5 Aug 2019 11:30:44 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 05 Aug 2019 11:30:44 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (149.103.108.93.rev.vodafone.pt [93.108.103.149])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 6DDA04265A2F;
        Mon,  5 Aug 2019 11:30:43 +0200 (CEST)
Date:   Mon, 5 Aug 2019 11:30:40 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org, steffen.klassert@secunet.com
Subject: Re: [PATCH nf 1/2] selftests: netfilter: extend flowtable test
 script for ipsec
Message-ID: <20190805093040.naznljvwn45pqrye@salvia>
References: <20190730125719.23553-1-fw@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190730125719.23553-1-fw@strlen.de>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Jul 30, 2019 at 02:57:18PM +0200, Florian Westphal wrote:
> 'flow offload' expression should not offload flows that will be subject
> to ipsec, but it does.
> 
> This results in a connectivity blackhole for the affected flows -- first
> packets will go through (offload happens after established state is
> reached), but all remaining ones bypass ipsec encryption and are thus
> discarded by the peer.
> 
> This can be worked around by adding "rt ipsec exists accept"
> before the 'flow offload' rule matches.
> 
> This test case will fail, support for such flows is added in
> next patch.

Applied, thanks Florian.
