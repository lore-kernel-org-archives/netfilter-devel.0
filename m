Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D0F2C433E0
	for <netfilter-devel@archiver.kernel.org>; Wed, 27 Jan 2021 13:44:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A911D207B0
	for <netfilter-devel@archiver.kernel.org>; Wed, 27 Jan 2021 13:44:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231461AbhA0NoO (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 27 Jan 2021 08:44:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231591AbhA0Nn7 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 27 Jan 2021 08:43:59 -0500
Received: from smtp-out.kfki.hu (smtp-out.kfki.hu [IPv6:2001:738:5001::46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E907EC061574
        for <netfilter-devel@vger.kernel.org>; Wed, 27 Jan 2021 05:43:18 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
        by smtp1.kfki.hu (Postfix) with ESMTP id 4CEAC3C801EF;
        Wed, 27 Jan 2021 14:43:17 +0100 (CET)
X-Virus-Scanned: Debian amavisd-new at smtp1.kfki.hu
Received: from smtp1.kfki.hu ([127.0.0.1])
        by localhost (smtp1.kfki.hu [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP; Wed, 27 Jan 2021 14:43:12 +0100 (CET)
Received: from blackhole.kfki.hu (blackhole.kfki.hu [148.6.240.2])
        by smtp1.kfki.hu (Postfix) with ESMTP id B41F73C801CB;
        Wed, 27 Jan 2021 14:43:12 +0100 (CET)
Received: by blackhole.kfki.hu (Postfix, from userid 1000)
        id AB314340D5D; Wed, 27 Jan 2021 14:43:12 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
        by blackhole.kfki.hu (Postfix) with ESMTP id A6F58340D5C;
        Wed, 27 Jan 2021 14:43:12 +0100 (CET)
Date:   Wed, 27 Jan 2021 14:43:12 +0100 (CET)
From:   Jozsef Kadlecsik <kadlec@netfilter.org>
X-X-Sender: kadlec@blackhole.kfki.hu
To:     Reindl Harald <h.reindl@thelounge.net>
cc:     netfilter-devel@vger.kernel.org
Subject: Re: https://bugzilla.kernel.org/show_bug.cgi?id=207773
In-Reply-To: <80fb46c6-6061-6a5b-b64e-a661600a4c9f@thelounge.net>
Message-ID: <alpine.DEB.2.23.453.2101271441570.11052@blackhole.kfki.hu>
References: <9ab32341-ca2f-22e2-0cb0-7ab55198ab80@thelounge.net> <alpine.DEB.2.23.453.2101271435390.11052@blackhole.kfki.hu> <80fb46c6-6061-6a5b-b64e-a661600a4c9f@thelounge.net>
User-Agent: Alpine 2.23 (DEB 453 2020-06-18)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, 27 Jan 2021, Reindl Harald wrote:

> Am 27.01.21 um 14:38 schrieb Jozsef Kadlecsik:
> > 
> > On Wed, 27 Jan 2021, Reindl Harald wrote:
> > 
> > > for the sake of god may someone look at this?
> > > https://bugzilla.kernel.org/show_bug.cgi?id=207773
> > 
> > Could you send your iptables rules and at least the set definitions
> > without the set contents? I need to reproduce the issue.
> 
> is offlist OK? that's the companies "datacenter firewall"

That's OK and private data remains private.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.hu
PGP key : https://wigner.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics
          H-1525 Budapest 114, POB. 49, Hungary
