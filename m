Return-Path: <SRS0=5Db6=CU=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81A01C43461
	for <netfilter-devel@archiver.kernel.org>; Fri, 11 Sep 2020 16:29:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 37E9D206DB
	for <netfilter-devel@archiver.kernel.org>; Fri, 11 Sep 2020 16:29:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726606AbgIKQ3c (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 11 Sep 2020 12:29:32 -0400
Received: from www62.your-server.de ([213.133.104.62]:33744 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726530AbgIKQ2L (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 11 Sep 2020 12:28:11 -0400
Received: from sslproxy05.your-server.de ([78.46.172.2])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1kGltz-0007hM-Lg; Fri, 11 Sep 2020 18:27:55 +0200
Received: from [178.196.57.75] (helo=pc-9.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1kGltz-00085L-C2; Fri, 11 Sep 2020 18:27:55 +0200
Subject: Re: [PATCH nf-next v3 3/3] netfilter: Introduce egress hook
To:     =?UTF-8?Q?Laura_Garc=c3=ada_Li=c3=a9bana?= <nevola@gmail.com>
Cc:     Lukas Wunner <lukas@wunner.de>,
        John Fastabend <john.fastabend@gmail.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Netfilter Development Mailing list 
        <netfilter-devel@vger.kernel.org>, coreteam@netfilter.org,
        netdev@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Thomas Graf <tgraf@suug.ch>, David Miller <davem@davemloft.net>
References: <20200904162154.GA24295@wunner.de>
 <813edf35-6fcf-c569-aab7-4da654546d9d@iogearbox.net>
 <20200905052403.GA10306@wunner.de>
 <e8aecc2b-80cb-8ee5-8efe-7ae5c4eafc70@iogearbox.net>
 <CAF90-Whc3HL9x-7TJ7m3tZp10RNmQxFD=wdQUJLCaUajL2RqXg@mail.gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <8e991436-cb1c-1306-51ac-bb582bfaa8a7@iogearbox.net>
Date:   Fri, 11 Sep 2020 18:27:54 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <CAF90-Whc3HL9x-7TJ7m3tZp10RNmQxFD=wdQUJLCaUajL2RqXg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.4/25927/Fri Sep 11 15:58:29 2020)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On 9/11/20 9:42 AM, Laura García Liébana wrote:
> On Tue, Sep 8, 2020 at 2:55 PM Daniel Borkmann <daniel@iogearbox.net> wrote:
>> On 9/5/20 7:24 AM, Lukas Wunner wrote:
>>> On Fri, Sep 04, 2020 at 11:14:37PM +0200, Daniel Borkmann wrote:
>>>> On 9/4/20 6:21 PM, Lukas Wunner wrote:
>> [...]
>>>> The tc queueing layer which is below is not the tc egress hook; the
>>>> latter is for filtering/mangling/forwarding or helping the lower tc
>>>> queueing layer to classify.
>>>
>>> People want to apply netfilter rules on egress, so either we need an
>>> egress hook in the xmit path or we'd have to teach tc to filter and
>>> mangle based on netfilter rules.  The former seemed more straight-forward
>>> to me but I'm happy to pursue other directions.
>>
>> I would strongly prefer something where nf integrates into existing tc hook,
>> not only due to the hook reuse which would be better, but also to allow for a
>> more flexible interaction between tc/BPF use cases and nf, to name one
> 
> That sounds good but I'm afraid that it would take too much back and
> forth discussions. We'll really appreciate it if this small patch can
> be unblocked and then rethink the refactoring of ingress/egress hooks
> that you commented in another thread.

I'm not sure whether your comment was serious or not, but nope, this needs
to be addressed as mentioned as otherwise this use case would regress. It
is one thing for you wanting to remove tc / BPF from your application stack
as you call it, but not at the cost of breaking others.

Thank you,
Daniel
