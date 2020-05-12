Return-Path: <SRS0=em6Q=62=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31A78C54E4A
	for <netfilter-devel@archiver.kernel.org>; Tue, 12 May 2020 09:30:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 037F0206A3
	for <netfilter-devel@archiver.kernel.org>; Tue, 12 May 2020 09:30:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728525AbgELJaU (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 12 May 2020 05:30:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726193AbgELJaU (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 12 May 2020 05:30:20 -0400
Received: from a3.inai.de (a3.inai.de [IPv6:2a01:4f8:10b:45d8::f5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55AD3C061A0C
        for <netfilter-devel@vger.kernel.org>; Tue, 12 May 2020 02:30:20 -0700 (PDT)
Received: by a3.inai.de (Postfix, from userid 25121)
        id D01A358725880; Tue, 12 May 2020 11:30:16 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by a3.inai.de (Postfix) with ESMTP id CF24F60D311F3;
        Tue, 12 May 2020 11:30:16 +0200 (CEST)
Date:   Tue, 12 May 2020 11:30:16 +0200 (CEST)
From:   Jan Engelhardt <jengelh@inai.de>
To:     Philip Prindeville <philipp@redfish-solutions.com>
cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH v1 1/1] xtables-addons: geoip: update scripts for DBIP
 names, etc.
In-Reply-To: <20200512002747.2108-1-philipp@redfish-solutions.com>
Message-ID: <nycvar.YFH.7.77.849.2005121118260.6562@n3.vanv.qr>
References: <20200512002747.2108-1-philipp@redfish-solutions.com>
User-Agent: Alpine 2.22 (LSU 394 2020-01-19)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


On Tuesday 2020-05-12 02:27, Philip Prindeville wrote:
>
>Also change the default destination directory to /usr/share/xt_geoip
>as most distros use this now.  Update the documentation.

This would break the current expectation that an unprivileged user,
using an unmodified incantation of the command, can run the program
and not run into a permission error.

Maybe there are some "nicer" approaches? I'm calling for further inspirations.

>-my $target_dir = ".";
>+my $target_dir = "/usr/share/xt_geoip";
