Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C1A7C7EE2D
	for <netfilter-devel@archiver.kernel.org>; Wed,  1 Mar 2023 19:05:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229546AbjCATFo (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 1 Mar 2023 14:05:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229529AbjCATFn (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 1 Mar 2023 14:05:43 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5806B43913
        for <netfilter-devel@vger.kernel.org>; Wed,  1 Mar 2023 11:04:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1677697495;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=lN9AxhiUyuhLIudz4BxR16dkYrIus6PcPshd5X+tifg=;
        b=cvPT9sC+QOxdtOOXhPwhtEVP8brVt2ykYMZKMhVyBMC4xbAeTKqDSViKnlPQAxJtPPL9tT
        2nPItcNjNSyC2ZPspbrXjANp0Kwpdh5nbjRtd0fdQ4X5hKTggPNhzOYanPjmEyOA4JQ9/P
        0D24qFVsxlidZr756RnEXZ2yKDN4dV4=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-519-bUyAZ1J-PTCa7yK0lo7aww-1; Wed, 01 Mar 2023 14:04:52 -0500
X-MC-Unique: bUyAZ1J-PTCa7yK0lo7aww-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id AF8AA1C0A58D;
        Wed,  1 Mar 2023 19:04:51 +0000 (UTC)
Received: from localhost (unknown [10.22.11.127])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8A0D040C6EC4;
        Wed,  1 Mar 2023 19:04:51 +0000 (UTC)
Date:   Wed, 1 Mar 2023 14:04:51 -0500
From:   Eric Garver <eric@garver.life>
To:     Phil Sutter <phil@nwl.cc>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [iptables PATCH] nft-restore: Fix for deletion of new,
 referenced rule
Message-ID: <Y/+h01zul5wWUIs2@egarver.remote.csb>
Mail-Followup-To: Eric Garver <eric@garver.life>, Phil Sutter <phil@nwl.cc>,
        netfilter-devel@vger.kernel.org
References: <20230228171549.28483-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230228171549.28483-1-phil@nwl.cc>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Feb 28, 2023 at 06:15:49PM +0100, Phil Sutter wrote:
> Combining multiple corner-cases here:
> 
> * Insert a rule before another new one which is not the first. Triggers
>   NFTNL_RULE_ID assignment of the latter.
> 
> * Delete the referenced new rule in the same batch again. Causes
>   overwriting of the previously assigned RULE_ID.
> 
> Consequently, iptables-nft-restore fails during *insert*, because the
> reference is dangling.
> 
> Reported-by: Eric Garver <eric@garver.life>
> Fixes: 760b35b46e4cc ("nft: Fix for add and delete of same rule in single batch")
> Signed-off-by: Phil Sutter <phil@nwl.cc>

Tested-by: Eric Garver <eric@garver.life>

Thanks Phil!

