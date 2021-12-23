Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB53FC433EF
	for <netfilter-devel@archiver.kernel.org>; Thu, 23 Dec 2021 00:01:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344316AbhLWABv (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 22 Dec 2021 19:01:51 -0500
Received: from mail.netfilter.org ([217.70.188.207]:41644 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231232AbhLWABv (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 22 Dec 2021 19:01:51 -0500
Received: from netfilter.org (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 2392B62BD8;
        Thu, 23 Dec 2021 00:59:16 +0100 (CET)
Date:   Thu, 23 Dec 2021 01:01:47 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf-next] netfilter: flowtable: remove ipv4/ipv6 modules
Message-ID: <YcO8a5rjGWxEQuvo@salvia>
References: <20211217141055.15983-1-fw@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20211217141055.15983-1-fw@strlen.de>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, Dec 17, 2021 at 03:10:55PM +0100, Florian Westphal wrote:
> Just place the structs and registration in the inet module.
> nf_flow_table_ipv6, nf_flow_table_ipv4 and nf_flow_table_inet share
> same module dependencies: nf_flow_table, nf_tables.
> 
> before:
>    text	   data	    bss	    dec	    hex	filename
>    2278	   1480	      0	   3758	    eae	nf_flow_table_inet.ko
>    1159	   1352	      0	   2511	    9cf	nf_flow_table_ipv6.ko
>    1154	   1352	      0	   2506	    9ca	nf_flow_table_ipv4.ko
> 
> after:
>    2369	   1672	      0	   4041	    fc9	nf_flow_table_inet.ko

Applied, thanks
