Return-Path: <SRS0=mmGa=IG=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.4 required=3.0 tests=BAYES_00,FORGED_MUA_MOZILLA,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5DDFDC433DB
	for <netfilter-devel@archiver.kernel.org>; Mon,  8 Mar 2021 10:26:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 370F36512C
	for <netfilter-devel@archiver.kernel.org>; Mon,  8 Mar 2021 10:26:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230039AbhCHKZg (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 8 Mar 2021 05:25:36 -0500
Received: from correo.us.es ([193.147.175.20]:45042 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229458AbhCHKZX (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 8 Mar 2021 05:25:23 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 31907FC378
        for <netfilter-devel@vger.kernel.org>; Mon,  8 Mar 2021 11:25:13 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 1E7ACDA78F
        for <netfilter-devel@vger.kernel.org>; Mon,  8 Mar 2021 11:25:13 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 1380EDA78B; Mon,  8 Mar 2021 11:25:13 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B841BDA794;
        Mon,  8 Mar 2021 11:25:10 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 08 Mar 2021 11:25:10 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 9D6D142DF560;
        Mon,  8 Mar 2021 11:25:10 +0100 (CET)
Date:   Mon, 8 Mar 2021 11:25:10 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Marc =?utf-8?Q?Aur=C3=A8le?= La France <tsi@tuyoix.net>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf] netfilter REJECT: Fix destination MAC in RST packets
Message-ID: <20210308102510.GA23497@salvia>
References: <alpine.LNX.2.20.2103071736460.15162@fanir.tuyoix.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <alpine.LNX.2.20.2103071736460.15162@fanir.tuyoix.net>
User-Agent: Mozilla/5.0
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Sun, Mar 07, 2021 at 06:16:34PM -0700, Marc Aurèle La France wrote:
> In the non-bridge case, the REJECT target code assumes the REJECTed
> packets were originally emitted by the local host, but that's not
> necessarily true when the local host is the default route of a subnet
> it is on, resulting in RST packets being sent out with an incorrect
> destination MAC.  Address this by refactoring the handling of bridged
> packets which deals with a similar issue.  Modulo patch fuzz, the
> following applies to v5 and later kernels.

The code this patch updates is related to BRIDGE_NETFILTER. Your patch
description refers to the non-bridge case. What are you trying to
achieve?

dev_queue_xmit() path should not be exercised from the prerouting
chain, packets generated from the IP later must follow the
ip_local_out() path.
