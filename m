Return-Path: <SRS0=BqdC=T5=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4343AC28CC0
	for <netfilter-devel@archiver.kernel.org>; Wed, 29 May 2019 19:01:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 23300240D2
	for <netfilter-devel@archiver.kernel.org>; Wed, 29 May 2019 19:01:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726099AbfE2TBy (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 29 May 2019 15:01:54 -0400
Received: from mail.us.es ([193.147.175.20]:55580 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726015AbfE2TBy (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 29 May 2019 15:01:54 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id DDF20BAE86
        for <netfilter-devel@vger.kernel.org>; Wed, 29 May 2019 21:01:52 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id CBAE4DA707
        for <netfilter-devel@vger.kernel.org>; Wed, 29 May 2019 21:01:52 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id C120CDA705; Wed, 29 May 2019 21:01:52 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id C484EDA704;
        Wed, 29 May 2019 21:01:50 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 29 May 2019 21:01:50 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id A0D7C4265A31;
        Wed, 29 May 2019 21:01:50 +0200 (CEST)
Date:   Wed, 29 May 2019 21:01:50 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Phil Sutter <phil@nwl.cc>
Cc:     netfilter-devel@vger.kernel.org, Eric Garver <e@erig.me>
Subject: Re: [nft PATCH 0/4] Fix ENOBUFS error in large transactions with
 --echo
Message-ID: <20190529190150.mg63x2sz3yje2tgx@salvia>
References: <20190529131346.23659-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190529131346.23659-1-phil@nwl.cc>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, May 29, 2019 at 03:13:42PM +0200, Phil Sutter wrote:
> When committing a larger transaction (e.g. adding 300 rules) with echo
> output turned on, mnl_batch_talk() would report ENOBUFS after the first
> call to mnl_socket_recvfrom(). (ENOBUFS indicates congestion in netlink
> socket.)

We can avoid this if we select the right buffer size for the --echo
case, to make this reliable. For events, that's a different case,
there is not much we can do in case this hits ENOBUFS, since we don't
know how much information the kernel will send to us, so we can just
report message losts to the users.

> The problem in mnl_batch_talk() was a combination of unmodified socket
> recv buffer, use of select() and unhandled ENOBUFS condition (abort
> instead of retry).
> 
> This series solves the issue, admittedly a bit in sledge hammer method:
> Maximize nf_sock receive buffer size for all users, make
> mnl_batch_talk() fetch more messages at once and retry upon ENOBUFS
> instead of just giving up.

Setting a fixed size works around the problem, yes. But still we will
hit ENOBUFS at some point. I sent you a patch to start estimating the
size of the receiver buffer size in a simple way.

> There was also a problem with select() use which motivated the loop
> rewrite in Patch 3.

Please, send a patch to fix this, thanks!

> Actually, replacing the whole loop by a simple call to
> nft_mnl_recv() worked and was even sufficient in avoiding ENOBUFS
> condition, but I am not sure if that has other side-effects.

Not sure what you mean.

>  tests/shell/testcases/transactions/0049huge_0 | 14 ++++

Thanks for this testcase.
