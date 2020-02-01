Return-Path: <SRS0=IEee=3V=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93359C33CB3
	for <netfilter-devel@archiver.kernel.org>; Sat,  1 Feb 2020 20:59:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6930F2063A
	for <netfilter-devel@archiver.kernel.org>; Sat,  1 Feb 2020 20:59:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1580590797;
	bh=KevWkdac8EVORDXCqj5ohEQaolR/zMrWdXeYUsEIWMU=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:List-ID:From;
	b=mSzEqBLH5rV6iIcHMStN156luo+907k+FRnGgsN0I9Abc977w6irmhHq694BbsxzD
	 glvR8B3BatNDIR3zR/+g0vwo8kgjU7w45d7MfWrYb9NBGmsZmdDokqK2qtcu69uUF4
	 KfD2wqMSF/+BfuZm3z0025jFZ6/Og7v+QZIQMTTw=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726664AbgBAU7w (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 1 Feb 2020 15:59:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:33666 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726453AbgBAU7w (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 1 Feb 2020 15:59:52 -0500
Received: from cakuba.hsd1.ca.comcast.net (c-73-93-4-247.hsd1.ca.comcast.net [73.93.4.247])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C952120658;
        Sat,  1 Feb 2020 20:59:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580590792;
        bh=KevWkdac8EVORDXCqj5ohEQaolR/zMrWdXeYUsEIWMU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=0x4R4W7u17I/w8KxjKktomaTCqhiAQDTFz2wXP9gt5GtqcM7Pu+yHy9Gkgf1+vx5G
         2SoEuOMf8A1/0H29pr3I7+MYItz40rTqaaKuEhaeq1OKchcNSpkezeUHaZhFnh/UvJ
         usyn1YZcpJaAQpSTcwRZ3HVuWcoBI9xuFqaHKYtA=
Date:   Sat, 1 Feb 2020 12:59:51 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org
Subject: Re: [PATCH 0/6] Netfilter fixes for net
Message-ID: <20200201125951.75a1d554@cakuba.hsd1.ca.comcast.net>
In-Reply-To: <20200131192428.167274-1-pablo@netfilter.org>
References: <20200131192428.167274-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, 31 Jan 2020 20:24:22 +0100, Pablo Neira Ayuso wrote:
> Hi,
> 
> The following patchset contains Netfilter fixes for net:
> 
> 1) Fix suspicious RCU usage in ipset, from Jozsef Kadlecsik.
> 
> 2) Use kvcalloc, from Joe Perches.
> 
> 3) Flush flowtable hardware workqueue after garbage collection run,
>    from Paul Blakey.
> 
> 4) Missing flowtable hardware workqueue flush from nf_flow_table_free(),
>    also from Paul.
> 
> 5) Restore NF_FLOW_HW_DEAD in flow_offload_work_del(), from Paul.
> 
> 6) Flowtable documentation fixes, from Matteo Croce.

Pulled, thanks!
