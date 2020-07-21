Return-Path: <SRS0=0X8Q=BA=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10708C433DF
	for <netfilter-devel@archiver.kernel.org>; Tue, 21 Jul 2020 09:16:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E5AE220792
	for <netfilter-devel@archiver.kernel.org>; Tue, 21 Jul 2020 09:16:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728109AbgGUJQD (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 21 Jul 2020 05:16:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726928AbgGUJQD (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 21 Jul 2020 05:16:03 -0400
Received: from a3.inai.de (a3.inai.de [IPv6:2a01:4f8:10b:45d8::f5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06FEFC061794
        for <netfilter-devel@vger.kernel.org>; Tue, 21 Jul 2020 02:16:03 -0700 (PDT)
Received: by a3.inai.de (Postfix, from userid 25121)
        id 8688E59B99E83; Tue, 21 Jul 2020 11:16:00 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by a3.inai.de (Postfix) with ESMTP id 834D660C4008F;
        Tue, 21 Jul 2020 11:16:00 +0200 (CEST)
Date:   Tue, 21 Jul 2020 11:16:00 +0200 (CEST)
From:   Jan Engelhardt <jengelh@inai.de>
To:     Jeremy Sowden <jeremy@azazel.net>
cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH xtables-addons] doc: fix quoted string in libxt_DNETMAP
 man-page.
In-Reply-To: <20200721083136.710735-1-jeremy@azazel.net>
Message-ID: <nycvar.YFH.7.77.849.2007211114060.23166@n3.vanv.qr>
References: <20200721083136.710735-1-jeremy@azazel.net>
User-Agent: Alpine 2.22 (LSU 394 2020-01-19)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tuesday 2020-07-21 10:31, Jeremy Sowden wrote:

>In roff, lines beginning with a single quote are control lines.  In the
>libxt_DNETMAP man-page there is a single-quoted string at the beginning
>of a line, which troff tries and fails to interpret as a macro:

Is there some escaping magic available that would make this work as 
well? I would fear that if the next person (me included) comes around 
to use an editor's "wrap at 80 cols" feature, that the quote might 
re-shift to the start of line. If all else, I'd just pick " over ' - in 
the hope that that does not have a special meaning.

>-boot time). Please note that the \fBttl\fR and \fBlasthit\fR entries contain an
>-'\fBS\fR' in case of a static binding.
>+boot time). Please note that the \fBttl\fR and \fBlasthit\fR entries contain
>+an '\fBS\fR' in case of a static binding.
