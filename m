Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F2C0C433EF
	for <netfilter-devel@archiver.kernel.org>; Wed, 30 Mar 2022 18:42:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243182AbiC3Smt (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 30 Mar 2022 14:42:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350439AbiC3SmY (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 30 Mar 2022 14:42:24 -0400
Received: from a3.inai.de (a3.inai.de [IPv6:2a01:4f8:10b:45d8::f5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E1E07CB23
        for <netfilter-devel@vger.kernel.org>; Wed, 30 Mar 2022 11:38:30 -0700 (PDT)
Received: by a3.inai.de (Postfix, from userid 25121)
        id 38193588F5214; Wed, 30 Mar 2022 20:38:28 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by a3.inai.de (Postfix) with ESMTP id 3786E60D4061A;
        Wed, 30 Mar 2022 20:38:28 +0200 (CEST)
Date:   Wed, 30 Mar 2022 20:38:28 +0200 (CEST)
From:   Jan Engelhardt <jengelh@inai.de>
To:     Phil Sutter <phil@nwl.cc>
cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
Subject: Re: [iptables PATCH 9/9] extensions: DNAT: Support service names in
 all spots
In-Reply-To: <20220330155851.13249-10-phil@nwl.cc>
Message-ID: <89qp85o0-704s-5280-sqp6-s71so14n7487@vanv.qr>
References: <20220330155851.13249-1-phil@nwl.cc> <20220330155851.13249-10-phil@nwl.cc>
User-Agent: Alpine 2.25 (LSU 592 2021-09-18)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


On Wednesday 2022-03-30 17:58, Phil Sutter wrote:

>When parsing (parts of) a port spec, if it doesn't start with a digit,
>try to find the largest substring getservbyname() accepts.

> -p tcp -j DNAT --to-destination 1.1.1.1:1000-2000/65536;;FAIL
> -p tcp -j DNAT --to-destination 1.1.1.1:ssh;-p tcp -j DNAT --to-destination 1.1.1.1:22;OK
> -p tcp -j DNAT --to-destination 1.1.1.1:ftp-data;-p tcp -j DNAT --to-destination 1.1.1.1:20;OK
>+-p tcp -j DNAT --to-destination 1.1.1.1:ftp-data-ssh;-p tcp -j DNAT --to-destination 1.1.1.1:20-22;OK
>+-p tcp -j DNAT --to-destination 1.1.1.1:echo-ftp-data;-p tcp -j DNAT --to-destination 1.1.1.1:7-20;OK
>+-p tcp -j DNAT --to-destination 1.1.1.1:ftp-data-ssh/echo;-p tcp -j DNAT --to-destination 1.1.1.1:20-22/7;OK
>+-p tcp -j DNAT --to-destination 1.1.1.1:echo-ftp-data/ssh;-p tcp -j DNAT --to-destination 1.1.1.1:7-20/22;OK
> -j DNAT;;FAIL

This looks dangerous. It is why I originally never allowed service names in
port ranges that use dash as the range character. a-b-c could mean a..b-c
today, and could mean a-b..c tomorrow, either because someone managed to
inject a-b into the service list.

The "solution" would be to use : as the range character, but that would require
a new --dport option for reasons of command-line compatibility.
