Return-Path: <SRS0=gJ4i=6M=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA67DC83004
	for <netfilter-devel@archiver.kernel.org>; Tue, 28 Apr 2020 22:30:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BDC69206F0
	for <netfilter-devel@archiver.kernel.org>; Tue, 28 Apr 2020 22:30:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726662AbgD1WaL (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 28 Apr 2020 18:30:11 -0400
Received: from correo.us.es ([193.147.175.20]:60540 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725934AbgD1WaL (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 28 Apr 2020 18:30:11 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id EAB1311EB3B
        for <netfilter-devel@vger.kernel.org>; Wed, 29 Apr 2020 00:30:08 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id DB1E5BAAA3
        for <netfilter-devel@vger.kernel.org>; Wed, 29 Apr 2020 00:30:08 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id D0A6820670; Wed, 29 Apr 2020 00:30:08 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id EE64CBAAAF;
        Wed, 29 Apr 2020 00:30:06 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 29 Apr 2020 00:30:06 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id D134142EF4E1;
        Wed, 29 Apr 2020 00:30:06 +0200 (CEST)
Date:   Wed, 29 Apr 2020 00:30:06 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Maciej =?utf-8?Q?=C5=BBenczykowski?= <zenczykowski@gmail.com>
Cc:     Florian Westphal <fw@strlen.de>,
        Linux Network Development Mailing List 
        <netdev@vger.kernel.org>,
        Netfilter Development Mailing List 
        <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH] iptables: flush stdout after every verbose log.
Message-ID: <20200428223006.GA30304@salvia>
References: <20200421081542.108296-1-zenczykowski@gmail.com>
 <20200428000525.GD24002@salvia>
 <CAHo-OoxP6ZrvbXFH_tC9_wdVDg7y=8bzVY9oKZTieZL_mqS1NQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAHo-OoxP6ZrvbXFH_tC9_wdVDg7y=8bzVY9oKZTieZL_mqS1NQ@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, Apr 27, 2020 at 05:14:24PM -0700, Maciej Żenczykowski wrote:
> > Could you check if this slows down iptables-restore?
> 
> per the iptables-restore man page
>        -v, --verbose
>               Print additional debug info during ruleset processing.
> 
> Well, if you run it with verbose mode enabled you probably don't care
> about performance all that much...

Thanks for explaining.

How long has this been broken? I mean, netd has been there for quite a
while interacting with iptables. However, the existing behaviour was
not a problem? Or a recent bug?
