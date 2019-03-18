Return-Path: <SRS0=5Ubq=RV=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DBFBEC43381
	for <netfilter-devel@archiver.kernel.org>; Mon, 18 Mar 2019 15:01:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B79AD21473
	for <netfilter-devel@archiver.kernel.org>; Mon, 18 Mar 2019 15:01:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726703AbfCRPBM (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 18 Mar 2019 11:01:12 -0400
Received: from ganesha.gnumonks.org ([213.95.27.120]:57737 "EHLO
        ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726677AbfCRPBM (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 18 Mar 2019 11:01:12 -0400
X-Greylist: delayed 518 seconds by postgrey-1.27 at vger.kernel.org; Mon, 18 Mar 2019 11:01:11 EDT
Received: from [195.39.71.253] (helo=gnumonks.org)
        by ganesha.gnumonks.org with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.84_2)
        (envelope-from <pablo@gnumonks.org>)
        id 1h5tl4-0001bd-IU; Mon, 18 Mar 2019 16:01:04 +0100
Date:   Mon, 18 Mar 2019 16:00:58 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Aditya Pakki <pakki001@umn.edu>
Cc:     kjlu@umn.edu, Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] netfilter: ip6t_srh: Fix potential NULL pointer
 dereference
Message-ID: <20190318150058.nn2cgvvid7jbvi4t@salvia>
References: <20190311231920.26514-1-pakki001@umn.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190311231920.26514-1-pakki001@umn.edu>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, Mar 11, 2019 at 06:19:20PM -0500, Aditya Pakki wrote:
> skb_header_pointer in srh_mt6 may return a NULL pointer that is
> dereferenced in ipv6_masked_addr_cmp. This patch avoids such a scenario.

I'll take this one instead:

https://patchwork.ozlabs.org/patch/1056390/

Thanks for submitting a patch anyway.
