Return-Path: <SRS0=IzLZ=RZ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F7CAC43381
	for <netfilter-devel@archiver.kernel.org>; Fri, 22 Mar 2019 13:31:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DD7282083D
	for <netfilter-devel@archiver.kernel.org>; Fri, 22 Mar 2019 13:31:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728832AbfCVNb0 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 22 Mar 2019 09:31:26 -0400
Received: from feynman.df7cb.de ([195.49.152.168]:45410 "EHLO feynman.df7cb.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728636AbfCVNbX (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 22 Mar 2019 09:31:23 -0400
X-Greylist: delayed 438 seconds by postgrey-1.27 at vger.kernel.org; Fri, 22 Mar 2019 09:31:23 EDT
Received: from msg.df7cb.de (unknown [IPv6:2003:5b:203b:100:7627:eaff:fe52:8e03])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by feynman.df7cb.de (Postfix) with ESMTPSA id 44Qkrb2Qxcz3F0Q;
        Fri, 22 Mar 2019 14:23:59 +0100 (CET)
Date:   Fri, 22 Mar 2019 14:23:59 +0100
From:   Christoph Berg <myon@debian.org>
To:     Jan Engelhardt <jengelh@inai.de>
Cc:     Arturo Borrero Gonzalez <arturo@netfilter.org>,
        netfilter-devel@vger.kernel.org, eric@regit.org,
        Chris Boot <bootc@debian.org>
Subject: Re: [PATCH] build: adjust configure for postgresql 11
Message-ID: <20190322132359.GC32388@msg.df7cb.de>
References: <20190321115456.24137-1-jengelh@inai.de>
 <a377fcf6-8940-34de-b1d6-0de07f10e046@netfilter.org>
 <nycvar.YFH.7.76.1903221354530.7557@n3.vanv.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <nycvar.YFH.7.76.1903221354530.7557@n3.vanv.qr>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Re: Jan Engelhardt 2019-03-22 <nycvar.YFH.7.76.1903221354530.7557@n3.vanv.qr>
> >> At least in openSUSE, PostgreSQL 11 no longer ships the pg_config
> >> program. Instead, there is has been a pkg-config file around for a
> >> while (also in pg10), so make use of that, by default.
> >
> >Debian ships pg_config. In fact, the same package libpq-dev [0] contains both
> >things:
> >
> >* /usr/bin/pg_config
> >* /usr/lib/x86_64-linux-gnu/pkgconfig/libpq.pc
> 
> pg_config is regarded for the server part only, says the respective maintainer.
> https://bugzilla.opensuse.org/show_bug.cgi?id=1120035#c1

That is wishful thinking. It would be nice if all client-side
applications would use pkg-config to interface to libpq, but state of
things is still that pg_config is used by many (most?) of them. That
choice tries to force everyone to switch. If openSUSE wants to fight
that fight, good luck.

`pg_config --libs` should not be used for linking client-side apps.
Thats an artifact from server-side linking.

Christoph
