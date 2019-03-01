Return-Path: <SRS0=xc7Z=RE=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2E1DC43381
	for <netfilter-devel@archiver.kernel.org>; Fri,  1 Mar 2019 09:08:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9AA8F20851
	for <netfilter-devel@archiver.kernel.org>; Fri,  1 Mar 2019 09:08:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731683AbfCAJIb (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 1 Mar 2019 04:08:31 -0500
Received: from mail.cn.fujitsu.com ([183.91.158.132]:12498 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727951AbfCAJIb (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 1 Mar 2019 04:08:31 -0500
X-IronPort-AV: E=Sophos;i="5.58,427,1544457600"; 
   d="scan'208";a="55605169"
Received: from unknown (HELO cn.fujitsu.com) ([10.167.33.5])
  by heian.cn.fujitsu.com with ESMTP; 01 Mar 2019 17:08:28 +0800
Received: from G08CNEXCHPEKD03.g08.fujitsu.local (unknown [10.167.33.85])
        by cn.fujitsu.com (Postfix) with ESMTP id 0FBCC4C4FFEA;
        Fri,  1 Mar 2019 17:08:14 +0800 (CST)
Received: from [10.167.226.33] (10.167.226.33) by
 G08CNEXCHPEKD03.g08.fujitsu.local (10.167.33.89) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Fri, 1 Mar 2019 17:08:26 +0800
Subject: Re: [PATCH] netfilter: nf_ct_helper: Fix possible panic when
 nf_conntrack_helper_unregister is used in an unloadable module
To:     Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        Su Yanjun <suyanjun218@163.com>, <pablo@netfilter.org>,
        <kadlec@blackhole.kfki.hu>, <fw@strlen.de>, <davem@davemloft.net>,
        <netfilter-devel@vger.kernel.org>, <coreteam@netfilter.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <1551419766-1039-1-git-send-email-suyanjun218@163.com>
 <e420b6c0-bebf-a2fc-a2ee-7b3e0023d833@cogentembedded.com>
From:   "Su Yanjun <suyj.fnst@cn.fujitsu.com>" <suyj.fnst@cn.fujitsu.com>
Message-ID: <ddd00e53-266b-93cc-898f-d92b88366d4d@cn.fujitsu.com>
Date:   Fri, 1 Mar 2019 17:08:23 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.3
MIME-Version: 1.0
In-Reply-To: <e420b6c0-bebf-a2fc-a2ee-7b3e0023d833@cogentembedded.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.167.226.33]
X-yoursite-MailScanner-ID: 0FBCC4C4FFEA.A3A41
X-yoursite-MailScanner: Found to be clean
X-yoursite-MailScanner-From: suyj.fnst@cn.fujitsu.com
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


On 2019/3/1 16:43, Sergei Shtylyov wrote:
> Hello!
>
> On 01.03.2019 8:56, Su Yanjun wrote:
>
>> From: Su Yanjun <suyj.fnst@cn.fujitsu.com>
>>
>> Because nf_conntrack_helper_unregister maybe used in an unloadable 
>> module,
>> it uses 'synchronize_rcu' which may cause kernel panic.
>>
>> According to the artical:
>
>    Article?
>
I got it.
>> RCU and Unloadable Modules
>> https://lwn.net/Articles/217484/
>>
>> When we have a heavy rcu callback load, then some of the callbacks 
>> might be
>> deferred in order to allow other processing to proceed. 
>> sychnorize_rcu does
>> not wait rcu callback complete and module may be unloaded before 
>> callback
>> done.
>>
>> This patch uses rcu_barrier instead of synchronize_rcu will prevent this
>                                                         ^ that/which 
> missed?
>
Yes.
>> situation.
>>
>> Signed-off-by: Su Yanjun <suyj.fnst@cn.fujitsu.com>
> [...]
>
> MBR, Sergei
>
>
Thanks.

Su




