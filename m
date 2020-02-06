Return-Path: <SRS0=cCuT=32=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7375EC33CAC
	for <netfilter-devel@archiver.kernel.org>; Thu,  6 Feb 2020 14:15:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4C4952082E
	for <netfilter-devel@archiver.kernel.org>; Thu,  6 Feb 2020 14:15:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728141AbgBFOPw (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 6 Feb 2020 09:15:52 -0500
Received: from a3.inai.de ([88.198.85.195]:52846 "EHLO a3.inai.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727481AbgBFOPw (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 6 Feb 2020 09:15:52 -0500
Received: by a3.inai.de (Postfix, from userid 25121)
        id F2AB25877E37B; Thu,  6 Feb 2020 15:15:50 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
        by a3.inai.de (Postfix) with ESMTP id EF65360D6A406;
        Thu,  6 Feb 2020 15:15:50 +0100 (CET)
Date:   Thu, 6 Feb 2020 15:15:50 +0100 (CET)
From:   Jan Engelhardt <jengelh@inai.de>
To:     jean-christophe manciot <actionmystique@gmail.com>
cc:     netfilter-devel@vger.kernel.org
Subject: Re: How to continue to use Maxmind geoip csv in xtables-addons
 3.8+
In-Reply-To: <CAKcFC3a_dpZEPUnyH_MNUrSpj+aeh=kT=QMV49-jrJMF6qRSWg@mail.gmail.com>
Message-ID: <nycvar.YFH.7.76.2002061515450.18928@n3.vanv.qr>
References: <CAKcFC3a_dpZEPUnyH_MNUrSpj+aeh=kT=QMV49-jrJMF6qRSWg@mail.gmail.com>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thursday 2020-02-06 12:19, jean-christophe manciot wrote:

>I have realized by digging within xt_geoip_build that the expected
>geoip provider has been changed from Maxmind to db-ip since 3.8-1
>(debian sid).
>
>This means that running xt_geoip_build with csv downloaded from
>Maxmind can no longer work.
>
>I am aware that Maxmind recently introduced "Significant Changes to
>Accessing and Using GeoLite2 Databases" and introduced a new end-user
>license agreement.
>
>However, is there a way to continue to use Maxmind geoip db with
>latest debian xtables-addons for people who detain the required
>license key in order to download GeoLite2 databases?

Just grab the old script from git.
