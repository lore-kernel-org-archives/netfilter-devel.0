Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32198C433F5
	for <netfilter-devel@archiver.kernel.org>; Fri, 17 Dec 2021 13:28:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230183AbhLQN2Y (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 17 Dec 2021 08:28:24 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:30428 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229543AbhLQN2Y (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 17 Dec 2021 08:28:24 -0500
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-592-nMeZzev3P9aEZ9vL5fSbrQ-1; Fri, 17 Dec 2021 08:28:20 -0500
X-MC-Unique: nMeZzev3P9aEZ9vL5fSbrQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 456833E743;
        Fri, 17 Dec 2021 13:28:19 +0000 (UTC)
Received: from localhost (unknown [10.22.9.123])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 92C9D5BE19;
        Fri, 17 Dec 2021 13:28:18 +0000 (UTC)
Date:   Fri, 17 Dec 2021 08:28:17 -0500
From:   Eric Garver <eric@garver.life>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org, Phil Sutter <phil@nwl.cc>
Subject: Re: [PATCH v4 nf-next 2/2] netfilter: nat: force port remap to
 prevent shadowing well-known ports
Message-ID: <YbyQcRF1V2FD1o7I@egarver.remote.csb>
Mail-Followup-To: Eric Garver <eric@garver.life>,
        Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org,
        Phil Sutter <phil@nwl.cc>
References: <20211217102957.2999-1-fw@strlen.de>
 <20211217102957.2999-3-fw@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211217102957.2999-3-fw@strlen.de>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, Dec 17, 2021 at 11:29:57AM +0100, Florian Westphal wrote:
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
> v3: no need to call tuple_force_port_remap if already in random mode (Phil)
> 
> Cc: Eric Garver <eric@garver.life>
> Signed-off-by: Florian Westphal <fw@strlen.de>
> Acked-by: Phil Sutter <phil@nwl.cc>
> ---
>  resent without changes, kept phils ack.
>  net/netfilter/nf_nat_core.c                  | 43 ++++++++++++++++++--
>  tools/testing/selftests/netfilter/nft_nat.sh |  5 ++-
>  2 files changed, 43 insertions(+), 5 deletions(-)

Acked-by: Eric Garver <eric@garver.life>

