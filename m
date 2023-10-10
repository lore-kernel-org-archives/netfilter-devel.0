Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 583F9CD80B7
	for <netfilter-devel@archiver.kernel.org>; Tue, 10 Oct 2023 11:53:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231423AbjJJLx5 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 10 Oct 2023 07:53:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230122AbjJJLx4 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 10 Oct 2023 07:53:56 -0400
Received: from a3.inai.de (a3.inai.de [IPv6:2a01:4f8:10b:45d8::f5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3104B4
        for <netfilter-devel@vger.kernel.org>; Tue, 10 Oct 2023 04:53:53 -0700 (PDT)
Received: by a3.inai.de (Postfix, from userid 25121)
        id 55FCF58AD6378; Tue, 10 Oct 2023 13:53:52 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by a3.inai.de (Postfix) with ESMTP id 5399D60E0BD5E;
        Tue, 10 Oct 2023 13:53:52 +0200 (CEST)
Date:   Tue, 10 Oct 2023 13:53:52 +0200 (CEST)
From:   Jan Engelhardt <jengelh@inai.de>
To:     Phil Sutter <phil@nwl.cc>
cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Arturo Borrero Gonzalez <arturo@debian.org>,
        Jeremy Sowden <jeremy@azazel.net>,
        netfilter-devel@vger.kernel.org
Subject: Re: [RFC] nftables 1.0.6 -stable backports
In-Reply-To: <ZSUNswK5nSC0IUvS@orbyte.nwl.cc>
Message-ID: <461n251o-75p0-2o1p-25n3-32r35psp0091@vanv.qr>
References: <ZSPZiekbEmjDfIF2@calendula> <e11f0179-6738-4b6f-8238-585fffad9a57@debian.org> <20231009111543.GB27648@breakpoint.cc> <ZSPm7SQhO/ziVMaw@calendula> <ZSUNswK5nSC0IUvS@orbyte.nwl.cc>
User-Agent: Alpine 2.26 (LSU 649 2022-06-02)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


On Tuesday 2023-10-10 10:39, Phil Sutter wrote:
>On Mon, Oct 09, 2023 at 01:41:33PM +0200, Pablo Neira Ayuso wrote:
>> 
>> Only one thing: I just wonder if this new 4 numbers scheme might
>> create confusion, as there will be release with 3 numbers and -stable
>> releases with 4 numbers.
>
>An upcoming 1.0.9 might be a good chance to switch upstream numbering
>scheme

Confusion, no. But the version numbers certainly suffer from ossification. The
1. prefix has been since over 20 years. It's like https://0ver.org/, just
offset by one. The kernel has ditched its ossified prefix (2.6.) over ten years
ago as well.

Speaking of 0ver (and reading past the sarcasm), it's time to move off 0.
for e.g. libconntrack*, conntrack-tools et al.
