Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E3CAC678D4
	for <netfilter-devel@archiver.kernel.org>; Thu,  2 Mar 2023 16:06:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229649AbjCBQG2 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 2 Mar 2023 11:06:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229547AbjCBQG1 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 2 Mar 2023 11:06:27 -0500
Received: from mail.balasys.hu (mail.balasys.hu [185.199.30.237])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50E55515DA
        for <netfilter-devel@vger.kernel.org>; Thu,  2 Mar 2023 08:06:23 -0800 (PST)
Received: from [10.90.6.8] (dmajor.balasys [10.90.6.8])
        by mail.balasys.hu (Postfix) with ESMTPSA id AD09C2B4937;
        Thu,  2 Mar 2023 17:06:20 +0100 (CET)
Message-ID: <f8d03b81-8980-b54e-a2a3-57f8e54044be@balasys.hu>
Date:   Thu, 2 Mar 2023 17:06:20 +0100
MIME-Version: 1.0
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org,
        Pablo Neira Ayuso <pablo@netfilter.org>
References: <401bd6ed-314a-a196-1cdc-e13c720cc8f2@balasys.hu>
 <20230302142946.GB309@breakpoint.cc>
Content-Language: en-US
From:   =?UTF-8?Q?Major_D=c3=a1vid?= <major.david@balasys.hu>
Subject: Re: CPU soft lockup in a spin lock using tproxy and nfqueue
In-Reply-To: <20230302142946.GB309@breakpoint.cc>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On 3/2/23 15:29, Florian Westphal wrote:
> Thanks, this is a bug in nft_tproxy.c.
> 
> Can you test following fix?
> 
> Thanks!

Thanks,

I builded and tested in my Jammy environment, and I could not reproduce
any soft lockups with this patch anymore.

But I am also wondering that the inet_twsk_deschedule_put is really
needed in this particular case in tproxy? As I understand it, there
is an other independent mechanism which destroys tw sockets, so no
need do it here?


