Return-Path: <SRS0=dzjG=EK=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04C16C2D0A3
	for <netfilter-devel@archiver.kernel.org>; Wed,  4 Nov 2020 13:03:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 95EE42071A
	for <netfilter-devel@archiver.kernel.org>; Wed,  4 Nov 2020 13:03:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729782AbgKDNDl (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 4 Nov 2020 08:03:41 -0500
Received: from correo.us.es ([193.147.175.20]:55694 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726350AbgKDNDl (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 4 Nov 2020 08:03:41 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id E2FD4D9AD70
        for <netfilter-devel@vger.kernel.org>; Wed,  4 Nov 2020 14:03:38 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id D241DDA78A
        for <netfilter-devel@vger.kernel.org>; Wed,  4 Nov 2020 14:03:38 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id C78F3DA722; Wed,  4 Nov 2020 14:03:38 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B8071DA730;
        Wed,  4 Nov 2020 14:03:36 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 04 Nov 2020 14:03:36 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 9763E42EF9E0;
        Wed,  4 Nov 2020 14:03:36 +0100 (CET)
Date:   Wed, 4 Nov 2020 14:03:36 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft 0/3] json: resolve multiple test case failures
Message-ID: <20201104130336.GA2097@salvia>
References: <20201103182040.24858-1-fw@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20201103182040.24858-1-fw@strlen.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Nov 03, 2020 at 07:20:37PM +0100, Florian Westphal wrote:
> Over the last few months nft gained a few new features and test cases
> that either do not have a json test case or fail in json mode.
> 
> First two patches only touch the test cases themselves, but the snat.t
> failure turned out to be due to lack of feature parity with the normal
> bison parser.
> 
> Thus that patch adds needed export/import facility for nat_type
> and the netmap flag.

Patches LGTM, thanks.
