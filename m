Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 790B9C11F65
	for <netfilter-devel@archiver.kernel.org>; Wed, 30 Jun 2021 12:30:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6051A61584
	for <netfilter-devel@archiver.kernel.org>; Wed, 30 Jun 2021 12:30:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234560AbhF3MdD (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 30 Jun 2021 08:33:03 -0400
Received: from relay.sw.ru ([185.231.240.75]:59178 "EHLO relay.sw.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234481AbhF3MdC (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 30 Jun 2021 08:33:02 -0400
X-Greylist: delayed 14684 seconds by postgrey-1.27 at vger.kernel.org; Wed, 30 Jun 2021 08:33:02 EDT
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=virtuozzo.com; s=relay; h=Content-Type:MIME-Version:Date:Message-ID:From:
        Subject; bh=kwk7jyLXbh21vjpq/Pu++X60kzhkvJVqtiZH2jwiitw=; b=q7Di/Ms0g1hwt7cFI
        CqZ1FxQpNKUAVVopFI5NqxSCznfizggec4qHSK5LyNPTmidtC/vfvHu+a3qpBEDIY5KdS6gxZ5GLi
        ym/0l2i72GBP0USRmplwDDetqP50P/3pH0OvDH9cX8ztta/BlCHVczZxZ36PKEaZzWAv2s3NihZz4
        =;
Received: from [10.93.0.56]
        by relay.sw.ru with esmtp (Exim 4.94.2)
        (envelope-from <vvs@virtuozzo.com>)
        id 1lYGPe-002P32-NO; Wed, 30 Jun 2021 15:30:31 +0300
Subject: Re: [PATCH NETFILTER] netfilter: nfnetlink: suspicious RCU usage in
 ctnetlink_dump_helpinfo
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Florian Westphal <fw@strlen.de>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Taehee Yoo <ap420073@gmail.com>, Julian Anastasov <ja@ssi.bg>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        linux-kernel@vger.kernel.org
References: <65205a04-f1a3-9901-f6b7-eab8f482f37f@virtuozzo.com>
 <20210630094949.GA18022@breakpoint.cc> <20210630120947.GA12739@salvia>
From:   Vasily Averin <vvs@virtuozzo.com>
Message-ID: <8a892a24-62f2-fb43-aad6-62ada13143e7@virtuozzo.com>
Date:   Wed, 30 Jun 2021 15:30:30 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210630120947.GA12739@salvia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On 6/30/21 3:09 PM, Pablo Neira Ayuso wrote:
> 
> On Wed, Jun 30, 2021 at 11:49:49AM +0200, Florian Westphal wrote:
>> Vasily Averin <vvs@virtuozzo.com> wrote:
>>> Two patches listed below removed ctnetlink_dump_helpinfo call from under
>>> rcu_read_lock. Now its rcu_dereference generates following warning:
>>> =============================
>>> WARNING: suspicious RCU usage
>>> 5.13.0+ #5 Not tainted
>>> -----------------------------
>>> net/netfilter/nf_conntrack_netlink.c:221 suspicious rcu_dereference_check() usage!
>>
>> Reviewed-by: Florian Westphal <fw@strlen.de>
> 
> I don't see this patch in netfilter's patchwork nor in
> netfilter-devel@vger.kernel.org
> 
> Where did they go?

My original letter was graylisted.

"
A message that you sent could not be delivered to one or more of its
recipients. This is a permanent error. The following address(es) failed:

coreteam@netfilter.org
host mail.netfilter.org [217.70.188.207]
SMTP error from remote mail server after RCPT TO:<coreteam@netfilter.org>:
450 4.2.0 <coreteam@netfilter.org>: Recipient address rejected:
Greylisted for 60 seconds: retry timeout exceeded
kadlec@netfilter.org
host mail.netfilter.org [217.70.188.207]
SMTP error from remote mail server after RCPT TO:<kadlec@netfilter.org>:
450 4.2.0 <kadlec@netfilter.org>: Recipient address rejected:
Greylisted for 60 seconds: retry timeout exceeded
pablo@netfilter.org
host mail.netfilter.org [217.70.188.207]
SMTP error from remote mail server after RCPT TO:<pablo@netfilter.org>:
450 4.2.0 <pablo@netfilter.org>: Recipient address rejected:
Greylisted for 60 seconds: retry timeout exceeded
linux-kernel@vger.kernel.org
host vger.kernel.org [23.128.96.18]
SMTP error from remote mail server after RCPT TO:<linux-kernel@vger.kernel.org>:
451 4.7.1 Hello [185.231.240.75], for recipient address <linux-kernel@vger.kernel.org> the policy analysis reported:
Greylisted, see http://postgrey.schweikert.ch/help/vger.kernel.org.html:
retry timeout exceeded
netfilter-devel@vger.kernel.org
host vger.kernel.org [23.128.96.18]
SMTP error from remote mail server after RCPT TO:<netfilter-devel@vger.kernel.org>:
451 4.7.1 Hello [185.231.240.75], for recipient address <netfilter-devel@vger.kernel.org> the policy analysis reported:
Greylisted, see http://postgrey.schweikert.ch/help/vger.kernel.org.html:
retry timeout exceeded
"
I'm expect it will be re-send in few hours.
othrevise I'll resend it once again via another mail server.

Thank you,
	Vasily Averin


