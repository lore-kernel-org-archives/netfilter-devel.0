Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32C8DC001DF
	for <netfilter-devel@archiver.kernel.org>; Wed,  2 Aug 2023 17:24:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231296AbjHBRY4 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 2 Aug 2023 13:24:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231133AbjHBRYy (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 2 Aug 2023 13:24:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E4661996
        for <netfilter-devel@vger.kernel.org>; Wed,  2 Aug 2023 10:24:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F31E161A55
        for <netfilter-devel@vger.kernel.org>; Wed,  2 Aug 2023 17:24:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C0EDC433C8;
        Wed,  2 Aug 2023 17:24:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1690997092;
        bh=RCTt4dihwXo5XlZYJ+1F+x6J9AFMfpqOwEn3Ton40r4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=CyyWqGPyjWoFxSxDfmdld3ZJ+bRCU2WU03uXdGXR+QMgckEf3mZXTDFs+eYEZxCta
         elNXHRamo9Ygfmic9Y/fEkdxyxoEq475GGg61Mg2OnY2dmjTSLbXTWi0bRZut/mZEk
         vfWQ0YzsHTSiMXSAbQaYXXLyEkgsaJUS+SnIItdbnrciQZaBSBzaQFlpNBve4RJwNu
         kyFd0h+TAK/p5rhOcCZoRChCYtDHfqdHLWV3Hrn68T9XCl2mR+bCofC5ZgYrsIfvAt
         g19+yvSlo5sYkhd4eug4cjjDR6T8FWhdHN1Ln2f8K7ZhB1i0SAAtO55d0x14k3+/XE
         zRwGKH4HOAtbg==
Date:   Wed, 2 Aug 2023 19:24:47 +0200
From:   Simon Horman <horms@kernel.org>
To:     Yue Haibing <yuehaibing@huawei.com>
Cc:     pablo@netfilter.org, kadlec@netfilter.org, fw@strlen.de,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, lucien.xin@gmail.com,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next] netfilter: helper: Remove unused function
 declarations
Message-ID: <ZMqRX6PK9A9Vk5Mh@kernel.org>
References: <20230802131549.332-1-yuehaibing@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230802131549.332-1-yuehaibing@huawei.com>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Aug 02, 2023 at 09:15:49PM +0800, Yue Haibing wrote:
> Commit b118509076b3 ("netfilter: remove nf_conntrack_helper sysctl and modparam toggles")
> leave these unused declarations.
> 
> Signed-off-by: Yue Haibing <yuehaibing@huawei.com>

Reviewed-by: Simon Horman <horms@kernel.org>

