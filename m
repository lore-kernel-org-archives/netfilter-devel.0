Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 737A3C433F5
	for <netfilter-devel@archiver.kernel.org>; Mon, 29 Nov 2021 20:25:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234588AbhK2U2E (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 29 Nov 2021 15:28:04 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:54196 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234507AbhK2UZw (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 29 Nov 2021 15:25:52 -0500
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-576-Rkx9VgH3NzuCuc4CKcIF9Q-1; Mon, 29 Nov 2021 15:22:29 -0500
X-MC-Unique: Rkx9VgH3NzuCuc4CKcIF9Q-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 32B155A064;
        Mon, 29 Nov 2021 20:22:28 +0000 (UTC)
Received: from localhost (unknown [10.22.33.169])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B48CA45D60;
        Mon, 29 Nov 2021 20:22:27 +0000 (UTC)
Date:   Mon, 29 Nov 2021 15:22:26 -0500
From:   Eric Garver <eric@garver.life>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org, Phil Sutter <phil@nwl.cc>
Subject: Re: [PATCH nf] netfilter: nat: force port remap to prevent shadowing
 well-known ports
Message-ID: <YaU2gndowxjvV+zn@egarver.remote.csb>
Mail-Followup-To: Eric Garver <eric@garver.life>,
        Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org,
        Phil Sutter <phil@nwl.cc>
References: <20211129144218.2677-1-fw@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211129144218.2677-1-fw@strlen.de>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, Nov 29, 2021 at 03:42:18PM +0100, Florian Westphal wrote:
> If destination port is above 32k and source port below 16k
> assume this might cause 'port shadowing' where a 'new' inbound
> connection matches an existing one, e.g.

How did you arrive at 16k?

> 
> inbound X:41234 -> Y:53 matches existing conntrack entry
>         Z:53 -> X:4123, where Z got natted to X.
> 
> In this case, new packet is natted to Z:53 which is likely
> unwanted.
> 
> We could avoid the rewrite for connections that are not being forwarded,
> but get_unique_tuple() and the callers don't propagate the required hook
> information for this.
> 
> Also adjust test case.
> 
> Cc: Eric Garver <eric@garver.life>
> Cc: Phil Sutter <phil@nwl.cc>
> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---

[..]

