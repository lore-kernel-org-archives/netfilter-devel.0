Return-Path: <SRS0=oAJK=BK=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2106C433DF
	for <netfilter-devel@archiver.kernel.org>; Fri, 31 Jul 2020 17:30:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7810320829
	for <netfilter-devel@archiver.kernel.org>; Fri, 31 Jul 2020 17:30:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733019AbgGaRad (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 31 Jul 2020 13:30:33 -0400
Received: from correo.us.es ([193.147.175.20]:38058 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732970AbgGaRac (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 31 Jul 2020 13:30:32 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id D693FDA70F
        for <netfilter-devel@vger.kernel.org>; Fri, 31 Jul 2020 19:30:30 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id C74B9DA850
        for <netfilter-devel@vger.kernel.org>; Fri, 31 Jul 2020 19:30:30 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id BCD3FDA844; Fri, 31 Jul 2020 19:30:30 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id AE11CDA722;
        Fri, 31 Jul 2020 19:30:28 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 31 Jul 2020 19:30:28 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 8E9714265A2F;
        Fri, 31 Jul 2020 19:30:28 +0200 (CEST)
Date:   Fri, 31 Jul 2020 19:30:28 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Phil Sutter <phil@nwl.cc>,
        "Jose M. Guisado Gomez" <guigom@riseup.net>,
        netfilter-devel@vger.kernel.org, Eric Garver <erig@erig.me>
Subject: Re: [PATCH nft v2 1/1] src: enable output with "nft --echo --json"
 and nftables syntax
Message-ID: <20200731173028.GA16302@salvia>
References: <20200730195337.3627-1-guigom@riseup.net>
 <20200731000020.4230-2-guigom@riseup.net>
 <20200731092212.GA1850@salvia>
 <20200731123342.GF13697@orbyte.nwl.cc>
 <20200731125825.GA12545@salvia>
 <20200731134828.GG13697@orbyte.nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200731134828.GG13697@orbyte.nwl.cc>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, Jul 31, 2020 at 03:48:28PM +0200, Phil Sutter wrote:
> On Fri, Jul 31, 2020 at 02:58:25PM +0200, Pablo Neira Ayuso wrote:
> > On Fri, Jul 31, 2020 at 02:33:42PM +0200, Phil Sutter wrote:
[...]
> The less predictable echo output behaves, the harder it is to write code
> that makes use of it.

What is it making the output less predictible? The kernel should
return an input that is equal to the output plus the handle. Other
than that, it's a bug.

This is also saving quite a bit of code and streamlining this further:

 4 files changed, 49 insertions(+), 153 deletions(-)
