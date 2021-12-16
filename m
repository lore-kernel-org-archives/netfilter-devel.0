Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66859C433EF
	for <netfilter-devel@archiver.kernel.org>; Thu, 16 Dec 2021 14:14:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229634AbhLPON7 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 16 Dec 2021 09:13:59 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:35583 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229576AbhLPON7 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 16 Dec 2021 09:13:59 -0500
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-492-hl9SKGRaMeiWSmqF-j-3Dg-1; Thu, 16 Dec 2021 09:13:55 -0500
X-MC-Unique: hl9SKGRaMeiWSmqF-j-3Dg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2B69A801AC5;
        Thu, 16 Dec 2021 14:13:54 +0000 (UTC)
Received: from localhost (unknown [10.22.34.184])
        by smtp.corp.redhat.com (Postfix) with ESMTP id AA3CB60657;
        Thu, 16 Dec 2021 14:13:53 +0000 (UTC)
Date:   Thu, 16 Dec 2021 09:13:53 -0500
From:   Eric Garver <eric@garver.life>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org, Phil Sutter <phil@nwl.cc>
Subject: Re: [PATCH nf-next v2 2/2] netfilter: nat: force port remap to
 prevent shadowing well-known ports
Message-ID: <YbtJoQ0yee1J+xPA@egarver.remote.csb>
Mail-Followup-To: Eric Garver <eric@garver.life>,
        Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org,
        Phil Sutter <phil@nwl.cc>
References: <20211215122026.20850-1-fw@strlen.de>
 <20211215122026.20850-3-fw@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211215122026.20850-3-fw@strlen.de>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Dec 15, 2021 at 01:20:26PM +0100, Florian Westphal wrote:
> If destination port is above 32k and source port below 16k
> assume this might cause 'port shadowing' where a 'new' inbound
> connection matches an existing one, e.g.
> 
> inbound X:41234 -> Y:53 matches existing conntrack entry
>         Z:53 -> X:4123, where Z got natted to X.
> 
> In this case, new packet is natted to Z:53 which is likely
> unwanted.
> 
> We avoid the rewrite for connections that originate from local host:
> port-shadowing is only possible with forwarded connections.
> 
> Also adjust test case.
> 
> Cc: Eric Garver <eric@garver.life>
> Cc: Phil Sutter <phil@nwl.cc>
> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
>  v2: skip remap if local_out is set.
> 
>  net/netfilter/nf_nat_core.c                  | 43 ++++++++++++++++++--
>  tools/testing/selftests/netfilter/nft_nat.sh |  5 ++-
>  2 files changed, 43 insertions(+), 5 deletions(-)

Thanks Florian!

Acked-by: Eric Garver <eric@garver.life>

