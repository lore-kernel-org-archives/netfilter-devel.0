Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03151C433E0
	for <netfilter-devel@archiver.kernel.org>; Thu, 11 Mar 2021 03:40:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C995064FB8
	for <netfilter-devel@archiver.kernel.org>; Thu, 11 Mar 2021 03:40:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230397AbhCKDjw (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 10 Mar 2021 22:39:52 -0500
Received: from smtp-out-no.shaw.ca ([64.59.134.12]:34748 "EHLO
        smtp-out-no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230346AbhCKDjr (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 10 Mar 2021 22:39:47 -0500
Received: from fanir.tuyoix.net ([68.150.218.192])
        by shaw.ca with ESMTP
        id KCAslx8A52SWTKCAtlQltv; Wed, 10 Mar 2021 20:39:47 -0700
X-Authority-Analysis: v=2.4 cv=fdJod2cF c=1 sm=1 tr=0 ts=60499103
 a=LfNn7serMq+1bQZBlMsSfQ==:117 a=LfNn7serMq+1bQZBlMsSfQ==:17
 a=dESyimp9J3IA:10 a=M51BFTxLslgA:10 a=nlC_4_pT8q9DhB4Ho9EA:9
 a=JsWhZaN1S4tDNjAKWpUA:9 a=QEXdDO2ut3YA:10
Received: from CLUIJ (cluij.tuyoix.net [192.168.144.15])
        (authenticated bits=0)
        by fanir.tuyoix.net (8.15.2/8.15.2) with ESMTPSA id 12B3djYh009650
        (version=TLSv1 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO);
        Wed, 10 Mar 2021 20:39:46 -0700
Date:   Wed, 10 Mar 2021 20:39:44 -0700 (Mountain Standard Time)
From:   =?UTF-8?Q?Marc_Aur=C3=A8le_La_France?= <tsi@tuyoix.net>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf] netfilter REJECT: Fix destination MAC in RST
 packets
In-Reply-To: <20210311000212.GA21480@salvia>
Message-ID: <alpine.WNT.2.20.2103102037030.2800@CLUIJ>
References: <alpine.LNX.2.20.2103071736460.15162@fanir.tuyoix.net> <20210308102510.GA23497@salvia> <alpine.WNT.2.20.2103080908550.2772@CLUIJ> <20210309013621.GA27206@salvia> <alpine.WNT.2.20.2103082114130.1604@CLUIJ> <20210309102740.GA30899@salvia>
 <alpine.WNT.2.20.2103101640090.3708@CLUIJ> <20210311000212.GA21480@salvia>
User-Agent: Alpine 2.20 (WNT 67 2015-01-07)
MIME-Version: 1.0
Content-Type: multipart/mixed; BOUNDARY="244749-10899-1615433984=:2800"
X-CMAE-Envelope: MS4xfNBc5n49S8W/bm2Z2uhPBkGiJXCFKtRif+GH454s0GavP+OtaGYETzAmMUer48x/e+Y2oA2Igppq4wwaok/mnyjXmOr3VOpp1cZSP0p3NBC82+g+ywqW
 HQElGABygQyRFH/RTN5ZJTq8pgyzxG5QM96qgFt98u/u3CC1e/FJ/tKw8AmVSSyPpfEkc0y0DOWX5mGHiFq/eWC3RxUYxakFcDbpEkWOCQIknsgmImEjDR3N
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--244749-10899-1615433984=:2800
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8BIT

On Thu, 11 Mar 2021, Pablo Neira Ayuso wrote:
> On Wed, Mar 10, 2021 at 04:51:26PM -0700, Marc Aurèle La France wrote:
>> On Tue, 9 Mar 2021, Pablo Neira Ayuso wrote:
>>> On Mon, Mar 08, 2021 at 09:25:28PM -0700, Marc Aurèle La France wrote:
>>>> On Tue, 9 Mar 2021, Pablo Neira Ayuso wrote:
>>>>> On Mon, Mar 08, 2021 at 09:21:20AM -0700, Marc Aurèle La France wrote:
>>>>>> On Mon, 8 Mar 2021, Pablo Neira Ayuso wrote:
>>>>>>> On Sun, Mar 07, 2021 at 06:16:34PM -0700, Marc Aurèle La France wrote:
>>>>>>>> In the non-bridge case, the REJECT target code assumes the REJECTed
>>>>>>>> packets were originally emitted by the local host, but that's not
>>>>>>>> necessarily true when the local host is the default route of a subnet
>>>>>>>> it is on, resulting in RST packets being sent out with an incorrect
>>>>>>>> destination MAC.  Address this by refactoring the handling of bridged
>>>>>>>> packets which deals with a similar issue.  Modulo patch fuzz, the
>>>>>>>> following applies to v5 and later kernels.

>>>>>>> The code this patch updates is related to BRIDGE_NETFILTER. Your patch
>>>>>>> description refers to the non-bridge case. What are you trying to
>>>>>>> achieve?

>>>>>> Via DHCP, my subnet's default route is a Linux system so that it can monitor
>>>>>> all outbound traffic.  By doing so, for example, I have determined that my
>>>>>> Android phone connects to Facebook despite the fact that I have no such app
>>>>>> installed.  I want to know, and control, what other behind-the-scenes
>>>>>> (under-handed) traffic devices on my subnet generate.

>>>>>>> dev_queue_xmit() path should not be exercised from the prerouting
>>>>>>> chain, packets generated from the IP later must follow the
>>>>>>> ip_local_out() path.

>>>>>> Well, I can tell you dev_queue_xmit() does in fact work in prerouting
>>>>>> chains, as it must for the bridging case.  The only potential problem I've
>>>>>> found so far is that the RST packet doesn't go through any netfilter hooks.

>>>>> That's the issue, Netfilter rejects code from the IP layer, so the
>>>>> packets follows the ip_local_out() path.

>>>> ... which sets an incorrect destination MAC.  Also, in this case, netfilter
>>>> doesn't reject any such thing.  It doesn't even "see" the RST packet
>>>> dev_queue_xmit() sends out.  That's OK as there is no further need to
>>>> process such a packet.

>>> dev_queue_xmit() skips the policy in the local out path for the
>>> generated RST packet. If you want to plain reject using
>>> dev_queue_xmit() then you have to use the ingress hook.

>>>> At least, the device whose connection request is being denied
>>>> doesn't hang anymore...

>>> The neighbour cache selects the destination MAC from the destination
>>> IP address of the RST packet.

>>> Your patch also refers to non-bridge scenario (no br_netfilter in
>>> place).

>>> Could you describe what you're trying to achieve in plain layman terms?

>> I will (re-)do no such thing because you are refusing to make sense.

>> It's OK that the bridge code uses dev_queue_xmit() to send out an RST packet
>> that has correct MACs, but that doesn't make another trip through netfilter.

> It's not OK that the bridge uses dev_queue_xmit().

> That was an ugly solution to make the REJECT target work from
> br_netfilter, because there was absolutely no other better way at that
> time to make it work.

> There has been now native support to reject traffic from the bridge
> from many years on through br_forward(), which is the way to go.

Ah, the cart before the horse.  I'll wait.

Later.

Marc.
--244749-10899-1615433984=:2800--
