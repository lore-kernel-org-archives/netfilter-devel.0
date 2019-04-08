Return-Path: <SRS0=Xgm7=SK=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 409D4C10F13
	for <netfilter-devel@archiver.kernel.org>; Mon,  8 Apr 2019 21:43:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1932B21841
	for <netfilter-devel@archiver.kernel.org>; Mon,  8 Apr 2019 21:43:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727233AbfDHVnW (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 8 Apr 2019 17:43:22 -0400
Received: from mail.us.es ([193.147.175.20]:46728 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727133AbfDHVnV (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 8 Apr 2019 17:43:21 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id E03EC303D17
        for <netfilter-devel@vger.kernel.org>; Mon,  8 Apr 2019 23:43:19 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id CCD6DDA70B
        for <netfilter-devel@vger.kernel.org>; Mon,  8 Apr 2019 23:43:19 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id C26BEDA706; Mon,  8 Apr 2019 23:43:19 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 72663DA701;
        Mon,  8 Apr 2019 23:43:17 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 08 Apr 2019 23:43:17 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 4BB844265A31;
        Mon,  8 Apr 2019 23:43:17 +0200 (CEST)
Date:   Mon, 8 Apr 2019 23:43:16 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Christoph Berg <myon@debian.org>
Cc:     Jan Engelhardt <jengelh@inai.de>,
        Arturo Borrero Gonzalez <arturo@netfilter.org>,
        netfilter-devel@vger.kernel.org, eric@regit.org,
        Chris Boot <bootc@debian.org>
Subject: Re: [PATCH] build: adjust configure for postgresql 11
Message-ID: <20190408214316.7cgiptnfdtnootta@salvia>
References: <20190321115456.24137-1-jengelh@inai.de>
 <a377fcf6-8940-34de-b1d6-0de07f10e046@netfilter.org>
 <nycvar.YFH.7.76.1903221354530.7557@n3.vanv.qr>
 <20190322132359.GC32388@msg.df7cb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190322132359.GC32388@msg.df7cb.de>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Christoph,

On Fri, Mar 22, 2019 at 02:23:59PM +0100, Christoph Berg wrote:
> Re: Jan Engelhardt 2019-03-22 <nycvar.YFH.7.76.1903221354530.7557@n3.vanv.qr>
> > >> At least in openSUSE, PostgreSQL 11 no longer ships the pg_config
> > >> program. Instead, there is has been a pkg-config file around for a
> > >> while (also in pg10), so make use of that, by default.
> > >
> > >Debian ships pg_config. In fact, the same package libpq-dev [0] contains both
> > >things:
> > >
> > >* /usr/bin/pg_config
> > >* /usr/lib/x86_64-linux-gnu/pkgconfig/libpq.pc
> > 
> > pg_config is regarded for the server part only, says the respective maintainer.
> > https://bugzilla.opensuse.org/show_bug.cgi?id=1120035#c1
> 
> That is wishful thinking. It would be nice if all client-side
> applications would use pkg-config to interface to libpq, but state of
> things is still that pg_config is used by many (most?) of them. That
> choice tries to force everyone to switch. If openSUSE wants to fight
> that fight, good luck.
> 
> `pg_config --libs` should not be used for linking client-side apps.
> Thats an artifact from server-side linking.

Any objection then OK with this patch? Not an pg expert here.

Thanks.
