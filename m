Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E055C433DB
	for <netfilter-devel@archiver.kernel.org>; Mon,  8 Mar 2021 16:15:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 158A76523D
	for <netfilter-devel@archiver.kernel.org>; Mon,  8 Mar 2021 16:15:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229775AbhCHQPA (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 8 Mar 2021 11:15:00 -0500
Received: from smtp-out-no.shaw.ca ([64.59.134.13]:34606 "EHLO
        smtp-out-no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229463AbhCHQOs (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 8 Mar 2021 11:14:48 -0500
X-Greylist: delayed 487 seconds by postgrey-1.27 at vger.kernel.org; Mon, 08 Mar 2021 11:14:48 EST
Received: from fanir.tuyoix.net ([68.150.218.192])
        by shaw.ca with ESMTP
        id JIP0lwjvgeHr9JIP1lqYm0; Mon, 08 Mar 2021 09:06:40 -0700
X-Authority-Analysis: v=2.4 cv=Yq/K+6UX c=1 sm=1 tr=0 ts=60464b90
 a=LfNn7serMq+1bQZBlMsSfQ==:117 a=LfNn7serMq+1bQZBlMsSfQ==:17
 a=dESyimp9J3IA:10 a=M51BFTxLslgA:10 a=nlC_4_pT8q9DhB4Ho9EA:9
 a=Ru1keEEOs_GpVbV6HLkA:9 a=QEXdDO2ut3YA:10
Received: from CLUIJ (cluij.tuyoix.net [192.168.144.15])
        (authenticated bits=0)
        by fanir.tuyoix.net (8.15.2/8.15.2) with ESMTPSA id 128G6bj1010941
        (version=TLSv1 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO);
        Mon, 8 Mar 2021 09:06:38 -0700
Date:   Mon, 8 Mar 2021 09:06:24 -0700 (Mountain Standard Time)
From:   =?UTF-8?Q?Marc_Aur=C3=A8le_La_France?= <tsi@tuyoix.net>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
cc:     Laura Garcia Liebana <nevola@gmail.com>,
        netfilter-devel@vger.kernel.org
Subject: Re: {PATCH nf] x_tables: Allow REJECT targets in PREROUTING chains
In-Reply-To: <20210308103438.GA23953@salvia>
Message-ID: <alpine.WNT.2.20.2103080902070.2772@CLUIJ>
References: <alpine.LNX.2.20.2103071733480.15162@fanir.tuyoix.net> <20210308103438.GA23953@salvia>
User-Agent: Alpine 2.20 (WNT 67 2015-01-07)
MIME-Version: 1.0
Content-Type: multipart/mixed; BOUNDARY="3155773-9547-1615219584=:2772"
X-CMAE-Envelope: MS4xfKHWr4wD5D1q+FewWHyzFId3c9RF4SzUeh8ir/1mg7sI/Of5qCAFPXpdHVjImEfBkbkqUI/bFRH4A1uanL3IAQN4r2nf1FTBLqqg746TCEtoxNgR+wRM
 V1pqitkLqhjdMNG9C204JL8o2S3oxTRK/5GY5hWmLvgYhqAaZx/tFxQapgnMuUfm6YLqp2za8JnHXMbSD1RnJZ1PDXJuV8hTDBtoA+iD+XLFDUpYLe4yR8CA
 wbhumKyIi/K6zxYvTVePXKtSyxhViHbZZ5bZM1RC6iM=
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--3155773-9547-1615219584=:2772
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8BIT

On Mon, 8 Mar 2021, Pablo Neira Ayuso wrote:
> On Sun, Mar 07, 2021 at 06:16:10PM -0700, Marc Aurèle La France wrote:
>> Extend commit f53b9b0bdc59c0823679f2e3214e0d538f5951b9 "netfilter:
>> introduce support for reject at prerouting stage", which appeared in
>> 5.9, by making the corresponding changes to x_tables REJECT targets.

>> Please Reply-To-All.

> This patch LGTM.

... except that I have since realised it relies on another change I'm 
carrying that allows REJECT targets in all tables, not just filter, 
something I doubt you are open to.

Withdrawn.

Thanks for youur time.

Marc.
--3155773-9547-1615219584=:2772--
