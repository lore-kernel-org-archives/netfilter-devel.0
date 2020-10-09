Return-Path: <SRS0=CfkY=DQ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78938C433E7
	for <netfilter-devel@archiver.kernel.org>; Fri,  9 Oct 2020 10:28:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2A06D2226B
	for <netfilter-devel@archiver.kernel.org>; Fri,  9 Oct 2020 10:28:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730763AbgJIK2e (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 9 Oct 2020 06:28:34 -0400
Received: from mail.thelounge.net ([91.118.73.15]:62595 "EHLO
        mail.thelounge.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725979AbgJIK2e (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 9 Oct 2020 06:28:34 -0400
Received: from srv-rhsoft.rhsoft.net (rh.vpn.thelounge.net [10.10.10.2])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-256))
        (No client certificate requested)
        (Authenticated sender: h.reindl@thelounge.net)
        by mail.thelounge.net (THELOUNGE MTA) with ESMTPSA id 4C746S1Y0rzXNf;
        Fri,  9 Oct 2020 12:28:32 +0200 (CEST)
To:     Phil Sutter <phil@nwl.cc>, Pablo Neira Ayuso <pablo@netfilter.org>,
        Arturo Borrero Gonzalez <arturo@netfilter.org>,
        netfilter-devel@vger.kernel.org, kadlec@netfilter.org
References: <160163907669.18523.7311010971070291883.stgit@endurance>
 <20201008173156.GA14654@salvia> <20201009082953.GD13016@orbyte.nwl.cc>
 <20201009085039.GB7851@salvia> <20201009093705.GF13016@orbyte.nwl.cc>
 <0669e18b-661b-efec-fe15-e540290c3219@thelounge.net>
 <20201009101458.GG13016@orbyte.nwl.cc>
From:   Reindl Harald <h.reindl@thelounge.net>
Organization: the lounge interactive design
Subject: Re: [iptables PATCH] iptables-nft: fix basechain policy configuration
Message-ID: <ecae4550-d4c7-433d-dedf-7a64cf1a3c5a@thelounge.net>
Date:   Fri, 9 Oct 2020 12:28:31 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.1
MIME-Version: 1.0
In-Reply-To: <20201009101458.GG13016@orbyte.nwl.cc>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org



Am 09.10.20 um 12:14 schrieb Phil Sutter:
> Hi Harald,
> 
> On Fri, Oct 09, 2020 at 12:07:57PM +0200, Reindl Harald wrote:
>> Am 09.10.20 um 11:37 schrieb Phil Sutter:
>>> I guess fundamentally this is due to legacy design which keeps builtin
>>> chains in place at all times. We could copy that in iptables-nft, but I
>>> like the current design where we just delete the whole table and start
>>> from scratch.
>>>
>>> Florian made a related remark a while ago about flushing chains with
>>> DROP policy: He claims it is almost always a mistake and we should reset
>>> the policy to ACCEPT in order to avoid people from locking themselves
>>> out. I second that idea, but am not sure if such a change is tolerable
>>> at all.
>> bad idea!
> 
> Why?

because in doubt you always to be packets dropped

>> nothing is locking you out just because of a short drop phase, at least
>> not over the past 12 years, that's what tcp retransmits are for
> 
> What I had in mind was 'ssh somehost iptables -F INPUT'.

when someone shoots you with so much passion in the foot let him

nobody does that without a script which will simply come back du 
tcp-retransmit and it's prettfy fine that after a flush DROP is the 
default policy

a default of ACCEPT for INPUT is crazy

>> when you once accept i have someone which should never have been
>> accepted in the conntracking - sorry - but when i say drop i literally
>> mean drop at any point in time
> 
> My English language parser failed this part, sorry. :)

accepting one unwanted packet leads in "ctstate RELATED,ESTABLISHED" 
triggering later no matter if you fix the policy afterwards
