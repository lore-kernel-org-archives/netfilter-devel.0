Return-Path: <SRS0=49hf=R5=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0EF26C43381
	for <netfilter-devel@archiver.kernel.org>; Tue, 26 Mar 2019 23:07:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D056F20811
	for <netfilter-devel@archiver.kernel.org>; Tue, 26 Mar 2019 23:06:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731583AbfCZXG7 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 26 Mar 2019 19:06:59 -0400
Received: from ganesha.gnumonks.org ([213.95.27.120]:33696 "EHLO
        ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730605AbfCZXG7 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 26 Mar 2019 19:06:59 -0400
Received: from sys.soleta.eu ([212.170.55.40] helo=gnumonks.org)
        by ganesha.gnumonks.org with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.84_2)
        (envelope-from <pablo@gnumonks.org>)
        id 1h8v9h-0003WA-Tk; Wed, 27 Mar 2019 00:06:55 +0100
Date:   Wed, 27 Mar 2019 00:06:53 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     kfm@plushkava.net, stable@vger.kernel.org, mpagano@gentoo.org,
        thibaut.sautereau@clip-os.org, netfilter-devel@vger.kernel.org
Subject: netfilter: nf_tables: fix set double-free in abort path
Message-ID: <20190326230653.pqhqk7dzoeja46yh@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Greg,

I'm receiving several emails for a bit of time now to request to
cherry-pick this patch:

        40ba1d9b4d19 netfilter: nf_tables: fix set double-free in abort path

to kernel 5.0 stable queue. I'd appreciate if you can do so.

Thanks!
