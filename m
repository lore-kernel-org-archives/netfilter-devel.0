Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A360C43334
	for <netfilter-devel@archiver.kernel.org>; Wed,  8 Jun 2022 16:04:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244740AbiFHQEb (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 8 Jun 2022 12:04:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244799AbiFHQEa (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 8 Jun 2022 12:04:30 -0400
Received: from mail1.systemli.org (mail1.systemli.org [93.190.126.36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E15C17C695
        for <netfilter-devel@vger.kernel.org>; Wed,  8 Jun 2022 09:04:28 -0700 (PDT)
Message-ID: <822db165-fa16-cc16-6181-556da0cbae81@systemli.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=systemli.org;
        s=default; t=1654704266;
        bh=j/Gi3qPrr8VLuzGPYAb7Y5yzBXc8FUljo9VYv6qUosg=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=531N7aOydFU0m+8hMXacEP2OBF6mtktaUDm8x+KQi2UFBRsPCp5fykAug6Dp82x/3
         4ukjmYUL50kSRa7LEb3njyIzXKkyIfRxHbx6+YzLKx7vPTIbXwgTal+ILasLA19D30
         v5OQmMMDQPw60oKSM1haBUxD3TIpGqmmfKnG5YgTdNAakUty5YO+i+d1TPSiGfeqZj
         B9Ro2axyursujN4uDntZAKxfAOd9lVjmH1RNk2CLAstc4xwfqyh7TtO/woo3e5KHLI
         p4wa5CZxl2QycOy8feXVid1mHQlqfWqFEzNdTZadK2xIDn9lu+h90pXD4qVmw8WhFE
         oFP7lN+cLcgow==
Date:   Wed, 8 Jun 2022 18:04:01 +0200
MIME-Version: 1.0
Subject: Re: Add action to "finally" accept packets?
Content-Language: en-US
To:     Florian Westphal <fw@strlen.de>
Cc:     Netfilter Development Mailing List 
        <netfilter-devel@vger.kernel.org>
References: <36adbaad-20aa-2909-6ec1-caf61b0364ad@systemli.org>
 <20220608154401.GB6114@breakpoint.cc>
From:   Nick <vincent@systemli.org>
In-Reply-To: <20220608154401.GB6114@breakpoint.cc>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

> Why does jump/goto not help? It works just like in iptables.
It does not help because of the way firewall4 is including custom 
nftables chains for now. You need to add a hook yourself.
Firewall4 has a table called fw4, there they also hook e.g. to the 
priority filter. Basically, your custom chain needs to hook filter 
priority - 1 to be executed and whatever you do, the fw4 hook will be 
executed afterward. I wanted to "go" over it. As I understand the 
current discussion, the plan is to hook "only once" and allow to jump to 
the custom chains from there.
Please keep in mind, that I am not the author of firewall4. I just 
wanted to ask if something like this is or will be possible in the 
future. I did not find any information about it on the internet. Thanks 
for your answer.

