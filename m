Return-Path: <SRS0=CfkY=DQ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CFACEC433E7
	for <netfilter-devel@archiver.kernel.org>; Fri,  9 Oct 2020 10:24:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7E6C12226B
	for <netfilter-devel@archiver.kernel.org>; Fri,  9 Oct 2020 10:24:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387599AbgJIKYR (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 9 Oct 2020 06:24:17 -0400
Received: from mail.thelounge.net ([91.118.73.15]:19393 "EHLO
        mail.thelounge.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387598AbgJIKYQ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 9 Oct 2020 06:24:16 -0400
X-Greylist: delayed 971 seconds by postgrey-1.27 at vger.kernel.org; Fri, 09 Oct 2020 06:24:15 EDT
Received: from srv-rhsoft.rhsoft.net (rh.vpn.thelounge.net [10.10.10.2])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-256) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: h.reindl@thelounge.net)
        by mail.thelounge.net (THELOUNGE MTA) with ESMTPSA id 4C73fp59J6zXNf;
        Fri,  9 Oct 2020 12:07:57 +0200 (CEST)
Subject: Re: [iptables PATCH] iptables-nft: fix basechain policy configuration
To:     Phil Sutter <phil@nwl.cc>, Pablo Neira Ayuso <pablo@netfilter.org>,
        Arturo Borrero Gonzalez <arturo@netfilter.org>,
        netfilter-devel@vger.kernel.org, kadlec@netfilter.org
References: <160163907669.18523.7311010971070291883.stgit@endurance>
 <20201008173156.GA14654@salvia> <20201009082953.GD13016@orbyte.nwl.cc>
 <20201009085039.GB7851@salvia> <20201009093705.GF13016@orbyte.nwl.cc>
From:   Reindl Harald <h.reindl@thelounge.net>
Organization: the lounge interactive design
Message-ID: <0669e18b-661b-efec-fe15-e540290c3219@thelounge.net>
Date:   Fri, 9 Oct 2020 12:07:57 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.1
MIME-Version: 1.0
In-Reply-To: <20201009093705.GF13016@orbyte.nwl.cc>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org



Am 09.10.20 um 11:37 schrieb Phil Sutter:
> I guess fundamentally this is due to legacy design which keeps builtin
> chains in place at all times. We could copy that in iptables-nft, but I
> like the current design where we just delete the whole table and start
> from scratch.
> 
> Florian made a related remark a while ago about flushing chains with
> DROP policy: He claims it is almost always a mistake and we should reset
> the policy to ACCEPT in order to avoid people from locking themselves
> out. I second that idea, but am not sure if such a change is tolerable
> at all.
bad idea!

nothing is locking you out just because of a short drop phase, at least 
not over the past 12 years, that's what tcp retransmits are for

when you once accept i have someone which should never have been 
accepted in the conntracking - sorry - but when i say drop i literally 
mean drop at any point in time
