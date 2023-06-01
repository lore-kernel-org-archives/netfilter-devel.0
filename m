Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44C7DC77B7A
	for <netfilter-devel@archiver.kernel.org>; Thu,  1 Jun 2023 19:17:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231599AbjFATRo (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 1 Jun 2023 15:17:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232248AbjFATRn (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 1 Jun 2023 15:17:43 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6C8D7186;
        Thu,  1 Jun 2023 12:17:40 -0700 (PDT)
Date:   Thu, 1 Jun 2023 21:17:38 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Abhijeet Rastogi <abhijeet.1989@gmail.com>
Cc:     Simon Horman <horms@verge.net.au>, Julian Anastasov <ja@ssi.bg>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        lvs-devel@vger.kernel.org, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] ipvs: increase ip_vs_conn_tab_bits range for 64BIT
Message-ID: <ZHju0vjpr4nY7gA5@calendula>
References: <20230412-increase_ipvs_conn_tab_bits-v3-1-c813278f2d24@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230412-increase_ipvs_conn_tab_bits-v3-1-c813278f2d24@gmail.com>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, May 16, 2023 at 08:08:49PM -0700, Abhijeet Rastogi wrote:
> Current range [8, 20] is set purely due to historical reasons
> because at the time, ~1M (2^20) was considered sufficient.
> With this change, 27 is the upper limit for 64-bit, 20 otherwise.
> 
> Previous change regarding this limit is here.
>
> Link: https://lore.kernel.org/all/86eabeb9dd62aebf1e2533926fdd13fed48bab1f.1631289960.git.aclaudi@redhat.com/T/#u

Applied to nf-next, thanks
