Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5394AC433DB
	for <netfilter-devel@archiver.kernel.org>; Tue,  9 Mar 2021 04:26:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1EB8264FA8
	for <netfilter-devel@archiver.kernel.org>; Tue,  9 Mar 2021 04:26:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229714AbhCIEZu (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 8 Mar 2021 23:25:50 -0500
Received: from smtp-out-no.shaw.ca ([64.59.134.9]:56864 "EHLO
        smtp-out-no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229730AbhCIEZt (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 8 Mar 2021 23:25:49 -0500
Received: from fanir.tuyoix.net ([68.150.218.192])
        by shaw.ca with ESMTP
        id JTwFl2GtTeHr9JTwGlwcRx; Mon, 08 Mar 2021 21:25:45 -0700
X-Authority-Analysis: v=2.4 cv=Yq/K+6UX c=1 sm=1 tr=0 ts=6046f8c9
 a=LfNn7serMq+1bQZBlMsSfQ==:117 a=LfNn7serMq+1bQZBlMsSfQ==:17
 a=dESyimp9J3IA:10 a=M51BFTxLslgA:10 a=nlC_4_pT8q9DhB4Ho9EA:9
 a=vkpKByAbYeXmDsCIbX0A:9 a=QEXdDO2ut3YA:10
Received: from CLUIJ (cluij.tuyoix.net [192.168.144.15])
        (authenticated bits=0)
        by fanir.tuyoix.net (8.15.2/8.15.2) with ESMTPSA id 1294Pgaf002290
        (version=TLSv1 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO);
        Mon, 8 Mar 2021 21:25:43 -0700
Date:   Mon, 8 Mar 2021 21:25:28 -0700 (Mountain Standard Time)
From:   =?UTF-8?Q?Marc_Aur=C3=A8le_La_France?= <tsi@tuyoix.net>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf] netfilter REJECT: Fix destination MAC in RST
 packets
In-Reply-To: <20210309013621.GA27206@salvia>
Message-ID: <alpine.WNT.2.20.2103082114130.1604@CLUIJ>
References: <alpine.LNX.2.20.2103071736460.15162@fanir.tuyoix.net> <20210308102510.GA23497@salvia> <alpine.WNT.2.20.2103080908550.2772@CLUIJ> <20210309013621.GA27206@salvia>
User-Agent: Alpine 2.20 (WNT 67 2015-01-07)
MIME-Version: 1.0
Content-Type: multipart/mixed; BOUNDARY="1832311-8623-1615263928=:1604"
X-CMAE-Envelope: MS4xfK2HBkDEXKVIB0JHuGggj4/7rULBXpiVKXmL1/GCGoDkgB7b/LFY6jrqW4ayDXuuyNQ84hQnTzpJ7tcAeodrH5ZiAPEwcW4/qfYoAP2f56E9Cb7G4rK8
 xbpIhsHuNLEK9hK1LoW8OvghKO/Vrb7n5KCH/baOtOFbub09dQtndNemVn8JEbExXWEwZhOIDKjDGQZb0bWkYvTT6ZWe37XYnmyrBvoz/CHvaWgvMq+XWH9d
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--1832311-8623-1615263928=:1604
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8BIT

On Tue, 9 Mar 2021, Pablo Neira Ayuso wrote:
> On Mon, Mar 08, 2021 at 09:21:20AM -0700, Marc Aurèle La France wrote:
>> On Mon, 8 Mar 2021, Pablo Neira Ayuso wrote:
>>> On Sun, Mar 07, 2021 at 06:16:34PM -0700, Marc Aurèle La France wrote:

>>>> In the non-bridge case, the REJECT target code assumes the REJECTed
>>>> packets were originally emitted by the local host, but that's not
>>>> necessarily true when the local host is the default route of a subnet
>>>> it is on, resulting in RST packets being sent out with an incorrect
>>>> destination MAC.  Address this by refactoring the handling of bridged
>>>> packets which deals with a similar issue.  Modulo patch fuzz, the
>>>> following applies to v5 and later kernels.

>>> The code this patch updates is related to BRIDGE_NETFILTER. Your patch
>>> description refers to the non-bridge case. What are you trying to
>>> achieve?

>> Via DHCP, my subnet's default route is a Linux system so that it can monitor
>> all outbound traffic.  By doing so, for example, I have determined that my
>> Android phone connects to Facebook despite the fact that I have no such app
>> installed.  I want to know, and control, what other behind-the-scenes
>> (under-handed) traffic devices on my subnet generate.

>>> dev_queue_xmit() path should not be exercised from the prerouting
>>> chain, packets generated from the IP later must follow the
>>> ip_local_out() path.

>> Well, I can tell you dev_queue_xmit() does in fact work in prerouting
>> chains, as it must for the bridging case.  The only potential problem I've
>> found so far is that the RST packet doesn't go through any netfilter hooks.

> That's the issue, Netfilter rejects code from the IP layer, so the
> packets follows the ip_local_out() path.

... which sets an incorrect destination MAC.  Also, in this case, 
netfilter doesn't reject any such thing.  It doesn't even "see" the RST 
packet dev_queue_xmit() sends out.  That's OK as there is no further need 
to process such a packet.  At least, the device whose connection 
request is being denied doesn't hang anymore...

> You could use ingress to reject through dev_queue_xmit() / neigh_xmit().

I'm sticking to my guns.  I'm a firm believer in the KISS principle, part 
of a dying breed to be sure.

Marc.
--1832311-8623-1615263928=:1604--
