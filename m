Return-Path: <SRS0=Oskt=YH=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5AC1C4CECE
	for <netfilter-devel@archiver.kernel.org>; Mon, 14 Oct 2019 13:57:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C3FBC2133F
	for <netfilter-devel@archiver.kernel.org>; Mon, 14 Oct 2019 13:57:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732317AbfJNN5B convert rfc822-to-8bit (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 14 Oct 2019 09:57:01 -0400
Received: from dispatchb-us1.ppe-hosted.com ([148.163.129.53]:54214 "EHLO
        dispatchb-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730477AbfJNN5B (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 14 Oct 2019 09:57:01 -0400
X-Virus-Scanned: Proofpoint Essentials engine
Received: from webmail.solarflare.com (webmail.solarflare.com [12.187.104.26])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us4.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 4492E4C0074;
        Mon, 14 Oct 2019 13:56:58 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ocex03.SolarFlarecom.com
 (10.20.40.36) with Microsoft SMTP Server (TLS) id 15.0.1395.4; Mon, 14 Oct
 2019 06:56:55 -0700
Subject: Re: [PATCH v2 nf-next] netfilter: add and use nf_hook_slow_list()
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>
CC:     <netfilter-devel@vger.kernel.org>
References: <20191010223037.10811-1-fw@strlen.de>
 <2d9864c9-95d2-02c2-b256-85a07c2b2232@solarflare.com>
 <20191010225433.GK25052@breakpoint.cc>
 <20191014110201.6gnd4ewsls7bsmry@salvia>
From:   Edward Cree <ecree@solarflare.com>
Message-ID: <4b19cd06-010c-bfcd-8a29-5b041fb9bc70@solarflare.com>
Date:   Mon, 14 Oct 2019 14:56:53 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20191014110201.6gnd4ewsls7bsmry@salvia>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Language: en-GB
X-Originating-IP: [10.17.20.203]
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1010-24974.005
X-TM-AS-Result: No-7.495600-4.000000-10
X-TMASE-MatchedRID: HXSqh3WYKfuHYS4ybQtcOh4ejJMDGBzF69aS+7/zbj+qvcIF1TcLYNiU
        K419XDm1bINQ5/egIOoZkOuFEoLztGwqGkf8xvfdW1M77Gh1ugYCn5QffvZFlR3RY4pGTCyHEoN
        4n3g9RrYldHjCZtJgv3UDKCdNHP2uYeOFZSwS7nSLzZSKyQypzFsP0tBwe3qDFBQ5IKls/A6sL4
        qRg1YXFlTbzoq5KvFKnkZQaFZBlMaiexRwf5KEhM36paW7ZnFofS0Ip2eEHny+qryzYw2E8LLn+
        0Vm71Lcq7rFUcuGp/EnRE+fI6etkqn/XlherE2UNSf9iCKZAs4uqd4AAeJ/GxTgSpQcKLmtmPiE
        wyTKewRtWVT/FwjEHJGNKvZY3ZLXMjwaCGlraS1H0v8MENAgBPAdfn5DyOPDXC6uJnc/p0Ssglk
        ltB8xdGpozkualSTDOvxFSbveVNw=
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--7.495600-4.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1010-24974.005
X-MDID: 1571061420-Me1ZBEw8Ws3E
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On 14/10/2019 12:02, Pablo Neira Ayuso wrote:
> On Fri, Oct 11, 2019 at 12:54:33AM +0200, Florian Westphal wrote:
>> Edward Cree <ecree@solarflare.com> wrote:
>>> On 10/10/2019 23:30, Florian Westphal wrote:
>>>> NF_HOOK_LIST now only works for ipv4 and ipv6, as those are the only
>>>> callers.
>>> ...
>>>> +
>>>> +     rcu_read_lock();
>>>> +     switch (pf) {
>>>> +     case NFPROTO_IPV4:
>>>> +             hook_head = rcu_dereference(net->nf.hooks_ipv4[hook]);
>>>> +             break;
>>>> +     case NFPROTO_IPV6:
>>>> +             hook_head = rcu_dereference(net->nf.hooks_ipv6[hook]);
>>>> +             break;
>>>> +     default:
>>>> +             WARN_ON_ONCE(1);
>>>> +             break;
>>>>       }
>>> Would it not make sense instead to abstract out the switch in nf_hook()
>>>  into, say, an inline function that could be called from here?  That
>>>  would satisfy SPOT and also save updating this code if new callers of
>>>  NF_HOOK_LIST are added in the future.
>> Its a matter of taste I guess.  I don't really like having all these
>> inline wrappers for wrappers wrapped in wrappers.
>>
>> Pablo, its up to you.  I could add __nf_hook_get_hook_head() or similar
>> and use that instead of open-coding.
> I'm fine with your approach, Florian. If new callers are added, this
> can be done later on.
Fine, in that case feel free to add my
Acked-by: Edward Cree <ecree@solarflare.com>
The information contained in this message is confidential and is intended for the addressee(s) only. If you have received this message in error, please notify the sender immediately and delete the message. Unless you are an addressee (or authorized to receive for an addressee), you may not use, copy or disclose to anyone this message or any information contained in this message. The unauthorized use, disclosure, copying or alteration of this message is strictly prohibited.
