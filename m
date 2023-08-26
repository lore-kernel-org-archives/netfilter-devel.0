Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 396DFC83F16
	for <netfilter-devel@archiver.kernel.org>; Sat, 26 Aug 2023 16:37:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229757AbjHZQhM (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 26 Aug 2023 12:37:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230137AbjHZQgw (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 26 Aug 2023 12:36:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A21D61991;
        Sat, 26 Aug 2023 09:36:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 418ED616E6;
        Sat, 26 Aug 2023 16:36:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50245C433C7;
        Sat, 26 Aug 2023 16:36:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1693067809;
        bh=Bw8aXWJjlayr4JFwZwbqJJnYZJRH6/I9kF9alThINnM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=FJbwLHRQkJCvnOxlkzE9v6BH95R2CNXEOUcB/mcsoMILwR6DOZ5srlpeE4XL6gY0e
         YZo+icE1dGDIcER8Mt0x8OWQm53yacn4zkB963DnVkydBrLG5F+22or4UmjMASnWpD
         HcaUdYBCw5M39/ZsnPJD6yp3pXkbVOIBT63nl5xo=
Date:   Sat, 26 Aug 2023 18:36:46 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Julian Anastasov <ja@ssi.bg>
Cc:     stable@vger.kernel.org, Simon Horman <horms@verge.net.au>,
        lvs-devel@vger.kernel.org, Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org, Junwei Hu <hujunwei4@huawei.com>,
        Sishuai Gong <sishuai.system@gmail.com>
Subject: Re: [PATCH -stable,4.14.y,4.19.y 0/1] ipvs: backport 1b90af292e71
 and 5310760af1d4
Message-ID: <2023082639-hacking-yoga-85c0@gregkh>
References: <2023082114-remix-cable-0852@gregkh>
 <20230824115354.61669-1-ja@ssi.bg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230824115354.61669-1-ja@ssi.bg>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Aug 24, 2023 at 02:53:53PM +0300, Julian Anastasov wrote:
> 	Hello,
> 
> 	This patchset contains backport for
> commit 1b90af292e71b20d03b837d39406acfbdc5d4b2a. It applies
> to linux-4.14.y and linux-4.19.y and differs from original commit
> for the zero/one values used for extra1/extra2.
> 
> 	When applied, the concerned commit
> 5310760af1d4fbea1452bfc77db5f9a680f7ae47 can be cherry-picked and
> it will apply cleanly on top of 1b90af292e71.
> 
> Junwei Hu (1):
>   ipvs: Improve robustness to the ipvs sysctl
> 
>  net/netfilter/ipvs/ip_vs_ctl.c | 70 +++++++++++++++++-----------------
>  1 file changed, 36 insertions(+), 34 deletions(-)
> 
> -- 
> 2.41.0
> 
> 

Now queued up, thanks.

greg k-h
