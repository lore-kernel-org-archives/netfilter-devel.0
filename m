Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86DDDC4708E
	for <netfilter-devel@archiver.kernel.org>; Thu,  8 Dec 2022 02:05:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229480AbiLHCFx (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 7 Dec 2022 21:05:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229470AbiLHCFw (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 7 Dec 2022 21:05:52 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 133B7C76D
        for <netfilter-devel@vger.kernel.org>; Wed,  7 Dec 2022 18:04:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670465097;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=nFchvTb5790qg6awiJkpUPZ+LC7QgWWhXEhFWQSHRYg=;
        b=ZwJJSSWsfWDp0mODvA50GLQjcVgDpqiOE85+iNSf3GEZXObzhl7RRD1VSFYUCk34fcorqB
        MPHm57QY/75DLpsmYwse6kOfCQyxubLCOGWQZpHx8vzHKIq4RLn2YfTeTdJ9xwwkvBZz5B
        rRZAzbqOQBbJny7HPJ9uCI7GMAMjQTo=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-484-1KawVJ_dORefSX2OU4dsCQ-1; Wed, 07 Dec 2022 21:04:53 -0500
X-MC-Unique: 1KawVJ_dORefSX2OU4dsCQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2DD4029A9CCC;
        Thu,  8 Dec 2022 02:04:53 +0000 (UTC)
Received: from localhost (wsfd-netdev-vmhost.ntdv.lab.eng.bos.redhat.com [10.19.188.17])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1F3CB42220;
        Thu,  8 Dec 2022 02:04:53 +0000 (UTC)
Date:   Wed, 7 Dec 2022 21:04:52 -0500
From:   Eric Garver <eric@garver.life>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft 2/2,v2] netlink: swap byteorder of value component in
 concatenation of intervals
Message-ID: <Y5FGRE4J+AOcgMvM@wsfd-netdev-vmhost.ntdv.lab.eng.bos.redhat.com>
Mail-Followup-To: Eric Garver <eric@garver.life>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
References: <20221208004028.420544-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221208004028.420544-1-pablo@netfilter.org>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Dec 08, 2022 at 01:40:28AM +0100, Pablo Neira Ayuso wrote:
> Commit 1017d323cafa ("src: support for selectors with different byteorder with
> interval concatenations") was incomplete.
> 
> Switch byteorder of singleton values in a set that contains
> concatenation of intervals. This singleton value is actually represented
> as a range in the kernel.
> 
> After this patch, if the set represents a concatenation of intervals:
> 
> - EXPR_F_INTERVAL denotes the lhs of the interval.
> - EXPR_F_INTERVAL_END denotes the rhs of the interval (this flag was
>   already used in this way before this patch).
> 
> If none of these flags are set on, then the set contains concatenation
> of singleton values (no interval flag is set on), in such case, no
> byteorder swap is required.
> 
> Update tests/shell and tests/py to cover the use-case breakage reported
> by Eric.
> 
> Reported-by: Eric Garver <eric@garver.life>
> Fixes: 1017d323cafa ("src: support for selectors with different byteorder with interval concatenations")
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> ---

Thanks Pablo!

Tested-by: Eric Garver <eric@garver.life>

