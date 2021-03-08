Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38121C4332B
	for <netfilter-devel@archiver.kernel.org>; Mon,  8 Mar 2021 16:22:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F139A65235
	for <netfilter-devel@archiver.kernel.org>; Mon,  8 Mar 2021 16:22:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230046AbhCHQWA (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 8 Mar 2021 11:22:00 -0500
Received: from smtp-out-so.shaw.ca ([64.59.136.137]:45657 "EHLO
        smtp-out-so.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229690AbhCHQVg (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 8 Mar 2021 11:21:36 -0500
Received: from fanir.tuyoix.net ([68.150.218.192])
        by shaw.ca with ESMTP
        id JIdRlI0WCHmS3JIdSla68o; Mon, 08 Mar 2021 09:21:35 -0700
X-Authority-Analysis: v=2.4 cv=MaypB7zf c=1 sm=1 tr=0 ts=60464f0f
 a=LfNn7serMq+1bQZBlMsSfQ==:117 a=LfNn7serMq+1bQZBlMsSfQ==:17
 a=dESyimp9J3IA:10 a=M51BFTxLslgA:10 a=nlC_4_pT8q9DhB4Ho9EA:9
 a=67Hp3EJipaeTLZmLvIAA:9 a=QEXdDO2ut3YA:10
Received: from CLUIJ (cluij.tuyoix.net [192.168.144.15])
        (authenticated bits=0)
        by fanir.tuyoix.net (8.15.2/8.15.2) with ESMTPSA id 128GLXM9012698
        (version=TLSv1 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO);
        Mon, 8 Mar 2021 09:21:33 -0700
Date:   Mon, 8 Mar 2021 09:21:20 -0700 (Mountain Standard Time)
From:   =?UTF-8?Q?Marc_Aur=C3=A8le_La_France?= <tsi@tuyoix.net>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf] netfilter REJECT: Fix destination MAC in RST
 packets
In-Reply-To: <20210308102510.GA23497@salvia>
Message-ID: <alpine.WNT.2.20.2103080908550.2772@CLUIJ>
References: <alpine.LNX.2.20.2103071736460.15162@fanir.tuyoix.net> <20210308102510.GA23497@salvia>
User-Agent: Alpine 2.20 (WNT 67 2015-01-07)
MIME-Version: 1.0
Content-Type: multipart/mixed; BOUNDARY="4051235-17762-1615220480=:2772"
X-CMAE-Envelope: MS4xfJY7rkKGYV0Tdor4f133G9aalEEnUPC0z1hRiOa4MFJ68bfTdDyPZYnT93wKqkNSJiBS9o7sevNQMbjMPEtYF4Lw4TXZdUpBBEQyZNz6OZ6jIe3ZSnei
 NbFzFaLfTMJF699iGA+AjIRwUKveO4Xz1J9Wunax50OYkHBu5+IB21P20EX98RFY4EkmHJO0I8YNYcY5vf0nMy6jRbwgSXhSTgFEOoTFDmCU3NzYVPCcheZ7
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--4051235-17762-1615220480=:2772
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8BIT

On Mon, 8 Mar 2021, Pablo Neira Ayuso wrote:
> On Sun, Mar 07, 2021 at 06:16:34PM -0700, Marc Aurèle La France wrote:
>> In the non-bridge case, the REJECT target code assumes the REJECTed
>> packets were originally emitted by the local host, but that's not
>> necessarily true when the local host is the default route of a subnet
>> it is on, resulting in RST packets being sent out with an incorrect
>> destination MAC.  Address this by refactoring the handling of bridged
>> packets which deals with a similar issue.  Modulo patch fuzz, the
>> following applies to v5 and later kernels.

> The code this patch updates is related to BRIDGE_NETFILTER. Your patch
> description refers to the non-bridge case. What are you trying to
> achieve?

Via DHCP, my subnet's default route is a Linux system so that it can 
monitor all outbound traffic.  By doing so, for example, I have determined 
that my Android phone connects to Facebook despite the fact that I have no 
such app installed.  I want to know, and control, what other 
behind-the-scenes (under-handed) traffic devices on my subnet generate.

> dev_queue_xmit() path should not be exercised from the prerouting
> chain, packets generated from the IP later must follow the
> ip_local_out() path.

Well, I can tell you dev_queue_xmit() does in fact work in prerouting 
chains, as it must for the bridging case.  The only potential problem I've 
found so far is that the RST packet doesn't go through any netfilter 
hooks.

Marc.
--4051235-17762-1615220480=:2772--
