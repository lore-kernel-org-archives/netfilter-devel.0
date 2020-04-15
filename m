Return-Path: <SRS0=F+rW=57=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76325C3815B
	for <netfilter-devel@archiver.kernel.org>; Wed, 15 Apr 2020 08:39:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4922C20784
	for <netfilter-devel@archiver.kernel.org>; Wed, 15 Apr 2020 08:39:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=mg.codeaurora.org header.i=@mg.codeaurora.org header.b="jUWmq15O"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2894719AbgDOIjL (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 15 Apr 2020 04:39:11 -0400
Received: from mail26.static.mailgun.info ([104.130.122.26]:53756 "EHLO
        mail26.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2894711AbgDOIjD (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 15 Apr 2020 04:39:03 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1586939942; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=bZ59EN8awNmF7zj3CyC713PMe8l1ZWyV0lWfIgcGESo=;
 b=jUWmq15ObR9oQuOHqv1vqAw3xedfwrVLYgnHojMi5qjbYWa00s2VUI+3xBeOs85+Gmkwz5ni
 eFaR3PTHhGUKdEregEfj0MC3DqrCG6kPDIdfSGfzvt31yanOCbDktX13Qu6veUWysWs8C2UO
 HlzM+Y82NbVV9CAlpsuW1atHis4=
X-Mailgun-Sending-Ip: 104.130.122.26
X-Mailgun-Sid: WyJlM2NhZSIsICJuZXRmaWx0ZXItZGV2ZWxAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5e96c81e.7fd202dd8538-smtp-out-n01;
 Wed, 15 Apr 2020 08:38:54 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id EECE5C43636; Wed, 15 Apr 2020 08:38:53 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: manojbm)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 3CC47C432C2;
        Wed, 15 Apr 2020 08:38:53 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Wed, 15 Apr 2020 14:08:53 +0530
From:   manojbm@codeaurora.org
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        sharathv@qti.qualcomm.com, ssaha@qti.qualcomm.com,
        vidulak@qti.qualcomm.com, manojbm@qti.qualcomm.com,
        subashab@codeaurora.org, Sauvik Saha <ssaha@codeaurora.org>
Subject: Re: [PATCH] idletimer extension :  Add alarm timer option
In-Reply-To: <20200415075954.bujipzq2xorbit36@salvia>
References: <20200415072411.20950-1-manojbm@codeaurora.org>
 <20200415075954.bujipzq2xorbit36@salvia>
Message-ID: <5680a2662bb24d61b7714edb3ad23950@codeaurora.org>
X-Sender: manojbm@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On 2020-04-15 13:29, Pablo Neira Ayuso wrote:
> Hi Manoj
> 
> On Wed, Apr 15, 2020 at 12:54:11PM +0530, Manoj Basapathi wrote:
>> Introduce "--alarm" option for idletimer rule.
>> If it is present, hardidle-timer is used, else default timer.
>> The default idletimer starts a deferrable timer or in other
>> words the timer will cease to run when cpu is in suspended
>> state. This change introduces the option to start a
>> non-deferrable or alarm timer which will continue to run even
>> when the cpu is in suspended state.
> 
> Would you include the recent update from Maciej:
> 
>         iptables: open eBPF programs in read only mode
> 
> in v2.
> 
> Thanks.

Hi Pablo,

IDLETIMER is not using bpf_obj_get function.
Can you please give me more details on how to include Maciej commit 
here.

Thanks,
Manoj
