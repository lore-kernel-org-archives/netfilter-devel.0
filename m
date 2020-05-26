Return-Path: <SRS0=ickv=7I=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A126AC433DF
	for <netfilter-devel@archiver.kernel.org>; Tue, 26 May 2020 12:59:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 857C7204EF
	for <netfilter-devel@archiver.kernel.org>; Tue, 26 May 2020 12:59:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729000AbgEZM7c (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 26 May 2020 08:59:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726325AbgEZM7b (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 26 May 2020 08:59:31 -0400
Received: from a3.inai.de (a3.inai.de [IPv6:2a01:4f8:10b:45d8::f5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E9BBC03E96D
        for <netfilter-devel@vger.kernel.org>; Tue, 26 May 2020 05:59:31 -0700 (PDT)
Received: by a3.inai.de (Postfix, from userid 25121)
        id F06C4588E04E5; Tue, 26 May 2020 14:59:28 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by a3.inai.de (Postfix) with ESMTP id EF60F60D8EE37;
        Tue, 26 May 2020 14:59:28 +0200 (CEST)
Date:   Tue, 26 May 2020 14:59:28 +0200 (CEST)
From:   Jan Engelhardt <jengelh@inai.de>
To:     Philip Prindeville <philipp@redfish-solutions.com>
cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH 1/1] geoip: add quiet flag to xt_geoip_build
In-Reply-To: <20200525200542.29000-1-philipp@redfish-solutions.com>
Message-ID: <nycvar.YFH.7.77.849.2005261459250.6469@n3.vanv.qr>
References: <20200525200542.29000-1-philipp@redfish-solutions.com>
User-Agent: Alpine 2.22 (LSU 394 2020-01-19)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Monday 2020-05-25 22:05, Philip Prindeville wrote:

>From: Philip Prindeville <philipp@redfish-solutions.com>
>
>Conceivably someone might want to run a refresh of the geoip database
>from within a script, particularly an unattended script such as a cron
>job.  Don't generate output in that case.

added.
