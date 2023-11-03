Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA091C4332F
	for <netfilter-devel@archiver.kernel.org>; Fri,  3 Nov 2023 12:11:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344688AbjKCMLk (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 3 Nov 2023 08:11:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346442AbjKCMLj (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 3 Nov 2023 08:11:39 -0400
Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [IPv6:2001:780:45:1d:225:90ff:fe52:c662])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52476A2
        for <netfilter-devel@vger.kernel.org>; Fri,  3 Nov 2023 05:11:37 -0700 (PDT)
Received: from [78.30.35.151] (port=42908 helo=gnumonks.org)
        by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <pablo@gnumonks.org>)
        id 1qyt1R-00Emi8-FT; Fri, 03 Nov 2023 13:11:35 +0100
Date:   Fri, 3 Nov 2023 13:11:32 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Phil Sutter <phil@nwl.cc>,
        Arturo Borrero Gonzalez <arturo@debian.org>,
        Jeremy Sowden <jeremy@azazel.net>,
        netfilter-devel@vger.kernel.org, fw@strlen.de
Subject: Re: [RFC] nftables 1.0.6 -stable backports
Message-ID: <ZUTjdO8IwJkR/ZQj@calendula>
References: <ZTE8xaZfFJoQRhjY@calendula>
 <ZTFJ4yXd7nZxjAJz@orbyte.nwl.cc>
 <ZUOJNnKJRKwj379J@calendula>
 <ZUOVrlIgCSIM8Ule@orbyte.nwl.cc>
 <ZUQTWSEXbw2paJ3v@calendula>
 <ZUTEfXMw2e5kMJ5A@orbyte.nwl.cc>
 <ZUTPG3XsdIFu8RRb@orbyte.nwl.cc>
 <ZUTQOqAS9EvI6/jV@calendula>
 <ZUTR9EAJZGhNfDa6@orbyte.nwl.cc>
 <ZUTZiB8xC1pVn+mn@calendula>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ZUTZiB8xC1pVn+mn@calendula>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

I have refreshed 1.0.6.y branch.
