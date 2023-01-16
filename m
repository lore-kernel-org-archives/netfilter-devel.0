Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D382C54EBE
	for <netfilter-devel@archiver.kernel.org>; Mon, 16 Jan 2023 17:42:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235072AbjAPRm0 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 16 Jan 2023 12:42:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235043AbjAPRmJ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 16 Jan 2023 12:42:09 -0500
Received: from a3.inai.de (a3.inai.de [IPv6:2a01:4f8:10b:45d8::f5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7402845203
        for <netfilter-devel@vger.kernel.org>; Mon, 16 Jan 2023 09:18:36 -0800 (PST)
Received: by a3.inai.de (Postfix, from userid 25121)
        id 126025880F78C; Mon, 16 Jan 2023 18:18:34 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
        by a3.inai.de (Postfix) with ESMTP id 11BEB60EA15B6;
        Mon, 16 Jan 2023 18:18:34 +0100 (CET)
Date:   Mon, 16 Jan 2023 18:18:34 +0100 (CET)
From:   Jan Engelhardt <jengelh@inai.de>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
cc:     Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org,
        Arturo Borrero Gonzalez <arturo@netfilter.org>
Subject: Re: [PATCH] build: put xtables.conf in EXTRA_DIST
In-Reply-To: <Y8U7wlJxOvWK7Vpw@salvia>
Message-ID: <r841n676-q68o-son2-s819-8p95s57rn8@vanv.qr>
References: <20230112225517.31560-1-jengelh@inai.de> <Y8FE0vEvtZhY6LCv@orbyte.nwl.cc> <Y8U7wlJxOvWK7Vpw@salvia>
User-Agent: Alpine 2.25 (LSU 592 2021-09-18)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


On Monday 2023-01-16 12:57, Pablo Neira Ayuso wrote:
>On Fri, Jan 13, 2023 at 12:47:30PM +0100, Phil Sutter wrote:
>
>IIRC ebtables is using a custom ethertype file, because definitions
>are different there.
>
>But is this installed file used in any way these days?

Probably not; the version I have has this to say:

# This list could be found on:
#         http://www.iana.org/assignments/ethernet-numbers
#         http://www.iana.org/assignments/ieee-802-numbers

With such official-ness, ebtables's ethertypes has a rather low priority.
