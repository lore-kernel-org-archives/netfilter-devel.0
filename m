Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1480CC7619A
	for <netfilter-devel@archiver.kernel.org>; Wed, 12 Apr 2023 14:18:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231499AbjDLOSU (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 12 Apr 2023 10:18:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231495AbjDLOST (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 12 Apr 2023 10:18:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A6C946A3;
        Wed, 12 Apr 2023 07:18:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B9EB2611BE;
        Wed, 12 Apr 2023 14:18:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C02C0C433D2;
        Wed, 12 Apr 2023 14:18:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681309098;
        bh=6Z0pbvNmrmVKo0gV14o7boQwibOZ6zoml5KjVPBYbrI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=jWcAfFDi1yErfUL9gWWMQQrSZKXusEk4CciyMQvlEKFuY/pEfPQOIR3tcArnXYwae
         xmcKpSS9vSVAoSoGvqaQjoPc0zMyhHK4SBD1Oc36usYNsdCtDSRLKJOGsGCH+3ElNw
         N4OuMv/ZyG1QHQ20ppy6ABY2bDkLCCUZfvkTkwitrX1x25WVkcwsBOpCGOQE9qgMtT
         W8JCIxJpZ+daZwEX9AsCxtUqzsj/SdktRpQoodN/KoAvl7KHYOryxl8wErE2z74DoD
         DpAMrzAgq4rd4CvdpXTM5TXXjhXdp9Tsz+snM9UNZqHW84qiJxyElIwW6rkjaTW8Xu
         7OZdWdk3Y8dGw==
Date:   Wed, 12 Apr 2023 07:18:16 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, pabeni@redhat.com, edumazet@google.com,
        mathew.j.martineau@linux.intel.com, matthieu.baerts@tessares.net,
        mptcp@lists.linux.dev
Subject: Re: [PATCH net,v2] uapi: linux: restore IPPROTO_MAX to 256 and add
 IPPROTO_UAPI_MAX
Message-ID: <20230412071816.0c0898ee@kernel.org>
In-Reply-To: <20230406092558.459491-1-pablo@netfilter.org>
References: <20230406092558.459491-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu,  6 Apr 2023 11:25:58 +0200 Pablo Neira Ayuso wrote:
>    IPPROTO_RAW = 255,		/* Raw IP packets			*/
> +  IPPROTO_MAX,
>  #define IPPROTO_RAW	

nit: any reason the IPPROTO_MAX is in between the enum entry 
and its associated define?
