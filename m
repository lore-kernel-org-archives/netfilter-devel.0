Return-Path: <SRS0=tHxH=BH=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69030C433E5
	for <netfilter-devel@archiver.kernel.org>; Tue, 28 Jul 2020 17:24:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 536A120786
	for <netfilter-devel@archiver.kernel.org>; Tue, 28 Jul 2020 17:24:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731918AbgG1RYU (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 28 Jul 2020 13:24:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731684AbgG1RYT (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 28 Jul 2020 13:24:19 -0400
Received: from a3.inai.de (a3.inai.de [IPv6:2a01:4f8:10b:45d8::f5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50B35C061794
        for <netfilter-devel@vger.kernel.org>; Tue, 28 Jul 2020 10:24:19 -0700 (PDT)
Received: by a3.inai.de (Postfix, from userid 25121)
        id 2EEBB58767971; Tue, 28 Jul 2020 14:01:25 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by a3.inai.de (Postfix) with ESMTP id D4FD660C4AEA0;
        Tue, 28 Jul 2020 14:01:25 +0200 (CEST)
Date:   Tue, 28 Jul 2020 14:01:25 +0200 (CEST)
From:   Jan Engelhardt <jengelh@inai.de>
To:     Philip Prindeville <philipp@redfish-solutions.com>
cc:     netfilter-devel@vger.kernel.org
Subject: Xtables-addons 3.10 (Re: [PATCH 1/1] geoip: add quiet flag to
 xt_geoip_build)
In-Reply-To: <52068C27-7A75-4F28-8DE2-C13CF196E2B5@redfish-solutions.com>
Message-ID: <nycvar.YFH.7.77.849.2007281355020.19722@n3.vanv.qr>
References: <20200525200542.29000-1-philipp@redfish-solutions.com> <nycvar.YFH.7.77.849.2005261459250.6469@n3.vanv.qr> <52068C27-7A75-4F28-8DE2-C13CF196E2B5@redfish-solutions.com>
User-Agent: Alpine 2.22 (LSU 394 2020-01-19)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Sunday 2020-07-26 19:32, Philip Prindeville wrote:
>> On May 26, 2020, at 6:59 AM, Jan Engelhardt <jengelh@inai.de> wrote:
>> On Monday 2020-05-25 22:05, Philip Prindeville wrote:
>
>>> Conceivably someone might want to run a refresh of the geoip database
>>> from within a script, particularly an unattended script such as a cron
>>> job.  Don't generate output in that case.
>
>BTW, when is 3.10 due out?

I have tagged 3.10 and produced the tarballs.
Take note that the homepage etc. has moved to

	https://inai.de/projects/xtables-addons/

Downloads, new git location, and redirects from sf.net
should be all there.
